Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 057445ECBAB
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 19:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbiI0RxT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 13:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232356AbiI0RxP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 13:53:15 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C84651183F
        for <stable@vger.kernel.org>; Tue, 27 Sep 2022 10:53:13 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id cv6so285990pjb.5
        for <stable@vger.kernel.org>; Tue, 27 Sep 2022 10:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=UsbFaw2yXIDNvEdKkvUt7YhUzmJt2JAS1N+cpeMIwps=;
        b=qpTPt3I7BYmzUNis9VyXqwh7lEUHkoq/BCs9qUMTNCvsXMyJQreFSMoJEZfqya1Bwg
         aT2slbVfrS4JvjkxLmK7356OLquTAEaFivGljQlfFKC0vkRIl0+32X+q1PdvWkw6a2SF
         67/7Ii0rexVQMx6R3kfR7FnmbXxvqBFmpvSp9faxg6Low0LbqnsyncKt5WX0lyd/xa8Y
         eg+lqjDfI63szHBhAcfw0+QDzM8Js+viP7ITNP4fo4cD9tUc4v8Acqtuzy1/WAzp/Xc2
         s1jOjPCuw8LWh1MaRWioL0+5g1oZn7zEo+q6KvmWtgQ4fZWHUKD1oy8cLcGaK0kl5Vnr
         6GRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=UsbFaw2yXIDNvEdKkvUt7YhUzmJt2JAS1N+cpeMIwps=;
        b=lhyrSmTSzf9VduB1Rtci1DfQOYjstDoQpW51aqegSo3JQHrdEQ8vVchATXe6TH0Uyz
         cP5tu6Ye2Jk3X/hrkndxZNY4NusriWk2++umo4T2GdPDX99O3Csiv+whHB8M/xV4odRA
         vSqDtTLG/j0uRiKUzgBT5eOBlnx/vhO2EFWT2s/fiCyETYIQfoNRKN5faagO4UXswJrw
         D/ICUxAQdsb1MUMUpITpaDNJ0v4HyBPhwBrAeDEbKM5f2APLSUay0TPlvW0iMbiNBSEB
         x/c2UdPWQNEJqkaNbV9PqYWT7LwlIEUneWU33U2oELOcCetQBkC+kDxZTz6jFPN0hdkt
         dcBw==
X-Gm-Message-State: ACrzQf3xa7kIvzPjHMNnDomnj1l8iTtME1e98tJMA1aZrTbiTK4PgVY4
        MtptyqUBsJo/tKMPKj3UHPSrpsjfqJII8cM1
X-Google-Smtp-Source: AMsMyM7H1U/xTycpqrQT2w5cYbsyuQ4hlS06RUC2/L5Vfc6oP3xxRklJZR0Ovbb4oV45eFdg5ov+7g==
X-Received: by 2002:a17:90b:1b51:b0:203:25f0:c25e with SMTP id nv17-20020a17090b1b5100b0020325f0c25emr5910780pjb.65.1664301193133;
        Tue, 27 Sep 2022 10:53:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b15-20020a170902d50f00b00174c235e1fdsm1878883plg.199.2022.09.27.10.53.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 10:53:12 -0700 (PDT)
Message-ID: <63333888.170a0220.59f74.35ac@mx.google.com>
Date:   Tue, 27 Sep 2022 10:53:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.11-208-g633f59cac516
X-Kernelci-Branch: queue/5.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.19 baseline: 185 runs,
 4 regressions (v5.19.11-208-g633f59cac516)
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

stable-rc/queue/5.19 baseline: 185 runs, 4 regressions (v5.19.11-208-g633f5=
9cac516)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
imx7ulp-evk                  | arm   | lab-nxp       | gcc-10   | imx_v6_v7=
_defconfig        | 1          =

imx7ulp-evk                  | arm   | lab-nxp       | gcc-10   | multi_v7_=
defconfig         | 1          =

qemu_mips-malta              | mips  | lab-collabora | gcc-10   | malta_def=
config            | 1          =

sc7180-trogdo...zor-limozeen | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.11-208-g633f59cac516/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.11-208-g633f59cac516
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      633f59cac5163337888e894046e66c00c8918288 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
imx7ulp-evk                  | arm   | lab-nxp       | gcc-10   | imx_v6_v7=
_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/633309240c49191b2fec4eba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
208-g633f59cac516/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
208-g633f59cac516/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633309240c49191b2fec4=
ebb
        failing since 1 day (last pass: v5.19.11-158-gc8a84e45064d0, first =
fail: v5.19.11-186-ge96864168d41) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
imx7ulp-evk                  | arm   | lab-nxp       | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/633306f4e5a035ce41ec4ebd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
208-g633f59cac516/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
208-g633f59cac516/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633306f4e5a035ce41ec4=
ebe
        failing since 0 day (last pass: v5.19.11-158-gc8a84e45064d0, first =
fail: v5.19.11-206-g444111497b13) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_mips-malta              | mips  | lab-collabora | gcc-10   | malta_def=
config            | 1          =


  Details:     https://kernelci.org/test/plan/id/633304a588079855a3ec4ef4

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
208-g633f59cac516/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_m=
ips-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
208-g633f59cac516/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_m=
ips-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/mipsel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/633304a58807985=
5a3ec4ef8
        new failure (last pass: v5.19.11-207-g5704e94c78ce)
        1 lines

    2022-09-27T14:11:26.635052  kern  :alert : CPU 0 Unable to handle kerne=
l paging request at virtual address 00007e54, epc =3D=3D 80200cc0, ra =3D=
=3D 8023ee18
    2022-09-27T14:11:26.663966  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>   =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sc7180-trogdo...zor-limozeen | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/633305e25ce44ee6c9ec4ee1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
208-g633f59cac516/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-sc7180-trogdor-lazor-limozeen.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
208-g633f59cac516/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-sc7180-trogdor-lazor-limozeen.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633305e25ce44ee6c9ec4=
ee2
        failing since 0 day (last pass: v5.19.11-206-g444111497b13, first f=
ail: v5.19.11-207-g5704e94c78ce) =

 =20
