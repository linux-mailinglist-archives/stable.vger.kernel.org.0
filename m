Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 105FB5079C7
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 21:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235270AbiDSTFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 15:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240570AbiDSTFi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 15:05:38 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB9803F31E
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 12:02:54 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id bx5so16291300pjb.3
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 12:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hl6f3XHcqI3oNNlBQJqzkBUB0gg0cVs5zqLLZ+dA9CE=;
        b=0vKDeRjwkiJItt7siM1pPtHvio39sl/A3UA/X8fLcFB8/H/l13lBX89VKcuyps2yFn
         Jn6l6wGXgfFl00T/NpYOlplSqBlp6cLTpb2b/rbOJJ2jOc+Ms21TSgCnzZfEwKP4lL3F
         aSDvf4upOV54axOQZ3leF3sNX8GGQhQ/hAkKUf5h3EJwu9V247MPMjCyl/fzFQMcTTTt
         4zyv+yTv7T7ClW9W7HkMArVMJG7V+JPqSwxJv/Ijz3tFwoBAwylgwkl2GeXnFTICWnYY
         KNK3MygkdvRA8bCiQOQx9hKlcgk0xMB4snZJMtCfxhWtwSX+iqMYyw8vOdcY/DlbMs4y
         zPtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hl6f3XHcqI3oNNlBQJqzkBUB0gg0cVs5zqLLZ+dA9CE=;
        b=3AWVHvfD0EScga+E663Qjj3G8kbYnN1qnwuYJLX32BdcghrEK7bYp2+15d0RH7ZGfz
         +onWTnEKl5DWFs/xfQqSwDnCMcTuoah/DHOX1R44elVUdClP3RzmMM23ZyQGL1YhXYix
         sZ71lK0yHiwP/ae0VpnDhB3TxnVup0zuV4oFQIoZIFF7NkuFz+wGq6z16z4nCTQXzER+
         8yR4EgPoc9akxdoagDt5c4ISpRjCbIEOEHrXeF4bJaepfa91i+0Jv+94NLumpCLP2pwB
         WCnCDpfqtHkjA8nIBvWg1GVpfWIozyXQAlfJKHXTaDxTWp5IL60wLKFZaLHPOMrcAUVi
         O2Mg==
X-Gm-Message-State: AOAM532M8UGCsfK7aySeovLkNrYbCPYq3stYzfjjCTOVxPVdrNV8R505
        b2w7bSqj4/oyAZYz5X8LN6vHgltF7OpiikBl
X-Google-Smtp-Source: ABdhPJzX0fVAWBneS+StAZ5PY376PvmdaQC2ImEPNTZ6V1f8yDL3Y+TQ0GpWv44o+gZaDmESRfe5kQ==
X-Received: by 2002:a17:902:e84d:b0:158:cd1b:8168 with SMTP id t13-20020a170902e84d00b00158cd1b8168mr16737954plg.43.1650394974222;
        Tue, 19 Apr 2022 12:02:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l6-20020a17090aaa8600b001cd5b85d664sm19763105pjq.1.2022.04.19.12.02.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 12:02:53 -0700 (PDT)
Message-ID: <625f075d.1c69fb81.28282.ed02@mx.google.com>
Date:   Tue, 19 Apr 2022 12:02:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.111-104-g09b77ec63e5db
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 101 runs,
 1 regressions (v5.10.111-104-g09b77ec63e5db)
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

stable-rc/queue/5.10 baseline: 101 runs, 1 regressions (v5.10.111-104-g09b7=
7ec63e5db)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.111-104-g09b77ec63e5db/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.111-104-g09b77ec63e5db
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      09b77ec63e5dbcee6af2955a5a16c6a8b349da47 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/625ed2e04f84a949c9ae0695

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.111=
-104-g09b77ec63e5db/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.111=
-104-g09b77ec63e5db/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/625ed2e04f84a949c9ae06b6
        failing since 42 days (last pass: v5.10.103-56-ge5a40f18f4ce, first=
 fail: v5.10.103-105-gf074cce6ae0d)

    2022-04-19T15:18:50.438314  /lava-6122915/1/../bin/lava-test-case   =

 =20
