Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 200A14CE773
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 23:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbiCEWnX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Mar 2022 17:43:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232754AbiCEWnX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Mar 2022 17:43:23 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA293C716
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 14:42:29 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id ay5so10765560plb.1
        for <stable@vger.kernel.org>; Sat, 05 Mar 2022 14:42:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=oMmFREaBLhrS9qGRXj3prv8f1uIjm/egVFYFlI7ppA0=;
        b=xCFfjtJqf9vAg4lOT10KCdzaU8k7nsZXwFgjZam1V7JC1AnW2fo886pkkY18gMbLGh
         0I3OEO98grZ5umVip5PKnlWcb0OQ+zgDDYVOhnwVVM1iMiHYG7qVlYPQZdoFcD4HU57V
         JAKvKUFEvd76M/v3LOtuNrnZ3k3vO1j+0PmbTw5qYHSkYavHH3vt55h1yAO6FGHb0VeP
         VMEO1hwj5JR1u/VKHFRqDDqR5gONL9XH09s4QVmT+EStHdhHUrhgnfXt6qj+z+HJFtIK
         qq9/gCIZ55w18eYhQKK6qscKiy8cQrX5JNSrDOx8FWonQHMwOAK7GsyIGxU6aBP1h+dO
         zIfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=oMmFREaBLhrS9qGRXj3prv8f1uIjm/egVFYFlI7ppA0=;
        b=NrS7DVLFxyKtDpsYiVqOtjkQQd5bPnUGha42WiRW2MnULPPnugaIzd4Ebycs1jaq0c
         Tw2YN/anjgbCp0n3egeuLkMjI2Px5W+ttT7O7S/Yunfz0V+jDLdQwgL6Gy/1+MGHgrgA
         60Be3O8Yymg76r2v1WdlAwHnlHk1Hi/Uz8AbO/vuVMqXCIewgT5zRTc3NNaO6mLH64As
         5Q3k0/9tGSwd3NhLgDUT35Wt5ZQu9PuJ5rgpGnrQF+T+3T91cNzLVONFN6Xl0YNU3Umj
         1xQMPQ3pqKRBEsDpuKEJWHmp0l7tWxuOBkM8rB4/LDKOFKDvVNgmj6qtiiEAsrs/ODfZ
         lUiw==
X-Gm-Message-State: AOAM533QQCtWC0CQMG75newjViDAQwbR/rACAChpCB9YImD8SfgGjv5B
        GQ6NuD48BqiGVW68tgRXgDj334PO32sTe0nsuxU=
X-Google-Smtp-Source: ABdhPJzm6ncVzKZK3kx2H52KwC6UkVBBEXyqt0YHhYdVM/kXrLaDkTcV1WGXRTgADTrta3I/pMGj2g==
X-Received: by 2002:a17:90b:250f:b0:1b8:f257:c39 with SMTP id ns15-20020a17090b250f00b001b8f2570c39mr5558706pjb.135.1646520146902;
        Sat, 05 Mar 2022 14:42:26 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f20-20020a056a001ad400b004f6e8f8f90bsm1174338pfv.109.2022.03.05.14.42.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Mar 2022 14:42:26 -0800 (PST)
Message-ID: <6223e752.1c69fb81.e8d1f.312c@mx.google.com>
Date:   Sat, 05 Mar 2022 14:42:26 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.103-94-g8a21dc3cefb9
Subject: stable-rc/queue/5.10 build: 183 builds: 45 failed, 138 passed,
 1170 errors, 699 warnings (v5.10.103-94-g8a21dc3cefb9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 build: 183 builds: 45 failed, 138 passed, 1170 errors,=
 699 warnings (v5.10.103-94-g8a21dc3cefb9)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F5.1=
0/kernel/v5.10.103-94-g8a21dc3cefb9/

Tree: stable-rc
Branch: queue/5.10
Git Describe: v5.10.103-94-g8a21dc3cefb9
Git Commit: 8a21dc3cefb97152bbb9185545cfbc4f7601f92c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 7 unique architectures

Build Failures Detected:

arm64:
    defconfig: (gcc-10) FAIL
    defconfig+arm64-chromebook: (gcc-10) FAIL

arm:
    at91_dt_defconfig: (gcc-10) FAIL
    bcm2835_defconfig: (gcc-10) FAIL
    eseries_pxa_defconfig: (gcc-10) FAIL
    exynos_defconfig: (gcc-10) FAIL
    gemini_defconfig: (gcc-10) FAIL
    imx_v6_v7_defconfig: (gcc-10) FAIL
    mini2440_defconfig: (gcc-10) FAIL
    multi_v5_defconfig: (gcc-10) FAIL
    multi_v7_defconfig: (gcc-10) FAIL
    mvebu_v5_defconfig: (gcc-10) FAIL
    omap2plus_defconfig: (gcc-10) FAIL
    pxa_defconfig: (gcc-10) FAIL
    qcom_defconfig: (gcc-10) FAIL
    rpc_defconfig: (gcc-10) FAIL
    s3c2410_defconfig: (gcc-10) FAIL
    s5pv210_defconfig: (gcc-10) FAIL
    sama5_defconfig: (gcc-10) FAIL
    tegra_defconfig: (gcc-10) FAIL
    u8500_defconfig: (gcc-10) FAIL
    zeus_defconfig: (gcc-10) FAIL

i386:
    i386_defconfig: (gcc-10) FAIL

mips:
    ar7_defconfig: (gcc-10) FAIL
    ath25_defconfig: (gcc-10) FAIL
    ath79_defconfig: (gcc-10) FAIL
    bcm47xx_defconfig: (gcc-10) FAIL
    bcm63xx_defconfig: (gcc-10) FAIL
    bmips_be_defconfig: (gcc-10) FAIL
    bmips_stb_defconfig: (gcc-10) FAIL
    db1xxx_defconfig: (gcc-10) FAIL
    gcw0_defconfig: (gcc-10) FAIL
    gpr_defconfig: (gcc-10) FAIL
    ip27_defconfig: (gcc-10) FAIL
    ip28_defconfig: (gcc-10) FAIL
    lemote2f_defconfig: (gcc-10) FAIL
    loongson3_defconfig: (gcc-10) FAIL
    malta_defconfig: (gcc-10) FAIL
    malta_kvm_defconfig: (gcc-10) FAIL
    malta_kvm_guest_defconfig: (gcc-10) FAIL
    maltaup_xpa_defconfig: (gcc-10) FAIL
    pistachio_defconfig: (gcc-10) FAIL
    sb1250_swarm_defconfig: (gcc-10) FAIL

x86_64:
    x86_64_defconfig: (gcc-10) FAIL
    x86_64_defconfig+x86-chromebook: (gcc-10) FAIL

Errors and Warnings Detected:

arc:

arm64:
    defconfig (gcc-10): 28 errors, 21 warnings
    defconfig+arm64-chromebook (gcc-10): 28 errors, 21 warnings

arm:
    at91_dt_defconfig (gcc-10): 28 errors, 16 warnings
    bcm2835_defconfig (gcc-10): 28 errors, 16 warnings
    eseries_pxa_defconfig (gcc-10): 28 errors, 16 warnings
    exynos_defconfig (gcc-10): 28 errors, 16 warnings
    gemini_defconfig (gcc-10): 26 errors, 17 warnings
    imx_v6_v7_defconfig (gcc-10): 28 errors, 16 warnings
    mini2440_defconfig (gcc-10): 28 errors, 16 warnings
    multi_v5_defconfig (gcc-10): 28 errors, 16 warnings
    multi_v7_defconfig (gcc-10): 28 errors, 16 warnings
    mvebu_v5_defconfig (gcc-10): 28 errors, 16 warnings
    omap2plus_defconfig (gcc-10): 28 errors, 16 warnings
    pxa_defconfig (gcc-10): 28 errors, 16 warnings
    qcom_defconfig (gcc-10): 28 errors, 16 warnings
    rpc_defconfig (gcc-10): 4 errors
    s3c2410_defconfig (gcc-10): 28 errors, 16 warnings
    s5pv210_defconfig (gcc-10): 28 errors, 16 warnings
    sama5_defconfig (gcc-10): 28 errors, 16 warnings
    tegra_defconfig (gcc-10): 28 errors, 16 warnings
    u8500_defconfig (gcc-10): 28 errors, 16 warnings
    zeus_defconfig (gcc-10): 28 errors, 16 warnings

i386:
    i386_defconfig (gcc-10): 28 errors, 21 warnings

mips:
    32r2el_defconfig (gcc-10): 1 warning
    ar7_defconfig (gcc-10): 28 errors, 16 warnings
    ath25_defconfig (gcc-10): 28 errors, 14 warnings
    ath79_defconfig (gcc-10): 28 errors, 14 warnings
    bcm47xx_defconfig (gcc-10): 28 errors, 14 warnings
    bcm63xx_defconfig (gcc-10): 26 errors, 17 warnings
    bmips_be_defconfig (gcc-10): 26 errors, 17 warnings
    bmips_stb_defconfig (gcc-10): 26 errors, 17 warnings
    db1xxx_defconfig (gcc-10): 26 errors, 17 warnings
    decstation_64_defconfig (gcc-10): 1 warning
    decstation_defconfig (gcc-10): 1 warning
    decstation_r4k_defconfig (gcc-10): 1 warning
    gcw0_defconfig (gcc-10): 28 errors, 16 warnings
    gpr_defconfig (gcc-10): 28 errors, 16 warnings
    lemote2f_defconfig (gcc-10): 28 errors, 16 warnings
    loongson3_defconfig (gcc-10): 28 errors, 16 warnings
    malta_defconfig (gcc-10): 28 errors, 14 warnings
    malta_kvm_defconfig (gcc-10): 28 errors, 14 warnings
    malta_kvm_guest_defconfig (gcc-10): 28 errors, 16 warnings
    maltaup_xpa_defconfig (gcc-10): 28 errors, 14 warnings
    pistachio_defconfig (gcc-10): 28 errors, 16 warnings
    rm200_defconfig (gcc-10): 1 warning
    sb1250_swarm_defconfig (gcc-10): 28 errors, 16 warnings

riscv:
    rv32_defconfig (gcc-10): 4 warnings

x86_64:
    x86_64_defconfig (gcc-10): 28 errors, 21 warnings
    x86_64_defconfig+x86-chromebook (gcc-10): 28 errors, 21 warnings

Errors summary:

    42   net/mac80211/mlme.c:5156:12: error: invalid storage class for func=
tion =E2=80=98ieee80211_prep_connection=E2=80=99
    42   net/mac80211/mlme.c:5122:13: error: invalid storage class for func=
tion =E2=80=98ieee80211_get_dtim=E2=80=99
    42   net/mac80211/mlme.c:4953:12: error: invalid storage class for func=
tion =E2=80=98ieee80211_prep_channel=E2=80=99
    42   net/mac80211/mlme.c:4892:1: error: invalid storage class for funct=
ion =E2=80=98ieee80211_verify_sta_he_mcs_support=E2=80=99
    42   net/mac80211/mlme.c:4847:11: error: invalid storage class for func=
tion =E2=80=98ieee80211_ht_vht_rx_chains=E2=80=99
    42   net/mac80211/mlme.c:4697:13: error: invalid storage class for func=
tion =E2=80=98ieee80211_restart_sta_timer=E2=80=99
    42   net/mac80211/mlme.c:4688:13: error: invalid storage class for func=
tion =E2=80=98ieee80211_sta_monitor_work=E2=80=99
    42   net/mac80211/mlme.c:4656:13: error: invalid storage class for func=
tion =E2=80=98ieee80211_sta_conn_mon_timer=E2=80=99
    42   net/mac80211/mlme.c:4639:13: error: invalid storage class for func=
tion =E2=80=98ieee80211_sta_bcn_mon_timer=E2=80=99
    42   net/mac80211/mlme.c:4439:12: error: invalid storage class for func=
tion =E2=80=98ieee80211_do_assoc=E2=80=99
    42   net/mac80211/mlme.c:4364:12: error: invalid storage class for func=
tion =E2=80=98ieee80211_auth=E2=80=99
    42   net/mac80211/mlme.c:4352:13: error: invalid storage class for func=
tion =E2=80=98ieee80211_sta_connection_lost=E2=80=99
    42   net/mac80211/mlme.c:4344:13: error: invalid storage class for func=
tion =E2=80=98ieee80211_sta_timer=E2=80=99
    42   net/mac80211/mlme.c:3951:13: error: invalid storage class for func=
tion =E2=80=98ieee80211_rx_mgmt_beacon=E2=80=99
    42   net/mac80211/mlme.c:3941:13: error: invalid storage class for func=
tion =E2=80=98ieee80211_rx_our_beacon=E2=80=99
    42   net/mac80211/mlme.c:3845:13: error: invalid storage class for func=
tion =E2=80=98ieee80211_handle_beacon_sig=E2=80=99
    42   net/mac80211/mlme.c:3780:13: error: invalid storage class for func=
tion =E2=80=98ieee80211_rx_mgmt_probe_resp=E2=80=99
    42   net/mac80211/mlme.c:3757:13: error: invalid storage class for func=
tion =E2=80=98ieee80211_rx_bss_info=E2=80=99
    42   net/mac80211/mlme.c:3648:13: error: invalid storage class for func=
tion =E2=80=98ieee80211_rx_mgmt_assoc_resp=E2=80=99
    42   net/mac80211/mlme.c:3271:13: error: invalid storage class for func=
tion =E2=80=98ieee80211_assoc_success=E2=80=99
    42   net/mac80211/mlme.c:3258:12: error: invalid storage class for func=
tion =E2=80=98ieee80211_recalc_twt_req=E2=80=99
    42   net/mac80211/mlme.c:3245:13: error: invalid storage class for func=
tion =E2=80=98ieee80211_twt_req_supported=E2=80=99
    42   net/mac80211/mlme.c:3195:13: error: invalid storage class for func=
tion =E2=80=98ieee80211_get_rates=E2=80=99
    42   net/mac80211/mlme.c:3164:13: error: invalid storage class for func=
tion =E2=80=98ieee80211_rx_mgmt_disassoc=E2=80=99
    42   net/mac80211/mlme.c:3116:13: error: invalid storage class for func=
tion =E2=80=98ieee80211_rx_mgmt_deauth=E2=80=99
    37   net/mac80211/mlme.c:5957:15: error: non-static declaration of =E2=
=80=98ieee80211_cqm_beacon_loss_notify=E2=80=99 follows static declaration
    37   net/mac80211/mlme.c:5947:15: error: non-static declaration of =E2=
=80=98ieee80211_cqm_rssi_notify=E2=80=99 follows static declaration
    32   include/linux/export.h:67:22: error: expected declaration or state=
ment at end of input
    10   net/mac80211/mlme.c:5957:1: error: expected declaration or stateme=
nt at end of input
    2    arm-linux-gnueabihf-gcc: error: unrecognized -march target: armv3m
    2    arm-linux-gnueabihf-gcc: error: missing argument to =E2=80=98-marc=
h=3D=E2=80=99

Warnings summary:

    64   include/linux/export.h:67:2: warning: ISO C90 forbids mixed declar=
ations and code [-Wdeclaration-after-statement]
    42   net/mac80211/mlme.c:5898:6: warning: =E2=80=98ieee80211_mgd_stop=
=E2=80=99 defined but not used [-Wunused-function]
    42   net/mac80211/mlme.c:5867:5: warning: =E2=80=98ieee80211_mgd_disass=
oc=E2=80=99 defined but not used [-Wunused-function]
    42   net/mac80211/mlme.c:5803:5: warning: =E2=80=98ieee80211_mgd_deauth=
=E2=80=99 defined but not used [-Wunused-function]
    42   net/mac80211/mlme.c:5480:5: warning: =E2=80=98ieee80211_mgd_assoc=
=E2=80=99 defined but not used [-Wunused-function]
    42   net/mac80211/mlme.c:5330:5: warning: =E2=80=98ieee80211_mgd_auth=
=E2=80=99 defined but not used [-Wunused-function]
    42   net/mac80211/mlme.c:4834:6: warning: =E2=80=98ieee80211_mlme_notif=
y_scan_completed=E2=80=99 defined but not used [-Wunused-function]
    42   net/mac80211/mlme.c:4795:6: warning: =E2=80=98ieee80211_sta_setup_=
sdata=E2=80=99 defined but not used [-Wunused-function]
    42   net/mac80211/mlme.c:4492:6: warning: =E2=80=98ieee80211_sta_work=
=E2=80=99 defined but not used [-Wunused-function]
    42   net/mac80211/mlme.c:4480:6: warning: =E2=80=98ieee80211_mgd_conn_t=
x_status=E2=80=99 defined but not used [-Wunused-function]
    42   net/mac80211/mlme.c:4254:6: warning: =E2=80=98ieee80211_sta_rx_que=
ued_mgmt=E2=80=99 defined but not used [-Wunused-function]
    42   net/mac80211/mlme.c:4234:6: warning: =E2=80=98ieee80211_sta_rx_que=
ued_ext=E2=80=99 defined but not used [-Wunused-function]
    42   net/mac80211/mlme.c:3062:1: warning: ISO C90 forbids mixed declara=
tions and code [-Wdeclaration-after-statement]
    36   net/mac80211/mlme.c:4770:6: warning: =E2=80=98ieee80211_sta_restar=
t=E2=80=99 defined but not used [-Wunused-function]
    36   net/mac80211/mlme.c:4710:6: warning: =E2=80=98ieee80211_mgd_quiesc=
e=E2=80=99 defined but not used [-Wunused-function]
    10   net/mac80211/mlme.c:5949:1: warning: ISO C90 forbids mixed declara=
tions and code [-Wdeclaration-after-statement]
    10   include/linux/compiler.h:225:2: warning: ISO C90 forbids mixed dec=
larations and code [-Wdeclaration-after-statement]
    5    net/mac80211/mlme.c:5949:6: warning: =E2=80=98ieee80211_cqm_beacon=
_loss_notify=E2=80=99 defined but not used [-Wunused-function]
    5    net/mac80211/mlme.c:5936:6: warning: =E2=80=98ieee80211_cqm_rssi_n=
otify=E2=80=99 defined but not used [-Wunused-function]
    5    include/linux/export.h:99:20: warning: unused variable =E2=80=98__=
kstrtab_ieee80211_cqm_rssi_notify=E2=80=99 [-Wunused-variable]
    5    include/linux/export.h:99:20: warning: unused variable =E2=80=98__=
kstrtab_ieee80211_cqm_beacon_loss_notify=E2=80=99 [-Wunused-variable]
    5    include/linux/export.h:100:20: warning: unused variable =E2=80=98_=
_kstrtabns_ieee80211_cqm_rssi_notify=E2=80=99 [-Wunused-variable]
    5    include/linux/export.h:100:20: warning: unused variable =E2=80=98_=
_kstrtabns_ieee80211_cqm_beacon_loss_notify=E2=80=99 [-Wunused-variable]
    3    kernel/rcu/tasks.h:707:13: warning: =E2=80=98show_rcu_tasks_rude_g=
p_kthread=E2=80=99 defined but not used [-Wunused-function]
    2    <stdin>:830:2: warning: #warning syscall fstat64 not implemented [=
-Wcpp]
    2    <stdin>:1127:2: warning: #warning syscall fstatat64 not implemente=
d [-Wcpp]
    1    drivers/block/paride/bpck.c:32: warning: "PC" redefined
    1    WARNING: modpost: Symbol info of vmlinux is missing. Unresolved sy=
mbol check will be entirely skipped.

Section mismatches summary:

    1    WARNING: modpost: vmlinux.o(.text+0xd040): Section mismatch in ref=
erence from the function __arm_ioremap_pfn_caller() to the function .memini=
t.text:memblock_is_map_memory()
    1    WARNING: modpost: vmlinux.o(.text+0xce9c): Section mismatch in ref=
erence from the function __arm_ioremap_pfn_caller() to the function .memini=
t.text:memblock_is_map_memory()
    1    WARNING: modpost: vmlinux.o(.text+0xcda4): Section mismatch in ref=
erence from the function __arm_ioremap_pfn_caller() to the function .memini=
t.text:memblock_is_map_memory()
    1    WARNING: modpost: vmlinux.o(.text+0xcd38): Section mismatch in ref=
erence from the function __arm_ioremap_pfn_caller() to the function .memini=
t.text:memblock_is_map_memory()
    1    WARNING: modpost: vmlinux.o(.text+0xcb84): Section mismatch in ref=
erence from the function __arm_ioremap_pfn_caller() to the function .memini=
t.text:memblock_is_map_memory()
    1    WARNING: modpost: vmlinux.o(.text+0xcb74): Section mismatch in ref=
erence from the function __arm_ioremap_pfn_caller() to the function .memini=
t.text:memblock_is_map_memory()
    1    WARNING: modpost: vmlinux.o(.text+0xcb6c): Section mismatch in ref=
erence from the function __arm_ioremap_pfn_caller() to the function .memini=
t.text:memblock_is_map_memory()
    1    WARNING: modpost: vmlinux.o(.text+0xcb4c): Section mismatch in ref=
erence from the function __arm_ioremap_pfn_caller() to the function .memini=
t.text:memblock_is_map_memory()
    1    WARNING: modpost: vmlinux.o(.text+0xcaa8): Section mismatch in ref=
erence from the function __arm_ioremap_pfn_caller() to the function .memini=
t.text:memblock_is_map_memory()
    1    WARNING: modpost: vmlinux.o(.text+0xc8ec): Section mismatch in ref=
erence from the function __arm_ioremap_pfn_caller() to the function .memini=
t.text:memblock_is_map_memory()
    1    WARNING: modpost: vmlinux.o(.text+0xb904): Section mismatch in ref=
erence from the function __arm_ioremap_pfn_caller() to the function .memini=
t.text:memblock_is_map_memory()
    1    WARNING: modpost: vmlinux.o(.text+0x8054): Section mismatch in ref=
erence from the function __arm_ioremap_pfn_caller() to the function .memini=
t.text:memblock_is_map_memory()
    1    WARNING: modpost: vmlinux.o(.text+0x7670): Section mismatch in ref=
erence from the function __arm_ioremap_pfn_caller() to the function .memini=
t.text:memblock_is_map_memory()

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
32r2el_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    WARNING: modpost: Symbol info of vmlinux is missing. Unresolved symbol =
check will be entirely skipped.

