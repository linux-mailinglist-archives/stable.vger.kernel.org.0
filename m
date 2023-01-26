Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0B8767CB9E
	for <lists+stable@lfdr.de>; Thu, 26 Jan 2023 14:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232982AbjAZNEm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Jan 2023 08:04:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbjAZNEm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Jan 2023 08:04:42 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 248F45B9D
        for <stable@vger.kernel.org>; Thu, 26 Jan 2023 05:04:41 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id t12-20020a17090aae0c00b00229f4cff534so5823609pjq.1
        for <stable@vger.kernel.org>; Thu, 26 Jan 2023 05:04:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=k06ex/Fn9hneSrcZRv648FlpUhfH4vf+ppqJ63T53xY=;
        b=rB/6HNdcZh8oMkYD1MUdqWRE1E/su6b64EsBpin3YHhDtOHMlrydsmZZvdR6UVEQpX
         NyaoyVU298X7GR5ZQPw4I7xlZjj+ICuY+c6XGaJe7MKnuSjWJtbPG9nAJvOlP/YC+APR
         AJAB/3KTAqtbfstODO91AzPJ3OD/SmD0TFR12Chpw8hfDNW8IkTfznHch34Mvk4brX/j
         guVDLtDDuaNUaGjW0LlhP1pafxspzUkIwY+8Ye0Cm0vlZ2u/U7lSzitFFErBmcVmrTSF
         Pgx14gw7Gi3d4Qt8C8Tdjg0cnDdsS21Tli+MRnzjfIPxRKH08+jicolsPsMp+sSsP5Qs
         hf8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k06ex/Fn9hneSrcZRv648FlpUhfH4vf+ppqJ63T53xY=;
        b=4oiNUjwD+K6eR2cetXXrCUrORbRcHqp3Tn+vmarSFpkab6nNLWp0UWLMSYpqD6SNeQ
         I6w6yPlw8RazMixVY5a2dO3oZww2xlSZI/RoXNSMozepIp9fhTlGquzyzY7ryi3eqhGQ
         sqJfJyoASkvcumXCvR4VzQDmx4iX4dxv0rtC34Bqg+8W5O+r5qhrQH3moLYmZGzxLIsA
         eHW0+wEIB1benVjSRJ5hnSvYWeMEz0bOfNw3zB6AO6Ei1pl/PBoWs0yZrA+DbpNs9EES
         6s5AEy5ZtAlWBCZgjPHNYOBQL3QXEF70FIraFm+mGDSByhmYu7NrgrgskPO0LxjymwiH
         5Gqw==
X-Gm-Message-State: AFqh2kokjJqcqL2zBuT6Z+bGfbxiyruDGgqq1gHpIAPZQ/o1TNbpfa0d
        VKwA3UJCOpGlnVYIKPF5oBWxGs2JkS9VKcjYrETHSw==
X-Google-Smtp-Source: AMrXdXt7tTed1qRr38/yf/So31z5VnigyOBcWJ0f8i9ovjgUSgolivOEtPwRwtk/jK+Bdq3WMm1fQg==
X-Received: by 2002:a05:6a20:54aa:b0:b6:99c7:9283 with SMTP id i42-20020a056a2054aa00b000b699c79283mr51576651pzk.12.1674738280353;
        Thu, 26 Jan 2023 05:04:40 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a6-20020a17090a688600b00223ed94759csm3358332pjd.39.2023.01.26.05.04.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jan 2023 05:04:40 -0800 (PST)
Message-ID: <63d27a68.170a0220.d5822.571b@mx.google.com>
Date:   Thu, 26 Jan 2023 05:04:40 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.90-123-gff66dad0e6ef
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 172 runs,
 1 regressions (v5.15.90-123-gff66dad0e6ef)
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

stable-rc/queue/5.15 baseline: 172 runs, 1 regressions (v5.15.90-123-gff66d=
ad0e6ef)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.90-123-gff66dad0e6ef/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.90-123-gff66dad0e6ef
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ff66dad0e6ef6c6634b750064f166f50095d7ebc =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/63d246c7f66977fc23915ede

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
123-gff66dad0e6ef/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
123-gff66dad0e6ef/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d246c7f66977fc23915ee3
        failing since 9 days (last pass: v5.15.82-123-gd03dbdba21ef, first =
fail: v5.15.87-100-ge215d5ead661)

    2023-01-26T09:23:53.432198  <8>[    9.990000] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3216055_1.5.2.4.1>
    2023-01-26T09:23:53.542820  / # #
    2023-01-26T09:23:53.645853  export SHELL=3D/bin/sh
    2023-01-26T09:23:53.646830  #
    2023-01-26T09:23:53.748757  / # export SHELL=3D/bin/sh. /lava-3216055/e=
nvironment
    2023-01-26T09:23:53.749409  =

    2023-01-26T09:23:53.851212  / # . /lava-3216055/environment/lava-321605=
5/bin/lava-test-runner /lava-3216055/1
    2023-01-26T09:23:53.852900  =

    2023-01-26T09:23:53.857548  / # /lava-3216055/bin/lava-test-runner /lav=
a-3216055/1
    2023-01-26T09:23:53.873501  <3>[   10.433377] Bluetooth: hci0: command =
0x0c03 tx timeout =

    ... (12 line(s) more)  =

 =20
