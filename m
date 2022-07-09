Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC86B56C7A8
	for <lists+stable@lfdr.de>; Sat,  9 Jul 2022 09:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbiGIHOu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Jul 2022 03:14:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiGIHOt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Jul 2022 03:14:49 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BDB111A3C
        for <stable@vger.kernel.org>; Sat,  9 Jul 2022 00:14:48 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id s206so714597pgs.3
        for <stable@vger.kernel.org>; Sat, 09 Jul 2022 00:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=27/OLlGLafd2iBMZlGEqfAVSK4k1qvz1cy0qFwuCTTk=;
        b=OeVytV4hN/mbFu6gPXIO8I001wiYJxlQKHR4o1N+t243XpbAOYQy3at/yjHE5M9s4x
         CwB2ebs1e9cdB68nEUrCS6QLmT0rkQLC+QvOC12AwzdvaLBsHrCfCtH0+Nn1sI3vuJXh
         bRBJiJ9tY9BxOMJrJPWYS0yWX1oepuLhhL6J4G0a+BAsnwuYU3OTE9yLPf5hpsfpyYxN
         5qotq5rSzIbbxdo9dalaGYxQY3L01xEmpV07ChtTDHQ77rbGoi0by5ctInlMDmChH6pl
         M0U0/ujexSlnbaPWq2d2xgDrPRtXRkvlQvQumUeS/4SIY+990vaYPDuUmU07RUaEd5lQ
         eTHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=27/OLlGLafd2iBMZlGEqfAVSK4k1qvz1cy0qFwuCTTk=;
        b=NC3cEz7hLSQDu8syIxN3XHn+qwHEu2Me8Q7F921gF1Id4d1qvALmVJFoWs/MMEATZV
         A714XSRjeQHTeBGnOQ7JqUyf1pSzGvE6YcCDwxNs7eew4VMU5dBN72WZsXx4juDrhq3T
         p1wCDvKD4DhAVmk4jBxRqLMGJt9cYvgWGezpsbEDmig4TBSim8eWmNyhCcVVoOwJS43J
         3IyrLmFDIHfbSmAnHu5hRYwe0dXEHfggs9M3qDrEYuMtrYflAn+TNLtk1lRyL1+NAJ25
         zxZbL7bTpFUNzy8WUb2LEITknwUkSeGIt7wrhFc990y3obYW4G/MJVFlNl6CVBLBUJ+S
         eH/A==
X-Gm-Message-State: AJIora9HtDq6QeuRtj8JXxjDxQbMcDHwcxIGyhK2MwiY88fmFvJFMYy6
        mYuULFo7vCw/xSCHTDhqItZ5z2R1xf+JgB0a
X-Google-Smtp-Source: AGRyM1sHDYGfQROkUlcF8jFaJmLL5HKQ+LSvg3K5yD4TPNvI+UQzJ02i32sLdjh5wtMZt/vuA73RJg==
X-Received: by 2002:a05:6a02:18b:b0:415:c9d:4e3c with SMTP id bj11-20020a056a02018b00b004150c9d4e3cmr6481888pgb.580.1657350887426;
        Sat, 09 Jul 2022 00:14:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v18-20020aa799d2000000b0052ab5a740aesm755081pfi.162.2022.07.09.00.14.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jul 2022 00:14:46 -0700 (PDT)
Message-ID: <62c92ae6.1c69fb81.8c0d.1308@mx.google.com>
Date:   Sat, 09 Jul 2022 00:14:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.10-27-g3c635995cefa
X-Kernelci-Branch: queue/5.18
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.18 baseline: 92 runs,
 2 regressions (v5.18.10-27-g3c635995cefa)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.18 baseline: 92 runs, 2 regressions (v5.18.10-27-g3c63599=
5cefa)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig=
 | 1          =

jetson-tk1         | arm  | lab-baylibre    | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.10-27-g3c635995cefa/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.10-27-g3c635995cefa
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3c635995cefa4355748ac4d7f35948cd51cac88c =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/62c905ab112b791224a39bd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.10-=
27-g3c635995cefa/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.10-=
27-g3c635995cefa/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c905ab112b791224a39=
bd1
        failing since 3 days (last pass: v5.18.9-96-g91cfa3d0b94d, first fa=
il: v5.18.9-102-ga6b8287ea0b9) =

 =



platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
jetson-tk1         | arm  | lab-baylibre    | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/62c8f736e8bdcd3ff5a39c05

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.10-=
27-g3c635995cefa/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.10-=
27-g3c635995cefa/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c8f736e8bdcd3ff5a39=
c06
        failing since 3 days (last pass: v5.18.8-6-g365d872fd167, first fai=
l: v5.18.9-96-g91cfa3d0b94d) =

 =20
