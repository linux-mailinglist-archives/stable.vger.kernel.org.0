Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1353A4DA2F7
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 20:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349577AbiCOTHO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 15:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351268AbiCOTGX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 15:06:23 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 495FB4A3E6
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 12:03:53 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id b8so268782pjb.4
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 12:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FR8zuS8m7J+Uesy6qejEsMdVivdp2zT2G12qp9WWuXg=;
        b=UzNoNKwvI/+cgFzlihhQj+fF2Fd9v9pdIND8KOi/SQp+HlFP9cNkdGkt+Q/rVsrj02
         PhWGlU9m31h5bfZqgUAATZvZq0JVTs8ZexVPu8inLUakcSbKvan3jaoHuKnSX3+6nJ8w
         7mFHpyDDWNPUb8i30nWWwcpKFXuENJBvP7zbP0/rB710tVGtVp6MiBPypsZWXWcityXZ
         9c3+oUjIF/K4P2wuwB1YhyqtrfK+1w7r5CB/QmC5AJ8p9F2NESqZeng1wyd/OahRQMCY
         j2pb1AbBxZ2tlhCUwF9jq3CV80qFWL3m+u9xJyKhXE7FxZDNnMrWIbwSOroiX06ak34m
         MUTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FR8zuS8m7J+Uesy6qejEsMdVivdp2zT2G12qp9WWuXg=;
        b=2bYLkVWS2EMfDyPmui4US9ZNdHpPyzJqZEemW1N9d+nl3GWIOWcUmFDLvYXYqD0tHW
         62t5ze2iMNK0GAk/N3jhHmC1O6K1qqzbURVwgh7/RA2VIhzGvDMk2UoraQXz2sbxGPuW
         BqHIDv5vct62UtELGmOCnDB5lHzAsX/N9TsR/AcuvJ/diyps+PToGl2j0xFav0YaW/dZ
         H7ck5yUY+ZZox27u8mf0Z6POYQhEniV3WST3pRZ/jvbQsOYsZni42O32uz1rgsJhEQPO
         rvwtWlJ8vj6rbdWK+j/AgeEUeSJ+ex4kxKqh3lB58AWHpPDLpWxHhUfSA/XiuiPlyYoa
         HV6Q==
X-Gm-Message-State: AOAM532/YEkOrNgPhyxomtZZAvYD8sI/7qENLOXR/w3SZPyrZalARTHt
        +F5VujVrfQt3Ozlyh+kMUEhaBWBVb/umHIzIMYE=
X-Google-Smtp-Source: ABdhPJxYROhwiONXjC0Mzv6r4aKDyD96C05Huf4DSptjRC1MUdTjKvj8l/3UTuB5o/u7TTlNH/BQJQ==
X-Received: by 2002:a17:90a:d584:b0:1b8:7864:1735 with SMTP id v4-20020a17090ad58400b001b878641735mr6190971pju.126.1647371029499;
        Tue, 15 Mar 2022 12:03:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ic6-20020a17090b414600b001bf691499e4sm3748761pjb.33.2022.03.15.12.03.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 12:03:49 -0700 (PDT)
Message-ID: <6230e315.1c69fb81.a1862.98ae@mx.google.com>
Date:   Tue, 15 Mar 2022 12:03:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.234-29-g655878b7b44c
Subject: stable-rc/queue/4.19 baseline: 65 runs,
 1 regressions (v4.19.234-29-g655878b7b44c)
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

stable-rc/queue/4.19 baseline: 65 runs, 1 regressions (v4.19.234-29-g655878=
b7b44c)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.234-29-g655878b7b44c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.234-29-g655878b7b44c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      655878b7b44c020a7017001d47fea4214a5600da =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6230ae24627c3b338ac62976

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.234=
-29-g655878b7b44c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.234=
-29-g655878b7b44c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6230ae24627c3b338ac6299c
        failing since 9 days (last pass: v4.19.232-31-g5cf846953aa2, first =
fail: v4.19.232-44-gfd65e02206f4)

    2022-03-15T15:17:42.805073  /lava-5883702/1/../bin/lava-test-case   =

 =20
