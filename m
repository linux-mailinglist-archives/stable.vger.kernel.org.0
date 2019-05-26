Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 366282A776
	for <lists+stable@lfdr.de>; Sun, 26 May 2019 02:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727511AbfEZA41 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 May 2019 20:56:27 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:46558 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727504AbfEZA41 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 May 2019 20:56:27 -0400
Received: by mail-wr1-f43.google.com with SMTP id r7so13366505wrr.13
        for <stable@vger.kernel.org>; Sat, 25 May 2019 17:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+5BJVTTNYYM+UMJcn40xSUuY7ECavcF5JBVpxFEUhas=;
        b=XIAgQfrkFA2vnap3TEessjwEm/WNHMhNLJ489g/Axn923zIdeyljWinxuofaOfA5xl
         qxBO5spftsufFpJwC2ND8HcUp5FTmi9AjXzcC1DaY0awZ4QcHi3eyZPSOuEcGyhh7McL
         MK1XvMmumtlC5qti0zZXZwvfVO6sskuKzYNaalMAt/v8WasbqbBX03qGBLfqPhXHic3i
         p86Kvi/bMPuVxN0+8pYbHDHP8nNIROPo9/Kn9g02xooZ3yXsJVZ2d3SNYkW2oo7R1hMQ
         O5s1XqAvhHsS9ze5eo5/OF72PkRQrxyx0dJFZONeAV6hGzi83zuMLfpiwg4zLTGcCzQ1
         rqYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+5BJVTTNYYM+UMJcn40xSUuY7ECavcF5JBVpxFEUhas=;
        b=m2pDFz4ixDaQUwkRLUjzJ/DaQ49pxorNRMtWZ+qFecr2r8ByI8CrhbUyD3JWh+l6BX
         8brFpag6RGRXzOZqN+U+Tx+s5CuEpLGu+XasLTysWu7YoJx8fIecwcH+542enudEmSPt
         9wtPzmwW3ZUIp/87dsLqrRuVUu4RsFKOjQJ+vTbQntw32ZuRICh1acWRQ10vht/NnB80
         JPSKHEl+94QKkLoVEEOnvU/7n5knQW8ex9OLZHSnfrOC8X4Coe65qrj5mZEMWbbW5ayz
         Ri2+ejjEky4AuPkLdczP4ZMV/EDdz7DnaBsmEB6Q6i7xX0NnBLkV/TsAZ6N3U/i1Tjk+
         oKWg==
X-Gm-Message-State: APjAAAUjZJ8xSMXS4bplTZYv1x0iyshxDFTszW5A7dVXm5ksTLv1vY+c
        s5toDunIEIYoVsRRZxCzRpaSihJbvIA=
X-Google-Smtp-Source: APXvYqzsp6DJoYg8r322fjb11SkRXuHJNcGc+QhsO5ObTmRnpQlpCUZWGyZGGPsXjB5TgeQVVt+UJA==
X-Received: by 2002:adf:e711:: with SMTP id c17mr31092894wrm.227.1558832185383;
        Sat, 25 May 2019 17:56:25 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id i9sm5416098wmf.43.2019.05.25.17.56.24
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 25 May 2019 17:56:24 -0700 (PDT)
Message-ID: <5ce9e438.1c69fb81.e61d0.cd56@mx.google.com>
Date:   Sat, 25 May 2019 17:56:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.0.y
X-Kernelci-Kernel: v5.0.19
Subject: stable-rc/linux-5.0.y boot: 128 boots: 0 failed,
 114 passed with 14 offline (v5.0.19)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.0.y boot: 128 boots: 0 failed, 114 passed with 14 offline=
 (v5.0.19)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.0.y/kernel/v5.0.19/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.0.y=
/kernel/v5.0.19/

Tree: stable-rc
Branch: linux-5.0.y
Git Describe: v5.0.19
Git Commit: 3f7c1cab1a61108821cf47dda8a32ed25cc3588b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 71 unique boards, 23 SoC families, 14 builds out of 208

Offline Platforms:

arm:

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab
            at91-sama5d4ek: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            at91-sama5d4ek: 1 offline lab
            stih410-b2120: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            tegra124-jetson-tk1: 1 offline lab

    tegra_defconfig:
        gcc-8
            tegra124-jetson-tk1: 1 offline lab

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
