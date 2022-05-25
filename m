Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 076825341C2
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 18:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234542AbiEYQyP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 12:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234485AbiEYQyO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 12:54:14 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A94387210
        for <stable@vger.kernel.org>; Wed, 25 May 2022 09:54:13 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id gk22so1782840pjb.1
        for <stable@vger.kernel.org>; Wed, 25 May 2022 09:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AZCIyrBVOn1lICyVPQDzt0D4g8QNjDhbspQEXIJUMWQ=;
        b=787bk0g5p/ovIbxZLw0GfKHJIyRlEK8tLf93lBrH2cXf7ZEsm/xjhMenumMLeylgwq
         po3zUwPN5tGIKEaJzlypFqwm1/1wJOMMtIGnxb+grZNJXXM/E892CFvAX9CKYUTkO79T
         /MqRFh9MMpW41FyXL82vU+oIccS2PF+0/D1IkKKTQ0XJLDiiZDtJvqD6JTQAmQi1eZI0
         /wvoy/Alx+bw6ya92qRGuxwIbphkCjxyvSU3iNU54pE5tTU3kPLOEDMSX9Q4SeJwKdQ7
         0nGMUVTSqRViWryUqcx7tre+HueOoHL/f1usoV/i9UCeX6Po1EscdyQZGMghukJUEA62
         qtpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AZCIyrBVOn1lICyVPQDzt0D4g8QNjDhbspQEXIJUMWQ=;
        b=KNtX5SQ6GeG4TLD2pvZlJaTAHkhSVmpYHWcHED2GAFPKuElPIAq1GLn8B0yMLmAh+E
         rs+mm8zuWgtDhCS4IWrlIYPU5qDuSyv2N3izafRI2TcOGueY3uofxiZsccdYvUPWZCvX
         OLdCIXJCqtXrdT90zRKv61eqISQfOYwWxoVi7/hSMrtcJ6U8ijoB7TVpJDsRIuUTUDtk
         azbCv8g4CxlorbWIHaWbaK9qNSoRuaXb+j83+C3RStpbiSZGLvh+YDTd0N5RMY+yjuEN
         N71tsWwoCymXvp+BvSLej95q+FdqNKmfyEW19cNtL/DGAvkOB61v+ZIFaeiyZgNuxz0q
         durg==
X-Gm-Message-State: AOAM531g6nUWk6IzFGyhpZ+aXv/z9fjkDpb+4F98zC0javaP7WAV3M5/
        aOeXTRhnXACGzNHvvXfJAsVJOFAt/gqOAkZSMLM=
X-Google-Smtp-Source: ABdhPJx5XIcc82pr3DbC8x7fqX69IMNXuP1+gKvNWXQvnrgu4GY8hTPkA5MS2Sz52YJ0tKc8W3D21w==
X-Received: by 2002:a17:902:f54d:b0:162:486a:93de with SMTP id h13-20020a170902f54d00b00162486a93demr8300406plf.147.1653497653012;
        Wed, 25 May 2022 09:54:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a4-20020a62d404000000b0050dc7628181sm11716914pfh.91.2022.05.25.09.54.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 09:54:12 -0700 (PDT)
Message-ID: <628e5f34.1c69fb81.9db1e.b73f@mx.google.com>
Date:   Wed, 25 May 2022 09:54:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.41-131-g047a20714529
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 66 runs,
 2 regressions (v5.15.41-131-g047a20714529)
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

stable-rc/queue/5.15 baseline: 66 runs, 2 regressions (v5.15.41-131-g047a20=
714529)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
rk3399-gru-kevin        | arm64 | lab-collabora | gcc-10   | defconfig+arm6=
4-chromebook | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-10   | defconfig     =
             | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.41-131-g047a20714529/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.41-131-g047a20714529
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      047a20714529df7ef2aef2fb26b78b576e515081 =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
rk3399-gru-kevin        | arm64 | lab-collabora | gcc-10   | defconfig+arm6=
4-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/628e3282dd0f36d10da39bd2

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.41-=
131-g047a20714529/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.41-=
131-g047a20714529/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/628e3283dd0f36d10da39bf4
        failing since 78 days (last pass: v5.15.26-42-gc89c0807b943, first =
fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-05-25T13:43:12.000179  <8>[   59.819032] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-05-25T13:43:13.025015  /lava-6466755/1/../bin/lava-test-case
    2022-05-25T13:43:13.035500  <8>[   60.854782] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-10   | defconfig     =
             | 1          =


  Details:     https://kernelci.org/test/plan/id/628e2d5ca7038240cba39bdf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.41-=
131-g047a20714529/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.41-=
131-g047a20714529/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628e2d5ca7038240cba39=
be0
        failing since 1 day (last pass: v5.15.41-44-g056e35d45b1e9, first f=
ail: v5.15.41-132-gede7034a09d1) =

 =20
