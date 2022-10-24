Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3722560AF12
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 17:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbiJXPae (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 11:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiJXP34 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 11:29:56 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BFFB1A1B2A
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 07:16:41 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id j12so8554732plj.5
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 07:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=1y8VlLgrSV01w654TV3cWy46AkwKCKX4C8VLLFGNIko=;
        b=xjOhdMNjQsnTusHSHoSZUl/O639PT2skqf9ryBnxnhVjgywObnJw3In6bCYZUdTuF4
         qcS4Yww9G2vAlBs3YXPzrOtOW9Y2/LW+5yNSFhi9t4wKMMg3//K1bYvrJJUgpI+1n907
         if2xLESsdpdaAnMVt5MlXz5uZmJ0AJmKBD49QdUWDh1kGdjmN7RpqOalbwFfCYqZDmK5
         bcUHM583Oy0UyEjcjKXVoMOT+iSmNs32S8hmJU50Ib2xSjBsGjTYkoQGViISCApbDe2g
         tj2W4bIrZh8YmHZsysJCCgptM4O7hKZqmcHK2YyMdbLB3CAZtsp1iJ1ceC5yddVFkZ+Z
         Xkng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1y8VlLgrSV01w654TV3cWy46AkwKCKX4C8VLLFGNIko=;
        b=eP1FOA16HpUwQI8p1UVhLSf1x7EAE5aeIGsqRjgac98I3lBPsnVcL43obGfKdaephD
         +7TCIgd+8BUB77IzEQzsm3zf1063TM6t8IDD/n97jyAq88WECnIIVjmpzXYnbgDCiNee
         tN32gbaRq/f94bZxN3Nw6r20G2up5qnSvURcD7nM0FqzERkM7nFklyZRq8mEmz9g9Gf2
         PirjrQSNpqvf/OXFKbMn7dlYXaCZTxCLRa0sdZ2wA+2eW/Hnrh+vPcqR0H9dO2rlDNUd
         TF3fVgfYBCYdgxr5ZT4BSIY3uj70vKdqUKUQH/eN2cYQ2sCtNGQWsCfzPc7+nRP331pu
         J/1w==
X-Gm-Message-State: ACrzQf2Pu3IitQ6okNxFcxRQBHjdZKbyW/VmXFN9wtOzNGs2OSLKAjtm
        E06I7enwVs0XiUY0aeI+ZwojJO4NSa8yfUm9
X-Google-Smtp-Source: AMsMyM6HGHHTleexGM5Z0m4/Pkb4tOshFef4FH/ejOJo0Af8UryoypGzyzhH0tbU8nxE+Z3BBZXahw==
X-Received: by 2002:a17:902:e54a:b0:186:a3ba:232a with SMTP id n10-20020a170902e54a00b00186a3ba232amr6304345plf.77.1666620248800;
        Mon, 24 Oct 2022 07:04:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t10-20020a63444a000000b0041c0c9c0072sm17027577pgk.64.2022.10.24.07.04.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 07:04:08 -0700 (PDT)
Message-ID: <63569b58.630a0220.dc36e.f4e4@mx.google.com>
Date:   Mon, 24 Oct 2022 07:04:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.17
X-Kernelci-Branch: linux-5.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.19.y baseline: 159 runs, 1 regressions (v5.19.17)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,TVD_SPACE_RATIO
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.19.y baseline: 159 runs, 1 regressions (v5.19.17)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sc7180-trogdo...zor-limozeen | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.19.y/ker=
nel/v5.19.17/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.19.y
  Describe: v5.19.17
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2b525314c7b57eac29fe8b77a6589428e4a4f6dd =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sc7180-trogdo...zor-limozeen | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/635666b489edc1ecb55e5b48

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.1=
7/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-sc7180-tro=
gdor-lazor-limozeen.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.1=
7/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-sc7180-tro=
gdor-lazor-limozeen.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/635666b489edc1ecb55e5=
b49
        failing since 6 days (last pass: v5.19.15, first fail: v5.19.16-2-g=
6f2c61ac925e) =

 =20
