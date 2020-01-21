Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5C361434DA
	for <lists+stable@lfdr.de>; Tue, 21 Jan 2020 01:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgAUAry (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jan 2020 19:47:54 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46962 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727009AbgAUAry (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jan 2020 19:47:54 -0500
Received: by mail-wr1-f65.google.com with SMTP id z7so1329541wrl.13
        for <stable@vger.kernel.org>; Mon, 20 Jan 2020 16:47:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yxNVTigx7RjcxB97RncCUH2FitTWgTntOugJWBkeSBE=;
        b=aahGv7b670nBwERxfe/azeE+ieA3cIARM8ZuNupA7UjyklAkghyDEtU9TCA1/9WvKn
         M3WKCA9AmzT8tao9qJHmjLIua3MH8pgmNYLs79OR9cWlZAxnlxXFVsZgqEJnZukEgZco
         gqxEShdsNQuw0QUdHgQHmmggcTaoYnuDV4/svhGIvNtFSJGXf9LK97oTssFY5TSauqFK
         jACKkCkeH5gSLo6elErTyO6g0mOblGAAwc7sdyeFm9Vudf+gRBE5yHc9nSMbM77+Nenk
         vW0A9KawfAeei6ehenm1Jo+9OE+obCqFqbM/+5a7BjNJcn1Gmdi330xM6PI124kMt+p/
         IC6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yxNVTigx7RjcxB97RncCUH2FitTWgTntOugJWBkeSBE=;
        b=RfLvRIXXPYOkHyNgfCFnDFyWPf1wYoSXwh1K97Z25Fh0YN2qwuaeFThJKlTPKzy2xU
         LlKRfOf2jcqDauYevGDIumu3UO5kB/c99xkl90qZ+EocrTIm/m+lIORPBd8J8vah5+uX
         SUj4HZRVt0sGzhOOwshbZafrVmDPekDLUH4GVdM/f+n7ai1Sntucc1HYdND+3tKAA+5i
         sqJ/MNJMViiUSXMTY1XEwThlFOXMzD+hobdUNG8W6xuyLyb08/KHvGTHeN+XGafDubMz
         W9SZkow4fN+zew/4xJ08FiqISFcKEDvJakxALaTtl0IIUEyTi1kJs5670UtsARc7hJfZ
         F9aQ==
X-Gm-Message-State: APjAAAW0jL+8vbchUOIG8eqT71wSXwkL76yhvobdQ+Se7vh01zNZeSk7
        irn2i8JxRWymZAsvByJNrOI/NXUZRDbBwQ==
X-Google-Smtp-Source: APXvYqyWBxhODlORpQUdaUYKlvwzkdibi5q7CIbP6y6qtx3BrICRdfnl0YOPXT1DiqeC4TKtg65S2w==
X-Received: by 2002:adf:f3d1:: with SMTP id g17mr1961934wrp.378.1579567672180;
        Mon, 20 Jan 2020 16:47:52 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n3sm47046863wrs.8.2020.01.20.16.47.51
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 16:47:51 -0800 (PST)
Message-ID: <5e264a37.1c69fb81.917b5.e132@mx.google.com>
Date:   Mon, 20 Jan 2020 16:47:51 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.166-41-g9accc54d9689
Subject: stable-rc/linux-4.14.y boot: 107 boots: 1 failed,
 96 passed with 9 offline, 1 untried/unknown (v4.14.166-41-g9accc54d9689)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 107 boots: 1 failed, 96 passed with 9 offline,=
 1 untried/unknown (v4.14.166-41-g9accc54d9689)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.166-41-g9accc54d9689/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.166-41-g9accc54d9689/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.166-41-g9accc54d9689
Git Commit: 9accc54d96898b2e3dd6c27ffcb36db40e2dff13
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 62 unique boards, 20 SoC families, 14 builds out of 198

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            juno-r2: 1 offline lab
            mt7622-rfb1: 1 offline lab

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

---
For more info write to <info@kernelci.org>
