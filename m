Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C079C115D8E
	for <lists+stable@lfdr.de>; Sat,  7 Dec 2019 17:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbfLGQk1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Dec 2019 11:40:27 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54496 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726414AbfLGQk1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Dec 2019 11:40:27 -0500
Received: by mail-wm1-f67.google.com with SMTP id b11so11036168wmj.4
        for <stable@vger.kernel.org>; Sat, 07 Dec 2019 08:40:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dnWTE9OEt+P3Q2rOiYTMsBU6h4ny73pdgTa+e4mk3UM=;
        b=eqjMAQy159cDmEJjbe3Tdj/WFJhZMfpu+xcRj0BrynmFlpPvAGUrrf0iNbn8WsTkwc
         w7NzcbKdGlSG94XX0e3Aqdm1sIJ39bUyOyR3o/dVICDPQF0voIgErT4ioU6fXsbI5f8w
         mMOEb7DG0kpT/2P6fyMadh1p+V2kwguJ57HTZaYS8gDzjrDXC8A47Nz041WGO8I1itS7
         evgn7XylHfNiDgojeJILBAynAjgjC1ZqJfeSfVOwvINMNB0o6EG8sFD3H8+9IPEth/0P
         kG0c/dJ6zHn5xBgsvXzZIWxO/9JBtAZUruZsZm6e09VHkJM3dIuBSnrDk93abBd+xQRl
         cOoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dnWTE9OEt+P3Q2rOiYTMsBU6h4ny73pdgTa+e4mk3UM=;
        b=oNB5zH/MQwG5oLDYvUaLdSDoAV5P3DKyajEvKIztvv3lMq8qQBkGQWymmYQWRjAIfU
         g9mhEiH+OW1cVG3FoDM5rmIDALLRHMGJr+cQKEitjMwb5u3j5zOB2AYvwozzFVEwDsko
         cIJ3H4SZ4ylpmjxdqanfiVj7MLu70EplAnZoz8qpPEpDpXIKuK2fjHVi/prMf89JEciS
         CXY01D6WmbZMjJcg/EYkW4WEBSPG5KBfcKphwaNZgmgsNk5HPckp//hfAR5mju/AksJ6
         oP3Qpt24lGZrMD7z52H+910bCm9PGVWTljkdTAijSYSlZST1xOb7EL9CNEHjGaytalOK
         meOg==
X-Gm-Message-State: APjAAAX0UV0yUzIybqUMM6ximMi+Vf++uZUT42ngwXE66Xa+lfhp82Dx
        YiMLwTImlHBN0to6eEm7MCXzRXS8ugA=
X-Google-Smtp-Source: APXvYqxQo+LLhJANh0H/uQmZsSWkg0aPqUxawgfl/onB6zviilWIFSK9cZ3ywnt7ecql3Doum6fv+Q==
X-Received: by 2002:a05:600c:30a:: with SMTP id q10mr15707251wmd.84.1575736815980;
        Sat, 07 Dec 2019 08:40:15 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v20sm7220871wmj.32.2019.12.07.08.40.14
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Dec 2019 08:40:15 -0800 (PST)
Message-ID: <5debd5ef.1c69fb81.2a74f.935e@mx.google.com>
Date:   Sat, 07 Dec 2019 08:40:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v4.19.88-209-g5944fcdd7eb0
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y build: 206 builds: 3 failed, 203 passed,
 6 errors, 139 warnings (v4.19.88-209-g5944fcdd7eb0)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y build: 206 builds: 3 failed, 203 passed, 6 errors, 1=
39 warnings (v4.19.88-209-g5944fcdd7eb0)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.88-209-g5944fcdd7eb0/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.88-209-g5944fcdd7eb0
Git Commit: 5944fcdd7eb0add713dd4b614377cb3ad97309b3
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 7 unique architectures

Build Failures Detected:

arm64:
    defconfig: (gcc-8) FAIL

arm:
    multi_v7_defconfig: (gcc-8) FAIL
    shmobile_defconfig: (gcc-8) FAIL

Errors and Warnings Detected:

arc:

arm64:
    defconfig (gcc-8): 1 error, 1 warning

arm:
    hisi_defconfig (gcc-8): 24 warnings
    imx_v6_v7_defconfig (gcc-8): 40 warnings
    multi_v7_defconfig (gcc-8): 1 error, 1 warning
    omap2plus_defconfig (gcc-8): 3 warnings
    qcom_defconfig (gcc-8): 45 warnings
    shmobile_defconfig (gcc-8): 4 errors
    u8500_defconfig (gcc-8): 15 warnings
    vexpress_defconfig (gcc-8): 4 warnings

i386:

mips:
    lemote2f_defconfig (gcc-8): 1 warning
    loongson3_defconfig (gcc-8): 2 warnings
    malta_qemu_32r6_defconfig (gcc-8): 1 warning
    nlm_xlp_defconfig (gcc-8): 1 warning

riscv:

x86_64:
    tinyconfig (gcc-8): 1 warning

Errors summary:

    1    drivers/pinctrl/sh-pfc/pfc-r8a7792.c:1753:38: error: macro "VIN_DA=
TA_PIN_GROUP" passed 3 arguments, but takes just 2
    1    drivers/pinctrl/sh-pfc/pfc-r8a7792.c:1751:38: error: macro "VIN_DA=
TA_PIN_GROUP" passed 3 arguments, but takes just 2
    1    drivers/pinctrl/sh-pfc/pfc-r8a7792.c:1750:38: error: macro "VIN_DA=
TA_PIN_GROUP" passed 3 arguments, but takes just 2
    1    drivers/pinctrl/sh-pfc/pfc-r8a7792.c:1750:2: error: =E2=80=98VIN_D=
ATA_PIN_GROUP=E2=80=99 undeclared here (not in a function); did you mean =
=E2=80=98PIN_MAP_TYPE_MUX_GROUP=E2=80=99?
    1    drivers/dma/xilinx/xilinx_dma.c:1252:9: error: implicit declaratio=
n of function =E2=80=98xilinx_prep_dma_addr_t=E2=80=99; did you mean =E2=80=
=98xilinx_dma_start=E2=80=99? [-Werror=3Dimplicit-function-declaration]
    1    arch/arm64/net/bpf_jit_comp.c:633:9: error: implicit declaration o=
f function =E2=80=98bpf_jit_get_func_addr=E2=80=99; did you mean =E2=80=98b=
pf_jit_binary_hdr=E2=80=99? [-Werror=3Dimplicit-function-declaration]

Warnings summary:

    3    net/core/rtnetlink.c:3181:1: warning: the frame size of 1312 bytes=
 is larger than 1024 bytes [-Wframe-larger-than=3D]
    2    cc1: some warnings being treated as errors
    1    {standard input}:131: Warning: macro instruction expanded into mul=
tiple instructions
    1    arch/mips/configs/loongson3_defconfig:55:warning: symbol value 'm'=
 invalid for HOTPLUG_PCI_SHPC
    1    arch/arm/boot/dts/vexpress-v2p-ca15_a7.dtb: Warning (graph_port): =
/replicator/ports/port@2: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/vexpress-v2p-ca15_a7.dtb: Warning (graph_port): =
/funnel@20040000/ports/port@3: graph node unit address error, expected "2"
    1    arch/arm/boot/dts/vexpress-v2p-ca15_a7.dtb: Warning (graph_port): =
/funnel@20040000/ports/port@2: graph node unit address error, expected "1"
    1    arch/arm/boot/dts/vexpress-v2p-ca15_a7.dtb: Warning (graph_port): =
