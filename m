Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFE04E35E5
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 02:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234608AbiCVBSN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 21:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234602AbiCVBSM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 21:18:12 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 135171C935
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 18:16:46 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id o13so11520946pgc.12
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 18:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RzutYkVMFx2T/4ZfyN2rD9PZJTqYX0PfUX6JJ0WhESU=;
        b=iltpnasGK959bUG7o63026Uz6kAlvzUQNMNeZznAH/xB+xnW8r1c7kUxADnWmgJ7U4
         jELHTnBYkiAz0VKTbMyy+R2KLIg1CRHhHIXDVSSGqoQRVPHQyLjYVYtziRDzZ10OxO4T
         pie67B6lyE+XVSMU4d7T/TvX9xpx0Q/iUxJZjIlj2Is4ZrXB/F/6EVAfLGItgdmEDqHn
         UZ+LSd+YY4p68UNY8iWxpVNQzWJLaezNEEkv5lmK32lMoE1FhCuQ8MUTvDybxtp2nDTI
         5w3ZdmY8kUX60gxQyD2H6F2P/OXmno1atr9h9RheP2+PPvYMSOOu6ZozL83Ux9rn8pdY
         P0LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RzutYkVMFx2T/4ZfyN2rD9PZJTqYX0PfUX6JJ0WhESU=;
        b=RCE6vsYyCvnc0HEzByNbxJoUtUtcV2q+fTKQgslF8NmJEDUxKM6gCXX7xiEqyeMwn+
         dsxbniVVcx43N9grhczOQ/KtQpCqEFy3VVe4Ym54QnZxNaEVJbpTmrojcJ33YApEei6/
         vcsoTmCl2x/FyclsGCxAwWUHFNbZJo5ZbE9turUfw+iR5FqvLyR6lDFK5ftTA9aGwjzp
         qtT9B+EX+XVQVg1N+l1/3T451Eizp6UdUgZVzdTZDxJrBxQK0/F7E7oVb1xUgQJJwAWQ
         G6P1dmidHiquyTfedHVWdyKVOtgePIP81anLvblGIen+KgqcuD8Y9Kkj+yKzM+kM85xd
         QciA==
X-Gm-Message-State: AOAM533WNytn2epV0JBLTw5CV/OkGrxCidjQbzB2e/RZzjQS4FaFWQ+2
        n0q9QAZMLcGPC1iU+OetNngH/DzyrGYC0f7/kKs=
X-Google-Smtp-Source: ABdhPJzhqV+FF4r5an0rN/PSZ6yMz1XIMVaRIf+K7zAupucLj1g+eAcNPvJCStRw00PaBIhamH3Snw==
X-Received: by 2002:a05:6a00:ccf:b0:4fa:abfe:e0f6 with SMTP id b15-20020a056a000ccf00b004faabfee0f6mr4794623pfv.67.1647911805418;
        Mon, 21 Mar 2022 18:16:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i6-20020a633c46000000b003817d623f72sm16056905pgn.24.2022.03.21.18.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 18:16:45 -0700 (PDT)
Message-ID: <6239237d.1c69fb81.28900.c5b1@mx.google.com>
Date:   Mon, 21 Mar 2022 18:16:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.107
Subject: stable/linux-5.10.y baseline: 89 runs, 1 regressions (v5.10.107)
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

stable/linux-5.10.y baseline: 89 runs, 1 regressions (v5.10.107)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.107/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.107
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      4c8814277b5dc2b9d2745c6493614b1ce10cef09 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6238f61c30d6a27922217305

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.107/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.107/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6238f61c30d6a27922217327
        failing since 12 days (last pass: v5.10.102, first fail: v5.10.104)

    2022-03-21T22:02:53.566840  <8>[   60.119337] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-21T22:02:54.586944  /lava-5917543/1/../bin/lava-test-case
    2022-03-21T22:02:54.598165  <8>[   61.151908] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
