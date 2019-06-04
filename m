Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD85134689
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 14:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbfFDMYl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 08:24:41 -0400
Received: from mail-wm1-f48.google.com ([209.85.128.48]:51578 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727409AbfFDMYl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 08:24:41 -0400
Received: by mail-wm1-f48.google.com with SMTP id f10so14666221wmb.1
        for <stable@vger.kernel.org>; Tue, 04 Jun 2019 05:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TjXKtZGpflgb0USqB9CjEWWH7aP6SwaP0HEH8M1cp7g=;
        b=Q3X/cXtuYX8XTFknZFOIpCVhynCW5FIgLwCC87Wrw9y0FHDVhFeu1PXv/vBmVVRyLg
         Y7JqfJVvWl+0MQTLukJ+ibXj1n09fQKkddMXdH7dZTfnvtwqqN9FmiWCOT/4OQ+4qi4P
         s6geFfShaJ03SLpcyanP9RcjMbvebOZ74xvMiOC4Nv12fVBVnWtEjjB6mcCzwzTEw2/7
         /iST1/TsxYOm11kFFq9oIcM8Sf3uktIOmryW0ZaWpjZDSxIRSJ7hUzLREvco5TP6bFW1
         6HSapq2REt+l2wPMOZRf8FryrZgGueIK1WOFKDeG0QedFhUnV79esnL0vj1N3tMzC7A4
         gRhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TjXKtZGpflgb0USqB9CjEWWH7aP6SwaP0HEH8M1cp7g=;
        b=Nch0NKxKyk4OKqfW8dteEtvlRNRIbY+fwsSHob/s4WbiYHpNA9wu1ukYnef77Lw4Fo
         tflbnHqCEMJ5aNByceEoH19yheDq/Zlx3N9bWvzlz8zt62YSluwRAQAMQIwBdT9MpcJg
         QLnXXnkiAP7J6XXRjDd8An22JG66rc198rE69Op5lMfwUxa8HP/ochbebDdk644PdZsx
         6FRLVKcw/cWisasIC5ZIhs67eocKqXWRtlkgcZwkK/o2F3pgEWiDw0vdDiBDXA1H7gnG
         oplSTcoferTgeBCTTLzIIWIxvTOsaFqBA6KH/naG1MX9tNnf+XAE90GaaY5TR6SORsKj
         XR3A==
X-Gm-Message-State: APjAAAU4n+HRytza4tAgkoOJ+dScqWH++KX0nyg+GGBou1Phf8eJRj23
        ajoF9LSIU2lcpLZO14IqgjGpqawOQqY1XQ==
X-Google-Smtp-Source: APXvYqxJRsto9kUd9Z1+BFiKID4Iw4VGydohOIGDgKNWbeXVKRviGz1uvvILR1UO+c3uf2nftitBGQ==
X-Received: by 2002:a7b:c549:: with SMTP id j9mr6240371wmk.114.1559651078973;
        Tue, 04 Jun 2019 05:24:38 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id d18sm2927173wrn.26.2019.06.04.05.24.38
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 05:24:38 -0700 (PDT)
Message-ID: <5cf66306.1c69fb81.b4398.1c82@mx.google.com>
Date:   Tue, 04 Jun 2019 05:24:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.0.21
X-Kernelci-Branch: linux-5.0.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.0.y boot: 134 boots: 0 failed,
 122 passed with 11 offline, 1 untried/unknown (v5.0.21)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.0.y boot: 134 boots: 0 failed, 122 passed with 11 offline=
, 1 untried/unknown (v5.0.21)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.0.y/kernel/v5.0.21/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.0.y=
/kernel/v5.0.21/

Tree: stable-rc
Branch: linux-5.0.y
Git Describe: v5.0.21
Git Commit: fd1594eb706427cc0d88fdfc2c1dbecd5abe7a83
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 74 unique boards, 23 SoC families, 14 builds out of 208

Offline Platforms:

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab
            at91-sama5d4ek: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            at91-sama5d4ek: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            mt7622-rfb1: 1 offline lab

---
For more info write to <info@kernelci.org>
