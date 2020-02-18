Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62A5D16226C
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 09:34:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbgBRIeN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 03:34:13 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35310 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbgBRIeN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Feb 2020 03:34:13 -0500
Received: by mail-wm1-f67.google.com with SMTP id b17so1885070wmb.0
        for <stable@vger.kernel.org>; Tue, 18 Feb 2020 00:34:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cyde3N6lZ2s94EYqEiSy1L/xZus5211mUCKG5MTS0YQ=;
        b=k9WEJGnzlJoXwRSTZFAILp0l5e+L0wq91Oaf7uzC/wFRqO89Glat2kljZzSrzke4Vn
         x1SrVVTB7q2epmmQaBQ+Z7nYYYRg3t/PUBmV3vEM4lABubyJ2mLbPkxvnJXy1ETRLwIL
         29/+pdy1QPtf9sidhN3KJyp5v2HHebazdA/fr37NfsC2uxvYNXDA0ubLybscZEY6Msdt
         qNMRaHPdg6l5QE6fe9UVGK6/a+mQYxsk4wXe2M8MNtOw8/+WRZcvB0FRQpOktrH5G+qd
         Ljedcwg7h1oUmlPRdCwfbPLbiOZ9rcgPqRo+4ieP7F8yViOu2jE8/rS/X7X42C/yM6aj
         O0jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cyde3N6lZ2s94EYqEiSy1L/xZus5211mUCKG5MTS0YQ=;
        b=PDqDLUY4cfveTyx101HmxVbjKL30fHwvHZmlha7t4ZVaDIwFs1Pcq3EQ+eIJIser1a
         e902csuX+5Vpqn7rXafhUqWeIdD1xZqbb5/7kx8873IIvKDmpuEqgkj7+Ei5X2P1fUXR
         IRMfZTWpeuUyIPe+zaxSpHl7kbk85Vki9J6oedJ+8enkb7CUYIc6Lt4JzeObIt/Ohfap
         Vx80KdJGM9ketDHEpUFTNd2PHAL4esXleCEOpraoCzGmtJWpVNgieqLSkUIvDnoe26SM
         BiJenkOl1qM8+MC7dqauOCgQTkDeqOBCILzXLQ5TE1SDIZgm8M5CZsm2EzLMU6KDPXMk
         mKTg==
X-Gm-Message-State: APjAAAX2+eUCwZTjXV0l4WLXe0N9DtZa9521P/N3vNniw5kjx8pHP++/
        NUJpCE+RAmHkW1M48HATSFLdgR+KYLiq2Q==
X-Google-Smtp-Source: APXvYqw/AE3rvgXQLdCQRFsIbkdj6WqFmkz8UrdjlI2jDnzRPjhFSLYBcVNFg+YXSDSFr0O+/prntQ==
X-Received: by 2002:a1c:3803:: with SMTP id f3mr1798648wma.134.1582014851365;
        Tue, 18 Feb 2020 00:34:11 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id d4sm4879038wra.14.2020.02.18.00.34.10
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 00:34:10 -0800 (PST)
Message-ID: <5e4ba182.1c69fb81.3c2fb.482a@mx.google.com>
Date:   Tue, 18 Feb 2020 00:34:10 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.9.214
Subject: stable/linux-4.9.y boot: 43 boots: 1 failed,
 41 passed with 1 untried/unknown (v4.9.214)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y boot: 43 boots: 1 failed, 41 passed with 1 untried/unkno=
wn (v4.9.214)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.214/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.214/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.214
Git Commit: 7ce439266f602f60f05dccf964a8685e53684a9a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 29 unique boards, 15 SoC families, 7 builds out of 136

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v4.9.211)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.9.212)

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

---
For more info write to <info@kernelci.org>
