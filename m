Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFC515978DD
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 23:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241932AbiHQVZD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 17:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241952AbiHQVY7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 17:24:59 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 568825C361
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 14:24:58 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id s31-20020a17090a2f2200b001faaf9d92easo2965367pjd.3
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 14:24:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=UxRMsuxJiImtry+57tk0hyFZl6FHagqK/F6ctuCpVVs=;
        b=txtEF7yqB4wM3cAiAQnnUbrwUUfrAj0znwfSRRKckuJAIRWdqf2iJdjJe0KMjE45x+
         DrUTY2hdYOYXZS23ofS/b6FgMtzEms1vN2p+30cnerjFHL6MFjux8zgEdp7K4mOa1slt
         37nB/4Sz4SqdrFK4O96XDO7dpbuznYuQecQD5rfAqBCYKyco0fj/vNKU1+GQOvgTs5gk
         WvW9BDTEfzk0ov7RwlS/Oi6/Tp6B1L5epH2XLlMlRmGNPv3vkWIX63e6ctIaPqyLVONV
         uGoiowrVN6tohHpFa71QT8EXnt4MCPQrkFPu1i7bLvpPEkvuNM94YR1kL+cSiGYN1bnP
         X+Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=UxRMsuxJiImtry+57tk0hyFZl6FHagqK/F6ctuCpVVs=;
        b=NO+3iZbBqHzQg+QMa6sRyoUHD3eV3HHK+mxsYEUO+LQpCHBcCxslWanb8eLUNa2yB0
         RpHENRdQaVoaRHXofaBdTwA8X6hI4iTRBSaLiVEj5zG0p/97vP7i0sruqze5hes1vnX5
         Vy/hBmv9MtNNXoRhSu1ASjhAZLEVPcBakL2EgP0NsXA8JeU4RC4HebjwAFtacKxr6e5p
         uOE+FxAq0oST547oZkPuRsythhIxGDQ72TcSF2eJtmwyJFQfy/6xuAK6QpNQYXnrjALg
         eug4tFqbbXJcGWh9zOoj0JtmcHybThnRJbGAUV8k5+rNHwXg6WMkBNcn4FC9JwqICNpm
         DbgQ==
X-Gm-Message-State: ACgBeo1+cjOkrY9wWadL+3fofvPDHFf6M7Rk9GQHLPAAgca/YhkDxC6y
        bk2IIwPtgzoFrb9gDGk+U3ViL5BJSOCCySI4
X-Google-Smtp-Source: AA6agR6BhhYe0Sfhj5KvqIgDcYZc7L6acKYGxEgOYwDXVvFIDtBzAxWwyOYVvFTLDwCds3Ao9kI6Ng==
X-Received: by 2002:a17:902:ec8e:b0:16d:d156:2bf1 with SMTP id x14-20020a170902ec8e00b0016dd1562bf1mr27341580plg.17.1660771497685;
        Wed, 17 Aug 2022 14:24:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id kx11-20020a17090b228b00b001faa4a6691asm2030644pjb.30.2022.08.17.14.24.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 14:24:49 -0700 (PDT)
Message-ID: <62fd5ca1.170a0220.b2726.3b68@mx.google.com>
Date:   Wed, 17 Aug 2022 14:24:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.18
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.18
Subject: stable-rc/queue/5.18 baseline: 152 runs, 3 regressions (v5.18.18)
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

stable-rc/queue/5.18 baseline: 152 runs, 3 regressions (v5.18.18)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
bcm2835-rpi-b-rev2 | arm  | lab-broonie     | gcc-10   | bcm2835_defconfig =
 | 1          =

imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig=
 | 1          =

panda              | arm  | lab-baylibre    | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.18/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.18
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      07e0b709cab7dc987b5071443789865e20481119 =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
bcm2835-rpi-b-rev2 | arm  | lab-broonie     | gcc-10   | bcm2835_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/62fd29accbf3c9e3bf355647

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.18/=
arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.18/=
arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fd29accbf3c9e3bf355=
648
        failing since 1 day (last pass: v5.18.16-7-g7fc5e6c7e4db1, first fa=
il: v5.18.17-1094-g906dae830019d) =

 =



platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/62fd2bf0dda92fbc27355663

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.18/=
arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6ul-pico-hobbit.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.18/=
arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6ul-pico-hobbit.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fd2bf0dda92fbc27355=
664
        failing since 42 days (last pass: v5.18.9-96-g91cfa3d0b94d, first f=
ail: v5.18.9-102-ga6b8287ea0b9) =

 =



platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
panda              | arm  | lab-baylibre    | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/62fd2d91f9f629da00355653

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.18/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.18/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fd2d91f9f629da00355=
654
        failing since 2 days (last pass: v5.18.17-134-g620d3eac5bbd1, first=
 fail: v5.18.17-1078-g5c55e4c4afa02) =

 =20
