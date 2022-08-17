Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03FDA597049
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 15:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239691AbiHQNzx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 09:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231609AbiHQNzw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 09:55:52 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA7DC96751
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 06:55:50 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id r22so12036433pgm.5
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 06:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=ZxxQ2udQIen5U/PeshWOu9NYrGFtcx9bygnqXF3N+DE=;
        b=CCyrm78+R+8CVrD9xFcHzFO5MlinihtQElZ+xCloMJsjUzeIwwXFIrFwO1fgveBQIl
         AIZbsdWE+NGxXgQvf3il1tu41sZkg7CRyfSfmqR1d2URWEafkbqTWn00ooeIxCRcrEI+
         AVZ8KBcrqUSnW9St3W6ZqGiu4nFVGTVGyH7+GRo7RvYuM4dXa9cGO4dqO3lIGBdYoQYz
         CJAmE6QcQD/FFXlADe+I/+N8sP1IIXXThE1x0VZ4QWkodApAaz2x4gJEyAujz+94wZjg
         wy0H1Zr8MeQzCZor52g+1Ei0r7XKXbf1EPXSlAN7Tz15NdSbc6DV+ibWpEap1kmn9eDi
         GdZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=ZxxQ2udQIen5U/PeshWOu9NYrGFtcx9bygnqXF3N+DE=;
        b=5IC4DprWk9jrfMtUkMjS2BnjsQ4XzyH91JslfhgsIv8BSpNZ2aWb2vBuQc+KC1r206
         GraUHurH8VUaFPR1WegPpYEcmiLYxlbDUxYqSfpsr9M5BPIEo8daLXzSJWhKOeY6OFIS
         mXm+ic4pBwXi2fWUqBg/Q/NGBArwbcGw7RXLC4IVVt/ULGe/C+RkU8E6ApWcSjG3IRGL
         TnjjRscZv67wqV1Ngi1pUR0Vbk+1veFJG4xE2Ka4HIFrQWrbBMwkNqh7MNwL6WTcXHv/
         1doTGhV8fQuLSFnDppRVcOJQHI0heskHn2L88VPVAI66cvNF8vuK3oEjWSCIm4vJ/yPl
         hGww==
X-Gm-Message-State: ACgBeo0I1R4D0lvtrfagCk76OfpQ4d+1lk2qNKHP+8l987a5IWqAMADV
        DqcgZQz5db6H9sX/I3uM9sK8sKZOWn0iwW3p
X-Google-Smtp-Source: AA6agR73wzfyg2HEtfXsehfjfXFVnAlnu1E5e4Ttmcb7Kjvc/Egs+WY/DCL/O5fAUI5N49vc4YdUPg==
X-Received: by 2002:a65:49c8:0:b0:41a:eb36:d1a7 with SMTP id t8-20020a6549c8000000b0041aeb36d1a7mr21873838pgs.66.1660744550143;
        Wed, 17 Aug 2022 06:55:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m15-20020a6562cf000000b00422c003cf78sm8280349pgv.82.2022.08.17.06.55.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 06:55:49 -0700 (PDT)
Message-ID: <62fcf365.650a0220.e6b77.d2a2@mx.google.com>
Date:   Wed, 17 Aug 2022 06:55:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.1-1158-g81900922fdc7d
Subject: stable-rc/queue/5.19 baseline: 147 runs,
 3 regressions (v5.19.1-1158-g81900922fdc7d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.19 baseline: 147 runs, 3 regressions (v5.19.1-1158-g81900=
922fdc7d)

Regressions Summary
-------------------

platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-10   | imx_v6_v7_defconf=
ig | 1          =

meson-gxbb-p200    | arm64 | lab-baylibre    | gcc-10   | defconfig        =
   | 1          =

qemu_mips-malta    | mips  | lab-collabora   | gcc-10   | malta_defconfig  =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.1-1158-g81900922fdc7d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.1-1158-g81900922fdc7d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      81900922fdc7d1e4ce93169926a206e0ba3aec3c =



Test Regressions
---------------- =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-10   | imx_v6_v7_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/62fcbd4ea39adbb6a835567c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.1-1=
158-g81900922fdc7d/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.1-1=
158-g81900922fdc7d/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fcbd4ea39adbb6a8355=
67d
        failing since 0 day (last pass: v5.19.1-1157-g615e53e38bef5, first =
fail: v5.19.1-1159-g6c70b627ef512) =

 =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
meson-gxbb-p200    | arm64 | lab-baylibre    | gcc-10   | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/62fcc1c39b51911343355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.1-1=
158-g81900922fdc7d/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.1-1=
158-g81900922fdc7d/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fcc1c39b51911343355=
643
        new failure (last pass: v5.19.1-1159-g6c70b627ef512) =

 =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
qemu_mips-malta    | mips  | lab-collabora   | gcc-10   | malta_defconfig  =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/62fcc037117b3f3123355643

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.1-1=
158-g81900922fdc7d/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_=
mips-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.1-1=
158-g81900922fdc7d/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_=
mips-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/mipsel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/62fcc037117b3f3=
12335564b
        new failure (last pass: v5.19.1-1157-g133ae52c0a31a)
        1 lines

    2022-08-17T10:16:10.682573  kern  :alert : CPU 0 Unable to handle kerne=
l paging request at virtual address 00e9ee20, epc =3D=3D 80201978, ra =3D=
=3D 80201968   =

 =20
