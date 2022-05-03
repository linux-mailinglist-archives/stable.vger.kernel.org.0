Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC7051853E
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 15:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235385AbiECNTZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 09:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236120AbiECNTV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 09:19:21 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B3732EFB
        for <stable@vger.kernel.org>; Tue,  3 May 2022 06:15:48 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id t11-20020a17090ad50b00b001d95bf21996so2171633pju.2
        for <stable@vger.kernel.org>; Tue, 03 May 2022 06:15:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=v/qgbOflhcx697FPuEPLGtgdlxWlvehRQ2J9rRzK88I=;
        b=h2VVUNaiJG1VI98forNVhL6lXWg4Sq1YTk4+6uSbyPu1Uoyi5pc0bhV7h/NgMhp0M9
         wI3nh5zP7NFhTCYIwE/GrSatlCUtAMO9SsHoCVh1kQ73asTMdS4oKH7sTeE+Y7KuXnEc
         ir3Smtfnxk4ahhLI21BFi0WYdDN899bFVt4vwp1aPHLiXew9mKSx07UDbDs9dyYxq1bt
         mbiLh3Yf7tCzKeQ9SN0Q/97wwvgIlXlhOSG28SAGJWfDedCnl+pP5sYvtaW+NGx5X4+7
         VMjPhy5xvaNZM2aFi3VkhtS4v0Vca4XLCrAvKJqDOHdt+XEFXUV+cuXQI0hMOShwnTiw
         A9bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=v/qgbOflhcx697FPuEPLGtgdlxWlvehRQ2J9rRzK88I=;
        b=WE/a81XIF5Vsezhp80Ty8U6bclQA09KzlsiG/O8hSB/hJ0I4Nw+rTTklNvf5P9YhCu
         3a1aP8BdH90O/fQZTsccslyiXdGyyTyyKUaNtd1une0CJfZx2/70KADs+wjt2wtTO5cf
         C36o3ZIebKACNHPSJDEoIiMFuf4hlC3dsnzc+5jCm9Tug1eNOzhgEr5hS2naI3ArCTAN
         KwyCTtqHdkPxjHmc8bLZ473XyianKeqdWfZTYl7FcasG7a+jxE/oGlMaPQNlBIZ0+IgW
         C0j9gTDt6ZH0rTazolMyeYH/rz6q1ONA6CzqBjmf9CLSJjGmnJx2c0GB3PzznE7iVynY
         M56g==
X-Gm-Message-State: AOAM530VonnN7xy0krzqGIzUB2aQE6bwr6kFLT1u7JAxEY9+C9IJARNr
        qTLPBNr589SxiwA3kzvapNZEwMRTiVRZbnWfziE=
X-Google-Smtp-Source: ABdhPJxtdQOYHNo4RLSN+8H4JKCryPza45GcSsQ660Ps5t4JKXaXhvEHm8EL6DM0aKZayCNLRYUkhw==
X-Received: by 2002:a17:903:1ca:b0:15e:8ed2:7716 with SMTP id e10-20020a17090301ca00b0015e8ed27716mr14928969plh.147.1651583748225;
        Tue, 03 May 2022 06:15:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k14-20020a170902ce0e00b0015e8d4eb288sm6357478plg.210.2022.05.03.06.15.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 06:15:47 -0700 (PDT)
Message-ID: <62712b03.1c69fb81.898f8.ffe0@mx.google.com>
Date:   Tue, 03 May 2022 06:15:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.113-112-g3a0b67ef7e5db
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.10.y baseline: 97 runs,
 1 regressions (v5.10.113-112-g3a0b67ef7e5db)
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

stable-rc/linux-5.10.y baseline: 97 runs, 1 regressions (v5.10.113-112-g3a0=
b67ef7e5db)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.113-112-g3a0b67ef7e5db/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.113-112-g3a0b67ef7e5db
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3a0b67ef7e5dbb0652ecc4e2f78e47d5ea252220 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/627104006ae7b011abdc7b58

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
13-112-g3a0b67ef7e5db/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora=
/baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
13-112-g3a0b67ef7e5db/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora=
/baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/627104006ae7b011abdc7b7e
        failing since 56 days (last pass: v5.10.103, first fail: v5.10.103-=
106-g79bd6348914c)

    2022-05-03T10:29:04.388318  /lava-6248164/1/../bin/lava-test-case   =

 =20