---------------------------------------------------------------------------=
-----
allnoconfig (x86_64, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (i386, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
am200epdkit_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
ar7_defconfig (mips, gcc-10) =E2=80=94 FAIL, 28 errors, 16 warnings, 0 sect=
ion mismatches

Errors:
    net/mac80211/mlme.c:3116:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_deauth=E2=80=99
    net/mac80211/mlme.c:3164:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_disassoc=E2=80=99
    net/mac80211/mlme.c:3195:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_rates=E2=80=99
    net/mac80211/mlme.c:3245:13: error: invalid storage class for function =
=E2=80=98ieee80211_twt_req_supported=E2=80=99
    net/mac80211/mlme.c:3258:12: error: invalid storage class for function =
=E2=80=98ieee80211_recalc_twt_req=E2=80=99
    net/mac80211/mlme.c:3271:13: error: invalid storage class for function =
=E2=80=98ieee80211_assoc_success=E2=80=99
    net/mac80211/mlme.c:3648:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_assoc_resp=E2=80=99
    net/mac80211/mlme.c:3757:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_bss_info=E2=80=99
    net/mac80211/mlme.c:3780:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_probe_resp=E2=80=99
    net/mac80211/mlme.c:3845:13: error: invalid storage class for function =
=E2=80=98ieee80211_handle_beacon_sig=E2=80=99
    net/mac80211/mlme.c:3941:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_our_beacon=E2=80=99
    net/mac80211/mlme.c:3951:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_beacon=E2=80=99
    net/mac80211/mlme.c:4344:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_timer=E2=80=99
    net/mac80211/mlme.c:4352:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_connection_lost=E2=80=99
    net/mac80211/mlme.c:4364:12: error: invalid storage class for function =
=E2=80=98ieee80211_auth=E2=80=99
    net/mac80211/mlme.c:4439:12: error: invalid storage class for function =
=E2=80=98ieee80211_do_assoc=E2=80=99
    net/mac80211/mlme.c:4639:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_bcn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4656:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_conn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4688:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_monitor_work=E2=80=99
    net/mac80211/mlme.c:4697:13: error: invalid storage class for function =
=E2=80=98ieee80211_restart_sta_timer=E2=80=99
    net/mac80211/mlme.c:4847:11: error: invalid storage class for function =
=E2=80=98ieee80211_ht_vht_rx_chains=E2=80=99
    net/mac80211/mlme.c:4892:1: error: invalid storage class for function =
=E2=80=98ieee80211_verify_sta_he_mcs_support=E2=80=99
    net/mac80211/mlme.c:4953:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_channel=E2=80=99
    net/mac80211/mlme.c:5122:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_dtim=E2=80=99
    net/mac80211/mlme.c:5156:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_connection=E2=80=99
    net/mac80211/mlme.c:5947:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_rssi_notify=E2=80=99 follows static declaration
    net/mac80211/mlme.c:5957:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_beacon_loss_notify=E2=80=99 follows static declaration
    include/linux/export.h:67:22: error: expected declaration or statement =
at end of input

Warnings:
    net/mac80211/mlme.c:3062:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    net/mac80211/mlme.c:5898:6: warning: =E2=80=98ieee80211_mgd_stop=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5867:5: warning: =E2=80=98ieee80211_mgd_disassoc=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5803:5: warning: =E2=80=98ieee80211_mgd_deauth=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5480:5: warning: =E2=80=98ieee80211_mgd_assoc=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5330:5: warning: =E2=80=98ieee80211_mgd_auth=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4834:6: warning: =E2=80=98ieee80211_mlme_notify_sca=
n_completed=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4795:6: warning: =E2=80=98ieee80211_sta_setup_sdata=
=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4770:6: warning: =E2=80=98ieee80211_sta_restart=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4710:6: warning: =E2=80=98ieee80211_mgd_quiesce=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4492:6: warning: =E2=80=98ieee80211_sta_work=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4480:6: warning: =E2=80=98ieee80211_mgd_conn_tx_sta=
tus=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4254:6: warning: =E2=80=98ieee80211_sta_rx_queued_m=
gmt=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4234:6: warning: =E2=80=98ieee80211_sta_rx_queued_e=
xt=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
aspeed_g4_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
aspeed_g5_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
assabet_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xcb6c): Section mismatch in referenc=
e from the function __arm_ioremap_pfn_caller() to the function .meminit.tex=
t:memblock_is_map_memory()

---------------------------------------------------------------------------=
-----
at91_dt_defconfig (arm, gcc-10) =E2=80=94 FAIL, 28 errors, 16 warnings, 0 s=
ection mismatches

Errors:
    net/mac80211/mlme.c:3116:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_deauth=E2=80=99
    net/mac80211/mlme.c:3164:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_disassoc=E2=80=99
    net/mac80211/mlme.c:3195:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_rates=E2=80=99
    net/mac80211/mlme.c:3245:13: error: invalid storage class for function =
=E2=80=98ieee80211_twt_req_supported=E2=80=99
    net/mac80211/mlme.c:3258:12: error: invalid storage class for function =
=E2=80=98ieee80211_recalc_twt_req=E2=80=99
    net/mac80211/mlme.c:3271:13: error: invalid storage class for function =
=E2=80=98ieee80211_assoc_success=E2=80=99
    net/mac80211/mlme.c:3648:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_assoc_resp=E2=80=99
    net/mac80211/mlme.c:3757:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_bss_info=E2=80=99
    net/mac80211/mlme.c:3780:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_probe_resp=E2=80=99
    net/mac80211/mlme.c:3845:13: error: invalid storage class for function =
=E2=80=98ieee80211_handle_beacon_sig=E2=80=99
    net/mac80211/mlme.c:3941:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_our_beacon=E2=80=99
    net/mac80211/mlme.c:3951:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_beacon=E2=80=99
    net/mac80211/mlme.c:4344:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_timer=E2=80=99
    net/mac80211/mlme.c:4352:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_connection_lost=E2=80=99
    net/mac80211/mlme.c:4364:12: error: invalid storage class for function =
=E2=80=98ieee80211_auth=E2=80=99
    net/mac80211/mlme.c:4439:12: error: invalid storage class for function =
=E2=80=98ieee80211_do_assoc=E2=80=99
    net/mac80211/mlme.c:4639:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_bcn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4656:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_conn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4688:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_monitor_work=E2=80=99
    net/mac80211/mlme.c:4697:13: error: invalid storage class for function =
=E2=80=98ieee80211_restart_sta_timer=E2=80=99
    net/mac80211/mlme.c:4847:11: error: invalid storage class for function =
=E2=80=98ieee80211_ht_vht_rx_chains=E2=80=99
    net/mac80211/mlme.c:4892:1: error: invalid storage class for function =
=E2=80=98ieee80211_verify_sta_he_mcs_support=E2=80=99
    net/mac80211/mlme.c:4953:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_channel=E2=80=99
    net/mac80211/mlme.c:5122:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_dtim=E2=80=99
    net/mac80211/mlme.c:5156:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_connection=E2=80=99
    net/mac80211/mlme.c:5947:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_rssi_notify=E2=80=99 follows static declaration
    net/mac80211/mlme.c:5957:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_beacon_loss_notify=E2=80=99 follows static declaration
    include/linux/export.h:67:22: error: expected declaration or statement =
at end of input

Warnings:
    net/mac80211/mlme.c:3062:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    net/mac80211/mlme.c:5898:6: warning: =E2=80=98ieee80211_mgd_stop=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5867:5: warning: =E2=80=98ieee80211_mgd_disassoc=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5803:5: warning: =E2=80=98ieee80211_mgd_deauth=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5480:5: warning: =E2=80=98ieee80211_mgd_assoc=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5330:5: warning: =E2=80=98ieee80211_mgd_auth=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4834:6: warning: =E2=80=98ieee80211_mlme_notify_sca=
n_completed=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4795:6: warning: =E2=80=98ieee80211_sta_setup_sdata=
=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4770:6: warning: =E2=80=98ieee80211_sta_restart=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4710:6: warning: =E2=80=98ieee80211_mgd_quiesce=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4492:6: warning: =E2=80=98ieee80211_sta_work=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4480:6: warning: =E2=80=98ieee80211_mgd_conn_tx_sta=
tus=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4254:6: warning: =E2=80=98ieee80211_sta_rx_queued_m=
gmt=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4234:6: warning: =E2=80=98ieee80211_sta_rx_queued_e=
xt=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
ath25_defconfig (mips, gcc-10) =E2=80=94 FAIL, 28 errors, 14 warnings, 0 se=
ction mismatches

Errors:
    net/mac80211/mlme.c:3116:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_deauth=E2=80=99
    net/mac80211/mlme.c:3164:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_disassoc=E2=80=99
    net/mac80211/mlme.c:3195:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_rates=E2=80=99
    net/mac80211/mlme.c:3245:13: error: invalid storage class for function =
=E2=80=98ieee80211_twt_req_supported=E2=80=99
    net/mac80211/mlme.c:3258:12: error: invalid storage class for function =
=E2=80=98ieee80211_recalc_twt_req=E2=80=99
    net/mac80211/mlme.c:3271:13: error: invalid storage class for function =
=E2=80=98ieee80211_assoc_success=E2=80=99
    net/mac80211/mlme.c:3648:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_assoc_resp=E2=80=99
    net/mac80211/mlme.c:3757:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_bss_info=E2=80=99
    net/mac80211/mlme.c:3780:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_probe_resp=E2=80=99
    net/mac80211/mlme.c:3845:13: error: invalid storage class for function =
=E2=80=98ieee80211_handle_beacon_sig=E2=80=99
    net/mac80211/mlme.c:3941:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_our_beacon=E2=80=99
    net/mac80211/mlme.c:3951:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_beacon=E2=80=99
    net/mac80211/mlme.c:4344:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_timer=E2=80=99
    net/mac80211/mlme.c:4352:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_connection_lost=E2=80=99
    net/mac80211/mlme.c:4364:12: error: invalid storage class for function =
=E2=80=98ieee80211_auth=E2=80=99
    net/mac80211/mlme.c:4439:12: error: invalid storage class for function =
=E2=80=98ieee80211_do_assoc=E2=80=99
    net/mac80211/mlme.c:4639:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_bcn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4656:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_conn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4688:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_monitor_work=E2=80=99
    net/mac80211/mlme.c:4697:13: error: invalid storage class for function =
=E2=80=98ieee80211_restart_sta_timer=E2=80=99
    net/mac80211/mlme.c:4847:11: error: invalid storage class for function =
=E2=80=98ieee80211_ht_vht_rx_chains=E2=80=99
    net/mac80211/mlme.c:4892:1: error: invalid storage class for function =
=E2=80=98ieee80211_verify_sta_he_mcs_support=E2=80=99
    net/mac80211/mlme.c:4953:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_channel=E2=80=99
    net/mac80211/mlme.c:5122:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_dtim=E2=80=99
    net/mac80211/mlme.c:5156:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_connection=E2=80=99
    net/mac80211/mlme.c:5947:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_rssi_notify=E2=80=99 follows static declaration
    net/mac80211/mlme.c:5957:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_beacon_loss_notify=E2=80=99 follows static declaration
    include/linux/export.h:67:22: error: expected declaration or statement =
at end of input

Warnings:
    net/mac80211/mlme.c:3062:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    net/mac80211/mlme.c:5898:6: warning: =E2=80=98ieee80211_mgd_stop=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5867:5: warning: =E2=80=98ieee80211_mgd_disassoc=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5803:5: warning: =E2=80=98ieee80211_mgd_deauth=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5480:5: warning: =E2=80=98ieee80211_mgd_assoc=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5330:5: warning: =E2=80=98ieee80211_mgd_auth=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4834:6: warning: =E2=80=98ieee80211_mlme_notify_sca=
n_completed=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4795:6: warning: =E2=80=98ieee80211_sta_setup_sdata=
=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4492:6: warning: =E2=80=98ieee80211_sta_work=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4480:6: warning: =E2=80=98ieee80211_mgd_conn_tx_sta=
tus=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4254:6: warning: =E2=80=98ieee80211_sta_rx_queued_m=
gmt=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4234:6: warning: =E2=80=98ieee80211_sta_rx_queued_e=
xt=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips, gcc-10) =E2=80=94 FAIL, 28 errors, 14 warnings, 0 se=
ction mismatches

Errors:
    net/mac80211/mlme.c:3116:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_deauth=E2=80=99
    net/mac80211/mlme.c:3164:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_disassoc=E2=80=99
    net/mac80211/mlme.c:3195:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_rates=E2=80=99
    net/mac80211/mlme.c:3245:13: error: invalid storage class for function =
=E2=80=98ieee80211_twt_req_supported=E2=80=99
    net/mac80211/mlme.c:3258:12: error: invalid storage class for function =
=E2=80=98ieee80211_recalc_twt_req=E2=80=99
    net/mac80211/mlme.c:3271:13: error: invalid storage class for function =
=E2=80=98ieee80211_assoc_success=E2=80=99
    net/mac80211/mlme.c:3648:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_assoc_resp=E2=80=99
    net/mac80211/mlme.c:3757:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_bss_info=E2=80=99
    net/mac80211/mlme.c:3780:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_probe_resp=E2=80=99
    net/mac80211/mlme.c:3845:13: error: invalid storage class for function =
=E2=80=98ieee80211_handle_beacon_sig=E2=80=99
    net/mac80211/mlme.c:3941:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_our_beacon=E2=80=99
    net/mac80211/mlme.c:3951:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_beacon=E2=80=99
    net/mac80211/mlme.c:4344:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_timer=E2=80=99
    net/mac80211/mlme.c:4352:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_connection_lost=E2=80=99
    net/mac80211/mlme.c:4364:12: error: invalid storage class for function =
=E2=80=98ieee80211_auth=E2=80=99
    net/mac80211/mlme.c:4439:12: error: invalid storage class for function =
=E2=80=98ieee80211_do_assoc=E2=80=99
    net/mac80211/mlme.c:4639:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_bcn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4656:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_conn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4688:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_monitor_work=E2=80=99
    net/mac80211/mlme.c:4697:13: error: invalid storage class for function =
=E2=80=98ieee80211_restart_sta_timer=E2=80=99
    net/mac80211/mlme.c:4847:11: error: invalid storage class for function =
=E2=80=98ieee80211_ht_vht_rx_chains=E2=80=99
    net/mac80211/mlme.c:4892:1: error: invalid storage class for function =
=E2=80=98ieee80211_verify_sta_he_mcs_support=E2=80=99
    net/mac80211/mlme.c:4953:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_channel=E2=80=99
    net/mac80211/mlme.c:5122:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_dtim=E2=80=99
    net/mac80211/mlme.c:5156:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_connection=E2=80=99
    net/mac80211/mlme.c:5947:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_rssi_notify=E2=80=99 follows static declaration
    net/mac80211/mlme.c:5957:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_beacon_loss_notify=E2=80=99 follows static declaration
    include/linux/export.h:67:22: error: expected declaration or statement =
at end of input

Warnings:
    net/mac80211/mlme.c:3062:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    net/mac80211/mlme.c:5898:6: warning: =E2=80=98ieee80211_mgd_stop=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5867:5: warning: =E2=80=98ieee80211_mgd_disassoc=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5803:5: warning: =E2=80=98ieee80211_mgd_deauth=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5480:5: warning: =E2=80=98ieee80211_mgd_assoc=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5330:5: warning: =E2=80=98ieee80211_mgd_auth=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4834:6: warning: =E2=80=98ieee80211_mlme_notify_sca=
n_completed=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4795:6: warning: =E2=80=98ieee80211_sta_setup_sdata=
=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4492:6: warning: =E2=80=98ieee80211_sta_work=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4480:6: warning: =E2=80=98ieee80211_mgd_conn_tx_sta=
tus=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4254:6: warning: =E2=80=98ieee80211_sta_rx_queued_m=
gmt=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4234:6: warning: =E2=80=98ieee80211_sta_rx_queued_e=
xt=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
axm55xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
axs103_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
badge4_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xcd38): Section mismatch in referenc=
e from the function __arm_ioremap_pfn_caller() to the function .meminit.tex=
t:memblock_is_map_memory()

---------------------------------------------------------------------------=
-----
bcm2835_defconfig (arm, gcc-10) =E2=80=94 FAIL, 28 errors, 16 warnings, 0 s=
ection mismatches

Errors:
    net/mac80211/mlme.c:3116:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_deauth=E2=80=99
    net/mac80211/mlme.c:3164:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_disassoc=E2=80=99
    net/mac80211/mlme.c:3195:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_rates=E2=80=99
    net/mac80211/mlme.c:3245:13: error: invalid storage class for function =
=E2=80=98ieee80211_twt_req_supported=E2=80=99
    net/mac80211/mlme.c:3258:12: error: invalid storage class for function =
=E2=80=98ieee80211_recalc_twt_req=E2=80=99
    net/mac80211/mlme.c:3271:13: error: invalid storage class for function =
=E2=80=98ieee80211_assoc_success=E2=80=99
    net/mac80211/mlme.c:3648:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_assoc_resp=E2=80=99
    net/mac80211/mlme.c:3757:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_bss_info=E2=80=99
    net/mac80211/mlme.c:3780:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_probe_resp=E2=80=99
    net/mac80211/mlme.c:3845:13: error: invalid storage class for function =
=E2=80=98ieee80211_handle_beacon_sig=E2=80=99
    net/mac80211/mlme.c:3941:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_our_beacon=E2=80=99
    net/mac80211/mlme.c:3951:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_beacon=E2=80=99
    net/mac80211/mlme.c:4344:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_timer=E2=80=99
    net/mac80211/mlme.c:4352:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_connection_lost=E2=80=99
    net/mac80211/mlme.c:4364:12: error: invalid storage class for function =
=E2=80=98ieee80211_auth=E2=80=99
    net/mac80211/mlme.c:4439:12: error: invalid storage class for function =
=E2=80=98ieee80211_do_assoc=E2=80=99
    net/mac80211/mlme.c:4639:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_bcn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4656:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_conn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4688:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_monitor_work=E2=80=99
    net/mac80211/mlme.c:4697:13: error: invalid storage class for function =
=E2=80=98ieee80211_restart_sta_timer=E2=80=99
    net/mac80211/mlme.c:4847:11: error: invalid storage class for function =
=E2=80=98ieee80211_ht_vht_rx_chains=E2=80=99
    net/mac80211/mlme.c:4892:1: error: invalid storage class for function =
=E2=80=98ieee80211_verify_sta_he_mcs_support=E2=80=99
    net/mac80211/mlme.c:4953:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_channel=E2=80=99
    net/mac80211/mlme.c:5122:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_dtim=E2=80=99
    net/mac80211/mlme.c:5156:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_connection=E2=80=99
    net/mac80211/mlme.c:5947:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_rssi_notify=E2=80=99 follows static declaration
    net/mac80211/mlme.c:5957:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_beacon_loss_notify=E2=80=99 follows static declaration
    include/linux/export.h:67:22: error: expected declaration or statement =
at end of input

Warnings:
    net/mac80211/mlme.c:3062:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    net/mac80211/mlme.c:5898:6: warning: =E2=80=98ieee80211_mgd_stop=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5867:5: warning: =E2=80=98ieee80211_mgd_disassoc=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5803:5: warning: =E2=80=98ieee80211_mgd_deauth=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5480:5: warning: =E2=80=98ieee80211_mgd_assoc=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5330:5: warning: =E2=80=98ieee80211_mgd_auth=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4834:6: warning: =E2=80=98ieee80211_mlme_notify_sca=
n_completed=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4795:6: warning: =E2=80=98ieee80211_sta_setup_sdata=
=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4770:6: warning: =E2=80=98ieee80211_sta_restart=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4710:6: warning: =E2=80=98ieee80211_mgd_quiesce=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4492:6: warning: =E2=80=98ieee80211_sta_work=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4480:6: warning: =E2=80=98ieee80211_mgd_conn_tx_sta=
tus=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4254:6: warning: =E2=80=98ieee80211_sta_rx_queued_m=
gmt=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4234:6: warning: =E2=80=98ieee80211_sta_rx_queued_e=
xt=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
bcm47xx_defconfig (mips, gcc-10) =E2=80=94 FAIL, 28 errors, 14 warnings, 0 =
section mismatches

Errors:
    net/mac80211/mlme.c:3116:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_deauth=E2=80=99
    net/mac80211/mlme.c:3164:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_disassoc=E2=80=99
    net/mac80211/mlme.c:3195:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_rates=E2=80=99
    net/mac80211/mlme.c:3245:13: error: invalid storage class for function =
=E2=80=98ieee80211_twt_req_supported=E2=80=99
    net/mac80211/mlme.c:3258:12: error: invalid storage class for function =
=E2=80=98ieee80211_recalc_twt_req=E2=80=99
    net/mac80211/mlme.c:3271:13: error: invalid storage class for function =
=E2=80=98ieee80211_assoc_success=E2=80=99
    net/mac80211/mlme.c:3648:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_assoc_resp=E2=80=99
    net/mac80211/mlme.c:3757:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_bss_info=E2=80=99
    net/mac80211/mlme.c:3780:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_probe_resp=E2=80=99
    net/mac80211/mlme.c:3845:13: error: invalid storage class for function =
=E2=80=98ieee80211_handle_beacon_sig=E2=80=99
    net/mac80211/mlme.c:3941:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_our_beacon=E2=80=99
    net/mac80211/mlme.c:3951:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_beacon=E2=80=99
    net/mac80211/mlme.c:4344:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_timer=E2=80=99
    net/mac80211/mlme.c:4352:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_connection_lost=E2=80=99
    net/mac80211/mlme.c:4364:12: error: invalid storage class for function =
=E2=80=98ieee80211_auth=E2=80=99
    net/mac80211/mlme.c:4439:12: error: invalid storage class for function =
=E2=80=98ieee80211_do_assoc=E2=80=99
    net/mac80211/mlme.c:4639:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_bcn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4656:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_conn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4688:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_monitor_work=E2=80=99
    net/mac80211/mlme.c:4697:13: error: invalid storage class for function =
=E2=80=98ieee80211_restart_sta_timer=E2=80=99
    net/mac80211/mlme.c:4847:11: error: invalid storage class for function =
=E2=80=98ieee80211_ht_vht_rx_chains=E2=80=99
    net/mac80211/mlme.c:4892:1: error: invalid storage class for function =
=E2=80=98ieee80211_verify_sta_he_mcs_support=E2=80=99
    net/mac80211/mlme.c:4953:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_channel=E2=80=99
    net/mac80211/mlme.c:5122:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_dtim=E2=80=99
    net/mac80211/mlme.c:5156:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_connection=E2=80=99
    net/mac80211/mlme.c:5947:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_rssi_notify=E2=80=99 follows static declaration
    net/mac80211/mlme.c:5957:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_beacon_loss_notify=E2=80=99 follows static declaration
    include/linux/export.h:67:22: error: expected declaration or statement =
at end of input

Warnings:
    net/mac80211/mlme.c:3062:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    net/mac80211/mlme.c:5898:6: warning: =E2=80=98ieee80211_mgd_stop=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5867:5: warning: =E2=80=98ieee80211_mgd_disassoc=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5803:5: warning: =E2=80=98ieee80211_mgd_deauth=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5480:5: warning: =E2=80=98ieee80211_mgd_assoc=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5330:5: warning: =E2=80=98ieee80211_mgd_auth=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4834:6: warning: =E2=80=98ieee80211_mlme_notify_sca=
n_completed=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4795:6: warning: =E2=80=98ieee80211_sta_setup_sdata=
=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4492:6: warning: =E2=80=98ieee80211_sta_work=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4480:6: warning: =E2=80=98ieee80211_mgd_conn_tx_sta=
tus=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4254:6: warning: =E2=80=98ieee80211_sta_rx_queued_m=
gmt=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4234:6: warning: =E2=80=98ieee80211_sta_rx_queued_e=
xt=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
bcm63xx_defconfig (mips, gcc-10) =E2=80=94 FAIL, 26 errors, 17 warnings, 0 =
section mismatches

Errors:
    net/mac80211/mlme.c:3116:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_deauth=E2=80=99
    net/mac80211/mlme.c:3164:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_disassoc=E2=80=99
    net/mac80211/mlme.c:3195:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_rates=E2=80=99
    net/mac80211/mlme.c:3245:13: error: invalid storage class for function =
=E2=80=98ieee80211_twt_req_supported=E2=80=99
    net/mac80211/mlme.c:3258:12: error: invalid storage class for function =
=E2=80=98ieee80211_recalc_twt_req=E2=80=99
    net/mac80211/mlme.c:3271:13: error: invalid storage class for function =
=E2=80=98ieee80211_assoc_success=E2=80=99
    net/mac80211/mlme.c:3648:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_assoc_resp=E2=80=99
    net/mac80211/mlme.c:3757:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_bss_info=E2=80=99
    net/mac80211/mlme.c:3780:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_probe_resp=E2=80=99
    net/mac80211/mlme.c:3845:13: error: invalid storage class for function =
=E2=80=98ieee80211_handle_beacon_sig=E2=80=99
    net/mac80211/mlme.c:3941:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_our_beacon=E2=80=99
    net/mac80211/mlme.c:3951:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_beacon=E2=80=99
    net/mac80211/mlme.c:4344:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_timer=E2=80=99
    net/mac80211/mlme.c:4352:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_connection_lost=E2=80=99
    net/mac80211/mlme.c:4364:12: error: invalid storage class for function =
=E2=80=98ieee80211_auth=E2=80=99
    net/mac80211/mlme.c:4439:12: error: invalid storage class for function =
=E2=80=98ieee80211_do_assoc=E2=80=99
    net/mac80211/mlme.c:4639:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_bcn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4656:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_conn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4688:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_monitor_work=E2=80=99
    net/mac80211/mlme.c:4697:13: error: invalid storage class for function =
=E2=80=98ieee80211_restart_sta_timer=E2=80=99
    net/mac80211/mlme.c:4847:11: error: invalid storage class for function =
=E2=80=98ieee80211_ht_vht_rx_chains=E2=80=99
    net/mac80211/mlme.c:4892:1: error: invalid storage class for function =
=E2=80=98ieee80211_verify_sta_he_mcs_support=E2=80=99
    net/mac80211/mlme.c:4953:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_channel=E2=80=99
    net/mac80211/mlme.c:5122:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_dtim=E2=80=99
    net/mac80211/mlme.c:5156:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_connection=E2=80=99
    net/mac80211/mlme.c:5957:1: error: expected declaration or statement at=
 end of input

Warnings:
    net/mac80211/mlme.c:3062:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    net/mac80211/mlme.c:5949:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    net/mac80211/mlme.c:5949:6: warning: =E2=80=98ieee80211_cqm_beacon_loss=
_notify=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5936:6: warning: =E2=80=98ieee80211_cqm_rssi_notify=
=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5898:6: warning: =E2=80=98ieee80211_mgd_stop=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5867:5: warning: =E2=80=98ieee80211_mgd_disassoc=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5803:5: warning: =E2=80=98ieee80211_mgd_deauth=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5480:5: warning: =E2=80=98ieee80211_mgd_assoc=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5330:5: warning: =E2=80=98ieee80211_mgd_auth=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4834:6: warning: =E2=80=98ieee80211_mlme_notify_sca=
n_completed=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4795:6: warning: =E2=80=98ieee80211_sta_setup_sdata=
=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4770:6: warning: =E2=80=98ieee80211_sta_restart=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4710:6: warning: =E2=80=98ieee80211_mgd_quiesce=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4492:6: warning: =E2=80=98ieee80211_sta_work=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4480:6: warning: =E2=80=98ieee80211_mgd_conn_tx_sta=
tus=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4254:6: warning: =E2=80=98ieee80211_sta_rx_queued_m=
gmt=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4234:6: warning: =E2=80=98ieee80211_sta_rx_queued_e=
xt=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
bigsur_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-10) =E2=80=94 FAIL, 26 errors, 17 warnings, 0=
 section mismatches

