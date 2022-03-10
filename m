Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F57F4D51B0
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 20:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232458AbiCJTVs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 14:21:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232191AbiCJTVq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 14:21:46 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4030EFE43D
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 11:20:45 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id gj15-20020a17090b108f00b001bef86c67c1so6119998pjb.3
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 11:20:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mpM1BakYXcdJFnr3f2mX4w5coKiZR3H4TTCTFRveKZs=;
        b=zRVHPOyyK+srmr2m/ETcFT34H7TT8++09t5xmUZRr/5/DAumjnml5mbvQ4SDqavOct
         iE6ks/zqqoUxGRk1uxT4DUU/hz2nOi1jSHuSj5ZIQyMNmxpvRmKRTgAkd3vkVScYwnlS
         9lVpBYrmrZx369OMODxb/MIYFtdjddeSIUyy5tP0Sw5vYoSmyZ7aaVhFxb7//G/vEBQX
         rbWjx6cpA8Eg7uWR4weHKi3YReCB9+9J6Xn3MWRLDfLXGBxSmchpTLotxZq+Rasw1TDr
         9r/TSmura+eJaAEh4rmUH4OfDSrkNYK4uGa8mbVBPP8uQWNrMitFc/4bg27pWwOnn6Mt
         Al2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mpM1BakYXcdJFnr3f2mX4w5coKiZR3H4TTCTFRveKZs=;
        b=X3m0ysmWi42WQv5ZMBukd8AKK7P4eFSKRuguFITyTwn/OyT39vkWUperHD4+rxeYQg
         MvINkObtTGk/1U0jiIN3Ee37EAOXuKka+IXj9nzhdeVZEfnJtQnAYo2pJwBS1WiGjO4a
         d5jGZBUFRV6PadROw64gP0XJDYLbnZa+mG2Oelnu3xt0pUET5J+GXIEN2YbXxu8P/ba/
         vVGXGIHCp9832tmzbzoXLD5A1KDHCrCNXEgPPIO/vBfuXVsK8kzpZMi02+soyW0uxnwo
         +Ps+jyl2W4qPq2jM0uUuHEokQOqEyLk+Aq5nXuZdCs7qplLLxJfZ/46Mc2VOYk+tRO3z
         m7Qw==
X-Gm-Message-State: AOAM532RxHPp6ZQUdAvPFPe771y9ciDQu9A2R4UWdPUIUWietWDz0pFG
        hIC1ieprFNFBTDX3/FlBK05rPwA/qYLxJnqYPcg=
X-Google-Smtp-Source: ABdhPJyAr0mHaoiUpHcJK480hHBJxwJSLy0cmUElZZB2m7yx1SB5ag6FUYp/MngY2yj6+Mp/vHlnZw==
X-Received: by 2002:a17:90a:6001:b0:1bb:83e8:1694 with SMTP id y1-20020a17090a600100b001bb83e81694mr17588942pji.127.1646940044519;
        Thu, 10 Mar 2022 11:20:44 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l2-20020a637c42000000b003644cfa0dd1sm5988646pgn.79.2022.03.10.11.20.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 11:20:43 -0800 (PST)
Message-ID: <622a4f8b.1c69fb81.3e677.ee7a@mx.google.com>
Date:   Thu, 10 Mar 2022 11:20:43 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.16
X-Kernelci-Kernel: v5.16.13-53-g2ec2cdfafec8
Subject: stable-rc/queue/5.16 baseline: 78 runs,
 1 regressions (v5.16.13-53-g2ec2cdfafec8)
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

stable-rc/queue/5.16 baseline: 78 runs, 1 regressions (v5.16.13-53-g2ec2cdf=
afec8)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.16/ker=
nel/v5.16.13-53-g2ec2cdfafec8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.16
  Describe: v5.16.13-53-g2ec2cdfafec8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2ec2cdfafec8337a7932f476a6c0b00244f41e08 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/622a19fd5ea7436c66c62968

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.13-=
53-g2ec2cdfafec8/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.13-=
53-g2ec2cdfafec8/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/622a19fd5ea7436c66c6298e
        failing since 2 days (last pass: v5.16.12-85-g060a81f57a12, first f=
ail: v5.16.12-184-g8f38ca5a2a07)

    2022-03-10T15:31:54.561250  /lava-5852264/1/../bin/lava-test-case   =

 =20
