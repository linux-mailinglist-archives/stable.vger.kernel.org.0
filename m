Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3D024D596D
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 05:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243758AbiCKENU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 23:13:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbiCKENT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 23:13:19 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F55D1A06D1
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 20:12:17 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id n15so6726875plh.2
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 20:12:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/MM/L4w5canNK/SMyxPZLP6/4YgG4IvA0qrG2Ibm+cQ=;
        b=zc1Q+X2Ikl6+iSNz9NpwZndU35KLhqQY5gAtRDZuasqji6dJgdxtbcVv7dFsBA7EuA
         pspnarSZhFUayd4iGLD5RlLJKsIGdQRHc6u9k5UPFhMjek+wR/9RdLZ0SbUsds2m7kRK
         3iKGjPwx1QXs7ZV6HfedcvwXfp8bHkmP9jS9xe7kmxms5De6QLOx8dNYh3DZeEjOBlDl
         Qr+qZ72ZH0Yqu1svt1eXgtTxiOujgJ8ByAiNOiQpMH20prg34lspBUhPUHcB/cDCb+/x
         hxFBysO6+dqXEZSSGcwlTTn7wWmAXtG+NkdIj1sa4Kw/bxeAIXnm25i9dSQlrdBesES0
         1GCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/MM/L4w5canNK/SMyxPZLP6/4YgG4IvA0qrG2Ibm+cQ=;
        b=YTHUnxkMNbc/6K6/l79e5JFIXbkQI1W8bbTQJs6jl/FeVBphVB93QPeKUe7yfgi3wp
         +ryQVYZpm24iAidt/uLlrSrdDZvh0H+a8CPzFI6UWgHWCaHW57jdo/EDFJ0qHKQ+mTaP
         U1ujIveLgbX6zCsUHhHSgMZf0nCsBzxONGCHz6vjSXrgbZus0ssASfiPFcCVhNuYi714
         LQCRGjMDe2uykvaULo5BPzQVTiS6ZPLzJRhy94jqizB4Ck+HfqmjVCO4s0cq8NX+rDfL
         Ea8E4l/ZIlNQbvs3CcGkRG89IPi+RfZwAmNOM+joPNE4SjhwSFsvn2cfSB1T0DKNmEUx
         46oQ==
X-Gm-Message-State: AOAM532jQlXaUrjgb6UYGZRhJ7BNSB8hhh1OultffuRlMrFDLeKZDQ0h
        zysz78qQhtwXVzjACqsb5Wo60AQIrlKzDWdz5uA=
X-Google-Smtp-Source: ABdhPJztHn5cVRSHQ0KxIYhQVxu5BK546qGfdvdWEOMg2KMkU2XwSwKztSAntSVy8zWRwZxDRoDNcg==
X-Received: by 2002:a17:90a:1f4d:b0:1bb:ff88:c67a with SMTP id y13-20020a17090a1f4d00b001bbff88c67amr19755620pjy.191.1646971936924;
        Thu, 10 Mar 2022 20:12:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j22-20020a17090a7e9600b001bc67215a52sm7187245pjl.56.2022.03.10.20.12.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 20:12:16 -0800 (PST)
Message-ID: <622acc20.1c69fb81.d9f4a.35f0@mx.google.com>
Date:   Thu, 10 Mar 2022 20:12:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.27-58-ge8cc97b93a9c
Subject: stable-rc/queue/5.15 baseline: 83 runs,
 1 regressions (v5.15.27-58-ge8cc97b93a9c)
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

stable-rc/queue/5.15 baseline: 83 runs, 1 regressions (v5.15.27-58-ge8cc97b=
93a9c)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.27-58-ge8cc97b93a9c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.27-58-ge8cc97b93a9c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e8cc97b93a9c61a8695f3e57b7bdf7f6834c91b9 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/622a959e3885a2e1e5c629c0

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.27-=
58-ge8cc97b93a9c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.27-=
58-ge8cc97b93a9c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/622a959e3885a2e1e5c629e6
        failing since 3 days (last pass: v5.15.26-42-gc89c0807b943, first f=
ail: v5.15.26-257-g2b9a22cd5eb8)

    2022-03-11T00:19:18.702552  /lava-5854984/1/../bin/lava-test-case
    2022-03-11T00:19:18.713525  <8>[   33.559578] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
