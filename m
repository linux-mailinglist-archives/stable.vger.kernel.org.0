Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0546BC360
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 02:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbjCPBiy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 21:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjCPBiw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 21:38:52 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 613E091B6C
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 18:38:51 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id p6so210312plf.0
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 18:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678930730;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=yFQUMyHSdMyCVct642euZndyohnGhrb9A4PCSjA2K2Y=;
        b=SHA+bWIj59SVD1K7KeqXzdRajdhXkvDhfRr855c/fAe+3DsQLamSM0v1w7vE2XSluf
         +g1AGe5YTBLpeQYkXndsQW/XX7kevbzgp9GtIqVAi+dSEsN8hGe9KLUnmShhVOzGKLH5
         RJ8vT1vN8CAm6IhiF/SPf2bmqb3CtheyVGVo7xf4kwq4mXtFN/Z009A/kmykF72+PmnQ
         zn0Bw9boTMwFTTe5QEYtY6g3aTx6aRKEfsRirzcZIpjh0LeDlRS5ilFDl/ctyK4M83ht
         7PoVrCs+2/nARx1UKdqMLc1HaPpyqeDt34JkEeN7jegXclzC+EcSEZZJpQZM1syZ4TQ3
         FUnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678930730;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yFQUMyHSdMyCVct642euZndyohnGhrb9A4PCSjA2K2Y=;
        b=sHhUM3oQggC9zuxACqz/PMJUwAeL8Zkx8/MzzTCoX+FLLs6WlmlFE+CHfbOaqagELG
         wGHdMZjMcxUu46mGgBby9qpb1y4PEwcnh3vVqgty8rgNXs9lGYurSuvLp8e0+DwPVDqj
         va7OedqR3hg9s8+nkVLdagv/B7//K5pHZIxwSzCDh7DUeDobVcupTlGp7UMSo89pr+2A
         ucRMqnbMMHU055g7XxmbgyM/GnS6X7rEKmcn7LFdmDEnlF6+nDfotVZt41ZuKOC0t/+1
         TH1j5VZlaMQ+RxSXv+QbGz/yPukgzO7iXDybnBhUY3hjtJfvGfWH1G/1TTm5ymePqq4n
         s/mg==
X-Gm-Message-State: AO0yUKW89TEXrsOqEd0eDU2qdeffPGyrjEnpPY97O76NSuqcMxE9kqQn
        zwBEYaf6qZtE/XuUmc2QvasUeLMS56Rzo8nYZUJF3ltA
X-Google-Smtp-Source: AK7set/XizaWGdK6oCnaeMNuMODQDjg8v/UVA1agqu47dWidhAWHXPhpVese/6aL3Pd9PcfOlAepVg==
X-Received: by 2002:a17:90b:33c9:b0:234:190d:e636 with SMTP id lk9-20020a17090b33c900b00234190de636mr1930483pjb.8.1678930729985;
        Wed, 15 Mar 2023 18:38:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id kx15-20020a17090b228f00b00231224439c1sm1301544pjb.27.2023.03.15.18.38.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 18:38:49 -0700 (PDT)
Message-ID: <64127329.170a0220.7c0e4.2f88@mx.google.com>
Date:   Wed, 15 Mar 2023 18:38:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.18-147-g17d91e680f61
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 117 runs,
 1 regressions (v6.1.18-147-g17d91e680f61)
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

stable-rc/queue/6.1 baseline: 117 runs, 1 regressions (v6.1.18-147-g17d91e6=
80f61)

Regressions Summary
-------------------

platform           | arch | lab         | compiler | defconfig         | re=
gressions
-------------------+------+-------------+----------+-------------------+---=
---------
bcm2835-rpi-b-rev2 | arm  | lab-broonie | gcc-10   | bcm2835_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.18-147-g17d91e680f61/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.18-147-g17d91e680f61
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      17d91e680f61dc69fda3858f463a17ddc96fa1e2 =



Test Regressions
---------------- =



platform           | arch | lab         | compiler | defconfig         | re=
gressions
-------------------+------+-------------+----------+-------------------+---=
---------
bcm2835-rpi-b-rev2 | arm  | lab-broonie | gcc-10   | bcm2835_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/64123c5739566c29088c8648

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.18-14=
7-g17d91e680f61/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.18-14=
7-g17d91e680f61/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64123c5739566c29088c867f
        new failure (last pass: v6.1.18-146-ge0f25c5308c10)

    2023-03-15T21:44:36.479319  + set +x
    2023-03-15T21:44:36.483721  <8>[   17.082366] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 169185_1.5.2.4.1>
    2023-03-15T21:44:36.598631  / # #
    2023-03-15T21:44:36.700724  export SHELL=3D/bin/sh
    2023-03-15T21:44:36.701361  #
    2023-03-15T21:44:36.803153  / # export SHELL=3D/bin/sh. /lava-169185/en=
vironment
    2023-03-15T21:44:36.803606  =

    2023-03-15T21:44:36.905209  / # . /lava-169185/environment/lava-169185/=
bin/lava-test-runner /lava-169185/1
    2023-03-15T21:44:36.906033  =

    2023-03-15T21:44:36.912494  / # /lava-169185/bin/lava-test-runner /lava=
-169185/1 =

    ... (14 line(s) more)  =

 =20