/funnel@20040000/ports/port@1: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/ste-snowball.dtb: Warning (graph_port): /soc/rep=
licator/ports/port@2: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/ste-snowball.dtb: Warning (graph_port): /soc/fun=
nel@801a6000/ports/port@2: graph node unit address error, expected "1"
    1    arch/arm/boot/dts/ste-snowball.dtb: Warning (graph_port): /soc/fun=
nel@801a6000/ports/port@1: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/ste-hrefv60plus-tvk.dtb: Warning (graph_port): /=
soc/replicator/ports/port@2: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/ste-hrefv60plus-tvk.dtb: Warning (graph_port): /=
soc/funnel@801a6000/ports/port@2: graph node unit address error, expected "=
1"
    1    arch/arm/boot/dts/ste-hrefv60plus-tvk.dtb: Warning (graph_port): /=
soc/funnel@801a6000/ports/port@1: graph node unit address error, expected "=
0"
    1    arch/arm/boot/dts/ste-hrefv60plus-stuib.dtb: Warning (graph_port):=
 /soc/replicator/ports/port@2: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/ste-hrefv60plus-stuib.dtb: Warning (graph_port):=
 /soc/funnel@801a6000/ports/port@2: graph node unit address error, expected=
 "1"
    1    arch/arm/boot/dts/ste-hrefv60plus-stuib.dtb: Warning (graph_port):=
 /soc/funnel@801a6000/ports/port@1: graph node unit address error, expected=
 "0"
    1    arch/arm/boot/dts/ste-hrefprev60-tvk.dtb: Warning (graph_port): /s=
oc/replicator/ports/port@2: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/ste-hrefprev60-tvk.dtb: Warning (graph_port): /s=
oc/funnel@801a6000/ports/port@2: graph node unit address error, expected "1"
    1    arch/arm/boot/dts/ste-hrefprev60-tvk.dtb: Warning (graph_port): /s=
oc/funnel@801a6000/ports/port@1: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/ste-hrefprev60-stuib.dtb: Warning (graph_port): =
/soc/replicator/ports/port@2: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/ste-hrefprev60-stuib.dtb: Warning (graph_port): =
/soc/funnel@801a6000/ports/port@2: graph node unit address error, expected =
"1"
    1    arch/arm/boot/dts/ste-hrefprev60-stuib.dtb: Warning (graph_port): =
/soc/funnel@801a6000/ports/port@1: graph node unit address error, expected =
"0"
    1    arch/arm/boot/dts/qcom-msm8974-sony-xperia-honami.dtb: Warning (gr=
aph_port): /soc/replicator@fc31c000/ports/port@2: graph node unit address e=
rror, expected "0"
    1    arch/arm/boot/dts/qcom-msm8974-sony-xperia-honami.dtb: Warning (gr=
aph_port): /soc/funnel@fc345000/ports/port@8: graph node unit address error=
, expected "0"
    1    arch/arm/boot/dts/qcom-msm8974-sony-xperia-honami.dtb: Warning (gr=
aph_port): /soc/funnel@fc31b000/ports/port@8: graph node unit address error=
, expected "0"
    1    arch/arm/boot/dts/qcom-msm8974-sony-xperia-honami.dtb: Warning (gr=
aph_port): /soc/funnel@fc31a000/ports/port@8: graph node unit address error=
, expected "0"
    1    arch/arm/boot/dts/qcom-msm8974-sony-xperia-honami.dtb: Warning (gr=
aph_port): /soc/etf@fc307000/ports/port@1: graph node unit address error, e=
xpected "0"
    1    arch/arm/boot/dts/qcom-msm8974-sony-xperia-castor.dtb: Warning (gr=
aph_port): /soc/replicator@fc31c000/ports/port@2: graph node unit address e=
rror, expected "0"
    1    arch/arm/boot/dts/qcom-msm8974-sony-xperia-castor.dtb: Warning (gr=
aph_port): /soc/funnel@fc345000/ports/port@8: graph node unit address error=
, expected "0"
    1    arch/arm/boot/dts/qcom-msm8974-sony-xperia-castor.dtb: Warning (gr=
aph_port): /soc/funnel@fc31b000/ports/port@8: graph node unit address error=
, expected "0"
    1    arch/arm/boot/dts/qcom-msm8974-sony-xperia-castor.dtb: Warning (gr=
aph_port): /soc/funnel@fc31a000/ports/port@8: graph node unit address error=
, expected "0"
    1    arch/arm/boot/dts/qcom-msm8974-sony-xperia-castor.dtb: Warning (gr=
aph_port): /soc/etf@fc307000/ports/port@1: graph node unit address error, e=
xpected "0"
    1    arch/arm/boot/dts/qcom-msm8974-sony-xperia-amami.dtb: Warning (gra=
ph_port): /soc/replicator@fc31c000/ports/port@2: graph node unit address er=
ror, expected "0"
    1    arch/arm/boot/dts/qcom-msm8974-sony-xperia-amami.dtb: Warning (gra=
ph_port): /soc/funnel@fc345000/ports/port@8: graph node unit address error,=
 expected "0"
    1    arch/arm/boot/dts/qcom-msm8974-sony-xperia-amami.dtb: Warning (gra=
ph_port): /soc/funnel@fc31b000/ports/port@8: graph node unit address error,=
 expected "0"
    1    arch/arm/boot/dts/qcom-msm8974-sony-xperia-amami.dtb: Warning (gra=
ph_port): /soc/funnel@fc31a000/ports/port@8: graph node unit address error,=
 expected "0"
    1    arch/arm/boot/dts/qcom-msm8974-sony-xperia-amami.dtb: Warning (gra=
ph_port): /soc/etf@fc307000/ports/port@1: graph node unit address error, ex=
pected "0"
    1    arch/arm/boot/dts/qcom-msm8974-samsung-klte.dtb: Warning (graph_po=
rt): /soc/replicator@fc31c000/ports/port@2: graph node unit address error, =
expected "0"
    1    arch/arm/boot/dts/qcom-msm8974-samsung-klte.dtb: Warning (graph_po=
rt): /soc/funnel@fc345000/ports/port@8: graph node unit address error, expe=
cted "0"
    1    arch/arm/boot/dts/qcom-msm8974-samsung-klte.dtb: Warning (graph_po=
rt): /soc/funnel@fc31b000/ports/port@8: graph node unit address error, expe=
cted "0"
    1    arch/arm/boot/dts/qcom-msm8974-samsung-klte.dtb: Warning (graph_po=
rt): /soc/funnel@fc31a000/ports/port@8: graph node unit address error, expe=
cted "0"
    1    arch/arm/boot/dts/qcom-msm8974-samsung-klte.dtb: Warning (graph_po=
rt): /soc/etf@fc307000/ports/port@1: graph node unit address error, expecte=
d "0"
    1    arch/arm/boot/dts/qcom-msm8974-lge-nexus5-hammerhead.dtb: Warning =
(graph_port): /soc/replicator@fc31c000/ports/port@2: graph node unit addres=
s error, expected "0"
    1    arch/arm/boot/dts/qcom-msm8974-lge-nexus5-hammerhead.dtb: Warning =
(graph_port): /soc/funnel@fc345000/ports/port@8: graph node unit address er=
ror, expected "0"
    1    arch/arm/boot/dts/qcom-msm8974-lge-nexus5-hammerhead.dtb: Warning =
