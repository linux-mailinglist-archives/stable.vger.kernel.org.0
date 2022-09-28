Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B70655EDFE0
	for <lists+stable@lfdr.de>; Wed, 28 Sep 2022 17:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234497AbiI1PNB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Sep 2022 11:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234599AbiI1PM6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Sep 2022 11:12:58 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E5E2B0890
        for <stable@vger.kernel.org>; Wed, 28 Sep 2022 08:12:50 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id v10-20020a17090a634a00b00205e48cf845so2684418pjs.4
        for <stable@vger.kernel.org>; Wed, 28 Sep 2022 08:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=w6fBZMESmRgjwlESP2ozzTtrQv3GKD4fE1uTt5qrSvk=;
        b=Selb+ZX9CEXsLP/orV+Om6gxqJ1FZsNlNjIbLTvz8HsqpB3YUWXXJtn2ZiubARYg0h
         iPUkvpAIOdRUEpLo6kMqnP8qprpqbWBEDMyi4FzmbQUj2l13DcMk9SmppEeB23lsbPj8
         RDpBH2Rk2ZS0AQDg8QudB8ZoTy3FXP8jNc+40pfxM6CBQQZTT3gexRfh2kKIz+N7nN4k
         DkuNyoqNZERFdzey4P6JFw8TsVOWMcL7jBBvg1348nfzdZ1XABGWnkzfRTq2Q/xWJ+7K
         Sj5pUYMGqw3cg0NbpKAurEp4YeE/br1nQKhmTf1eAaK7wfH6yw0opMpkkgRKoWqZw6PZ
         T5Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=w6fBZMESmRgjwlESP2ozzTtrQv3GKD4fE1uTt5qrSvk=;
        b=RLkSgteSskSeKaATSyxQjwJVhX0mdorYlxiX77RLTCIn3mJcOZNoV0HNzVy0sfoENP
         LHPh1YTrwvNy9stuYysNHqA/rezLo81pmjJcEgJNpXJZvV9nBrvW8dsB60wiq9/a1m0H
         WFd/J4eZPgR+DYUY6MAcyXR8yLsJzIgClrseSf2uck09cs5XIvWpsDSFcn2kZTASW7a7
         MxfGaWmlcQQYhoJlOfuWYTNHWNYvdjiXlTu0/vDOmWAUDFOOztKmpDpjFKZLWCcmgoMX
         WE6FbCqykFdA7N8da+Rb6NbUoWXb5w2HILQraipOmFQPf9XyvMP9FT2CIN2Q//2mtdHi
         ziVg==
X-Gm-Message-State: ACrzQf00zLE1Qjfos/qsxeZcPeN6+H6oJ5Ha89sgT8OW3GcosS+5VDjT
        7IQo+AFUI48w+LwDGEK5CNoMoTBkdwKsIADL
X-Google-Smtp-Source: AMsMyM5ihb3NcIKWTGm/jAFJZ1y7WdO1vaRAo6OUB7uk5yOPWW4LdcZzoUMRVzxpTEtgDSI3LOFGdQ==
X-Received: by 2002:a17:902:a517:b0:178:8bf4:c536 with SMTP id s23-20020a170902a51700b001788bf4c536mr321787plq.62.1664377969664;
        Wed, 28 Sep 2022 08:12:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q5-20020a17090a4f8500b001fbb0f0b00fsm1671733pjh.35.2022.09.28.08.12.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 08:12:48 -0700 (PDT)
Message-ID: <63346470.170a0220.fe253.2ba6@mx.google.com>
Date:   Wed, 28 Sep 2022 08:12:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.11-208-ge0d15091986ad
X-Kernelci-Branch: queue/5.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.19 baseline: 170 runs,
 3 regressions (v5.19.11-208-ge0d15091986ad)
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

stable-rc/queue/5.19 baseline: 170 runs, 3 regressions (v5.19.11-208-ge0d15=
091986ad)

Regressions Summary
-------------------

platform        | arch | lab           | compiler | defconfig           | r=
egressions
----------------+------+---------------+----------+---------------------+--=
----------
imx7ulp-evk     | arm  | lab-nxp       | gcc-10   | imx_v6_v7_defconfig | 1=
          =

imx7ulp-evk     | arm  | lab-nxp       | gcc-10   | multi_v7_defconfig  | 1=
          =

qemu_mips-malta | mips | lab-collabora | gcc-10   | malta_defconfig     | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.11-208-ge0d15091986ad/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.11-208-ge0d15091986ad
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e0d15091986ad8880b9ff425584f5bac667297a3 =



Test Regressions
---------------- =



platform        | arch | lab           | compiler | defconfig           | r=
egressions
----------------+------+---------------+----------+---------------------+--=
----------
imx7ulp-evk     | arm  | lab-nxp       | gcc-10   | imx_v6_v7_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/63342f6f33066e2de2ec4ed2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
208-ge0d15091986ad/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-=
evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
208-ge0d15091986ad/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-=
evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63342f6f33066e2de2ec4=
ed3
        failing since 2 days (last pass: v5.19.11-158-gc8a84e45064d0, first=
 fail: v5.19.11-186-ge96864168d41) =

 =



platform        | arch | lab           | compiler | defconfig           | r=
egressions
----------------+------+---------------+----------+---------------------+--=
----------
imx7ulp-evk     | arm  | lab-nxp       | gcc-10   | multi_v7_defconfig  | 1=
          =


  Details:     https://kernelci.org/test/plan/id/63343136493293b5acec4f44

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
208-ge0d15091986ad/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
208-ge0d15091986ad/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63343136493293b5acec4=
f45
        failing since 1 day (last pass: v5.19.11-158-gc8a84e45064d0, first =
fail: v5.19.11-206-g444111497b13) =

 =



platform        | arch | lab           | compiler | defconfig           | r=
egressions
----------------+------+---------------+----------+---------------------+--=
----------
qemu_mips-malta | mips | lab-collabora | gcc-10   | malta_defconfig     | 1=
          =


  Details:     https://kernelci.org/test/plan/id/6334339f8a3f40b3cfec4ed6

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
208-ge0d15091986ad/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_=
mips-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
208-ge0d15091986ad/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_=
mips-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/mipsel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/6334339f8a3f40b=
3cfec4eda
        failing since 0 day (last pass: v5.19.11-207-g5704e94c78ce, first f=
ail: v5.19.11-208-g633f59cac516)
        1 lines

    2022-09-28T11:44:16.673904  kern  :alert : CPU 0 Unable to handle kerne=
l paging request at virtual address 00007e54, epc =3D=3D 80200cc0, ra =3D=
=3D 8023ee18
    2022-09-28T11:44:16.711356  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>   =

 =20
