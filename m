Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D23C4FA7CA
	for <lists+stable@lfdr.de>; Sat,  9 Apr 2022 14:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241745AbiDIMyW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Apr 2022 08:54:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbiDIMyV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Apr 2022 08:54:21 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5C7B11C3D
        for <stable@vger.kernel.org>; Sat,  9 Apr 2022 05:52:14 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id o5-20020a17090ad20500b001ca8a1dc47aso14192438pju.1
        for <stable@vger.kernel.org>; Sat, 09 Apr 2022 05:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ReBEWWJXTHMPg2uVIe8K1bIoiALJiPOBT/RMs9f+t0c=;
        b=F8HTTz/tvMuYvrMLEYe2o14DqejfdE0ezROKkw/2A+G/km6qQ3SK8OqLb4L2qPQTGQ
         d6Rp89JfWFSNlUdTnPpv+UrD0dJvibJS+SUDMuofDVhKQaz3h51NUsSJfufwi8LhXgs9
         elSIWB02l6O+Klgo9nI1N9WFdwDHQUAcGKoTLk1aTCdSEGb3Ldwb49h4zUpAmT3TGYca
         hGVi57OQO6HcqY+s19nlfI76KLTnBzpUXv/u7cswI/oNO9m6eeo6CUDRKmZ7V/KZRGLm
         7rnCcp41CrvoNtumLsX1o9mNbN5zWXggaX9L797kcTgMwSxcig0lvE4pQ4Ic9CngryBY
         t+xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ReBEWWJXTHMPg2uVIe8K1bIoiALJiPOBT/RMs9f+t0c=;
        b=A40/BBBP8b8/7pTMrEsDjsqP7yekzBnUzvaFdej8jub/gkvUytP0Z8uW90y2yR3qo9
         XYIU42nHN+6TNjtstg3aGkr9+dCST3P+qi3jrZZN/TKNJA1V8nxhsWv/QXhRLZdc+hQS
         cZe4XOH53+T9muw/6gkd9q/jU5oAgyZrTGdZbNXdXxq3XiEmUuIex85Llw17VB8k7LnV
         wd4Fw/aenO9iY9BCwYGxoM5iGGdKKccsJlGoSA5oirtI5KwOzjUBkt3S6bRs+vuxEqo4
         MHRR4rgCpK9Z6EQDS3wMvhbIHdBJe+jGiKWM5BBoKHrFjuL7rsgre+1eIaaicXaW7YOy
         AL5A==
X-Gm-Message-State: AOAM5306S7xTXQx5TTb5VZM6kdcugJmbLWWfON8IAYt0P7AHTlr0+Ptz
        /bY5e/8AbYA2AXG38A7lr21n4NFh6XvkfP0U
X-Google-Smtp-Source: ABdhPJxKuL6xHoNxu2NO4PjwcOIVQ569Yn1N0fMN3ntAwE3szbzLMW+4SFJRRkxi2/KF3EQXYw9OIQ==
X-Received: by 2002:a17:90a:4e08:b0:1ca:7108:439e with SMTP id n8-20020a17090a4e0800b001ca7108439emr26966234pjh.27.1649508734002;
        Sat, 09 Apr 2022 05:52:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b2-20020a6541c2000000b0039d1280084asm2874556pgq.26.2022.04.09.05.52.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Apr 2022 05:52:13 -0700 (PDT)
Message-ID: <6251817d.1c69fb81.17f6d.78f0@mx.google.com>
Date:   Sat, 09 Apr 2022 05:52:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.109-597-gcb8aa05b9d788
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 71 runs,
 3 regressions (v5.10.109-597-gcb8aa05b9d788)
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

stable-rc/queue/5.10 baseline: 71 runs, 3 regressions (v5.10.109-597-gcb8aa=
05b9d788)

Regressions Summary
-------------------

platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
imx6q-var-dt6customboard | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 2          =

rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.109-597-gcb8aa05b9d788/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.109-597-gcb8aa05b9d788
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cb8aa05b9d7889bf0610e9acadd2598afc36e2d6 =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
imx6q-var-dt6customboard | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 2          =


  Details:     https://kernelci.org/test/plan/id/62514a147c2e33455dae0688

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.109=
-597-gcb8aa05b9d788/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx=
6q-var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.109=
-597-gcb8aa05b9d788/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx=
6q-var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/62514a147c2e334=
55dae068f
        new failure (last pass: v5.10.109-597-g64232f26da0d8)
        53 lines

    2022-04-09T08:55:37.018780  =

    2022-04-09T08:55:37.019035  kern  :alert : [0000004c] *pgd=3D495e5831
    2022-04-09T08:55:37.069202  kern  :emerg : Internal error: Oops: 17 [#1=
] SMP ARM
    2022-04-09T08:55:37.069458  kern  :emerg : Process udevd (pid: 143, sta=
ck limit =3D 0x(ptrval))
    2022-04-09T08:55:37.069681  kern  :emerg : Stack: (0xc3bfdcd8 to 0xc3bf=
e000)
    2022-04-09T08:55:37.069895  kern  :emerg : dcc0:                       =
                                c0f022e4 c09ded90
    2022-04-09T08:55:37.070339  kern  :emerg : dce0: c35fcdb0 c35fcdb4 c35f=
cc00 c09e4870 c3bfc000 c14463ac 0000000c 02a328d8
    2022-04-09T08:55:37.072495  kern  :emerg : dd00: c19c7990 c3ad3c00 c200=
1a80 ef86da00 c09f2014 c14463ac 0000000c c32e4640
    2022-04-09T08:55:37.112330  kern  :emerg : dd20: c19c7990 02a328d8 0000=
0001 c2184c80 c2692f80 c35fcc00 c35fcc14 c14463ac
    2022-04-09T08:55:37.112587  kern  :emerg : dd40: 0000000c c32e4640 c19c=
7990 c09f1fe8 c14440d0 00000000 c35fcc00 fffffdfb =

    ... (38 line(s) more)  =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/62514a147c2e334=
55dae0690
        new failure (last pass: v5.10.109-597-g64232f26da0d8)
        4 lines

    2022-04-09T08:55:37.015576  kern  :alert : 8<--- cut here ---
    2022-04-09T08:55:37.015831  kern  :alert : Unable to handle kernel NULL=
 pointer dereference at virtual address 0000004c
    2022-04-09T08:55:37.016055  kern  :alert : pgd =3D (ptrval)<8>[   17.19=
7897] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dline=
s MEASUREMENT=3D4>   =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62514ceab322b6b2c5ae0687

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.109=
-597-gcb8aa05b9d788/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.109=
-597-gcb8aa05b9d788/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62514ceab322b6b2c5ae06a9
        failing since 32 days (last pass: v5.10.103-56-ge5a40f18f4ce, first=
 fail: v5.10.103-105-gf074cce6ae0d)

    2022-04-09T09:07:33.617192  <8>[   60.077289] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-09T09:07:34.640162  /lava-6054714/1/../bin/lava-test-case
    2022-04-09T09:07:34.650520  <8>[   61.111148] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
