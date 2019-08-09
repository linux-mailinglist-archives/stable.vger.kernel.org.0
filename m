Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 070E786EC4
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 02:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404422AbfHIAVj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 20:21:39 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:43217 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404329AbfHIAVi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Aug 2019 20:21:38 -0400
Received: by mail-wr1-f45.google.com with SMTP id p13so22001804wru.10
        for <stable@vger.kernel.org>; Thu, 08 Aug 2019 17:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=m6XtIgVfE/xHFDxmjBECX2j6xBc0VKm2fno11Ae74tk=;
        b=EeD7LnSzE+2mfYRkPv4PiwwPYHQUqUUYH6jk+X/aOSEuJ/EpWAvhLE5i/WHlcvb5Pp
         zOeoobUzTKqYPR2NjV1FBlBRJhnU6OmqvkAbJ+rIU0q8JofDKo5PLhIB3j44chGkFK9d
         8G5cxtXlsAK/E3G4lHGHm1TsC/mrumJeWs4vtdFaa/IYf+zpyaVGj3EfHMnZU7exT0/i
         EOhwphhKmbKWNMT/dFdjYvwnYSlgb+5DKFPficM4M3uXPYWPSQCnY3LK26EW8+XgjsIO
         35Qdw6ltarmzzNSVbQaq1B6F0fZzj8uM3H4kO0/zAgNcHICsJuB0g2xBRUlFvA3OaA2s
         nnZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=m6XtIgVfE/xHFDxmjBECX2j6xBc0VKm2fno11Ae74tk=;
        b=tbzu7jqjaQICufycZavki564IUHStGrVk84QGUE2OReNVXq4m4MVzEwQudK9uNlDTD
         1WLNQ7uB3eT5ziMXPtPyqEWIMXNXfUsisbDF/Qu0/m2f6ApP2pcowbtgTHC/NmnLm2G7
         OV/EIuvh/9WQpFNwJjuVJ5X17ss4c8AZycPdABaCNuDOML4dao0A3z2rSAftrrKoHOip
         DgHz7jFQxBbX3pYpySuoVi2z9tyi38KdcvnfSWmqQeQMg7OSRqNlnEWb+lJHD+43QJ8o
         WA6t4s+6LBXeXQgR+loCyekq/80u+chZXhtwbndqE9g3WyjUQip8294sIueoDvjJhsqk
         83CA==
X-Gm-Message-State: APjAAAXDXC8VyqyM0syESa+WaC2jWM0vNH/i6XxisUPmJAl7oNOWOSUs
        LRES+qD5Ky2///K8rA7qEESClZDWz+UVxg==
X-Google-Smtp-Source: APXvYqwu3VxzhpNVJUQy1iBVuJXyNNkz/LNn2R5dzHdkd4EsR3ivvyAh10ijK6+6E0RNf2OhRxtYVw==
X-Received: by 2002:adf:e710:: with SMTP id c16mr10494384wrm.292.1565310096576;
        Thu, 08 Aug 2019 17:21:36 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l15sm9305237wrq.64.2019.08.08.17.21.35
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Aug 2019 17:21:35 -0700 (PDT)
Message-ID: <5d4cbc8f.1c69fb81.e52f4.f511@mx.google.com>
Date:   Thu, 08 Aug 2019 17:21:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.64-128-gd43238541496
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 124 boots: 0 failed,
 113 passed with 11 offline (v4.19.64-128-gd43238541496)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 124 boots: 0 failed, 113 passed with 11 offlin=
e (v4.19.64-128-gd43238541496)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.64-128-gd43238541496/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.64-128-gd43238541496/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.64-128-gd43238541496
Git Commit: d43238541496ae2b216aaac84e0933bb06eeb0a6
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 70 unique boards, 27 SoC families, 17 builds out of 206

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab
            mt7622-rfb1: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
