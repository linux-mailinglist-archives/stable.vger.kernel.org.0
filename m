Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD6AC1AD078
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 21:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731395AbgDPTjN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 15:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725894AbgDPTjN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Apr 2020 15:39:13 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBC54C061A0C
        for <stable@vger.kernel.org>; Thu, 16 Apr 2020 12:39:11 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id d1so2146491pfh.1
        for <stable@vger.kernel.org>; Thu, 16 Apr 2020 12:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SXAmxK9qmYgVx1eTnwhNm1bQw5tBBhXbPeWGPcM7KAk=;
        b=vRpK4oL5/vhdabwAjiIbDmrXG/nCNrrg6pLJYSFClrRa7kifmftN1Zaq8tRbw178TP
         BHhqsevkU33RppKLKBL+Rlbyc3SCblorb5GzLDnpGeMQhRdKSqHcxQBueRBwtFVrv3Nc
         Su5lAwggsGTZRCelpSFt8ZXXSRzuxvuWbcm7kmpqiu4d2nwyYWt8jFRYKlJpp8sUf9rE
         lo81a9OoAwC/puGrgl3Y9bhBj7TqNRks01vfQFiwdo+FhRZjl1omd041pOMEPFkWr108
         +KxGJe1mTGs2RdNyxAxjbNa8xOnQVgYmIyPBvB8ZNjmkAyVWSqRGlZhiPxPPohUkC9Re
         w6Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SXAmxK9qmYgVx1eTnwhNm1bQw5tBBhXbPeWGPcM7KAk=;
        b=nIggHNTjITU40v18jsuwxUHnKMR5nnehTU05hUSKHZO7cFhY8TkvVXWa9qdOYBUsPw
         xEA94dJ0wd7yEnsTdF3ltc5lbGynyS6Mkrxk2/XTcsgtamLYNlsH3sblwLgEgejk3/kW
         BA1r3Tab9fB4nOQWjU/zjCv7Wk4mcdUT3iP+fb+3Zz85UiNSYbAgSRSeHq5AKivzsbtm
         pfbxYGpVZnB2oVe0QYyX0+UeK3JsZOcKcSZScfC1/DLy8VB6rXL4r2bz2k5viCF7zAgs
         GaBLbULcL3/c4553reEyCXZNT1muRrZJn8vp2jvjOu1/+W3leo5k+BvoOGPxPuQVE2r2
         haHw==
X-Gm-Message-State: AGi0PuYDtHPLARBwRIulfzf8OutonQ0zG4d+jYMI8EUIPQ4x6hxNeLVs
        0dKJ64rYd/T2ITs1ji0ZDSMHU6+FuFU=
X-Google-Smtp-Source: APiQypIVFSR4RwdilsRoYRsl1e4zaWGvd7TX/08HYL/BX+eL2/R3Oz/8BHqfF0KN37a5/5RYiXe1Tg==
X-Received: by 2002:a62:62c3:: with SMTP id w186mr21707513pfb.105.1587065950932;
        Thu, 16 Apr 2020 12:39:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q11sm5368411pgs.25.2020.04.16.12.39.09
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 12:39:10 -0700 (PDT)
Message-ID: <5e98b45e.1c69fb81.5ae1d.2c16@mx.google.com>
Date:   Thu, 16 Apr 2020 12:39:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.175-146-g4bea164d1f6e
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 132 boots: 3 failed,
 122 passed with 2 offline, 5 untried/unknown (v4.14.175-146-g4bea164d1f6e)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 132 boots: 3 failed, 122 passed with 2 offline=
, 5 untried/unknown (v4.14.175-146-g4bea164d1f6e)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.175-146-g4bea164d1f6e/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.175-146-g4bea164d1f6e/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.175-146-g4bea164d1f6e
Git Commit: 4bea164d1f6ea26a51939ac38ecbed387e445339
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 75 unique boards, 21 SoC families, 18 builds out of 201

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 68 days (last pass: v4.14=
.169-92-gb4137330c582 - first fail: v4.14.170-62-gd6856e4a2c23)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 56 days (last pass: v4.14.170-141=
-g00a0113414f7 - first fail: v4.14.171-29-g9cfe30e85240)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-p200: 1 failed lab
            meson-gxm-q200: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
