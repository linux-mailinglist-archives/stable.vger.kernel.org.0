Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0A5518B1C
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 16:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbfEIOCR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 10:02:17 -0400
Received: from mail-wr1-f41.google.com ([209.85.221.41]:44051 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726195AbfEIOCQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 10:02:16 -0400
Received: by mail-wr1-f41.google.com with SMTP id c5so3197140wrs.11
        for <stable@vger.kernel.org>; Thu, 09 May 2019 07:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CxrpZYou4XCaCJ0MVg7cBo4icZVGB6CK7I6b9oDeq/o=;
        b=FEszZoJFvB+18Fomj25c74yYhRPv6YcKNJkztpNtE6JsturRmLvkoTpw/X0hTNyWyR
         bIBCqvIXbPeYieZ1Pzt3Q/MeDe4sqetWjg524tEjsez2zzy1GltCkZPDtr2zkqdxWQGu
         5bkuHq47sL/hNBvsUrh7kHasXKJ+fFKPheIgkHw2ln/sDykxo1nzLRwU3W4XXGu7Hck/
         Ogkzktye6RK+mva/Hf8HhEK4+C2es2xZ1ZY0xCaxw+YU0xXB+uTG7YnrLeg9/5GHwsBS
         eELfs12gsK4iPvQnTB9EayVyaXqU7I1fH+rCzOU5gC3ByrQHDm/RHxwtomUXEj1/i4fw
         YsDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CxrpZYou4XCaCJ0MVg7cBo4icZVGB6CK7I6b9oDeq/o=;
        b=liN5gMuU9bKDGDc0WC1OlyMaxRffp/dWG2DF+hjLB4sqA82f+m2AlmVY/yB1Q1+zP1
         +zYTKwWjNeB1D53Byz+q0rzGPccknBjhBmFNxBnx3rLUnOZB8w49kR36sf+zJwTsDpBv
         8nRA2KT0sMigZuzKPY5r9RZL9Qz9mWn646mx1bMg3QqpoGP0c1vzC6YX+Qeozr1QItfp
         F7igkvAjSFmSKGkxSPxSEM3B8yVfXplEs8OesqHQjI7bU4FueXAvFeqrKFLhdd/BuMyc
         UnV+j8tRFcTGLLAU3xJp84h8/IdJcpHv0nJ4oTW0+sGkqItt1Gu/Y3oQAQ1f0r0BsXok
         zIwQ==
X-Gm-Message-State: APjAAAV4UDeqNcAW34PXjAaS3uYV7QELwbUw4WnvG+ZAIzABpuzdj7UC
        w0u96MLxqYW0WGLr8kV6PnTzdnep8k4Peg==
X-Google-Smtp-Source: APXvYqxGjS7XqJgHDcIH5YHgSjjDmd/RBp7hbeYdG/ZybhPln8dRGALsA2RSTa5itHWj0i3+X3MWMA==
X-Received: by 2002:adf:dc08:: with SMTP id t8mr3159909wri.220.1557410535124;
        Thu, 09 May 2019 07:02:15 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c139sm4117716wmd.26.2019.05.09.07.02.13
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 07:02:14 -0700 (PDT)
Message-ID: <5cd432e6.1c69fb81.2b906.380f@mx.google.com>
Date:   Thu, 09 May 2019 07:02:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.41-56-g487b15502665
Subject: stable-rc/linux-4.19.y boot: 131 boots: 0 failed,
 128 passed with 1 offline, 1 untried/unknown,
 1 conflict (v4.19.41-56-g487b15502665)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 131 boots: 0 failed, 128 passed with 1 offline=
, 1 untried/unknown, 1 conflict (v4.19.41-56-g487b15502665)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.41-56-g487b15502665/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.41-56-g487b15502665/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.41-56-g487b15502665
Git Commit: 487b15502665ed34010b1e79164938fbeba123f0
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 70 unique boards, 25 SoC families, 15 builds out of 206

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: failing since 1 day (last pass: v4.19.40-100-gf=
897c76a347c - first fail: v4.19.41)

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