(graph_port): /soc/funnel@fc31b000/ports/port@8: graph node unit address er=
ror, expected "0"
    1    arch/arm/boot/dts/qcom-msm8974-lge-nexus5-hammerhead.dtb: Warning =
(graph_port): /soc/funnel@fc31a000/ports/port@8: graph node unit address er=
ror, expected "0"
    1    arch/arm/boot/dts/qcom-msm8974-lge-nexus5-hammerhead.dtb: Warning =
(graph_port): /soc/etf@fc307000/ports/port@1: graph node unit address error=
, expected "0"
    1    arch/arm/boot/dts/qcom-msm8974-fairphone-fp2.dtb: Warning (graph_p=
ort): /soc/replicator@fc31c000/ports/port@2: graph node unit address error,=
 expected "0"
    1    arch/arm/boot/dts/qcom-msm8974-fairphone-fp2.dtb: Warning (graph_p=
ort): /soc/funnel@fc345000/ports/port@8: graph node unit address error, exp=
ected "0"
    1    arch/arm/boot/dts/qcom-msm8974-fairphone-fp2.dtb: Warning (graph_p=
ort): /soc/funnel@fc31b000/ports/port@8: graph node unit address error, exp=
ected "0"
    1    arch/arm/boot/dts/qcom-msm8974-fairphone-fp2.dtb: Warning (graph_p=
ort): /soc/funnel@fc31a000/ports/port@8: graph node unit address error, exp=
ected "0"
    1    arch/arm/boot/dts/qcom-msm8974-fairphone-fp2.dtb: Warning (graph_p=
ort): /soc/etf@fc307000/ports/port@1: graph node unit address error, expect=
ed "0"
    1    arch/arm/boot/dts/qcom-apq8074-dragonboard.dtb: Warning (graph_por=
t): /soc/replicator@fc31c000/ports/port@2: graph node unit address error, e=
xpected "0"
    1    arch/arm/boot/dts/qcom-apq8074-dragonboard.dtb: Warning (graph_por=
t): /soc/funnel@fc345000/ports/port@8: graph node unit address error, expec=
ted "0"
    1    arch/arm/boot/dts/qcom-apq8074-dragonboard.dtb: Warning (graph_por=
t): /soc/funnel@fc31b000/ports/port@8: graph node unit address error, expec=
ted "0"
    1    arch/arm/boot/dts/qcom-apq8074-dragonboard.dtb: Warning (graph_por=
t): /soc/funnel@fc31a000/ports/port@8: graph node unit address error, expec=
ted "0"
    1    arch/arm/boot/dts/qcom-apq8074-dragonboard.dtb: Warning (graph_por=
t): /soc/etf@fc307000/ports/port@1: graph node unit address error, expected=
 "0"
    1    arch/arm/boot/dts/qcom-apq8064-sony-xperia-yuga.dtb: Warning (grap=
h_port): /soc/replicator/ports/port@2: graph node unit address error, expec=
ted "0"
    1    arch/arm/boot/dts/qcom-apq8064-sony-xperia-yuga.dtb: Warning (grap=
h_port): /soc/funnel@1a04000/ports/port@8: graph node unit address error, e=
xpected "0"
    1    arch/arm/boot/dts/qcom-apq8064-ifc6410.dtb: Warning (graph_port): =
/soc/replicator/ports/port@2: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/qcom-apq8064-ifc6410.dtb: Warning (graph_port): =
/soc/funnel@1a04000/ports/port@8: graph node unit address error, expected "=
0"
    1    arch/arm/boot/dts/qcom-apq8064-cm-qs600.dtb: Warning (graph_port):=
 /soc/replicator/ports/port@2: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/qcom-apq8064-cm-qs600.dtb: Warning (graph_port):=
 /soc/funnel@1a04000/ports/port@8: graph node unit address error, expected =
"0"
    1    arch/arm/boot/dts/qcom-apq8064-asus-nexus7-flo.dtb: Warning (graph=
_port): /soc/replicator/ports/port@2: graph node unit address error, expect=
ed "0"
    1    arch/arm/boot/dts/qcom-apq8064-asus-nexus7-flo.dtb: Warning (graph=
_port): /soc/funnel@1a04000/ports/port@8: graph node unit address error, ex=
pected "0"
    1    arch/arm/boot/dts/qcom-apq8064-arrow-sd-600eval.dtb: Warning (grap=
h_port): /soc/replicator/ports/port@2: graph node unit address error, expec=
ted "0"
    1    arch/arm/boot/dts/qcom-apq8064-arrow-sd-600eval.dtb: Warning (grap=
h_port): /soc/funnel@1a04000/ports/port@8: graph node unit address error, e=
xpected "0"
    1    arch/arm/boot/dts/omap3-gta04a5.dtb: Warning (graph_port): /ocp@68=
000000/dss@48050000/encoder@48050c00/port: graph node unit address error, e=
xpected "0"
    1    arch/arm/boot/dts/omap3-gta04a4.dtb: Warning (graph_port): /ocp@68=
000000/dss@48050000/encoder@48050c00/port: graph node unit address error, e=
xpected "0"
    1    arch/arm/boot/dts/omap3-gta04a3.dtb: Warning (graph_port): /ocp@68=
000000/dss@48050000/encoder@48050c00/port: graph node unit address error, e=
xpected "0"
    1    arch/arm/boot/dts/imx7s-warp.dtb: Warning (graph_port): /soc/funne=
l@30083000/ports/port@2: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/imx7s-warp.dtb: Warning (graph_port): /soc/funne=
l@30041000/ports/port@2: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/imx7s-warp.dtb: Warning (graph_port): /soc/etf@3=
0084000/ports/port@1: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/imx7s-warp.dtb: Warning (graph_port): /replicato=
r/ports/port@2: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/imx7s-colibri-eval-v3.dtb: Warning (graph_port):=
 /soc/funnel@30083000/ports/port@2: graph node unit address error, expected=
 "0"
    1    arch/arm/boot/dts/imx7s-colibri-eval-v3.dtb: Warning (graph_port):=
 /soc/funnel@30041000/ports/port@2: graph node unit address error, expected=
 "0"
    1    arch/arm/boot/dts/imx7s-colibri-eval-v3.dtb: Warning (graph_port):=
 /soc/etf@30084000/ports/port@1: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/imx7s-colibri-eval-v3.dtb: Warning (graph_port):=
 /replicator/ports/port@2: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/imx7d-sdb.dtb: Warning (graph_port): /soc/funnel=
