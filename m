Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 815C25B1F9A
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 15:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231752AbiIHNuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 09:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231203AbiIHNuA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 09:50:00 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EADF38479
        for <stable@vger.kernel.org>; Thu,  8 Sep 2022 06:49:50 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id 65so7753259pfx.0
        for <stable@vger.kernel.org>; Thu, 08 Sep 2022 06:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=tEUk5tQ0wd49H0soMWeNCK13fPK5bpsSdfXuIiQ/EGk=;
        b=LGRlHX3QqNRH7fkqXhQCxSn5wPgem4aXd8nLRGBG3aZYHZzOqGQvwcM9WSxGRJncQo
         UIzWMc2S1WDUNvHNZ0hTTUfWVEtjNpb0jabbRHkH6u04jL0Cv72bcaJ9b0SFTePZSgjy
         eYd5NAL/QBez+fcJ2nUGyXPFQAoxnQkCjK7n964dyjVUuYA/gJUoeH5ltM8hr97t9iTk
         JIZSkdV1mVo9p6JQkzU5inRCNoFsuQ6qLuvzvcqQgdaHgXwdT1jjV1qa6Cyo6XIoy7Zv
         omWtpqINnkOtRhzCastx1RtPdIrD8GBGRtv9kBSwO6h2e0F+p2yYCXgBBALhmemKP8mk
         QBKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=tEUk5tQ0wd49H0soMWeNCK13fPK5bpsSdfXuIiQ/EGk=;
        b=I+Cl4lYPmKC65/HIlwoyAUaoz8BUzrAt5J80KWYD4u7HrK44AxZXd1mylAm22N0RPU
         SJfEQ5CG++pQ+v2Eq4XtOt64tJzVlycqHAkoOo/iwGg2JdgVVMHbI6IZ55GOvtddsxcR
         PaZ5FI9330kjvA0dCxvbKPb99FNroTck2U1tAJP9H6UfZJCpwOOAv2+6VmbjxhxsjIcO
         qDnpGCvnZpjTf+Z+Yz8QxQ3cLfDUgJdSaifEhlceZUR4Ftmh25aS7RFghoKE/unrWN/P
         ZvqHXW9SKEWeg3saSi3mD4dOl9c6VeOzw7tulpiBN05pg3Ng/KqrWbCdrRapKRwwbi05
         K7dg==
X-Gm-Message-State: ACgBeo0WGBcGzUacbP8WwDwK/bVH/Itxp6VmtntGRN5337KiwvHVp0m6
        1EmReQGrvnSwH9jo1FAqtJ3FacQ6NeVpgxcX3OE=
X-Google-Smtp-Source: AA6agR7kNQqw9Pum5AmLTtSjP79PbYgLBIGm4m+ShaljwcRSH46jeN2w3eT2LH9nxTWYwC6zgAMFkQ==
X-Received: by 2002:a05:6a02:281:b0:42b:748e:5d90 with SMTP id bk1-20020a056a02028100b0042b748e5d90mr7796578pgb.422.1662644989622;
        Thu, 08 Sep 2022 06:49:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nk21-20020a17090b195500b001f2ef3c7956sm1763364pjb.25.2022.09.08.06.49.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 06:49:48 -0700 (PDT)
Message-ID: <6319f2fc.170a0220.11ac1.2a79@mx.google.com>
Date:   Thu, 08 Sep 2022 06:49:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.19.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.8
Subject: stable/linux-5.19.y baseline: 201 runs, 5 regressions (v5.19.8)
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

stable/linux-5.19.y baseline: 201 runs, 5 regressions (v5.19.8)

Regressions Summary
-------------------

platform           | arch  | lab             | compiler | defconfig        =
          | regressions
-------------------+-------+-----------------+----------+------------------=
----------+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-10   | imx_v6_v7_defconf=
ig        | 1          =

imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-10   | multi_v7_defconfi=
g         | 1          =

mt8173-elm-hana    | arm64 | lab-collabora   | gcc-10   | defconfig+arm64-c=
hromebook | 1          =

qemu_mips-malta    | mips  | lab-collabora   | gcc-10   | malta_defconfig  =
          | 1          =

rk3399-roc-pc      | arm64 | lab-clabbe      | gcc-10   | defconfig        =
          | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.19.y/kernel=
/v5.19.8/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.19.y
  Describe: v5.19.8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      70cb6afe0e2ff1b7854d840978b1849bffb3ed21 =



Test Regressions
---------------- =



platform           | arch  | lab             | compiler | defconfig        =
          | regressions
-------------------+-------+-----------------+----------+------------------=
----------+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-10   | imx_v6_v7_defconf=
ig        | 1          =


  Details:     https://kernelci.org/test/plan/id/6319c9cd68e90baea335565f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.19.y/v5.19.8/ar=
m/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.19.y/v5.19.8/ar=
m/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6ul-pico-hobbit.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6319c9cd68e90baea3355=
660
        failing since 21 days (last pass: v5.19.1, first fail: v5.19.2) =

 =



platform           | arch  | lab             | compiler | defconfig        =
          | regressions
-------------------+-------+-----------------+----------+------------------=
----------+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-10   | multi_v7_defconfi=
g         | 1          =


  Details:     https://kernelci.org/test/plan/id/6319cbd59d2876519f355679

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.19.y/v5.19.8/ar=
m/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.19.y/v5.19.8/ar=
m/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6319cbd59d2876519f355=
67a
        new failure (last pass: v5.19.7) =

 =



platform           | arch  | lab             | compiler | defconfig        =
          | regressions
-------------------+-------+-----------------+----------+------------------=
----------+------------
mt8173-elm-hana    | arm64 | lab-collabora   | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6319c32dd774e8fb3a3556bd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.19.y/v5.19.8/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-mt8173-elm-han=
a.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.19.y/v5.19.8/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-mt8173-elm-han=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6319c32dd774e8fb3a355=
6be
        new failure (last pass: v5.19.2) =

 =



platform           | arch  | lab             | compiler | defconfig        =
          | regressions
-------------------+-------+-----------------+----------+------------------=
----------+------------
qemu_mips-malta    | mips  | lab-collabora   | gcc-10   | malta_defconfig  =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/6319bcc3302086a321355692

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.19.y/v5.19.8/mi=
ps/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mips-malta.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.19.y/v5.19.8/mi=
ps/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mips-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/mipsel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6319bcc3302086a321355=
693
        new failure (last pass: v5.19.7) =

 =



platform           | arch  | lab             | compiler | defconfig        =
          | regressions
-------------------+-------+-----------------+----------+------------------=
----------+------------
rk3399-roc-pc      | arm64 | lab-clabbe      | gcc-10   | defconfig        =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/6319bce438ba970a4035566d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.19.y/v5.19.8/ar=
m64/defconfig/gcc-10/lab-clabbe/baseline-rk3399-roc-pc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.19.y/v5.19.8/ar=
m64/defconfig/gcc-10/lab-clabbe/baseline-rk3399-roc-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6319bce438ba970a40355=
66e
        new failure (last pass: v5.19.1) =

 =20
