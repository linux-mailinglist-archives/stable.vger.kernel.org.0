Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 423DD445A81
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 20:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbhKDTWf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 15:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbhKDTWf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 15:22:35 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A75DFC061714
        for <stable@vger.kernel.org>; Thu,  4 Nov 2021 12:19:56 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id u17so8886422plg.9
        for <stable@vger.kernel.org>; Thu, 04 Nov 2021 12:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=62gQWjFjAnrwPeeFBUEaSnY3B4k4aHX8wV5jmKCJt0U=;
        b=UUPinC9pT5HR5wL/lapAAJEqKCDDvshHYwYnev4QfTTZ6r3NV34PMA2V/5FbCdSA1d
         +2vqFZAkSNnxp3DCEm0Ynh/o+meBkp7qux2c/SPVPbNVNfPdZStn70cxVg4TJHjSW6Ze
         i9I7+I7wXmOfRn02EKOde2p540n5rzVqrtiVH1BKgeGg2u+vfnetE2kkDKR3tGI8xMp1
         Zmw/4LBdM7RxW2XmKpxSqBbIj04ipS8E8RzUTuw9gyCeXX8994AOU3rOci7V/bO/vNrb
         5TJcA1Yso7mQj46TAj8Cnq3/0JQipYJnGrfZOry1CYSBE1lQ/rzoZnmNr/N+EkXgrCzl
         LNKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=62gQWjFjAnrwPeeFBUEaSnY3B4k4aHX8wV5jmKCJt0U=;
        b=MC4H8zQ2XlZXudz/tc1Yyyn3c9FvQgLNAIkesYfLGJZY9UL7SSYdH5TUindO2OwAyM
         P+YuRNnceXIG/igaGzDvFDv9N6Uq7PZ6naL6ST3NvTOxUKDxZlWdblFyD+c/LlsPn0Hk
         4ogWtUuQ2m3Ewc8eHSeHmSN9EKciPOGGsMSE0mQMrhD1Gze0EUd1IkY9APp3s2A1dFF4
         6hjPEmxpzELdqXEoK6hHRFMPlOc8vknTDUWKF5jLLOtUnT61WRv98+tXzPxDY8uxAV8b
         +y4GBMJw1gUJrRJ7bDYkhV3rVvPsjBv/4oIglYTfinrGoTGgbG1GWmnwifhZEyZJZWHY
         x7TA==
X-Gm-Message-State: AOAM5306CDNR+RsC6Wv8m35bYr7Tsf2EQ8LOAty7NY3wb0e39NV3MU4+
        oZ2Ik3PkohVhKY/RzYOstnudCKCi5WvwsNGJ
X-Google-Smtp-Source: ABdhPJzJUVOFDz6lpfdvrAlrIM1WPJadW8vJ77ibhPPli16Ovg5M12mH2ZgnJv55+68PbAyknU5b7g==
X-Received: by 2002:a17:902:d505:b0:142:175d:1d4 with SMTP id b5-20020a170902d50500b00142175d01d4mr15072819plg.50.1636053595979;
        Thu, 04 Nov 2021 12:19:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s2sm5315880pfe.215.2021.11.04.12.19.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 12:19:55 -0700 (PDT)
Message-ID: <6184325b.1c69fb81.361ee.1de3@mx.google.com>
Date:   Thu, 04 Nov 2021 12:19:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.16-16-g32650358170a
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.14 baseline: 155 runs,
 1 regressions (v5.14.16-16-g32650358170a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 155 runs, 1 regressions (v5.14.16-16-g326503=
58170a)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.16-16-g32650358170a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.16-16-g32650358170a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      32650358170a7c74432712e8e6b895243c18c512 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6183fde926b0a2d04233590f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.16-=
16-g32650358170a/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.16-=
16-g32650358170a/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6183fde926b0a2d042335=
910
        failing since 11 days (last pass: v5.14.14-64-gb66eb77f69e4, first =
fail: v5.14.14-124-g710e5bbf51e3) =

 =20
