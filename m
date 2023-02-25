Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD876A2BD4
	for <lists+stable@lfdr.de>; Sat, 25 Feb 2023 22:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbjBYVLS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Feb 2023 16:11:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjBYVLR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Feb 2023 16:11:17 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95958166F4
        for <stable@vger.kernel.org>; Sat, 25 Feb 2023 13:10:58 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id i5so1335519pla.2
        for <stable@vger.kernel.org>; Sat, 25 Feb 2023 13:10:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=I9CV9kkArE+poF4Gtn7uwcw9QkWFr6pUX/QdczlOmLI=;
        b=nDpekZ7QGga94lguoamgnNfOu0vCiBVkHKTb+eMEz2fB7Mh90yYUUG+dM5XzHFX3c7
         n/WaDiA0/TIbJGDzDowAZhBZ0auyMDbaOwgeJxN/UXKLQhdaxkpYLPp+tUJwSjSMnNzk
         WmkuW0fybEIcvdNlvAMHqL9T4DpNwqC7QPw+IabFjSdwtWg2XO1j8c2xPfM2dG+18+R6
         bO4YFdaN4GU8wk+jZ+pbvAZNSxCvZ6iQZHaHUygyhv1RqfeAbsokt505GfYC61HDjM7W
         23nSqu6PBNJ4E5+rBPk6E3CwV1bOLnQIjUN9JkdaVDbR4lSCkSsHC2OooCddO3Bs6HeF
         Jm7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I9CV9kkArE+poF4Gtn7uwcw9QkWFr6pUX/QdczlOmLI=;
        b=W3LP9C9ABgKtI466nNdpoC1yki2drt+RASoLVTeZgwR6x7qUNE0KZLgHTU+E0fcTjt
         ycfkvMHLml9ImfD1H1utBB5oSU7ktm6pyBLV65wg5kSGgQH84jmKEsftI1R5YNSfRvAZ
         qzszKj/afB+vVvGYLWDJ5sW1OXAIKaBALaUxz41Fo1YU5D4a2ThRYgOGOEvTN01eRG+y
         tsEQGDDR4fFSkk0A/XEbXVzEwbcXMEz+Kw9ch7DdrOV1W4Kajz1gFTaHkl9L886wRfe/
         sf0vThOquFqtL0qGwvEtruFX23wFgJkp4sJe+n7KwiOvxY1CW1uQ6Up6wivOyzajG9L1
         eLZw==
X-Gm-Message-State: AO0yUKUX+/Xs3s05ZGXf+liI1c+Khc2HIfgcl1LRZRSlqwJM3GLM4X53
        uea0v334Ik3v5Ll4k3nAf/RKBWCLCV5ekzdHHR4=
X-Google-Smtp-Source: AK7set+6IAujkL5Oi0OWc7Cnad+trELNH8HBExjG6IZGbGtMRz9mtqe+DjihaWxlZnPAvbqKsJBk0Q==
X-Received: by 2002:a17:902:d4ca:b0:19a:9880:175f with SMTP id o10-20020a170902d4ca00b0019a9880175fmr24568538plg.51.1677359457763;
        Sat, 25 Feb 2023 13:10:57 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id jn9-20020a170903050900b0019cc3d0e1basm1684052plb.112.2023.02.25.13.10.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Feb 2023 13:10:57 -0800 (PST)
Message-ID: <63fa7961.170a0220.b43da.2749@mx.google.com>
Date:   Sat, 25 Feb 2023 13:10:57 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-6.1.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.14
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-6.1.y baseline: 158 runs, 3 regressions (v6.1.14)
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

stable-rc/linux-6.1.y baseline: 158 runs, 3 regressions (v6.1.14)

Regressions Summary
-------------------

platform           | arch  | lab           | compiler | defconfig       | r=
egressions
-------------------+-------+---------------+----------+-----------------+--=
----------
kontron-pitx-imx8m | arm64 | lab-kontron   | gcc-10   | defconfig       | 2=
          =

qemu_mips-malta    | mips  | lab-collabora | gcc-10   | malta_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-6.1.y/kern=
el/v6.1.14/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-6.1.y
  Describe: v6.1.14
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7d54cb2c26dad1264ecca85992bfe8984df4b7b5 =



Test Regressions
---------------- =



platform           | arch  | lab           | compiler | defconfig       | r=
egressions
-------------------+-------+---------------+----------+-----------------+--=
----------
kontron-pitx-imx8m | arm64 | lab-kontron   | gcc-10   | defconfig       | 2=
          =


  Details:     https://kernelci.org/test/plan/id/63fa488d1dac60b38e8c86e4

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.14/=
arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-imx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.14/=
arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63fa488d1dac60b38e8c86eb
        new failure (last pass: v6.1.13-48-g342b7f3b3ae5)

    2023-02-25T17:42:15.528280  / # #
    2023-02-25T17:42:15.630178  export SHELL=3D/bin/sh
    2023-02-25T17:42:15.630587  #
    2023-02-25T17:42:15.731916  / # export SHELL=3D/bin/sh. /lava-285420/en=
vironment
    2023-02-25T17:42:15.732454  =

    2023-02-25T17:42:15.833714  / # . /lava-285420/environment/lava-285420/=
bin/lava-test-runner /lava-285420/1
    2023-02-25T17:42:15.834465  =

    2023-02-25T17:42:15.839110  / # /lava-285420/bin/lava-test-runner /lava=
-285420/1
    2023-02-25T17:42:15.904053  + export 'TESTRUN_ID=3D1_bootrr'
    2023-02-25T17:42:15.904371  + cd /l<8>[   14.418191] <LAVA_SIGNAL_START=
RUN 1_bootrr 285420_1.5.2.4.5> =

    ... (10 line(s) more)  =


  * baseline.bootrr.dwc3-usb1-probed: https://kernelci.org/test/case/id/63f=
a488d1dac60b38e8c86fb
        new failure (last pass: v6.1.13-48-g342b7f3b3ae5)

    2023-02-25T17:42:18.254153  /lava-285420/1/../bin/lava-test-case
    2023-02-25T17:42:18.254553  <8>[   16.862194] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwc3-usb1-probed RESULT=3Dfail>   =

 =



platform           | arch  | lab           | compiler | defconfig       | r=
egressions
-------------------+-------+---------------+----------+-----------------+--=
----------
qemu_mips-malta    | mips  | lab-collabora | gcc-10   | malta_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/63fa453c5ea824a1f58c86a0

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.14/=
mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mips-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.14/=
mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mips-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/mipsel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63fa453c5ea824a=
1f58c86a4
        new failure (last pass: v6.1.13-48-g342b7f3b3ae5)
        1 lines

    2023-02-25T17:28:23.486390  kern  :alert : CPU 0 Unable to handle kerne=
l paging request at virtual address 538abf9c, epc =3D=3D 80203594, ra =3D=
=3D 80203588
    2023-02-25T17:28:23.486538  =


    2023-02-25T17:28:23.509635  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
    2023-02-25T17:28:23.509759  =

   =

 =20
