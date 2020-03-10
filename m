Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4749B17EF75
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 04:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbgCJDue (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 23:50:34 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:45024 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbgCJDue (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Mar 2020 23:50:34 -0400
Received: by mail-pl1-f196.google.com with SMTP id d9so4865505plo.11
        for <stable@vger.kernel.org>; Mon, 09 Mar 2020 20:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UiMhl8OnicFEpUcwwKqADN3wR7kUB4syei7Opl8RBG0=;
        b=ercDQoS2AA34vMTp/1esC2bTYnYBLZ/i5CE+5NnJS3CSjhUmri1mBkBr4IjIoNw66b
         n+4nZl5fOY0DADx31GoZZTIjMvJVm+ZlTNQODwuncTHvkgz+7jdh0rT6bvHQMcGOj5n+
         QsTGqetVTL+3X/EH8kMkp+WUqGGleQtcT1WgEki2rbiqCVAlKtG9qn56noe/yxUz1GU4
         RUa1yE+XcHBUpW2IKDNvGomMfb98dSF7CkGLIFzv+RlYvUd1n+BGFfq43RSrkgMx/2ND
         NIy7r8UUlZ21v8uqxus/gaJCS3LO7R5a6tLetwl5dzv+679TKaiHvNObxeLC8SwxIpOn
         RTDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UiMhl8OnicFEpUcwwKqADN3wR7kUB4syei7Opl8RBG0=;
        b=O/0EYNDL4ySpJFPdkG1tGg9jP1KQCQfcE20b43PO83ccaoVm+UjyrfJRMuOHXF+im/
         2X9L38mVvyR4RTP4whau1kdgwx7xoFGsoa8xYqo4FsvuXFr7mVQDIfFlZULcEOFTyRkB
         w7E0ggUXihymB8Wwc6tnZ4PAAD3VEPodSMDK301ukgzzQ+uLH0Qst8nuP1UqEOLgHbI2
         ytnzbC50ManB7HxgQQiwKn0aFw4nNUZCAfaQtpIgLMc0vkcZIHRBP9RvZwyAm+tonyXu
         oYKaTkIUbyjfLrjwBxd2HBG2VIaDgGBJ2gzQeHxvNFASefGvihkWZL3G2igk2P8Pyz8o
         3dbQ==
X-Gm-Message-State: ANhLgQ17vm0Lc1ocX/GPisOQ3XIwlA2kv5jNwmCZh3sJ4tMwJZ/a+Kwd
        CaoqmsMZTqDSgeBapSJ8PgNfdtv7JEk=
X-Google-Smtp-Source: ADFU+vuy/UnFd0ZNGt46/icZCi5BrrER/j84FMe2oXceEpuluoisPvqV7pKCF+HFVl7DhcXQBj5C7g==
X-Received: by 2002:a17:90a:368f:: with SMTP id t15mr2761764pjb.23.1583812231355;
        Mon, 09 Mar 2020 20:50:31 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h2sm44822135pgv.40.2020.03.09.20.50.29
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 20:50:30 -0700 (PDT)
Message-ID: <5e670e86.1c69fb81.a1d64.9722@mx.google.com>
Date:   Mon, 09 Mar 2020 20:50:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.215-78-g55f9f667f78e
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.9.y boot: 56 boots: 2 failed,
 52 passed with 1 offline, 1 untried/unknown (v4.9.215-78-g55f9f667f78e)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 56 boots: 2 failed, 52 passed with 1 offline, 1=
 untried/unknown (v4.9.215-78-g55f9f667f78e)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.215-78-g55f9f667f78e/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.215-78-g55f9f667f78e/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.215-78-g55f9f667f78e
Git Commit: 55f9f667f78e4ff76536a5582e0d1a15b5ffbd29
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 45 unique boards, 15 SoC families, 16 builds out of 196

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 30 days (last pass: v4.9.=
213 - first fail: v4.9.213-37-g860ec95da9ad)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: failing since 25 days (last pass: v4.9.=
213-96-gdf211f742718 - first fail: v4.9.213-117-g41f2460abb3e)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
