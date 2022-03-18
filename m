Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 661674DE4A3
	for <lists+stable@lfdr.de>; Sat, 19 Mar 2022 00:49:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241551AbiCRXuw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 19:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241568AbiCRXuv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 19:50:51 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D30BD72E11
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 16:49:31 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d18so8296207plr.6
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 16:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WAHN7R+MF0ykpmKSvI3/5XsDIe7BquDTnP+pb7D9CwM=;
        b=N6BGOE7iw/nIBQ1ghUe6NIrDmEnQmzpB3qb6TJ7ACJjmhWpwgcjaFJsdAMkjf97bPY
         plsjo7rG7Ahw3TMKDAEbNLM/GrbYG500RFL6H5CtSLUblcCSURGRCN54XFNefXvMK6YR
         YF+5vVLnS/UJ62DjiwSr11fm65eTZI17Ai/dZOVtcJ0nQPTjyw7NTAeCqO/4ItoNxG1q
         e2rtYYH9gwUcI7kXuDGuqPqXggZEkoJeO/WNUGWqKJsscmNpW06DDUvsUDxg5aVrpI2k
         uXMCTzk6liruE+dtttdN0ex5IPD0nQI/7BHcL5xZc35Ee1qkVHYFOfRrSajIhuE26xlz
         4oZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WAHN7R+MF0ykpmKSvI3/5XsDIe7BquDTnP+pb7D9CwM=;
        b=Xz61isgpnWeBzoZJEXLXOfnrPgQwYcT+C0xvfF9QAQTY6HJd1uU8Ix0cSzGeDNIhSO
         t/XYf9FKtbqSf1Ri76p7gGdipPsO4l/9nnW6ZUvDOBGSQAOIUv4NkUy/dyD+kMZCxJEK
         yreeM9/woSOduQb7N6Mz56vY1aqWP202azqM09rHS3HCwnkq9h9CZvaME20n6QEl3Avq
         H/2R72NRRh9vrxoz7ufmlFAe/0lm4IE8+KmqMKB5WXG/gGdx0cyLKzgRJRKcETFJ1UYw
         o8fLptKiPt4DSDMiJbUgCERw1v/PxdWLOiKWlSggR4dAMOsPAnyXOUIjJ3Ty4XLyoDHt
         rPmw==
X-Gm-Message-State: AOAM5311xy5M54HXeRldxpp/mGPoEqv9VWMdn2HWFnwDUIgMLOjzkKVr
        E4QdznV6I4Kpghti35INkfJnMQGuYnAOkpFQtCg=
X-Google-Smtp-Source: ABdhPJx3rTBF1CMydkYeynIK0yAORD/9KEq4dEPWrDU2GZTG784kwC5tuCxqAr7EM+kTaRY8bf7UuQ==
X-Received: by 2002:a17:90a:1a:b0:1c6:c1ee:c3fb with SMTP id 26-20020a17090a001a00b001c6c1eec3fbmr4207631pja.50.1647647371131;
        Fri, 18 Mar 2022 16:49:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t6-20020a63b246000000b0038085c0a9d7sm8205072pgo.49.2022.03.18.16.49.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 16:49:30 -0700 (PDT)
Message-ID: <62351a8a.1c69fb81.5db8.69e9@mx.google.com>
Date:   Fri, 18 Mar 2022 16:49:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.235-21-ge7df6a4ce347
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 62 runs,
 1 regressions (v4.19.235-21-ge7df6a4ce347)
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

stable-rc/queue/4.19 baseline: 62 runs, 1 regressions (v4.19.235-21-ge7df6a=
4ce347)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.235-21-ge7df6a4ce347/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.235-21-ge7df6a4ce347
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e7df6a4ce3472dfe453bbdd9877ecedcaf2d3c6c =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6234e4e58289d34f03f8006f

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.235=
-21-ge7df6a4ce347/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.235=
-21-ge7df6a4ce347/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6234e4e68289d34f03f80091
        failing since 12 days (last pass: v4.19.232-31-g5cf846953aa2, first=
 fail: v4.19.232-44-gfd65e02206f4) =

 =20
