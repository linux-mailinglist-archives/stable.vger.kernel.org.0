Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 105704CE832
	for <lists+stable@lfdr.de>; Sun,  6 Mar 2022 02:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231982AbiCFB4b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Mar 2022 20:56:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbiCFB4a (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Mar 2022 20:56:30 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3913D77A88
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 17:55:39 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id m11-20020a17090a7f8b00b001beef6143a8so11164906pjl.4
        for <stable@vger.kernel.org>; Sat, 05 Mar 2022 17:55:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5M77xOsy9e63pqscnPIbtWnQYZrujDVl3BFRFuwht88=;
        b=3j9G+PzUNLcyjTsVYusC3yg4T+vYHPULazEmlIt2pPGAiquHRdSHHjs8upo64bD7tX
         p2KTfBTN4WI1UeCZL3dmiojnRA5cFcBxIZBVsP/LL0wHzOPtlrgjXIVbzlLcM4bDm4ox
         EA0D3YhH+slDrmJ00NZ3EIBTqaKtc1/teeObJr0MnFCwHfRhNlqiviod5Hc+peqhRL5k
         BowUL6AKTIPzoNNUJ0jJcoEafb54bgTZmQeUFQZrdt3fPGRMC09o1YBJAJNQ4Bjov2F0
         2vaHCAcTV2SIeMAGmmGbhNI4kblq1ADADof/z14kd0L0+bmon0RlVtmxyBRWfYD5tvCj
         O0FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5M77xOsy9e63pqscnPIbtWnQYZrujDVl3BFRFuwht88=;
        b=XGvov6+nV3AoJvuWSC5cLyvnXceL5dLH0NrC0+QWB91frDWVQ/EovFZHuH9H1RKF8x
         IpXHBaQvWo/inajNcZuFLe6fXsGagkC6mdGY6/n68cxRfN/5W3VHl3hHhkVgIMYowfEH
         rqS98K41lFQspsJRiisZifUSdxc3ZxqJkrKseBep1OJnaUH5WgRCf1RbC/OeTHhAMVxP
         MSndD+nmFJ+oeRvmdUKdCtdQEu9snUArjcK5M2o87+0q3CuXV30vxdqmlbLOrhqx76/q
         kLOtk4NRZVV1jqjSlq8qSM1FMulBb8nt+Ki3nVW5iNHj0cpc/EOX3sPXy9uFjWz1gZ9j
         Xlsg==
X-Gm-Message-State: AOAM533MtbS/XMQs4K/FMh8bEEhPpEdv+RXG91YmuYbXBJzs/fdpW0FS
        mJ8B4FV9GDnwYYEsZCtgcLUBdw1HB/DxS5q+kzA=
X-Google-Smtp-Source: ABdhPJzHmEjCxjqbj/mfMRsSmLzz5BSYws11pHTCp1/ROHSGZeXe14t+q2JRi2rpFzwQnOLnE9COgQ==
X-Received: by 2002:a17:902:e051:b0:151:b485:3453 with SMTP id x17-20020a170902e05100b00151b4853453mr5883036plx.116.1646531738539;
        Sat, 05 Mar 2022 17:55:38 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d32-20020a631d60000000b003650a9d8f9asm7843236pgm.33.2022.03.05.17.55.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Mar 2022 17:55:38 -0800 (PST)
Message-ID: <6224149a.1c69fb81.3b5e4.5029@mx.google.com>
Date:   Sat, 05 Mar 2022 17:55:38 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.232-44-g885ff5b26df2
Subject: stable-rc/queue/4.19 baseline: 63 runs,
 1 regressions (v4.19.232-44-g885ff5b26df2)
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

stable-rc/queue/4.19 baseline: 63 runs, 1 regressions (v4.19.232-44-g885ff5=
b26df2)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig             | regre=
ssions
-----------+------+--------------+----------+-----------------------+------=
------
da850-lcdk | arm  | lab-baylibre | gcc-10   | davinci_all_defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.232-44-g885ff5b26df2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.232-44-g885ff5b26df2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      885ff5b26df2ccbb17113ebce260fb9277a3469a =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig             | regre=
ssions
-----------+------+--------------+----------+-----------------------+------=
------
da850-lcdk | arm  | lab-baylibre | gcc-10   | davinci_all_defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/6223db2acb167c1e72c6296c

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: davinci_all_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.232=
-44-g885ff5b26df2/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-da=
850-lcdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.232=
-44-g885ff5b26df2/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-da=
850-lcdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/6223db2acb167c1=
e72c62970
        new failure (last pass: v4.19.232-14-g2255e8399f91)
        2 lines

    2022-03-05T21:50:26.639164  <3>tilcdc 1e13000.display: tilcdc_crtc_irq(=
0x00000020): FIFO underflow
    2022-03-05T21:50:26.700029  kern  :alert : raw: 00000000 00000100 00000=
200 00000000 00000004 0000000a ffffff7f 00000000
    2022-03-05T21:50:26.700281  kern  :alert : page dumped because: nonzero=
 mapcount
    2022-03-05T21:50:26.729887  <3>tilcdc 1e13000.display: tilcdc_crtc_irq(=
0x00000020): FIFO underflow
    2022-03-05T21:50:26.730081  <3>tilcdc 1e13000.display: tilcdc_crtc_irq(=
0x00000020): FIFO underflow
    2022-03-05T21:50:26.777716  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
