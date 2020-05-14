Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 584241D3F05
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 22:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgENUhX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 16:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726073AbgENUhX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 May 2020 16:37:23 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85238C061A0C
        for <stable@vger.kernel.org>; Thu, 14 May 2020 13:37:21 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id q9so1331289pjm.2
        for <stable@vger.kernel.org>; Thu, 14 May 2020 13:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hQLCktbcX37EifQt5gS6XpS3qxT0QMI1kFo0IuoQNrU=;
        b=YwUlGAq0KaejpEKMmFmQAsbnNsf5fgwc23OvVOXR9lfhpOC7dxFnMR/28OuGYGmEf2
         wvjd90jG2Gf/M7uyrlvtcqQbw5T+y7tYxjipivco0MhH9tUizpeE1ZhthiRQpRkXaRCk
         BgginzRFCerAVwqSM9hY3dBuqULv37XzxjI7AoNASxbNJF4NzQDsuXM2xpLJY7RqHDkL
         xNcZ4GipDxt9DcpbIAVitwr785jEmSkXQj5HCMVe0NxVRJPMaD58LrHNhoqzBncSa/HR
         cTz6oD6G3nXi4TimAPfNGR96XKsM6ZUPJ0YtEjMGYYff7LsYx6RpShACIR2pzk38RWbV
         dSVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hQLCktbcX37EifQt5gS6XpS3qxT0QMI1kFo0IuoQNrU=;
        b=Ofj1wtTRzjAjBhqLJ8kwn81JGGYIJk/yKbNZp/OAliOad83AL7JhdPG32crflw5nXa
         6l2+7XmJKFDrvfdRVVeKluXBoEZz6fTPnA7YlMz9zuN9eEFEgeB/ftf4Z1omEjgAg8aA
         lg0xuCQgGRH90qeaG//GHVGpp7lQAms0qBuabYzcoX0FpJKJT081qaN5KnBCocX1lWhq
         yImCAyy/DJ6n7o7eSJsLJQ2bVGvv0+bxPal9zT6ON3a/qWosKnUX7dHiisMXZtSFkKcq
         XXFYQFqx2txLlTMFtuS3QqjXYMJav21OQQOOT0hzLnugNAXRAZvHsOBm+Cz7OCHjOl0X
         0L8A==
X-Gm-Message-State: AOAM532LO4A64eFro6p6X+v49Qc6ugaMRxguwWJ/dOkdzGI5reKWerOb
        uCcSSymZVMzTqUtWSeNpfNGWgxbPkqk=
X-Google-Smtp-Source: ABdhPJzopbzBkQVJcou8UpWm4B7MEXA6OC158ytlFMXz+qcdiGoCxn3iaHjv84YgzAYEG4GIFmBQFA==
X-Received: by 2002:a17:902:cf87:: with SMTP id l7mr325135ply.307.1589488640697;
        Thu, 14 May 2020 13:37:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r12sm80418pgv.59.2020.05.14.13.37.19
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 13:37:20 -0700 (PDT)
Message-ID: <5ebdac00.1c69fb81.e66ac.053a@mx.google.com>
Date:   Thu, 14 May 2020 13:37:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.180-49-g7ab962eff016
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.14.y boot: 130 boots: 3 failed,
 117 passed with 5 offline, 5 untried/unknown (v4.14.180-49-g7ab962eff016)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 130 boots: 3 failed, 117 passed with 5 offline=
, 5 untried/unknown (v4.14.180-49-g7ab962eff016)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.180-49-g7ab962eff016/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.180-49-g7ab962eff016/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.180-49-g7ab962eff016
Git Commit: 7ab962eff01648dbef560d24229802fc7c6b3de2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 74 unique boards, 21 SoC families, 18 builds out of 201

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
80 - first fail: v4.14.180-37-gad4fc99d1989)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 84 days (last pass: v4.14.170-141=
-g00a0113414f7 - first fail: v4.14.171-29-g9cfe30e85240)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.14.180-49-g188e0903=
39cf)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-p200: 1 failed lab
            meson-gxm-q200: 1 failed lab

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
