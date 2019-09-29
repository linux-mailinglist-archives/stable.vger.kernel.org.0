Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBC2C1908
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 20:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729098AbfI2S6j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 14:58:39 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51189 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729096AbfI2S6j (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Sep 2019 14:58:39 -0400
Received: by mail-wm1-f68.google.com with SMTP id 5so10905845wmg.0
        for <stable@vger.kernel.org>; Sun, 29 Sep 2019 11:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dq1noghuki3s05Ms2hjQ2tq/heCYmToBu8e3a/R//7k=;
        b=RZnQLCVmb/4tjx4y24ArwoC464miRbP3uW4W8j/j0U/9ok/qFCJacNEZvlqOptAPcg
         Ajrxewlt7onag/+1NHK45ejkyG2YtIyZbVI4Q65OahvT2F4vsesTlT8SrNe9LbhU8Rea
         otpwojmyiuxnGWBaF6aCKJGz2RgQ+GIjf3rwiG+oYfsGTSrGKAw+BmzZNzhLt9ViDI7z
         cuVkhLJ/VeRy9FNw9fEvDwBkbnBJjaxCkB00ZTb+3EwD6IAnqZEj08CyJ1kKlmjNoY9f
         ZfIrBud3eJ473AWbRdaUkMqIkxCn+d+PoejNc0xWomP9GURWSoekyuvOJ93BA42vFh1q
         6o2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dq1noghuki3s05Ms2hjQ2tq/heCYmToBu8e3a/R//7k=;
        b=D/N0tPMhwickZpB3GcfYuBW5A8ywL0BWeJsQLeXvVGgZrEYsWpU0U4MIIHJ2oJeUDp
         wW8p3CDYaQXrNLzBTwGLSybEsV33qkzsyEMGOLzX/BD2LFErlUBNjuymxaeAvuIiy7P1
         S/71ZL1pFVpnATAwvc1wnCGQwIZPaWAy8mYZ3hK8l6pFByJKCi9F/dGeesyPwTVN7jCT
         gcC7moWEGwmN0FzjetH1FOCw9j3InLcjmu9tCpjUNLPR1MJ87Jki5FnwTAf06am5TcWM
         2RpVY7+u9DJgAMhNgPC9ixmt1iLHm6Yk1sPlknFHZ7PK0FIH4ETfoS8IJ5SH6tgzabBs
         xhxA==
X-Gm-Message-State: APjAAAV317F85kA2b/RRXuS7JhF51K0IoCn/CPTPxqtawpnqQBXSSoyK
        YFCdKsFI59vv95WR7LYqtBwVEfdUwBw=
X-Google-Smtp-Source: APXvYqyb42OMZo06V3VtUXRni+ocZGstwZx+guB+BtXAaZH/whESQ/8saX7VnCvmDAWZE4yH2rEx+w==
X-Received: by 2002:a1c:27c5:: with SMTP id n188mr13911093wmn.118.1569783517018;
        Sun, 29 Sep 2019 11:58:37 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id e20sm23723341wrc.34.2019.09.29.11.58.36
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 29 Sep 2019 11:58:36 -0700 (PDT)
Message-ID: <5d90fedc.1c69fb81.a6672.a543@mx.google.com>
Date:   Sun, 29 Sep 2019 11:58:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.75-64-gb52c75f7b978
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 80 boots: 1 failed,
 78 passed with 1 conflict (v4.19.75-64-gb52c75f7b978)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 80 boots: 1 failed, 78 passed with 1 conflict =
(v4.19.75-64-gb52c75f7b978)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.75-64-gb52c75f7b978/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.75-64-gb52c75f7b978/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.75-64-gb52c75f7b978
Git Commit: b52c75f7b9785d0d0e6bf145787ed2fc99f5483c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 43 unique boards, 15 SoC families, 13 builds out of 206

Boot Regressions Detected:

arm:

    tegra_defconfig:
        gcc-8:
          tegra124-nyan-big:
              lab-collabora: new failure (last pass: v4.19.75-33-gdab8e08e7=
087)

Boot Failure Detected:

arm:
    tegra_defconfig:
        gcc-8:
            tegra124-nyan-big: 1 failed lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    exynos_defconfig:
        exynos5422-odroidxu3:
            lab-collabora: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
