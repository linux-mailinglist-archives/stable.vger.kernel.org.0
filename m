Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB17B211E7
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 04:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbfEQCDJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 22:03:09 -0400
Received: from mail-wr1-f54.google.com ([209.85.221.54]:41042 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfEQCDJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 22:03:09 -0400
Received: by mail-wr1-f54.google.com with SMTP id g12so5061459wro.8
        for <stable@vger.kernel.org>; Thu, 16 May 2019 19:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XjonWgcDMdTJGU2Vyt8RXvVKrcMJegoJWm1N7RPNf3Y=;
        b=OjEy7pdXZLapHlQw66ubfagstmE+o2UTz8ApeoEFlhFrFNMJjlNBsNfBFeRF6wfUW3
         /Wso7AdMkgVyh9TOoG96QqTWuO47PphKwshEGTc+1mF7rrgihxW5a6TA7aZqMIWpGsEg
         wpqE0X21kXFZOplbFaG6RmsaNs1/MFMtFxnldM3jXURx70g9yhS0a1M6F1RcvHdq+FUx
         I2tbTZnUxf3Ig4tFH+8POGjuJ7OmUo0lR+a6NofWEeNMv+QT8LKSVQK+6mtm/jkZwGvB
         42F9a+nyvHtxvT0wHx8XOpNh0kMpVQgGoWfY/uXuLMYWIqjQ8QBXCEkntJfwnQRwf6UY
         ZEMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XjonWgcDMdTJGU2Vyt8RXvVKrcMJegoJWm1N7RPNf3Y=;
        b=o/xwwH7XZ2835On5IN86o8Q52B46PxCJa/Y8uEnmZ05VJPv1RzUQQrnpymS+3JRw1M
         PRRg+HbjH12BOafOLzdK8O7DjPA1OdmqAyCi7aIFyl/LNEZftsZIu5MjRxcnQa5t3tcY
         g24mkJR+OQiXA8DzO4UGOlBV8QVD45y4DgogbTFaB6ONNbTW4jRK0qfXG2rDo1sBoxZO
         +2/G9BJRjrC6R6TwiuWbvhizChv0zgFqXE1m9DHrQBNcSUcOIbYJj0sRblKc9GfCujKP
         bV7eujSw8KJdzvHREE+f5D43gaPaMgg5t3NyqtlHtF2sfMb8BIghWCOtQFzv6iD1npgl
         EnxA==
X-Gm-Message-State: APjAAAVpr4oNs7PAfuv5Kt+CZ9iDOk/SCZFya9KTiqWwkX52ouMu8Mkc
        RQauIOMEiI9qhdcq/pc5xBQmB5P187MyBg==
X-Google-Smtp-Source: APXvYqySrE0aME9eeb/f6wmTPwIQA/ZHOSexTOFtYfgHseqGIeQ+655dx22mgNT86syNrf9+hjfvKA==
X-Received: by 2002:adf:ec42:: with SMTP id w2mr31286661wrn.77.1558058587527;
        Thu, 16 May 2019 19:03:07 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x187sm8756749wmb.33.2019.05.16.19.03.06
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 May 2019 19:03:06 -0700 (PDT)
Message-ID: <5cde165a.1c69fb81.fe1a9.3f9b@mx.google.com>
Date:   Thu, 16 May 2019 19:03:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.44
Subject: stable-rc/linux-4.19.y boot: 125 boots: 0 failed,
 123 passed with 1 offline, 1 conflict (v4.19.44)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 125 boots: 0 failed, 123 passed with 1 offline=
, 1 conflict (v4.19.44)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.44/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.44/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.44
Git Commit: dafc674bbcb11c6a5c63b75be5873b118e2add17
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 65 unique boards, 22 SoC families, 14 builds out of 206

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: new failure (last pass: v4.19.43-114-gb5001f5ea=
b58)

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    omap2plus_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
