Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B788C1E71C7
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 02:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438168AbgE2ArN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 20:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438131AbgE2ArL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 May 2020 20:47:11 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0120FC08C5C6
        for <stable@vger.kernel.org>; Thu, 28 May 2020 17:47:09 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id nu7so369820pjb.0
        for <stable@vger.kernel.org>; Thu, 28 May 2020 17:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2oTsCW/tMr6WehxRf7TN2Hw9nRy7MDaJnt9P4mb1l2A=;
        b=elj8ooJ9cwngKJEN4nHADYUSUKqTu7V6tmT6zGCSgeRrhZNLdW0gnI8HIIzc8Jtmp7
         HcfnJCraTKcqIOLswPt72si4xS/UuFCBaiwiBviGg2WImJ+4ekI4WVp5DCtsXXww8eEW
         UNdQ/dLMpjTBN8pX/KQCFa8EL6rJTxP3XEVuDmICq80FMhhqHgNHTvXLJ4L5/DGQUN0r
         9V9MzAWVlPZde8efzqNmDwkVbdjDJrcZM5ly2u1tsotcHZSabiT5/LASoMDfVKHiuAsj
         W3WAQEaX6jEphRVnrHKcxlwZIT6S8Z9XQH0lHL12dyWENMAvDakH2gm6oLnBqdkk9PiX
         ROVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2oTsCW/tMr6WehxRf7TN2Hw9nRy7MDaJnt9P4mb1l2A=;
        b=KyDiCv1LZ/OuVeewvpo/69ZN6H70huwz3xX/g8r4j57NY3cpaVjTx2cr5BMMb7hRz4
         yELGI4pOtWO8Smd31QXigK9ptzsKcoJV60o/rRwG5y1CbtxQpAhlTQKgJN+j37wZqQWj
         oW838aSD9vfMwbYsqYJCcUzSvOCLsy38kGj9QQMd7v60SBHjteK3A1Xp1lNnir+ffIFl
         yUdINXONCF7BybuyfUgFM7V/QSSDNtMUyOhemoYpQuO+tqHRz9bQpXnogo3lutdnEvae
         0huIhdm8xZQ6VXr6poMg2BQozk1HWv8nRo8kONC2rYfT3jw3e+n+aBvaZZCELDsEnESa
         jHfQ==
X-Gm-Message-State: AOAM531D6jluqX7bdpOZtLhhMW676k8gYLYGHHYzdMAL+oAmwrSJWYoJ
        qTm6C+YzbRVzJo0J4G0BG8wcWFlHpRI=
X-Google-Smtp-Source: ABdhPJw7FrD9kYJszRrdukNs+eT/U5fNZfT+HSQ8HEOl1V+K+axNQih5gM8EtcZabQY/2cG8k9gKwg==
X-Received: by 2002:a17:90b:4c4b:: with SMTP id np11mr6743642pjb.58.1590713229024;
        Thu, 28 May 2020 17:47:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b63sm5686201pfg.86.2020.05.28.17.47.08
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 17:47:08 -0700 (PDT)
Message-ID: <5ed05b8c.1c69fb81.4de96.27c8@mx.google.com>
Date:   Thu, 28 May 2020 17:47:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.6.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.6.15
Subject: stable/linux-5.6.y boot: 103 boots: 3 failed,
 97 passed with 3 untried/unknown (v5.6.15)
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
https://kernelci.org/test/job/stable/branch/linux-5.6.y/kernel/v5.6.15/plan=
/baseline/

---------------------------------------------------------------------------=
----

stable/linux-5.6.y boot: 103 boots: 3 failed, 97 passed with 3 untried/unkn=
own (v5.6.15)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
6.y/kernel/v5.6.15/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.6.y/ke=
rnel/v5.6.15/

Tree: stable
Branch: linux-5.6.y
Git Describe: v5.6.15
Git Commit: 183673bef8533a3744ad27e32ca901de59e09307
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 66 unique boards, 18 SoC families, 15 builds out of 165

Boot Regressions Detected:

arc:

    hsdk_defconfig:
        gcc-8:
          hsdk:
              lab-baylibre: failing since 8 days (last pass: v5.6.13 - firs=
t fail: v5.6.14)

arm64:

    defconfig:
        gcc-8:
          meson-g12b-a311d-khadas-vim3:
              lab-baylibre: new failure (last pass: v5.6.14)
          meson-gxbb-p200:
              lab-baylibre: new failure (last pass: v5.6.13)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-g12b-a311d-khadas-vim3: 1 failed lab

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            bcm2836-rpi-2-b: 1 failed lab

---
For more info write to <info@kernelci.org>
