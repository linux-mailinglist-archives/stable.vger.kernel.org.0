Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C46FF581501
	for <lists+stable@lfdr.de>; Tue, 26 Jul 2022 16:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238296AbiGZOU4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jul 2022 10:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239001AbiGZOUz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jul 2022 10:20:55 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 992EB27B10
        for <stable@vger.kernel.org>; Tue, 26 Jul 2022 07:20:53 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id z18so5580950edb.10
        for <stable@vger.kernel.org>; Tue, 26 Jul 2022 07:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=E3zT2cWFCHTaCeSnI9tSoNjGmPrhcL5ypVm0hjHFp+Q=;
        b=WQc/LRVjJts29bgnIWMoj7EnG5c1QoYQK0vP5D5bmhyxMm1I+FTAg1Z4fK6x6bXyQC
         eXLSLxxwwOuFB1CkzzdQzpz2XbzCv2l83GsTfQwx62eDaxHODI0wFFAXXOX5eggZZU0B
         vRON2TAbE42XeyDFeQ73COS11Tq0qJzm16ZeoKP3W+Ag2e7dxXx6XW0rona5VD5sSEMv
         SdvrhxPGHaHii2kFg2N2Yuojf50FGCSQAegtZSwfRsOadE9Vfr6raCszuQYDRVa3R/vn
         Q+4g8oKr1u8LV0jMDReHpIFLEjod6QGWp0uYUpGBdZUteZT2ErGP3xdtmt0ZR22C/0HT
         6q8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=E3zT2cWFCHTaCeSnI9tSoNjGmPrhcL5ypVm0hjHFp+Q=;
        b=Ev2DhPg4gaO8OVWeo+Cc7jmnrSu7YSltbq+1xZUSeNBvQnNhRIckWgsQaYsOI05Vkq
         C/VYdPKWA5l/Iz6IIxR3pVqhU23tNzRPT4p/HExwWoS2QhKVp+d9z13vPXQ3zjeAtk77
         9/QR+MZAGraxxH9Ov6IjyCbusq8PxqMBXncLGp4gKYT9lInYKlJPkOxZoUfMvunL9lFK
         tpxyiacL6gqP3uH0Onlf9B+6/SR7z8C2ZG5tMFU9p44VytHPAt930OwL5jaOR1ng8x53
         r0ZHkO09oJuVjeAKxIcqWbeDL63KX2qCXUyOaegRvU299Z9bUNTsP6pDG8AgBEK9TPR4
         boSg==
X-Gm-Message-State: AJIora/EPAOZ5KIHrMvTSHnKcknbfhwHPCVK+T/EEnkitehQoiFOXaE8
        rQGyxeyqcySf6lkR9AE2Hf6E6iATd1VsBhHpyrgD0Q==
X-Google-Smtp-Source: AGRyM1uPiHz9r78dkOMkMS7A40TQlp0htLCjU+g7vKNWtDQEZFtqP7rw3kimJdOVXxtmSiTxWS2YaUyNOrqrwQoAZr8=
X-Received: by 2002:aa7:cb87:0:b0:43b:e650:6036 with SMTP id
 r7-20020aa7cb87000000b0043be6506036mr14304550edt.350.1658845251277; Tue, 26
 Jul 2022 07:20:51 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 26 Jul 2022 19:50:40 +0530
Message-ID: <CA+G9fYuTWEUmMWgSC=SoVdf7YN2pochkxPqj2iXH7DUaA6n1=A@mail.gmail.com>
Subject: stable: queue/5.15: arch/x86/mm/extable.c:200:7: error: duplicate
 case value '12'
To:     Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-stable <stable@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

x86 and i386 clang builds failed due this build warnings / errors on
stable-rc queue/5.15

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

git_ref: queue/5.15
git_describe: v5.15.56-266-gda50e215b6b1
git_repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc-queues
Build:   v5.15.56-266-gda50e215b6b1
Details: https://qa-reports.linaro.org/lkft/linux-stable-rc-queues-queue_5.15/build/v5.15.56-266-gda50e215b6b1

Steps to reproduce:
-------------------
tuxmake --runtime podman \
        --target-arch x86_64 \
        --toolchain clang-14 \
        --kconfig
https://builds.tuxbuild.com/2CT2NoyYwejQUXoBcT1lYTHbhtT/config \
          LLVM=1 \
          LLVM_IAS=1


Build error log:
-----------------
builds/linux/arch/x86/include/asm/extable_fixup_types.h:49:9: warning:
'EX_TYPE_DEFAULT_MCE_SAFE' macro redefined [-Wmacro-redefined]
#define EX_TYPE_DEFAULT_MCE_SAFE        12
        ^
arch/x86/include/asm/extable_fixup_types.h:42:9: note: previous
definition is here
#define EX_TYPE_DEFAULT_MCE_SAFE        14
        ^
arch/x86/include/asm/extable_fixup_types.h:50:9: warning:
'EX_TYPE_FAULT_MCE_SAFE' macro redefined [-Wmacro-redefined]
#define EX_TYPE_FAULT_MCE_SAFE          13
        ^
arch/x86/include/asm/extable_fixup_types.h:43:9: note: previous
definition is here
#define EX_TYPE_FAULT_MCE_SAFE          15
        ^
arch/x86/mm/extable.c:200:7: error: duplicate case value '12'
        case EX_TYPE_WRMSR_IN_MCE:
             ^
arch/x86/include/asm/extable_fixup_types.h:40:31: note: expanded from
macro 'EX_TYPE_WRMSR_IN_MCE'
#define EX_TYPE_WRMSR_IN_MCE            12
                                        ^
arch/x86/mm/extable.c:177:7: note: previous case defined here
        case EX_TYPE_DEFAULT_MCE_SAFE:
             ^
arch/x86/include/asm/extable_fixup_types.h:49:34: note: expanded from
macro 'EX_TYPE_DEFAULT_MCE_SAFE'
#define EX_TYPE_DEFAULT_MCE_SAFE        12
                                        ^
arch/x86/mm/extable.c:203:7: error: duplicate case value '13'
        case EX_TYPE_RDMSR_IN_MCE:
             ^
arch/x86/include/asm/extable_fixup_types.h:41:31: note: expanded from
macro 'EX_TYPE_RDMSR_IN_MCE'
#define EX_TYPE_RDMSR_IN_MCE            13
                                        ^
arch/x86/mm/extable.c:180:7: note: previous case defined here
        case EX_TYPE_FAULT_MCE_SAFE:
             ^
arch/x86/include/asm/extable_fixup_types.h:50:33: note: expanded from
macro 'EX_TYPE_FAULT_MCE_SAFE'
#define EX_TYPE_FAULT_MCE_SAFE          13
                                        ^
2 warnings and 2 errors generated.
make[3]: *** [scripts/Makefile.build:289: arch/x86/mm/extable.o] Error 1

Build link:
https://builds.tuxbuild.com/2CT2NoyYwejQUXoBcT1lYTHbhtT/



--
Linaro LKFT
https://lkft.linaro.org
