Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB3B64FE150
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 14:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347437AbiDLM7P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 08:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355186AbiDLM5x (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 08:57:53 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 655B45A158
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 05:31:38 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id a16-20020a17090a6d9000b001c7d6c1bb13so2804895pjk.4
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 05:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WAcn+M1Cg91MWLaK81sbBP4ZgtgBjdCNNxewnhXhD+8=;
        b=gbE2sNI5cSoJG0JRZ5AGMHPoOMaV6EKkgj/Rc9y/XEHNiYtk8Qz5BgiCNtNhulv/ZN
         vpfIH11qpxsC0UWhjXFS7IF4Cun4TZPCpJj5UH676nyJSku1TgI5kdph+vBt992qrnym
         jYlJTVNdItvFra3w3leqGVqrbgs6SypCsh/uyR7hy4EtOBeX4sRbe/APdKVpUfkztx5a
         a3651pEHJ08C9tHwE0x8pJuk0/tpTVTxPUwbOoO5ovGP/2UyT2RTLGOSKqMwApVEitgp
         jf+r8MSVRqkjw6k6PnJsnouJ6yT7CqT9IT8hNoD2s0NYo1AYc0bwOKcBXeUcKYWF0EBW
         nv6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WAcn+M1Cg91MWLaK81sbBP4ZgtgBjdCNNxewnhXhD+8=;
        b=qw9JvNWw830gXO9njWQUYleE6Pe0aGL9vlngrCZlELFOgL/8oRPHq46n9Iq2hRk+vH
         QkxM+QrQQHZo+Gt5jib51AphSQS2SehdQYsNp9RmSFkRWeTIM+0zQzifxSrO4k9rdh+S
         om1owB+yQN1ErR/Ro4ORvF8KSkzQ7cd79tWWlqkvfVQdARkWRdM5kzVqep9ci2T5/Z0w
         STtw+T2fAeEPbcI3HmeJ7yrYniRKbIbo48atE5QWwNLCddmpBeU+gu5IVLEJidZhb+BQ
         ePIS/wUhEgjv1BRZ3YR8lUuhoP9flxep6Q11iTQMjtwPw/v+mHRzWaV1H3woiq4ibeeT
         Uwzw==
X-Gm-Message-State: AOAM530XYxoPlu+RiWWwGD/GtFYZAephMdkTWPj4gaHCIpuT1sjFGXMm
        7m+mlxq91DzYdz+TXst2nk/6x4VIIxn+bDA8
X-Google-Smtp-Source: ABdhPJwP6kHdCs6c0ho344eD33aBboPar5EHZ+hp7EXDalC9o6pbRCoLqlvtE4Hgk76dZgafqCxRCw==
X-Received: by 2002:a17:90b:4a0d:b0:1c6:f480:b7f2 with SMTP id kk13-20020a17090b4a0d00b001c6f480b7f2mr4734155pjb.79.1649766697750;
        Tue, 12 Apr 2022 05:31:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z16-20020a056a00241000b004f3a647ae89sm40303210pfh.174.2022.04.12.05.31.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 05:31:37 -0700 (PDT)
Message-ID: <62557129.1c69fb81.8039d.88b6@mx.google.com>
Date:   Tue, 12 Apr 2022 05:31:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.16.y
X-Kernelci-Kernel: v5.16.19-286-g4a83e2cd9b74
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.16.y baseline: 134 runs,
 1 regressions (v5.16.19-286-g4a83e2cd9b74)
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

stable-rc/linux-5.16.y baseline: 134 runs, 1 regressions (v5.16.19-286-g4a8=
3e2cd9b74)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.16.y/ker=
nel/v5.16.19-286-g4a83e2cd9b74/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.16.y
  Describe: v5.16.19-286-g4a83e2cd9b74
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4a83e2cd9b7444a50219f4be214a3d4d143e1945 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/625542a91aeb644a96ae0681

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.1=
9-286-g4a83e2cd9b74/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.1=
9-286-g4a83e2cd9b74/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/625542a91aeb644a96ae06a3
        failing since 36 days (last pass: v5.16.12, first fail: v5.16.12-16=
6-g373826da847f)

    2022-04-12T09:13:03.109011  /lava-6071831/1/../bin/lava-test-case
    2022-04-12T09:13:03.122496  <8>[   33.456516] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
