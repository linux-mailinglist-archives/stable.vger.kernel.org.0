Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12A0E1367FC
	for <lists+stable@lfdr.de>; Fri, 10 Jan 2020 08:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbgAJHKb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jan 2020 02:10:31 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:32920 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbgAJHKb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jan 2020 02:10:31 -0500
Received: by mail-wr1-f68.google.com with SMTP id b6so748964wrq.0
        for <stable@vger.kernel.org>; Thu, 09 Jan 2020 23:10:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ean7//V8Z8/8ALOSZCDeMR/JHZRjAWIOclGnOLYPOvg=;
        b=leHp7SoV1RP4bBla0fizNf1SO5gsrktQCN48UhPCt63ZButQsEiBdjGQv1wx+ky+sd
         xyTJa8r9UdIW3mC4ElYMoWeHNgu5PrFIOK06PiUFk/8d93iYf9E/tFd3G4YZ+DHJKSmT
         KGrMaJRmizZMLHjB6iFhGE6VVR/6tE1qpT6vNkgtYWdZ9aL4dDp+SqG2sNePSDQi2KUb
         6qvoKC2/vSLeugf/90ENyMQYtZBM5cVj82Tk3FCDjbXAhWufnXA5EHKO9sTF3JoKJICj
         /jtcQvjcjKsUQmAJCVdiPKTxEpnaxDlYJ/oYFm33Ow5Xqb+23EJd88qy/1o/4p0zy+9i
         OrcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ean7//V8Z8/8ALOSZCDeMR/JHZRjAWIOclGnOLYPOvg=;
        b=bw21HIcGdhgMq5DLXHKhRlPyl2SzVTw1wvZqRPugjnjto5Xarx1JWLwE7YE2/02aMY
         s909VfVpdlWaThnEzYDEk7LcrC8xOhcQuWE6Wf/qwBmoG4b7gO4YMv1xGbqYdxVzuAac
         AcrL+QJ3XDLm34Sm/iXlgR682M6FEF7M/WK55OoeMS3gvCgfd0Ps+U7eqH6JAQshQD4b
         XSwnkG1efC33poR3cR7e4zgHHfufjatzGmimRdTidSaqyzk6crrWaKYiEbGaz2tExKCi
         ZI8mJlkpwM42IzjXc6alUvyJwVrCP2IE7olXaAmoY9W2D23U19DvE9dQTcArUisTB21A
         OJrg==
X-Gm-Message-State: APjAAAVZlsniR/6BvV8nW9k90gh9I+UW3BlbpFB91OE52F31ZGWsvrhy
        Am4sXDF4dBkRkj0uqMG1VxB6PqKLNsdxag==
X-Google-Smtp-Source: APXvYqzBLQPHRWF16huuCJ/2k2O9ex1wTGoriQQr9pj55FBNglUE8FBendWh4L0s0XNCiZGRdGnDAQ==
X-Received: by 2002:a05:6000:1047:: with SMTP id c7mr1736544wrx.341.1578640228985;
        Thu, 09 Jan 2020 23:10:28 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x16sm1143572wmk.35.2020.01.09.23.10.28
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 23:10:28 -0800 (PST)
Message-ID: <5e182364.1c69fb81.5e0a2.49a7@mx.google.com>
Date:   Thu, 09 Jan 2020 23:10:28 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.94-61-g704918bac4ed
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 63 boots: 5 failed,
 57 passed with 1 untried/unknown (v4.19.94-61-g704918bac4ed)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 63 boots: 5 failed, 57 passed with 1 untried/u=
nknown (v4.19.94-61-g704918bac4ed)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.94-61-g704918bac4ed/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.94-61-g704918bac4ed/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.94-61-g704918bac4ed
Git Commit: 704918bac4eda98e55133ba7d28b517d48fa2a02
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 42 unique boards, 12 SoC families, 14 builds out of 206

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: new failure (last pass: v4.19.94)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-olinuxino-lime:
              lab-baylibre: new failure (last pass: v4.19.94)

arm64:

    defconfig:
        gcc-8:
          bcm2837-rpi-3-b:
              lab-baylibre: new failure (last pass: v4.19.94)
          meson-gxbb-p200:
              lab-baylibre: new failure (last pass: v4.19.94)
          meson-gxl-s905d-p230:
              lab-baylibre: new failure (last pass: v4.19.94)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            bcm2837-rpi-3-b: 1 failed lab
            meson-gxbb-p200: 1 failed lab
            meson-gxl-s905d-p230: 1 failed lab

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
