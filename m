Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C92585FBB40
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 21:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbiJKTTz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 15:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiJKTTx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 15:19:53 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEBB913FB9
        for <stable@vger.kernel.org>; Tue, 11 Oct 2022 12:19:52 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id l6so4076132pgu.7
        for <stable@vger.kernel.org>; Tue, 11 Oct 2022 12:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=idQRA8aKLQ9gY5l4kooythTa5Gb1pPsQozHlZGuhwgo=;
        b=1KjeSKUDI63w3E7gaQLEZLrJwMVWKqmzOQ17dbr0gD6TQqBqxGSO1T8dtNVuQI1tRK
         N8wknmdg8uPQfm0fvoUIdrgc9zsxwkfpRlILLd+LvvGE3/y7sPAtb8mJfzHfARDfw1Em
         7PiEOcNki2kdyNqlqP2/CFpdtDNucvwI/0pXORfbnkkuDwbSrobgh5mJXM8fG6BvT24v
         XXnlx2JAmfYkQ+fDArdxF/LzEUYhlsjlWxJNo1PCi7CoS+90yXmyyqD+JxT6z03j4dc4
         937wyIgVHb2dstU3LZvqG19iwGRHns/yDaqEaoRQNo8BWsB9RN11SPHalKyHJAD1Z3go
         brMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=idQRA8aKLQ9gY5l4kooythTa5Gb1pPsQozHlZGuhwgo=;
        b=1GFlmm/R60nxEluqwbKlhyjwMZlYNGA+nPVUzHY/XCnpHl4+C9rtWVKaufkwlsoBbd
         NqF8MD4WYXbq68IUJUVH9PgCeFVcQlFzu+WGl99MUfgaoFtt6nVO4/Az9XKmP8JG4Rl6
         2S7Cz6zHmQVp7b2d7Rsnm++MoLdXsuyLHLBK8V26fjGolJTurXRIhWm2y44mraCKujqF
         Z4tMkuxMP+OYHdlUh0mp2yBLSXYSbX8kr9sH8/ZBkts7ikpl6RLxvayKHlI5ZmBniUa7
         pS7NkbD0T1VwRU4dkaPezCHW+2cNxA11tzZfZAzmlPbK99IYgU3mbPJg9YeImneTVUQ2
         jmOg==
X-Gm-Message-State: ACrzQf0KouIMcxfI9WsHEpOPj334/RGe5KLqB589+C7Wa/G+gTp+QvGs
        uW/gOSkxuUK+qrLga/d2I/De4GwphBJsKb1LWLY=
X-Google-Smtp-Source: AMsMyM6HG4cRgYGFk4DtE3HGDFrK133t/9NTtv/7OmEY6GNuC6T+siYx93YHEfqyDuP1Ze4lWNLNbw==
X-Received: by 2002:a63:1b58:0:b0:45f:e7ba:a223 with SMTP id b24-20020a631b58000000b0045fe7baa223mr16489814pgm.548.1665515992110;
        Tue, 11 Oct 2022 12:19:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d6-20020a623606000000b0053e6eae9665sm9744155pfa.140.2022.10.11.12.19.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 12:19:51 -0700 (PDT)
Message-ID: <6345c1d7.620a0220.3a6d.0ad9@mx.google.com>
Date:   Tue, 11 Oct 2022 12:19:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.72-36-g1dafe9f099a1
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 153 runs,
 3 regressions (v5.15.72-36-g1dafe9f099a1)
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

stable-rc/queue/5.15 baseline: 153 runs, 3 regressions (v5.15.72-36-g1dafe9=
f099a1)

Regressions Summary
-------------------

platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
beagle-xm   | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1     =
     =

imx7ulp-evk | arm  | lab-nxp      | gcc-10   | imx_v6_v7_defconfig | 1     =
     =

imx7ulp-evk | arm  | lab-nxp      | gcc-10   | multi_v7_defconfig  | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.72-36-g1dafe9f099a1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.72-36-g1dafe9f099a1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1dafe9f099a1a437445ee5b31df13bac51196270 =



Test Regressions
---------------- =



platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
beagle-xm   | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6345900f7e49f52cb5cab604

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.72-=
36-g1dafe9f099a1/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.72-=
36-g1dafe9f099a1/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6345900f7e49f52cb5cab=
605
        failing since 19 days (last pass: v5.15.69-17-g7d846e6eef7f, first =
fail: v5.15.69-45-g01bb9cc9bf6e) =

 =



platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
imx7ulp-evk | arm  | lab-nxp      | gcc-10   | imx_v6_v7_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/63458dec6553b4b05ccab63b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.72-=
36-g1dafe9f099a1/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.72-=
36-g1dafe9f099a1/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63458dec6553b4b05ccab=
63c
        failing since 15 days (last pass: v5.15.70-117-g5ae36aa8ead6e, firs=
t fail: v5.15.70-133-gbad831d5b9cf) =

 =



platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
imx7ulp-evk | arm  | lab-nxp      | gcc-10   | multi_v7_defconfig  | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/634590bb261bb72dbecab60b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.72-=
36-g1dafe9f099a1/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.72-=
36-g1dafe9f099a1/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634590bb261bb72dbecab=
60c
        failing since 16 days (last pass: v5.15.69-44-g09c929d3da79, first =
fail: v5.15.70-123-gaf951c1b9b36) =

 =20
