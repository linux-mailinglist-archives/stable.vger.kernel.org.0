Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 481096C9D7F
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 10:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232515AbjC0ITp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 04:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233053AbjC0ITY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 04:19:24 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383B6449E
        for <stable@vger.kernel.org>; Mon, 27 Mar 2023 01:19:23 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id fd25so5023896pfb.1
        for <stable@vger.kernel.org>; Mon, 27 Mar 2023 01:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679905162;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=i9mX7Sq/EfFfuRFUA5QSZuuPrDDl1DNdzkj2U9kpne4=;
        b=Ihhp8GAZgo2NyuNT811zziyToBWgmtRzHNTUJVXkSmljaWzlSZtrkuP1BHT2VxGrWg
         r8k+zWuJTl+0Xdrn/VYHqTcr8SjjCPEZhT2YildGbjjixtLo9OTLoxQawUg6EYK1le5A
         r+0ZeJW+MlbCxoMmJ9ixb89kh5DXiip+hDtI3wYSUTMz0ywZDCJ1D2zF5x0BC4l2PA1i
         x6yG4+QmQLNI8LPQqFjoXz49liXaFMGci3QqDvr9kE+PqbxX/uthaxCIemsV+Suy7CQh
         ztcOjUKncc3DkT5JDMROLcH9V2SoNe6NjZhPcLzLDqjYtFDzsdSgJqd3Jbb4UxPmt8Sy
         yXuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679905162;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i9mX7Sq/EfFfuRFUA5QSZuuPrDDl1DNdzkj2U9kpne4=;
        b=vcp0PMh4lxJdEs4P+ZA3JT/JLDHhTZS/p8wBzZE0zq8Yg6FE5eY85NJzs866YQkH4k
         bPsRGi/6krmSOj2NRJWyp5WyoX+q8tOx8bi+nCRgS8yZybW+lhNHMQBoHZbrskDLeH7+
         SVqyXqptLBf8+TDL7yxIS1oQp4IAw5tVgkEYqU2kJ+yFWZWecihjYcTxDbROjC2XDNxd
         hDnWYRTV+KdIbAjydbbJkJ0Jtite34kgsSXldg7cTp5w7O72Dro20MRq+O99I2C8gesR
         tZCJi69mE7Sb9r1ejWL+feCbaWF6dwCrTpk4UwiB2aZRW5OrYaehirCBMpHDiClmJrKQ
         uTvw==
X-Gm-Message-State: AAQBX9e7bKW4lD22xI42mbGNsGXtVurljQCab7JJ8K0NZ9SRbYVh25p7
        z1eoCGE8aLRY9kf5UyI4n7mKtjImSuExR9WZl/A=
X-Google-Smtp-Source: AKy350aEkq+8hElda8odKPdwUbLldR/v57buLjf44Cul18WtJWdwWq1W4ihPH87KDsqTMkl6ICqiEw==
X-Received: by 2002:a62:1c4e:0:b0:626:2984:8a76 with SMTP id c75-20020a621c4e000000b0062629848a76mr10212817pfc.34.1679905162481;
        Mon, 27 Mar 2023 01:19:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n3-20020a654883000000b0051322a5aa64sm5545081pgs.3.2023.03.27.01.19.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 01:19:22 -0700 (PDT)
Message-ID: <6421518a.650a0220.46fca.8f16@mx.google.com>
Date:   Mon, 27 Mar 2023 01:19:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.104-74-gbea1fcdf92c2b
Subject: stable-rc/queue/5.15 baseline: 115 runs,
 2 regressions (v5.15.104-74-gbea1fcdf92c2b)
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

stable-rc/queue/5.15 baseline: 115 runs, 2 regressions (v5.15.104-74-gbea1f=
cdf92c2b)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig           | regress=
ions
-----------+------+--------------+----------+---------------------+--------=
----
beagle-xm  | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1      =
    =

cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.104-74-gbea1fcdf92c2b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.104-74-gbea1fcdf92c2b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bea1fcdf92c2bc3de1a0103e471fabb42c32244e =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig           | regress=
ions
-----------+------+--------------+----------+---------------------+--------=
----
beagle-xm  | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/64211d0f8daf9cccde9c951a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-74-gbea1fcdf92c2b/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-74-gbea1fcdf92c2b/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64211d0f8daf9cccde9c9=
51b
        failing since 51 days (last pass: v5.15.91-12-g3290f78df1ab, first =
fail: v5.15.91-18-ga7afd81d41cb) =

 =



platform   | arch | lab          | compiler | defconfig           | regress=
ions
-----------+------+--------------+----------+---------------------+--------=
----
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/64211b70c637544dd39c9505

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-74-gbea1fcdf92c2b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-74-gbea1fcdf92c2b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64211b70c637544dd39c950e
        failing since 68 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-03-27T04:28:16.328401  <8>[    9.989345] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3448060_1.5.2.4.1>
    2023-03-27T04:28:16.440209  / # #
    2023-03-27T04:28:16.541918  export SHELL=3D/bin/sh
    2023-03-27T04:28:16.542305  #
    2023-03-27T04:28:16.643649  / # export SHELL=3D/bin/sh. /lava-3448060/e=
nvironment
    2023-03-27T04:28:16.644409  =

    2023-03-27T04:28:16.644889  / # . /lava-3448060/environment<3>[   10.27=
3101] Bluetooth: hci0: command 0xfc18 tx timeout
    2023-03-27T04:28:16.746762  /lava-3448060/bin/lava-test-runner /lava-34=
48060/1
    2023-03-27T04:28:16.747258  =

    2023-03-27T04:28:16.752195  / # /lava-3448060/bin/lava-test-runner /lav=
a-3448060/1 =

    ... (12 line(s) more)  =

 =20
