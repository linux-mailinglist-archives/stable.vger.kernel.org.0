Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 528014FC557
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 22:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232437AbiDKUCr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 16:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349754AbiDKUCm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 16:02:42 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65FAC5FB2
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 13:00:27 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id c29so1107298pfp.1
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 13:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vrrtxixYgLtnJ6Vdj0YfOCCJld65RiKdn6exW0OYWLM=;
        b=jeW+B2hTEWw83XWkShH6zzzKawdnK0CSljEjaqho2xOqDG+Qpjo1pVqHtcWA2wD80w
         /FTRpSxMql2y7nMzRjuK3Pm4n58bOVQdL52FGJPavxi/XcbBxw3+aLF7d43mc2+OK7Bh
         GTSkEk/zLtYiRdf2pUY+vETmX4ptQ3FivKliZmBhAMjRQz/MnuukTgVnYVqZ2ZqfeksT
         YbyRfrf9sPip34r+Fjl5hHrWQbp9sgbimIIEF4k4rEDadcBE2i0VBURLgPOcsceiiBai
         N3zwO1GtZpOHrrI32i+f7Mu8KfJGVe23Te5QjuYyruP40L4q3no+DgYAjB4CM4HafNeb
         GgMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vrrtxixYgLtnJ6Vdj0YfOCCJld65RiKdn6exW0OYWLM=;
        b=neGPB/w2klresZ7e/ftvFMeAhX0c1pQ5r561kWJ/1VxIAcRBzsMxaCa14NYNLCg1VW
         N4n0motCHH7XLIj8sYLuBiWImL8G+ZFRDvFvFpXDWyBK3mZpMrKMkvBDzBRKDMorKhC8
         7hcZuc2s02MypFogcCuADzFqLrdWuo09FSJYGPV12dYVnDbXSyiqD+LF2RhrlIojeXHA
         sIyD+YrRvnZwjLOGDgSPYoT6WAfmGajeGAlvK7RCY/vrzZKtjKHud0N/HRvjLdiVK8Bf
         +PYo0iPhEpEeXHaiZpDWswxa1iZQkOCZhkwCwTdY59dheR6FcJWPyTYZ9fZuyE8HGXqA
         u9ew==
X-Gm-Message-State: AOAM532gKW7p0AblCd3+EPc1/UhiLAkxvpln5nLVXvVymWfMfXb68dEW
        lshuNUBVXv+rPL8PnZ3xgO0ZP0nZnzizQgy6
X-Google-Smtp-Source: ABdhPJzH8wAQ+oJ1PyJQHp1qCQIKaI5ICRbZdb9oR4Kh5c+UDLZsOva6hnC+4PJAzKorLOBHAyLx7Q==
X-Received: by 2002:a05:6a00:2908:b0:4fa:9297:f631 with SMTP id cg8-20020a056a00290800b004fa9297f631mr981771pfb.3.1649707226720;
        Mon, 11 Apr 2022 13:00:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j6-20020a63b606000000b003808b0ea96fsm488780pgf.66.2022.04.11.13.00.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 13:00:26 -0700 (PDT)
Message-ID: <625488da.1c69fb81.cab4d.1d80@mx.google.com>
Date:   Mon, 11 Apr 2022 13:00:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.110-166-gfa7879780a1b
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 78 runs,
 1 regressions (v5.10.110-166-gfa7879780a1b)
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

stable-rc/queue/5.10 baseline: 78 runs, 1 regressions (v5.10.110-166-gfa787=
9780a1b)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.110-166-gfa7879780a1b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.110-166-gfa7879780a1b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fa7879780a1b254f0bd7a701044f468ba2616c0a =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/625459e47337d58327ae06e2

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.110=
-166-gfa7879780a1b/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.110=
-166-gfa7879780a1b/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/625459e47337d58327ae0704
        failing since 34 days (last pass: v5.10.103-56-ge5a40f18f4ce, first=
 fail: v5.10.103-105-gf074cce6ae0d)

    2022-04-11T16:39:46.896499  /lava-6063861/1/../bin/lava-test-case   =

 =20
