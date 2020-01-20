Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4FBC1432AC
	for <lists+stable@lfdr.de>; Mon, 20 Jan 2020 20:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgATT5x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jan 2020 14:57:53 -0500
Received: from mail-wr1-f49.google.com ([209.85.221.49]:46412 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbgATT5x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jan 2020 14:57:53 -0500
Received: by mail-wr1-f49.google.com with SMTP id z7so712293wrl.13
        for <stable@vger.kernel.org>; Mon, 20 Jan 2020 11:57:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4dkpylIrHncmfxqNvIkcEzWs4R1JMzmcWuvbDL8PNtk=;
        b=XS88pqXfXJ4QQIzFtc/UK3RXecqFBPPMp7gEEzXt4pLLU5x2sMF8cXtThOyl5MCDif
         vCPvnXyBaNbRrXyiwwqYKiWvNj2noAhnbG3Ky2SPrQU+63gPDBOAwM551ym2i6DwZi3d
         Q9vCc8mU01mAJW0Jqaz7+u1LFflqwmyvop+Krvc2US45QxFM9LpH3JR58qQNoWrMtLtp
         PPKQ41UpLAQhj3NutI6uuWNGMRmnvZT/W/2AVirD1HxUzkwRxcoWIW/rwNcehAWR7xtE
         Yd5m4tfM7qPE21yn0+NftzX8TQaYrjhkUl8t0WVEbVSn3D5k8O1/l3gyXrWTsBraKSNf
         UeKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4dkpylIrHncmfxqNvIkcEzWs4R1JMzmcWuvbDL8PNtk=;
        b=GCAvsaLufl7YQCwWDr9xwGFR1Hi4b+PEJkZ4nke3JgR8PLdQZvkEl6F4ZKWrpB0utB
         cxTrWC7N814aTEN14I3Bf9pJjcu8bWZgCzD19X19dXQYOCwnwMs1SQFfIBTEK6iUL0ka
         PLbgG6hd0DBNp8CrQSBkgOTzgMidG2P9d3WwmkonD/Y7crdjNtvrSyElozpMXKCdOlJa
         jjZ4mMaO94lCsJpD/DY1xtCxYGEl94nfK02ScF3+j+bM76IpkvqwJA+/6xuVGoYAB6vl
         h0GzIQV/Rg5qiX6k8wVuiYxaIN4AKRt2f4vKy+fB7d3o1IaTpds2akpmQI6KFZz54GBi
         5dSg==
X-Gm-Message-State: APjAAAUvEm6jNglm+elZfcH801541nXAIA8X94flc0sJOyLAqgISQipf
        sz7fS1xNfkCT7x8uEKw9snRWAxB71eiPAA==
X-Google-Smtp-Source: APXvYqx2aih3kdL70ldlObqsltTvespDouy0yVEv797UseNr0dmo4M/5cH45QF/L42KZFMSyDVQFlg==
X-Received: by 2002:adf:f288:: with SMTP id k8mr1151732wro.301.1579550270853;
        Mon, 20 Jan 2020 11:57:50 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id q3sm526526wmj.38.2020.01.20.11.57.50
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 11:57:50 -0800 (PST)
Message-ID: <5e26063e.1c69fb81.c8175.2b6f@mx.google.com>
Date:   Mon, 20 Jan 2020 11:57:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.210-81-g0f7725a1298b
Subject: stable-rc/linux-4.9.y boot: 100 boots: 2 failed,
 87 passed with 9 offline, 2 untried/unknown (v4.9.210-81-g0f7725a1298b)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 100 boots: 2 failed, 87 passed with 9 offline, =
2 untried/unknown (v4.9.210-81-g0f7725a1298b)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.210-81-g0f7725a1298b/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.210-81-g0f7725a1298b/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.210-81-g0f7725a1298b
Git Commit: 0f7725a1298bdfb6612898c01a4e7abb01f7e1a7
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 53 unique boards, 18 SoC families, 16 builds out of 192

Boot Regressions Detected:

arm:

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: new failure (last pass: v4.9.210-77-g2f=
9a91e62a20)
          sun5i-r8-chip:
              lab-baylibre-seattle: new failure (last pass: v4.9.210-77-g2f=
9a91e62a20)

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            juno-r2: 1 offline lab

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    socfpga_defconfig:
        gcc-8
            socfpga_cyclone5_de0_sockit: 1 offline lab

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
