Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCB01DB46C
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 15:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgETNA5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 09:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbgETNA4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 09:00:56 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55157C061A0E
        for <stable@vger.kernel.org>; Wed, 20 May 2020 06:00:56 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id k22so1291248pls.10
        for <stable@vger.kernel.org>; Wed, 20 May 2020 06:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=R4qiLl/W4MKPKFsFJ0XJ5vO1DWhaZMeWyzknUTTW9dk=;
        b=oLpoOCa4LvU1e6WVUeG+ywfN323/uaGes3loi0XckiqnMnX+crYrOO+nRNECcR1GI9
         IY7aDO9fLi5jsi5GHVBEtHP4iOUkkz7Bn4hvItVfbqmyATNfb4XxahzWNXf+CNyixaX7
         TL33ZOVRsSzDy9bbIFfCKIqfzqtyHXACau4ZZN9F5VBZ5W8liHIXnBX/Gt6ZoEphphQB
         Ab4ejC2BYivV7TZrhiVgJmjv8zmgrffqiZzwA51QD3uI9cLbPdjHX99wGQ3Qh3OvZfKl
         cELBaoBRo15WuXhWKjfOR92xKNUWjQaLIxNsemsFQbHHq/FSc6iheFJc1jO2nvFOTGR9
         knIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=R4qiLl/W4MKPKFsFJ0XJ5vO1DWhaZMeWyzknUTTW9dk=;
        b=YBubpzkX7kGU3KnnsXIdEF/dWNRKDCvPowqZG+dj4YIX8KHI2C0yNWygKUX3ho1qkG
         pQCyh5xdL1YAABDPJHqrVtyr+HIU/Q3rKx7AB2GJUT+M0yZC9hos3aHrIzXdKK9GEU1g
         eYJnHo7joy8rigu/X+jx103rWXBEdT12i6YAAc7TMpTczd3VfbgNnU57MT3wRBvtdMx3
         E0JKdNJ/EKzQtaRNgXBGUtaRlPab/HDE5IO4M4BJS0GdVKueDS+rDdG8yAkQyUybKG47
         0PuQi0T/Lgdvgm8YvcYi9IxgcxRkmpESRh6Um4UHix6HQKWuwHkHfSwSnvNFc+lJu+hG
         M2QQ==
X-Gm-Message-State: AOAM532XQ9KOFZIftCNc7lL+0Sut0uAI6I1jaZ6Z8KnWY6eeFZ8I5FYo
        2aG+QAnxH4KzzKTpa3+uyRxP9iCcnDE=
X-Google-Smtp-Source: ABdhPJzQpIGYsM6qcIOAGZ+XLW3R53JEYiZgLyOVR6MeDve2YeDPvV1O152x51A3s9C7/7E3HZ1QqA==
X-Received: by 2002:a17:902:c213:: with SMTP id 19mr4493054pll.190.1589979655522;
        Wed, 20 May 2020 06:00:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v75sm2180338pjb.35.2020.05.20.06.00.53
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 06:00:54 -0700 (PDT)
Message-ID: <5ec52a06.1c69fb81.e96fa.83ff@mx.google.com>
Date:   Wed, 20 May 2020 06:00:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.4.42
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.4.y
Subject: stable/linux-5.4.y boot: 84 boots: 1 failed,
 81 passed with 2 untried/unknown (v5.4.42)
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
https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/v5.4.42/plan=
/baseline/

---------------------------------------------------------------------------=
----

stable/linux-5.4.y boot: 84 boots: 1 failed, 81 passed with 2 untried/unkno=
wn (v5.4.42)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
4.y/kernel/v5.4.42/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.4.y/ke=
rnel/v5.4.42/

Tree: stable
Branch: linux-5.4.y
Git Describe: v5.4.42
Git Commit: 1cdaf895c99d319c0007d0b62818cf85fc4b087f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 58 unique boards, 17 SoC families, 13 builds out of 200

Boot Regressions Detected:

arc:

    hsdk_defconfig:
        gcc-8:
          hsdk:
              lab-baylibre: failing since 5 days (last pass: v5.4.40 - firs=
t fail: v5.4.41)

arm64:

    defconfig:
        gcc-8:
          meson-g12b-a311d-khadas-vim3:
              lab-baylibre: new failure (last pass: v5.4.41)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
