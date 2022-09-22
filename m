Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF36A5E6707
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 17:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232120AbiIVPZq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 11:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232035AbiIVPZn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 11:25:43 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92986EF09D
        for <stable@vger.kernel.org>; Thu, 22 Sep 2022 08:25:39 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id e67so3340335pgc.12
        for <stable@vger.kernel.org>; Thu, 22 Sep 2022 08:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=KHgkOhuLJtXZZudnejL34dLakBXAzoLyHdgZdraeRyE=;
        b=gNXHzZhGxkLuF8Vb5Fw12NaRQTHlnmUeARWJ292QNeR3gGVuXy9y/Bp+A8O/06Aa5k
         LdrlDX4UA4YiBUDB6KgspIryFvQnnQ6yjcDAf2dkxoIeuICTe8gFDVIgPKgoN5l2fExx
         SLUFArUQVCF1NnaEZ9uv4kSuz33eK3VOFktX7pj6swQLfixK5R6xVz7APFKI1dYzBbBG
         lex9/g3R1zOPCgx6pZFIFRV1bmIr1miYZBSuxL70C0bz394CGfTnGqPfi7b5NzhG0RNi
         4QFeGcl3QRfgXGP/gmFYuebVtaA6oiGKQ9krqqqcMh8VMyp/JqKu5WV8Ij0Ei5fV/tuL
         /3MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=KHgkOhuLJtXZZudnejL34dLakBXAzoLyHdgZdraeRyE=;
        b=2rWfHx+MPRf7mZt668jzQp4bkM26t8Q29xkJCIsUQfqJ82UwE5mlGLOtfxf4sxLwLn
         2tTQ2eta9FklXQxO8a5z/EtFon7AEqT3UEZAwk3J0cJDMA9XklWqaU2O1UfEREz0r9kd
         tEA5tVwgIPIv0iy2as8Gi0E5opao8hKoy17jJcfhVcQck2VVrZFhZ/p/P3IqY6xrSDKC
         /VsQWCwkIUSGL3McwqttP0zj6/NHVW+DuAuO1rcmkGjIhg18CaeUYZMz9UEOt0cQKwnu
         0REJb6U5gI6PPIx4Fnt+SXagMazW34OtL5FlsV6oSRZNhOxwVN7NBuUS7P+BVIb3C7Av
         SxAQ==
X-Gm-Message-State: ACrzQf3MOjPFD0c5mjMYfatysT1xXOEWnu5+z+a6EVAlwUtrJ64+EAw+
        96jDqOmbcq7IkghCB2ZH6qqR/4o76517bolptyg=
X-Google-Smtp-Source: AMsMyM7UIGpg1iV8A0XEYeJQ7bFoAcCRNk7csM6o1y9/DYPpUR9p8nsvUa72UnOha/1X7qh5q+eUkg==
X-Received: by 2002:aa7:9605:0:b0:53e:8062:43fc with SMTP id q5-20020aa79605000000b0053e806243fcmr4194930pfg.39.1663860337884;
        Thu, 22 Sep 2022 08:25:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e23-20020aa79817000000b00540b35628a4sm4619112pfl.123.2022.09.22.08.25.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 08:25:37 -0700 (PDT)
Message-ID: <632c7e71.a70a0220.ecbd0.9bdc@mx.google.com>
Date:   Thu, 22 Sep 2022 08:25:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.144-39-g7cb536a33eb23
Subject: stable-rc/queue/5.10 baseline: 136 runs,
 2 regressions (v5.10.144-39-g7cb536a33eb23)
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

stable-rc/queue/5.10 baseline: 136 runs, 2 regressions (v5.10.144-39-g7cb53=
6a33eb23)

Regressions Summary
-------------------

platform | arch | lab          | compiler | defconfig           | regressio=
ns
---------+------+--------------+----------+---------------------+----------=
--
panda    | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  | 1        =
  =

panda    | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1        =
  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.144-39-g7cb536a33eb23/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.144-39-g7cb536a33eb23
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7cb536a33eb2348c2200a83816b2f9d19a15a962 =



Test Regressions
---------------- =



platform | arch | lab          | compiler | defconfig           | regressio=
ns
---------+------+--------------+----------+---------------------+----------=
--
panda    | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  | 1        =
  =


  Details:     https://kernelci.org/test/plan/id/632c4e4bc30c7e7ca235565a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.144=
-39-g7cb536a33eb23/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.144=
-39-g7cb536a33eb23/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632c4e4bc30c7e7ca2355=
65b
        failing since 30 days (last pass: v5.10.136-539-g2b0d128e38cdb, fir=
st fail: v5.10.137-150-g8b56d7183e67) =

 =



platform | arch | lab          | compiler | defconfig           | regressio=
ns
---------+------+--------------+----------+---------------------+----------=
--
panda    | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1        =
  =


  Details:     https://kernelci.org/test/plan/id/632c49c2bd68ed886d355645

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.144=
-39-g7cb536a33eb23/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.144=
-39-g7cb536a33eb23/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632c49c2bd68ed886d355=
646
        failing since 30 days (last pass: v5.10.136-539-g2b0d128e38cdb, fir=
st fail: v5.10.137-150-g8b56d7183e67) =

 =20
