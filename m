Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5690A4B3C00
	for <lists+stable@lfdr.de>; Sun, 13 Feb 2022 16:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236577AbiBMPSp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Feb 2022 10:18:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233396AbiBMPSp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Feb 2022 10:18:45 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 541E35BD0D
        for <stable@vger.kernel.org>; Sun, 13 Feb 2022 07:18:37 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id v13-20020a17090ac90d00b001b87bc106bdso16494366pjt.4
        for <stable@vger.kernel.org>; Sun, 13 Feb 2022 07:18:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yKYItfcDn/gHtoIcOYumCk0sOBI0ytZ6t9ApJGhASL0=;
        b=RoC6hokhECnvP6JYEexCEZvNCRf+5kMHkza7F55pv7KjN6/w/PxfCIfoapDQdb/FSm
         2FCU7qR50gkEW0lF3W/UkOHJ2cD0I9Z7zxlMw/CZ6yN9j0XN/v32nNIpoTZY7dnCM+kJ
         aYETHwWITLf1o6OCgVVHLKKbOja692eFc1G93Pg/MFHPzU9EC5MVDYBdeP8YLND+1fux
         nBRhOiXlyNKY4NuLjvwhIdaB5Dy9HtRpNyFdsokdXy/UPVBkg5FuBVDawnotHlM7Z07U
         zkiNThAmDcLIPZ5T7WhwdW17jhdQQgljevtdp5izQ4R9zisNkXbiFp2ywSl0p2sFdvuK
         9xOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yKYItfcDn/gHtoIcOYumCk0sOBI0ytZ6t9ApJGhASL0=;
        b=B6adDzwK3YxO1cdikrRYYQjDTlW8bs2CuoApx0H6j0m/IuaG+jVcxA8GbjfnMyGtTp
         +I8ENazWXVRMJnxjmeyixUFpDDpoX3Mlu5OxY7ndms2rXkUSGnf/eeoswTAXVTY3MoCz
         OZKcMBH6hi7HccZEQqgBQXhRSolqUGW7Xu2/oPBRCWg9wQHVuKsCvSiwIWEj1/mqJWmA
         dMLHkQNeKPAEiqUT4BDJYTJwWbQU3klCu8Ae5usv04qPWvHsYfraC+hpR231Pd+jWcDD
         h3eypCPqjn5G2QvVVdRQ6qEljknsQmLssOT9PyDBFx5d0Abh8G2ouzgV1dhDjqZ8c8iw
         91XQ==
X-Gm-Message-State: AOAM533Y8E19In9GLppEv8pyaB0sBCbIHnLgzn3TrQB5aQndtv0xVPXb
        XD3kSKXmacsTVs32nR+jFsdA/MkX4O3KMplt
X-Google-Smtp-Source: ABdhPJw8X0qbzdu6kWSG6NzIInMD0T1lANSOWmqC10KbPoBDb96F4kev+HsFOicdZ10jSg1876DlWg==
X-Received: by 2002:a17:902:d4c2:: with SMTP id o2mr10350647plg.14.1644765515749;
        Sun, 13 Feb 2022 07:18:35 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 132sm21029145pfw.21.2022.02.13.07.18.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Feb 2022 07:18:35 -0800 (PST)
Message-ID: <6209214b.1c69fb81.d3b83.3e67@mx.google.com>
Date:   Sun, 13 Feb 2022 07:18:35 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.16
X-Kernelci-Kernel: v5.16.9-192-gafce8e2e1a82
Subject: stable-rc/queue/5.16 build: 178 builds: 6 failed, 172 passed,
 103 errors, 4 warnings (v5.16.9-192-gafce8e2e1a82)
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

stable-rc/queue/5.16 build: 178 builds: 6 failed, 172 passed, 103 errors, 4=
 warnings (v5.16.9-192-gafce8e2e1a82)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F5.1=
6/kernel/v5.16.9-192-gafce8e2e1a82/

Tree: stable-rc
Branch: queue/5.16
Git Describe: v5.16.9-192-gafce8e2e1a82
Git Commit: afce8e2e1a825f77816489a342f75e2d08b32145
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 7 unique architectures

