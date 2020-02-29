Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9521747ED
	for <lists+stable@lfdr.de>; Sat, 29 Feb 2020 17:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbgB2QQA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Feb 2020 11:16:00 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33157 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727146AbgB2QQA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Feb 2020 11:16:00 -0500
Received: by mail-pf1-f194.google.com with SMTP id n7so3355809pfn.0
        for <stable@vger.kernel.org>; Sat, 29 Feb 2020 08:15:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WtcINlSLLsrsb95kFZuH8LDrkXAEZPpnqBUGR50LncQ=;
        b=smCDZAxWm5B5k8piQ+Dxy7k84XModZ/hXiKoWm5TnvhjAE9VBlbMiiOW5y0uUF3x1F
         6aLabHV4rOHD3RLV4iBsV/H8ahd2GnfOMTwRUrG5yTlmUgoyTus8GP4Cg0c5GbWIqjyL
         JpRCMCvaVTpH39VqZrQomPZ1q3dNuKUz7isJ4N5hyWn+VQxckTKnRypvFBpUtN9rctV5
         ieVqPm+jHTA2csyEjJ+QkuyD9tsFfYR7QQotRgGYCnLUQQ0N9P5zIe4YkFcksDf0SPtG
         wGQ+hSHvHIMF40uQpovwU4vj6XmGgSCM3hlxwawAOiIGO/KPEhRsN1B/8Wl1Lw50JQpT
         suSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WtcINlSLLsrsb95kFZuH8LDrkXAEZPpnqBUGR50LncQ=;
        b=LmyBjR0/NHQN1AIGb+0eqL0iKyI1/H1U5/c75O1ZsQR0PZpKg/ijGM2erXHwHMx8rr
         UHvfzLkwORsITWQ4+p9iWgD3bDiPG7+z1RV+/a0hjRq/aKIuhXaxQaaKQmXNmN/AuNzQ
         pI6VxhCuuL0Ry7lVu3NBzO0WYDHp2xhWrHe1ND7OTktqq1g2YcPvqJtXkSEx8QHpc5zh
         BBliVTTycUFXKCxhALMMxqWvlDXumh1fMxDZg48y4breJSf0bQihadx5aTHjY4AuAHGw
         EbLBXHdsLpbYnhshl1qAk5SO+/tyB73sHGxUNYO+QBimTUewpUuLZb+YqDtIopN5ZMIc
         neuA==
X-Gm-Message-State: APjAAAWZSl3lgTWWTbcnxhJAePJbyrxgyZ4becTmOdPUq3bvpilEw0Yo
        9+GAbKXG1qO0TiPlkZhqgF+W3+XjGUU=
X-Google-Smtp-Source: APXvYqynE0V33bWjxskgM8rVgKdG/leNx1akfrZlNopr19MRdnbImmMe2/9N8jUWXV5C5Ac0cCJoMQ==
X-Received: by 2002:a63:214e:: with SMTP id s14mr10151418pgm.428.1582992956035;
        Sat, 29 Feb 2020 08:15:56 -0800 (PST)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 1sm11310967pff.11.2020.02.29.08.15.55
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Feb 2020 08:15:55 -0800 (PST)
Message-ID: <5e5a8e3b.1c69fb81.9643.e234@mx.google.com>
Date:   Sat, 29 Feb 2020 08:15:55 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.23
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
Subject: stable/linux-5.4.y boot: 53 boots: 3 failed,
 49 passed with 1 untried/unknown (v5.4.23)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y boot: 53 boots: 3 failed, 49 passed with 1 untried/unkno=
wn (v5.4.23)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
4.y/kernel/v5.4.23/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.4.y/ke=
rnel/v5.4.23/

Tree: stable
Branch: linux-5.4.y
Git Describe: v5.4.23
Git Commit: bfe3046ecafdd71ba6932deebe2eb357048b7bfc
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 52 unique boards, 14 SoC families, 13 builds out of 200

Boot Regressions Detected:

arm:

    sunxi_defconfig:
        gcc-8:
          sun8i-h2-plus-orangepi-r1:
              lab-baylibre: new failure (last pass: v5.4.22)

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s805x-p241:
              lab-baylibre: new failure (last pass: v5.4.22)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s805x-p241: 1 failed lab
            msm8998-mtp: 1 failed lab

---
For more info write to <info@kernelci.org>
