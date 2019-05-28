Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 629252C614
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 14:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbfE1MEZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 May 2019 08:04:25 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:36980 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726974AbfE1MEZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 May 2019 08:04:25 -0400
Received: by mail-wr1-f46.google.com with SMTP id h1so5792692wro.4
        for <stable@vger.kernel.org>; Tue, 28 May 2019 05:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1deJgB3uk8A3F1trWuQB7UM/ILOF2g01mNVqP0XVeko=;
        b=FTb3rdvsOyFoPuk9WzepcxHTKqkttdH+uq7LtXcK9k4lH9UtBiyJvSbNa79EH60bym
         KgNKpRKdfYOS/sLRYgTFqvye1vLTnWTu/RCYSM8P2QB68m89HmdufpXK7IDzInUobwcS
         qMH2lbOMMdvnDLMKHc2dQAKWtcVvAaUATOWnY/hHdhWnoTG+sBSfEAGWIZFdsMPUzOJt
         jI8dDXUQa3cxyE9bQI3WZq/d+ZJxcWaUqi1TUFVuppfa92m1QClk9+caq+dbEuyNPgjG
         BVBWv5LrHlLl0TQk4LozAnL137QRQaMquAfApsCFCVf9rIjTX6mUqmKkCEIp0ZUTNqRw
         o+DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1deJgB3uk8A3F1trWuQB7UM/ILOF2g01mNVqP0XVeko=;
        b=IOFXyioJzZBdOqwKv2s4a8IFj/2L0+CjHQFU9eu7NVQsTmO1hGwKml645+28j4wJ3L
         TLE6kOKUpbXI1ae4r2xoJXwsLq0yzrAY32vWmINdkELBNssoQ7I5O9c+UL3Nv4KOvrnV
         VNeapmCWw57i3iTHtoc4GStXrWl7z0vDc9a/426AkQAb10xjTDYGxONWRDN6z6rgsdSb
         Oh4cF9HLwPU3n8wUmzz0vINz3s13lda1Coz4TtWmIeTbqhQVbGMGt97MbjtAbJszH7OP
         sO0ixMXqfQ12wADd6uQJG9JsO8Z0Jet6Vd/3H0rulYii6KHBtVWike4zcMXtPiPWnjkn
         1ckw==
X-Gm-Message-State: APjAAAXVV/DlrtRBK0NwcOWTmWknfFMsmpirSTgRxpxO2B68wt+jse7s
        y3CYuJAKGuMFM0a6umBsi8bDFAACz2PYQA==
X-Google-Smtp-Source: APXvYqxlK1keworLBt5NzGgCq3pDpfTdTN0Y8+ac7FMg+Yi4T+ZAmG9bR6zKvx5pExw70sngN1hrrA==
X-Received: by 2002:a5d:5586:: with SMTP id i6mr9973166wrv.299.1559045062888;
        Tue, 28 May 2019 05:04:22 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id h15sm13673784wru.52.2019.05.28.05.04.21
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 05:04:21 -0700 (PDT)
Message-ID: <5ced23c5.1c69fb81.34ef4.a692@mx.google.com>
Date:   Tue, 28 May 2019 05:04:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.122-25-g134da08a28ad
Subject: stable-rc/linux-4.14.y boot: 120 boots: 0 failed,
 105 passed with 15 offline (v4.14.122-25-g134da08a28ad)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 120 boots: 0 failed, 105 passed with 15 offlin=
e (v4.14.122-25-g134da08a28ad)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.122-25-g134da08a28ad/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.122-25-g134da08a28ad/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.122-25-g134da08a28ad
Git Commit: 134da08a28ad3d3a467e925b1f61598dc5e878a2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 63 unique boards, 24 SoC families, 14 builds out of 201

Offline Platforms:

arm:

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            stih410-b2120: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            tegra124-jetson-tk1: 1 offline lab
            tegra20-iris-512: 1 offline lab

    tegra_defconfig:
        gcc-8
            tegra124-jetson-tk1: 1 offline lab
            tegra20-iris-512: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            mt7622-rfb1: 1 offline lab

---
For more info write to <info@kernelci.org>
