Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 022DD588F4D
	for <lists+stable@lfdr.de>; Wed,  3 Aug 2022 17:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236253AbiHCPXw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Aug 2022 11:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233041AbiHCPXv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Aug 2022 11:23:51 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D495FDB
        for <stable@vger.kernel.org>; Wed,  3 Aug 2022 08:23:50 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id v18so16679403plo.8
        for <stable@vger.kernel.org>; Wed, 03 Aug 2022 08:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wHlyfe/qddzJgZodPwhB5N7keQXRJ428nFsOpAN6VR4=;
        b=wke0ySd+p+uYuOsqtrwMiWoI8u9DGHU5nZtJsfA6BRlDkecdZZfZcFq+4k3J8CZEZK
         8ZJPRCEWXSzu3JhwjyDqNv+XvvSnmeDPBfvT1nQfoVcOdzU8bbD1xNcH4yszZs6pKRzV
         rw96uO5EJ159iuq+sX8q5ikHskAHc3vBxTD+ZOXwszS/rCxjtJQA1DdJ4eaNfr6l/NBg
         w7SHWo9N3gAmdP3cgiy6pm+/R+hk6fzhxl0ZbZ8Q8In8SdY/9VtNJWPbND0yTfBcLd6S
         hdCVg00xm3BaakDfo1mVgtpdQCZyARfRIeQz40+L+BvLffK8EcI+ACgTUuv868bI5jAc
         /rdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wHlyfe/qddzJgZodPwhB5N7keQXRJ428nFsOpAN6VR4=;
        b=1yeGCGh6rd32L0fpUIXMMhDWPvJu23Bm/E+itlNOKbYJKzgAOkjVJwKXsYcQN5+KkT
         G3574aMH1U47ZWnQzMHUlseBYkJBqKW5gvumoiNjDuKvtaIjtDp0E2AbdRDD3PEFKmUz
         ULY3yJ2Z8RhregeWLyS9RxnSbfL9v8XpstzWID116P98gWOPEObSWR4FvP0naJVh131Y
         pR72kg6DcKj3GQYVJywiNVkAMPI+sykp+eZOGP/5k83niWHsnXGBVV4wYpC1e1dJX+41
         eQJaVz1iVDJ6JwnEkQrGdvx9wZkXySM76MD0oeeB7DKTiDzApMjcxHGd5ObMZUp3fPli
         iTiQ==
X-Gm-Message-State: ACgBeo0+jA+ZXdHuqwwS7JH3wK+9gtQEGmV+h4grPpEA6XokHVZjK4iE
        2//7GP0BcBssL77MVXY7KQpu5WCiPn2vy7ra54k=
X-Google-Smtp-Source: AA6agR4yTYRPnON+B7nZo1lBl3b+TpsvfoLAxUeZtyWEhDswk8d19BWVRAJMnrFNtzZLOkGhMPVeUg==
X-Received: by 2002:a17:902:ba8e:b0:16d:9ecb:d1c1 with SMTP id k14-20020a170902ba8e00b0016d9ecbd1c1mr27457811pls.53.1659540230150;
        Wed, 03 Aug 2022 08:23:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q5-20020aa79605000000b0052d16416effsm9699743pfg.80.2022.08.03.08.23.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 08:23:49 -0700 (PDT)
Message-ID: <62ea9305.a70a0220.1e5e0.f533@mx.google.com>
Date:   Wed, 03 Aug 2022 08:23:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.18.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.16
Subject: stable/linux-5.18.y baseline: 150 runs, 2 regressions (v5.18.16)
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

stable/linux-5.18.y baseline: 150 runs, 2 regressions (v5.18.16)

Regressions Summary
-------------------

platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6ul-pico-hobbit           | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig        | 1          =

mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.18.y/kernel=
/v5.18.16/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.18.y
  Describe: v5.18.16
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      8843bf1f0737ecea456d2bbd19d4263d49f2d110 =



Test Regressions
---------------- =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6ul-pico-hobbit           | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62ea6d050638926d97daf064

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.18.y/v5.18.16/a=
rm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6ul-pico-hobbit.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-5.18.y/v5.18.16/a=
rm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6ul-pico-hobbit.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ea6d050638926d97daf=
065
        failing since 19 days (last pass: v5.18.11, first fail: v5.18.12) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62ea5e3f1242c29be8daf0a2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.18.y/v5.18.16/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-mt8183-kukui-=
jacuzzi-juniper-sku16.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.18.y/v5.18.16/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-mt8183-kukui-=
jacuzzi-juniper-sku16.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ea5e3f1242c29be8daf=
0a3
        new failure (last pass: v5.18.14) =

 =20