Build Failures Detected:

arm:
    qcom_defconfig: (gcc-10) FAIL
    rpc_defconfig: (gcc-10) FAIL

mips:
    cavium_octeon_defconfig: (gcc-10) FAIL
    decstation_64_defconfig: (gcc-10) FAIL
    ip27_defconfig: (gcc-10) FAIL
    ip28_defconfig: (gcc-10) FAIL

Errors and Warnings Detected:

arc:
    tinyconfig (gcc-10): 1 warning

arm64:

arm:
    qcom_defconfig (gcc-10): 1 error
    rpc_defconfig (gcc-10): 2 errors

i386:

mips:
    32r2el_defconfig (gcc-10): 1 warning
    bigsur_defconfig (gcc-10): 1 error
    cavium_octeon_defconfig (gcc-10): 92 errors
    ci20_defconfig (gcc-10): 1 warning
    decstation_64_defconfig (gcc-10): 1 error
    fuloong2e_defconfig (gcc-10): 1 error
    ip32_defconfig (gcc-10): 1 error
    lemote2f_defconfig (gcc-10): 1 error
    loongson2k_defconfig (gcc-10): 1 error
    loongson3_defconfig (gcc-10): 1 error
    rm200_defconfig (gcc-10): 1 warning
    sb1250_swarm_defconfig (gcc-10): 1 error

riscv:

x86_64:

Errors summary:

    8    expr: syntax error: unexpected argument =E2=80=980xffffffff8000000=
0=E2=80=99
    1    arch/mips/cavium-octeon/octeon-memcpy.S:399: Error: unrecognized o=
