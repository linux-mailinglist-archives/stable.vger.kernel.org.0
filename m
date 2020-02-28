Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31FD4172EDA
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 03:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730439AbgB1CdZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 21:33:25 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46531 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726943AbgB1CdZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 21:33:25 -0500
Received: by mail-pf1-f194.google.com with SMTP id o24so868970pfp.13
        for <stable@vger.kernel.org>; Thu, 27 Feb 2020 18:33:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Jcvw+cyKq0kFfPdUUN7DDjJp3R9uCeskGyuGNIwGAMg=;
        b=TWSL1ZzGbeFMpLmkFehEyg2vaOdNZPS/8mb6bxpCB86yMBgeOFU6P9RvK+yHmjXVUW
         RrV06NFFpq9PqCsOcWkWFA1GD+nNcsMXtl0n9sYPTvch1Xc733RIuZyQLMyeE+K5paof
         xnXe6Y108JFu8n97LvLX5pSES/h/rEAbLdjFAf0sBxfHJSo6R7FOxxqamy5sWidXXJhM
         AV5VukMuf66PlLzNTcJhc/q5WBsi/ome0o4QQijZLEu2sf2V2rCPYxh3US+2LQJAH7Kc
         PGaPjSNkzefBLav38nObYx4R0nV3Gd6k4UQXTe12PZN4dVFUqNitvHD/9kosIFzebTL4
         WzFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Jcvw+cyKq0kFfPdUUN7DDjJp3R9uCeskGyuGNIwGAMg=;
        b=sSNC7zJzWrwtunxTt1dgT2XELxExlJ5KHar2H+qirOSJCHw4pzNeWXS7K4NiSXeYeG
         rA2jqyBZ9+rcBmLXCBfVclsIVHSb9KiGHfPHDNSE6X9kKoh0R4I10ro31nwNjgBsmLJv
         d9/Kytq7zriM2yjPiSl5wFjSFMnOa+k4+8qRlqKnTlBLT/xowPqeWt3f1YOHzj6O49t7
         G1VuxYqDOiKE9XDxxtSGvN0rFu2F+3ff7kbNll30iUHbkComlAjQdmIOLDbGbQ5SsOur
         NHe4A/37tdkR6Chf7ltHEO2fyQLGO3q4ePbo4rWA4NwvX0kvO8/Sd/0bW7fk/houLbzN
         AkWg==
X-Gm-Message-State: APjAAAU9CspiJ6opX52rkRg+DKDo3BiESEPtkdIIc1pJffq4jCDVBKO1
        7qPD2i5kTj7hvisBgZSExSAaBEHO9iU=
X-Google-Smtp-Source: APXvYqxZCBFTJIA4VIuuXV5vwNV6i9mWGsUTcCviY88lkmPj9dFRFcuSSvC2HhR79kG65jVeDvH2/w==
X-Received: by 2002:a65:4bc7:: with SMTP id p7mr2467850pgr.204.1582857203686;
        Thu, 27 Feb 2020 18:33:23 -0800 (PST)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o6sm9220080pfg.180.2020.02.27.18.33.22
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 18:33:22 -0800 (PST)
Message-ID: <5e587bf2.1c69fb81.2a29.8eb8@mx.google.com>
Date:   Thu, 27 Feb 2020 18:33:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.214-114-g68572b1fc85a
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 53 boots: 2 failed,
 50 passed with 1 conflict (v4.4.214-114-g68572b1fc85a)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 53 boots: 2 failed, 50 passed with 1 conflict (=
v4.4.214-114-g68572b1fc85a)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.214-114-g68572b1fc85a/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.214-114-g68572b1fc85a/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.214-114-g68572b1fc85a
Git Commit: 68572b1fc85aad5f46827fabaefbc6aaaa1f92be
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 26 unique boards, 11 SoC families, 10 builds out of 190

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v4.4.214)

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu_x86_64:
              lab-collabora: new failure (last pass: v4.4.214)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
