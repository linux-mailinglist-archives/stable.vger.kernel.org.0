Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFE994F47E8
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 01:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347248AbiDEVWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 17:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457659AbiDEQ2U (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 12:28:20 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD937C166
        for <stable@vger.kernel.org>; Tue,  5 Apr 2022 09:26:19 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id n8so4344509plh.1
        for <stable@vger.kernel.org>; Tue, 05 Apr 2022 09:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UfjR+IkQKqNfi3MRgwHzLg9NRC+yguux9qV1miFezqU=;
        b=7tpqNiYe82st3YwYgimFV2YDD/1es7e+8dQvxGlhGNxLNAPDVT/Fn+hT62uVx9WksJ
         NPtQWHk4jTuFUeT5Xp1o4EIuJokcD16tnRrLzXneJyLGNdTBLnfADg07liBnaTb2p0/W
         Hx2qD+hvypmeaVomFpEHKaCdaoSmr0QYmOsjjMFCee4IbI6lEeE4lCTY32rtucjLdZqK
         HTTDJLwJmkp2H3XzVyzg67FF2aSIcLPq0K17HEu9LtM+bYTJRfprGuBSa0dSUJp89TQT
         mB6rr6gK8oSV2QkaSyI3hkuX5R557seiuH5iQMMzhDLT5w81XCM/DapMccYLUpxkVW8S
         Gapw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UfjR+IkQKqNfi3MRgwHzLg9NRC+yguux9qV1miFezqU=;
        b=tkU/LgsAVOyvAYWzHy4JthWgg7r3gwSjAagzVW2WzI+gdOosckGfSWq2oY/PdN+OJC
         E757uL1rqd0nwDXrJcGcXrWtKId56a1N9vYbb+L/i0GmLP5/w+Fpn79GHWmZ+wZ2wucT
         ObxHBCRV2pxaaN54yrY8sqjueij5V70hTUJnrip1GS4YfHYQAyQPw01Jg0EfSygIXbHn
         x8sO/kuPFSyVX6KNxuGN7mbsRFED1Y99DX9J5hRYvBsE/Lb7LhmXUMqHINrmQ09ysXIR
         hGr8ANAhUSMP5Kid9yS97CaKGnIGwIr1jCRJ8haXSqhVli8qCD2zhDszYblEoo1xFTlX
         RZkg==
X-Gm-Message-State: AOAM531yFfnejXzHFvV2N6eIshWTbT8oN/ZrFbIv6cPoS/L97IdAdzdp
        MZLaoA7W/iRVTSll3HIO2z6g+mrHJ7ZMuM274ow=
X-Google-Smtp-Source: ABdhPJyuuD5cx5+cOwjH2L6XVYczb1UydVj8xFO40ax+ryXNtAYEOhQPA0fjwEcwA+vfmvPnfAA3VQ==
X-Received: by 2002:a17:902:f605:b0:14f:5d75:4fb0 with SMTP id n5-20020a170902f60500b0014f5d754fb0mr4290601plg.101.1649175978824;
        Tue, 05 Apr 2022 09:26:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h8-20020a17090a2ec800b001ca0ce2e2c8sm2855136pjs.47.2022.04.05.09.26.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 09:26:18 -0700 (PDT)
Message-ID: <624c6daa.1c69fb81.14e1.79c2@mx.google.com>
Date:   Tue, 05 Apr 2022 09:26:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.237-257-gb6c6c89e9f49
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 47 runs,
 1 regressions (v4.19.237-257-gb6c6c89e9f49)
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

stable-rc/queue/4.19 baseline: 47 runs, 1 regressions (v4.19.237-257-gb6c6c=
89e9f49)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.237-257-gb6c6c89e9f49/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.237-257-gb6c6c89e9f49
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b6c6c89e9f4981fdefd1d6a8c76c9acfcf746e5f =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/624c45e176b9f087d0ae0734

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-257-gb6c6c89e9f49/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-257-gb6c6c89e9f49/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/624c45e176b9f087d0ae0756
        failing since 30 days (last pass: v4.19.232-31-g5cf846953aa2, first=
 fail: v4.19.232-44-gfd65e02206f4)

    2022-04-05T13:36:21.275183  <8>[   35.859514] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>   =

 =20
