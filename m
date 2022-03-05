Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 371764CE693
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 20:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232243AbiCETeG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Mar 2022 14:34:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232249AbiCETeF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Mar 2022 14:34:05 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58D4BBAB
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 11:33:14 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id 27so10221393pgk.10
        for <stable@vger.kernel.org>; Sat, 05 Mar 2022 11:33:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KaTr98yAF89DE7Q5Cox9fRZjgjz8kaRu0+jjcmiMpH8=;
        b=t4BIj/pC82JjokhSN3gqD7LEP079G2MiLLrrMm1EkrYnomITcNj4okeMed1u/Id7U8
         23qAuMjZFEk17hyPJZshNjdhSaAtveZwn+kySf07qF8xYKkiPByQCRpQkYLonE0oxKni
         KSfhvoD31dsU6U6G0SOKBRNusdoTDGLXCfxdYOgx74iWeuoBR965Q/1i4jpKp4hv3Uw4
         RCDmzdAEQlCEv0EALqZjQeHl+0yUVqVRhfUb4qoB9/ivQRPiFCeUcWCko/nImsO2vc6U
         BH3gviooKgYta0PiBqTTARutQEEeaF4H5HEAxsybvfGzLhox6Lrd5/oXqU5qQYnQG+vu
         0hXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KaTr98yAF89DE7Q5Cox9fRZjgjz8kaRu0+jjcmiMpH8=;
        b=CkdPt/VHaUVlRuePKVybGWfEkJAO8pkGZVzpFx4VP1XVv0stDa6Xm0b55A8bWkLgU8
         2yZ7RLXk1aKyrcbr1SyYPSKr1G1R9CrdNyKykCU+NbwvJTJa19M3knjTIWkytHkTl8Vq
         OpJCnMJ7qVDypLHVXf7pb06c8k+ooZhyz5iAdgNdzu0YW0kbYEtvXtUzalFWlc00OW8I
         OUDF9gVm9qwzcy0l7RyDfyGQtdLdlim/YzKiRO+6XkT8yYnQAdkLGG45Uo4LFz9k209U
         POFdummg7xsiiMxFpNpoC+/5sBdiZHbd9Gdo9Q11AGGAhEZOIoj53tUVNC+kaDI6uhPr
         5/0A==
X-Gm-Message-State: AOAM5304yo+c5qHP5sqzuUapACT80TzDOb+/gqBicoIrhyatOaYrR7Wh
        49rBQwiW92wxlAgrKkJ50Uz7bWHlayOVSQhnT1Q=
X-Google-Smtp-Source: ABdhPJwwjhuuvTfzDmuPhf8zOhltjsnBv0XpT9XhPEI6jFWQWWDW+Kowo9pjR8PF3ocC9eOkja8Geg==
X-Received: by 2002:a63:b30d:0:b0:378:c5ee:afda with SMTP id i13-20020a63b30d000000b00378c5eeafdamr3763949pgf.385.1646508793619;
        Sat, 05 Mar 2022 11:33:13 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 63-20020a17090a09c500b001bef3fd20b3sm10972743pjo.18.2022.03.05.11.33.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Mar 2022 11:33:13 -0800 (PST)
Message-ID: <6223baf9.1c69fb81.1a4bd.d27c@mx.google.com>
Date:   Sat, 05 Mar 2022 11:33:13 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.103-56-ge5a40f18f4ce
Subject: stable-rc/queue/5.10 baseline: 126 runs,
 1 regressions (v5.10.103-56-ge5a40f18f4ce)
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

stable-rc/queue/5.10 baseline: 126 runs, 1 regressions (v5.10.103-56-ge5a40=
f18f4ce)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.103-56-ge5a40f18f4ce/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.103-56-ge5a40f18f4ce
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e5a40f18f4ce432a65e7c0b4fe5fde02799095f2 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6223a269a63325e702c6296e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.103=
-56-ge5a40f18f4ce/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s9=
05d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.103=
-56-ge5a40f18f4ce/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s9=
05d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6223a269a63325e702c62=
96f
        new failure (last pass: v5.10.103-45-ga9cd4525baaa) =

 =20
