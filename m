Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9984E58F5
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 20:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240249AbiCWTNr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 15:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232772AbiCWTNr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 15:13:47 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2DD0606C9
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 12:12:16 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id b8so2653549pjb.4
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 12:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=y9KdMUeHQWtlb9ax/KzO5l4SB/fbxSwaqvaXMqQY2J4=;
        b=eR61oxyGa510Uob2qw9o178i0ZlyFF+nQYZjuUht937VKe6pHOjfIv8y1zbvW0lyzH
         z3QsFIKsQk5BvBGS/3HOId8rwATi1hhq98lxFEC5QLs9knjokndCIIG/ojW4+QrkCu74
         fV7wGMJiCItDVQ9nIhlZ+OP7ddxPbVWNPFVxCDnSEUF4+B3vLXo7zH7lQEpd54yBhF+4
         FKqWVBjzO+S1YDM1W0WBYIsIdwVQIt9Ld600ER5AxoLGNAah6ZO0d/oX5FlMKW1ryFHH
         8wNVG+Lr4BhwVRvpkKseEUxNIgTrFw1qWbm+3yHcw29Ltr9Y6fXTyKEO7zCzKBFvgtdl
         jG2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=y9KdMUeHQWtlb9ax/KzO5l4SB/fbxSwaqvaXMqQY2J4=;
        b=1DJoOmbe8pnSXJVcQP2OuLdTfWshB5tyZhmfLDIRZmJJY1VeheTcZp2pGPuYUj1jJE
         PYNJt7dWvtKTnsOcojMvmFgxW0Tw+l9oy5YIM5555K3vHnV1gej9NMlJ5UG3lAqVASVi
         J+ZsMD9RDPe2x52UCBmV56TuzTNK1ovt96vui+d02q7TSb1TdHluurTHkk0ltHv2N7QH
         ve70ud6RbDMLYpcSNVE+ef+ijhXgEKebia+dn5Y4uDUkYR9IXuAAgqII760YeOkGvSta
         46jMa6Jl3H+dubzi1QdK8Z538QTMjErm66Vv4OJFaR5YH8WvgsAZ5uGRHRuXYsYwpGmm
         cxrg==
X-Gm-Message-State: AOAM530vprGYnzOIX3iUd6o97jFeVzrLO4a8qryCgbyTNI7/70LdWzoM
        zeRvxlZ1obcYzN23FK5mVn0GM3mPZi9RKkpvQzU=
X-Google-Smtp-Source: ABdhPJzGdJsD012iWfNjiV6+GZkrM/6K4DWuLX3YAm+fhhwVLZHxLFkSkKlHiNgZAK/lu+o8zNkVSA==
X-Received: by 2002:a17:90a:4809:b0:1bf:72b5:af9c with SMTP id a9-20020a17090a480900b001bf72b5af9cmr1391398pjh.190.1648062736130;
        Wed, 23 Mar 2022 12:12:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u10-20020a17090a2b8a00b001c6594e5ddcsm450080pjd.15.2022.03.23.12.12.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 12:12:15 -0700 (PDT)
Message-ID: <623b710f.1c69fb81.1ee4.1e73@mx.google.com>
Date:   Wed, 23 Mar 2022 12:12:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.236
Subject: stable-rc/linux-4.19.y baseline: 32 runs, 1 regressions (v4.19.236)
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

stable-rc/linux-4.19.y baseline: 32 runs, 1 regressions (v4.19.236)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.236/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.236
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      67aefbfee14b1f29cb4529911aef7322899ecc8b =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/623b425b5bb665872dbd9185

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
36/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gr=
u-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
36/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gr=
u-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/623b425b5bb665872dbd91a7
        failing since 17 days (last pass: v4.19.232, first fail: v4.19.232-=
45-g5da8d73687e7)

    2022-03-23T15:52:46.256666  /lava-5933204/1/../bin/lava-test-case   =

 =20
