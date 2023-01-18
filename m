Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A20EF672649
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 19:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbjARSGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 13:06:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231202AbjARSGV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 13:06:21 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E7F45B5A0
        for <stable@vger.kernel.org>; Wed, 18 Jan 2023 10:03:48 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id c85so23549325pfc.8
        for <stable@vger.kernel.org>; Wed, 18 Jan 2023 10:03:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=sdOUzWo1LC1BqmaR57HH1IqmjhQuepemk1ubcg4hyHk=;
        b=Sd0Z7REAnsBYFm4iCOthkQt9oPN176wuXOiNMR/VH7V8PnHx3j48JQaPs4pQpIOFt4
         ciNAXY5/l2xqwdgqE/ECgZnuz4wqopXYicFDita6MlVBgkTCR9m9EdS0Xp161+NBZJi/
         VNfbkJ6Dt5zqfQg24t+hnghqzGK/btvpcCjdeQTBlCGAaBCT2vrNQKu3yJUkFpCLoge3
         IwGMOO1AigoxumsN8HQjI6gK73fhou3qHV9JkcsbsQUF9ECVxW70ALq04MdtR8SVIwJL
         Bp04XKw19PrNAPyebdV6+eke9HJzDGy99W1fEEai+C2TvxSVC6qupwUs1hisfaWj+PAP
         E+GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sdOUzWo1LC1BqmaR57HH1IqmjhQuepemk1ubcg4hyHk=;
        b=FJJlxCTWHeANQnEd4GEfhEUV4VJsk6hdpVEB27xDN5I5ASHDOjKgIXYB1r+Z07Unas
         gVloAFzQkmp+7WKZ4GQat2wpbwagqb7qZHn4O4aUKhVrc03Iju7MwgiTkLSqIeWMk+e9
         ATN3c1wnKZ+3vseuB47/YReEVNtHdKKDlnMGRbZ9F6B9SYmYq2JEiUBRGsDO50YavJFD
         SnM2W/bC3gjUdU8os5XUEOJhsTxRWjotVyPXlH+HKByWu0pf2BZ28Bibes21FQKMDXUM
         lRsw/KEL6vYCGo9Jpog9AYuEUU9gko67CYI2r/87nQmXmpzni4fIRtJYWtHtUo0t3MDq
         ++vg==
X-Gm-Message-State: AFqh2koHYocUn3yz0sqpwEUXZFJHvlJTlcitAan9e7RkpI3XDzIZicxF
        fEtGaL5NlqNG4WamXIgGwrhiJvUzewU3Hf70dQnTiQ==
X-Google-Smtp-Source: AMrXdXv99DWqtNJ2szraFhAiYjZKSjOirAYGw9gfgM+62tR0YVjbeAi5aEs1g/RyYhRMEtU8e9hkBQ==
X-Received: by 2002:a05:6a00:1d23:b0:589:6338:9650 with SMTP id a35-20020a056a001d2300b0058963389650mr7646439pfx.5.1674065026098;
        Wed, 18 Jan 2023 10:03:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q20-20020aa79834000000b0058134d2df41sm21737745pfl.146.2023.01.18.10.03.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 10:03:45 -0800 (PST)
Message-ID: <63c83481.a70a0220.88384.32a2@mx.google.com>
Date:   Wed, 18 Jan 2023 10:03:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.89
X-Kernelci-Report-Type: test
Subject: stable/linux-5.15.y baseline: 221 runs, 2 regressions (v5.15.89)
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

stable/linux-5.15.y baseline: 221 runs, 2 regressions (v5.15.89)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig        =
          | regressions
----------------------+-------+--------------+----------+------------------=
----------+------------
cubietruck            | arm   | lab-baylibre | gcc-10   | multi_v7_defconfi=
g         | 1          =

qemu_arm64-virt-gicv2 | arm64 | lab-baylibre | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.89/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.89
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      3bcc86eb3ed952c22ceecce8932dde72ea01f8cc =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig        =
          | regressions
----------------------+-------+--------------+----------+------------------=
----------+------------
cubietruck            | arm   | lab-baylibre | gcc-10   | multi_v7_defconfi=
g         | 1          =


  Details:     https://kernelci.org/test/plan/id/63c83333272c479053915ed5

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.89/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.89/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63c83333272c479053915eda
        new failure (last pass: v5.15.82)

    2023-01-18T17:57:46.030486  <8>[    9.816915] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3158289_1.5.2.4.1>
    2023-01-18T17:57:46.141072  / # #
    2023-01-18T17:57:46.243117  export SHELL=3D/bin/sh
    2023-01-18T17:57:46.243679  #
    2023-01-18T17:57:46.345038  / # export SHELL=3D/bin/sh. /lava-3158289/e=
nvironment
    2023-01-18T17:57:46.345422  =

    2023-01-18T17:57:46.446758  / # . /lava-3158289/environment/lava-315828=
9/bin/lava-test-runner /lava-3158289/1
    2023-01-18T17:57:46.448540  =

    2023-01-18T17:57:46.453018  / # /lava-3158289/bin/lava-test-runner /lav=
a-3158289/1
    2023-01-18T17:57:46.542543  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform              | arch  | lab          | compiler | defconfig        =
          | regressions
----------------------+-------+--------------+----------+------------------=
----------+------------
qemu_arm64-virt-gicv2 | arm64 | lab-baylibre | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63c8058f5c55261dae916024

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.89/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.89/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c8058f5c55261dae916=
025
        new failure (last pass: v5.15.88) =

 =20
