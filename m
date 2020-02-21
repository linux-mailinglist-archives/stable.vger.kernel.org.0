Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E95DF167609
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732003AbgBUIGw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:06:52 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38404 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731977AbgBUIGw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Feb 2020 03:06:52 -0500
Received: by mail-pg1-f193.google.com with SMTP id d6so584394pgn.5
        for <stable@vger.kernel.org>; Fri, 21 Feb 2020 00:06:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=U5G7DsXmnuajC6U6u9wwfa/zrpQmgeuvul3FTccfDY4=;
        b=hRCvzyG/7JHCDcvQ9xUw1zO+u3CE37b0SXtOZMLcROEpCkMRim8geA0DNCHXy7b40n
         ObkqRZecNS2iq1tR/HMYTzT3/kHf4/omf97DADu0lp6azMjbFN9H9dl1o0leZSHOhqPg
         ysR/hjJ2C2OG8dJKtJ6qVq/f6ozx0jKYH19htRNZ+UhYaTroC5LvkbioLejnmlr7U9LL
         ZEB3pFqf6CWFmPG3fRERusfxsy/tWFnlewmi7KQw23EuMIF+wmD0EYsEtssibtZyYyhH
         So+1bIy6ZgNSTYbirI9NwViKn4OSoRJ+U58U0bSaUkj/5TRK7+MwlEuanVkuBGoHBSYP
         97pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=U5G7DsXmnuajC6U6u9wwfa/zrpQmgeuvul3FTccfDY4=;
        b=tPxV/Rao8P3SUkcuzLQURO6pTroaLCgqOt+d7IbkDn+Qe6EVBsa3AsrEbEHx/MwFW1
         zCufKMxZ88sLXV8zMIFK4COM2o9IDeonXHN4XjuywDs+cjTkm8QiVO5qM7cnu/jNSZNb
         kGLrX8uCML4tVkZFbQfaAq63E9Wh4Bf8VVw3ERtJvGGjS9Kx33zMpTSTRsyyhs7DaftM
         2E2nvZRxzlatpWildXoizuXYrYQ9hU2jzQ/IfNgRS+a7wIEhFTWLA9AcDZD7f83aUeqR
         TZZmvVfgQmVOvhRHzt2Wa6n08RpUbmqan5urO9qnVufxO+Ucr2QRVwHK/gP0GyI7M+ZO
         gJLw==
X-Gm-Message-State: APjAAAX6IK6Eu7/+sphWGFUBtABsbsA7tyY4/ijqQMMfEZ1vBauIJVy3
        vLGYQsCOagowfHyFGY3gq4q3o2K/YDQ=
X-Google-Smtp-Source: APXvYqyUNLWhUjzBkWMBo5ukpwj2daCdBnry6tuz0n51Uq1hxrEzULIpqpHmtCYdPPpeWxYKJ9wihQ==
X-Received: by 2002:a63:3754:: with SMTP id g20mr35675108pgn.384.1582272411124;
        Fri, 21 Feb 2020 00:06:51 -0800 (PST)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l193sm1606929pge.21.2020.02.21.00.06.50
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 00:06:50 -0800 (PST)
Message-ID: <5e4f8f9a.1c69fb81.9f53e.5b4a@mx.google.com>
Date:   Fri, 21 Feb 2020 00:06:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.21
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.4.y
Subject: stable/linux-5.4.y boot: 69 boots: 3 failed,
 65 passed with 1 untried/unknown (v5.4.21)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y boot: 69 boots: 3 failed, 65 passed with 1 untried/unkno=
wn (v5.4.21)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
4.y/kernel/v5.4.21/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.4.y/ke=
rnel/v5.4.21/

Tree: stable
Branch: linux-5.4.y
Git Describe: v5.4.21
Git Commit: 2d636a1263be81f89412548a31f9cbbfef746b9c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 54 unique boards, 14 SoC families, 14 builds out of 188

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          am335x-boneblack:
              lab-baylibre: new failure (last pass: v5.4.19)
          omap4-panda:
              lab-baylibre: new failure (last pass: v5.4.19)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    omap2plus_defconfig:
        gcc-8:
            omap4-panda: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            msm8998-mtp: 1 failed lab

---
For more info write to <info@kernelci.org>
