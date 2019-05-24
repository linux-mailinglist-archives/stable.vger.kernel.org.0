Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7982228F4D
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 04:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731721AbfEXCzl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 22:55:41 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:42603 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731551AbfEXCzl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 22:55:41 -0400
Received: by mail-wr1-f45.google.com with SMTP id l2so8309646wrb.9
        for <stable@vger.kernel.org>; Thu, 23 May 2019 19:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hWBioqGdAhicwfVnDJ7CU+jAbGNSq11bdhgnot7t3fc=;
        b=OaKn632/h2YNKoTZbgvqQlJ3my0XkR+5VF9K2O3KbLRBPJAzh8+ElksHiCg8ZDCjAt
         mlRHdSl+icvunkNl6ENk7ix8WL3Bb2ZHH63YDEVzJ1G576W+LhPOJ2a6TyoTGkiiw9Vc
         XDHruw/ejE2boQaXteAfr+5BdWCII/h1jWOmhIgqEx+Q+HmJ6OiE8xzqJq+JUSbvcyLf
         UkIz2VxJC8ZrzRAwzd49oYvmb24d5pNdELwVJ/6w++XbaC3PimUgkXD5O1VgC9PWXbc/
         MDnnPyl0IQehUVpNhzqmpbMLGDlS1pJVb1r2MNHhZN2aJsKywWblZB8GwcQdfRHqfdy0
         rP5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hWBioqGdAhicwfVnDJ7CU+jAbGNSq11bdhgnot7t3fc=;
        b=dM54xWsrxu7oTfY3KnexMcky/FNIP75PiKkFBUJQbFxwYZTcJnGFLeFn1BSsZs6Xa3
         Mo87Wg87f981LIX0JbHVy2dom78w1brJktnYmgEYPigZttmmIesjYs+ru0X+DlmP4dVK
         aBqQshVQkCareZLc3TQzaN8dog+ZN4LJx4jwzUNpwe3KuBOoBRwMuw/EW0Nq0GfdNyCw
         EQuYfFp75qgDHUkAh7Omqi0kz8Z7zjNRgvmhNg4XRN6gOcsXq5bqZxnQLPuS3RGV47vx
         RVf27Q6lnsQZNaHG9zXUoSgmv0RFfnfM6P6fynViImcsaruTp3WE3Vbjq5audj5ns17N
         vBnw==
X-Gm-Message-State: APjAAAW32RV+B25gtGLEM6V6quFz4FtZ3EXwGn7iESUqbQYljd9wPeuM
        h2+2Czomxt4EyE+SG0AzwxFNt5MSIB9d6w==
X-Google-Smtp-Source: APXvYqx09LKfwRGpvmFk4spyNRRY86ndU/URtbmFoLHXwI/9CjP9DCtW/1fbHWr580epO3pHP6kW8g==
X-Received: by 2002:a5d:6243:: with SMTP id m3mr8485807wrv.41.1558666539269;
        Thu, 23 May 2019 19:55:39 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t19sm970846wmi.42.2019.05.23.19.55.38
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 19:55:38 -0700 (PDT)
Message-ID: <5ce75d2a.1c69fb81.db3e6.4fcb@mx.google.com>
Date:   Thu, 23 May 2019 19:55:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.0.y
X-Kernelci-Kernel: v5.0.18-140-gc7802929531b
Subject: stable-rc/linux-5.0.y boot: 133 boots: 0 failed,
 118 passed with 14 offline, 1 untried/unknown (v5.0.18-140-gc7802929531b)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.0.y boot: 133 boots: 0 failed, 118 passed with 14 offline=
, 1 untried/unknown (v5.0.18-140-gc7802929531b)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.0.y/kernel/v5.0.18-140-gc7802929531b/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.0.y=
/kernel/v5.0.18-140-gc7802929531b/

Tree: stable-rc
Branch: linux-5.0.y
Git Describe: v5.0.18-140-gc7802929531b
Git Commit: c7802929531b3fd886283d78a4f91f1e522cbdf2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 74 unique boards, 24 SoC families, 14 builds out of 208

Offline Platforms:

arm:

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab
            at91-sama5d4ek: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            at91-sama5d4ek: 1 offline lab
            stih410-b2120: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            tegra124-jetson-tk1: 1 offline lab

    tegra_defconfig:
        gcc-8
            tegra124-jetson-tk1: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            mt7622-rfb1: 1 offline lab

---
For more info write to <info@kernelci.org>
