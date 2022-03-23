Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 344DF4E5996
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 21:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237339AbiCWULL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 16:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239934AbiCWULK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 16:11:10 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64552694AE
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 13:09:40 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id k6so2603761plg.12
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 13:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bqbkkfQ6DJeWwPjXhaTf4dOtRWnm84k2cLupIbOddZM=;
        b=z4i1cmanH62I61kXSoNn1uGhTGyEDTffIogFS2jUJZclh10Iyrj2nD+W99z0jjmfe3
         2miXRJ/8Ru7NFRU165OqhnpN759s4HxM1LIFC67BNM37oA9CIzHr4CA5PVArHP4czEbL
         63BfcsSJGk7xorXZZjwEIY6d152camLVz8kcKhEgPNhkHIRIiS1UscSsEbeaoN7yp/rS
         k6YlQbD6Qq90nsNzFR+mxvZ5WzBT8SCkaNCHYq5G4/EEb5Q4XFTccOXqZ9ukC46aoCW0
         VbZj8Tr4SWN273XR7MRgGRwFFAeR9Uj1s2Y4bfI0Mk9yZ972R1vw684+NgjI2ls07FMJ
         oY6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bqbkkfQ6DJeWwPjXhaTf4dOtRWnm84k2cLupIbOddZM=;
        b=7UEHcexLN3FowKQUWAp9lC5nP1SX7W+Eao+5eHx3Jrzx54hl+79hGOUduvAZrbExQh
         OltqZHGG8OKkriblm1UF9ug8b1J8qyGEqNWHmZWlC4Nm86ZN3Hdpo1WlO/vNP6INFI7J
         sOpLVGiMQ4TuMUKSz4wHIiccsAKngxGGitVf8XzKXkt0KlMkkglrDQfMwMUZ2J1Sddcf
         ohrvwUCS6xMyRseEFFveoBpoV7hbPXwFZdklNwMyDzDqsDbZfYqRKT6SxBca5ZUMAUDs
         SFrlv8osGqUzcJNpeX0RxvL3KeP+iRGJ0N7HS5DqC6WbMLjRI8ZtshwWRr0ZmKINYJIQ
         +KDw==
X-Gm-Message-State: AOAM532+R72/a1gnhx+X8mjD6vN+6lXjRcAA4d9We8nhD0ede4gqd114
        Q3XWza3y7eSO2T7JETYFyjusecF/SllLSNrgVDI=
X-Google-Smtp-Source: ABdhPJwQz+l3vUVheVdoxAiuivKgk66a5f0gj1bnBUAgJNdj+5mrRnHB7aA5nWpPhgYGwLPqY1inAA==
X-Received: by 2002:a17:902:d50c:b0:154:5090:8126 with SMTP id b12-20020a170902d50c00b0015450908126mr1845656plg.133.1648066179707;
        Wed, 23 Mar 2022 13:09:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e3-20020a636903000000b003863620133bsm176306pgc.77.2022.03.23.13.09.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 13:09:39 -0700 (PDT)
Message-ID: <623b7e83.1c69fb81.ef4e.0d39@mx.google.com>
Date:   Wed, 23 Mar 2022 13:09:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.187
Subject: stable-rc/linux-5.4.y baseline: 53 runs, 1 regressions (v5.4.187)
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

stable-rc/linux-5.4.y baseline: 53 runs, 1 regressions (v5.4.187)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.187/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.187
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      055c4cf7e6da13450016942e5286492b4a224868 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/623b54666654b9a445bd91aa

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.187=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-=
kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.187=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-=
kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/623b54666654b9a445bd91cc
        failing since 17 days (last pass: v5.4.181-51-gb77a12b8d613, first =
fail: v5.4.182-54-gf27af6bf3c32) =

 =20
