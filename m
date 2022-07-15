Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36D2B57638C
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 16:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbiGOOVB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 10:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiGOOVA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 10:21:00 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4463F5C9C7
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 07:20:59 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id h132so4521467pgc.10
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 07:20:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tf8E8jT+MfwvxjgryQK/+y+a3E6fJoqY6d92RiJ2OJ4=;
        b=kFUsq4MggMw9ERPhBH4S4UIcHQVdF03T6x+AlIw7mSpLUUfDyi73hglvQavJhtiKnK
         m/+Hz8SWc92K0o3FBtKVhPkkI+oET24cGAch3APJVbA64N8qMeR02EiL/Iy9FkBuWxjf
         C0q65suEzC0UwBN0B4RIKc0JqnB7VvLgpYAZn8cKxryRHrkw6eQTgxdYcllvqiEPEF7n
         R0sMHHyNIZWDtShKg4tfSq7VAhPA/E11F2Lhw6Hiq8S2nnPXMrwR5MCGhjvBD097GYz0
         PxgjXBLKMM47KTVV/5gqiVbD80GUELXw/DfDgmrrhVZzz3mwSWNfRr0Xhk62epxbKJ2I
         j2Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tf8E8jT+MfwvxjgryQK/+y+a3E6fJoqY6d92RiJ2OJ4=;
        b=v7R5SBgnwiDhj6w+6Wkoyu9HEY8eGsQiVLf67PX5GeCp4oTNw0ayQ/nxIMohZDzA9P
         OgAjs/im2dAGikXUvnKoPUvMg/9QlbrkvloDrBQVb6VMQyO6bzq1Y9BTyS059lkWBdcy
         aPDotYXhVGx+30KZywWtneREtSTufpTErX5sn8c0rDfWbhw0knn96eqW66NUmTO+9134
         EfrnKja24DCryoFFRhkp1xKdjr7t3dwZnr1XAdeF05MQNqoR1Me5ZLJlV5JsQruGliQQ
         qwSaSTAyjW4pyucjjhqxLw/F5Q5fT2DdbgPvUZC5LGGuxCmaRIUdDc0tUAwwFYYZJKyn
         He+w==
X-Gm-Message-State: AJIora+fYK5iSKkfrRygsiWDJF5gqyh4v8tqE6KHxTASGUWMciqIe8oM
        aK/HaDuRF1kHR1kYFXDQjqiKAXWVjRSDbGjn
X-Google-Smtp-Source: AGRyM1sNSJLrxzH4z/4JNKlmCF5ueBpM6/3tuEoIbo0lxmWjhOyLAYx/9oClenRoSmD0lSltGHy7FQ==
X-Received: by 2002:a05:6a00:150d:b0:52b:1ffb:503f with SMTP id q13-20020a056a00150d00b0052b1ffb503fmr8047277pfu.27.1657894858647;
        Fri, 15 Jul 2022 07:20:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z15-20020aa79f8f000000b00518a473265csm3883791pfr.217.2022.07.15.07.20.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 07:20:58 -0700 (PDT)
Message-ID: <62d177ca.1c69fb81.7a67.5ffc@mx.google.com>
Date:   Fri, 15 Jul 2022 07:20:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.12
X-Kernelci-Branch: linux-5.18.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.18.y baseline: 93 runs, 2 regressions (v5.18.12)
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

stable/linux-5.18.y baseline: 93 runs, 2 regressions (v5.18.12)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_defconfi=
g | 1          =

jetson-tk1         | arm  | lab-baylibre    | gcc-10   | tegra_defconfig   =
  | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.18.y/kernel=
/v5.18.12/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.18.y
  Describe: v5.18.12
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      c2e9702659dfc309dfda6116da48f200fe425aab =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/62d1498772e227a6b5a39be3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.18.y/v5.18.12/a=
rm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6ul-pico-hobbit.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-5.18.y/v5.18.12/a=
rm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6ul-pico-hobbit.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d1498772e227a6b5a39=
be4
        new failure (last pass: v5.18.11) =

 =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
jetson-tk1         | arm  | lab-baylibre    | gcc-10   | tegra_defconfig   =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/62d1489034c5e790d4a39bfd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.18.y/v5.18.12/a=
rm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.18.y/v5.18.12/a=
rm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d1489034c5e790d4a39=
bfe
        failing since 46 days (last pass: v5.18, first fail: v5.18.1) =

 =20