Errors:
    net/mac80211/mlme.c:3116:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_deauth=E2=80=99
    net/mac80211/mlme.c:3164:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_disassoc=E2=80=99
    net/mac80211/mlme.c:3195:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_rates=E2=80=99
    net/mac80211/mlme.c:3245:13: error: invalid storage class for function =
=E2=80=98ieee80211_twt_req_supported=E2=80=99
    net/mac80211/mlme.c:3258:12: error: invalid storage class for function =
=E2=80=98ieee80211_recalc_twt_req=E2=80=99
    net/mac80211/mlme.c:3271:13: error: invalid storage class for function =
=E2=80=98ieee80211_assoc_success=E2=80=99
    net/mac80211/mlme.c:3648:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_assoc_resp=E2=80=99
    net/mac80211/mlme.c:3757:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_bss_info=E2=80=99
    net/mac80211/mlme.c:3780:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_probe_resp=E2=80=99
    net/mac80211/mlme.c:3845:13: error: invalid storage class for function =
=E2=80=98ieee80211_handle_beacon_sig=E2=80=99
    net/mac80211/mlme.c:3941:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_our_beacon=E2=80=99
    net/mac80211/mlme.c:3951:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_beacon=E2=80=99
    net/mac80211/mlme.c:4344:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_timer=E2=80=99
    net/mac80211/mlme.c:4352:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_connection_lost=E2=80=99
    net/mac80211/mlme.c:4364:12: error: invalid storage class for function =
=E2=80=98ieee80211_auth=E2=80=99
    net/mac80211/mlme.c:4439:12: error: invalid storage class for function =
=E2=80=98ieee80211_do_assoc=E2=80=99
    net/mac80211/mlme.c:4639:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_bcn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4656:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_conn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4688:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_monitor_work=E2=80=99
    net/mac80211/mlme.c:4697:13: error: invalid storage class for function =
=E2=80=98ieee80211_restart_sta_timer=E2=80=99
    net/mac80211/mlme.c:4847:11: error: invalid storage class for function =
=E2=80=98ieee80211_ht_vht_rx_chains=E2=80=99
    net/mac80211/mlme.c:4892:1: error: invalid storage class for function =
=E2=80=98ieee80211_verify_sta_he_mcs_support=E2=80=99
    net/mac80211/mlme.c:4953:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_channel=E2=80=99
    net/mac80211/mlme.c:5122:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_dtim=E2=80=99
    net/mac80211/mlme.c:5156:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_connection=E2=80=99
    net/mac80211/mlme.c:5957:1: error: expected declaration or statement at=
 end of input

Warnings:
    net/mac80211/mlme.c:3062:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    net/mac80211/mlme.c:5949:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    net/mac80211/mlme.c:5949:6: warning: =E2=80=98ieee80211_cqm_beacon_loss=
_notify=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5936:6: warning: =E2=80=98ieee80211_cqm_rssi_notify=
=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5898:6: warning: =E2=80=98ieee80211_mgd_stop=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5867:5: warning: =E2=80=98ieee80211_mgd_disassoc=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5803:5: warning: =E2=80=98ieee80211_mgd_deauth=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5480:5: warning: =E2=80=98ieee80211_mgd_assoc=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5330:5: warning: =E2=80=98ieee80211_mgd_auth=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4834:6: warning: =E2=80=98ieee80211_mlme_notify_sca=
n_completed=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4795:6: warning: =E2=80=98ieee80211_sta_setup_sdata=
=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4770:6: warning: =E2=80=98ieee80211_sta_restart=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4710:6: warning: =E2=80=98ieee80211_mgd_quiesce=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4492:6: warning: =E2=80=98ieee80211_sta_work=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4480:6: warning: =E2=80=98ieee80211_mgd_conn_tx_sta=
tus=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4254:6: warning: =E2=80=98ieee80211_sta_rx_queued_m=
gmt=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4234:6: warning: =E2=80=98ieee80211_sta_rx_queued_e=
xt=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-10) =E2=80=94 FAIL, 26 errors, 17 warnings, =
0 section mismatches

Errors:
    net/mac80211/mlme.c:3116:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_deauth=E2=80=99
    net/mac80211/mlme.c:3164:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_disassoc=E2=80=99
    net/mac80211/mlme.c:3195:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_rates=E2=80=99
    net/mac80211/mlme.c:3245:13: error: invalid storage class for function =
=E2=80=98ieee80211_twt_req_supported=E2=80=99
    net/mac80211/mlme.c:3258:12: error: invalid storage class for function =
=E2=80=98ieee80211_recalc_twt_req=E2=80=99
    net/mac80211/mlme.c:3271:13: error: invalid storage class for function =
=E2=80=98ieee80211_assoc_success=E2=80=99
    net/mac80211/mlme.c:3648:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_assoc_resp=E2=80=99
    net/mac80211/mlme.c:3757:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_bss_info=E2=80=99
    net/mac80211/mlme.c:3780:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_probe_resp=E2=80=99
    net/mac80211/mlme.c:3845:13: error: invalid storage class for function =
=E2=80=98ieee80211_handle_beacon_sig=E2=80=99
    net/mac80211/mlme.c:3941:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_our_beacon=E2=80=99
    net/mac80211/mlme.c:3951:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_beacon=E2=80=99
    net/mac80211/mlme.c:4344:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_timer=E2=80=99
    net/mac80211/mlme.c:4352:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_connection_lost=E2=80=99
    net/mac80211/mlme.c:4364:12: error: invalid storage class for function =
=E2=80=98ieee80211_auth=E2=80=99
    net/mac80211/mlme.c:4439:12: error: invalid storage class for function =
=E2=80=98ieee80211_do_assoc=E2=80=99
    net/mac80211/mlme.c:4639:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_bcn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4656:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_conn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4688:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_monitor_work=E2=80=99
    net/mac80211/mlme.c:4697:13: error: invalid storage class for function =
=E2=80=98ieee80211_restart_sta_timer=E2=80=99
    net/mac80211/mlme.c:4847:11: error: invalid storage class for function =
=E2=80=98ieee80211_ht_vht_rx_chains=E2=80=99
    net/mac80211/mlme.c:4892:1: error: invalid storage class for function =
=E2=80=98ieee80211_verify_sta_he_mcs_support=E2=80=99
    net/mac80211/mlme.c:4953:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_channel=E2=80=99
    net/mac80211/mlme.c:5122:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_dtim=E2=80=99
    net/mac80211/mlme.c:5156:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_connection=E2=80=99
    net/mac80211/mlme.c:5957:1: error: expected declaration or statement at=
 end of input

Warnings:
    net/mac80211/mlme.c:3062:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    net/mac80211/mlme.c:5949:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    net/mac80211/mlme.c:5949:6: warning: =E2=80=98ieee80211_cqm_beacon_loss=
_notify=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5936:6: warning: =E2=80=98ieee80211_cqm_rssi_notify=
=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5898:6: warning: =E2=80=98ieee80211_mgd_stop=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5867:5: warning: =E2=80=98ieee80211_mgd_disassoc=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5803:5: warning: =E2=80=98ieee80211_mgd_deauth=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5480:5: warning: =E2=80=98ieee80211_mgd_assoc=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5330:5: warning: =E2=80=98ieee80211_mgd_auth=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4834:6: warning: =E2=80=98ieee80211_mlme_notify_sca=
n_completed=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4795:6: warning: =E2=80=98ieee80211_sta_setup_sdata=
=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4770:6: warning: =E2=80=98ieee80211_sta_restart=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4710:6: warning: =E2=80=98ieee80211_mgd_quiesce=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4492:6: warning: =E2=80=98ieee80211_sta_work=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4480:6: warning: =E2=80=98ieee80211_mgd_conn_tx_sta=
tus=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4254:6: warning: =E2=80=98ieee80211_sta_rx_queued_m=
gmt=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4234:6: warning: =E2=80=98ieee80211_sta_rx_queued_e=
xt=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0x7670): Section mismatch in referenc=
e from the function __arm_ioremap_pfn_caller() to the function .meminit.tex=
t:memblock_is_map_memory()

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
cm_x300_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
cobalt_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
colibri_pxa270_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
collie_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xb904): Section mismatch in referenc=
e from the function __arm_ioremap_pfn_caller() to the function .meminit.tex=
t:memblock_is_map_memory()

---------------------------------------------------------------------------=
-----
corgi_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
cu1000-neo_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
cu1830-neo_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
davinci_all_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-10) =E2=80=94 FAIL, 26 errors, 17 warnings, 0 s=
ection mismatches

Errors:
    net/mac80211/mlme.c:3116:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_deauth=E2=80=99
    net/mac80211/mlme.c:3164:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_disassoc=E2=80=99
    net/mac80211/mlme.c:3195:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_rates=E2=80=99
    net/mac80211/mlme.c:3245:13: error: invalid storage class for function =
=E2=80=98ieee80211_twt_req_supported=E2=80=99
    net/mac80211/mlme.c:3258:12: error: invalid storage class for function =
=E2=80=98ieee80211_recalc_twt_req=E2=80=99
    net/mac80211/mlme.c:3271:13: error: invalid storage class for function =
=E2=80=98ieee80211_assoc_success=E2=80=99
    net/mac80211/mlme.c:3648:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_assoc_resp=E2=80=99
    net/mac80211/mlme.c:3757:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_bss_info=E2=80=99
    net/mac80211/mlme.c:3780:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_probe_resp=E2=80=99
    net/mac80211/mlme.c:3845:13: error: invalid storage class for function =
=E2=80=98ieee80211_handle_beacon_sig=E2=80=99
    net/mac80211/mlme.c:3941:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_our_beacon=E2=80=99
    net/mac80211/mlme.c:3951:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_beacon=E2=80=99
    net/mac80211/mlme.c:4344:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_timer=E2=80=99
    net/mac80211/mlme.c:4352:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_connection_lost=E2=80=99
    net/mac80211/mlme.c:4364:12: error: invalid storage class for function =
=E2=80=98ieee80211_auth=E2=80=99
    net/mac80211/mlme.c:4439:12: error: invalid storage class for function =
=E2=80=98ieee80211_do_assoc=E2=80=99
    net/mac80211/mlme.c:4639:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_bcn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4656:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_conn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4688:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_monitor_work=E2=80=99
    net/mac80211/mlme.c:4697:13: error: invalid storage class for function =
=E2=80=98ieee80211_restart_sta_timer=E2=80=99
    net/mac80211/mlme.c:4847:11: error: invalid storage class for function =
=E2=80=98ieee80211_ht_vht_rx_chains=E2=80=99
    net/mac80211/mlme.c:4892:1: error: invalid storage class for function =
=E2=80=98ieee80211_verify_sta_he_mcs_support=E2=80=99
    net/mac80211/mlme.c:4953:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_channel=E2=80=99
    net/mac80211/mlme.c:5122:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_dtim=E2=80=99
    net/mac80211/mlme.c:5156:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_connection=E2=80=99
    net/mac80211/mlme.c:5957:1: error: expected declaration or statement at=
 end of input

Warnings:
    net/mac80211/mlme.c:3062:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    net/mac80211/mlme.c:5949:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    net/mac80211/mlme.c:5949:6: warning: =E2=80=98ieee80211_cqm_beacon_loss=
_notify=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5936:6: warning: =E2=80=98ieee80211_cqm_rssi_notify=
=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5898:6: warning: =E2=80=98ieee80211_mgd_stop=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5867:5: warning: =E2=80=98ieee80211_mgd_disassoc=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5803:5: warning: =E2=80=98ieee80211_mgd_deauth=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5480:5: warning: =E2=80=98ieee80211_mgd_assoc=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5330:5: warning: =E2=80=98ieee80211_mgd_auth=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4834:6: warning: =E2=80=98ieee80211_mlme_notify_sca=
n_completed=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4795:6: warning: =E2=80=98ieee80211_sta_setup_sdata=
=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4770:6: warning: =E2=80=98ieee80211_sta_restart=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4710:6: warning: =E2=80=98ieee80211_mgd_quiesce=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4492:6: warning: =E2=80=98ieee80211_sta_work=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4480:6: warning: =E2=80=98ieee80211_mgd_conn_tx_sta=
tus=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4254:6: warning: =E2=80=98ieee80211_sta_rx_queued_m=
gmt=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4234:6: warning: =E2=80=98ieee80211_sta_rx_queued_e=
xt=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
decstation_64_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning,=
 0 section mismatches

Warnings:
    kernel/rcu/tasks.h:707:13: warning: =E2=80=98show_rcu_tasks_rude_gp_kth=
read=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 =
section mismatches

Warnings:
    kernel/rcu/tasks.h:707:13: warning: =E2=80=98show_rcu_tasks_rude_gp_kth=
read=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
decstation_r4k_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning=
, 0 section mismatches

Warnings:
    kernel/rcu/tasks.h:707:13: warning: =E2=80=98show_rcu_tasks_rude_gp_kth=
read=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
defconfig (riscv, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-10) =E2=80=94 FAIL, 28 errors, 21 warnings, 0 section=
 mismatches

Errors:
    net/mac80211/mlme.c:3116:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_deauth=E2=80=99
    net/mac80211/mlme.c:3164:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_disassoc=E2=80=99
    net/mac80211/mlme.c:3195:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_rates=E2=80=99
    net/mac80211/mlme.c:3245:13: error: invalid storage class for function =
=E2=80=98ieee80211_twt_req_supported=E2=80=99
    net/mac80211/mlme.c:3258:12: error: invalid storage class for function =
=E2=80=98ieee80211_recalc_twt_req=E2=80=99
    net/mac80211/mlme.c:3271:13: error: invalid storage class for function =
=E2=80=98ieee80211_assoc_success=E2=80=99
    net/mac80211/mlme.c:3648:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_assoc_resp=E2=80=99
    net/mac80211/mlme.c:3757:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_bss_info=E2=80=99
    net/mac80211/mlme.c:3780:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_probe_resp=E2=80=99
    net/mac80211/mlme.c:3845:13: error: invalid storage class for function =
=E2=80=98ieee80211_handle_beacon_sig=E2=80=99
    net/mac80211/mlme.c:3941:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_our_beacon=E2=80=99
    net/mac80211/mlme.c:3951:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_beacon=E2=80=99
    net/mac80211/mlme.c:4344:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_timer=E2=80=99
    net/mac80211/mlme.c:4352:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_connection_lost=E2=80=99
    net/mac80211/mlme.c:4364:12: error: invalid storage class for function =
=E2=80=98ieee80211_auth=E2=80=99
    net/mac80211/mlme.c:4439:12: error: invalid storage class for function =
=E2=80=98ieee80211_do_assoc=E2=80=99
    net/mac80211/mlme.c:4639:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_bcn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4656:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_conn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4688:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_monitor_work=E2=80=99
    net/mac80211/mlme.c:4697:13: error: invalid storage class for function =
=E2=80=98ieee80211_restart_sta_timer=E2=80=99
    net/mac80211/mlme.c:4847:11: error: invalid storage class for function =
=E2=80=98ieee80211_ht_vht_rx_chains=E2=80=99
    net/mac80211/mlme.c:4892:1: error: invalid storage class for function =
=E2=80=98ieee80211_verify_sta_he_mcs_support=E2=80=99
    net/mac80211/mlme.c:4953:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_channel=E2=80=99
    net/mac80211/mlme.c:5122:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_dtim=E2=80=99
    net/mac80211/mlme.c:5156:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_connection=E2=80=99
    net/mac80211/mlme.c:5947:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_rssi_notify=E2=80=99 follows static declaration
    net/mac80211/mlme.c:5957:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_beacon_loss_notify=E2=80=99 follows static declaration
    net/mac80211/mlme.c:5957:1: error: expected declaration or statement at=
 end of input

Warnings:
    net/mac80211/mlme.c:3062:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    include/linux/compiler.h:225:2: warning: ISO C90 forbids mixed declarat=
ions and code [-Wdeclaration-after-statement]
    net/mac80211/mlme.c:5949:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    include/linux/compiler.h:225:2: warning: ISO C90 forbids mixed declarat=
ions and code [-Wdeclaration-after-statement]
    include/linux/export.h:100:20: warning: unused variable =E2=80=98__kstr=
tabns_ieee80211_cqm_beacon_loss_notify=E2=80=99 [-Wunused-variable]
    include/linux/export.h:99:20: warning: unused variable =E2=80=98__kstrt=
ab_ieee80211_cqm_beacon_loss_notify=E2=80=99 [-Wunused-variable]
    include/linux/export.h:100:20: warning: unused variable =E2=80=98__kstr=
tabns_ieee80211_cqm_rssi_notify=E2=80=99 [-Wunused-variable]
    include/linux/export.h:99:20: warning: unused variable =E2=80=98__kstrt=
ab_ieee80211_cqm_rssi_notify=E2=80=99 [-Wunused-variable]
    net/mac80211/mlme.c:5898:6: warning: =E2=80=98ieee80211_mgd_stop=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5867:5: warning: =E2=80=98ieee80211_mgd_disassoc=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5803:5: warning: =E2=80=98ieee80211_mgd_deauth=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5480:5: warning: =E2=80=98ieee80211_mgd_assoc=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5330:5: warning: =E2=80=98ieee80211_mgd_auth=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4834:6: warning: =E2=80=98ieee80211_mlme_notify_sca=
n_completed=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4795:6: warning: =E2=80=98ieee80211_sta_setup_sdata=
=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4770:6: warning: =E2=80=98ieee80211_sta_restart=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4710:6: warning: =E2=80=98ieee80211_mgd_quiesce=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4492:6: warning: =E2=80=98ieee80211_sta_work=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4480:6: warning: =E2=80=98ieee80211_mgd_conn_tx_sta=
tus=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4254:6: warning: =E2=80=98ieee80211_sta_rx_queued_m=
gmt=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4234:6: warning: =E2=80=98ieee80211_sta_rx_queued_e=
xt=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
defconfig+arm64-chromebook (arm64, gcc-10) =E2=80=94 FAIL, 28 errors, 21 wa=
rnings, 0 section mismatches

Errors:
    net/mac80211/mlme.c:3116:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_deauth=E2=80=99
    net/mac80211/mlme.c:3164:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_disassoc=E2=80=99
    net/mac80211/mlme.c:3195:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_rates=E2=80=99
    net/mac80211/mlme.c:3245:13: error: invalid storage class for function =
=E2=80=98ieee80211_twt_req_supported=E2=80=99
    net/mac80211/mlme.c:3258:12: error: invalid storage class for function =
=E2=80=98ieee80211_recalc_twt_req=E2=80=99
    net/mac80211/mlme.c:3271:13: error: invalid storage class for function =
=E2=80=98ieee80211_assoc_success=E2=80=99
    net/mac80211/mlme.c:3648:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_assoc_resp=E2=80=99
    net/mac80211/mlme.c:3757:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_bss_info=E2=80=99
    net/mac80211/mlme.c:3780:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_probe_resp=E2=80=99
    net/mac80211/mlme.c:3845:13: error: invalid storage class for function =
=E2=80=98ieee80211_handle_beacon_sig=E2=80=99
    net/mac80211/mlme.c:3941:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_our_beacon=E2=80=99
    net/mac80211/mlme.c:3951:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_beacon=E2=80=99
    net/mac80211/mlme.c:4344:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_timer=E2=80=99
    net/mac80211/mlme.c:4352:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_connection_lost=E2=80=99
    net/mac80211/mlme.c:4364:12: error: invalid storage class for function =
=E2=80=98ieee80211_auth=E2=80=99
    net/mac80211/mlme.c:4439:12: error: invalid storage class for function =
=E2=80=98ieee80211_do_assoc=E2=80=99
    net/mac80211/mlme.c:4639:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_bcn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4656:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_conn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4688:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_monitor_work=E2=80=99
    net/mac80211/mlme.c:4697:13: error: invalid storage class for function =
=E2=80=98ieee80211_restart_sta_timer=E2=80=99
    net/mac80211/mlme.c:4847:11: error: invalid storage class for function =
=E2=80=98ieee80211_ht_vht_rx_chains=E2=80=99
    net/mac80211/mlme.c:4892:1: error: invalid storage class for function =
=E2=80=98ieee80211_verify_sta_he_mcs_support=E2=80=99
    net/mac80211/mlme.c:4953:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_channel=E2=80=99
    net/mac80211/mlme.c:5122:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_dtim=E2=80=99
    net/mac80211/mlme.c:5156:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_connection=E2=80=99
    net/mac80211/mlme.c:5947:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_rssi_notify=E2=80=99 follows static declaration
    net/mac80211/mlme.c:5957:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_beacon_loss_notify=E2=80=99 follows static declaration
    net/mac80211/mlme.c:5957:1: error: expected declaration or statement at=
 end of input

Warnings:
    net/mac80211/mlme.c:3062:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    include/linux/compiler.h:225:2: warning: ISO C90 forbids mixed declarat=
ions and code [-Wdeclaration-after-statement]
    net/mac80211/mlme.c:5949:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    include/linux/compiler.h:225:2: warning: ISO C90 forbids mixed declarat=
ions and code [-Wdeclaration-after-statement]
    include/linux/export.h:100:20: warning: unused variable =E2=80=98__kstr=
tabns_ieee80211_cqm_beacon_loss_notify=E2=80=99 [-Wunused-variable]
    include/linux/export.h:99:20: warning: unused variable =E2=80=98__kstrt=
ab_ieee80211_cqm_beacon_loss_notify=E2=80=99 [-Wunused-variable]
    include/linux/export.h:100:20: warning: unused variable =E2=80=98__kstr=
tabns_ieee80211_cqm_rssi_notify=E2=80=99 [-Wunused-variable]
    include/linux/export.h:99:20: warning: unused variable =E2=80=98__kstrt=
ab_ieee80211_cqm_rssi_notify=E2=80=99 [-Wunused-variable]
    net/mac80211/mlme.c:5898:6: warning: =E2=80=98ieee80211_mgd_stop=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5867:5: warning: =E2=80=98ieee80211_mgd_disassoc=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5803:5: warning: =E2=80=98ieee80211_mgd_deauth=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5480:5: warning: =E2=80=98ieee80211_mgd_assoc=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5330:5: warning: =E2=80=98ieee80211_mgd_auth=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4834:6: warning: =E2=80=98ieee80211_mlme_notify_sca=
n_completed=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4795:6: warning: =E2=80=98ieee80211_sta_setup_sdata=
=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4770:6: warning: =E2=80=98ieee80211_sta_restart=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4710:6: warning: =E2=80=98ieee80211_mgd_quiesce=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4492:6: warning: =E2=80=98ieee80211_sta_work=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4480:6: warning: =E2=80=98ieee80211_mgd_conn_tx_sta=
tus=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4254:6: warning: =E2=80=98ieee80211_sta_rx_queued_m=
gmt=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4234:6: warning: =E2=80=98ieee80211_sta_rx_queued_e=
xt=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
dove_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
e55_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
ebsa110_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
efm32_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ep93xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0x8054): Section mismatch in referenc=
e from the function __arm_ioremap_pfn_caller() to the function .meminit.tex=
t:memblock_is_map_memory()

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-10) =E2=80=94 FAIL, 28 errors, 16 warnings,=
 0 section mismatches

Errors:
    net/mac80211/mlme.c:3116:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_deauth=E2=80=99
    net/mac80211/mlme.c:3164:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_disassoc=E2=80=99
    net/mac80211/mlme.c:3195:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_rates=E2=80=99
    net/mac80211/mlme.c:3245:13: error: invalid storage class for function =
=E2=80=98ieee80211_twt_req_supported=E2=80=99
    net/mac80211/mlme.c:3258:12: error: invalid storage class for function =
=E2=80=98ieee80211_recalc_twt_req=E2=80=99
    net/mac80211/mlme.c:3271:13: error: invalid storage class for function =
=E2=80=98ieee80211_assoc_success=E2=80=99
    net/mac80211/mlme.c:3648:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_assoc_resp=E2=80=99
    net/mac80211/mlme.c:3757:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_bss_info=E2=80=99
    net/mac80211/mlme.c:3780:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_probe_resp=E2=80=99
    net/mac80211/mlme.c:3845:13: error: invalid storage class for function =
=E2=80=98ieee80211_handle_beacon_sig=E2=80=99
    net/mac80211/mlme.c:3941:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_our_beacon=E2=80=99
    net/mac80211/mlme.c:3951:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_beacon=E2=80=99
    net/mac80211/mlme.c:4344:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_timer=E2=80=99
    net/mac80211/mlme.c:4352:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_connection_lost=E2=80=99
    net/mac80211/mlme.c:4364:12: error: invalid storage class for function =
