Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC6A18A3E
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 15:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbfEINEm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 09:04:42 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]:46141 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbfEINEm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 09:04:42 -0400
Received: by mail-wr1-f47.google.com with SMTP id r7so2322691wrr.13
        for <stable@vger.kernel.org>; Thu, 09 May 2019 06:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jgjdLpyM8EnA/ozc4CWX3LV4Y7xiqB0zLFPPOIGW6OM=;
        b=MED8cC+AXIdm7H1oOPScfzYEoi7ogFafw4gntDVul81rs/l6OHyEf3huZpd2iAat8y
         VNNrhE7minW4VpDY1NuT9ys+Do/oV4EagoxPDLFlHgKVKt0GhVHQWlcoJUodYCNgKhwq
         C6eHTO1rxkD6Tke2wH0X7OPfXICWF2iX0dM74yF/DL3+4pH8EkrdG2xgrrr+lWUkZGxI
         MwXDK/m2/ZmdoEZL9jDrdWKxT/04z0lPpdo8mAEFzP/MWsXNrg7IkdiGQsuARxZgk1bi
         88I+b5DAiax+30gO0b6g2A2te3Fbs4vdaud0tP2P+v6tfqE2Pm3nhC6hiJkVvn5DsHyB
         oLUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jgjdLpyM8EnA/ozc4CWX3LV4Y7xiqB0zLFPPOIGW6OM=;
        b=VDSUM8Xeaw4IgLbvIPysfHCXt0BsPj12E/SMAYYT0Ookq16X7Ki8RvaFQOOwjlasVq
         r6DFc+gm+CUtEKfY+57KuQGPcu7305najdIXzBeWVYjme6piT1YCUQw5wWkZUxALcgcE
         8g8yd+SBsWDiBdyJEwddRxfqU8p+oMH51wRQmIwAImHcGebifdDvBJOhG4FRNCECtW19
         52kYNHdCUBp6bgULaqhYxHmmt86UBTEIY6VAQt8x2UwXKxJYBV+QnOepuFxOeayIETDo
         qLZiJt5cQ8mE/pdaodTRY/VDA5UhML66qhM/wOnpP/ZwEF77b8Z2T7OmmkE2RyKPmc3G
         yPtw==
X-Gm-Message-State: APjAAAVVy4rux92FrlmLju8KetfeRRu+qfhAhsp8d6jPhO8PgiFCMSrS
        bP1j7aZLHAgvmU1zuclLRMddllLtTPKUJA==
X-Google-Smtp-Source: APXvYqzZNHAebJvfvZrE//l/knpt1RXpyF+pucDTbzTFdzOxi9w5dnjUf5lvH3B1I0PKJ+qbXy/NVw==
X-Received: by 2002:adf:dbce:: with SMTP id e14mr3017688wrj.249.1557407080308;
        Thu, 09 May 2019 06:04:40 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f6sm3110527wro.12.2019.05.09.06.04.39
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 06:04:39 -0700 (PDT)
Message-ID: <5cd42567.1c69fb81.8b2c2.f09a@mx.google.com>
Date:   Thu, 09 May 2019 06:04:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.174
Subject: stable-rc/linux-4.9.y boot: 108 boots: 1 failed,
 103 passed with 1 offline, 1 untried/unknown, 2 conflicts (v4.9.174)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 108 boots: 1 failed, 103 passed with 1 offline,=
 1 untried/unknown, 2 conflicts (v4.9.174)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.174/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.174/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.174
Git Commit: d79b8577dfb7d02cada8c6671d39d10c09af891b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 51 unique boards, 22 SoC families, 15 builds out of 196

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v4.9.173-61-g43d95ffd27=
9c)
          omap4-panda:
              lab-baylibre: new failure (last pass: v4.9.173-61-g43d95ffd27=
9c)

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

arm:
    multi_v7_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

    davinci_all_defconfig:
        da850-lcdk:
            lab-baylibre: PASS (gcc-8)
            lab-baylibre-seattle: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
