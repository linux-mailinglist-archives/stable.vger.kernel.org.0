Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C17C2127E
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 05:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbfEQD13 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 23:27:29 -0400
Received: from mail-wm1-f52.google.com ([209.85.128.52]:34302 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbfEQD13 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 23:27:29 -0400
Received: by mail-wm1-f52.google.com with SMTP id j187so8325082wma.1
        for <stable@vger.kernel.org>; Thu, 16 May 2019 20:27:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JzTa8ReDtcxs4Zb5dSIjUik8M2C1zmrnU6PTKaCeeo8=;
        b=dvHIgX8xXWAVb85XAYs5hXMDCfEaqxRB0c5GzPZKDWWYSFa4Bh8ZmCSDgH/aqT6XHz
         7saPRSmg7Gs00sUQfmyLBXgETfClUbadM2tMbORyPgiMYf4lgVVal7mAtjgZ9FLQeUow
         gna0clFSTmbC+d+qv2JP9EFnoj3WKA3LKALS/fVM6GZMTkzgR3P83Xwm8uQ2ltFKRVec
         1+YzHECKfvCEBsGivAJDMIV3veP4M9J4hiQ9AKPJU8MkTLsC5oYDndpU80tOqgdqGr75
         XNDgAgB9rE5Oql9A7RyqU2iYUfZEtRGDDEA1UKDwKzj94jeLWJEgRVmt/QZMkwBvLQOq
         GZpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JzTa8ReDtcxs4Zb5dSIjUik8M2C1zmrnU6PTKaCeeo8=;
        b=HI8Bv8Flle5xTRf9CrbewtQ8lJx/p0EqQ8Q6uTuTEORrkViOQHxCy9U450DeJHkmQh
         lcbNrjnHtdC5kEq12rU8jkAmBoFHAy10O97a7xWCN+LKNJyYS5zPsI5ZNq4/i+1xGbAh
         Qke66rVeLyExl5MQpBosQZjjMlHHnLOzCcFoKxjZdUBmM9rggoGlXK2sFTYuEH6sbNZz
         8D7VVqTKYRsoDdcjs1/bHd89IyMHy9Tb0NTmlHdHVSH1Dlll4IzohSS5NafCev02WakA
         vQTRcONFWSUZeaapZvdBekshY6bvr6gwS57WIIwbb6O4aAuezkhWC4eStet92dbnjGcy
         QCgg==
X-Gm-Message-State: APjAAAVkm5u7tjCrepWjlwEJjnOKNmzHSCGxikIjPNU+N3B0T4TCZ6y5
        RovE3HSH+wH5cwDZBSuRItzPFOtemdVKbg==
X-Google-Smtp-Source: APXvYqyaiTa1/L6ZcGeGCtt0H1PB1ykxXMJec8nUHO5RpOXwxJyLXbnse+snnUoNH6woYWB2sFSqxA==
X-Received: by 2002:a1c:b4d4:: with SMTP id d203mr28623345wmf.34.1558063647034;
        Thu, 16 May 2019 20:27:27 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n2sm10675362wra.89.2019.05.16.20.27.25
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 May 2019 20:27:25 -0700 (PDT)
Message-ID: <5cde2a1d.1c69fb81.6d399.e310@mx.google.com>
Date:   Thu, 16 May 2019 20:27:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.120
Subject: stable-rc/linux-4.14.y boot: 122 boots: 1 failed,
 116 passed with 3 offline, 1 untried/unknown, 1 conflict (v4.14.120)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 122 boots: 1 failed, 116 passed with 3 offline=
, 1 untried/unknown, 1 conflict (v4.14.120)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.120/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.120/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.120
Git Commit: e6fedb8802c7543852cc6b06d8c009f89b3af3d8
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 61 unique boards, 22 SoC families, 14 builds out of 201

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: new failure (last pass: v4.14.119)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

Offline Platforms:

arm:

    tegra_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab
            tegra20-iris-512: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    multi_v7_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