@30083000/ports/port@2: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/imx7d-sdb.dtb: Warning (graph_port): /soc/funnel=
@30041000/ports/port@2: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/imx7d-sdb.dtb: Warning (graph_port): /soc/etf@30=
084000/ports/port@1: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/imx7d-sdb.dtb: Warning (graph_port): /replicator=
/ports/port@2: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/imx7d-sdb-sht11.dtb: Warning (graph_port): /soc/=
funnel@30083000/ports/port@2: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/imx7d-sdb-sht11.dtb: Warning (graph_port): /soc/=
funnel@30041000/ports/port@2: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/imx7d-sdb-sht11.dtb: Warning (graph_port): /soc/=
etf@30084000/ports/port@1: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/imx7d-sdb-sht11.dtb: Warning (graph_port): /repl=
icator/ports/port@2: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/imx7d-sbc-imx7.dtb: Warning (graph_port): /soc/f=
unnel@30083000/ports/port@2: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/imx7d-sbc-imx7.dtb: Warning (graph_port): /soc/f=
unnel@30041000/ports/port@2: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/imx7d-sbc-imx7.dtb: Warning (graph_port): /soc/e=
tf@30084000/ports/port@1: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/imx7d-sbc-imx7.dtb: Warning (graph_port): /repli=
cator/ports/port@2: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/imx7d-pico-pi.dtb: Warning (graph_port): /soc/fu=
nnel@30083000/ports/port@2: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/imx7d-pico-pi.dtb: Warning (graph_port): /soc/fu=
nnel@30041000/ports/port@2: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/imx7d-pico-pi.dtb: Warning (graph_port): /soc/et=
f@30084000/ports/port@1: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/imx7d-pico-pi.dtb: Warning (graph_port): /replic=
ator/ports/port@2: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/imx7d-nitrogen7.dtb: Warning (graph_port): /soc/=
funnel@30083000/ports/port@2: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/imx7d-nitrogen7.dtb: Warning (graph_port): /soc/=
funnel@30041000/ports/port@2: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/imx7d-nitrogen7.dtb: Warning (graph_port): /soc/=
etf@30084000/ports/port@1: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/imx7d-nitrogen7.dtb: Warning (graph_port): /repl=
icator/ports/port@2: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/imx7d-colibri-eval-v3.dtb: Warning (graph_port):=
 /soc/funnel@30083000/ports/port@2: graph node unit address error, expected=
 "0"
    1    arch/arm/boot/dts/imx7d-colibri-eval-v3.dtb: Warning (graph_port):=
 /soc/funnel@30041000/ports/port@2: graph node unit address error, expected=
 "0"
    1    arch/arm/boot/dts/imx7d-colibri-eval-v3.dtb: Warning (graph_port):=
 /soc/etf@30084000/ports/port@1: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/imx7d-colibri-eval-v3.dtb: Warning (graph_port):=
 /replicator/ports/port@2: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/imx7d-colibri-emmc-eval-v3.dtb: Warning (graph_p=
ort): /soc/funnel@30083000/ports/port@2: graph node unit address error, exp=
ected "0"
    1    arch/arm/boot/dts/imx7d-colibri-emmc-eval-v3.dtb: Warning (graph_p=
ort): /soc/funnel@30041000/ports/port@2: graph node unit address error, exp=
ected "0"
    1    arch/arm/boot/dts/imx7d-colibri-emmc-eval-v3.dtb: Warning (graph_p=
ort): /soc/etf@30084000/ports/port@1: graph node unit address error, expect=
ed "0"
    1    arch/arm/boot/dts/imx7d-colibri-emmc-eval-v3.dtb: Warning (graph_p=
ort): /replicator/ports/port@2: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/imx7d-cl-som-imx7.dtb: Warning (graph_port): /so=
c/funnel@30083000/ports/port@2: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/imx7d-cl-som-imx7.dtb: Warning (graph_port): /so=
c/funnel@30041000/ports/port@2: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/imx7d-cl-som-imx7.dtb: Warning (graph_port): /so=
c/etf@30084000/ports/port@1: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/imx7d-cl-som-imx7.dtb: Warning (graph_port): /re=
plicator/ports/port@2: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/hip04-d01.dtb: Warning (graph_port): /replicator=
3/ports/port@2: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/hip04-d01.dtb: Warning (graph_port): /replicator=
2/ports/port@2: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/hip04-d01.dtb: Warning (graph_port): /replicator=
1/ports/port@2: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/hip04-d01.dtb: Warning (graph_port): /replicator=
0/ports/port@2: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/hip04-d01.dtb: Warning (graph_port): /funnel@0,e=
3d01000/ports/port@4: graph node unit address error, expected "3"
    1    arch/arm/boot/dts/hip04-d01.dtb: Warning (graph_port): /funnel@0,e=
3d01000/ports/port@3: graph node unit address error, expected "2"
    1    arch/arm/boot/dts/hip04-d01.dtb: Warning (graph_port): /funnel@0,e=
3d01000/ports/port@2: graph node unit address error, expected "1"
    1    arch/arm/boot/dts/hip04-d01.dtb: Warning (graph_port): /funnel@0,e=
3d01000/ports/port@1: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/hip04-d01.dtb: Warning (graph_port): /funnel@0,e=
3cc1000/ports/port@4: graph node unit address error, expected "3"
    1    arch/arm/boot/dts/hip04-d01.dtb: Warning (graph_port): /funnel@0,e=
3cc1000/ports/port@3: graph node unit address error, expected "2"
    1    arch/arm/boot/dts/hip04-d01.dtb: Warning (graph_port): /funnel@0,e=
3cc1000/ports/port@2: graph node unit address error, expected "1"
    1    arch/arm/boot/dts/hip04-d01.dtb: Warning (graph_port): /funnel@0,e=
3cc1000/ports/port@1: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/hip04-d01.dtb: Warning (graph_port): /funnel@0,e=
3c81000/ports/port@4: graph node unit address error, expected "3"
    1    arch/arm/boot/dts/hip04-d01.dtb: Warning (graph_port): /funnel@0,e=
3c81000/ports/port@3: graph node unit address error, expected "2"
    1    arch/arm/boot/dts/hip04-d01.dtb: Warning (graph_port): /funnel@0,e=
3c81000/ports/port@2: graph node unit address error, expected "1"
    1    arch/arm/boot/dts/hip04-d01.dtb: Warning (graph_port): /funnel@0,e=
3c81000/ports/port@1: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/hip04-d01.dtb: Warning (graph_port): /funnel@0,e=
3c41000/ports/port@4: graph node unit address error, expected "3"
    1    arch/arm/boot/dts/hip04-d01.dtb: Warning (graph_port): /funnel@0,e=
3c41000/ports/port@3: graph node unit address error, expected "2"
    1    arch/arm/boot/dts/hip04-d01.dtb: Warning (graph_port): /funnel@0,e=
3c41000/ports/port@2: graph node unit address error, expected "1"
    1    arch/arm/boot/dts/hip04-d01.dtb: Warning (graph_port): /funnel@0,e=
3c41000/ports/port@1: graph node unit address error, expected "0"
    1    arch/arm/boot/dts/hip04-d01.dtb: Warning (graph_port): /funnel@0,e=
3c04000/ports/port@4: graph node unit address error, expected "3"
    1    arch/arm/boot/dts/hip04-d01.dtb: Warning (graph_port): /funnel@0,e=
3c04000/ports/port@3: graph node unit address error, expected "2"
    1    arch/arm/boot/dts/hip04-d01.dtb: Warning (graph_port): /funnel@0,e=
3c04000/ports/port@2: graph node unit address error, expected "1"
    1    arch/arm/boot/dts/hip04-d01.dtb: Warning (graph_port): /funnel@0,e=
