Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D58CD5002D2
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 01:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232053AbiDMXyX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 19:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235309AbiDMXyX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 19:54:23 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9192A541B2
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 16:52:00 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id l127so1627507pfl.6
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 16:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zIbrUuxzUK4ACFbGpftHxKSN3hcjXZy1pixgvMD9pJY=;
        b=niPHbVmzQd3v9MWESt3s4k5FJcDMMCq6OWqtJNVZx3M6UdE5MlOHNIWjt9YbliKDdm
         JxNf2ZhW5jJ90s1Iyf9I5GBougDHjx/hEjJsFk5HT3ehFliLtQ2hNhgclp9VOsmWSWQd
         btmedpWV4BjoweZTU0PRUHdvUGmTBxev5SFAArBYjzN7sUHvycJfXM7fw3A4XgDaWnml
         Q1cgONvcQEeFISv3ojv1yi8ojfO6p4p6lXstAeEPTQUS6VusO9BKD9w3H7q3Pa91gVKS
         pP9GhJaKjehO2+2oR18n3OoJOoP807MVv3tqVO+DOmKaehLPhMylm3qWa4hD5ON9gu/G
         Ct1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zIbrUuxzUK4ACFbGpftHxKSN3hcjXZy1pixgvMD9pJY=;
        b=cyJm8p9Uy8fatNFVGVWXxu/lYPnqkDMra6BjzLfV+acPQSBF1EGoVLybtFkIQO6WT4
         cRnUnicg5V0wZw+F6Fboe7C8JyHkRjgyYvzSyS7+OtH9YvrFv4zrXnM3W8Q8Z/W31lRY
         oV1Rn794yrAHMaSC1TzB4Kzt1cehKzjmWUXT7l/ifG07Aowvq5Cnh0URCdl362qkEnee
         Zo+RYQ1hQmWcdWrXAbSinxLorlsoB6/aMAsHnQwHzqQ8zxroOjRrHJEbCUGCaExvbxiO
         c7UJE+yxI2x7ZuibzPA9hSIDJPdrAqg574FSDt1OWdxacWLhaeYZYssrZFCYV6YlZ2dX
         Hqmg==
X-Gm-Message-State: AOAM533L5tWbJ+fXLQGjBHaVumSZ0c7q3GfGvF4dvl+OSdqKn8YT0Ja1
        VDqx3Fri9eCNwW2s12JQOuPZL4aNeK94z+29
X-Google-Smtp-Source: ABdhPJwiqzgMENduao1l9UJl1Eqy5QaqJ8A2exhUHKTXob66fkQfPjIk3Eb41e/pH6P+jWHwowSx3Q==
X-Received: by 2002:a63:9203:0:b0:386:3b37:76b5 with SMTP id o3-20020a639203000000b003863b3776b5mr63588pgd.234.1649893919913;
        Wed, 13 Apr 2022 16:51:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k14-20020aa7820e000000b004f7134a70cdsm194646pfi.61.2022.04.13.16.51.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 16:51:59 -0700 (PDT)
Message-ID: <6257621f.1c69fb81.2996f.0ca3@mx.google.com>
Date:   Wed, 13 Apr 2022 16:51:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.17.y
X-Kernelci-Kernel: v5.17.3
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.17.y baseline: 89 runs, 2 regressions (v5.17.3)
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

stable-rc/linux-5.17.y baseline: 89 runs, 2 regressions (v5.17.3)

Regressions Summary
-------------------

platform      | arch | lab         | compiler | defconfig          | regres=
sions
--------------+------+-------------+----------+--------------------+-------=
-----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | at91_dt_defconfig  | 1     =
     =

at91sam9g20ek | arm  | lab-broonie | gcc-10   | multi_v5_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.17.y/ker=
nel/v5.17.3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.17.y
  Describe: v5.17.3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      77b5472d00d158866e2e1d03c13862b428b65405 =



Test Regressions
---------------- =



platform      | arch | lab         | compiler | defconfig          | regres=
sions
--------------+------+-------------+----------+--------------------+-------=
-----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | at91_dt_defconfig  | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/62572ae5741b3b7236ae06a3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.17.y/v5.17.3=
/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.17.y/v5.17.3=
/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62572ae5741b3b7236ae0=
6a4
        new failure (last pass: v5.17.2-344-g66349d151ef98) =

 =



platform      | arch | lab         | compiler | defconfig          | regres=
sions
--------------+------+-------------+----------+--------------------+-------=
-----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | multi_v5_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/62572c393eab180e5fae069f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.17.y/v5.17.3=
/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.17.y/v5.17.3=
/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62572c393eab180e5fae0=
6a0
        new failure (last pass: v5.17.2-344-g66349d151ef98) =

 =20
