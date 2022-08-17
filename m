Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13ED4597A3E
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 01:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236306AbiHQXcg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 19:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234593AbiHQXcf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 19:32:35 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBCAD9AFB6
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 16:32:34 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id r15-20020a17090a1bcf00b001fabf42a11cso225709pjr.3
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 16:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=DURts0P3zju1Oh2fqSYwx/73prH6bhk1t2TfUVuc0+I=;
        b=QyMt8Y8g0o/7oz6VTnbC418AIsnEeGkKmkq//DYnrDPYMEHVGEuhrdtw317U909+Jf
         xy+Jt3hFzJBZS8RMo8rhjMLqVwenRX2BtKGwJKiycxYDDuLoJdYkHDmoVW/nHEnwR/VE
         HLVvsXyJmlDTv5b8A3BXABKveQk89PM8oWP0b1rMX1Z44tEcVGWBu3Ym4PhzoAmyPMv1
         0Wh0jTmryCfEp22eHPekejB1s5BnH8IBmu8xOrTmDB+WkLA3SmCIjE986soLGdK0q9km
         kxoTmFOJFxVDD6K/hviBXiWwLRY4ijvJmS6eK5FnDs4dYpl1eFYH3dGEsBo3K7vBvk/e
         sM7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=DURts0P3zju1Oh2fqSYwx/73prH6bhk1t2TfUVuc0+I=;
        b=DSG3oeh76I2gDNphiPOIsespLbsjbdxCb2uNjdug2IsEGEEGRjxoh/cA59U7nD0OwI
         4Y9mFtWxx6I5ijQjOWt47IoY2EdWstbjZ/8fd5NkIESWgwAu9N2OeIpnYMEYPB4bvYj7
         bX+TFLVT2kFZTIXtk46E4M5ACXVI68/f6Z6o5bc96PgXBguVTu7+ia95sMxVHZ/W8IEh
         H+pnx/w7b1jNRdIJsjKv1+CW1txzNjf66XJ8yn8fW3f5d5DHJciW6KF7kErCAXCc5DoI
         DPAI7b1h9Z1mXRV2PSiF1ecJky2znlpeasDU4aPy4pkvx3PlNclY4mVup6KPrrTh+/HJ
         Wo1A==
X-Gm-Message-State: ACgBeo3YmJOsJPZH2cD3bZUNL5MiDIsuosIEMyQI+z2xvUL6m+TAEGZA
        +JwVFAQbqtlPXfVWuQqC2VkORE8aiql9OQ7N
X-Google-Smtp-Source: AA6agR5YuxFnU//NtcQbGXzv/rwnqf+tp4ARypUCpJtcVCpqWhK9/qgCGsi224E4I8VDhbZrnekwUA==
X-Received: by 2002:a17:902:d885:b0:172:868f:188c with SMTP id b5-20020a170902d88500b00172868f188cmr248463plz.78.1660779154187;
        Wed, 17 Aug 2022 16:32:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m11-20020a17090a7f8b00b001f89383d587sm51939pjl.56.2022.08.17.16.32.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 16:32:33 -0700 (PDT)
Message-ID: <62fd7a91.170a0220.acab8.01db@mx.google.com>
Date:   Wed, 17 Aug 2022 16:32:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.2-1-gf331c74ae4b69
Subject: stable-rc/queue/5.19 baseline: 127 runs,
 1 regressions (v5.19.2-1-gf331c74ae4b69)
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

stable-rc/queue/5.19 baseline: 127 runs, 1 regressions (v5.19.2-1-gf331c74a=
e4b69)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.2-1-gf331c74ae4b69/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.2-1-gf331c74ae4b69
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f331c74ae4b69387744fe3d103ec741e7b32a7ab =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/62fd56d57646392d7935564d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.2-1=
-gf331c74ae4b69/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.2-1=
-gf331c74ae4b69/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fd56d57646392d79355=
64e
        failing since 1 day (last pass: v5.19.1-1157-g615e53e38bef5, first =
fail: v5.19.1-1159-g6c70b627ef512) =

 =20
