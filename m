Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 004BA10259D
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 14:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727673AbfKSNlB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 08:41:01 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34423 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfKSNlA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 08:41:00 -0500
Received: by mail-wr1-f65.google.com with SMTP id e6so23929257wrw.1
        for <stable@vger.kernel.org>; Tue, 19 Nov 2019 05:40:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0frWimAnATgKKKHvoJQrskDhF0bqqm3M6pcal3BWTtU=;
        b=xBw7cwQrw8HHpG4Xv+vaxyvfnylpleUcmnmTLmAm11rPf54vSFbmZFkn1KzxLobtCx
         XbpHkNYA1jUW+4FEX+mqiGa/2kklKzgUBeeOzWNTSRAIpGP4oaVKtrMatENBFjbf+RS2
         OzueHFtz2b5MQbp17Xpp5dpcPsHJSrhLsRiEW+D67iVbfcB1rjMJxX74vxUox62QAH+D
         E7tN9rdV+zzI5p8wDQFss1kPGfdtXP0UfIxjWncJCPKbsBPhQEVIyvZ9ihLz990OpqwI
         ewygdtSPL1CexX8e9kTmEieSAHz+rOUgu+7ZiqpVk/sugDfurNl6A2bgEopAdnSG/66+
         MDOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0frWimAnATgKKKHvoJQrskDhF0bqqm3M6pcal3BWTtU=;
        b=t0mBKBophrMScQ/ikDHyzApqM5Gm4WaTDCLRh3gN+JTBjDHGJ18VQUMr5UNQ9QsUKM
         RMbCr3aw+v6sju/A8toDNSCZrVfHh6Wd9IDXigP5yEmj0sSnNkrpyDpVjQ86KyThs+6z
         EBaoGsFZYyEqypOq8IZNUQVp809C0cKKJeI+H8VPv797ujIbL/77M8erZOE1j/o51EK4
         grNdHXyKLmER4Mz37DfWqT1PhSgWG6gfJPgbLhgNN9JQXYNdAL3OtPGjTh0YAr9gG7UG
         02P3GBMteXq4hOyYtDEcT1N6w1HNHPMQCeXcU2bEiRZmDJcgPK8kohyFRaJOpshbCsdo
         RE4A==
X-Gm-Message-State: APjAAAVNZm3GNTMQkLWqF9+JWnpRNJjCAm0juw+iMNw1aVdX7EHlZ/20
        QPv64xunCTtq77baYUgrGpQ4SV2NVw0+LQ==
X-Google-Smtp-Source: APXvYqx1mxE3gsEyZe1yhHAozaoe5Y8HfMfs2j7xDOZT6pdAowD6ckFn/gHHXE+Hfhs4IRBULBcKjw==
X-Received: by 2002:a5d:5089:: with SMTP id a9mr21359381wrt.57.1574170858665;
        Tue, 19 Nov 2019 05:40:58 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r2sm3199293wma.44.2019.11.19.05.40.57
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 05:40:57 -0800 (PST)
Message-ID: <5dd3f0e9.1c69fb81.3e5f9.f16b@mx.google.com>
Date:   Tue, 19 Nov 2019 05:40:57 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.201-179-ge948539072c5
Subject: stable-rc/linux-4.9.y boot: 97 boots: 1 failed,
 86 passed with 10 offline (v4.9.201-179-ge948539072c5)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 97 boots: 1 failed, 86 passed with 10 offline (=
v4.9.201-179-ge948539072c5)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.201-179-ge948539072c5/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.201-179-ge948539072c5/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.201-179-ge948539072c5
Git Commit: e948539072c5ea11d61b15d4536f9202c88736c2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 51 unique boards, 20 SoC families, 14 builds out of 197

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.20=
1-32-gd7f83e4f45e8 - first fail: v4.9.201-180-ga01b8802acde)

    socfpga_defconfig:
        gcc-8:
          socfpga_cyclone5_de0_sockit:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.20=
1-32-gd7f83e4f45e8 - first fail: v4.9.201-180-ga01b8802acde)

Boot Failure Detected:

arm:
    omap2plus_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            juno-r2: 1 offline lab

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            bcm4708-smartrg-sr400ac: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    socfpga_defconfig:
        gcc-8
            socfpga_cyclone5_de0_sockit: 1 offline lab

---
For more info write to <info@kernelci.org>
