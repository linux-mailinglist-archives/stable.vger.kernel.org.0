Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3E6E4EA302
	for <lists+stable@lfdr.de>; Tue, 29 Mar 2022 00:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbiC1W1S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 18:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbiC1W1N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 18:27:13 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9644616D8DD
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 15:25:31 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id e5so15964641pls.4
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 15:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3tMcpCI+WNC4nXGUGP55drnUuoHIJ+Z310LUJO01hrI=;
        b=a38S2Zg+GGbqf4xzwP20px2q2xpHb8JJY4zh9PKySVYv05+J3HsLb6VmDf3nje0Llb
         kudP6CVgbSTpVHhvib7NM+LO2zgGK2yGH9lXq6OYiYlWnzhFCXTHJ4aZjQax7fwWt35N
         f5UymmYb1Bzm1oNhQqaYCgU9x7HP0sZbF/BXgMYlObdfp6OxCO5n7YQh9iMrpVA47zuD
         BbSU/5nv6XD7fK4F8aSoE9p4M1NaPdfz47eyCvreeyZo9HvyKPDULAXsh2/yd+IFiOjH
         6A/YkNhrjtAXO2/+ybzAATvXmn2g8hFCuE8SBYkoGBhBNxECCHNiJLQp/M2nGeIxK9P3
         dZqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3tMcpCI+WNC4nXGUGP55drnUuoHIJ+Z310LUJO01hrI=;
        b=hi91fnQWH0ENT0nW8b8ghhJAGWGJe6NTgM02+HR4bGGP/BhnCkYswXnxD9nYCW5Gjz
         BTeDfrQ1gxtGsilDYJgnvOyXWyRDpOxf64zXawA+QT56OmRzAvyAKvkaVHevxAdtfb3N
         S60vOuf2XdPXueRj72QjkK1EyEroF6IgSsZl2qMHVn1MlsWkbhXpu9R05Md4VZfhJQoC
         uquNfMlEiFmBFlYAKvi8XwxPBk3XL9c4oOqGQck/Yl8fCS08EZQijPEHj794EL42Ul8k
         lCjsWuYIG/WlANW0ncziBAAYKDdoBRJl7mXebuvpXG6WGpwHD5vRDvtvyZWLB/3jvYrm
         ph6w==
X-Gm-Message-State: AOAM532mg+72+8wbOsbgf04UF1CybuwsPl9LWV0bKKv4PHjplMVe6O8J
        IobKBdsM1w31R/LdM4b2TDydg3RQ6mWJ8F0G2mE=
X-Google-Smtp-Source: ABdhPJy6tbJNhKfLHBE6qkHHvkz36Iv5exfdIt4pNZ4xCIWzS9cztd4C68oSyTxEm8/nsDh+Playmg==
X-Received: by 2002:a17:903:32c9:b0:154:3a2d:fa89 with SMTP id i9-20020a17090332c900b001543a2dfa89mr27472167plr.3.1648506330831;
        Mon, 28 Mar 2022 15:25:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k14-20020aa7820e000000b004f7134a70cdsm16558951pfi.61.2022.03.28.15.25.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 15:25:30 -0700 (PDT)
Message-ID: <624235da.1c69fb81.9d41c.cc3d@mx.google.com>
Date:   Mon, 28 Mar 2022 15:25:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.237-11-g954e3bfb38f4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 95 runs,
 1 regressions (v4.19.237-11-g954e3bfb38f4)
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

stable-rc/queue/4.19 baseline: 95 runs, 1 regressions (v4.19.237-11-g954e3b=
fb38f4)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.237-11-g954e3bfb38f4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.237-11-g954e3bfb38f4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      954e3bfb38f466b4f58a82491a6a640398774552 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/624204b0bd397902f5ae0686

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-11-g954e3bfb38f4/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-11-g954e3bfb38f4/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/624204b0bd397902f5ae06a8
        failing since 22 days (last pass: v4.19.232-31-g5cf846953aa2, first=
 fail: v4.19.232-44-gfd65e02206f4)

    2022-03-28T18:55:30.574283  <8>[   35.949153] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-28T18:55:31.589840  /lava-5962529/1/../bin/lava-test-case   =

 =20
