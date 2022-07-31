Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2693B586046
	for <lists+stable@lfdr.de>; Sun, 31 Jul 2022 19:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbiGaRxz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Jul 2022 13:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiGaRxy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 Jul 2022 13:53:54 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4915EFD22
        for <stable@vger.kernel.org>; Sun, 31 Jul 2022 10:53:53 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id f7so8998476pjp.0
        for <stable@vger.kernel.org>; Sun, 31 Jul 2022 10:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yca10Y7W8yjhmo4rLx1Q/lKf/ZcoAM9A3HQL3H/1Qv0=;
        b=n8Zc/THWhs57rTV0nvoizEufdZCOFU2PwOQWmmlpOlPGZg4AQAwbJnuHqWotlrKLKz
         xooFF6YOoGA+iInJATZJqz+PReafN0H0AJmlLvBT23n8SLX3SKTQ19HIK3iZfYv36Pd2
         Nu4ziuao4aiQcqewvo62eBr0o9igWDJCcN5as6yq7opzOPxoCftXvhY2zSIz0GrzfPQh
         25/8k2NLOqUwMcKPMtmM/z2xZsLGoZQxV0cnU2pAacRPhkAaxZT+ZOz1E+lJA/2O93Yi
         CDhWTQzkx7YdGcuUWkXemA/oM3+VRui9/yU/qSXN8HxSEE9vxxvLbTpXzmmaTUTaEyYR
         6lDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yca10Y7W8yjhmo4rLx1Q/lKf/ZcoAM9A3HQL3H/1Qv0=;
        b=DXTmnyHGvh5kuI82dGDoNj0KkdRJ2e7mTqA3UPqj98I6rCNYhrWpO0Uj/MX99fGzMs
         cADRKzx70ja1kcdnlCLszJMdPeFYXBBroSBvARbdXwj+jYThmQPi2mM37zIMxKtAlUCO
         fXs1bBRAuZvmLxYIPmeKUU5JQ4DGjw6gev09RR7gPPI585oyOzSBFKxKuxssyWA3J0qm
         VPFs7qSpRGc9TfakZWM4kZHurYS949fVPZ6ZibAKt2QWO8s+cqC0Z/eqmkWf+TIoAhUE
         ml+5NDyfKyabZqShtKs06eKngVPt3a171QRuNAs3eMug/NdjKIfuCTynSvA3ch3QpNkA
         lBRQ==
X-Gm-Message-State: ACgBeo18zyykGW6imA126zeav3pHF0BpIsIcCGTPPvOr+Iw6De1YoAnC
        tKEZxDnS4C0ThSnqqNGlGb4QVWB9+d6Uvj3HqQU=
X-Google-Smtp-Source: AA6agR5e+H4jEm8JB4wbRWR5RmFo5CkKlxhACA2P//MKSDyNob9UMxASnYHB6usqOqEmZGIu+8pSpw==
X-Received: by 2002:a17:90b:1b11:b0:1f2:2d70:70d7 with SMTP id nu17-20020a17090b1b1100b001f22d7070d7mr15761157pjb.59.1659290032561;
        Sun, 31 Jul 2022 10:53:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b2-20020a170902650200b0016c6e360ff6sm7695112plk.303.2022.07.31.10.53.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Jul 2022 10:53:52 -0700 (PDT)
Message-ID: <62e6c1b0.170a0220.56b59.b30e@mx.google.com>
Date:   Sun, 31 Jul 2022 10:53:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.18
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.14-239-g0cb79a713f90e
Subject: stable-rc/queue/5.18 baseline: 112 runs,
 2 regressions (v5.18.14-239-g0cb79a713f90e)
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

stable-rc/queue/5.18 baseline: 112 runs, 2 regressions (v5.18.14-239-g0cb79=
a713f90e)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig=
 | 1          =

qemu_mips-malta    | mips | lab-collabora   | gcc-10   | malta_defconfig   =
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.14-239-g0cb79a713f90e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.14-239-g0cb79a713f90e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0cb79a713f90e431ec3cad9894edf7578bc313e4 =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/62e68b941fa3dc5b98daf07a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.14-=
239-g0cb79a713f90e/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.14-=
239-g0cb79a713f90e/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e68b941fa3dc5b98daf=
07b
        failing since 25 days (last pass: v5.18.9-96-g91cfa3d0b94d, first f=
ail: v5.18.9-102-ga6b8287ea0b9) =

 =



platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
qemu_mips-malta    | mips | lab-collabora   | gcc-10   | malta_defconfig   =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/62e689c41d86b96414daf05a

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.14-=
239-g0cb79a713f90e/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_=
mips-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.14-=
239-g0cb79a713f90e/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_=
mips-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/mipsel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/62e689c41d86b96=
414daf062
        new failure (last pass: v5.18.14-186-g9e5d3e20f8a4d)
        1 lines

    2022-07-31T13:55:07.483695  kern  :alert : CPU 0 Unable to handle kerne=
l paging request at virtual address fd657c28, epc =3D=3D 801ff530, ra =3D=
=3D 8023be80
    2022-07-31T13:55:07.593901  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>   =

 =20