=E2=80=98ieee80211_auth=E2=80=99
    net/mac80211/mlme.c:4439:12: error: invalid storage class for function =
=E2=80=98ieee80211_do_assoc=E2=80=99
    net/mac80211/mlme.c:4639:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_bcn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4656:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_conn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4688:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_monitor_work=E2=80=99
    net/mac80211/mlme.c:4697:13: error: invalid storage class for function =
=E2=80=98ieee80211_restart_sta_timer=E2=80=99
    net/mac80211/mlme.c:4847:11: error: invalid storage class for function =
=E2=80=98ieee80211_ht_vht_rx_chains=E2=80=99
    net/mac80211/mlme.c:4892:1: error: invalid storage class for function =
=E2=80=98ieee80211_verify_sta_he_mcs_support=E2=80=99
    net/mac80211/mlme.c:4953:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_channel=E2=80=99
    net/mac80211/mlme.c:5122:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_dtim=E2=80=99
    net/mac80211/mlme.c:5156:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_connection=E2=80=99
    net/mac80211/mlme.c:5947:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_rssi_notify=E2=80=99 follows static declaration
    net/mac80211/mlme.c:5957:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_beacon_loss_notify=E2=80=99 follows static declaration
    include/linux/export.h:67:22: error: expected declaration or statement =
at end of input

Warnings:
    net/mac80211/mlme.c:3062:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    net/mac80211/mlme.c:5898:6: warning: =E2=80=98ieee80211_mgd_stop=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5867:5: warning: =E2=80=98ieee80211_mgd_disassoc=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5803:5: warning: =E2=80=98ieee80211_mgd_deauth=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5480:5: warning: =E2=80=98ieee80211_mgd_assoc=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5330:5: warning: =E2=80=98ieee80211_mgd_auth=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4834:6: warning: =E2=80=98ieee80211_mlme_notify_sca=
n_completed=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4795:6: warning: =E2=80=98ieee80211_sta_setup_sdata=
=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4770:6: warning: =E2=80=98ieee80211_sta_restart=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4710:6: warning: =E2=80=98ieee80211_mgd_quiesce=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4492:6: warning: =E2=80=98ieee80211_sta_work=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4480:6: warning: =E2=80=98ieee80211_mgd_conn_tx_sta=
tus=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4254:6: warning: =E2=80=98ieee80211_sta_rx_queued_m=
gmt=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4234:6: warning: =E2=80=98ieee80211_sta_rx_queued_e=
xt=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-10) =E2=80=94 FAIL, 28 errors, 16 warnings, 0 se=
ction mismatches

Errors:
    net/mac80211/mlme.c:3116:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_deauth=E2=80=99
    net/mac80211/mlme.c:3164:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_disassoc=E2=80=99
    net/mac80211/mlme.c:3195:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_rates=E2=80=99
    net/mac80211/mlme.c:3245:13: error: invalid storage class for function =
=E2=80=98ieee80211_twt_req_supported=E2=80=99
    net/mac80211/mlme.c:3258:12: error: invalid storage class for function =
=E2=80=98ieee80211_recalc_twt_req=E2=80=99
    net/mac80211/mlme.c:3271:13: error: invalid storage class for function =
=E2=80=98ieee80211_assoc_success=E2=80=99
    net/mac80211/mlme.c:3648:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_assoc_resp=E2=80=99
    net/mac80211/mlme.c:3757:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_bss_info=E2=80=99
    net/mac80211/mlme.c:3780:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_probe_resp=E2=80=99
    net/mac80211/mlme.c:3845:13: error: invalid storage class for function =
=E2=80=98ieee80211_handle_beacon_sig=E2=80=99
    net/mac80211/mlme.c:3941:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_our_beacon=E2=80=99
    net/mac80211/mlme.c:3951:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_beacon=E2=80=99
    net/mac80211/mlme.c:4344:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_timer=E2=80=99
    net/mac80211/mlme.c:4352:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_connection_lost=E2=80=99
    net/mac80211/mlme.c:4364:12: error: invalid storage class for function =
=E2=80=98ieee80211_auth=E2=80=99
    net/mac80211/mlme.c:4439:12: error: invalid storage class for function =
=E2=80=98ieee80211_do_assoc=E2=80=99
    net/mac80211/mlme.c:4639:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_bcn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4656:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_conn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4688:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_monitor_work=E2=80=99
    net/mac80211/mlme.c:4697:13: error: invalid storage class for function =
=E2=80=98ieee80211_restart_sta_timer=E2=80=99
    net/mac80211/mlme.c:4847:11: error: invalid storage class for function =
=E2=80=98ieee80211_ht_vht_rx_chains=E2=80=99
    net/mac80211/mlme.c:4892:1: error: invalid storage class for function =
=E2=80=98ieee80211_verify_sta_he_mcs_support=E2=80=99
    net/mac80211/mlme.c:4953:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_channel=E2=80=99
    net/mac80211/mlme.c:5122:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_dtim=E2=80=99
    net/mac80211/mlme.c:5156:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_connection=E2=80=99
    net/mac80211/mlme.c:5947:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_rssi_notify=E2=80=99 follows static declaration
    net/mac80211/mlme.c:5957:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_beacon_loss_notify=E2=80=99 follows static declaration
    include/linux/export.h:67:22: error: expected declaration or statement =
at end of input

Warnings:
    net/mac80211/mlme.c:3062:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    net/mac80211/mlme.c:5898:6: warning: =E2=80=98ieee80211_mgd_stop=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5867:5: warning: =E2=80=98ieee80211_mgd_disassoc=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5803:5: warning: =E2=80=98ieee80211_mgd_deauth=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5480:5: warning: =E2=80=98ieee80211_mgd_assoc=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5330:5: warning: =E2=80=98ieee80211_mgd_auth=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4834:6: warning: =E2=80=98ieee80211_mlme_notify_sca=
n_completed=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4795:6: warning: =E2=80=98ieee80211_sta_setup_sdata=
=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4770:6: warning: =E2=80=98ieee80211_sta_restart=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4710:6: warning: =E2=80=98ieee80211_mgd_quiesce=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4492:6: warning: =E2=80=98ieee80211_sta_work=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4480:6: warning: =E2=80=98ieee80211_mgd_conn_tx_sta=
tus=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4254:6: warning: =E2=80=98ieee80211_sta_rx_queued_m=
gmt=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4234:6: warning: =E2=80=98ieee80211_sta_rx_queued_e=
xt=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
gcw0_defconfig (mips, gcc-10) =E2=80=94 FAIL, 28 errors, 16 warnings, 0 sec=
tion mismatches

Errors:
    net/mac80211/mlme.c:3116:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_deauth=E2=80=99
    net/mac80211/mlme.c:3164:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_disassoc=E2=80=99
    net/mac80211/mlme.c:3195:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_rates=E2=80=99
    net/mac80211/mlme.c:3245:13: error: invalid storage class for function =
=E2=80=98ieee80211_twt_req_supported=E2=80=99
    net/mac80211/mlme.c:3258:12: error: invalid storage class for function =
=E2=80=98ieee80211_recalc_twt_req=E2=80=99
    net/mac80211/mlme.c:3271:13: error: invalid storage class for function =
=E2=80=98ieee80211_assoc_success=E2=80=99
    net/mac80211/mlme.c:3648:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_assoc_resp=E2=80=99
    net/mac80211/mlme.c:3757:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_bss_info=E2=80=99
    net/mac80211/mlme.c:3780:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_probe_resp=E2=80=99
    net/mac80211/mlme.c:3845:13: error: invalid storage class for function =
=E2=80=98ieee80211_handle_beacon_sig=E2=80=99
    net/mac80211/mlme.c:3941:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_our_beacon=E2=80=99
    net/mac80211/mlme.c:3951:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_beacon=E2=80=99
    net/mac80211/mlme.c:4344:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_timer=E2=80=99
    net/mac80211/mlme.c:4352:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_connection_lost=E2=80=99
    net/mac80211/mlme.c:4364:12: error: invalid storage class for function =
=E2=80=98ieee80211_auth=E2=80=99
    net/mac80211/mlme.c:4439:12: error: invalid storage class for function =
=E2=80=98ieee80211_do_assoc=E2=80=99
    net/mac80211/mlme.c:4639:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_bcn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4656:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_conn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4688:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_monitor_work=E2=80=99
    net/mac80211/mlme.c:4697:13: error: invalid storage class for function =
=E2=80=98ieee80211_restart_sta_timer=E2=80=99
    net/mac80211/mlme.c:4847:11: error: invalid storage class for function =
=E2=80=98ieee80211_ht_vht_rx_chains=E2=80=99
    net/mac80211/mlme.c:4892:1: error: invalid storage class for function =
=E2=80=98ieee80211_verify_sta_he_mcs_support=E2=80=99
    net/mac80211/mlme.c:4953:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_channel=E2=80=99
    net/mac80211/mlme.c:5122:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_dtim=E2=80=99
    net/mac80211/mlme.c:5156:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_connection=E2=80=99
    net/mac80211/mlme.c:5947:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_rssi_notify=E2=80=99 follows static declaration
    net/mac80211/mlme.c:5957:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_beacon_loss_notify=E2=80=99 follows static declaration
    include/linux/export.h:67:22: error: expected declaration or statement =
at end of input

Warnings:
    net/mac80211/mlme.c:3062:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    net/mac80211/mlme.c:5898:6: warning: =E2=80=98ieee80211_mgd_stop=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5867:5: warning: =E2=80=98ieee80211_mgd_disassoc=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5803:5: warning: =E2=80=98ieee80211_mgd_deauth=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5480:5: warning: =E2=80=98ieee80211_mgd_assoc=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5330:5: warning: =E2=80=98ieee80211_mgd_auth=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4834:6: warning: =E2=80=98ieee80211_mlme_notify_sca=
n_completed=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4795:6: warning: =E2=80=98ieee80211_sta_setup_sdata=
=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4770:6: warning: =E2=80=98ieee80211_sta_restart=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4710:6: warning: =E2=80=98ieee80211_mgd_quiesce=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4492:6: warning: =E2=80=98ieee80211_sta_work=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4480:6: warning: =E2=80=98ieee80211_mgd_conn_tx_sta=
tus=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4254:6: warning: =E2=80=98ieee80211_sta_rx_queued_m=
gmt=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4234:6: warning: =E2=80=98ieee80211_sta_rx_queued_e=
xt=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
gemini_defconfig (arm, gcc-10) =E2=80=94 FAIL, 26 errors, 17 warnings, 0 se=
ction mismatches

Errors:
    net/mac80211/mlme.c:3116:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_deauth=E2=80=99
    net/mac80211/mlme.c:3164:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_disassoc=E2=80=99
    net/mac80211/mlme.c:3195:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_rates=E2=80=99
    net/mac80211/mlme.c:3245:13: error: invalid storage class for function =
=E2=80=98ieee80211_twt_req_supported=E2=80=99
    net/mac80211/mlme.c:3258:12: error: invalid storage class for function =
=E2=80=98ieee80211_recalc_twt_req=E2=80=99
    net/mac80211/mlme.c:3271:13: error: invalid storage class for function =
=E2=80=98ieee80211_assoc_success=E2=80=99
    net/mac80211/mlme.c:3648:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_assoc_resp=E2=80=99
    net/mac80211/mlme.c:3757:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_bss_info=E2=80=99
    net/mac80211/mlme.c:3780:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_probe_resp=E2=80=99
    net/mac80211/mlme.c:3845:13: error: invalid storage class for function =
=E2=80=98ieee80211_handle_beacon_sig=E2=80=99
    net/mac80211/mlme.c:3941:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_our_beacon=E2=80=99
    net/mac80211/mlme.c:3951:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_beacon=E2=80=99
    net/mac80211/mlme.c:4344:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_timer=E2=80=99
    net/mac80211/mlme.c:4352:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_connection_lost=E2=80=99
    net/mac80211/mlme.c:4364:12: error: invalid storage class for function =
=E2=80=98ieee80211_auth=E2=80=99
    net/mac80211/mlme.c:4439:12: error: invalid storage class for function =
=E2=80=98ieee80211_do_assoc=E2=80=99
    net/mac80211/mlme.c:4639:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_bcn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4656:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_conn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4688:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_monitor_work=E2=80=99
    net/mac80211/mlme.c:4697:13: error: invalid storage class for function =
=E2=80=98ieee80211_restart_sta_timer=E2=80=99
    net/mac80211/mlme.c:4847:11: error: invalid storage class for function =
=E2=80=98ieee80211_ht_vht_rx_chains=E2=80=99
    net/mac80211/mlme.c:4892:1: error: invalid storage class for function =
=E2=80=98ieee80211_verify_sta_he_mcs_support=E2=80=99
    net/mac80211/mlme.c:4953:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_channel=E2=80=99
    net/mac80211/mlme.c:5122:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_dtim=E2=80=99
    net/mac80211/mlme.c:5156:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_connection=E2=80=99
    net/mac80211/mlme.c:5957:1: error: expected declaration or statement at=
 end of input

Warnings:
    net/mac80211/mlme.c:3062:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    net/mac80211/mlme.c:5949:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    net/mac80211/mlme.c:5949:6: warning: =E2=80=98ieee80211_cqm_beacon_loss=
_notify=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5936:6: warning: =E2=80=98ieee80211_cqm_rssi_notify=
=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5898:6: warning: =E2=80=98ieee80211_mgd_stop=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5867:5: warning: =E2=80=98ieee80211_mgd_disassoc=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5803:5: warning: =E2=80=98ieee80211_mgd_deauth=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5480:5: warning: =E2=80=98ieee80211_mgd_assoc=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5330:5: warning: =E2=80=98ieee80211_mgd_auth=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4834:6: warning: =E2=80=98ieee80211_mlme_notify_sca=
n_completed=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4795:6: warning: =E2=80=98ieee80211_sta_setup_sdata=
=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4770:6: warning: =E2=80=98ieee80211_sta_restart=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4710:6: warning: =E2=80=98ieee80211_mgd_quiesce=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4492:6: warning: =E2=80=98ieee80211_sta_work=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4480:6: warning: =E2=80=98ieee80211_mgd_conn_tx_sta=
tus=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4254:6: warning: =E2=80=98ieee80211_sta_rx_queued_m=
gmt=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4234:6: warning: =E2=80=98ieee80211_sta_rx_queued_e=
xt=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
gpr_defconfig (mips, gcc-10) =E2=80=94 FAIL, 28 errors, 16 warnings, 0 sect=
ion mismatches

Errors:
    net/mac80211/mlme.c:3116:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_deauth=E2=80=99
    net/mac80211/mlme.c:3164:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_disassoc=E2=80=99
    net/mac80211/mlme.c:3195:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_rates=E2=80=99
    net/mac80211/mlme.c:3245:13: error: invalid storage class for function =
=E2=80=98ieee80211_twt_req_supported=E2=80=99
    net/mac80211/mlme.c:3258:12: error: invalid storage class for function =
=E2=80=98ieee80211_recalc_twt_req=E2=80=99
    net/mac80211/mlme.c:3271:13: error: invalid storage class for function =
=E2=80=98ieee80211_assoc_success=E2=80=99
    net/mac80211/mlme.c:3648:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_assoc_resp=E2=80=99
    net/mac80211/mlme.c:3757:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_bss_info=E2=80=99
    net/mac80211/mlme.c:3780:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_probe_resp=E2=80=99
    net/mac80211/mlme.c:3845:13: error: invalid storage class for function =
=E2=80=98ieee80211_handle_beacon_sig=E2=80=99
    net/mac80211/mlme.c:3941:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_our_beacon=E2=80=99
    net/mac80211/mlme.c:3951:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_beacon=E2=80=99
    net/mac80211/mlme.c:4344:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_timer=E2=80=99
    net/mac80211/mlme.c:4352:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_connection_lost=E2=80=99
    net/mac80211/mlme.c:4364:12: error: invalid storage class for function =
=E2=80=98ieee80211_auth=E2=80=99
    net/mac80211/mlme.c:4439:12: error: invalid storage class for function =
=E2=80=98ieee80211_do_assoc=E2=80=99
    net/mac80211/mlme.c:4639:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_bcn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4656:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_conn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4688:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_monitor_work=E2=80=99
    net/mac80211/mlme.c:4697:13: error: invalid storage class for function =
=E2=80=98ieee80211_restart_sta_timer=E2=80=99
    net/mac80211/mlme.c:4847:11: error: invalid storage class for function =
=E2=80=98ieee80211_ht_vht_rx_chains=E2=80=99
    net/mac80211/mlme.c:4892:1: error: invalid storage class for function =
=E2=80=98ieee80211_verify_sta_he_mcs_support=E2=80=99
    net/mac80211/mlme.c:4953:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_channel=E2=80=99
    net/mac80211/mlme.c:5122:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_dtim=E2=80=99
    net/mac80211/mlme.c:5156:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_connection=E2=80=99
    net/mac80211/mlme.c:5947:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_rssi_notify=E2=80=99 follows static declaration
    net/mac80211/mlme.c:5957:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_beacon_loss_notify=E2=80=99 follows static declaration
    include/linux/export.h:67:22: error: expected declaration or statement =
at end of input

Warnings:
    net/mac80211/mlme.c:3062:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    net/mac80211/mlme.c:5898:6: warning: =E2=80=98ieee80211_mgd_stop=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5867:5: warning: =E2=80=98ieee80211_mgd_disassoc=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5803:5: warning: =E2=80=98ieee80211_mgd_deauth=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5480:5: warning: =E2=80=98ieee80211_mgd_assoc=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5330:5: warning: =E2=80=98ieee80211_mgd_auth=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4834:6: warning: =E2=80=98ieee80211_mlme_notify_sca=
n_completed=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4795:6: warning: =E2=80=98ieee80211_sta_setup_sdata=
=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4770:6: warning: =E2=80=98ieee80211_sta_restart=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4710:6: warning: =E2=80=98ieee80211_mgd_quiesce=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4492:6: warning: =E2=80=98ieee80211_sta_work=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4480:6: warning: =E2=80=98ieee80211_mgd_conn_tx_sta=
tus=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4254:6: warning: =E2=80=98ieee80211_sta_rx_queued_m=
gmt=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4234:6: warning: =E2=80=98ieee80211_sta_rx_queued_e=
xt=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
h3600_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xcb84): Section mismatch in referenc=
e from the function __arm_ioremap_pfn_caller() to the function .meminit.tex=
t:memblock_is_map_memory()

---------------------------------------------------------------------------=
-----
h5000_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
hackkit_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xce9c): Section mismatch in referenc=
e from the function __arm_ioremap_pfn_caller() to the function .meminit.tex=
t:memblock_is_map_memory()

---------------------------------------------------------------------------=
-----
haps_hs_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
haps_hs_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
hisi_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
hsdk_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
i386_defconfig (i386, gcc-10) =E2=80=94 FAIL, 28 errors, 21 warnings, 0 sec=
tion mismatches

Errors:
    net/mac80211/mlme.c:3116:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_deauth=E2=80=99
    net/mac80211/mlme.c:3164:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_disassoc=E2=80=99
    net/mac80211/mlme.c:3195:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_rates=E2=80=99
    net/mac80211/mlme.c:3245:13: error: invalid storage class for function =
=E2=80=98ieee80211_twt_req_supported=E2=80=99
    net/mac80211/mlme.c:3258:12: error: invalid storage class for function =
=E2=80=98ieee80211_recalc_twt_req=E2=80=99
    net/mac80211/mlme.c:3271:13: error: invalid storage class for function =
=E2=80=98ieee80211_assoc_success=E2=80=99
    net/mac80211/mlme.c:3648:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_assoc_resp=E2=80=99
    net/mac80211/mlme.c:3757:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_bss_info=E2=80=99
    net/mac80211/mlme.c:3780:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_probe_resp=E2=80=99
    net/mac80211/mlme.c:3845:13: error: invalid storage class for function =
=E2=80=98ieee80211_handle_beacon_sig=E2=80=99
    net/mac80211/mlme.c:3941:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_our_beacon=E2=80=99
    net/mac80211/mlme.c:3951:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_beacon=E2=80=99
    net/mac80211/mlme.c:4344:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_timer=E2=80=99
    net/mac80211/mlme.c:4352:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_connection_lost=E2=80=99
    net/mac80211/mlme.c:4364:12: error: invalid storage class for function =
=E2=80=98ieee80211_auth=E2=80=99
    net/mac80211/mlme.c:4439:12: error: invalid storage class for function =
=E2=80=98ieee80211_do_assoc=E2=80=99
    net/mac80211/mlme.c:4639:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_bcn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4656:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_conn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4688:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_monitor_work=E2=80=99
    net/mac80211/mlme.c:4697:13: error: invalid storage class for function =
=E2=80=98ieee80211_restart_sta_timer=E2=80=99
    net/mac80211/mlme.c:4847:11: error: invalid storage class for function =
=E2=80=98ieee80211_ht_vht_rx_chains=E2=80=99
    net/mac80211/mlme.c:4892:1: error: invalid storage class for function =
=E2=80=98ieee80211_verify_sta_he_mcs_support=E2=80=99
    net/mac80211/mlme.c:4953:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_channel=E2=80=99
    net/mac80211/mlme.c:5122:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_dtim=E2=80=99
    net/mac80211/mlme.c:5156:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_connection=E2=80=99
    net/mac80211/mlme.c:5947:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_rssi_notify=E2=80=99 follows static declaration
    net/mac80211/mlme.c:5957:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_beacon_loss_notify=E2=80=99 follows static declaration
    net/mac80211/mlme.c:5957:1: error: expected declaration or statement at=
 end of input

Warnings:
    net/mac80211/mlme.c:3062:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    include/linux/compiler.h:225:2: warning: ISO C90 forbids mixed declarat=
ions and code [-Wdeclaration-after-statement]
    net/mac80211/mlme.c:5949:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    include/linux/compiler.h:225:2: warning: ISO C90 forbids mixed declarat=
ions and code [-Wdeclaration-after-statement]
    include/linux/export.h:100:20: warning: unused variable =E2=80=98__kstr=
tabns_ieee80211_cqm_beacon_loss_notify=E2=80=99 [-Wunused-variable]
    include/linux/export.h:99:20: warning: unused variable =E2=80=98__kstrt=
ab_ieee80211_cqm_beacon_loss_notify=E2=80=99 [-Wunused-variable]
    include/linux/export.h:100:20: warning: unused variable =E2=80=98__kstr=
tabns_ieee80211_cqm_rssi_notify=E2=80=99 [-Wunused-variable]
    include/linux/export.h:99:20: warning: unused variable =E2=80=98__kstrt=
ab_ieee80211_cqm_rssi_notify=E2=80=99 [-Wunused-variable]
    net/mac80211/mlme.c:5898:6: warning: =E2=80=98ieee80211_mgd_stop=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5867:5: warning: =E2=80=98ieee80211_mgd_disassoc=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5803:5: warning: =E2=80=98ieee80211_mgd_deauth=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5480:5: warning: =E2=80=98ieee80211_mgd_assoc=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5330:5: warning: =E2=80=98ieee80211_mgd_auth=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4834:6: warning: =E2=80=98ieee80211_mlme_notify_sca=
n_completed=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4795:6: warning: =E2=80=98ieee80211_sta_setup_sdata=
=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4770:6: warning: =E2=80=98ieee80211_sta_restart=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4710:6: warning: =E2=80=98ieee80211_mgd_quiesce=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4492:6: warning: =E2=80=98ieee80211_sta_work=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4480:6: warning: =E2=80=98ieee80211_mgd_conn_tx_sta=
tus=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4254:6: warning: =E2=80=98ieee80211_sta_rx_queued_m=
gmt=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4234:6: warning: =E2=80=98ieee80211_sta_rx_queued_e=
xt=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
imote2_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
imx_v4_v5_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
imx_v6_v7_defconfig (arm, gcc-10) =E2=80=94 FAIL, 28 errors, 16 warnings, 0=
 section mismatches

Errors:
    net/mac80211/mlme.c:3116:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_deauth=E2=80=99
    net/mac80211/mlme.c:3164:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_disassoc=E2=80=99
    net/mac80211/mlme.c:3195:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_rates=E2=80=99
    net/mac80211/mlme.c:3245:13: error: invalid storage class for function =
=E2=80=98ieee80211_twt_req_supported=E2=80=99
    net/mac80211/mlme.c:3258:12: error: invalid storage class for function =
=E2=80=98ieee80211_recalc_twt_req=E2=80=99
    net/mac80211/mlme.c:3271:13: error: invalid storage class for function =
=E2=80=98ieee80211_assoc_success=E2=80=99
    net/mac80211/mlme.c:3648:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_assoc_resp=E2=80=99
    net/mac80211/mlme.c:3757:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_bss_info=E2=80=99
    net/mac80211/mlme.c:3780:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_probe_resp=E2=80=99
    net/mac80211/mlme.c:3845:13: error: invalid storage class for function =
