Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3E9749730
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 03:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbfFRB4Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 21:56:24 -0400
Received: from mail-wr1-f41.google.com ([209.85.221.41]:39208 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbfFRB4X (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jun 2019 21:56:23 -0400
Received: by mail-wr1-f41.google.com with SMTP id x4so12064787wrt.6
        for <stable@vger.kernel.org>; Mon, 17 Jun 2019 18:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0HepCJwDYsm0Shu2CNf2eE/kc71TZil5tCl+GGac7oY=;
        b=Zwk3nY1XN2CUfOX0TNowC02g3/SkG7LT1L35se5o3V5UD0zDWxbxjE8Ueo4vkUIhi+
         8/4gJJhn7dE9oWTEpP8mEO5idlhr/zJqUtbauw8l1ZrHjLkdzFs/Z6N/pa3rHDY+dK+c
         1aBD7O2psmMt4BSlP5Tkl0nUt8uOwfNT+hLuYF9DWrlttLBLm80jHW48BGqHVDbBil0T
         bf0yB5EWalU8MfxU+0mscG1zOIg+CyesdeeFlKIhjpGf0VbCq3F4l0+lHQ4jQN0mtRf7
         90YmjsmcZlx+M6dpdszOTNsXU9RCf41Ga70XrFxR/jBv9oxr4tbo6MHXe5ukm/WwY6RS
         +hBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0HepCJwDYsm0Shu2CNf2eE/kc71TZil5tCl+GGac7oY=;
        b=NDg7Vv1Ql+jf6ImVCll0KHP2Pgiv1toHz4/ssg/ORNIntyKlCegXl54c+wiJL5G8//
         B+RxU4J1wtAFmruUCDyZJp5qeh8dnRM14nVtxBN6X8Gm6IkkM9raE+UE+SsUpXAYaua1
         aYYFWYKKvaJy7g3ASzHX7tHMQU6hpC+8ZxhY+ANFJiQirgcu3ksKCzWr1lveNEOWkxRF
         +61USkfWCZTgdRWoCVFBiK1rc6kQFEWE3Hbz6j/cJ2CNknCy9KSObMHrrjqGSB8L0YmD
         pwyMFlt+XGrJTI+HMGTnZ+RWh1sBOmuZ6lnqfmRgZRsoQYIJRKsvXwO4EgO8EjuQdWYs
         o7Sg==
X-Gm-Message-State: APjAAAWvf93rvm9mADgN0sv+jnSCkSXEGgzAt5rfr8ll9qVEMQi/Ldes
        cilqvqgqEc1VNs0GyClvmzWunz34TLtOyA==
X-Google-Smtp-Source: APXvYqzSZOKVzdTx9VDbZUsrUS7JjDjKu9kh4MRZPKFJqeia+Q1XCE42RuzpOuk1YBSsv3u4voXe1w==
X-Received: by 2002:adf:fb0b:: with SMTP id c11mr31473032wrr.56.1560822981716;
        Mon, 17 Jun 2019 18:56:21 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o13sm25553147wra.92.2019.06.17.18.56.20
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 18:56:21 -0700 (PDT)
Message-ID: <5d0844c5.1c69fb81.6464b.bec3@mx.google.com>
Date:   Mon, 17 Jun 2019 18:56:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.52-76-ge7db76b325b2
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 110 boots: 1 failed,
 109 passed (v4.19.52-76-ge7db76b325b2)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 110 boots: 1 failed, 109 passed (v4.19.52-76-g=
e7db76b325b2)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.52-76-ge7db76b325b2/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.52-76-ge7db76b325b2/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.52-76-ge7db76b325b2
Git Commit: e7db76b325b2967d1db43452cac4b11c0a37bcbf
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 64 unique boards, 24 SoC families, 15 builds out of 206

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-gxm-khadas-vim2:
              lab-baylibre: new failure (last pass: v4.19.52)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-khadas-vim2: 1 failed lab

---
For more info write to <info@kernelci.org>
