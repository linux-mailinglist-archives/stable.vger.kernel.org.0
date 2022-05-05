Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B594551B781
	for <lists+stable@lfdr.de>; Thu,  5 May 2022 07:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243665AbiEEFmp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 May 2022 01:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232594AbiEEFmp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 May 2022 01:42:45 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B9C11FCC3
        for <stable@vger.kernel.org>; Wed,  4 May 2022 22:39:07 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id w17-20020a17090a529100b001db302efed6so3172624pjh.4
        for <stable@vger.kernel.org>; Wed, 04 May 2022 22:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1H8C9xyx7+wSojj1ARL96J9naw2qPW3GPg+4cuQjutE=;
        b=vVjXWyTsz03aaekaTp68Gti9rVYMo5QbrwEp6V1pLUFpjrDJnguW3UJolc/LbcfdL8
         cGdTrXw7sJrf2z6dkIpPYU5q/9ioewqzW0sIu8ADz3FcIJi3gjQutJMB5Rz4CUy+OzWb
         W3un39JCbMBDd8/BGiK8eaAFByAAsjfwL9woWKoKMDnOrJcMWx3NRp9+zFI31knSQsON
         HyXkGAAkt6nXgS1LVTtVlah6Xa0DrzH2I99kXKpBXIcc0SrkG2eOplSz7HuQioQfGFIc
         Kt+rlmTp177/ZYLG7ju7828juO8ZcwU3QNL00C0jQabrZpBz8nVqcjvEs+yaGBEawO6/
         NIIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1H8C9xyx7+wSojj1ARL96J9naw2qPW3GPg+4cuQjutE=;
        b=GNAvHku/8o5Lfs/oH0dR2saAxlBgzPiD8n0U8+iQZTUqKUl2JW47BCVcToWo/FuMe8
         tEvy6qiA0vXwDns1XdVsM2gO52EkuhA09z5oWkmYER8zg0JnBvEQNcB99mJKg6gZ+SIt
         MfCQweM9N8d62oiJ6GCy8HprrHpezY0+ZtXntgKiplYvtip/teTfrsSa8Wr9nJwnL+mq
         NasxXP1nliq2upLndDz986rgipi978KKUVIPZqkKgz0flV2lP8y/ZAtSaxO+D88weCWi
         NusRkCMMgGpmaOHcrJHSprxzwHTUYNr6Yh1QD5WOAAeZaIGj1nRBzAK9L/bLOGyybkRl
         uwUQ==
X-Gm-Message-State: AOAM532Gof8O4AgbgE41PgKtzxqiOcCK8+KE6X+e+WVZGvPeG9pYsBg+
        lljn9UMZrn0IcQjFc2wZ2Y5kyrM0UWIlkBg+ozc=
X-Google-Smtp-Source: ABdhPJzVcaYHvLCUphRqk3CAFnHNy7PRId8MxlmAtd6XTAW3JLkq48g2iKesTIiu2j+TdNswVFykiA==
X-Received: by 2002:a17:90b:4b83:b0:1dc:5073:b704 with SMTP id lr3-20020a17090b4b8300b001dc5073b704mr4115119pjb.94.1651729146528;
        Wed, 04 May 2022 22:39:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v22-20020a636116000000b003c14af505fdsm386358pgb.21.2022.05.04.22.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 22:39:06 -0700 (PDT)
Message-ID: <627362fa.1c69fb81.1104d.1038@mx.google.com>
Date:   Wed, 04 May 2022 22:39:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.277-54-gf277f09f64f4
Subject: stable-rc/queue/4.14 baseline: 86 runs,
 2 regressions (v4.14.277-54-gf277f09f64f4)
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

stable-rc/queue/4.14 baseline: 86 runs, 2 regressions (v4.14.277-54-gf277f0=
9f64f4)

Regressions Summary
-------------------

platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie  | gcc-10   | defconfig =
         | 1          =

meson8b-odroidc1             | arm   | lab-baylibre | gcc-10   | multi_v7_d=
efconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.277-54-gf277f09f64f4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.277-54-gf277f09f64f4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f277f09f64f4c026bc67d2887bbf7578c0c32861 =



Test Regressions
---------------- =



platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie  | gcc-10   | defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/627331eb78995f11c08f571e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.277=
-54-gf277f09f64f4/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s90=
5x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.277=
-54-gf277f09f64f4/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s90=
5x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627331eb78995f11c08f5=
71f
        failing since 16 days (last pass: v4.14.275-277-gda5c0b6bebbb1, fir=
st fail: v4.14.275-284-gdf8ec5b4383b9) =

 =



platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
meson8b-odroidc1             | arm   | lab-baylibre | gcc-10   | multi_v7_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/627331a266fc9d37b38f573a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.277=
-54-gf277f09f64f4/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.277=
-54-gf277f09f64f4/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627331a266fc9d37b38f5=
73b
        failing since 80 days (last pass: v4.14.266-18-g18b83990eba9, first=
 fail: v4.14.266-28-g7d44cfe0255d) =

 =20