=E2=80=98ieee80211_handle_beacon_sig=E2=80=99
    net/mac80211/mlme.c:3941:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_our_beacon=E2=80=99
    net/mac80211/mlme.c:3951:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_beacon=E2=80=99
    net/mac80211/mlme.c:4344:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_timer=E2=80=99
    net/mac80211/mlme.c:4352:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_connection_lost=E2=80=99
    net/mac80211/mlme.c:4364:12: error: invalid storage class for function =
=E2=80=98ieee80211_auth=E2=80=99
    net/mac80211/mlme.c:4439:12: error: invalid storage class for function =
=E2=80=98ieee80211_do_assoc=E2=80=99
    net/mac80211/mlme.c:4639:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_bcn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4656:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_conn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4688:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_monitor_work=E2=80=99
    net/mac80211/mlme.c:4697:13: error: invalid storage class for function =
=E2=80=98ieee80211_restart_sta_timer=E2=80=99
    net/mac80211/mlme.c:4847:11: error: invalid storage class for function =
=E2=80=98ieee80211_ht_vht_rx_chains=E2=80=99
    net/mac80211/mlme.c:4892:1: error: invalid storage class for function =
=E2=80=98ieee80211_verify_sta_he_mcs_support=E2=80=99
    net/mac80211/mlme.c:4953:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_channel=E2=80=99
    net/mac80211/mlme.c:5122:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_dtim=E2=80=99
    net/mac80211/mlme.c:5156:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_connection=E2=80=99
    net/mac80211/mlme.c:5947:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_rssi_notify=E2=80=99 follows static declaration
    net/mac80211/mlme.c:5957:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_beacon_loss_notify=E2=80=99 follows static declaration
    include/linux/export.h:67:22: error: expected declaration or statement =
at end of input

Warnings:
    net/mac80211/mlme.c:3062:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    net/mac80211/mlme.c:5898:6: warning: =E2=80=98ieee80211_mgd_stop=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5867:5: warning: =E2=80=98ieee80211_mgd_disassoc=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5803:5: warning: =E2=80=98ieee80211_mgd_deauth=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5480:5: warning: =E2=80=98ieee80211_mgd_assoc=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5330:5: warning: =E2=80=98ieee80211_mgd_auth=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4834:6: warning: =E2=80=98ieee80211_mlme_notify_sca=
n_completed=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4795:6: warning: =E2=80=98ieee80211_sta_setup_sdata=
=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4770:6: warning: =E2=80=98ieee80211_sta_restart=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4710:6: warning: =E2=80=98ieee80211_mgd_quiesce=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4492:6: warning: =E2=80=98ieee80211_sta_work=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4480:6: warning: =E2=80=98ieee80211_mgd_conn_tx_sta=
tus=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4254:6: warning: =E2=80=98ieee80211_sta_rx_queued_m=
gmt=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4234:6: warning: =E2=80=98ieee80211_sta_rx_queued_e=
xt=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
integrator_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
ip22_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ip27_defconfig (mips, gcc-10) =E2=80=94 FAIL, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ip28_defconfig (mips, gcc-10) =E2=80=94 FAIL, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
jmr3927_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
jornada720_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xcaa8): Section mismatch in referenc=
e from the function __arm_ioremap_pfn_caller() to the function .meminit.tex=
t:memblock_is_map_memory()

---------------------------------------------------------------------------=
-----
keystone_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
lart_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xcb74): Section mismatch in referenc=
e from the function __arm_ioremap_pfn_caller() to the function .meminit.tex=
t:memblock_is_map_memory()

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-10) =E2=80=94 FAIL, 28 errors, 16 warnings, 0=
 section mismatches

Errors:
    net/mac80211/mlme.c:3116:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_deauth=E2=80=99
    net/mac80211/mlme.c:3164:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_disassoc=E2=80=99
    net/mac80211/mlme.c:3195:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_rates=E2=80=99
    net/mac80211/mlme.c:3245:13: error: invalid storage class for function =
=E2=80=98ieee80211_twt_req_supported=E2=80=99
    net/mac80211/mlme.c:3258:12: error: invalid storage class for function =
=E2=80=98ieee80211_recalc_twt_req=E2=80=99
    net/mac80211/mlme.c:3271:13: error: invalid storage class for function =
=E2=80=98ieee80211_assoc_success=E2=80=99
    net/mac80211/mlme.c:3648:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_assoc_resp=E2=80=99
    net/mac80211/mlme.c:3757:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_bss_info=E2=80=99
    net/mac80211/mlme.c:3780:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_probe_resp=E2=80=99
    net/mac80211/mlme.c:3845:13: error: invalid storage class for function =
=E2=80=98ieee80211_handle_beacon_sig=E2=80=99
    net/mac80211/mlme.c:3941:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_our_beacon=E2=80=99
    net/mac80211/mlme.c:3951:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_beacon=E2=80=99
    net/mac80211/mlme.c:4344:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_timer=E2=80=99
    net/mac80211/mlme.c:4352:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_connection_lost=E2=80=99
    net/mac80211/mlme.c:4364:12: error: invalid storage class for function =
=E2=80=98ieee80211_auth=E2=80=99
    net/mac80211/mlme.c:4439:12: error: invalid storage class for function =
=E2=80=98ieee80211_do_assoc=E2=80=99
    net/mac80211/mlme.c:4639:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_bcn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4656:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_conn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4688:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_monitor_work=E2=80=99
    net/mac80211/mlme.c:4697:13: error: invalid storage class for function =
=E2=80=98ieee80211_restart_sta_timer=E2=80=99
    net/mac80211/mlme.c:4847:11: error: invalid storage class for function =
=E2=80=98ieee80211_ht_vht_rx_chains=E2=80=99
    net/mac80211/mlme.c:4892:1: error: invalid storage class for function =
=E2=80=98ieee80211_verify_sta_he_mcs_support=E2=80=99
    net/mac80211/mlme.c:4953:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_channel=E2=80=99
    net/mac80211/mlme.c:5122:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_dtim=E2=80=99
    net/mac80211/mlme.c:5156:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_connection=E2=80=99
    net/mac80211/mlme.c:5947:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_rssi_notify=E2=80=99 follows static declaration
    net/mac80211/mlme.c:5957:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_beacon_loss_notify=E2=80=99 follows static declaration
    include/linux/export.h:67:22: error: expected declaration or statement =
at end of input

Warnings:
    net/mac80211/mlme.c:3062:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    net/mac80211/mlme.c:5898:6: warning: =E2=80=98ieee80211_mgd_stop=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5867:5: warning: =E2=80=98ieee80211_mgd_disassoc=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5803:5: warning: =E2=80=98ieee80211_mgd_deauth=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5480:5: warning: =E2=80=98ieee80211_mgd_assoc=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5330:5: warning: =E2=80=98ieee80211_mgd_auth=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4834:6: warning: =E2=80=98ieee80211_mlme_notify_sca=
n_completed=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4795:6: warning: =E2=80=98ieee80211_sta_setup_sdata=
=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4770:6: warning: =E2=80=98ieee80211_sta_restart=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4710:6: warning: =E2=80=98ieee80211_mgd_quiesce=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4492:6: warning: =E2=80=98ieee80211_sta_work=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4480:6: warning: =E2=80=98ieee80211_mgd_conn_tx_sta=
tus=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4254:6: warning: =E2=80=98ieee80211_sta_rx_queued_m=
gmt=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4234:6: warning: =E2=80=98ieee80211_sta_rx_queued_e=
xt=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
loongson1b_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
loongson1c_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-10) =E2=80=94 FAIL, 28 errors, 16 warnings, =
0 section mismatches

Errors:
    net/mac80211/mlme.c:3116:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_deauth=E2=80=99
    net/mac80211/mlme.c:3164:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_disassoc=E2=80=99
    net/mac80211/mlme.c:3195:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_rates=E2=80=99
    net/mac80211/mlme.c:3245:13: error: invalid storage class for function =
=E2=80=98ieee80211_twt_req_supported=E2=80=99
    net/mac80211/mlme.c:3258:12: error: invalid storage class for function =
=E2=80=98ieee80211_recalc_twt_req=E2=80=99
    net/mac80211/mlme.c:3271:13: error: invalid storage class for function =
=E2=80=98ieee80211_assoc_success=E2=80=99
    net/mac80211/mlme.c:3648:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_assoc_resp=E2=80=99
    net/mac80211/mlme.c:3757:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_bss_info=E2=80=99
    net/mac80211/mlme.c:3780:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_probe_resp=E2=80=99
    net/mac80211/mlme.c:3845:13: error: invalid storage class for function =
=E2=80=98ieee80211_handle_beacon_sig=E2=80=99
    net/mac80211/mlme.c:3941:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_our_beacon=E2=80=99
    net/mac80211/mlme.c:3951:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_beacon=E2=80=99
    net/mac80211/mlme.c:4344:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_timer=E2=80=99
    net/mac80211/mlme.c:4352:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_connection_lost=E2=80=99
    net/mac80211/mlme.c:4364:12: error: invalid storage class for function =
=E2=80=98ieee80211_auth=E2=80=99
    net/mac80211/mlme.c:4439:12: error: invalid storage class for function =
=E2=80=98ieee80211_do_assoc=E2=80=99
    net/mac80211/mlme.c:4639:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_bcn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4656:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_conn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4688:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_monitor_work=E2=80=99
    net/mac80211/mlme.c:4697:13: error: invalid storage class for function =
=E2=80=98ieee80211_restart_sta_timer=E2=80=99
    net/mac80211/mlme.c:4847:11: error: invalid storage class for function =
=E2=80=98ieee80211_ht_vht_rx_chains=E2=80=99
    net/mac80211/mlme.c:4892:1: error: invalid storage class for function =
=E2=80=98ieee80211_verify_sta_he_mcs_support=E2=80=99
    net/mac80211/mlme.c:4953:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_channel=E2=80=99
    net/mac80211/mlme.c:5122:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_dtim=E2=80=99
    net/mac80211/mlme.c:5156:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_connection=E2=80=99
    net/mac80211/mlme.c:5947:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_rssi_notify=E2=80=99 follows static declaration
    net/mac80211/mlme.c:5957:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_beacon_loss_notify=E2=80=99 follows static declaration
    include/linux/export.h:67:22: error: expected declaration or statement =
at end of input

Warnings:
    net/mac80211/mlme.c:3062:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    net/mac80211/mlme.c:5898:6: warning: =E2=80=98ieee80211_mgd_stop=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5867:5: warning: =E2=80=98ieee80211_mgd_disassoc=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5803:5: warning: =E2=80=98ieee80211_mgd_deauth=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5480:5: warning: =E2=80=98ieee80211_mgd_assoc=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5330:5: warning: =E2=80=98ieee80211_mgd_auth=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4834:6: warning: =E2=80=98ieee80211_mlme_notify_sca=
n_completed=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4795:6: warning: =E2=80=98ieee80211_sta_setup_sdata=
=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4770:6: warning: =E2=80=98ieee80211_sta_restart=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4710:6: warning: =E2=80=98ieee80211_mgd_quiesce=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4492:6: warning: =E2=80=98ieee80211_sta_work=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4480:6: warning: =E2=80=98ieee80211_mgd_conn_tx_sta=
tus=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4254:6: warning: =E2=80=98ieee80211_sta_rx_queued_m=
gmt=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4234:6: warning: =E2=80=98ieee80211_sta_rx_queued_e=
xt=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
lpc18xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
lpc32xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
lpd270_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
lubbock_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
magician_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
mainstone_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
malta_defconfig (mips, gcc-10) =E2=80=94 FAIL, 28 errors, 14 warnings, 0 se=
ction mismatches

Errors:
    net/mac80211/mlme.c:3116:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_deauth=E2=80=99
    net/mac80211/mlme.c:3164:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_disassoc=E2=80=99
    net/mac80211/mlme.c:3195:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_rates=E2=80=99
    net/mac80211/mlme.c:3245:13: error: invalid storage class for function =
=E2=80=98ieee80211_twt_req_supported=E2=80=99
    net/mac80211/mlme.c:3258:12: error: invalid storage class for function =
=E2=80=98ieee80211_recalc_twt_req=E2=80=99
    net/mac80211/mlme.c:3271:13: error: invalid storage class for function =
=E2=80=98ieee80211_assoc_success=E2=80=99
    net/mac80211/mlme.c:3648:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_assoc_resp=E2=80=99
    net/mac80211/mlme.c:3757:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_bss_info=E2=80=99
    net/mac80211/mlme.c:3780:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_probe_resp=E2=80=99
    net/mac80211/mlme.c:3845:13: error: invalid storage class for function =
=E2=80=98ieee80211_handle_beacon_sig=E2=80=99
    net/mac80211/mlme.c:3941:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_our_beacon=E2=80=99
    net/mac80211/mlme.c:3951:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_beacon=E2=80=99
    net/mac80211/mlme.c:4344:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_timer=E2=80=99
    net/mac80211/mlme.c:4352:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_connection_lost=E2=80=99
    net/mac80211/mlme.c:4364:12: error: invalid storage class for function =
=E2=80=98ieee80211_auth=E2=80=99
    net/mac80211/mlme.c:4439:12: error: invalid storage class for function =
=E2=80=98ieee80211_do_assoc=E2=80=99
    net/mac80211/mlme.c:4639:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_bcn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4656:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_conn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4688:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_monitor_work=E2=80=99
    net/mac80211/mlme.c:4697:13: error: invalid storage class for function =
=E2=80=98ieee80211_restart_sta_timer=E2=80=99
    net/mac80211/mlme.c:4847:11: error: invalid storage class for function =
=E2=80=98ieee80211_ht_vht_rx_chains=E2=80=99
    net/mac80211/mlme.c:4892:1: error: invalid storage class for function =
=E2=80=98ieee80211_verify_sta_he_mcs_support=E2=80=99
    net/mac80211/mlme.c:4953:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_channel=E2=80=99
    net/mac80211/mlme.c:5122:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_dtim=E2=80=99
    net/mac80211/mlme.c:5156:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_connection=E2=80=99
    net/mac80211/mlme.c:5947:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_rssi_notify=E2=80=99 follows static declaration
    net/mac80211/mlme.c:5957:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_beacon_loss_notify=E2=80=99 follows static declaration
    include/linux/export.h:67:22: error: expected declaration or statement =
at end of input

Warnings:
    net/mac80211/mlme.c:3062:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    net/mac80211/mlme.c:5898:6: warning: =E2=80=98ieee80211_mgd_stop=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5867:5: warning: =E2=80=98ieee80211_mgd_disassoc=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5803:5: warning: =E2=80=98ieee80211_mgd_deauth=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5480:5: warning: =E2=80=98ieee80211_mgd_assoc=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5330:5: warning: =E2=80=98ieee80211_mgd_auth=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4834:6: warning: =E2=80=98ieee80211_mlme_notify_sca=
n_completed=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4795:6: warning: =E2=80=98ieee80211_sta_setup_sdata=
=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4492:6: warning: =E2=80=98ieee80211_sta_work=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4480:6: warning: =E2=80=98ieee80211_mgd_conn_tx_sta=
tus=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4254:6: warning: =E2=80=98ieee80211_sta_rx_queued_m=
gmt=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4234:6: warning: =E2=80=98ieee80211_sta_rx_queued_e=
xt=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-10) =E2=80=94 FAIL, 28 errors, 14 warnings, =
0 section mismatches

Errors:
    net/mac80211/mlme.c:3116:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_deauth=E2=80=99
    net/mac80211/mlme.c:3164:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_disassoc=E2=80=99
    net/mac80211/mlme.c:3195:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_rates=E2=80=99
    net/mac80211/mlme.c:3245:13: error: invalid storage class for function =
=E2=80=98ieee80211_twt_req_supported=E2=80=99
    net/mac80211/mlme.c:3258:12: error: invalid storage class for function =
=E2=80=98ieee80211_recalc_twt_req=E2=80=99
    net/mac80211/mlme.c:3271:13: error: invalid storage class for function =
=E2=80=98ieee80211_assoc_success=E2=80=99
    net/mac80211/mlme.c:3648:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_assoc_resp=E2=80=99
    net/mac80211/mlme.c:3757:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_bss_info=E2=80=99
    net/mac80211/mlme.c:3780:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_probe_resp=E2=80=99
    net/mac80211/mlme.c:3845:13: error: invalid storage class for function =
=E2=80=98ieee80211_handle_beacon_sig=E2=80=99
    net/mac80211/mlme.c:3941:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_our_beacon=E2=80=99
    net/mac80211/mlme.c:3951:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_beacon=E2=80=99
    net/mac80211/mlme.c:4344:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_timer=E2=80=99
    net/mac80211/mlme.c:4352:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_connection_lost=E2=80=99
    net/mac80211/mlme.c:4364:12: error: invalid storage class for function =
=E2=80=98ieee80211_auth=E2=80=99
    net/mac80211/mlme.c:4439:12: error: invalid storage class for function =
=E2=80=98ieee80211_do_assoc=E2=80=99
    net/mac80211/mlme.c:4639:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_bcn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4656:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_conn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4688:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_monitor_work=E2=80=99
    net/mac80211/mlme.c:4697:13: error: invalid storage class for function =
=E2=80=98ieee80211_restart_sta_timer=E2=80=99
    net/mac80211/mlme.c:4847:11: error: invalid storage class for function =
=E2=80=98ieee80211_ht_vht_rx_chains=E2=80=99
    net/mac80211/mlme.c:4892:1: error: invalid storage class for function =
=E2=80=98ieee80211_verify_sta_he_mcs_support=E2=80=99
    net/mac80211/mlme.c:4953:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_channel=E2=80=99
    net/mac80211/mlme.c:5122:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_dtim=E2=80=99
    net/mac80211/mlme.c:5156:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_connection=E2=80=99
    net/mac80211/mlme.c:5947:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_rssi_notify=E2=80=99 follows static declaration
    net/mac80211/mlme.c:5957:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_beacon_loss_notify=E2=80=99 follows static declaration
    include/linux/export.h:67:22: error: expected declaration or statement =
at end of input

Warnings:
    net/mac80211/mlme.c:3062:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    net/mac80211/mlme.c:5898:6: warning: =E2=80=98ieee80211_mgd_stop=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5867:5: warning: =E2=80=98ieee80211_mgd_disassoc=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5803:5: warning: =E2=80=98ieee80211_mgd_deauth=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5480:5: warning: =E2=80=98ieee80211_mgd_assoc=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5330:5: warning: =E2=80=98ieee80211_mgd_auth=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4834:6: warning: =E2=80=98ieee80211_mlme_notify_sca=
n_completed=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4795:6: warning: =E2=80=98ieee80211_sta_setup_sdata=
=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4492:6: warning: =E2=80=98ieee80211_sta_work=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4480:6: warning: =E2=80=98ieee80211_mgd_conn_tx_sta=
tus=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4254:6: warning: =E2=80=98ieee80211_sta_rx_queued_m=
gmt=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4234:6: warning: =E2=80=98ieee80211_sta_rx_queued_e=
xt=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
malta_kvm_guest_defconfig (mips, gcc-10) =E2=80=94 FAIL, 28 errors, 16 warn=
ings, 0 section mismatches

Errors:
    net/mac80211/mlme.c:3116:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_deauth=E2=80=99
    net/mac80211/mlme.c:3164:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_disassoc=E2=80=99
    net/mac80211/mlme.c:3195:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_rates=E2=80=99
    net/mac80211/mlme.c:3245:13: error: invalid storage class for function =
=E2=80=98ieee80211_twt_req_supported=E2=80=99
    net/mac80211/mlme.c:3258:12: error: invalid storage class for function =
=E2=80=98ieee80211_recalc_twt_req=E2=80=99
    net/mac80211/mlme.c:3271:13: error: invalid storage class for function =
=E2=80=98ieee80211_assoc_success=E2=80=99
    net/mac80211/mlme.c:3648:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_assoc_resp=E2=80=99
    net/mac80211/mlme.c:3757:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_bss_info=E2=80=99
    net/mac80211/mlme.c:3780:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_probe_resp=E2=80=99
    net/mac80211/mlme.c:3845:13: error: invalid storage class for function =
=E2=80=98ieee80211_handle_beacon_sig=E2=80=99
    net/mac80211/mlme.c:3941:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_our_beacon=E2=80=99
    net/mac80211/mlme.c:3951:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_beacon=E2=80=99
    net/mac80211/mlme.c:4344:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_timer=E2=80=99
    net/mac80211/mlme.c:4352:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_connection_lost=E2=80=99
    net/mac80211/mlme.c:4364:12: error: invalid storage class for function =
=E2=80=98ieee80211_auth=E2=80=99
    net/mac80211/mlme.c:4439:12: error: invalid storage class for function =
=E2=80=98ieee80211_do_assoc=E2=80=99
    net/mac80211/mlme.c:4639:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_bcn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4656:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_conn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4688:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_monitor_work=E2=80=99
    net/mac80211/mlme.c:4697:13: error: invalid storage class for function =
=E2=80=98ieee80211_restart_sta_timer=E2=80=99
    net/mac80211/mlme.c:4847:11: error: invalid storage class for function =
=E2=80=98ieee80211_ht_vht_rx_chains=E2=80=99
    net/mac80211/mlme.c:4892:1: error: invalid storage class for function =
=E2=80=98ieee80211_verify_sta_he_mcs_support=E2=80=99
    net/mac80211/mlme.c:4953:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_channel=E2=80=99
    net/mac80211/mlme.c:5122:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_dtim=E2=80=99
    net/mac80211/mlme.c:5156:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_connection=E2=80=99
    net/mac80211/mlme.c:5947:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_rssi_notify=E2=80=99 follows static declaration
    net/mac80211/mlme.c:5957:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_beacon_loss_notify=E2=80=99 follows static declaration
    include/linux/export.h:67:22: error: expected declaration or statement =
at end of input

Warnings:
    net/mac80211/mlme.c:3062:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    net/mac80211/mlme.c:5898:6: warning: =E2=80=98ieee80211_mgd_stop=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5867:5: warning: =E2=80=98ieee80211_mgd_disassoc=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5803:5: warning: =E2=80=98ieee80211_mgd_deauth=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5480:5: warning: =E2=80=98ieee80211_mgd_assoc=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5330:5: warning: =E2=80=98ieee80211_mgd_auth=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4834:6: warning: =E2=80=98ieee80211_mlme_notify_sca=
n_completed=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4795:6: warning: =E2=80=98ieee80211_sta_setup_sdata=
=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4770:6: warning: =E2=80=98ieee80211_sta_restart=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4710:6: warning: =E2=80=98ieee80211_mgd_quiesce=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4492:6: warning: =E2=80=98ieee80211_sta_work=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4480:6: warning: =E2=80=98ieee80211_mgd_conn_tx_sta=
tus=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4254:6: warning: =E2=80=98ieee80211_sta_rx_queued_m=
gmt=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4234:6: warning: =E2=80=98ieee80211_sta_rx_queued_e=
xt=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnin=
gs, 0 section mismatches

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-10) =E2=80=94 FAIL, 28 errors, 14 warnings=
, 0 section mismatches

Errors:
    net/mac80211/mlme.c:3116:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_deauth=E2=80=99
    net/mac80211/mlme.c:3164:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_disassoc=E2=80=99
    net/mac80211/mlme.c:3195:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_rates=E2=80=99
    net/mac80211/mlme.c:3245:13: error: invalid storage class for function =
=E2=80=98ieee80211_twt_req_supported=E2=80=99
    net/mac80211/mlme.c:3258:12: error: invalid storage class for function =
=E2=80=98ieee80211_recalc_twt_req=E2=80=99
    net/mac80211/mlme.c:3271:13: error: invalid storage class for function =
=E2=80=98ieee80211_assoc_success=E2=80=99
    net/mac80211/mlme.c:3648:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_assoc_resp=E2=80=99
    net/mac80211/mlme.c:3757:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_bss_info=E2=80=99
    net/mac80211/mlme.c:3780:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_probe_resp=E2=80=99
    net/mac80211/mlme.c:3845:13: error: invalid storage class for function =
=E2=80=98ieee80211_handle_beacon_sig=E2=80=99
    net/mac80211/mlme.c:3941:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_our_beacon=E2=80=99
    net/mac80211/mlme.c:3951:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_beacon=E2=80=99
    net/mac80211/mlme.c:4344:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_timer=E2=80=99
    net/mac80211/mlme.c:4352:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_connection_lost=E2=80=99
    net/mac80211/mlme.c:4364:12: error: invalid storage class for function =
=E2=80=98ieee80211_auth=E2=80=99
    net/mac80211/mlme.c:4439:12: error: invalid storage class for function =
=E2=80=98ieee80211_do_assoc=E2=80=99
    net/mac80211/mlme.c:4639:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_bcn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4656:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_conn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4688:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_monitor_work=E2=80=99
    net/mac80211/mlme.c:4697:13: error: invalid storage class for function =
