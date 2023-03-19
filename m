Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E71B6C06A3
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 00:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbjCSXgq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 19:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjCSXgp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 19:36:45 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 621B246A7
        for <stable@vger.kernel.org>; Sun, 19 Mar 2023 16:36:41 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id p20so10715754plw.13
        for <stable@vger.kernel.org>; Sun, 19 Mar 2023 16:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679269000;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=F0T8HZydrgUdEzoY6HS+O/ZSUotn9eDzXcpuccN4BTQ=;
        b=ZVzf2LpX0rt2SzE9I/ppbGw6VH3PmAr44vHw7NOyF8yQPYozFCP7YepueMyByXCQR1
         UY9pAdXUbNHUF5SxW/RODNrTgUPg2hdFYWAYWpqC0BjdNAP/esTjXpAUcgE6xqmQRjsm
         gV7BL8asLiUzZSJN5HibLiHeIbMBJ8fPpXDDCWVzlYWbMF1Edg92DSu98Xyzsrod7RtB
         mq47VQMb0INyv7B1kGDlXpz2zXZkhboZpDPkN/wJ/LJXz2MZcZ+dIKcPR/Dz0jQC+Z4K
         NMVPGoCZosFPyAh4M+0ckc/ycFOhfr9N6AuAD0tCl4seVA2dpbMaMd4ny1+lzuSQo2Yx
         kBQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679269000;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F0T8HZydrgUdEzoY6HS+O/ZSUotn9eDzXcpuccN4BTQ=;
        b=X9/WOkvbi6UvTsL3u68yrqKx01qPmUbAg/CfW8hq6NRkn/LFGKUzloIAf+jEmU2Hul
         SOTwBTBwO9W98TcnKakuqqop79bRtvrNUNG2FkbqTrxLifuw/5vImhSs3A90oD3m5InP
         VipmfhAYbLEFaYhm0ZgcdnFPiJWb6p+mqkKHKO/fUA48gm0wdl/8BgNMUzqVZLjKj8Lo
         0dh8DpuPhqnu6D6TReLMEzl2Xb+LYH/AFUFxK9WiTDoa4SheszrEbg7O1vwTCl4x2XzW
         VtygCB53afGIIRZxLJh2j87UDLowQ0OluZa6xjTcXMt/rDmwl50QM0QPqK5fjtlv4+Ob
         KqJw==
X-Gm-Message-State: AO0yUKVrX+yIyYbuiFUgogfgaKZZ+6YcFslPbOeYH1qEJIvqiOeotb3t
        skpTHvgQ0PJz1NE4W0LavEmoGbj84tZAdv3lRr1HZQ==
X-Google-Smtp-Source: AK7set/oasKA8WwrK+fK2iZ2CIC1wwc10NWMr8EEvvJExRa6DBDtJgKgd89eJJwV7sGPG27yYVJ2lQ==
X-Received: by 2002:a05:6a20:671a:b0:d7:3b62:3cf with SMTP id q26-20020a056a20671a00b000d73b6203cfmr12472124pzh.54.1679269000646;
        Sun, 19 Mar 2023 16:36:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d2-20020a639742000000b00502e7115cbdsm2364946pgo.51.2023.03.19.16.36.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Mar 2023 16:36:40 -0700 (PDT)
Message-ID: <64179c88.630a0220.6904f.2c48@mx.google.com>
Date:   Sun, 19 Mar 2023 16:36:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.20-92-g2d61a6c64e31
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 171 runs,
 2 regressions (v6.1.20-92-g2d61a6c64e31)
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

stable-rc/queue/6.1 baseline: 171 runs, 2 regressions (v6.1.20-92-g2d61a6c6=
4e31)

Regressions Summary
-------------------

platform           | arch | lab           | compiler | defconfig         | =
regressions
-------------------+------+---------------+----------+-------------------+-=
-----------
bcm2835-rpi-b-rev2 | arm  | lab-broonie   | gcc-10   | bcm2835_defconfig | =
1          =

qemu_mips-malta    | mips | lab-collabora | gcc-10   | malta_defconfig   | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.20-92-g2d61a6c64e31/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.20-92-g2d61a6c64e31
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2d61a6c64e3199cc14bd020f69e9cbf6b8b1d833 =



Test Regressions
---------------- =



platform           | arch | lab           | compiler | defconfig         | =
regressions
-------------------+------+---------------+----------+-------------------+-=
-----------
bcm2835-rpi-b-rev2 | arm  | lab-broonie   | gcc-10   | bcm2835_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/6417674a9ac68a53668c865e

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.20-92=
-g2d61a6c64e31/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-rp=
i-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.20-92=
-g2d61a6c64e31/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-rp=
i-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6417674a9ac68a53668c8695
        failing since 2 days (last pass: v6.1.18-144-g88546018fee83, first =
fail: v6.1.19-139-g6d04fa2f2978)

    2023-03-19T19:48:52.575274  + set +x
    2023-03-19T19:48:52.579240  <8>[   16.517787] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 188090_1.5.2.4.1>
    2023-03-19T19:48:52.695381  / # #
    2023-03-19T19:48:52.797629  export SHELL=3D/bin/sh
    2023-03-19T19:48:52.798448  #
    2023-03-19T19:48:52.900514  / # export SHELL=3D/bin/sh. /lava-188090/en=
vironment
    2023-03-19T19:48:52.901053  =

    2023-03-19T19:48:53.003056  / # . /lava-188090/environment/lava-188090/=
bin/lava-test-runner /lava-188090/1
    2023-03-19T19:48:53.003970  =

    2023-03-19T19:48:53.010313  / # /lava-188090/bin/lava-test-runner /lava=
-188090/1 =

    ... (14 line(s) more)  =

 =



platform           | arch | lab           | compiler | defconfig         | =
regressions
-------------------+------+---------------+----------+-------------------+-=
-----------
qemu_mips-malta    | mips | lab-collabora | gcc-10   | malta_defconfig   | =
1          =


  Details:     https://kernelci.org/test/plan/id/6417682d5e136e6bd78c865c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.20-92=
-g2d61a6c64e31/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mips=
-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.20-92=
-g2d61a6c64e31/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mips=
-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/mipsel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6417682d5e136e6bd78c8=
65d
        failing since 0 day (last pass: v6.1.19-139-g6d04fa2f2978, first fa=
il: v6.1.20-92-gafcdef45f9b4) =

 =20
