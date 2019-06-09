Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 182503AC4D
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 00:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729306AbfFIWLq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 18:11:46 -0400
Received: from mail-wm1-f41.google.com ([209.85.128.41]:56011 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfFIWLp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jun 2019 18:11:45 -0400
Received: by mail-wm1-f41.google.com with SMTP id a15so6688190wmj.5
        for <stable@vger.kernel.org>; Sun, 09 Jun 2019 15:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VbwrAx1UuhYUk33Eb6Nh7Ho50cD83TFR3BNTlq7pRds=;
        b=gzWSs4f6nwyTY0i0TKfZbXrmvFpvs50ylRT8mrveL3lYsv9kxrQOnBsNuaSF8qmIlT
         Ie4kH0+Co6Z8VAeGwjkqDmTIAvNYAuhIg9PpbxbLADsbzNbnOLNlHNN7CB2Ivr6+4v9T
         8pA+0BCpSVp/TIyX77F32x5ufpskVIo7kk3o7vUDbYkFlmiqqpRZ5P6mXpFyaHUf93J+
         2ji6YU2qXkW5sZbn3AAgqoWfvwKhaA5B8XQTCErruJO//+sUs3XviIxjFi1T+4lDBv2n
         dwylIGjBMca39UgEJ8isfoPe3WgEX6ZPP/hdHqd5wt8R3kyadOiG4ca+7ugJyz5/BVQD
         xTnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VbwrAx1UuhYUk33Eb6Nh7Ho50cD83TFR3BNTlq7pRds=;
        b=rdw82wMcL4KtO4KenJmBSL2JbZphismLEm3XrfdASFfNDgjeivDx+T9fvo1n/2F0zE
         KrN8XI5zO9oUgwnNmruJ1lMqwCFsmwzeYIDaWsLC8ICLqhJ+xxewnef49Xwgu+uxSSs0
         Ynk+gQWkQUN1+Fcsux+Blb19VYDLNth66CKfO1irNtNZRBx+ku6uYtslm6vIgbTvhuCP
         katEm4kp14cZT7GDabU/WUekBdS2CtKvaFv/uTEltvKnfxSA5DVhHLQ9EYJUauHB5lo/
         pITtfqc/DT193izQzCjNwnSzDyWPoKoz03oMaACDlaoRAItt8a/12TsTxxYHXt4DltkL
         8gfw==
X-Gm-Message-State: APjAAAWfrvhz9CelvI9N+EXHY8g/cLnzMd1fFuHLw2J3qEfSW/fnH8tx
        dFHqqZfL+nSxN9lUsI6p3ef1O/Ntw2M=
X-Google-Smtp-Source: APXvYqwoaNmz+KdspLJDMgiorATixOPUKeySDuD81bCZYms1wjGg0k34l2+7MKmuhjCvkJKKML9shA==
X-Received: by 2002:a1c:2358:: with SMTP id j85mr11534566wmj.46.1560118303527;
        Sun, 09 Jun 2019 15:11:43 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j8sm6709661wrr.64.2019.06.09.15.11.42
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Jun 2019 15:11:43 -0700 (PDT)
Message-ID: <5cfd841f.1c69fb81.230a7.6926@mx.google.com>
Date:   Sun, 09 Jun 2019 15:11:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.180-242-gc9c6a085b72e
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y boot: 94 boots: 1 failed,
 92 passed with 1 conflict (v4.4.180-242-gc9c6a085b72e)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 94 boots: 1 failed, 92 passed with 1 conflict (=
v4.4.180-242-gc9c6a085b72e)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.180-242-gc9c6a085b72e/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.180-242-gc9c6a085b72e/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.180-242-gc9c6a085b72e
Git Commit: c9c6a085b72ef62ce2cdcfbee79476ad2bdbd703
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 44 unique boards, 20 SoC families, 14 builds out of 190

Boot Regressions Detected:

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu:
              lab-baylibre: new failure (last pass: v4.4.180-230-g17950b5be=
27c)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-drue: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)
            lab-mhart: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
