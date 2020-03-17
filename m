Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09197188CE3
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 19:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbgCQSMC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 14:12:02 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42274 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbgCQSMB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 14:12:01 -0400
Received: by mail-pf1-f194.google.com with SMTP id x2so12020138pfn.9
        for <stable@vger.kernel.org>; Tue, 17 Mar 2020 11:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gFYr11U9e4zA7TFAgYoiIT16gp96XuW4vT1BltWf5Mc=;
        b=YTz8AQfVjVU7RDPHtilUjll+kmpHKtnugXytFnWyjUxZb6Ox1Ow+w9Q1uF7/I4UHny
         /xalWCMwAJB2y9SeE5qYTxS5cps31yIOWXRs8Ef8h0n03WUFg8qUH4FpJg2iqthncYq4
         c/aUpKgGeeDzqclQ/+uPddKzvYq/Pl560FwkwgrxH7sOY3KlABJkaa8aF9A1cKKYZxvQ
         SkGWaXPVqKsMSg9DUH+YcC2wS2ORVkOR2O+MbhkWAJv5hydd14w9y3nyorGTEEyM8z5I
         OzXM/eq/e7RBRJlCueW1jVT4qlFyPMbUMssf3awGePVID5Wp3pGs6tZBGGV4knZssc0J
         sNbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gFYr11U9e4zA7TFAgYoiIT16gp96XuW4vT1BltWf5Mc=;
        b=KoIQMtb7Na54NdmoiLJICrsIknrXDmEdIKqx7I3Wr54SXRHzZZmoVpDgNSqm+V7pdz
         8ODF502Q0pTwHpIp8phT+0PM3TuIr5jIaxQkxuQTauMdAJt43sZlwDAddxkBUY5DW9sL
         q4UdGBqq1JMQoa8rn/6HxT9ybHEX8tW+DvkafNuvY6BR3To/q3Zb/hIWDUOCjtU0qir3
         UY6Y32rnw5Bpk6iWQeDJ1JD2dd9gnAk9L+82nYdrgeeoDnU5S2BEypxt9X6IfuHDfaP3
         9QYm3AK3AGVgEk0aIDky2LiBvQ9rMD9jcYsyYBEpCEL9vHlEkNRqBvgiyKHZrx249SmE
         WddA==
X-Gm-Message-State: ANhLgQ2nruHdaGNFP7FuRZPWa4Nq6DWUuVOdC9tAs+Nigo9DHWkM6lxR
        qYtpZE7guiBBDa6ZjfKmreo1BJZytGU=
X-Google-Smtp-Source: ADFU+vuP6wV/SzISXak4B85cNPzyyk6dsR5LZzNqDG15kQAm92c/le9bvB/1KTQAv18R6qWhxqYDVQ==
X-Received: by 2002:a62:ce48:: with SMTP id y69mr15792pfg.178.1584468719199;
        Tue, 17 Mar 2020 11:11:59 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g18sm3772074pfh.174.2020.03.17.11.11.57
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2020 11:11:58 -0700 (PDT)
Message-ID: <5e7112ee.1c69fb81.e4d78.d5c8@mx.google.com>
Date:   Tue, 17 Mar 2020 11:11:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.109-92-gad35ac79caef
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 145 boots: 1 failed,
 135 passed with 4 offline, 5 untried/unknown (v4.19.109-92-gad35ac79caef)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 145 boots: 1 failed, 135 passed with 4 offline=
, 5 untried/unknown (v4.19.109-92-gad35ac79caef)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.109-92-gad35ac79caef/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.109-92-gad35ac79caef/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.109-92-gad35ac79caef
Git Commit: ad35ac79caefa8ec9fbaaf4737d87fd7bc0329cd
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 83 unique boards, 22 SoC families, 19 builds out of 206

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 38 days (last pass: v4.19=
.101 - first fail: v4.19.102-96-g0632821fe218)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 4 days (last pass: v4.19.108-87-g=
624c124960e8 - first fail: v4.19.109)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.19.109-91-ga807140c=
a617)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
