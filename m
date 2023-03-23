Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB7926C5CAD
	for <lists+stable@lfdr.de>; Thu, 23 Mar 2023 03:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbjCWCdU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 22:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbjCWCdT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 22:33:19 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D305E2CC6C
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 19:33:17 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id y19so11742126pgk.5
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 19:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679538797;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=WHRA7LVA+gHjzGR2ppLAHknbhoXczbTzGRhV59pwpsQ=;
        b=NfxIu1Y5fwho7l8vibLxZZ+bUcVSH661I79/8mKsnZ2m5mQxa6xUW+ZTz2Ytd0hDOV
         mP3DKwjXbsAeEk8Jx61dLf8CmG0S4Tz9GUwcOaD3BZbupcSkSLsFEZ2Zkn+jPM5WSJrk
         PRUh7mDODD1iWtPD+m+d0Iyr/d+m1uHboHUjzbAFB2uTpk3IDZSfRbqupOBkOjDL590s
         LCighNA5VoKprTx//bBqvFcaGuDqFkD+hChUT/SRiEGzw+zXL/0aZNGukQ925evVJuOW
         Jusy5iJI6PtRFWexe0gaAR3K2/EbgRVi3AAYjbSrqikwSNRJ1kI/VtjcyvU1LhQo+ICu
         64uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679538797;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WHRA7LVA+gHjzGR2ppLAHknbhoXczbTzGRhV59pwpsQ=;
        b=y2d1IDxbv4+zG1NF6wsdfXVlfKZIrZ+WdTOSHc1fTZFx6WISz0XWPmloEtYn4r2uT5
         59Gqg7pSmLBMWtY/0owiPTtCrx4WWQKwYXwUe38/bTBZtPLnwDyoWRN3B6t8QhWHQl5+
         0XPUMsuYbMbtJiTPEYDTL5Kja0ogRlEanI27Z9wxBhgULNbYerf81dd+RobdYxvv7uQl
         SOJKDfRupfZP32Al2GAt+fgugAZH4UXIcOESOECYD+34XfgDnAfS29SfLK9J/Jo4EPSr
         eYX9HYizk9HPix0FELixZkzT+xwe8i8ikKhJbgqBtcuK3BNmKOXwSusUqfFLq4/QHrcx
         Fx8w==
X-Gm-Message-State: AO0yUKVOTY+q1geNNbzkftn+mKbOOyqgsFJBRV1HI3IiPYXaGwsBA+ko
        1GiviuH2xCAKaguqq4ryPbGhQ7b4KeeT542r9Lf4GA==
X-Google-Smtp-Source: AK7set+rW+jHPB7r3f5RnnZIk9sj5Rj/mBB/O/wqFhsNaaqagN9O48EtNwCCQv17/w2dtg4p9oM3fA==
X-Received: by 2002:a62:8442:0:b0:627:ead2:95b4 with SMTP id k63-20020a628442000000b00627ead295b4mr4576532pfd.3.1679538797069;
        Wed, 22 Mar 2023 19:33:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t13-20020a62ea0d000000b005a87d636c70sm10696650pfh.130.2023.03.22.19.33.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 19:33:16 -0700 (PDT)
Message-ID: <641bba6c.620a0220.8fb2f.3fe1@mx.google.com>
Date:   Wed, 22 Mar 2023 19:33:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v6.1.21-10-g0866b93e23cb1
Subject: stable-rc/queue/6.1 baseline: 184 runs,
 1 regressions (v6.1.21-10-g0866b93e23cb1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/6.1 baseline: 184 runs, 1 regressions (v6.1.21-10-g0866b93e=
23cb1)

Regressions Summary
-------------------

platform           | arch | lab         | compiler | defconfig         | re=
gressions
-------------------+------+-------------+----------+-------------------+---=
---------
bcm2835-rpi-b-rev2 | arm  | lab-broonie | gcc-10   | bcm2835_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.21-10-g0866b93e23cb1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.21-10-g0866b93e23cb1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0866b93e23cb1d66eb4b105d305cdb185ca17b7d =



Test Regressions
---------------- =



platform           | arch | lab         | compiler | defconfig         | re=
gressions
-------------------+------+-------------+----------+-------------------+---=
---------
bcm2835-rpi-b-rev2 | arm  | lab-broonie | gcc-10   | bcm2835_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/641b85c2646f1b27d69c950a

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.21-10=
-g0866b93e23cb1/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.21-10=
-g0866b93e23cb1/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/641b85c3646f1b27d69c9541
        new failure (last pass: v6.1.20-199-g4e63f82cdfbd)

    2023-03-22T22:48:09.514467  + set +x
    2023-03-22T22:48:09.518174  <8>[   18.118780] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 211298_1.5.2.4.1>
    2023-03-22T22:48:09.634141  / # #
    2023-03-22T22:48:09.736500  export SHELL=3D/bin/sh
    2023-03-22T22:48:09.737083  #
    2023-03-22T22:48:09.838603  / # export SHELL=3D/bin/sh. /lava-211298/en=
vironment
    2023-03-22T22:48:09.839144  =

    2023-03-22T22:48:09.940511  / # . /lava-211298/environment/lava-211298/=
bin/lava-test-runner /lava-211298/1
    2023-03-22T22:48:09.941391  =

    2023-03-22T22:48:09.947374  / # /lava-211298/bin/lava-test-runner /lava=
-211298/1 =

    ... (14 line(s) more)  =

 =20