pcode `ptr 9b,l_exc'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:375: Error: unrecognized o=
pcode `ptr 9b,s_exc_p1'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:372: Error: unrecognized o=
pcode `ptr 9b,l_exc'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:371: Error: unrecognized o=
pcode `ptr 9b,s_exc_p1'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:371: Error: unrecognized o=
pcode `ptr 9b,l_exc'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:370: Error: unrecognized o=
pcode `ptr 9b,s_exc_p1'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:370: Error: unrecognized o=
pcode `ptr 9b,l_exc'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:369: Error: unrecognized o=
pcode `ptr 9b,s_exc_p1'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:369: Error: unrecognized o=
pcode `ptr 9b,l_exc'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:368: Error: unrecognized o=
pcode `ptr 9b,s_exc_p1'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:368: Error: unrecognized o=
pcode `ptr 9b,l_exc'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:367: Error: unrecognized o=
pcode `ptr 9b,s_exc_p1'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:367: Error: unrecognized o=
pcode `ptr 9b,l_exc'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:366: Error: unrecognized o=
pcode `ptr 9b,s_exc_p1'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:366: Error: unrecognized o=
pcode `ptr 9b,l_exc'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:350: Error: unrecognized o=
pcode `ptr 9b,s_exc_p1u'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:348: Error: unrecognized o=
pcode `ptr 9b,l_exc_copy'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:347: Error: unrecognized o=
pcode `ptr 9b,l_exc'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:337: Error: unrecognized o=
pcode `ptr 9b,s_exc_p1u'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:336: Error: unrecognized o=
pcode `ptr 9b,s_exc_p2u'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:335: Error: unrecognized o=
pcode `ptr 9b,s_exc_p3u'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:334: Error: unrecognized o=
pcode `ptr 9b,s_exc_p4u'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:332: Error: unrecognized o=
pcode `ptr 9b,l_exc_copy'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:331: Error: unrecognized o=
pcode `ptr 9b,l_exc_copy'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:330: Error: unrecognized o=
pcode `ptr 9b,l_exc_copy'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:329: Error: unrecognized o=
pcode `ptr 9b,l_exc_copy'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:328: Error: unrecognized o=
pcode `ptr 9b,l_exc_copy'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:327: Error: unrecognized o=
pcode `ptr 9b,l_exc_copy'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:325: Error: unrecognized o=
pcode `ptr 9b,l_exc_copy'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:324: Error: unrecognized o=
pcode `ptr 9b,l_exc'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:310: Error: unrecognized o=
pcode `ptr 9b,s_exc_p1u'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:305: Error: unrecognized o=
pcode `ptr 9b,l_exc'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:298: Error: unrecognized o=
pcode `ptr 9b,s_exc_p1u'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:295: Error: unrecognized o=
pcode `ptr 9b,l_exc'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:288: Error: unrecognized o=
pcode `ptr 9b,s_exc_p1u'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:285: Error: unrecognized o=
pcode `ptr 9b,l_exc'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:270: Error: unrecognized o=
pcode `ptr 9b,s_exc_p1u'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:269: Error: unrecognized o=
pcode `ptr 9b,s_exc_p2u'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:268: Error: unrecognized o=
pcode `ptr 9b,s_exc_p3u'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:267: Error: unrecognized o=
pcode `ptr 9b,s_exc_p4u'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:265: Error: unrecognized o=
pcode `ptr 9b,l_exc_copy'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:264: Error: unrecognized o=
pcode `ptr 9b,l_exc_copy'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:263: Error: unrecognized o=
pcode `ptr 9b,l_exc_copy'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:262: Error: unrecognized o=
pcode `ptr 9b,l_exc'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:251: Error: unrecognized o=
pcode `ptr 9b,s_exc_p1u'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:250: Error: unrecognized o=
pcode `ptr 9b,s_exc_p2u'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:249: Error: unrecognized o=
pcode `ptr 9b,s_exc_p3u'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:248: Error: unrecognized o=
pcode `ptr 9b,s_exc_p4u'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:247: Error: unrecognized o=
pcode `ptr 9b,l_exc_copy'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:246: Error: unrecognized o=
pcode `ptr 9b,l_exc_copy'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:245: Error: unrecognized o=
pcode `ptr 9b,l_exc_copy'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:244: Error: unrecognized o=
pcode `ptr 9b,l_exc_copy'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:243: Error: unrecognized o=
pcode `ptr 9b,s_exc_p5u'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:242: Error: unrecognized o=
pcode `ptr 9b,s_exc_p6u'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:241: Error: unrecognized o=
pcode `ptr 9b,s_exc_p7u'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:240: Error: unrecognized o=
pcode `ptr 9b,s_exc_p8u'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:238: Error: unrecognized o=
pcode `ptr 9b,l_exc_copy'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:237: Error: unrecognized o=
pcode `ptr 9b,l_exc_copy'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:236: Error: unrecognized o=
pcode `ptr 9b,l_exc_copy'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:235: Error: unrecognized o=
pcode `ptr 9b,l_exc'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:221: Error: unrecognized o=
pcode `ptr 9b,s_exc_p1u'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:220: Error: unrecognized o=
pcode `ptr 9b,s_exc_p2u'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:219: Error: unrecognized o=
pcode `ptr 9b,s_exc_p3u'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:218: Error: unrecognized o=
pcode `ptr 9b,s_exc_p4u'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:217: Error: unrecognized o=
pcode `ptr 9b,l_exc_copy_rewind16'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:216: Error: unrecognized o=
pcode `ptr 9b,l_exc_copy_rewind16'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:215: Error: unrecognized o=
pcode `ptr 9b,l_exc_copy_rewind16'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:214: Error: unrecognized o=
pcode `ptr 9b,l_exc_copy_rewind16'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:213: Error: unrecognized o=
pcode `ptr 9b,s_exc_p5u'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:212: Error: unrecognized o=
pcode `ptr 9b,s_exc_p6u'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:211: Error: unrecognized o=
pcode `ptr 9b,s_exc_p7u'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:210: Error: unrecognized o=
pcode `ptr 9b,s_exc_p8u'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:209: Error: unrecognized o=
pcode `ptr 9b,l_exc_copy_rewind16'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:208: Error: unrecognized o=
pcode `ptr 9b,l_exc_copy_rewind16'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:207: Error: unrecognized o=
pcode `ptr 9b,l_exc_copy_rewind16'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:206: Error: unrecognized o=
pcode `ptr 9b,l_exc_copy_rewind16'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:204: Error: unrecognized o=
pcode `ptr 9b,s_exc_p9u'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:202: Error: unrecognized o=
pcode `ptr 9b,s_exc_p10u'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:201: Error: unrecognized o=
pcode `ptr 9b,s_exc_p11u'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:200: Error: unrecognized o=
pcode `ptr 9b,s_exc_p12u'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:199: Error: unrecognized o=
pcode `ptr 9b,l_exc_copy'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:198: Error: unrecognized o=
pcode `ptr 9b,l_exc_copy'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:197: Error: unrecognized o=
pcode `ptr 9b,l_exc_copy'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:196: Error: unrecognized o=
pcode `ptr 9b,l_exc_copy'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:195: Error: unrecognized o=
pcode `ptr 9b,s_exc_p13u'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:194: Error: unrecognized o=
pcode `ptr 9b,s_exc_p14u'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:193: Error: unrecognized o=
pcode `ptr 9b,s_exc_p15u'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:192: Error: unrecognized o=
pcode `ptr 9b,s_exc_p16u'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:190: Error: unrecognized o=
pcode `ptr 9b,l_exc_copy'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:189: Error: unrecognized o=
pcode `ptr 9b,l_exc_copy'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:188: Error: unrecognized o=
pcode `ptr 9b,l_exc_copy'
    1    arch/mips/cavium-octeon/octeon-memcpy.S:187: Error: unrecognized o=
pcode `ptr 9b,l_exc'
    1    arch/arm/kernel/head.S:319: Error: missing expression -- `ldr r7,=
=3D0x'
    1    arch/arm/kernel/head.S:319: Error: missing expression -- `ldr r3,=
