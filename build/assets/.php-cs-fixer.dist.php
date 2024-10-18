<?php

declare(strict_types=1);

use PhpCsFixer\Config;
use PhpCsFixer\Finder;

$finder = (new Finder())
    ->in(__DIR__.'/src')
    ->in(__DIR__.'/migrations')
    ->in(__DIR__.'/tests')
    ->exclude('var')
;

return (new Config())
    ->setRules([
        '@PhpCsFixer' => true,
        '@PhpCsFixer:risky' => true,
        '@DoctrineAnnotation' => true,
        'yoda_style' => ['equal' => false, 'identical' => false, 'less_and_greater' => false],
        'phpdoc_summary' => false,
        'declare_strict_types' => true,
        'fopen_flags' => false,
        'php_unit_strict' => false,
        'php_unit_internal_class' => false,
        'php_unit_test_class_requires_covers' => false,
        'heredoc_to_nowdoc' => false,
        'string_implicit_backslashes' => false,
        'phpdoc_types_order' => [
            'null_adjustment' => 'always_last',
        ],
        'concat_space' => ['spacing' => 'one'],
        'increment_style' => false,
        'phpdoc_align' => ['align' => 'left'],
    ])
    ->setFinder($finder)
;