3c04000/ports/port@1: graph node unit address error, expected "0"
    1    .config:1009:warning: override: UNWINDER_GUESS changes choice state

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
32r2el_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
acs5k_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
acs5k_tiny_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
allnoconfig (riscv, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
allnoconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
allnoconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
am200epdkit_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
ar7_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
aspeed_g4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
aspeed_g5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
assabet_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
at91_dt_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
ath25_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
axm55xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
axs103_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
axs103_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
badge4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
bcm2835_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
bcm47xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
bcm63xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
bigsur_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
clps711x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
cm_x2xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
cm_x300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
cns3420vb_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
cobalt_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
colibri_pxa270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
collie_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
corgi_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
davinci_all_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mism=
atches

Errors:
    arch/arm64/net/bpf_jit_comp.c:633:9: error: implicit declaration of fun=
ction =E2=80=98bpf_jit_get_func_addr=E2=80=99; did you mean =E2=80=98bpf_ji=
t_binary_hdr=E2=80=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
defconfig (riscv, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
dove_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
e55_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
ebsa110_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
efm32_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
em_x270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
ep93xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
gcw0_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
gemini_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
gpr_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
h3600_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
h5000_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
hackkit_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
haps_hs_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
haps_hs_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
hisi_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 24 warnings, 0 sectio=
n mismatches

Warnings:
    arch/arm/boot/dts/hip04-d01.dtb: Warning (graph_port): /replicator0/por=
ts/port@2: graph node unit address error, expected "0"
    arch/arm/boot/dts/hip04-d01.dtb: Warning (graph_port): /replicator1/por=
ts/port@2: graph node unit address error, expected "0"
    arch/arm/boot/dts/hip04-d01.dtb: Warning (graph_port): /replicator2/por=
ts/port@2: graph node unit address error, expected "0"
    arch/arm/boot/dts/hip04-d01.dtb: Warning (graph_port): /replicator3/por=
ts/port@2: graph node unit address error, expected "0"
    arch/arm/boot/dts/hip04-d01.dtb: Warning (graph_port): /funnel@0,e3c410=
00/ports/port@1: graph node unit address error, expected "0"
    arch/arm/boot/dts/hip04-d01.dtb: Warning (graph_port): /funnel@0,e3c410=
00/ports/port@2: graph node unit address error, expected "1"
    arch/arm/boot/dts/hip04-d01.dtb: Warning (graph_port): /funnel@0,e3c410=
00/ports/port@3: graph node unit address error, expected "2"
    arch/arm/boot/dts/hip04-d01.dtb: Warning (graph_port): /funnel@0,e3c410=
00/ports/port@4: graph node unit address error, expected "3"
    arch/arm/boot/dts/hip04-d01.dtb: Warning (graph_port): /funnel@0,e3c810=
00/ports/port@1: graph node unit address error, expected "0"
    arch/arm/boot/dts/hip04-d01.dtb: Warning (graph_port): /funnel@0,e3c810=
00/ports/port@2: graph node unit address error, expected "1"
    arch/arm/boot/dts/hip04-d01.dtb: Warning (graph_port): /funnel@0,e3c810=
00/ports/port@3: graph node unit address error, expected "2"
    arch/arm/boot/dts/hip04-d01.dtb: Warning (graph_port): /funnel@0,e3c810=
00/ports/port@4: graph node unit address error, expected "3"
    arch/arm/boot/dts/hip04-d01.dtb: Warning (graph_port): /funnel@0,e3cc10=
00/ports/port@1: graph node unit address error, expected "0"
    arch/arm/boot/dts/hip04-d01.dtb: Warning (graph_port): /funnel@0,e3cc10=
00/ports/port@2: graph node unit address error, expected "1"
    arch/arm/boot/dts/hip04-d01.dtb: Warning (graph_port): /funnel@0,e3cc10=
00/ports/port@3: graph node unit address error, expected "2"
    arch/arm/boot/dts/hip04-d01.dtb: Warning (graph_port): /funnel@0,e3cc10=
00/ports/port@4: graph node unit address error, expected "3"
    arch/arm/boot/dts/hip04-d01.dtb: Warning (graph_port): /funnel@0,e3d010=
00/ports/port@1: graph node unit address error, expected "0"
    arch/arm/boot/dts/hip04-d01.dtb: Warning (graph_port): /funnel@0,e3d010=
00/ports/port@2: graph node unit address error, expected "1"
    arch/arm/boot/dts/hip04-d01.dtb: Warning (graph_port): /funnel@0,e3d010=
00/ports/port@3: graph node unit address error, expected "2"
    arch/arm/boot/dts/hip04-d01.dtb: Warning (graph_port): /funnel@0,e3d010=
00/ports/port@4: graph node unit address error, expected "3"
    arch/arm/boot/dts/hip04-d01.dtb: Warning (graph_port): /funnel@0,e3c040=
00/ports/port@1: graph node unit address error, expected "0"
    arch/arm/boot/dts/hip04-d01.dtb: Warning (graph_port): /funnel@0,e3c040=
00/ports/port@2: graph node unit address error, expected "1"
    arch/arm/boot/dts/hip04-d01.dtb: Warning (graph_port): /funnel@0,e3c040=
00/ports/port@3: graph node unit address error, expected "2"
    arch/arm/boot/dts/hip04-d01.dtb: Warning (graph_port): /funnel@0,e3c040=
00/ports/port@4: graph node unit address error, expected "3"

---------------------------------------------------------------------------=
-----
hsdk_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
i386_defconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
imote2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
imx_v4_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
imx_v6_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 40 warnings, 0 s=
ection mismatches

Warnings:
    arch/arm/boot/dts/imx7d-cl-som-imx7.dtb: Warning (graph_port): /replica=
tor/ports/port@2: graph node unit address error, expected "0"
    arch/arm/boot/dts/imx7d-cl-som-imx7.dtb: Warning (graph_port): /soc/fun=
nel@30041000/ports/port@2: graph node unit address error, expected "0"
    arch/arm/boot/dts/imx7d-cl-som-imx7.dtb: Warning (graph_port): /soc/fun=
nel@30083000/ports/port@2: graph node unit address error, expected "0"
    arch/arm/boot/dts/imx7d-cl-som-imx7.dtb: Warning (graph_port): /soc/etf=
@30084000/ports/port@1: graph node unit address error, expected "0"
    arch/arm/boot/dts/imx7d-colibri-emmc-eval-v3.dtb: Warning (graph_port):=
 /replicator/ports/port@2: graph node unit address error, expected "0"
    arch/arm/boot/dts/imx7d-colibri-emmc-eval-v3.dtb: Warning (graph_port):=
 /soc/funnel@30041000/ports/port@2: graph node unit address error, expected=
 "0"
    arch/arm/boot/dts/imx7d-colibri-emmc-eval-v3.dtb: Warning (graph_port):=
 /soc/funnel@30083000/ports/port@2: graph node unit address error, expected=
 "0"
    arch/arm/boot/dts/imx7d-colibri-emmc-eval-v3.dtb: Warning (graph_port):=
 /soc/etf@30084000/ports/port@1: graph node unit address error, expected "0"
    arch/arm/boot/dts/imx7d-colibri-eval-v3.dtb: Warning (graph_port): /rep=
licator/ports/port@2: graph node unit address error, expected "0"
    arch/arm/boot/dts/imx7d-colibri-eval-v3.dtb: Warning (graph_port): /soc=
/funnel@30041000/ports/port@2: graph node unit address error, expected "0"
    arch/arm/boot/dts/imx7d-colibri-eval-v3.dtb: Warning (graph_port): /soc=
/funnel@30083000/ports/port@2: graph node unit address error, expected "0"
    arch/arm/boot/dts/imx7d-colibri-eval-v3.dtb: Warning (graph_port): /soc=
/etf@30084000/ports/port@1: graph node unit address error, expected "0"
    arch/arm/boot/dts/imx7d-nitrogen7.dtb: Warning (graph_port): /replicato=
r/ports/port@2: graph node unit address error, expected "0"
    arch/arm/boot/dts/imx7d-nitrogen7.dtb: Warning (graph_port): /soc/funne=
l@30041000/ports/port@2: graph node unit address error, expected "0"
    arch/arm/boot/dts/imx7d-nitrogen7.dtb: Warning (graph_port): /soc/funne=
l@30083000/ports/port@2: graph node unit address error, expected "0"
    arch/arm/boot/dts/imx7d-nitrogen7.dtb: Warning (graph_port): /soc/etf@3=
0084000/ports/port@1: graph node unit address error, expected "0"
    arch/arm/boot/dts/imx7d-pico-pi.dtb: Warning (graph_port): /replicator/=
ports/port@2: graph node unit address error, expected "0"
    arch/arm/boot/dts/imx7d-pico-pi.dtb: Warning (graph_port): /soc/funnel@=
30041000/ports/port@2: graph node unit address error, expected "0"
    arch/arm/boot/dts/imx7d-pico-pi.dtb: Warning (graph_port): /soc/funnel@=
30083000/ports/port@2: graph node unit address error, expected "0"
    arch/arm/boot/dts/imx7d-pico-pi.dtb: Warning (graph_port): /soc/etf@300=
84000/ports/port@1: graph node unit address error, expected "0"
    arch/arm/boot/dts/imx7d-sbc-imx7.dtb: Warning (graph_port): /replicator=
/ports/port@2: graph node unit address error, expected "0"
    arch/arm/boot/dts/imx7d-sbc-imx7.dtb: Warning (graph_port): /soc/funnel=
@30041000/ports/port@2: graph node unit address error, expected "0"
    arch/arm/boot/dts/imx7d-sbc-imx7.dtb: Warning (graph_port): /soc/funnel=
@30083000/ports/port@2: graph node unit address error, expected "0"
    arch/arm/boot/dts/imx7d-sbc-imx7.dtb: Warning (graph_port): /soc/etf@30=
084000/ports/port@1: graph node unit address error, expected "0"
    arch/arm/boot/dts/imx7d-sdb.dtb: Warning (graph_port): /replicator/port=
s/port@2: graph node unit address error, expected "0"
    arch/arm/boot/dts/imx7d-sdb.dtb: Warning (graph_port): /soc/funnel@3004=
1000/ports/port@2: graph node unit address error, expected "0"
    arch/arm/boot/dts/imx7d-sdb.dtb: Warning (graph_port): /soc/funnel@3008=
3000/ports/port@2: graph node unit address error, expected "0"
    arch/arm/boot/dts/imx7d-sdb.dtb: Warning (graph_port): /soc/etf@3008400=
0/ports/port@1: graph node unit address error, expected "0"
    arch/arm/boot/dts/imx7d-sdb-sht11.dtb: Warning (graph_port): /replicato=
r/ports/port@2: graph node unit address error, expected "0"
    arch/arm/boot/dts/imx7d-sdb-sht11.dtb: Warning (graph_port): /soc/funne=
l@30041000/ports/port@2: graph node unit address error, expected "0"
    arch/arm/boot/dts/imx7d-sdb-sht11.dtb: Warning (graph_port): /soc/funne=
l@30083000/ports/port@2: graph node unit address error, expected "0"
    arch/arm/boot/dts/imx7d-sdb-sht11.dtb: Warning (graph_port): /soc/etf@3=
0084000/ports/port@1: graph node unit address error, expected "0"
    arch/arm/boot/dts/imx7s-colibri-eval-v3.dtb: Warning (graph_port): /rep=
licator/ports/port@2: graph node unit address error, expected "0"
    arch/arm/boot/dts/imx7s-colibri-eval-v3.dtb: Warning (graph_port): /soc=
/funnel@30041000/ports/port@2: graph node unit address error, expected "0"
    arch/arm/boot/dts/imx7s-colibri-eval-v3.dtb: Warning (graph_port): /soc=
/funnel@30083000/ports/port@2: graph node unit address error, expected "0"
    arch/arm/boot/dts/imx7s-colibri-eval-v3.dtb: Warning (graph_port): /soc=
/etf@30084000/ports/port@1: graph node unit address error, expected "0"
    arch/arm/boot/dts/imx7s-warp.dtb: Warning (graph_port): /replicator/por=
ts/port@2: graph node unit address error, expected "0"
    arch/arm/boot/dts/imx7s-warp.dtb: Warning (graph_port): /soc/funnel@300=
41000/ports/port@2: graph node unit address error, expected "0"
    arch/arm/boot/dts/imx7s-warp.dtb: Warning (graph_port): /soc/funnel@300=
83000/ports/port@2: graph node unit address error, expected "0"
    arch/arm/boot/dts/imx7s-warp.dtb: Warning (graph_port): /soc/etf@300840=
00/ports/port@1: graph node unit address error, expected "0"

---------------------------------------------------------------------------=
-----
integrator_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
iop13xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
iop33x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ip22_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
ip27_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
ip28_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
ip32_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
jmr3927_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
jornada720_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
keystone_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
ks8695_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
lart_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
lasat_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    net/core/rtnetlink.c:3181:1: warning: the frame size of 1312 bytes is l=
arger than 1024 bytes [-Wframe-larger-than=3D]

---------------------------------------------------------------------------=
-----
loongson1b_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
loongson1c_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 s=
ection mismatches

Warnings:
    arch/mips/configs/loongson3_defconfig:55:warning: symbol value 'm' inva=
lid for HOTPLUG_PCI_SHPC
    net/core/rtnetlink.c:3181:1: warning: the frame size of 1312 bytes is l=
arger than 1024 bytes [-Wframe-larger-than=3D]

---------------------------------------------------------------------------=
-----
lpc18xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
lpc32xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
lpd270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
lubbock_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
magician_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
mainstone_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
malta_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
malta_kvm_guest_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warning=
s, 0 section mismatches

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning=
, 0 section mismatches

Warnings:
    {standard input}:131: Warning: macro instruction expanded into multiple=
 instructions

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
markeins_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
mips_paravirt_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
mmp2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
moxart_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
mpc30x_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
mps2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
msp71xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
mtx1_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
multi_v4t_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
multi_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    drivers/dma/xilinx/xilinx_dma.c:1252:9: error: implicit declaration of =
function =E2=80=98xilinx_prep_dma_addr_t=E2=80=99; did you mean =E2=80=98xi=
linx_dma_start=E2=80=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mv78xx0_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
mxs_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
neponset_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
netwinder_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
netx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/core/rtnetlink.c:3181:1: warning: the frame size of 1312 bytes is l=
arger than 1024 bytes [-Wframe-larger-than=3D]

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
nsim_hs_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
nsim_hs_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
nsimosci_hs_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
nsimosci_hs_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
nuc910_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
nuc950_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
nuc960_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
omap1_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 3 warnings, 0 se=
ction mismatches

Warnings:
    arch/arm/boot/dts/omap3-gta04a3.dtb: Warning (graph_port): /ocp@6800000=
0/dss@48050000/encoder@48050c00/port: graph node unit address error, expect=
ed "0"
    arch/arm/boot/dts/omap3-gta04a4.dtb: Warning (graph_port): /ocp@6800000=
0/dss@48050000/encoder@48050c00/port: graph node unit address error, expect=
ed "0"
    arch/arm/boot/dts/omap3-gta04a5.dtb: Warning (graph_port): /ocp@6800000=
0/dss@48050000/encoder@48050c00/port: graph node unit address error, expect=
ed "0"

---------------------------------------------------------------------------=
-----
omega2p_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
orion5x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
oxnas_v6_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
palmz72_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
pcm027_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
pic32mzda_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
pistachio_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
pnx8335_stb225_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
prima2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
pxa255-idp_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
pxa3xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
pxa910_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
pxa_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 45 warnings, 0 sectio=
n mismatches

Warnings:
    arch/arm/boot/dts/qcom-apq8064-arrow-sd-600eval.dtb: Warning (graph_por=
t): /soc/replicator/ports/port@2: graph node unit address error, expected "=
0"
    arch/arm/boot/dts/qcom-apq8064-arrow-sd-600eval.dtb: Warning (graph_por=
t): /soc/funnel@1a04000/ports/port@8: graph node unit address error, expect=
ed "0"
    arch/arm/boot/dts/qcom-apq8064-cm-qs600.dtb: Warning (graph_port): /soc=
/replicator/ports/port@2: graph node unit address error, expected "0"
    arch/arm/boot/dts/qcom-apq8064-cm-qs600.dtb: Warning (graph_port): /soc=
/funnel@1a04000/ports/port@8: graph node unit address error, expected "0"
    arch/arm/boot/dts/qcom-apq8064-ifc6410.dtb: Warning (graph_port): /soc/=
replicator/ports/port@2: graph node unit address error, expected "0"
    arch/arm/boot/dts/qcom-apq8064-ifc6410.dtb: Warning (graph_port): /soc/=
funnel@1a04000/ports/port@8: graph node unit address error, expected "0"
    arch/arm/boot/dts/qcom-apq8064-sony-xperia-yuga.dtb: Warning (graph_por=
t): /soc/replicator/ports/port@2: graph node unit address error, expected "=
0"
    arch/arm/boot/dts/qcom-apq8064-sony-xperia-yuga.dtb: Warning (graph_por=
t): /soc/funnel@1a04000/ports/port@8: graph node unit address error, expect=
ed "0"
    arch/arm/boot/dts/qcom-apq8064-asus-nexus7-flo.dtb: Warning (graph_port=
): /soc/replicator/ports/port@2: graph node unit address error, expected "0"
    arch/arm/boot/dts/qcom-apq8064-asus-nexus7-flo.dtb: Warning (graph_port=
): /soc/funnel@1a04000/ports/port@8: graph node unit address error, expecte=
d "0"
    arch/arm/boot/dts/qcom-apq8074-dragonboard.dtb: Warning (graph_port): /=
soc/replicator@fc31c000/ports/port@2: graph node unit address error, expect=
ed "0"
    arch/arm/boot/dts/qcom-apq8074-dragonboard.dtb: Warning (graph_port): /=
soc/etf@fc307000/ports/port@1: graph node unit address error, expected "0"
    arch/arm/boot/dts/qcom-apq8074-dragonboard.dtb: Warning (graph_port): /=
soc/funnel@fc31b000/ports/port@8: graph node unit address error, expected "=
0"
    arch/arm/boot/dts/qcom-apq8074-dragonboard.dtb: Warning (graph_port): /=
soc/funnel@fc31a000/ports/port@8: graph node unit address error, expected "=
0"
    arch/arm/boot/dts/qcom-apq8074-dragonboard.dtb: Warning (graph_port): /=
soc/funnel@fc345000/ports/port@8: graph node unit address error, expected "=
0"
    arch/arm/boot/dts/qcom-msm8974-fairphone-fp2.dtb: Warning (graph_port):=
 /soc/replicator@fc31c000/ports/port@2: graph node unit address error, expe=
cted "0"
    arch/arm/boot/dts/qcom-msm8974-fairphone-fp2.dtb: Warning (graph_port):=
 /soc/etf@fc307000/ports/port@1: graph node unit address error, expected "0"
    arch/arm/boot/dts/qcom-msm8974-fairphone-fp2.dtb: Warning (graph_port):=
 /soc/funnel@fc31b000/ports/port@8: graph node unit address error, expected=
 "0"
    arch/arm/boot/dts/qcom-msm8974-fairphone-fp2.dtb: Warning (graph_port):=
 /soc/funnel@fc31a000/ports/port@8: graph node unit address error, expected=
 "0"
    arch/arm/boot/dts/qcom-msm8974-fairphone-fp2.dtb: Warning (graph_port):=
 /soc/funnel@fc345000/ports/port@8: graph node unit address error, expected=
 "0"
    arch/arm/boot/dts/qcom-msm8974-lge-nexus5-hammerhead.dtb: Warning (grap=
h_port): /soc/replicator@fc31c000/ports/port@2: graph node unit address err=
or, expected "0"
    arch/arm/boot/dts/qcom-msm8974-lge-nexus5-hammerhead.dtb: Warning (grap=
h_port): /soc/etf@fc307000/ports/port@1: graph node unit address error, exp=
ected "0"
    arch/arm/boot/dts/qcom-msm8974-lge-nexus5-hammerhead.dtb: Warning (grap=
h_port): /soc/funnel@fc31b000/ports/port@8: graph node unit address error, =
expected "0"
    arch/arm/boot/dts/qcom-msm8974-lge-nexus5-hammerhead.dtb: Warning (grap=
h_port): /soc/funnel@fc31a000/ports/port@8: graph node unit address error, =
expected "0"
    arch/arm/boot/dts/qcom-msm8974-lge-nexus5-hammerhead.dtb: Warning (grap=
h_port): /soc/funnel@fc345000/ports/port@8: graph node unit address error, =
expected "0"
    arch/arm/boot/dts/qcom-msm8974-samsung-klte.dtb: Warning (graph_port): =
/soc/replicator@fc31c000/ports/port@2: graph node unit address error, expec=
ted "0"
    arch/arm/boot/dts/qcom-msm8974-samsung-klte.dtb: Warning (graph_port): =
/soc/etf@fc307000/ports/port@1: graph node unit address error, expected "0"
    arch/arm/boot/dts/qcom-msm8974-samsung-klte.dtb: Warning (graph_port): =
/soc/funnel@fc31b000/ports/port@8: graph node unit address error, expected =
"0"
    arch/arm/boot/dts/qcom-msm8974-samsung-klte.dtb: Warning (graph_port): =
/soc/funnel@fc31a000/ports/port@8: graph node unit address error, expected =
"0"
    arch/arm/boot/dts/qcom-msm8974-samsung-klte.dtb: Warning (graph_port): =
/soc/funnel@fc345000/ports/port@8: graph node unit address error, expected =
"0"
    arch/arm/boot/dts/qcom-msm8974-sony-xperia-amami.dtb: Warning (graph_po=
rt): /soc/replicator@fc31c000/ports/port@2: graph node unit address error, =
expected "0"
    arch/arm/boot/dts/qcom-msm8974-sony-xperia-amami.dtb: Warning (graph_po=
rt): /soc/etf@fc307000/ports/port@1: graph node unit address error, expecte=
d "0"
    arch/arm/boot/dts/qcom-msm8974-sony-xperia-amami.dtb: Warning (graph_po=
rt): /soc/funnel@fc31b000/ports/port@8: graph node unit address error, expe=
cted "0"
    arch/arm/boot/dts/qcom-msm8974-sony-xperia-amami.dtb: Warning (graph_po=
rt): /soc/funnel@fc31a000/ports/port@8: graph node unit address error, expe=
cted "0"
    arch/arm/boot/dts/qcom-msm8974-sony-xperia-amami.dtb: Warning (graph_po=
rt): /soc/funnel@fc345000/ports/port@8: graph node unit address error, expe=
cted "0"
    arch/arm/boot/dts/qcom-msm8974-sony-xperia-castor.dtb: Warning (graph_p=
ort): /soc/replicator@fc31c000/ports/port@2: graph node unit address error,=
 expected "0"
    arch/arm/boot/dts/qcom-msm8974-sony-xperia-castor.dtb: Warning (graph_p=
ort): /soc/etf@fc307000/ports/port@1: graph node unit address error, expect=
ed "0"
    arch/arm/boot/dts/qcom-msm8974-sony-xperia-castor.dtb: Warning (graph_p=
ort): /soc/funnel@fc31b000/ports/port@8: graph node unit address error, exp=
ected "0"
    arch/arm/boot/dts/qcom-msm8974-sony-xperia-castor.dtb: Warning (graph_p=
ort): /soc/funnel@fc31a000/ports/port@8: graph node unit address error, exp=
ected "0"
    arch/arm/boot/dts/qcom-msm8974-sony-xperia-castor.dtb: Warning (graph_p=
ort): /soc/funnel@fc345000/ports/port@8: graph node unit address error, exp=
ected "0"
    arch/arm/boot/dts/qcom-msm8974-sony-xperia-honami.dtb: Warning (graph_p=
ort): /soc/replicator@fc31c000/ports/port@2: graph node unit address error,=
 expected "0"
    arch/arm/boot/dts/qcom-msm8974-sony-xperia-honami.dtb: Warning (graph_p=
ort): /soc/etf@fc307000/ports/port@1: graph node unit address error, expect=
ed "0"
    arch/arm/boot/dts/qcom-msm8974-sony-xperia-honami.dtb: Warning (graph_p=
ort): /soc/funnel@fc31b000/ports/port@8: graph node unit address error, exp=
ected "0"
    arch/arm/boot/dts/qcom-msm8974-sony-xperia-honami.dtb: Warning (graph_p=
ort): /soc/funnel@fc31a000/ports/port@8: graph node unit address error, exp=
ected "0"
    arch/arm/boot/dts/qcom-msm8974-sony-xperia-honami.dtb: Warning (graph_p=
ort): /soc/funnel@fc345000/ports/port@8: graph node unit address error, exp=
ected "0"

---------------------------------------------------------------------------=
-----
qi_lb60_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
raumfeld_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
rb532_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
rbtx49xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
realview_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
rpc_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
s5pv210_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
sama5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
sb1250_swarm_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, =
0 section mismatches

---------------------------------------------------------------------------=
-----
shannon_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm, gcc-8) =E2=80=94 FAIL, 4 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    drivers/pinctrl/sh-pfc/pfc-r8a7792.c:1750:38: error: macro "VIN_DATA_PI=
N_GROUP" passed 3 arguments, but takes just 2
    drivers/pinctrl/sh-pfc/pfc-r8a7792.c:1750:2: error: =E2=80=98VIN_DATA_P=
IN_GROUP=E2=80=99 undeclared here (not in a function); did you mean =E2=80=
=98PIN_MAP_TYPE_MUX_GROUP=E2=80=99?
    drivers/pinctrl/sh-pfc/pfc-r8a7792.c:1751:38: error: macro "VIN_DATA_PI=
N_GROUP" passed 3 arguments, but takes just 2
    drivers/pinctrl/sh-pfc/pfc-r8a7792.c:1753:38: error: macro "VIN_DATA_PI=
N_GROUP" passed 3 arguments, but takes just 2

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
spear13xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
spear3xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
spear6xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
spitz_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
stm32_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
sunxi_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
tango4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
tb0219_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
tb0226_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
tb0287_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
tct_hammer_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    .config:1009:warning: override: UNWINDER_GUESS changes choice state

---------------------------------------------------------------------------=
-----
tinyconfig (riscv, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
tinyconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
tinyconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
tinyconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
tinyconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
trizeps4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
u300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
u8500_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 15 warnings, 0 secti=
on mismatches

Warnings:
    arch/arm/boot/dts/ste-snowball.dtb: Warning (graph_port): /soc/funnel@8=
01a6000/ports/port@1: graph node unit address error, expected "0"
    arch/arm/boot/dts/ste-snowball.dtb: Warning (graph_port): /soc/funnel@8=
01a6000/ports/port@2: graph node unit address error, expected "1"
    arch/arm/boot/dts/ste-snowball.dtb: Warning (graph_port): /soc/replicat=
or/ports/port@2: graph node unit address error, expected "0"
    arch/arm/boot/dts/ste-hrefprev60-stuib.dtb: Warning (graph_port): /soc/=
funnel@801a6000/ports/port@1: graph node unit address error, expected "0"
    arch/arm/boot/dts/ste-hrefprev60-stuib.dtb: Warning (graph_port): /soc/=
funnel@801a6000/ports/port@2: graph node unit address error, expected "1"
    arch/arm/boot/dts/ste-hrefprev60-stuib.dtb: Warning (graph_port): /soc/=
replicator/ports/port@2: graph node unit address error, expected "0"
    arch/arm/boot/dts/ste-hrefprev60-tvk.dtb: Warning (graph_port): /soc/fu=
nnel@801a6000/ports/port@1: graph node unit address error, expected "0"
    arch/arm/boot/dts/ste-hrefprev60-tvk.dtb: Warning (graph_port): /soc/fu=
nnel@801a6000/ports/port@2: graph node unit address error, expected "1"
    arch/arm/boot/dts/ste-hrefprev60-tvk.dtb: Warning (graph_port): /soc/re=
plicator/ports/port@2: graph node unit address error, expected "0"
    arch/arm/boot/dts/ste-hrefv60plus-stuib.dtb: Warning (graph_port): /soc=
/funnel@801a6000/ports/port@1: graph node unit address error, expected "0"
    arch/arm/boot/dts/ste-hrefv60plus-stuib.dtb: Warning (graph_port): /soc=
/funnel@801a6000/ports/port@2: graph node unit address error, expected "1"
    arch/arm/boot/dts/ste-hrefv60plus-stuib.dtb: Warning (graph_port): /soc=
/replicator/ports/port@2: graph node unit address error, expected "0"
    arch/arm/boot/dts/ste-hrefv60plus-tvk.dtb: Warning (graph_port): /soc/f=
unnel@801a6000/ports/port@1: graph node unit address error, expected "0"
    arch/arm/boot/dts/ste-hrefv60plus-tvk.dtb: Warning (graph_port): /soc/f=
unnel@801a6000/ports/port@2: graph node unit address error, expected "1"
    arch/arm/boot/dts/ste-hrefv60plus-tvk.dtb: Warning (graph_port): /soc/r=
eplicator/ports/port@2: graph node unit address error, expected "0"

---------------------------------------------------------------------------=
-----
vdk_hs38_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
vdk_hs38_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
vexpress_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 4 warnings, 0 sec=
tion mismatches

Warnings:
    arch/arm/boot/dts/vexpress-v2p-ca15_a7.dtb: Warning (graph_port): /repl=
icator/ports/port@2: graph node unit address error, expected "0"
    arch/arm/boot/dts/vexpress-v2p-ca15_a7.dtb: Warning (graph_port): /funn=
el@20040000/ports/port@1: graph node unit address error, expected "0"
    arch/arm/boot/dts/vexpress-v2p-ca15_a7.dtb: Warning (graph_port): /funn=
el@20040000/ports/port@2: graph node unit address error, expected "1"
    arch/arm/boot/dts/vexpress-v2p-ca15_a7.dtb: Warning (graph_port): /funn=
el@20040000/ports/port@3: graph node unit address error, expected "2"

---------------------------------------------------------------------------=
-----
vf610m4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
viper_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
vocore2_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
workpad_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
x86_64_defconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
xcep_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
xway_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
zx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---
For more info write to <info@kernelci.org>
