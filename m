Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F90F5BA110
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 20:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbiIOS5e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 14:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiIOS5c (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 14:57:32 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 760F34AD67
        for <stable@vger.kernel.org>; Thu, 15 Sep 2022 11:57:31 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id iw17so19261505plb.0
        for <stable@vger.kernel.org>; Thu, 15 Sep 2022 11:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=weVA5vI+rvfoVce0LIvqvrSr2EvqsXpvo1uWBQOY0wk=;
        b=nDsOxE7sqjAApKxFAIBzzhzPQztadJgsdY5ktyIeo/LBhV618LuFNRaT/SRt54/Gef
         BLLU94DKTq559tQDeUznExegml8pnDCeYmBQ1ULGLeFUy3JTvwSyVa8K19obkeqlPhnw
         s8bQhyUI6D7cuTKumfjQedYCbwFCRZvIDEDSj/mYViwHjDgHN/Oz0xkvDpzvGaD/glSF
         xeWSA8lWgMKoSgKN2Jgfzat+eApkalknr+G6ZLWXBgXk38/5NFIwgQRUzKkt00Hrmyl1
         19ike9EenseT6Dzio39bXwhHFegLk5dE5CkeVPxNnWFfWs4i203wMSswfMWYHrcJ45gn
         Hd2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=weVA5vI+rvfoVce0LIvqvrSr2EvqsXpvo1uWBQOY0wk=;
        b=Goh9kdScnwEP0jCaUydEJpomtfpjCG4U07N9PyOGqWzW/RmyIDrswgZY7nlfuuVnI6
         7HefOkx8wBQ7bX8GcnUhjK62pM5af0bfOLs4toZak4rGX8qdRrcTmgZZluVD33a83ntz
         Kr1igLEJvGZlK31Y8pVGFWJnME4TnFJIgyDxFhpfoZlGm6MRxXxUZyoUtAvYgwQIuxS6
         oql7tXEdrmEt1QgRAplcA4os+hk9n1Ob7y5YxGIinTI+fs1pWJmMz3YrqEYKqDQ2wk9Y
         601Zj7nFirW73Yfa/cmNCYx8VLg0b1fuLnn+GvpDGMGXcVEmGxLnn01ym+KvHhPeRkVZ
         7+WQ==
X-Gm-Message-State: ACrzQf1exKvzB0aXtWjpk6bCCuVoEL5ZNkHKr2wDHh8QzTEQHMtE9LDb
        YF2qfy2W80Loyx6fDsND8ckXpBSFZH2DEQw2iQc=
X-Google-Smtp-Source: AMsMyM4JQJ8D4gvo3Q/wwrwPydXNyb5w2tiFIeaM7c3OJjRtD1EU24A07lG6elyEmOCUzEDpNQFv0w==
X-Received: by 2002:a17:90b:3510:b0:202:f18c:fdb6 with SMTP id ls16-20020a17090b351000b00202f18cfdb6mr1338333pjb.122.1663268250660;
        Thu, 15 Sep 2022 11:57:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q6-20020a170902dac600b00174a4bcefc7sm13408765plx.217.2022.09.15.11.57.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Sep 2022 11:57:29 -0700 (PDT)
Message-ID: <63237599.170a0220.c2c4a.8267@mx.google.com>
Date:   Thu, 15 Sep 2022 11:57:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.68-27-g08cb13c1cfaa
Subject: stable-rc/queue/5.15 baseline: 196 runs,
 2 regressions (v5.15.68-27-g08cb13c1cfaa)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 196 runs, 2 regressions (v5.15.68-27-g08cb13=
c1cfaa)

Regressions Summary
-------------------

platform            | arch  | lab          | compiler | defconfig          =
 | regressions
--------------------+-------+--------------+----------+--------------------=
-+------------
beagle-xm           | arm   | lab-baylibre | gcc-10   | omap2plus_defconfig=
 | 1          =

r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig          =
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.68-27-g08cb13c1cfaa/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.68-27-g08cb13c1cfaa
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      08cb13c1cfaadcabf31a0e0f1c6a53a200c8dda2 =



Test Regressions
---------------- =



platform            | arch  | lab          | compiler | defconfig          =
 | regressions
--------------------+-------+--------------+----------+--------------------=
-+------------
beagle-xm           | arm   | lab-baylibre | gcc-10   | omap2plus_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6323432eaafe2b0cc535565e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
27-g08cb13c1cfaa/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
27-g08cb13c1cfaa/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6323432eaafe2b0cc5355=
65f
        failing since 168 days (last pass: v5.15.31-2-g57d4301e22c2, first =
fail: v5.15.31-3-g4ae45332eb9c) =

 =



platform            | arch  | lab          | compiler | defconfig          =
 | regressions
--------------------+-------+--------------+----------+--------------------=
-+------------
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig          =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/632346b235349c160b355644

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
27-g08cb13c1cfaa/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salv=
ator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
27-g08cb13c1cfaa/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salv=
ator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632346b235349c160b355=
645
        failing since 0 day (last pass: v5.15.66-119-g781f01e9677c, first f=
ail: v5.15.66-118-gc5dc57eebeef) =

 =20
