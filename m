Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA2959CDBE
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 03:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238929AbiHWBQp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 21:16:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237907AbiHWBQm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 21:16:42 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 341F85723F
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 18:16:42 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id y4so11483196plb.2
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 18:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=jqmay7w+hVxAmqeGN2+dTrk9+0I7ybnxw/l1Er2zBKU=;
        b=AcW+o84+7jp3CfFAfPb+unVYeoULBuLvXF924MCDIi7KLmrmAUVAnLqjRDlX/PP/DQ
         /rH33/HUcCJN2oliv+Gt8Ojtgj+kxiDsRSfZTdEuhYSAEE7q2KpSk4X4ngxs0iz1l0ZF
         McnNp0Qt/n9JLPYyQsBg38SnP72yCE9xQGldCYGR7qfeRB1WH0uv1wVzPi+JGyXh695q
         /gk1ZLjCg496PmQuNhxV8M7ncNQ1d/K1Hf+muZ2RInlRRVHUb6H+GEll2d1+y4j4grox
         /Y5x+g0cO9HKG7msduPg/gfJ4/boam81KPB0Kus7RcPHqIkZUXfvkj19+a45Q1iy6zL0
         ljvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=jqmay7w+hVxAmqeGN2+dTrk9+0I7ybnxw/l1Er2zBKU=;
        b=ZE9KufrUZfcrslHcISQ9xWhMjv7WsSvHy0o8hPW5V7Q6kxr74/yXZEU6eOy7EWlHUr
         aQgcl9khXWQ17Wppa2vsGGuYaVflE2IT2bHTVQLzhU55YVsSBCDep/a0P4nlnZuP4KcZ
         Ts9glF/kgVdOrzQ3hVudWzkXrI5fv/OnUeYNLvS6/wiCwNXH5FWd7qZM7dMGVbSk1mH+
         V+1hwQGroPS96Ja6QwAs0UWWho2mBcEQGAjKWB6InDa4sylfcR/otaLEPq8Xx0xiemi7
         RBXp5YA+lwLFaRd10n2px31qRnomuSfC5XVRkLnglkxehWNjWRe6wr6s6P9tgud6jiS8
         RXyg==
X-Gm-Message-State: ACgBeo0HFCPLSijuYYwy+T1CttyX3CVghssnSTI3eYsX74m1s8DIYK1a
        kKIU94XZ2knN05IoJ0ZYWoemV8+kzF69W90U
X-Google-Smtp-Source: AA6agR6bjGRtFtHdj6jLxcWueUoM4RWPSjN/mUeOsxcGAk2w8pJGvXiaqhqlgdaLWHhnSiEGhspApw==
X-Received: by 2002:a17:903:187:b0:172:f1c0:ff37 with SMTP id z7-20020a170903018700b00172f1c0ff37mr5649646plg.113.1661217401545;
        Mon, 22 Aug 2022 18:16:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o5-20020a170902bcc500b0016db6bd77f4sm9019353pls.117.2022.08.22.18.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 18:16:41 -0700 (PDT)
Message-ID: <63042a79.170a0220.65988.0aca@mx.google.com>
Date:   Mon, 22 Aug 2022 18:16:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.18.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.19
Subject: stable-rc/linux-5.18.y baseline: 143 runs, 4 regressions (v5.18.19)
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

stable-rc/linux-5.18.y baseline: 143 runs, 4 regressions (v5.18.19)

Regressions Summary
-------------------

platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
imx6ul-pico-hobbit    | arm   | lab-pengutronix | gcc-10   | imx_v6_v7_defc=
onfig | 1          =

kontron-pitx-imx8m    | arm64 | lab-kontron     | gcc-10   | defconfig     =
      | 1          =

meson-gxm-khadas-vim2 | arm64 | lab-baylibre    | gcc-10   | defconfig     =
      | 1          =

panda                 | arm   | lab-baylibre    | gcc-10   | multi_v7_defco=
nfig  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.18.y/ker=
nel/v5.18.19/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.18.y
  Describe: v5.18.19
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      22a992953741ad79c07890d3f4104585e52ef26b =



Test Regressions
---------------- =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
imx6ul-pico-hobbit    | arm   | lab-pengutronix | gcc-10   | imx_v6_v7_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/630417de1acca3d340355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
9/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6ul-pico-hobbi=
t.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
9/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6ul-pico-hobbi=
t.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630417de1acca3d340355=
643
        failing since 21 days (last pass: v5.18.14, first fail: v5.18.14-24=
8-g7e8a7b1c98057) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
kontron-pitx-imx8m    | arm64 | lab-kontron     | gcc-10   | defconfig     =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/6303f6a1f02733083c355650

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
9/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-imx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
9/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6303f6a1f02733083c355=
651
        failing since 6 days (last pass: v5.18.14-248-g7e8a7b1c98057, first=
 fail: v5.18.17-1096-g56bd9e4c28e9e) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
meson-gxm-khadas-vim2 | arm64 | lab-baylibre    | gcc-10   | defconfig     =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/6303f5430d6c60af2a35564f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
9/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-khadas-vim2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
9/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-khadas-vim2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6303f5430d6c60af2a355=
650
        new failure (last pass: v5.18.17-1095-g8e2f0ee8f479f) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
panda                 | arm   | lab-baylibre    | gcc-10   | multi_v7_defco=
nfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6304280a8c8db0272a355645

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
9/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
9/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6304280a8c8db0272a355=
646
        failing since 7 days (last pass: v5.18.14, first fail: v5.18.17-107=
9-gb280aa862bc2b) =

 =20
