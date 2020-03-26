Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFBC193762
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 05:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726014AbgCZEvd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 00:51:33 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45635 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbgCZEvd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Mar 2020 00:51:33 -0400
Received: by mail-pf1-f194.google.com with SMTP id j10so2162248pfi.12
        for <stable@vger.kernel.org>; Wed, 25 Mar 2020 21:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Z+p7K1bdo5CnqymaCgpJZr2tovuabgPcsROO66IkfTk=;
        b=Ok9TItMAFJ5qvCvIHKq4Zb3WQhzNckPpE2BP1ruKZzzvb0KyFYCI8MhCRDlOarTlYq
         9iVvF/+b+rsBYrcOXr0jkMTflwN2Vgy82KREctF/TFrQzSN32PQIYka7Hl/Dl/M0yynT
         Qq/QL8IHZG7vaywtoMCV/Wb85tLHXFMBgTxoyYq56bB5AXW6w7ombQwVjeuPca7rmruR
         N1Un9CPjgbYpItM5AX0AmVnNtFmfFiSTmipbelBbwq9gUDrPEwZIOND5vmGHEwjylHqA
         cSS9M7di4NCXMtEJ7g3Y58/9mzZR1WFxNw43Z1+ZSt9YFvRUNT/kTmk4pyp1C0sOAGk8
         HYdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Z+p7K1bdo5CnqymaCgpJZr2tovuabgPcsROO66IkfTk=;
        b=Vwtjtveu+Km0N2GKDhqwSWj7FD5ASOjlj8vvd1mkCmO+5gFn/eGqqYwReJA8pAJ8is
         pDZmbIDRGG8Yq4lCcHJaQDc8P6hFKY390d0X18gOgllvVDj8Sy1oUeQpNastZF+QQMmU
         jVLkaS3FEpVT/XgerNRoP8rA1ds1eCBNOZL8qapS5/j7Kk07R7UMzyQBdSedZV+l6VZB
         bzCqZ7LNWi+0XIIuTJCKBMLrlTNGDtAlalwyo+BRZGkTUYNI6LAiubF3pkDclN72A3e2
         LPpiCmha6tkwdpNU481Gqk//vQD5DKLUgYbD3b/FaiewMPEAw/AmOHYd1uWuBdNNVFoq
         vsAA==
X-Gm-Message-State: ANhLgQ0x0YJ+nqukEEZHAG/iZPBUonH2Mmbc6ikHLuITlXMGcrz3dLNg
        qrWOqoV5evkna3gaRrWLjvGadWWEr1k=
X-Google-Smtp-Source: ADFU+vum4MZkddrjmXZkq4gBnjePzRa4yOvS5enV74fpFlZBL9HrbfQr+hWNBrzPnNSZF3AKgWYV4g==
X-Received: by 2002:a63:215a:: with SMTP id s26mr6641993pgm.339.1585198290709;
        Wed, 25 Mar 2020 21:51:30 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l5sm614056pgt.10.2020.03.25.21.51.29
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 21:51:30 -0700 (PDT)
Message-ID: <5e7c34d2.1c69fb81.3db86.2efb@mx.google.com>
Date:   Wed, 25 Mar 2020 21:51:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.113
X-Kernelci-Report-Type: build
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y build: 206 builds: 0 failed, 206 passed,
 10 warnings (v4.19.113)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y build: 206 builds: 0 failed, 206 passed, 10 warnings=
 (v4.19.113)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.113/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.113
Git Commit: 54b4fa6d39551639cb10664f6ac78b01993a1d7e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 7 unique architectures

Warnings Detected:

arc:

arm64:

arm:
    multi_v7_defconfig (gcc-8): 2 warnings
    sunxi_defconfig (gcc-8): 2 warnings

i386:

mips:
    lemote2f_defconfig (gcc-8): 1 warning
    loongson3_defconfig (gcc-8): 2 warnings
    malta_qemu_32r6_defconfig (gcc-8): 1 warning
    nlm_xlp_defconfig (gcc-8): 1 warning

riscv:

x86_64:
    tinyconfig (gcc-8): 1 warning


Warnings summary:

    3    net/core/rtnetlink.c:3190:1: warning: the frame size of 1312 bytes=
 is larger than 1024 bytes [-Wframe-larger-than=3D]
    2    drivers/gpu/drm/sun4i/sun4i_hdmi_tmds_clk.c:159:5: warning: =E2=80=
=98is_double=E2=80=99 may be used uninitialized in this function [-Wmaybe-u=
ninitialized]
    2    arch/arm/boot/dts/sun8i-h3-beelink-x2.dtb: Warning (clocks_propert=
y): /wifi_pwrseq: Missing property '#clock-cells' in node /soc/rtc@1f00000 =
or bad phandle (referred from clocks[0])
    1    {standard input}:131: Warning: macro instruction expanded into mul=
tiple instructions
    1    arch/mips/configs/loongson3_defconfig:55:warning: symbol value 'm'=
 invalid for HOTPLUG_PCI_SHPC
    1    .config:1010:warning: override: UNWINDER_GUESS changes choice state

---
For more info write to <info@kernelci.org>
