Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B73B741AD
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 00:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729579AbfGXWsJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 18:48:09 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37171 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727498AbfGXWsJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 18:48:09 -0400
Received: by mail-wm1-f67.google.com with SMTP id f17so42956039wme.2
        for <stable@vger.kernel.org>; Wed, 24 Jul 2019 15:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UfZy49/B9rbS8h7ed+p9jIYgC2BxNXVvPg17QcKxhKw=;
        b=sLrVRRMKxxuhHNxwD181YybqM8eko42vG1qd2Hi66IABTs9ZAn97UFYN/HHICTyUUH
         JO+KX7NTPOiKequsB3IAPwt9ARveIpYYSBxPDSuKC71XidvRmpxFILKVvOF2s0tz7Gqq
         xzQUgXGRy3T4s6vhx249n603ZYWZyd9vjdJIUMj5AdROICRTcBlonNNfz3f8//Ok3YFs
         RU7YRo//f2LeACnKzdhPVN9SXnONyKO3npxFtET2iKHM8fBVewB9VvoL76L2FeWbW+jB
         AlY3elX+Qs/rNa9yp8V5HYkQTArOcIxB78t0d1LHspXgoV8+BuphAh/qWfq1kWFGCKUa
         d7mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UfZy49/B9rbS8h7ed+p9jIYgC2BxNXVvPg17QcKxhKw=;
        b=M9fpLVdjubRtBTjpCcvVxCrF6KZFgh/TE+xRXeu10sDrDkZSP2mTo7u5i7mJ6Bg7Ls
         VX4nQmKnHT//XvO8APwBxEbd2g5879Stss6zqoOHv5nutZignQcVaHblIN81PCvxH713
         rxWNj89i4gelaX3aftYJZfZufNn5x1Bgq3wbEWVNe7SU2PTQho/pVqDfbFLx4gK96o/e
         YQ8UKdVfXTU2349CUDze/IEKQD9Z1u5wIC6qjy242kgfIHZMgYaPlfprmarrgfxFaM3f
         Wktd0T8y0ivaBC/9HDxi9Uf7cCALpT2QAOnqtEgExyXZASryjtAUyQdNfW0EzWock2Nk
         mQAQ==
X-Gm-Message-State: APjAAAVoU7RVxOw29/LX1XrwHEwMJtRWtXeiFpouIPY10VaZSVxMhzla
        +6VK4ekLazZiojp7gBTeodF+VZRvfUc=
X-Google-Smtp-Source: APXvYqymKKMkbPlZISgc3HBrEdi9+1tY+gUTA0X+JWGVe+7ThMMpKglVewG19EmozKnA9qOiFyXMSA==
X-Received: by 2002:a1c:f90f:: with SMTP id x15mr73939215wmh.69.1564008486790;
        Wed, 24 Jul 2019 15:48:06 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id h16sm48346563wrv.88.2019.07.24.15.48.05
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 15:48:05 -0700 (PDT)
Message-ID: <5d38e025.1c69fb81.12b6b.e216@mx.google.com>
Date:   Wed, 24 Jul 2019 15:48:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.2-414-ga4059e390eb8
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.2.y
Subject: stable-rc/linux-5.2.y boot: 139 boots: 1 failed,
 136 passed with 1 offline, 1 untried/unknown (v5.2.2-414-ga4059e390eb8)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 139 boots: 1 failed, 136 passed with 1 offline,=
 1 untried/unknown (v5.2.2-414-ga4059e390eb8)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.2-414-ga4059e390eb8/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.2-414-ga4059e390eb8/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.2-414-ga4059e390eb8
Git Commit: a4059e390eb842ee95dcb0b856eee5cc422a815b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 81 unique boards, 28 SoC families, 17 builds out of 209

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905x-nexbox-a95x: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-gxbb-odroidc2: 1 offline lab

---
For more info write to <info@kernelci.org>
