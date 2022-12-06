Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 187EE6449DD
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 18:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232865AbiLFRBa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 12:01:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232198AbiLFRB3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 12:01:29 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DD3328E10
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 09:01:28 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id n3so10816576pfq.10
        for <stable@vger.kernel.org>; Tue, 06 Dec 2022 09:01:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=8PbB0JdE+NSiWHGfWLPtoReMHS+kZC7g+F/sxQmitAA=;
        b=ughzuFDux7dLievxNhXem9sTnpA/nCqy7vebuj0u3buiSWJr0Fb2VfVABVTVwTNPw0
         Av28VIuDR7oJnEjyCgxJIfLZOPzRVaKxPd4prmyTqD0prDwbR8kL61hMhuYDjQQ4OgG+
         3jt7Gr1t0kZCoTzeMXWTsgohdTRmoyJQT8R9hu4O8p+31Uwd5+2IBSyNj6DE6vW5vyNd
         f5zbTJNbOZaiRk/xKwGsw4ZepKMF/pye/kuz6pX1OX0qrnaO6iOijQ4Vn2qlRvmH0mgF
         IW7Rv+MSgk5SCACVLZpi7U8v4uqHXVki3QQUUadV+djs+ONpTA6I2VuaFrhEgjmZR6KM
         E1BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8PbB0JdE+NSiWHGfWLPtoReMHS+kZC7g+F/sxQmitAA=;
        b=4wLYnoNsUoIuwYRIhLt7PuCI1Xfy64u8c41b1LUkfTxXIrf6bf8nK6ClDDcJ3+fUr0
         5lLTejGdB6gC/N3DLRi8pB+02DmgChMkyAD8s1fSCB4moJ06y7z7VV6kLa7DDCK5hHwl
         BVJc3C3V2Nu4XQS4BGlpO+Ob1slKhzAgGqmBtzEmg68LzMFSR4cWIBcUCKmUR4foB+RQ
         eNnHIfB2HdW6piqB1otsAb/6CcGFPt9Y0lKBUSRQl0f73c2RCEqCKFbvAhb85yEufWbl
         PmTKajW/TQRoE1OJTKZOCe6rhZ6Gowqm/ZaWmgDBcDwmAzvJmiH9/Cn2q9NUV9AphfKU
         ydSQ==
X-Gm-Message-State: ANoB5pkofwHnzwebPGinSPeFqAHgm3/Qh38/lvfjNMKZHZMT1dEMipwJ
        l06ZeL3zZ97f2gvcndVZITnOZjixtPYmEMKmgnNyJA==
X-Google-Smtp-Source: AA0mqf7grZ/dQSQcyZ2A2IWhNzXzC/UIvNAst6Z55x7QbwykVdNNmTNaTEArskVuUfj6qD8V0FVZqw==
X-Received: by 2002:a63:1664:0:b0:477:bbc6:9221 with SMTP id 36-20020a631664000000b00477bbc69221mr56822321pgw.352.1670346087550;
        Tue, 06 Dec 2022 09:01:27 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q1-20020a170902dac100b0018941395c40sm12925982plx.285.2022.12.06.09.01.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 09:01:27 -0800 (PST)
Message-ID: <638f7567.170a0220.5cdf0.7b73@mx.google.com>
Date:   Tue, 06 Dec 2022 09:01:27 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.157-96-g6b1c6d5296c8
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 136 runs,
 1 regressions (v5.10.157-96-g6b1c6d5296c8)
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

stable-rc/queue/5.10 baseline: 136 runs, 1 regressions (v5.10.157-96-g6b1c6=
d5296c8)

Regressions Summary
-------------------

platform   | arch | lab           | compiler | defconfig          | regress=
ions
-----------+------+---------------+----------+--------------------+--------=
----
odroid-xu3 | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.157-96-g6b1c6d5296c8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.157-96-g6b1c6d5296c8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6b1c6d5296c8d94683dc49469c3bbea78024a2e0 =



Test Regressions
---------------- =



platform   | arch | lab           | compiler | defconfig          | regress=
ions
-----------+------+---------------+----------+--------------------+--------=
----
odroid-xu3 | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/638f42e74e0961d9162abd06

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.157=
-96-g6b1c6d5296c8/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odro=
id-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.157=
-96-g6b1c6d5296c8/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odro=
id-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221125.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/638f42e74e0961d9162ab=
d07
        new failure (last pass: v5.10.157-92-g362267195001) =

 =20
