Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6AC6517AA
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 02:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbiLTBQZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 20:16:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232848AbiLTBQI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 20:16:08 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2823912619
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 17:16:06 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id 17so10805521pll.0
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 17:16:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=rSzAY99uRrNw//PHBQeFYTZmjjxqpMfzg/YorvEuKMw=;
        b=I55McZntg4jCRVhWDSPNWkxidjn6dtwVuXPAAqWTFLKOPIU1MN/rHm4EGuyq4qJek7
         WXGlOmK7SBKCwVezq1j+0n7Nf9Hg9Qo1P6nC++g9IJL9oOYurhlB0F2tscEziHJoDpJv
         LEyYZFVNrcJpkvTfCezojK4Fey6eUR0SncbrtfaGxKOdsd+IbwSa71yT2SUZD0AMxuJB
         XNCg5dENhJ0zvqLdCkYiEIHOXNVGJUNGGu478gfCZbyU3sHjO2dchqkATbKAlYL7+1Oe
         dGOI13VETKy+RhioY8fuvfVFgqWVVkK4w4M0tfe5hxGJyWPYviIBBLrOjqMf7qgpCIGM
         xXkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rSzAY99uRrNw//PHBQeFYTZmjjxqpMfzg/YorvEuKMw=;
        b=U1Q5lcL0VZG9ATaJoFZWQTG3CghbRGWR+P7OLxkJ+UaA4gEaN5DTQY45hClDL/fBXu
         zKCVt4lx0uvgiLQvmqVY7J3en57RNkT1/hoDhyV0c0DE/qCy7L83ZrViquTlVV5YFdLA
         hbvMMpcT5yH2QyPz+cBLwOVmvi132fqJ5hsc7L0m9qGW2rSTgySPqyJ2S8bjr2ijt7R0
         K0UjkplQWtfuNuOxx9NlQWEnDgTcgd+wv9wTepssaDvIUYFFawqeCQ0/oMfwDyr7D26K
         3F7qGas9kMNHpHNenef6OyOXqu7woN7K8FANtPUX5GgYL4tvODyJSp7vXi05Ki9uCKz5
         8/yQ==
X-Gm-Message-State: ANoB5plbwTp18U/+HQbLczFyKCrxsW0ZvnGkve/WhrFPiTmZitEwBV5I
        I/whpHaCQktJuZPFa8OP6/rKzVU2v3qjb97XFCw=
X-Google-Smtp-Source: AA0mqf6LxPF73exygyBCBUq8WPa+vdrbDJS2epYQYzO2LmqhuCTdWDeZGWGtOCOwGfJaHxk4jzxI9Q==
X-Received: by 2002:a17:902:f78f:b0:188:59e2:5f91 with SMTP id q15-20020a170902f78f00b0018859e25f91mr49197038pln.59.1671498965288;
        Mon, 19 Dec 2022 17:16:05 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b5-20020a170902650500b00186b86ed450sm7811815plk.156.2022.12.19.17.16.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Dec 2022 17:16:04 -0800 (PST)
Message-ID: <63a10cd4.170a0220.4d22.d434@mx.google.com>
Date:   Mon, 19 Dec 2022 17:16:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.160-18-g2007c64d18cd
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 157 runs,
 1 regressions (v5.10.160-18-g2007c64d18cd)
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

stable-rc/queue/5.10 baseline: 157 runs, 1 regressions (v5.10.160-18-g2007c=
64d18cd)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.160-18-g2007c64d18cd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.160-18-g2007c64d18cd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2007c64d18cd469b3d1cfd51efb4c14961d83a6c =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63a0dd2b8cba6c8b7e4eee24

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.160=
-18-g2007c64d18cd/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.160=
-18-g2007c64d18cd/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63a0dd2b8cba6c8b7e4ee=
e25
        new failure (last pass: v5.10.159-16-gabc55ff4a6e4) =

 =20