=E2=80=98ieee80211_restart_sta_timer=E2=80=99
    net/mac80211/mlme.c:4847:11: error: invalid storage class for function =
=E2=80=98ieee80211_ht_vht_rx_chains=E2=80=99
    net/mac80211/mlme.c:4892:1: error: invalid storage class for function =
=E2=80=98ieee80211_verify_sta_he_mcs_support=E2=80=99
    net/mac80211/mlme.c:4953:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_channel=E2=80=99
    net/mac80211/mlme.c:5122:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_dtim=E2=80=99
    net/mac80211/mlme.c:5156:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_connection=E2=80=99
    net/mac80211/mlme.c:5947:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_rssi_notify=E2=80=99 follows static declaration
    net/mac80211/mlme.c:5957:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_beacon_loss_notify=E2=80=99 follows static declaration
    include/linux/export.h:67:22: error: expected declaration or statement =
at end of input

Warnings:
    net/mac80211/mlme.c:3062:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    net/mac80211/mlme.c:5898:6: warning: =E2=80=98ieee80211_mgd_stop=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5867:5: warning: =E2=80=98ieee80211_mgd_disassoc=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5803:5: warning: =E2=80=98ieee80211_mgd_deauth=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5480:5: warning: =E2=80=98ieee80211_mgd_assoc=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5330:5: warning: =E2=80=98ieee80211_mgd_auth=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4834:6: warning: =E2=80=98ieee80211_mlme_notify_sca=
n_completed=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4795:6: warning: =E2=80=98ieee80211_sta_setup_sdata=
=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4492:6: warning: =E2=80=98ieee80211_sta_work=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4480:6: warning: =E2=80=98ieee80211_mgd_conn_tx_sta=
tus=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4254:6: warning: =E2=80=98ieee80211_sta_rx_queued_m=
gmt=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4234:6: warning: =E2=80=98ieee80211_sta_rx_queued_e=
xt=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
milbeaut_m10v_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-10) =E2=80=94 FAIL, 28 errors, 16 warnings, 0 =
section mismatches

Errors:
    net/mac80211/mlme.c:3116:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_deauth=E2=80=99
    net/mac80211/mlme.c:3164:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_disassoc=E2=80=99
    net/mac80211/mlme.c:3195:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_rates=E2=80=99
    net/mac80211/mlme.c:3245:13: error: invalid storage class for function =
=E2=80=98ieee80211_twt_req_supported=E2=80=99
    net/mac80211/mlme.c:3258:12: error: invalid storage class for function =
=E2=80=98ieee80211_recalc_twt_req=E2=80=99
    net/mac80211/mlme.c:3271:13: error: invalid storage class for function =
=E2=80=98ieee80211_assoc_success=E2=80=99
    net/mac80211/mlme.c:3648:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_assoc_resp=E2=80=99
    net/mac80211/mlme.c:3757:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_bss_info=E2=80=99
    net/mac80211/mlme.c:3780:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_probe_resp=E2=80=99
    net/mac80211/mlme.c:3845:13: error: invalid storage class for function =
=E2=80=98ieee80211_handle_beacon_sig=E2=80=99
    net/mac80211/mlme.c:3941:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_our_beacon=E2=80=99
    net/mac80211/mlme.c:3951:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_beacon=E2=80=99
    net/mac80211/mlme.c:4344:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_timer=E2=80=99
    net/mac80211/mlme.c:4352:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_connection_lost=E2=80=99
    net/mac80211/mlme.c:4364:12: error: invalid storage class for function =
=E2=80=98ieee80211_auth=E2=80=99
    net/mac80211/mlme.c:4439:12: error: invalid storage class for function =
=E2=80=98ieee80211_do_assoc=E2=80=99
    net/mac80211/mlme.c:4639:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_bcn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4656:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_conn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4688:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_monitor_work=E2=80=99
    net/mac80211/mlme.c:4697:13: error: invalid storage class for function =
=E2=80=98ieee80211_restart_sta_timer=E2=80=99
    net/mac80211/mlme.c:4847:11: error: invalid storage class for function =
=E2=80=98ieee80211_ht_vht_rx_chains=E2=80=99
    net/mac80211/mlme.c:4892:1: error: invalid storage class for function =
=E2=80=98ieee80211_verify_sta_he_mcs_support=E2=80=99
    net/mac80211/mlme.c:4953:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_channel=E2=80=99
    net/mac80211/mlme.c:5122:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_dtim=E2=80=99
    net/mac80211/mlme.c:5156:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_connection=E2=80=99
    net/mac80211/mlme.c:5947:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_rssi_notify=E2=80=99 follows static declaration
    net/mac80211/mlme.c:5957:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_beacon_loss_notify=E2=80=99 follows static declaration
    include/linux/export.h:67:22: error: expected declaration or statement =
at end of input

Warnings:
    net/mac80211/mlme.c:3062:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    net/mac80211/mlme.c:5898:6: warning: =E2=80=98ieee80211_mgd_stop=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5867:5: warning: =E2=80=98ieee80211_mgd_disassoc=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5803:5: warning: =E2=80=98ieee80211_mgd_deauth=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5480:5: warning: =E2=80=98ieee80211_mgd_assoc=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5330:5: warning: =E2=80=98ieee80211_mgd_auth=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4834:6: warning: =E2=80=98ieee80211_mlme_notify_sca=
n_completed=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4795:6: warning: =E2=80=98ieee80211_sta_setup_sdata=
=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4770:6: warning: =E2=80=98ieee80211_sta_restart=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4710:6: warning: =E2=80=98ieee80211_mgd_quiesce=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4492:6: warning: =E2=80=98ieee80211_sta_work=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4480:6: warning: =E2=80=98ieee80211_mgd_conn_tx_sta=
tus=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4254:6: warning: =E2=80=98ieee80211_sta_rx_queued_m=
gmt=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4234:6: warning: =E2=80=98ieee80211_sta_rx_queued_e=
xt=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
mmp2_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
moxart_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
mpc30x_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
mps2_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
mtx1_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
multi_v4t_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
multi_v5_defconfig (arm, gcc-10) =E2=80=94 FAIL, 28 errors, 16 warnings, 0 =
section mismatches

Errors:
    net/mac80211/mlme.c:3116:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_deauth=E2=80=99
    net/mac80211/mlme.c:3164:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_disassoc=E2=80=99
    net/mac80211/mlme.c:3195:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_rates=E2=80=99
    net/mac80211/mlme.c:3245:13: error: invalid storage class for function =
=E2=80=98ieee80211_twt_req_supported=E2=80=99
    net/mac80211/mlme.c:3258:12: error: invalid storage class for function =
=E2=80=98ieee80211_recalc_twt_req=E2=80=99
    net/mac80211/mlme.c:3271:13: error: invalid storage class for function =
=E2=80=98ieee80211_assoc_success=E2=80=99
    net/mac80211/mlme.c:3648:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_assoc_resp=E2=80=99
    net/mac80211/mlme.c:3757:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_bss_info=E2=80=99
    net/mac80211/mlme.c:3780:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_probe_resp=E2=80=99
    net/mac80211/mlme.c:3845:13: error: invalid storage class for function =
=E2=80=98ieee80211_handle_beacon_sig=E2=80=99
    net/mac80211/mlme.c:3941:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_our_beacon=E2=80=99
    net/mac80211/mlme.c:3951:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_beacon=E2=80=99
    net/mac80211/mlme.c:4344:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_timer=E2=80=99
    net/mac80211/mlme.c:4352:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_connection_lost=E2=80=99
    net/mac80211/mlme.c:4364:12: error: invalid storage class for function =
=E2=80=98ieee80211_auth=E2=80=99
    net/mac80211/mlme.c:4439:12: error: invalid storage class for function =
=E2=80=98ieee80211_do_assoc=E2=80=99
    net/mac80211/mlme.c:4639:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_bcn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4656:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_conn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4688:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_monitor_work=E2=80=99
    net/mac80211/mlme.c:4697:13: error: invalid storage class for function =
=E2=80=98ieee80211_restart_sta_timer=E2=80=99
    net/mac80211/mlme.c:4847:11: error: invalid storage class for function =
=E2=80=98ieee80211_ht_vht_rx_chains=E2=80=99
    net/mac80211/mlme.c:4892:1: error: invalid storage class for function =
=E2=80=98ieee80211_verify_sta_he_mcs_support=E2=80=99
    net/mac80211/mlme.c:4953:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_channel=E2=80=99
    net/mac80211/mlme.c:5122:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_dtim=E2=80=99
    net/mac80211/mlme.c:5156:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_connection=E2=80=99
    net/mac80211/mlme.c:5947:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_rssi_notify=E2=80=99 follows static declaration
    net/mac80211/mlme.c:5957:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_beacon_loss_notify=E2=80=99 follows static declaration
    include/linux/export.h:67:22: error: expected declaration or statement =
at end of input

Warnings:
    net/mac80211/mlme.c:3062:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    net/mac80211/mlme.c:5898:6: warning: =E2=80=98ieee80211_mgd_stop=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5867:5: warning: =E2=80=98ieee80211_mgd_disassoc=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5803:5: warning: =E2=80=98ieee80211_mgd_deauth=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5480:5: warning: =E2=80=98ieee80211_mgd_assoc=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5330:5: warning: =E2=80=98ieee80211_mgd_auth=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4834:6: warning: =E2=80=98ieee80211_mlme_notify_sca=
n_completed=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4795:6: warning: =E2=80=98ieee80211_sta_setup_sdata=
=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4770:6: warning: =E2=80=98ieee80211_sta_restart=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4710:6: warning: =E2=80=98ieee80211_mgd_quiesce=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4492:6: warning: =E2=80=98ieee80211_sta_work=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4480:6: warning: =E2=80=98ieee80211_mgd_conn_tx_sta=
tus=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4254:6: warning: =E2=80=98ieee80211_sta_rx_queued_m=
gmt=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4234:6: warning: =E2=80=98ieee80211_sta_rx_queued_e=
xt=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-10) =E2=80=94 FAIL, 28 errors, 16 warnings, 0 =
section mismatches

Errors:
    net/mac80211/mlme.c:3116:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_deauth=E2=80=99
    net/mac80211/mlme.c:3164:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_disassoc=E2=80=99
    net/mac80211/mlme.c:3195:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_rates=E2=80=99
    net/mac80211/mlme.c:3245:13: error: invalid storage class for function =
=E2=80=98ieee80211_twt_req_supported=E2=80=99
    net/mac80211/mlme.c:3258:12: error: invalid storage class for function =
=E2=80=98ieee80211_recalc_twt_req=E2=80=99
    net/mac80211/mlme.c:3271:13: error: invalid storage class for function =
=E2=80=98ieee80211_assoc_success=E2=80=99
    net/mac80211/mlme.c:3648:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_assoc_resp=E2=80=99
    net/mac80211/mlme.c:3757:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_bss_info=E2=80=99
    net/mac80211/mlme.c:3780:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_probe_resp=E2=80=99
    net/mac80211/mlme.c:3845:13: error: invalid storage class for function =
=E2=80=98ieee80211_handle_beacon_sig=E2=80=99
    net/mac80211/mlme.c:3941:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_our_beacon=E2=80=99
    net/mac80211/mlme.c:3951:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_beacon=E2=80=99
    net/mac80211/mlme.c:4344:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_timer=E2=80=99
    net/mac80211/mlme.c:4352:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_connection_lost=E2=80=99
    net/mac80211/mlme.c:4364:12: error: invalid storage class for function =
=E2=80=98ieee80211_auth=E2=80=99
    net/mac80211/mlme.c:4439:12: error: invalid storage class for function =
=E2=80=98ieee80211_do_assoc=E2=80=99
    net/mac80211/mlme.c:4639:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_bcn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4656:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_conn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4688:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_monitor_work=E2=80=99
    net/mac80211/mlme.c:4697:13: error: invalid storage class for function =
=E2=80=98ieee80211_restart_sta_timer=E2=80=99
    net/mac80211/mlme.c:4847:11: error: invalid storage class for function =
=E2=80=98ieee80211_ht_vht_rx_chains=E2=80=99
    net/mac80211/mlme.c:4892:1: error: invalid storage class for function =
=E2=80=98ieee80211_verify_sta_he_mcs_support=E2=80=99
    net/mac80211/mlme.c:4953:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_channel=E2=80=99
    net/mac80211/mlme.c:5122:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_dtim=E2=80=99
    net/mac80211/mlme.c:5156:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_connection=E2=80=99
    net/mac80211/mlme.c:5947:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_rssi_notify=E2=80=99 follows static declaration
    net/mac80211/mlme.c:5957:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_beacon_loss_notify=E2=80=99 follows static declaration
    include/linux/export.h:67:22: error: expected declaration or statement =
at end of input

Warnings:
    net/mac80211/mlme.c:3062:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    net/mac80211/mlme.c:5898:6: warning: =E2=80=98ieee80211_mgd_stop=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5867:5: warning: =E2=80=98ieee80211_mgd_disassoc=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5803:5: warning: =E2=80=98ieee80211_mgd_deauth=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5480:5: warning: =E2=80=98ieee80211_mgd_assoc=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5330:5: warning: =E2=80=98ieee80211_mgd_auth=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4834:6: warning: =E2=80=98ieee80211_mlme_notify_sca=
n_completed=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4795:6: warning: =E2=80=98ieee80211_sta_setup_sdata=
=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4770:6: warning: =E2=80=98ieee80211_sta_restart=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4710:6: warning: =E2=80=98ieee80211_mgd_quiesce=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4492:6: warning: =E2=80=98ieee80211_sta_work=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4480:6: warning: =E2=80=98ieee80211_mgd_conn_tx_sta=
tus=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4254:6: warning: =E2=80=98ieee80211_sta_rx_queued_m=
gmt=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4234:6: warning: =E2=80=98ieee80211_sta_rx_queued_e=
xt=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-10) =E2=80=94 FAIL, 28 errors, 16 warnings, 0 =
section mismatches

Errors:
    net/mac80211/mlme.c:3116:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_deauth=E2=80=99
    net/mac80211/mlme.c:3164:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_disassoc=E2=80=99
    net/mac80211/mlme.c:3195:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_rates=E2=80=99
    net/mac80211/mlme.c:3245:13: error: invalid storage class for function =
=E2=80=98ieee80211_twt_req_supported=E2=80=99
    net/mac80211/mlme.c:3258:12: error: invalid storage class for function =
=E2=80=98ieee80211_recalc_twt_req=E2=80=99
    net/mac80211/mlme.c:3271:13: error: invalid storage class for function =
=E2=80=98ieee80211_assoc_success=E2=80=99
    net/mac80211/mlme.c:3648:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_assoc_resp=E2=80=99
    net/mac80211/mlme.c:3757:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_bss_info=E2=80=99
    net/mac80211/mlme.c:3780:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_probe_resp=E2=80=99
    net/mac80211/mlme.c:3845:13: error: invalid storage class for function =
=E2=80=98ieee80211_handle_beacon_sig=E2=80=99
    net/mac80211/mlme.c:3941:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_our_beacon=E2=80=99
    net/mac80211/mlme.c:3951:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_beacon=E2=80=99
    net/mac80211/mlme.c:4344:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_timer=E2=80=99
    net/mac80211/mlme.c:4352:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_connection_lost=E2=80=99
    net/mac80211/mlme.c:4364:12: error: invalid storage class for function =
=E2=80=98ieee80211_auth=E2=80=99
    net/mac80211/mlme.c:4439:12: error: invalid storage class for function =
=E2=80=98ieee80211_do_assoc=E2=80=99
    net/mac80211/mlme.c:4639:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_bcn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4656:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_conn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4688:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_monitor_work=E2=80=99
    net/mac80211/mlme.c:4697:13: error: invalid storage class for function =
=E2=80=98ieee80211_restart_sta_timer=E2=80=99
    net/mac80211/mlme.c:4847:11: error: invalid storage class for function =
=E2=80=98ieee80211_ht_vht_rx_chains=E2=80=99
    net/mac80211/mlme.c:4892:1: error: invalid storage class for function =
=E2=80=98ieee80211_verify_sta_he_mcs_support=E2=80=99
    net/mac80211/mlme.c:4953:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_channel=E2=80=99
    net/mac80211/mlme.c:5122:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_dtim=E2=80=99
    net/mac80211/mlme.c:5156:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_connection=E2=80=99
    net/mac80211/mlme.c:5947:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_rssi_notify=E2=80=99 follows static declaration
    net/mac80211/mlme.c:5957:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_beacon_loss_notify=E2=80=99 follows static declaration
    include/linux/export.h:67:22: error: expected declaration or statement =
at end of input

Warnings:
    net/mac80211/mlme.c:3062:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    net/mac80211/mlme.c:5898:6: warning: =E2=80=98ieee80211_mgd_stop=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5867:5: warning: =E2=80=98ieee80211_mgd_disassoc=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5803:5: warning: =E2=80=98ieee80211_mgd_deauth=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5480:5: warning: =E2=80=98ieee80211_mgd_assoc=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5330:5: warning: =E2=80=98ieee80211_mgd_auth=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4834:6: warning: =E2=80=98ieee80211_mlme_notify_sca=
n_completed=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4795:6: warning: =E2=80=98ieee80211_sta_setup_sdata=
=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4770:6: warning: =E2=80=98ieee80211_sta_restart=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4710:6: warning: =E2=80=98ieee80211_mgd_quiesce=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4492:6: warning: =E2=80=98ieee80211_sta_work=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4480:6: warning: =E2=80=98ieee80211_mgd_conn_tx_sta=
tus=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4254:6: warning: =E2=80=98ieee80211_sta_rx_queued_m=
gmt=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4234:6: warning: =E2=80=98ieee80211_sta_rx_queued_e=
xt=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
mxs_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
neponset_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xcda4): Section mismatch in referenc=
e from the function __arm_ioremap_pfn_caller() to the function .meminit.tex=
t:memblock_is_map_memory()

---------------------------------------------------------------------------=
-----
netwinder_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
nommu_k210_defconfig (riscv, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, =
0 section mismatches

---------------------------------------------------------------------------=
-----
nsimosci_hs_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
nsimosci_hs_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warning=
s, 0 section mismatches

---------------------------------------------------------------------------=
-----
omap1_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-10) =E2=80=94 FAIL, 28 errors, 16 warnings, 0=
 section mismatches

Errors:
    net/mac80211/mlme.c:3116:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_deauth=E2=80=99
    net/mac80211/mlme.c:3164:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_disassoc=E2=80=99
    net/mac80211/mlme.c:3195:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_rates=E2=80=99
    net/mac80211/mlme.c:3245:13: error: invalid storage class for function =
=E2=80=98ieee80211_twt_req_supported=E2=80=99
    net/mac80211/mlme.c:3258:12: error: invalid storage class for function =
=E2=80=98ieee80211_recalc_twt_req=E2=80=99
    net/mac80211/mlme.c:3271:13: error: invalid storage class for function =
=E2=80=98ieee80211_assoc_success=E2=80=99
    net/mac80211/mlme.c:3648:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_assoc_resp=E2=80=99
    net/mac80211/mlme.c:3757:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_bss_info=E2=80=99
    net/mac80211/mlme.c:3780:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_probe_resp=E2=80=99
    net/mac80211/mlme.c:3845:13: error: invalid storage class for function =
=E2=80=98ieee80211_handle_beacon_sig=E2=80=99
    net/mac80211/mlme.c:3941:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_our_beacon=E2=80=99
    net/mac80211/mlme.c:3951:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_beacon=E2=80=99
    net/mac80211/mlme.c:4344:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_timer=E2=80=99
    net/mac80211/mlme.c:4352:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_connection_lost=E2=80=99
    net/mac80211/mlme.c:4364:12: error: invalid storage class for function =
=E2=80=98ieee80211_auth=E2=80=99
    net/mac80211/mlme.c:4439:12: error: invalid storage class for function =
=E2=80=98ieee80211_do_assoc=E2=80=99
    net/mac80211/mlme.c:4639:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_bcn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4656:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_conn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4688:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_monitor_work=E2=80=99
    net/mac80211/mlme.c:4697:13: error: invalid storage class for function =
=E2=80=98ieee80211_restart_sta_timer=E2=80=99
    net/mac80211/mlme.c:4847:11: error: invalid storage class for function =
=E2=80=98ieee80211_ht_vht_rx_chains=E2=80=99
    net/mac80211/mlme.c:4892:1: error: invalid storage class for function =
=E2=80=98ieee80211_verify_sta_he_mcs_support=E2=80=99
    net/mac80211/mlme.c:4953:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_channel=E2=80=99
    net/mac80211/mlme.c:5122:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_dtim=E2=80=99
    net/mac80211/mlme.c:5156:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_connection=E2=80=99
    net/mac80211/mlme.c:5947:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_rssi_notify=E2=80=99 follows static declaration
    net/mac80211/mlme.c:5957:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_beacon_loss_notify=E2=80=99 follows static declaration
    include/linux/export.h:67:22: error: expected declaration or statement =
at end of input

Warnings:
    net/mac80211/mlme.c:3062:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    net/mac80211/mlme.c:5898:6: warning: =E2=80=98ieee80211_mgd_stop=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5867:5: warning: =E2=80=98ieee80211_mgd_disassoc=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5803:5: warning: =E2=80=98ieee80211_mgd_deauth=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5480:5: warning: =E2=80=98ieee80211_mgd_assoc=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5330:5: warning: =E2=80=98ieee80211_mgd_auth=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4834:6: warning: =E2=80=98ieee80211_mlme_notify_sca=
n_completed=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4795:6: warning: =E2=80=98ieee80211_sta_setup_sdata=
=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4770:6: warning: =E2=80=98ieee80211_sta_restart=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4710:6: warning: =E2=80=98ieee80211_mgd_quiesce=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4492:6: warning: =E2=80=98ieee80211_sta_work=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4480:6: warning: =E2=80=98ieee80211_mgd_conn_tx_sta=
tus=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4254:6: warning: =E2=80=98ieee80211_sta_rx_queued_m=
gmt=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4234:6: warning: =E2=80=98ieee80211_sta_rx_queued_e=
xt=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
omega2p_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
orion5x_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
oxnas_v6_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
palmz72_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
pcm027_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
pic32mzda_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
pistachio_defconfig (mips, gcc-10) =E2=80=94 FAIL, 28 errors, 16 warnings, =
0 section mismatches

Errors:
    net/mac80211/mlme.c:3116:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_deauth=E2=80=99
    net/mac80211/mlme.c:3164:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_disassoc=E2=80=99
    net/mac80211/mlme.c:3195:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_rates=E2=80=99
    net/mac80211/mlme.c:3245:13: error: invalid storage class for function =
=E2=80=98ieee80211_twt_req_supported=E2=80=99
    net/mac80211/mlme.c:3258:12: error: invalid storage class for function =
=E2=80=98ieee80211_recalc_twt_req=E2=80=99
    net/mac80211/mlme.c:3271:13: error: invalid storage class for function =
=E2=80=98ieee80211_assoc_success=E2=80=99
    net/mac80211/mlme.c:3648:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_assoc_resp=E2=80=99
    net/mac80211/mlme.c:3757:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_bss_info=E2=80=99
    net/mac80211/mlme.c:3780:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_probe_resp=E2=80=99
    net/mac80211/mlme.c:3845:13: error: invalid storage class for function =
=E2=80=98ieee80211_handle_beacon_sig=E2=80=99
    net/mac80211/mlme.c:3941:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_our_beacon=E2=80=99
    net/mac80211/mlme.c:3951:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_beacon=E2=80=99
    net/mac80211/mlme.c:4344:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_timer=E2=80=99
    net/mac80211/mlme.c:4352:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_connection_lost=E2=80=99
    net/mac80211/mlme.c:4364:12: error: invalid storage class for function =
=E2=80=98ieee80211_auth=E2=80=99
    net/mac80211/mlme.c:4439:12: error: invalid storage class for function =
=E2=80=98ieee80211_do_assoc=E2=80=99
    net/mac80211/mlme.c:4639:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_bcn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4656:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_conn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4688:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_monitor_work=E2=80=99
    net/mac80211/mlme.c:4697:13: error: invalid storage class for function =
=E2=80=98ieee80211_restart_sta_timer=E2=80=99
    net/mac80211/mlme.c:4847:11: error: invalid storage class for function =
=E2=80=98ieee80211_ht_vht_rx_chains=E2=80=99
    net/mac80211/mlme.c:4892:1: error: invalid storage class for function =
=E2=80=98ieee80211_verify_sta_he_mcs_support=E2=80=99
    net/mac80211/mlme.c:4953:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_channel=E2=80=99
    net/mac80211/mlme.c:5122:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_dtim=E2=80=99
    net/mac80211/mlme.c:5156:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_connection=E2=80=99
    net/mac80211/mlme.c:5947:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_rssi_notify=E2=80=99 follows static declaration
    net/mac80211/mlme.c:5957:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_beacon_loss_notify=E2=80=99 follows static declaration
    include/linux/export.h:67:22: error: expected declaration or statement =