=3D0x'
    1    /tmp/kci/linux/build/../drivers/gpu/drm/panel/panel-edp.c:843: und=
efined reference to `drm_panel_dp_aux_backlight'

Warnings summary:

    1    drivers/block/paride/bpck.c:32: warning: "PC" redefined
    1    arch/mips/boot/dts/ingenic/jz4780.dtsi:473.33-475.6: Warning (unit=
_address_format): /nemc@13410000/efuse@d0/eth-mac-addr@0x22: unit name shou=
ld not have leading "0x"
    1    arch/mips/boot/dts/img/boston.dts:128.19-178.5: Warning (pci_devic=
e_reg): /pci@14000000/pci2_root@0,0,0: PCI unit address format error, expec=
ted "0,0"
    1    arch/arc/Makefile:26: ** WARNING ** CONFIG_ARC_TUNE_MCPU flag '' i=
s unknown, fallback to ''

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
    arch/mips/boot/dts/img/boston.dts:128.19-178.5: Warning (pci_device_reg=
): /pci@14000000/pci2_root@0,0,0: PCI unit address format error, expected "=
0,0"

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
allnoconfig (x86_64, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
am200epdkit_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
ar7_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

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

---------------------------------------------------------------------------=
-----
at91_dt_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
ath25_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
axm55xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
axs103_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
axs103_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
badge4_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
bcm2835_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
bcm47xx_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
bcm63xx_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
bigsur_defconfig (mips, gcc-10) =E2=80=94 PASS, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-10) =E2=80=94 FAIL, 92 errors, 0 warning=
s, 0 section mismatches

Errors:
    arch/mips/cavium-octeon/octeon-memcpy.S:187: Error: unrecognized opcode=
 `ptr 9b,l_exc'
    arch/mips/cavium-octeon/octeon-memcpy.S:188: Error: unrecognized opcode=
 `ptr 9b,l_exc_copy'
    arch/mips/cavium-octeon/octeon-memcpy.S:189: Error: unrecognized opcode=
 `ptr 9b,l_exc_copy'
    arch/mips/cavium-octeon/octeon-memcpy.S:190: Error: unrecognized opcode=
 `ptr 9b,l_exc_copy'
    arch/mips/cavium-octeon/octeon-memcpy.S:192: Error: unrecognized opcode=
 `ptr 9b,s_exc_p16u'
    arch/mips/cavium-octeon/octeon-memcpy.S:193: Error: unrecognized opcode=
 `ptr 9b,s_exc_p15u'
    arch/mips/cavium-octeon/octeon-memcpy.S:194: Error: unrecognized opcode=
 `ptr 9b,s_exc_p14u'
    arch/mips/cavium-octeon/octeon-memcpy.S:195: Error: unrecognized opcode=
 `ptr 9b,s_exc_p13u'
    arch/mips/cavium-octeon/octeon-memcpy.S:196: Error: unrecognized opcode=
 `ptr 9b,l_exc_copy'
    arch/mips/cavium-octeon/octeon-memcpy.S:197: Error: unrecognized opcode=
 `ptr 9b,l_exc_copy'
    arch/mips/cavium-octeon/octeon-memcpy.S:198: Error: unrecognized opcode=
 `ptr 9b,l_exc_copy'
    arch/mips/cavium-octeon/octeon-memcpy.S:199: Error: unrecognized opcode=
 `ptr 9b,l_exc_copy'
    arch/mips/cavium-octeon/octeon-memcpy.S:200: Error: unrecognized opcode=
 `ptr 9b,s_exc_p12u'
    arch/mips/cavium-octeon/octeon-memcpy.S:201: Error: unrecognized opcode=
 `ptr 9b,s_exc_p11u'
    arch/mips/cavium-octeon/octeon-memcpy.S:202: Error: unrecognized opcode=
 `ptr 9b,s_exc_p10u'
    arch/mips/cavium-octeon/octeon-memcpy.S:204: Error: unrecognized opcode=
 `ptr 9b,s_exc_p9u'
    arch/mips/cavium-octeon/octeon-memcpy.S:206: Error: unrecognized opcode=
 `ptr 9b,l_exc_copy_rewind16'
    arch/mips/cavium-octeon/octeon-memcpy.S:207: Error: unrecognized opcode=
 `ptr 9b,l_exc_copy_rewind16'
    arch/mips/cavium-octeon/octeon-memcpy.S:208: Error: unrecognized opcode=
 `ptr 9b,l_exc_copy_rewind16'
    arch/mips/cavium-octeon/octeon-memcpy.S:209: Error: unrecognized opcode=
 `ptr 9b,l_exc_copy_rewind16'
    arch/mips/cavium-octeon/octeon-memcpy.S:210: Error: unrecognized opcode=
 `ptr 9b,s_exc_p8u'
    arch/mips/cavium-octeon/octeon-memcpy.S:211: Error: unrecognized opcode=
 `ptr 9b,s_exc_p7u'
    arch/mips/cavium-octeon/octeon-memcpy.S:212: Error: unrecognized opcode=
 `ptr 9b,s_exc_p6u'
    arch/mips/cavium-octeon/octeon-memcpy.S:213: Error: unrecognized opcode=
 `ptr 9b,s_exc_p5u'
    arch/mips/cavium-octeon/octeon-memcpy.S:214: Error: unrecognized opcode=
 `ptr 9b,l_exc_copy_rewind16'
    arch/mips/cavium-octeon/octeon-memcpy.S:215: Error: unrecognized opcode=
 `ptr 9b,l_exc_copy_rewind16'
    arch/mips/cavium-octeon/octeon-memcpy.S:216: Error: unrecognized opcode=
 `ptr 9b,l_exc_copy_rewind16'
    arch/mips/cavium-octeon/octeon-memcpy.S:217: Error: unrecognized opcode=
 `ptr 9b,l_exc_copy_rewind16'
    arch/mips/cavium-octeon/octeon-memcpy.S:218: Error: unrecognized opcode=
 `ptr 9b,s_exc_p4u'
    arch/mips/cavium-octeon/octeon-memcpy.S:219: Error: unrecognized opcode=
 `ptr 9b,s_exc_p3u'
    arch/mips/cavium-octeon/octeon-memcpy.S:220: Error: unrecognized opcode=
 `ptr 9b,s_exc_p2u'
    arch/mips/cavium-octeon/octeon-memcpy.S:221: Error: unrecognized opcode=
 `ptr 9b,s_exc_p1u'
    arch/mips/cavium-octeon/octeon-memcpy.S:235: Error: unrecognized opcode=
 `ptr 9b,l_exc'
    arch/mips/cavium-octeon/octeon-memcpy.S:236: Error: unrecognized opcode=
 `ptr 9b,l_exc_copy'
    arch/mips/cavium-octeon/octeon-memcpy.S:237: Error: unrecognized opcode=
 `ptr 9b,l_exc_copy'
    arch/mips/cavium-octeon/octeon-memcpy.S:238: Error: unrecognized opcode=
 `ptr 9b,l_exc_copy'
    arch/mips/cavium-octeon/octeon-memcpy.S:240: Error: unrecognized opcode=
 `ptr 9b,s_exc_p8u'
    arch/mips/cavium-octeon/octeon-memcpy.S:241: Error: unrecognized opcode=
 `ptr 9b,s_exc_p7u'
    arch/mips/cavium-octeon/octeon-memcpy.S:242: Error: unrecognized opcode=
 `ptr 9b,s_exc_p6u'
    arch/mips/cavium-octeon/octeon-memcpy.S:243: Error: unrecognized opcode=
 `ptr 9b,s_exc_p5u'
    arch/mips/cavium-octeon/octeon-memcpy.S:244: Error: unrecognized opcode=
 `ptr 9b,l_exc_copy'
    arch/mips/cavium-octeon/octeon-memcpy.S:245: Error: unrecognized opcode=
 `ptr 9b,l_exc_copy'
    arch/mips/cavium-octeon/octeon-memcpy.S:246: Error: unrecognized opcode=
 `ptr 9b,l_exc_copy'
    arch/mips/cavium-octeon/octeon-memcpy.S:247: Error: unrecognized opcode=
 `ptr 9b,l_exc_copy'
    arch/mips/cavium-octeon/octeon-memcpy.S:248: Error: unrecognized opcode=
 `ptr 9b,s_exc_p4u'
    arch/mips/cavium-octeon/octeon-memcpy.S:249: Error: unrecognized opcode=
 `ptr 9b,s_exc_p3u'
    arch/mips/cavium-octeon/octeon-memcpy.S:250: Error: unrecognized opcode=
 `ptr 9b,s_exc_p2u'
    arch/mips/cavium-octeon/octeon-memcpy.S:251: Error: unrecognized opcode=
 `ptr 9b,s_exc_p1u'
    arch/mips/cavium-octeon/octeon-memcpy.S:262: Error: unrecognized opcode=
 `ptr 9b,l_exc'
    arch/mips/cavium-octeon/octeon-memcpy.S:263: Error: unrecognized opcode=
 `ptr 9b,l_exc_copy'
    arch/mips/cavium-octeon/octeon-memcpy.S:264: Error: unrecognized opcode=
 `ptr 9b,l_exc_copy'
    arch/mips/cavium-octeon/octeon-memcpy.S:265: Error: unrecognized opcode=
 `ptr 9b,l_exc_copy'
    arch/mips/cavium-octeon/octeon-memcpy.S:267: Error: unrecognized opcode=
 `ptr 9b,s_exc_p4u'
    arch/mips/cavium-octeon/octeon-memcpy.S:268: Error: unrecognized opcode=
 `ptr 9b,s_exc_p3u'
    arch/mips/cavium-octeon/octeon-memcpy.S:269: Error: unrecognized opcode=
 `ptr 9b,s_exc_p2u'
    arch/mips/cavium-octeon/octeon-memcpy.S:270: Error: unrecognized opcode=
 `ptr 9b,s_exc_p1u'
    arch/mips/cavium-octeon/octeon-memcpy.S:285: Error: unrecognized opcode=
 `ptr 9b,l_exc'
    arch/mips/cavium-octeon/octeon-memcpy.S:288: Error: unrecognized opcode=
 `ptr 9b,s_exc_p1u'
    arch/mips/cavium-octeon/octeon-memcpy.S:295: Error: unrecognized opcode=
 `ptr 9b,l_exc'
    arch/mips/cavium-octeon/octeon-memcpy.S:298: Error: unrecognized opcode=
 `ptr 9b,s_exc_p1u'
    arch/mips/cavium-octeon/octeon-memcpy.S:305: Error: unrecognized opcode=
 `ptr 9b,l_exc'
    arch/mips/cavium-octeon/octeon-memcpy.S:310: Error: unrecognized opcode=
 `ptr 9b,s_exc_p1u'
    arch/mips/cavium-octeon/octeon-memcpy.S:324: Error: unrecognized opcode=
 `ptr 9b,l_exc'
    arch/mips/cavium-octeon/octeon-memcpy.S:325: Error: unrecognized opcode=
 `ptr 9b,l_exc_copy'
    arch/mips/cavium-octeon/octeon-memcpy.S:327: Error: unrecognized opcode=
 `ptr 9b,l_exc_copy'
    arch/mips/cavium-octeon/octeon-memcpy.S:328: Error: unrecognized opcode=
 `ptr 9b,l_exc_copy'
    arch/mips/cavium-octeon/octeon-memcpy.S:329: Error: unrecognized opcode=
 `ptr 9b,l_exc_copy'
    arch/mips/cavium-octeon/octeon-memcpy.S:330: Error: unrecognized opcode=
 `ptr 9b,l_exc_copy'
    arch/mips/cavium-octeon/octeon-memcpy.S:331: Error: unrecognized opcode=
 `ptr 9b,l_exc_copy'
    arch/mips/cavium-octeon/octeon-memcpy.S:332: Error: unrecognized opcode=
 `ptr 9b,l_exc_copy'
    arch/mips/cavium-octeon/octeon-memcpy.S:334: Error: unrecognized opcode=
 `ptr 9b,s_exc_p4u'
    arch/mips/cavium-octeon/octeon-memcpy.S:335: Error: unrecognized opcode=
 `ptr 9b,s_exc_p3u'
    arch/mips/cavium-octeon/octeon-memcpy.S:336: Error: unrecognized opcode=
 `ptr 9b,s_exc_p2u'
    arch/mips/cavium-octeon/octeon-memcpy.S:337: Error: unrecognized opcode=
 `ptr 9b,s_exc_p1u'
    arch/mips/cavium-octeon/octeon-memcpy.S:347: Error: unrecognized opcode=
 `ptr 9b,l_exc'
    arch/mips/cavium-octeon/octeon-memcpy.S:348: Error: unrecognized opcode=
 `ptr 9b,l_exc_copy'
    arch/mips/cavium-octeon/octeon-memcpy.S:350: Error: unrecognized opcode=
 `ptr 9b,s_exc_p1u'
    arch/mips/cavium-octeon/octeon-memcpy.S:366: Error: unrecognized opcode=
 `ptr 9b,l_exc'
    arch/mips/cavium-octeon/octeon-memcpy.S:366: Error: unrecognized opcode=
 `ptr 9b,s_exc_p1'
    arch/mips/cavium-octeon/octeon-memcpy.S:367: Error: unrecognized opcode=
 `ptr 9b,l_exc'
    arch/mips/cavium-octeon/octeon-memcpy.S:367: Error: unrecognized opcode=
 `ptr 9b,s_exc_p1'
    arch/mips/cavium-octeon/octeon-memcpy.S:368: Error: unrecognized opcode=
 `ptr 9b,l_exc'
    arch/mips/cavium-octeon/octeon-memcpy.S:368: Error: unrecognized opcode=
 `ptr 9b,s_exc_p1'
    arch/mips/cavium-octeon/octeon-memcpy.S:369: Error: unrecognized opcode=
 `ptr 9b,l_exc'
    arch/mips/cavium-octeon/octeon-memcpy.S:369: Error: unrecognized opcode=
 `ptr 9b,s_exc_p1'
    arch/mips/cavium-octeon/octeon-memcpy.S:370: Error: unrecognized opcode=
 `ptr 9b,l_exc'
    arch/mips/cavium-octeon/octeon-memcpy.S:370: Error: unrecognized opcode=
 `ptr 9b,s_exc_p1'
    arch/mips/cavium-octeon/octeon-memcpy.S:371: Error: unrecognized opcode=
 `ptr 9b,l_exc'
    arch/mips/cavium-octeon/octeon-memcpy.S:371: Error: unrecognized opcode=
 `ptr 9b,s_exc_p1'
    arch/mips/cavium-octeon/octeon-memcpy.S:372: Error: unrecognized opcode=
 `ptr 9b,l_exc'
    arch/mips/cavium-octeon/octeon-memcpy.S:375: Error: unrecognized opcode=
 `ptr 9b,s_exc_p1'
    arch/mips/cavium-octeon/octeon-memcpy.S:399: Error: unrecognized opcode=
 `ptr 9b,l_exc'

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    arch/mips/boot/dts/ingenic/jz4780.dtsi:473.33-475.6: Warning (unit_addr=
ess_format): /nemc@13410000/efuse@d0/eth-mac-addr@0x22: unit name should no=
t have leading "0x"

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
db1xxx_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
decstation_64_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings,=
 0 section mismatches

Errors:
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
decstation_r4k_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warning=
s, 0 section mismatches

---------------------------------------------------------------------------=
-----
defconfig (riscv, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
defconfig+arm64-chromebook (arm64, gcc-10) =E2=80=94 PASS, 0 errors, 0 warn=
ings, 0 section mismatches

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
ep93xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

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
fuloong2e_defconfig (mips, gcc-10) =E2=80=94 PASS, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99

---------------------------------------------------------------------------=
-----
gcw0_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
gemini_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
gpr_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
h3600_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
h5000_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
hackkit_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

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
i386_defconfig (i386, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

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
imx_v6_v7_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

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
ip32_defconfig (mips, gcc-10) =E2=80=94 PASS, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99

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

---------------------------------------------------------------------------=
-----
keystone_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
lart_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-10) =E2=80=94 PASS, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99

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
loongson2k_defconfig (mips, gcc-10) =E2=80=94 PASS, 1 error, 0 warnings, 0 =
section mismatches

Errors:
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-10) =E2=80=94 PASS, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99

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
malta_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

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
maltaup_xpa_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, =
0 section mismatches

---------------------------------------------------------------------------=
-----
milbeaut_m10v_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

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
multi_v5_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

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
nommu_k210_defconfig (riscv, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, =
0 section mismatches

---------------------------------------------------------------------------=
-----
nommu_k210_sdcard_defconfig (riscv, gcc-10) =E2=80=94 PASS, 0 errors, 0 war=
nings, 0 section mismatches

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
omap2plus_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

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
pleb_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

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
pxa_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    /tmp/kci/linux/build/../drivers/gpu/drm/panel/panel-edp.c:843: undefine=
d reference to `drm_panel_dp_aux_backlight'

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
rpc_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 section=
 mismatches

Errors:
    arch/arm/kernel/head.S:319: Error: missing expression -- `ldr r7,=3D0x'
    arch/arm/kernel/head.S:319: Error: missing expression -- `ldr r3,=3D0x'

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
rv32_defconfig (riscv, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
s5pv210_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
sama5_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
sama7_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
sb1250_swarm_defconfig (mips, gcc-10) =E2=80=94 PASS, 1 error, 0 warnings, =
0 section mismatches

Errors:
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99

---------------------------------------------------------------------------=
-----
shannon_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

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
tegra_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mis=
matches

Warnings:
    arch/arc/Makefile:26: ** WARNING ** CONFIG_ARC_TUNE_MCPU flag '' is unk=
nown, fallback to ''

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
u8500_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

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
x86_64_defconfig (x86_64, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
x86_64_defconfig+x86-chromebook (x86_64, gcc-10) =E2=80=94 PASS, 0 errors, =
0 warnings, 0 section mismatches

---------------------------------------------------------------------------=
-----
xcep_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---
For more info write to <info@kernelci.org>
