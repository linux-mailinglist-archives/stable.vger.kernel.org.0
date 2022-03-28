Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09C9B4E9F12
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 20:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245267AbiC1Sk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 14:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245265AbiC1SkZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 14:40:25 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49002633A2
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 11:38:43 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id bc27so12891799pgb.4
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 11:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NOCrcKKhjGORXar8m8jYVf0enym8oD6amDXn+meCYPI=;
        b=cDDHASp9PYmIRukmN8tpK1vgijeDQI8bR2nxQL5WSxdEPTOQkahMgWprAHTEVZCqmm
         Wlu/SaQApfOgczrlH1oKJ4r0fitpQPxo7g33wPIYAbyz3mNbyzLHbaO5esBw6IMJ8Jsr
         Om9O5DmxU2E0VovlGzhOeM/pG5+rwtVxnofioqPXF3gmN2/APZjxXK4K3dg4frH/b39f
         4I6jdkI8lUrjsJ20uwb+Dc9FVOGYpVHoJza0Gr+bkqivCu5IKIvtTqgwbJ/xxXAGdpHM
         7iABfVZJXY/0U7YcbGFFxKkIQMrJOfwE+WXA2lK9nwdTxHSQJkFJKhGxVgXymMWh1WYp
         fJZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NOCrcKKhjGORXar8m8jYVf0enym8oD6amDXn+meCYPI=;
        b=xOB6CPYNOZIRQJ2rrKdcQBgTHiaOmwjMaUrjg7F84PXPUGTZlDS2M3QpBCyTkLrkoM
         NeX5h9COORP0u8L/7dajkeIYNNKFTKm05NnyRdtfYZ14dTc8mnV3E78euDWvauH1F7ly
         RR6vi6NDXuZbT/LofE6IiiEFs5NSgjYJoEnmPx7ymP75EVPN6p9xzLd32ORSQO8exo6B
         KmxJXSjzPDbJONeqEsTl6k6ZW4tKBN8cr3+RNkxtWha6nRck8RC8nVWibihnapiPhREr
         Liccf7r643NlQZYhR+bF0VCzNoq9GBDSm2pYbrdlmkBFQc7wXEeu56i3uBxPpHsM7oe8
         IjDA==
X-Gm-Message-State: AOAM532AKtwIvnPDaf68MLISErh+lLT+QMgxnWabZnNRSOAKN5wzMxFS
        rVC1sM6/bhRdqCz84y3kRO+PnkN9z8ZjvXDYLIM=
X-Google-Smtp-Source: ABdhPJzNQkS90xypg4MR71/lfwlkuv2Br00qYEHSDwcNvViE8WDyN3BxWJGVoKRxsa9nr4eonU75VA==
X-Received: by 2002:a05:6a00:21c6:b0:4fa:914c:2c2b with SMTP id t6-20020a056a0021c600b004fa914c2c2bmr24503935pfj.56.1648492722584;
        Mon, 28 Mar 2022 11:38:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m8-20020a056a00080800b004faa4e113bfsm17569937pfk.154.2022.03.28.11.38.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 11:38:42 -0700 (PDT)
Message-ID: <624200b2.1c69fb81.fb2d9.d879@mx.google.com>
Date:   Mon, 28 Mar 2022 11:38:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.109
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 120 runs, 1 regressions (v5.10.109)
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

stable-rc/linux-5.10.y baseline: 120 runs, 1 regressions (v5.10.109)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.109/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.109
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d9c5818a0bc09e4cc9fe663edb69e4d6cdae4f70 =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/6241ce545681f4e02aae0690

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
09/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
09/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6241ce545681f4e02aae0=
691
        failing since 4 days (last pass: v5.10.105-72-g1ef0e2b31490, first =
fail: v5.10.108) =

 =20
