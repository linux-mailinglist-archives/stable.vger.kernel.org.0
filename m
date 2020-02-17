Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43239161D22
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 23:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbgBQWFh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 17:05:37 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51200 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbgBQWFh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 17:05:37 -0500
Received: by mail-wm1-f65.google.com with SMTP id t23so819835wmi.1
        for <stable@vger.kernel.org>; Mon, 17 Feb 2020 14:05:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KRNnX2Dy3vQ3TR9v80qEceBA+qaWokupetsg3pUgtiI=;
        b=z6oNJ4nUdayzKbC7OF0Glo+X7BOMjvHBO1qdA2q+tACrNi0GuZpOo/B6xOKgceBJY4
         EEYKBjNV+Wh+Pjc3Ys7f5B+4yzdFI7uq38Aep8sAOn/mUUmqgGXoH3smf+KmUAyEllIC
         NekVmBqZOK9hXAPxW1j95BnjuxcG+bvsr/CRYrZPD+5lvI6D1ols0IsjMq3yHEsNc4Ug
         MsPP07+akQVqYknEed4vOTTffP7rfFDtZeIpiYr8axG2Gxlkho6EcS4uQPKcvCCST7fP
         4wf0uPrV55J5usk28SJz8vV46r1aSVECPo4xlce0rNIlM1gUfL8YQUSfe3PaM0Y9Tb9q
         jXxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KRNnX2Dy3vQ3TR9v80qEceBA+qaWokupetsg3pUgtiI=;
        b=fTqT1Oa0I/61BdMV6hGoHBQOhUZPADcdjzEjgDP2uqsKPbNzFkoo6mk3vVWhq9cMWe
         VtDrElzypkCVMrYBGMZ4K2/tVVMy2716zh+NCBmtAMJEry0cUDis7Zmw7bMKVnjuo4UO
         2LNGhBGYspwM3gJZFQn6PuEvEWtbGFB+otQVKhIhUKSSjTn/u8NYFvKk5LP48sfO7z6N
         2n8T4RD2wNbIhGmtDm/QF/S+6ICDOaPDyXrEqzreaHUpsLCu8C8uOgphwOqdxQ32whUC
         jsN/6ndauemp6Y5yJGa/d+NlMOj8ZdKGPIJl5VvPo1e2M1a5TnWlbXKvmya6dHpSNhRK
         RiAA==
X-Gm-Message-State: APjAAAU8JhzOLu2mmdp/d52SYVgdN4Dkpq+1yxrVWBWI7n738c0CvBQ5
        HlP528eWB7mmpHFefwIT4IG+8+MoZptefw==
X-Google-Smtp-Source: APXvYqzekBAAo4O1ycw9BOCrhcNgbeplL88PZJtw61PsULhrH+C9fso1JrypJPu7L2B1zORzv4hTng==
X-Received: by 2002:a1c:451:: with SMTP id 78mr935555wme.125.1581977134951;
        Mon, 17 Feb 2020 14:05:34 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id u4sm2978495wrt.37.2020.02.17.14.05.34
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 14:05:34 -0800 (PST)
Message-ID: <5e4b0e2e.1c69fb81.e2d26.eab0@mx.google.com>
Date:   Mon, 17 Feb 2020 14:05:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.214
Subject: stable-rc/linux-4.4.y boot: 13 boots: 0 failed,
 11 passed with 2 offline (v4.4.214)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 13 boots: 0 failed, 11 passed with 2 offline (v=
4.4.214)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.214/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.214/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.214
Git Commit: 76e5c6fd6d163f1aa63969cc982e79be1fee87a7
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 13 unique boards, 5 SoC families, 7 builds out of 106

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 9 days (last pass: v4.4.2=
12-56-g758a39807529 - first fail: v4.4.213-28-ga3b43e6eae91)

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    imx_v6_v7_defconfig:
        gcc-8
            imx6dl-wandboard_dual: 1 offline lab

---
For more info write to <info@kernelci.org>