at end of input

Warnings:
    net/mac80211/mlme.c:3062:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    net/mac80211/mlme.c:5898:6: warning: =E2=80=98ieee80211_mgd_stop=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5867:5: warning: =E2=80=98ieee80211_mgd_disassoc=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5803:5: warning: =E2=80=98ieee80211_mgd_deauth=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5480:5: warning: =E2=80=98ieee80211_mgd_assoc=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5330:5: warning: =E2=80=98ieee80211_mgd_auth=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4834:6: warning: =E2=80=98ieee80211_mlme_notify_sca=
n_completed=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4795:6: warning: =E2=80=98ieee80211_sta_setup_sdata=
=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4770:6: warning: =E2=80=98ieee80211_sta_restart=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4710:6: warning: =E2=80=98ieee80211_mgd_quiesce=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4492:6: warning: =E2=80=98ieee80211_sta_work=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4480:6: warning: =E2=80=98ieee80211_mgd_conn_tx_sta=
tus=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4254:6: warning: =E2=80=98ieee80211_sta_rx_queued_m=
gmt=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4234:6: warning: =E2=80=98ieee80211_sta_rx_queued_e=
xt=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xc8ec): Section mismatch in referenc=
e from the function __arm_ioremap_pfn_caller() to the function .meminit.tex=
t:memblock_is_map_memory()

---------------------------------------------------------------------------=
-----
prima2_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
pxa255-idp_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
pxa3xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
pxa910_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
pxa_defconfig (arm, gcc-10) =E2=80=94 FAIL, 28 errors, 16 warnings, 0 secti=
on mismatches

Errors:
    net/mac80211/mlme.c:3116:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_deauth=E2=80=99
    net/mac80211/mlme.c:3164:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_disassoc=E2=80=99
    net/mac80211/mlme.c:3195:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_rates=E2=80=99
    net/mac80211/mlme.c:3245:13: error: invalid storage class for function =
=E2=80=98ieee80211_twt_req_supported=E2=80=99
    net/mac80211/mlme.c:3258:12: error: invalid storage class for function =
=E2=80=98ieee80211_recalc_twt_req=E2=80=99
    net/mac80211/mlme.c:3271:13: error: invalid storage class for function =
=E2=80=98ieee80211_assoc_success=E2=80=99
    net/mac80211/mlme.c:3648:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_assoc_resp=E2=80=99
    net/mac80211/mlme.c:3757:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_bss_info=E2=80=99
    net/mac80211/mlme.c:3780:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_probe_resp=E2=80=99
    net/mac80211/mlme.c:3845:13: error: invalid storage class for function =
=E2=80=98ieee80211_handle_beacon_sig=E2=80=99
    net/mac80211/mlme.c:3941:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_our_beacon=E2=80=99
    net/mac80211/mlme.c:3951:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_beacon=E2=80=99
    net/mac80211/mlme.c:4344:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_timer=E2=80=99
    net/mac80211/mlme.c:4352:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_connection_lost=E2=80=99
    net/mac80211/mlme.c:4364:12: error: invalid storage class for function =
=E2=80=98ieee80211_auth=E2=80=99
    net/mac80211/mlme.c:4439:12: error: invalid storage class for function =
=E2=80=98ieee80211_do_assoc=E2=80=99
    net/mac80211/mlme.c:4639:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_bcn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4656:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_conn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4688:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_monitor_work=E2=80=99
    net/mac80211/mlme.c:4697:13: error: invalid storage class for function =
=E2=80=98ieee80211_restart_sta_timer=E2=80=99
    net/mac80211/mlme.c:4847:11: error: invalid storage class for function =
=E2=80=98ieee80211_ht_vht_rx_chains=E2=80=99
    net/mac80211/mlme.c:4892:1: error: invalid storage class for function =
=E2=80=98ieee80211_verify_sta_he_mcs_support=E2=80=99
    net/mac80211/mlme.c:4953:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_channel=E2=80=99
    net/mac80211/mlme.c:5122:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_dtim=E2=80=99
    net/mac80211/mlme.c:5156:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_connection=E2=80=99
    net/mac80211/mlme.c:5947:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_rssi_notify=E2=80=99 follows static declaration
    net/mac80211/mlme.c:5957:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_beacon_loss_notify=E2=80=99 follows static declaration
    include/linux/export.h:67:22: error: expected declaration or statement =
at end of input

Warnings:
    net/mac80211/mlme.c:3062:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    net/mac80211/mlme.c:5898:6: warning: =E2=80=98ieee80211_mgd_stop=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5867:5: warning: =E2=80=98ieee80211_mgd_disassoc=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5803:5: warning: =E2=80=98ieee80211_mgd_deauth=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5480:5: warning: =E2=80=98ieee80211_mgd_assoc=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5330:5: warning: =E2=80=98ieee80211_mgd_auth=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4834:6: warning: =E2=80=98ieee80211_mlme_notify_sca=
n_completed=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4795:6: warning: =E2=80=98ieee80211_sta_setup_sdata=
=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4770:6: warning: =E2=80=98ieee80211_sta_restart=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4710:6: warning: =E2=80=98ieee80211_mgd_quiesce=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4492:6: warning: =E2=80=98ieee80211_sta_work=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4480:6: warning: =E2=80=98ieee80211_mgd_conn_tx_sta=
tus=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4254:6: warning: =E2=80=98ieee80211_sta_rx_queued_m=
gmt=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4234:6: warning: =E2=80=98ieee80211_sta_rx_queued_e=
xt=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm, gcc-10) =E2=80=94 FAIL, 28 errors, 16 warnings, 0 sect=
ion mismatches

Errors:
    net/mac80211/mlme.c:3116:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_deauth=E2=80=99
    net/mac80211/mlme.c:3164:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_disassoc=E2=80=99
    net/mac80211/mlme.c:3195:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_rates=E2=80=99
    net/mac80211/mlme.c:3245:13: error: invalid storage class for function =
=E2=80=98ieee80211_twt_req_supported=E2=80=99
    net/mac80211/mlme.c:3258:12: error: invalid storage class for function =
=E2=80=98ieee80211_recalc_twt_req=E2=80=99
    net/mac80211/mlme.c:3271:13: error: invalid storage class for function =
=E2=80=98ieee80211_assoc_success=E2=80=99
    net/mac80211/mlme.c:3648:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_assoc_resp=E2=80=99
    net/mac80211/mlme.c:3757:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_bss_info=E2=80=99
    net/mac80211/mlme.c:3780:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_probe_resp=E2=80=99
    net/mac80211/mlme.c:3845:13: error: invalid storage class for function =
=E2=80=98ieee80211_handle_beacon_sig=E2=80=99
    net/mac80211/mlme.c:3941:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_our_beacon=E2=80=99
    net/mac80211/mlme.c:3951:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_beacon=E2=80=99
    net/mac80211/mlme.c:4344:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_timer=E2=80=99
    net/mac80211/mlme.c:4352:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_connection_lost=E2=80=99
    net/mac80211/mlme.c:4364:12: error: invalid storage class for function =
=E2=80=98ieee80211_auth=E2=80=99
    net/mac80211/mlme.c:4439:12: error: invalid storage class for function =
=E2=80=98ieee80211_do_assoc=E2=80=99
    net/mac80211/mlme.c:4639:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_bcn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4656:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_conn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4688:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_monitor_work=E2=80=99
    net/mac80211/mlme.c:4697:13: error: invalid storage class for function =
=E2=80=98ieee80211_restart_sta_timer=E2=80=99
    net/mac80211/mlme.c:4847:11: error: invalid storage class for function =
=E2=80=98ieee80211_ht_vht_rx_chains=E2=80=99
    net/mac80211/mlme.c:4892:1: error: invalid storage class for function =
=E2=80=98ieee80211_verify_sta_he_mcs_support=E2=80=99
    net/mac80211/mlme.c:4953:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_channel=E2=80=99
    net/mac80211/mlme.c:5122:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_dtim=E2=80=99
    net/mac80211/mlme.c:5156:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_connection=E2=80=99
    net/mac80211/mlme.c:5947:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_rssi_notify=E2=80=99 follows static declaration
    net/mac80211/mlme.c:5957:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_beacon_loss_notify=E2=80=99 follows static declaration
    include/linux/export.h:67:22: error: expected declaration or statement =
at end of input

Warnings:
    net/mac80211/mlme.c:3062:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    net/mac80211/mlme.c:5898:6: warning: =E2=80=98ieee80211_mgd_stop=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5867:5: warning: =E2=80=98ieee80211_mgd_disassoc=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5803:5: warning: =E2=80=98ieee80211_mgd_deauth=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5480:5: warning: =E2=80=98ieee80211_mgd_assoc=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5330:5: warning: =E2=80=98ieee80211_mgd_auth=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4834:6: warning: =E2=80=98ieee80211_mlme_notify_sca=
n_completed=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4795:6: warning: =E2=80=98ieee80211_sta_setup_sdata=
=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4770:6: warning: =E2=80=98ieee80211_sta_restart=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4710:6: warning: =E2=80=98ieee80211_mgd_quiesce=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4492:6: warning: =E2=80=98ieee80211_sta_work=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4480:6: warning: =E2=80=98ieee80211_mgd_conn_tx_sta=
tus=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4254:6: warning: =E2=80=98ieee80211_sta_rx_queued_m=
gmt=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4234:6: warning: =E2=80=98ieee80211_sta_rx_queued_e=
xt=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
qi_lb60_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
rb532_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
rbtx49xx_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
realview_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    drivers/block/paride/bpck.c:32: warning: "PC" redefined

---------------------------------------------------------------------------=
-----
rpc_defconfig (arm, gcc-10) =E2=80=94 FAIL, 4 errors, 0 warnings, 0 section=
 mismatches

Errors:
    arm-linux-gnueabihf-gcc: error: unrecognized -march target: armv3m
    arm-linux-gnueabihf-gcc: error: missing argument to =E2=80=98-march=3D=
=E2=80=99
    arm-linux-gnueabihf-gcc: error: unrecognized -march target: armv3m
    arm-linux-gnueabihf-gcc: error: missing argument to =E2=80=98-march=3D=
=E2=80=99

---------------------------------------------------------------------------=
-----
rs90_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
rv32_defconfig (riscv, gcc-10) =E2=80=94 PASS, 0 errors, 4 warnings, 0 sect=
ion mismatches

Warnings:
    <stdin>:830:2: warning: #warning syscall fstat64 not implemented [-Wcpp]
    <stdin>:1127:2: warning: #warning syscall fstatat64 not implemented [-W=
cpp]
    <stdin>:830:2: warning: #warning syscall fstat64 not implemented [-Wcpp]
    <stdin>:1127:2: warning: #warning syscall fstatat64 not implemented [-W=
cpp]

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm, gcc-10) =E2=80=94 FAIL, 28 errors, 16 warnings, 0 s=
ection mismatches

Errors:
    net/mac80211/mlme.c:3116:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_deauth=E2=80=99
    net/mac80211/mlme.c:3164:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_disassoc=E2=80=99
    net/mac80211/mlme.c:3195:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_rates=E2=80=99
    net/mac80211/mlme.c:3245:13: error: invalid storage class for function =
=E2=80=98ieee80211_twt_req_supported=E2=80=99
    net/mac80211/mlme.c:3258:12: error: invalid storage class for function =
=E2=80=98ieee80211_recalc_twt_req=E2=80=99
    net/mac80211/mlme.c:3271:13: error: invalid storage class for function =
=E2=80=98ieee80211_assoc_success=E2=80=99
    net/mac80211/mlme.c:3648:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_assoc_resp=E2=80=99
    net/mac80211/mlme.c:3757:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_bss_info=E2=80=99
    net/mac80211/mlme.c:3780:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_probe_resp=E2=80=99
    net/mac80211/mlme.c:3845:13: error: invalid storage class for function =
=E2=80=98ieee80211_handle_beacon_sig=E2=80=99
    net/mac80211/mlme.c:3941:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_our_beacon=E2=80=99
    net/mac80211/mlme.c:3951:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_beacon=E2=80=99
    net/mac80211/mlme.c:4344:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_timer=E2=80=99
    net/mac80211/mlme.c:4352:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_connection_lost=E2=80=99
    net/mac80211/mlme.c:4364:12: error: invalid storage class for function =
=E2=80=98ieee80211_auth=E2=80=99
    net/mac80211/mlme.c:4439:12: error: invalid storage class for function =
=E2=80=98ieee80211_do_assoc=E2=80=99
    net/mac80211/mlme.c:4639:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_bcn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4656:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_conn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4688:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_monitor_work=E2=80=99
    net/mac80211/mlme.c:4697:13: error: invalid storage class for function =
=E2=80=98ieee80211_restart_sta_timer=E2=80=99
    net/mac80211/mlme.c:4847:11: error: invalid storage class for function =
=E2=80=98ieee80211_ht_vht_rx_chains=E2=80=99
    net/mac80211/mlme.c:4892:1: error: invalid storage class for function =
=E2=80=98ieee80211_verify_sta_he_mcs_support=E2=80=99
    net/mac80211/mlme.c:4953:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_channel=E2=80=99
    net/mac80211/mlme.c:5122:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_dtim=E2=80=99
    net/mac80211/mlme.c:5156:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_connection=E2=80=99
    net/mac80211/mlme.c:5947:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_rssi_notify=E2=80=99 follows static declaration
    net/mac80211/mlme.c:5957:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_beacon_loss_notify=E2=80=99 follows static declaration
    include/linux/export.h:67:22: error: expected declaration or statement =
at end of input

Warnings:
    net/mac80211/mlme.c:3062:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    net/mac80211/mlme.c:5898:6: warning: =E2=80=98ieee80211_mgd_stop=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5867:5: warning: =E2=80=98ieee80211_mgd_disassoc=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5803:5: warning: =E2=80=98ieee80211_mgd_deauth=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5480:5: warning: =E2=80=98ieee80211_mgd_assoc=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5330:5: warning: =E2=80=98ieee80211_mgd_auth=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4834:6: warning: =E2=80=98ieee80211_mlme_notify_sca=
n_completed=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4795:6: warning: =E2=80=98ieee80211_sta_setup_sdata=
=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4770:6: warning: =E2=80=98ieee80211_sta_restart=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4710:6: warning: =E2=80=98ieee80211_mgd_quiesce=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4492:6: warning: =E2=80=98ieee80211_sta_work=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4480:6: warning: =E2=80=98ieee80211_mgd_conn_tx_sta=
tus=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4254:6: warning: =E2=80=98ieee80211_sta_rx_queued_m=
gmt=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4234:6: warning: =E2=80=98ieee80211_sta_rx_queued_e=
xt=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
s5pv210_defconfig (arm, gcc-10) =E2=80=94 FAIL, 28 errors, 16 warnings, 0 s=
ection mismatches

Errors:
    net/mac80211/mlme.c:3116:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_deauth=E2=80=99
    net/mac80211/mlme.c:3164:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_disassoc=E2=80=99
    net/mac80211/mlme.c:3195:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_rates=E2=80=99
    net/mac80211/mlme.c:3245:13: error: invalid storage class for function =
=E2=80=98ieee80211_twt_req_supported=E2=80=99
    net/mac80211/mlme.c:3258:12: error: invalid storage class for function =
=E2=80=98ieee80211_recalc_twt_req=E2=80=99
    net/mac80211/mlme.c:3271:13: error: invalid storage class for function =
=E2=80=98ieee80211_assoc_success=E2=80=99
    net/mac80211/mlme.c:3648:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_assoc_resp=E2=80=99
    net/mac80211/mlme.c:3757:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_bss_info=E2=80=99
    net/mac80211/mlme.c:3780:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_probe_resp=E2=80=99
    net/mac80211/mlme.c:3845:13: error: invalid storage class for function =
=E2=80=98ieee80211_handle_beacon_sig=E2=80=99
    net/mac80211/mlme.c:3941:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_our_beacon=E2=80=99
    net/mac80211/mlme.c:3951:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_beacon=E2=80=99
    net/mac80211/mlme.c:4344:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_timer=E2=80=99
    net/mac80211/mlme.c:4352:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_connection_lost=E2=80=99
    net/mac80211/mlme.c:4364:12: error: invalid storage class for function =
=E2=80=98ieee80211_auth=E2=80=99
    net/mac80211/mlme.c:4439:12: error: invalid storage class for function =
=E2=80=98ieee80211_do_assoc=E2=80=99
    net/mac80211/mlme.c:4639:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_bcn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4656:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_conn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4688:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_monitor_work=E2=80=99
    net/mac80211/mlme.c:4697:13: error: invalid storage class for function =
=E2=80=98ieee80211_restart_sta_timer=E2=80=99
    net/mac80211/mlme.c:4847:11: error: invalid storage class for function =
=E2=80=98ieee80211_ht_vht_rx_chains=E2=80=99
    net/mac80211/mlme.c:4892:1: error: invalid storage class for function =
=E2=80=98ieee80211_verify_sta_he_mcs_support=E2=80=99
    net/mac80211/mlme.c:4953:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_channel=E2=80=99
    net/mac80211/mlme.c:5122:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_dtim=E2=80=99
    net/mac80211/mlme.c:5156:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_connection=E2=80=99
    net/mac80211/mlme.c:5947:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_rssi_notify=E2=80=99 follows static declaration
    net/mac80211/mlme.c:5957:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_beacon_loss_notify=E2=80=99 follows static declaration
    include/linux/export.h:67:22: error: expected declaration or statement =
at end of input

Warnings:
    net/mac80211/mlme.c:3062:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    net/mac80211/mlme.c:5898:6: warning: =E2=80=98ieee80211_mgd_stop=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5867:5: warning: =E2=80=98ieee80211_mgd_disassoc=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5803:5: warning: =E2=80=98ieee80211_mgd_deauth=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5480:5: warning: =E2=80=98ieee80211_mgd_assoc=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5330:5: warning: =E2=80=98ieee80211_mgd_auth=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4834:6: warning: =E2=80=98ieee80211_mlme_notify_sca=
n_completed=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4795:6: warning: =E2=80=98ieee80211_sta_setup_sdata=
=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4770:6: warning: =E2=80=98ieee80211_sta_restart=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4710:6: warning: =E2=80=98ieee80211_mgd_quiesce=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4492:6: warning: =E2=80=98ieee80211_sta_work=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4480:6: warning: =E2=80=98ieee80211_mgd_conn_tx_sta=
tus=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4254:6: warning: =E2=80=98ieee80211_sta_rx_queued_m=
gmt=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4234:6: warning: =E2=80=98ieee80211_sta_rx_queued_e=
xt=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
sama5_defconfig (arm, gcc-10) =E2=80=94 FAIL, 28 errors, 16 warnings, 0 sec=
tion mismatches

Errors:
    net/mac80211/mlme.c:3116:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_deauth=E2=80=99
    net/mac80211/mlme.c:3164:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_disassoc=E2=80=99
    net/mac80211/mlme.c:3195:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_rates=E2=80=99
    net/mac80211/mlme.c:3245:13: error: invalid storage class for function =
=E2=80=98ieee80211_twt_req_supported=E2=80=99
    net/mac80211/mlme.c:3258:12: error: invalid storage class for function =
=E2=80=98ieee80211_recalc_twt_req=E2=80=99
    net/mac80211/mlme.c:3271:13: error: invalid storage class for function =
=E2=80=98ieee80211_assoc_success=E2=80=99
    net/mac80211/mlme.c:3648:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_assoc_resp=E2=80=99
    net/mac80211/mlme.c:3757:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_bss_info=E2=80=99
    net/mac80211/mlme.c:3780:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_probe_resp=E2=80=99
    net/mac80211/mlme.c:3845:13: error: invalid storage class for function =
=E2=80=98ieee80211_handle_beacon_sig=E2=80=99
    net/mac80211/mlme.c:3941:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_our_beacon=E2=80=99
    net/mac80211/mlme.c:3951:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_beacon=E2=80=99
    net/mac80211/mlme.c:4344:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_timer=E2=80=99
    net/mac80211/mlme.c:4352:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_connection_lost=E2=80=99
    net/mac80211/mlme.c:4364:12: error: invalid storage class for function =
=E2=80=98ieee80211_auth=E2=80=99
    net/mac80211/mlme.c:4439:12: error: invalid storage class for function =
=E2=80=98ieee80211_do_assoc=E2=80=99
    net/mac80211/mlme.c:4639:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_bcn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4656:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_conn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4688:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_monitor_work=E2=80=99
    net/mac80211/mlme.c:4697:13: error: invalid storage class for function =
=E2=80=98ieee80211_restart_sta_timer=E2=80=99
    net/mac80211/mlme.c:4847:11: error: invalid storage class for function =
=E2=80=98ieee80211_ht_vht_rx_chains=E2=80=99
    net/mac80211/mlme.c:4892:1: error: invalid storage class for function =
=E2=80=98ieee80211_verify_sta_he_mcs_support=E2=80=99
    net/mac80211/mlme.c:4953:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_channel=E2=80=99
    net/mac80211/mlme.c:5122:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_dtim=E2=80=99
    net/mac80211/mlme.c:5156:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_connection=E2=80=99
    net/mac80211/mlme.c:5947:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_rssi_notify=E2=80=99 follows static declaration
    net/mac80211/mlme.c:5957:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_beacon_loss_notify=E2=80=99 follows static declaration
    include/linux/export.h:67:22: error: expected declaration or statement =
at end of input

Warnings:
    net/mac80211/mlme.c:3062:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    net/mac80211/mlme.c:5898:6: warning: =E2=80=98ieee80211_mgd_stop=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5867:5: warning: =E2=80=98ieee80211_mgd_disassoc=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5803:5: warning: =E2=80=98ieee80211_mgd_deauth=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5480:5: warning: =E2=80=98ieee80211_mgd_assoc=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5330:5: warning: =E2=80=98ieee80211_mgd_auth=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4834:6: warning: =E2=80=98ieee80211_mlme_notify_sca=
n_completed=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4795:6: warning: =E2=80=98ieee80211_sta_setup_sdata=
=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4770:6: warning: =E2=80=98ieee80211_sta_restart=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4710:6: warning: =E2=80=98ieee80211_mgd_quiesce=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4492:6: warning: =E2=80=98ieee80211_sta_work=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4480:6: warning: =E2=80=98ieee80211_mgd_conn_tx_sta=
tus=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4254:6: warning: =E2=80=98ieee80211_sta_rx_queued_m=
gmt=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4234:6: warning: =E2=80=98ieee80211_sta_rx_queued_e=
xt=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
sb1250_swarm_defconfig (mips, gcc-10) =E2=80=94 FAIL, 28 errors, 16 warning=
s, 0 section mismatches

Errors:
    net/mac80211/mlme.c:3116:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_deauth=E2=80=99
    net/mac80211/mlme.c:3164:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_disassoc=E2=80=99
    net/mac80211/mlme.c:3195:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_rates=E2=80=99
    net/mac80211/mlme.c:3245:13: error: invalid storage class for function =
=E2=80=98ieee80211_twt_req_supported=E2=80=99
    net/mac80211/mlme.c:3258:12: error: invalid storage class for function =
=E2=80=98ieee80211_recalc_twt_req=E2=80=99
    net/mac80211/mlme.c:3271:13: error: invalid storage class for function =
=E2=80=98ieee80211_assoc_success=E2=80=99
    net/mac80211/mlme.c:3648:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_assoc_resp=E2=80=99
    net/mac80211/mlme.c:3757:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_bss_info=E2=80=99
    net/mac80211/mlme.c:3780:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_probe_resp=E2=80=99
    net/mac80211/mlme.c:3845:13: error: invalid storage class for function =
=E2=80=98ieee80211_handle_beacon_sig=E2=80=99
    net/mac80211/mlme.c:3941:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_our_beacon=E2=80=99
    net/mac80211/mlme.c:3951:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_beacon=E2=80=99
    net/mac80211/mlme.c:4344:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_timer=E2=80=99
    net/mac80211/mlme.c:4352:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_connection_lost=E2=80=99
    net/mac80211/mlme.c:4364:12: error: invalid storage class for function =
=E2=80=98ieee80211_auth=E2=80=99
    net/mac80211/mlme.c:4439:12: error: invalid storage class for function =
=E2=80=98ieee80211_do_assoc=E2=80=99
    net/mac80211/mlme.c:4639:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_bcn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4656:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_conn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4688:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_monitor_work=E2=80=99
    net/mac80211/mlme.c:4697:13: error: invalid storage class for function =
=E2=80=98ieee80211_restart_sta_timer=E2=80=99
    net/mac80211/mlme.c:4847:11: error: invalid storage class for function =
=E2=80=98ieee80211_ht_vht_rx_chains=E2=80=99
    net/mac80211/mlme.c:4892:1: error: invalid storage class for function =
