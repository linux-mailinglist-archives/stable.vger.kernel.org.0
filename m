Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8C7C1E36E3
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 06:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728627AbgE0EKk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 00:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726907AbgE0EKj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 May 2020 00:10:39 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F7BEC061A0F
        for <stable@vger.kernel.org>; Tue, 26 May 2020 21:10:39 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id x10so9643799plr.4
        for <stable@vger.kernel.org>; Tue, 26 May 2020 21:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7niiOiv3PrwdlgIJNjueuyqojdUyzCpsCuvJLhqOO5I=;
        b=iYSWOfq3M3pt/bR186gVK5a74Mb/OL9gyO8hz2VQdlnARm2ZU08KWUBKgfy5HZe1h9
         FJd5kXVbS6+gmvih2XTQRx8kVMEOQOc8yzvs5PAy5TsjolcSlwkOWVftFtu7G2107OUK
         ccieqIsh/hbqS+kEUrFZqvUO53CRaYaBQU5ac54Svbr3JDwaln2iN1IEoRJ7Eix2K3Jt
         ECN2CDwulBaRTwFe0kTY6z5YvgwvEghW75FdLdanCghpU57Yip1Bkwa1Cmrsz7PvvNn9
         6T5zadATfKr+wE+pypRxg6vBinivM7M9z+H/Wg8zbElqKN5kfu+DIbaC1o8xThohF6ie
         or3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7niiOiv3PrwdlgIJNjueuyqojdUyzCpsCuvJLhqOO5I=;
        b=IYv4GBZSt4AgZuAl1zbhpFNfxll9+6RsoZOVaxVtnV/cIa1P0bFCGXTgyiiNgyGGjd
         i9lD/77qZ6KZ3a/8+9HfERbKe7dANLF9u6k4nSvBVBaPSGwWKap6U7oRKUCvz6acr7BT
         SgQCyTp88bIlG/VHZcP4fAHeFMbtkfncRN7K7csuIw205QxWhk3lgSsIQdqUrE/ynhqn
         yJd0HZEhRQetZD1WPIHO5NDzstG1Tek5aO9sTgRSgDvy0RNGscXOzE0Kk3K53csh210h
         BZiRrsbDObyiPaxYNdIDj4uRdbjNCD7qlaPi6bKo8LSg52gzda0ToqD5RtNiW4rQ1eel
         On/Q==
X-Gm-Message-State: AOAM5308IebFa6cOFLfa2YgbgkptpiHGkBgVQz8mww9yfZlgy6Ewocjr
        Dc33aehYwQxoZo/i4t3Qa5q7fwQZoOQ=
X-Google-Smtp-Source: ABdhPJwDQHgpK5KQD5qs1Xamw8gO2CIs2r2hy1fzhwJuX9Gv8SQSxiBizVsP0TvIB8fX5nW53UBpNA==
X-Received: by 2002:a17:90b:3704:: with SMTP id mg4mr2771833pjb.84.1590552638730;
        Tue, 26 May 2020 21:10:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p5sm830224pju.7.2020.05.26.21.10.36
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 21:10:37 -0700 (PDT)
Message-ID: <5ecde83d.1c69fb81.3a15e.76ce@mx.google.com>
Date:   Tue, 26 May 2020 21:10:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.224-66-g147ece171c0d
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 60 boots: 3 failed,
 52 passed with 3 offline, 2 untried/unknown (v4.4.224-66-g147ece171c0d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

******************************************
* WARNING: Boot tests are now deprecated *
******************************************

As kernelci.org is expanding its functional testing capabilities, the conce=
pt
of boot testing is now deprecated.  Boot results are scheduled to be droppe=
d on
*5th June 2020*.  The full schedule for boot tests deprecation is available=
 on
this GitHub issue: https://github.com/kernelci/kernelci-backend/issues/238

The new equivalent is the *baseline* test suite which also runs sanity chec=
ks
using dmesg and bootrr: https://github.com/kernelci/bootrr

See the *baseline results for this kernel revision* on this page:
https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kernel/v4.4.224-=
66-g147ece171c0d/plan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-4.4.y boot: 60 boots: 3 failed, 52 passed with 3 offline, 2=
 untried/unknown (v4.4.224-66-g147ece171c0d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.224-66-g147ece171c0d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.224-66-g147ece171c0d/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.224-66-g147ece171c0d
Git Commit: 147ece171c0dc02b417f35088182a61e6dac368a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 42 unique boards, 16 SoC families, 12 builds out of 159

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 13 days (last pass: v4.4.=
223 - first fail: v4.4.223-36-g32f5ec9b096d)

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu_x86_64:
              lab-baylibre: new failure (last pass: v4.4.224-38-g1f47601a42=
96)

Boot Failures Detected:

x86_64:
    x86_64_defconfig:
        gcc-8:
            qemu_x86_64: 1 failed lab

arm:
    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
