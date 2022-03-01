Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 083AE4C81B8
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 04:43:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231954AbiCADoJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 22:44:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbiCADoJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 22:44:09 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 608D661A1F
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 19:43:29 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id bc27so4439385pgb.4
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 19:43:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6quh4pJrpOw79M7NcqEowVXveRG6pDj7UjzyvOFJKTg=;
        b=7nXniPOkHb9v2/nQnJPWvtaJHhmOdCHRCG6nrNMd9OzRojBFvk0ibZISwJ+2l2nX19
         UwOYcmBny77Z6DiSN8cJ9ymPG7aoBFlFbkdv34geu5VzOVXypSYp5Bm9So/+JCleUuE6
         FExA1d1abZH3+G66XCu81Zy26+AMx5Uk9HMn9vB3Ud9sHiq4yqyORmG78OaMN/UbYa5R
         x1A4Qy2VIRbMXYa330f7y2SZNnARxdfzE6/Hdy5zk2oAG2X8tSUF0mGnPX3i+OUc/GgD
         ncPkT8GKB9zIbrWNY44yZEzq4ZYwqTUMAgqGIkFqloqntNwTMi733GZfZyMqViZngojb
         Myrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6quh4pJrpOw79M7NcqEowVXveRG6pDj7UjzyvOFJKTg=;
        b=V+GMKqAYk0342yhIQ3qgEbGtrBKiMkTcgfidcea5q5CDOchUWLIq7qW3qM0IYmPJFA
         ko9kenZmyez0z+qF2gWX5IMnXW8sEX2QhsllO9qvsdapk6RFix/iH6+hMqCyEivbPHYp
         v8joIOwpKwEx95lzXxNv74JzM6CmtxdEu09jUp+qWieZs2SSWy7dR0ruYGFO7tyWJmz9
         qtY7qlaVYwzfggwRCB4akPqG5UJurpngK0wbbApdKkkKN4QIsD6x+3dX5NagO6MuZgyu
         6GnOnETgFUSLOF/rKHcyWkLhjTDceC021WbIRuTZ/9hcduf7UNBRs7HLifeXITTzsxXt
         ZXUA==
X-Gm-Message-State: AOAM5322UNSgNL9paXQnaEMSc1sAjJSe4uCDkxm69I0KDndb+O4PBryw
        0EinzbUk6F8EektI2qsqeggWlxh3f8VfVtnqnK0=
X-Google-Smtp-Source: ABdhPJxpVmJtxv9gHfLoTqmQ82sgNMoN4EQSOODr70pK2sHgGfRvbbYSqgxWEEz6Zqb/tJbUWyDJMw==
X-Received: by 2002:a65:43c8:0:b0:378:7add:ec4c with SMTP id n8-20020a6543c8000000b003787addec4cmr10055541pgp.570.1646106208498;
        Mon, 28 Feb 2022 19:43:28 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g5-20020a056a001a0500b004def10341e5sm14809254pfv.22.2022.02.28.19.43.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 19:43:28 -0800 (PST)
Message-ID: <621d9660.1c69fb81.61437.69ae@mx.google.com>
Date:   Mon, 28 Feb 2022 19:43:28 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.268-32-g43ab82ea0bf0
Subject: stable-rc/linux-4.14.y baseline: 65 runs,
 1 regressions (v4.14.268-32-g43ab82ea0bf0)
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

stable-rc/linux-4.14.y baseline: 65 runs, 1 regressions (v4.14.268-32-g43ab=
82ea0bf0)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.268-32-g43ab82ea0bf0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.268-32-g43ab82ea0bf0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      43ab82ea0bf0a7b6afb31831af7cefaa3e21c9d6 =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/621d5f06dcc59452cfc62991

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
68-32-g43ab82ea0bf0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-mes=
on8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
68-32-g43ab82ea0bf0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-mes=
on8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/621d5f06dcc59452cfc62=
992
        failing since 14 days (last pass: v4.14.266, first fail: v4.14.266-=
45-gce409501ca5f) =

 =20