=E2=80=98ieee80211_verify_sta_he_mcs_support=E2=80=99
    net/mac80211/mlme.c:4953:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_channel=E2=80=99
    net/mac80211/mlme.c:5122:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_dtim=E2=80=99
    net/mac80211/mlme.c:5156:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_connection=E2=80=99
    net/mac80211/mlme.c:5947:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_rssi_notify=E2=80=99 follows static declaration
    net/mac80211/mlme.c:5957:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_beacon_loss_notify=E2=80=99 follows static declaration
    include/linux/export.h:67:22: error: expected declaration or statement =
at end of input

Warnings:
    net/mac80211/mlme.c:3062:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    net/mac80211/mlme.c:5898:6: warning: =E2=80=98ieee80211_mgd_stop=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5867:5: warning: =E2=80=98ieee80211_mgd_disassoc=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5803:5: warning: =E2=80=98ieee80211_mgd_deauth=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5480:5: warning: =E2=80=98ieee80211_mgd_assoc=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5330:5: warning: =E2=80=98ieee80211_mgd_auth=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4834:6: warning: =E2=80=98ieee80211_mlme_notify_sca=
n_completed=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4795:6: warning: =E2=80=98ieee80211_sta_setup_sdata=
=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4770:6: warning: =E2=80=98ieee80211_sta_restart=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4710:6: warning: =E2=80=98ieee80211_mgd_quiesce=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4492:6: warning: =E2=80=98ieee80211_sta_work=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4480:6: warning: =E2=80=98ieee80211_mgd_conn_tx_sta=
tus=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4254:6: warning: =E2=80=98ieee80211_sta_rx_queued_m=
gmt=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4234:6: warning: =E2=80=98ieee80211_sta_rx_queued_e=
xt=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
shannon_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xcb4c): Section mismatch in referenc=
e from the function __arm_ioremap_pfn_caller() to the function .meminit.tex=
t:memblock_is_map_memory()

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xd040): Section mismatch in referenc=
e from the function __arm_ioremap_pfn_caller() to the function .meminit.tex=
t:memblock_is_map_memory()

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
spear13xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
spear3xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
spear6xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
spitz_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
stm32_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
sunxi_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
tango4_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
tb0219_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
tb0226_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
tb0287_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
tct_hammer_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm, gcc-10) =E2=80=94 FAIL, 28 errors, 16 warnings, 0 sec=
tion mismatches

Errors:
    net/mac80211/mlme.c:3116:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_deauth=E2=80=99
    net/mac80211/mlme.c:3164:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_disassoc=E2=80=99
    net/mac80211/mlme.c:3195:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_rates=E2=80=99
    net/mac80211/mlme.c:3245:13: error: invalid storage class for function =
=E2=80=98ieee80211_twt_req_supported=E2=80=99
    net/mac80211/mlme.c:3258:12: error: invalid storage class for function =
=E2=80=98ieee80211_recalc_twt_req=E2=80=99
    net/mac80211/mlme.c:3271:13: error: invalid storage class for function =
=E2=80=98ieee80211_assoc_success=E2=80=99
    net/mac80211/mlme.c:3648:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_assoc_resp=E2=80=99
    net/mac80211/mlme.c:3757:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_bss_info=E2=80=99
    net/mac80211/mlme.c:3780:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_probe_resp=E2=80=99
    net/mac80211/mlme.c:3845:13: error: invalid storage class for function =
=E2=80=98ieee80211_handle_beacon_sig=E2=80=99
    net/mac80211/mlme.c:3941:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_our_beacon=E2=80=99
    net/mac80211/mlme.c:3951:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_beacon=E2=80=99
    net/mac80211/mlme.c:4344:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_timer=E2=80=99
    net/mac80211/mlme.c:4352:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_connection_lost=E2=80=99
    net/mac80211/mlme.c:4364:12: error: invalid storage class for function =
=E2=80=98ieee80211_auth=E2=80=99
    net/mac80211/mlme.c:4439:12: error: invalid storage class for function =
=E2=80=98ieee80211_do_assoc=E2=80=99
    net/mac80211/mlme.c:4639:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_bcn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4656:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_conn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4688:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_monitor_work=E2=80=99
    net/mac80211/mlme.c:4697:13: error: invalid storage class for function =
=E2=80=98ieee80211_restart_sta_timer=E2=80=99
    net/mac80211/mlme.c:4847:11: error: invalid storage class for function =
=E2=80=98ieee80211_ht_vht_rx_chains=E2=80=99
    net/mac80211/mlme.c:4892:1: error: invalid storage class for function =
=E2=80=98ieee80211_verify_sta_he_mcs_support=E2=80=99
    net/mac80211/mlme.c:4953:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_channel=E2=80=99
    net/mac80211/mlme.c:5122:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_dtim=E2=80=99
    net/mac80211/mlme.c:5156:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_connection=E2=80=99
    net/mac80211/mlme.c:5947:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_rssi_notify=E2=80=99 follows static declaration
    net/mac80211/mlme.c:5957:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_beacon_loss_notify=E2=80=99 follows static declaration
    include/linux/export.h:67:22: error: expected declaration or statement =
at end of input

Warnings:
    net/mac80211/mlme.c:3062:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    net/mac80211/mlme.c:5898:6: warning: =E2=80=98ieee80211_mgd_stop=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5867:5: warning: =E2=80=98ieee80211_mgd_disassoc=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5803:5: warning: =E2=80=98ieee80211_mgd_deauth=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5480:5: warning: =E2=80=98ieee80211_mgd_assoc=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5330:5: warning: =E2=80=98ieee80211_mgd_auth=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4834:6: warning: =E2=80=98ieee80211_mlme_notify_sca=
n_completed=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4795:6: warning: =E2=80=98ieee80211_sta_setup_sdata=
=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4770:6: warning: =E2=80=98ieee80211_sta_restart=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4710:6: warning: =E2=80=98ieee80211_mgd_quiesce=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4492:6: warning: =E2=80=98ieee80211_sta_work=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4480:6: warning: =E2=80=98ieee80211_mgd_conn_tx_sta=
tus=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4254:6: warning: =E2=80=98ieee80211_sta_rx_queued_m=
gmt=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4234:6: warning: =E2=80=98ieee80211_sta_rx_queued_e=
xt=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
tinyconfig (i386, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
trizeps4_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
u300_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
u8500_defconfig (arm, gcc-10) =E2=80=94 FAIL, 28 errors, 16 warnings, 0 sec=
tion mismatches

Errors:
    net/mac80211/mlme.c:3116:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_deauth=E2=80=99
    net/mac80211/mlme.c:3164:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_disassoc=E2=80=99
    net/mac80211/mlme.c:3195:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_rates=E2=80=99
    net/mac80211/mlme.c:3245:13: error: invalid storage class for function =
=E2=80=98ieee80211_twt_req_supported=E2=80=99
    net/mac80211/mlme.c:3258:12: error: invalid storage class for function =
=E2=80=98ieee80211_recalc_twt_req=E2=80=99
    net/mac80211/mlme.c:3271:13: error: invalid storage class for function =
=E2=80=98ieee80211_assoc_success=E2=80=99
    net/mac80211/mlme.c:3648:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_assoc_resp=E2=80=99
    net/mac80211/mlme.c:3757:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_bss_info=E2=80=99
    net/mac80211/mlme.c:3780:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_probe_resp=E2=80=99
    net/mac80211/mlme.c:3845:13: error: invalid storage class for function =
=E2=80=98ieee80211_handle_beacon_sig=E2=80=99
    net/mac80211/mlme.c:3941:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_our_beacon=E2=80=99
    net/mac80211/mlme.c:3951:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_beacon=E2=80=99
    net/mac80211/mlme.c:4344:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_timer=E2=80=99
    net/mac80211/mlme.c:4352:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_connection_lost=E2=80=99
    net/mac80211/mlme.c:4364:12: error: invalid storage class for function =
=E2=80=98ieee80211_auth=E2=80=99
    net/mac80211/mlme.c:4439:12: error: invalid storage class for function =
=E2=80=98ieee80211_do_assoc=E2=80=99
    net/mac80211/mlme.c:4639:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_bcn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4656:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_conn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4688:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_monitor_work=E2=80=99
    net/mac80211/mlme.c:4697:13: error: invalid storage class for function =
=E2=80=98ieee80211_restart_sta_timer=E2=80=99
    net/mac80211/mlme.c:4847:11: error: invalid storage class for function =
=E2=80=98ieee80211_ht_vht_rx_chains=E2=80=99
    net/mac80211/mlme.c:4892:1: error: invalid storage class for function =
=E2=80=98ieee80211_verify_sta_he_mcs_support=E2=80=99
    net/mac80211/mlme.c:4953:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_channel=E2=80=99
    net/mac80211/mlme.c:5122:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_dtim=E2=80=99
    net/mac80211/mlme.c:5156:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_connection=E2=80=99
    net/mac80211/mlme.c:5947:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_rssi_notify=E2=80=99 follows static declaration
    net/mac80211/mlme.c:5957:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_beacon_loss_notify=E2=80=99 follows static declaration
    include/linux/export.h:67:22: error: expected declaration or statement =
at end of input

Warnings:
    net/mac80211/mlme.c:3062:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    net/mac80211/mlme.c:5898:6: warning: =E2=80=98ieee80211_mgd_stop=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5867:5: warning: =E2=80=98ieee80211_mgd_disassoc=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5803:5: warning: =E2=80=98ieee80211_mgd_deauth=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5480:5: warning: =E2=80=98ieee80211_mgd_assoc=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5330:5: warning: =E2=80=98ieee80211_mgd_auth=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4834:6: warning: =E2=80=98ieee80211_mlme_notify_sca=
n_completed=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4795:6: warning: =E2=80=98ieee80211_sta_setup_sdata=
=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4770:6: warning: =E2=80=98ieee80211_sta_restart=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4710:6: warning: =E2=80=98ieee80211_mgd_quiesce=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4492:6: warning: =E2=80=98ieee80211_sta_work=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4480:6: warning: =E2=80=98ieee80211_mgd_conn_tx_sta=
tus=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4254:6: warning: =E2=80=98ieee80211_sta_rx_queued_m=
gmt=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4234:6: warning: =E2=80=98ieee80211_sta_rx_queued_e=
xt=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
vdk_hs38_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
vdk_hs38_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, =
0 section mismatches

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
vexpress_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
vf610m4_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
viper_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
vocore2_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, =
0 section mismatches

---------------------------------------------------------------------------=
-----
workpad_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
x86_64_defconfig (x86_64, gcc-10) =E2=80=94 FAIL, 28 errors, 21 warnings, 0=
 section mismatches

Errors:
    net/mac80211/mlme.c:3116:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_deauth=E2=80=99
    net/mac80211/mlme.c:3164:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_disassoc=E2=80=99
    net/mac80211/mlme.c:3195:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_rates=E2=80=99
    net/mac80211/mlme.c:3245:13: error: invalid storage class for function =
=E2=80=98ieee80211_twt_req_supported=E2=80=99
    net/mac80211/mlme.c:3258:12: error: invalid storage class for function =
=E2=80=98ieee80211_recalc_twt_req=E2=80=99
    net/mac80211/mlme.c:3271:13: error: invalid storage class for function =
=E2=80=98ieee80211_assoc_success=E2=80=99
    net/mac80211/mlme.c:3648:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_assoc_resp=E2=80=99
    net/mac80211/mlme.c:3757:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_bss_info=E2=80=99
    net/mac80211/mlme.c:3780:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_probe_resp=E2=80=99
    net/mac80211/mlme.c:3845:13: error: invalid storage class for function =
=E2=80=98ieee80211_handle_beacon_sig=E2=80=99
    net/mac80211/mlme.c:3941:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_our_beacon=E2=80=99
    net/mac80211/mlme.c:3951:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_beacon=E2=80=99
    net/mac80211/mlme.c:4344:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_timer=E2=80=99
    net/mac80211/mlme.c:4352:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_connection_lost=E2=80=99
    net/mac80211/mlme.c:4364:12: error: invalid storage class for function =
=E2=80=98ieee80211_auth=E2=80=99
    net/mac80211/mlme.c:4439:12: error: invalid storage class for function =
=E2=80=98ieee80211_do_assoc=E2=80=99
    net/mac80211/mlme.c:4639:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_bcn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4656:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_conn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4688:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_monitor_work=E2=80=99
    net/mac80211/mlme.c:4697:13: error: invalid storage class for function =
=E2=80=98ieee80211_restart_sta_timer=E2=80=99
    net/mac80211/mlme.c:4847:11: error: invalid storage class for function =
=E2=80=98ieee80211_ht_vht_rx_chains=E2=80=99
    net/mac80211/mlme.c:4892:1: error: invalid storage class for function =
=E2=80=98ieee80211_verify_sta_he_mcs_support=E2=80=99
    net/mac80211/mlme.c:4953:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_channel=E2=80=99
    net/mac80211/mlme.c:5122:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_dtim=E2=80=99
    net/mac80211/mlme.c:5156:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_connection=E2=80=99
    net/mac80211/mlme.c:5947:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_rssi_notify=E2=80=99 follows static declaration
    net/mac80211/mlme.c:5957:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_beacon_loss_notify=E2=80=99 follows static declaration
    net/mac80211/mlme.c:5957:1: error: expected declaration or statement at=
 end of input

Warnings:
    net/mac80211/mlme.c:3062:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    include/linux/compiler.h:225:2: warning: ISO C90 forbids mixed declarat=
ions and code [-Wdeclaration-after-statement]
    net/mac80211/mlme.c:5949:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    include/linux/compiler.h:225:2: warning: ISO C90 forbids mixed declarat=
ions and code [-Wdeclaration-after-statement]
    include/linux/export.h:100:20: warning: unused variable =E2=80=98__kstr=
tabns_ieee80211_cqm_beacon_loss_notify=E2=80=99 [-Wunused-variable]
    include/linux/export.h:99:20: warning: unused variable =E2=80=98__kstrt=
ab_ieee80211_cqm_beacon_loss_notify=E2=80=99 [-Wunused-variable]
    include/linux/export.h:100:20: warning: unused variable =E2=80=98__kstr=
tabns_ieee80211_cqm_rssi_notify=E2=80=99 [-Wunused-variable]
    include/linux/export.h:99:20: warning: unused variable =E2=80=98__kstrt=
ab_ieee80211_cqm_rssi_notify=E2=80=99 [-Wunused-variable]
    net/mac80211/mlme.c:5898:6: warning: =E2=80=98ieee80211_mgd_stop=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5867:5: warning: =E2=80=98ieee80211_mgd_disassoc=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5803:5: warning: =E2=80=98ieee80211_mgd_deauth=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5480:5: warning: =E2=80=98ieee80211_mgd_assoc=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5330:5: warning: =E2=80=98ieee80211_mgd_auth=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4834:6: warning: =E2=80=98ieee80211_mlme_notify_sca=
n_completed=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4795:6: warning: =E2=80=98ieee80211_sta_setup_sdata=
=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4770:6: warning: =E2=80=98ieee80211_sta_restart=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4710:6: warning: =E2=80=98ieee80211_mgd_quiesce=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4492:6: warning: =E2=80=98ieee80211_sta_work=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4480:6: warning: =E2=80=98ieee80211_mgd_conn_tx_sta=
tus=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4254:6: warning: =E2=80=98ieee80211_sta_rx_queued_m=
gmt=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4234:6: warning: =E2=80=98ieee80211_sta_rx_queued_e=
xt=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
x86_64_defconfig+x86-chromebook (x86_64, gcc-10) =E2=80=94 FAIL, 28 errors,=
 21 warnings, 0 section mismatches

Errors:
    net/mac80211/mlme.c:3116:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_deauth=E2=80=99
    net/mac80211/mlme.c:3164:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_disassoc=E2=80=99
    net/mac80211/mlme.c:3195:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_rates=E2=80=99
    net/mac80211/mlme.c:3245:13: error: invalid storage class for function =
=E2=80=98ieee80211_twt_req_supported=E2=80=99
    net/mac80211/mlme.c:3258:12: error: invalid storage class for function =
=E2=80=98ieee80211_recalc_twt_req=E2=80=99
    net/mac80211/mlme.c:3271:13: error: invalid storage class for function =
=E2=80=98ieee80211_assoc_success=E2=80=99
    net/mac80211/mlme.c:3648:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_assoc_resp=E2=80=99
    net/mac80211/mlme.c:3757:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_bss_info=E2=80=99
    net/mac80211/mlme.c:3780:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_probe_resp=E2=80=99
    net/mac80211/mlme.c:3845:13: error: invalid storage class for function =
=E2=80=98ieee80211_handle_beacon_sig=E2=80=99
    net/mac80211/mlme.c:3941:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_our_beacon=E2=80=99
    net/mac80211/mlme.c:3951:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_beacon=E2=80=99
    net/mac80211/mlme.c:4344:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_timer=E2=80=99
    net/mac80211/mlme.c:4352:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_connection_lost=E2=80=99
    net/mac80211/mlme.c:4364:12: error: invalid storage class for function =
=E2=80=98ieee80211_auth=E2=80=99
    net/mac80211/mlme.c:4439:12: error: invalid storage class for function =
=E2=80=98ieee80211_do_assoc=E2=80=99
    net/mac80211/mlme.c:4639:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_bcn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4656:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_conn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4688:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_monitor_work=E2=80=99
    net/mac80211/mlme.c:4697:13: error: invalid storage class for function =
=E2=80=98ieee80211_restart_sta_timer=E2=80=99
    net/mac80211/mlme.c:4847:11: error: invalid storage class for function =
=E2=80=98ieee80211_ht_vht_rx_chains=E2=80=99
    net/mac80211/mlme.c:4892:1: error: invalid storage class for function =
=E2=80=98ieee80211_verify_sta_he_mcs_support=E2=80=99
    net/mac80211/mlme.c:4953:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_channel=E2=80=99
    net/mac80211/mlme.c:5122:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_dtim=E2=80=99
    net/mac80211/mlme.c:5156:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_connection=E2=80=99
    net/mac80211/mlme.c:5947:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_rssi_notify=E2=80=99 follows static declaration
    net/mac80211/mlme.c:5957:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_beacon_loss_notify=E2=80=99 follows static declaration
    net/mac80211/mlme.c:5957:1: error: expected declaration or statement at=
 end of input

Warnings:
    net/mac80211/mlme.c:3062:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    include/linux/compiler.h:225:2: warning: ISO C90 forbids mixed declarat=
ions and code [-Wdeclaration-after-statement]
    net/mac80211/mlme.c:5949:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    include/linux/compiler.h:225:2: warning: ISO C90 forbids mixed declarat=
ions and code [-Wdeclaration-after-statement]
    include/linux/export.h:100:20: warning: unused variable =E2=80=98__kstr=
tabns_ieee80211_cqm_beacon_loss_notify=E2=80=99 [-Wunused-variable]
    include/linux/export.h:99:20: warning: unused variable =E2=80=98__kstrt=
ab_ieee80211_cqm_beacon_loss_notify=E2=80=99 [-Wunused-variable]
    include/linux/export.h:100:20: warning: unused variable =E2=80=98__kstr=
tabns_ieee80211_cqm_rssi_notify=E2=80=99 [-Wunused-variable]
    include/linux/export.h:99:20: warning: unused variable =E2=80=98__kstrt=
ab_ieee80211_cqm_rssi_notify=E2=80=99 [-Wunused-variable]
    net/mac80211/mlme.c:5898:6: warning: =E2=80=98ieee80211_mgd_stop=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5867:5: warning: =E2=80=98ieee80211_mgd_disassoc=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5803:5: warning: =E2=80=98ieee80211_mgd_deauth=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5480:5: warning: =E2=80=98ieee80211_mgd_assoc=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5330:5: warning: =E2=80=98ieee80211_mgd_auth=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4834:6: warning: =E2=80=98ieee80211_mlme_notify_sca=
n_completed=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4795:6: warning: =E2=80=98ieee80211_sta_setup_sdata=
=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4770:6: warning: =E2=80=98ieee80211_sta_restart=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4710:6: warning: =E2=80=98ieee80211_mgd_quiesce=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4492:6: warning: =E2=80=98ieee80211_sta_work=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4480:6: warning: =E2=80=98ieee80211_mgd_conn_tx_sta=
tus=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4254:6: warning: =E2=80=98ieee80211_sta_rx_queued_m=
gmt=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4234:6: warning: =E2=80=98ieee80211_sta_rx_queued_e=
xt=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
xcep_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-10) =E2=80=94 FAIL, 28 errors, 16 warnings, 0 sect=
ion mismatches

Errors:
    net/mac80211/mlme.c:3116:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_deauth=E2=80=99
    net/mac80211/mlme.c:3164:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_disassoc=E2=80=99
    net/mac80211/mlme.c:3195:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_rates=E2=80=99
    net/mac80211/mlme.c:3245:13: error: invalid storage class for function =
=E2=80=98ieee80211_twt_req_supported=E2=80=99
    net/mac80211/mlme.c:3258:12: error: invalid storage class for function =
=E2=80=98ieee80211_recalc_twt_req=E2=80=99
    net/mac80211/mlme.c:3271:13: error: invalid storage class for function =
=E2=80=98ieee80211_assoc_success=E2=80=99
    net/mac80211/mlme.c:3648:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_assoc_resp=E2=80=99
    net/mac80211/mlme.c:3757:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_bss_info=E2=80=99
    net/mac80211/mlme.c:3780:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_probe_resp=E2=80=99
    net/mac80211/mlme.c:3845:13: error: invalid storage class for function =
=E2=80=98ieee80211_handle_beacon_sig=E2=80=99
    net/mac80211/mlme.c:3941:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_our_beacon=E2=80=99
    net/mac80211/mlme.c:3951:13: error: invalid storage class for function =
=E2=80=98ieee80211_rx_mgmt_beacon=E2=80=99
    net/mac80211/mlme.c:4344:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_timer=E2=80=99
    net/mac80211/mlme.c:4352:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_connection_lost=E2=80=99
    net/mac80211/mlme.c:4364:12: error: invalid storage class for function =
=E2=80=98ieee80211_auth=E2=80=99
    net/mac80211/mlme.c:4439:12: error: invalid storage class for function =
=E2=80=98ieee80211_do_assoc=E2=80=99
    net/mac80211/mlme.c:4639:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_bcn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4656:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_conn_mon_timer=E2=80=99
    net/mac80211/mlme.c:4688:13: error: invalid storage class for function =
=E2=80=98ieee80211_sta_monitor_work=E2=80=99
    net/mac80211/mlme.c:4697:13: error: invalid storage class for function =
=E2=80=98ieee80211_restart_sta_timer=E2=80=99
    net/mac80211/mlme.c:4847:11: error: invalid storage class for function =
=E2=80=98ieee80211_ht_vht_rx_chains=E2=80=99
    net/mac80211/mlme.c:4892:1: error: invalid storage class for function =
=E2=80=98ieee80211_verify_sta_he_mcs_support=E2=80=99
    net/mac80211/mlme.c:4953:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_channel=E2=80=99
    net/mac80211/mlme.c:5122:13: error: invalid storage class for function =
=E2=80=98ieee80211_get_dtim=E2=80=99
    net/mac80211/mlme.c:5156:12: error: invalid storage class for function =
=E2=80=98ieee80211_prep_connection=E2=80=99
    net/mac80211/mlme.c:5947:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_rssi_notify=E2=80=99 follows static declaration
    net/mac80211/mlme.c:5957:15: error: non-static declaration of =E2=80=98=
ieee80211_cqm_beacon_loss_notify=E2=80=99 follows static declaration
    include/linux/export.h:67:22: error: expected declaration or statement =
at end of input

Warnings:
    net/mac80211/mlme.c:3062:1: warning: ISO C90 forbids mixed declarations=
 and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    include/linux/export.h:67:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    net/mac80211/mlme.c:5898:6: warning: =E2=80=98ieee80211_mgd_stop=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5867:5: warning: =E2=80=98ieee80211_mgd_disassoc=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5803:5: warning: =E2=80=98ieee80211_mgd_deauth=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5480:5: warning: =E2=80=98ieee80211_mgd_assoc=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:5330:5: warning: =E2=80=98ieee80211_mgd_auth=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4834:6: warning: =E2=80=98ieee80211_mlme_notify_sca=
n_completed=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4795:6: warning: =E2=80=98ieee80211_sta_setup_sdata=
=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4770:6: warning: =E2=80=98ieee80211_sta_restart=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4710:6: warning: =E2=80=98ieee80211_mgd_quiesce=E2=
=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4492:6: warning: =E2=80=98ieee80211_sta_work=E2=80=
=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4480:6: warning: =E2=80=98ieee80211_mgd_conn_tx_sta=
tus=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4254:6: warning: =E2=80=98ieee80211_sta_rx_queued_m=
gmt=E2=80=99 defined but not used [-Wunused-function]
    net/mac80211/mlme.c:4234:6: warning: =E2=80=98ieee80211_sta_rx_queued_e=
xt=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
zx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---
For more info write to <info@kernelci.org>
