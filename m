Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E458A4D4740
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 13:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241082AbiCJMvg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 07:51:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242129AbiCJMv3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 07:51:29 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5AD5148920
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 04:50:28 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id j2so10767006ybu.0
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 04:50:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=GU7El5i1xR6+DBzAKo71uTHDnFjNMoBDIOZdS+BtihY=;
        b=FT6ZVm02oGMQeagkFMV5RoWf4Mu0sD75kwX8qHZntCN5I5jb8exerkcKg1e5xWbN2M
         5AABtTHdY/MM73lLOhGJBzXD4phO83U9/HKMGL1bYpySitrdZxuK4UBfBPF46bVF6Ka4
         ppebJcTguo0sNKoabic4ivTJZ6uGNZaa+5JXmkeRZdgl99b8UTvVUY9wWg2i/XylLTY5
         sKcw2XIDxlnOymAYdR7j1a1b/lN9B0GtzZg5riTlQHU0ZmL6HhjyYJIBPY4RXDqxs8RM
         bgeDr7eYheV8tHbCiJHg3CJrMCMl1A+4xDRzxTRtSp88T8VlNQIqcyMi3kVpkHTb7Dc1
         JTQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=GU7El5i1xR6+DBzAKo71uTHDnFjNMoBDIOZdS+BtihY=;
        b=uG7+wgf+PYzQ/04Bo1LaPZkZvjOF2zntbVF44lTcRIlYPjpMDS/0qimDk2rZPTrCZ1
         YyJkzhdyxShiYV4uaiNLhz1aGS3Qet7dclodzbSeP0j3jCd7IdtnDfOCTUQ8oDZme8dh
         kMsEEAIBf66Ig7M3DY3f9JCqM1v6zUvl/RsPHxaLFS7YwUjDsaKgezwIoWEiLjtVbCFe
         EvV2aYzmZN5ac4zudnJpLz9dMJ/CWkXjY9tgDvIH9wQCeb/xIdBQKOD//CM4rahpjRiW
         UVFecKtuQIFxwEuW1hJjGjvRUm0zAAeRnJu/C0l4rjpC79y68YU9jw+Nz+K9BQoLyqvM
         zKbA==
X-Gm-Message-State: AOAM530KXGeEncIoN/A859/UQ+3RSnquFxIW819O24zLth9En/5h9NMX
        xnU9DCFbYVE1aUqd3s382KKItJLHT4gWodiyAVj42w==
X-Google-Smtp-Source: ABdhPJyyd3lVkcsapnO2xQ8msUOO2zRprrKSiu24QB5+vnAS9YgNgqOAZ+pq1/J1xsHwAC7qD+KdRTh2MpiJVj1TM6U=
X-Received: by 2002:a25:9846:0:b0:61a:3deb:4d39 with SMTP id
 k6-20020a259846000000b0061a3deb4d39mr3721216ybo.537.1646916627719; Thu, 10
 Mar 2022 04:50:27 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 10 Mar 2022 18:20:16 +0530
Message-ID: <CA+G9fYtEAa1C7PQGKXxMdeQPBxQJD=vre8BU-i+GzuDpXr9DyA@mail.gmail.com>
Subject: stable-rc queue/4.19 x86 and i386 builds failed
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     linux-stable <stable@vger.kernel.org>, lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc queue/4.19 x86 and i386 gcc-11 builds failed due to following
multiple warnings and errors.

metadata:
    git_describe: v4.19.233-22-g83c76d59eabe
    git_repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc-queues
    git_sha: 83c76d59eabe7545b86485336a9aeb0f652666be
    git_short_log: 83c76d59eabe (\ARM: fix build warning in proc-v7-bugs.c\)
    target_arch: x86_64
    toolchain: gcc-11


make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/2/build ARCH=x86_64
CROSS_COMPILE=x86_64-linux-gnu- 'CC=sccache x86_64-linux-gnu-gcc'
'HOSTCC=sccache gcc'
arch/x86/entry/entry_64.S: Assembler messages:
arch/x86/entry/entry_64.S:1738: Warning: no instruction mnemonic
suffix given and no register operands; using default for `sysret'
arch/x86/kernel/cpu/bugs.c: In function 'spectre_v2_select_mitigation':
arch/x86/kernel/cpu/bugs.c:973:41: error: implicit declaration of
function 'unprivileged_ebpf_enabled'
[-Werror=implicit-function-declaration]
  973 |         if (mode == SPECTRE_V2_EIBRS && unprivileged_ebpf_enabled())
      |                                         ^~~~~~~~~~~~~~~~~~~~~~~~~
cc1: some warnings being treated as errors


drivers/crypto/ccp/sp-platform.c:37:34: warning: array 'sp_of_match'
assumed to have one element
   37 | static const struct of_device_id sp_of_match[];
      |                                  ^~~~~~~~~~~
drivers/gpu/drm/i915/intel_dp.c: In function 'intel_dp_check_mst_status':
drivers/gpu/drm/i915/intel_dp.c:4129:30: warning:
'drm_dp_channel_eq_ok' reading 6 bytes from a region of size 4
[-Wstringop-overread]
 4129 |                             !drm_dp_channel_eq_ok(&esi[10],
intel_dp->lane_count)) {
      |
^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/gpu/drm/i915/intel_dp.c:4129:30: note: referencing argument 1
of type 'const u8 *' {aka 'const unsigned char *'}
In file included from drivers/gpu/drm/i915/intel_dp.c:39:
include/drm/drm_dp_helper.h:954:6: note: in a call to function
'drm_dp_channel_eq_ok'
  954 | bool drm_dp_channel_eq_ok(const u8 link_status[DP_LINK_STATUS_SIZE],
      |      ^~~~~~~~~~~~~~~~~~~~
make[1]: Target '_all' not remade because of errors.


Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

build link [1] & [2]


--
Linaro LKFT
https://lkft.linaro.org

[1] https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc-queues/-/jobs/2187396920
[2] https://builds.tuxbuild.com/26C6OfFPTfEBORLviGXIOuwmzR2/
