Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E21D150DAA
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:46:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728332AbgBCQqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:46:01 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39341 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729811AbgBCQp7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Feb 2020 11:45:59 -0500
Received: by mail-wm1-f67.google.com with SMTP id c84so18029589wme.4
        for <stable@vger.kernel.org>; Mon, 03 Feb 2020 08:45:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=oYhfEkbRoCi5geVBsL2x2XyM4UWwcuJso8r0Bq1TDRo=;
        b=U6XfRznIRJjGeXkFFm2W7nITqSGqfmeWxB+a2YIB83JOvl+XgsR9lo1TavZ3PsON7F
         kwYSEh/uSG7gE3zYvM0r6jF32oNrki8Z/MwfjjE9Mt1LrMHDjoGwIt5u0Z+xh+Mi1qr4
         RMXmBEJ6J8fCJpdadE7gxwO+Am/aWaqOxtDySlUvDAFBCMEsayI24vbY0Wbsgi40SzRh
         cIBArRc/+E5vazfJHjBQwE7xC08JaE4zWkOmS8CD4Wy6T79QZCWsoG1QeCbXkD/j5V+g
         sH99yxnrUWTuc/bMkc6vIPKEw588TNEGNUKj54Y8QcM7zFtFnAIPJ61vRfbGxcAT8RNI
         LrOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=oYhfEkbRoCi5geVBsL2x2XyM4UWwcuJso8r0Bq1TDRo=;
        b=fEjXkyzggpseAQewQZrIM0a1inEOLUweCjS3mVxdpRQdgxgUt7U3Ve4IOB8pcTnGhS
         LjwBAazzCx7m371KVODEvLXs2Quwu0RMBmhQuq/WSvsIPFS+cx+eCBNOvpPMIhNu+bEi
         otW5SCFKMTC8kkF4s53hnYS95CvDj1tH0nm6Nw/JNi+Idq/JBn0/Y9DAI6dSSNCwUUFb
         mce41LTm+nB3En5+ATAzP2cZ6bbY2Gl3WQJuJXiIHh9YnqBHdY0G/Rs6i3nz5OXpC6uf
         16/9VZz2JmwxhB7leaAP7Fyp9KHz5iiQbF6+kxIYEjcAv4h2V6FgDUbl7yswTMFnBLOa
         otHA==
X-Gm-Message-State: APjAAAUcNL7KYFbr9lVyX7GpyIfMR00B5nKBuht64B1rdVChH3WxvBki
        yEEPQIL9icR/EQ71PvjAYs/j7jxx6Ow=
X-Google-Smtp-Source: APXvYqxzm1DG508F9P9zhCMO4RYOwjAgZODhjxXvsDzjM5/7M9GuuBxa29UbpwPWxsMzWZAIRmpXrw==
X-Received: by 2002:a05:600c:21ce:: with SMTP id x14mr29694816wmj.120.1580748357094;
        Mon, 03 Feb 2020 08:45:57 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b10sm26643169wrt.90.2020.02.03.08.45.55
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 08:45:56 -0800 (PST)
Message-ID: <5e384e44.1c69fb81.c6251.3bf1@mx.google.com>
Date:   Mon, 03 Feb 2020 08:45:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Kernel: v4.4.212
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 55 boots: 1 failed,
 52 passed with 1 offline, 1 untried/unknown (v4.4.212)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 55 boots: 1 failed, 52 passed with 1 offline, 1=
 untried/unknown (v4.4.212)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.212/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.212/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.212
Git Commit: 475d90ca735ce524de49d9fbe3f1a3fd5655caeb
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 38 unique boards, 15 SoC families, 12 builds out of 151

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          am335x-boneblack:
              lab-baylibre: new failure (last pass: v4.4.211-184-g475d90ca7=
35c)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            tegra30-beaver: 1 offline lab

---
For more info write to <info@kernelci.org>
