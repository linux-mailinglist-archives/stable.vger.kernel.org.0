Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4A54ACBAA
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 22:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243141AbiBGVwd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 16:52:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243125AbiBGVwd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 16:52:33 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62842C061355
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 13:52:32 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id v4so8356089pjh.2
        for <stable@vger.kernel.org>; Mon, 07 Feb 2022 13:52:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=S4zrQYHRQgSeBOTpQU+Y2vfgNi0v/V3wK2hEqmal1jI=;
        b=6VpFOm1+F6PlONYzvWepQ8ZZMIj3kWKV5kzzSG72LsFvNjcSWzVwX1znkqJwEPclrT
         KLbA1esL++/hF3X+GBXqH3sxU51V1nCMr10D+ON742xX/SXbmpzAr6w06R3uwavxPPR4
         ybf64ksQ819TXjGhUOzPEtbmjsZagT7WCUWFpneHBTDI+T1ziyRVEjuB42JBdn841BHY
         KhsNNF+NYBonK/oxfS84/Ah2l/1pj3pGLqPjyIqWIN9Zr/x6rS9jFzTNqDoPZhvj3Srb
         oornT6xcMtCoTrM7ufLSTXI7GLiPQXOvM2/HTldFDiDZDPv6QbcovYzvyzqPQIcl5cas
         Ua0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=S4zrQYHRQgSeBOTpQU+Y2vfgNi0v/V3wK2hEqmal1jI=;
        b=p0FsYPlW4+Rd3JDf4T0eFQTEcbWfbQ4DFGafezzvYGga7gJN39QXwomeq/Xrv1LJCW
         qEt89E2P+hjRO/HkA6Kr41U4WDN2CfRbcwuxi9DwrQaEqaZVNoqlczpVN/9BMqHDZtdW
         p6A0UzNXsCmBBXGQiIvC8p3ytBdeZp/h74jku8jUYAwSzKJjUgFBpCATRCbkUCfl1Th+
         hzQEEOdUajONFYmCwts3IdH6zIwi4zAt6Z1AJn/+O0c2Zs3UQM2TFWwv5JpcuR2K0xrN
         XwJuJ/yLyIXEUAiBfJIYchZFoavU3CpiBSXbMPzKc+BD7/0uNnbHVt3NN6NbeYhLPkh4
         /nmA==
X-Gm-Message-State: AOAM532uor6kPleUCpS6Ya/9as22fvq8s0Bygka38DEatMlrwLL5JF6s
        3PYuQum/IbeRxnaqX+eXF1Z+4zWyHBWgboSU
X-Google-Smtp-Source: ABdhPJzOA8oNL+gx05YvKCkc3GZe4Gl6oLZO8Zz3Q5PLT/mCZryQo9jGx5FcLKhZ3GTKgyeUSCZhZw==
X-Received: by 2002:a17:902:b710:: with SMTP id d16mr1281190pls.130.1644270751428;
        Mon, 07 Feb 2022 13:52:31 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nl7sm314805pjb.5.2022.02.07.13.52.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 13:52:31 -0800 (PST)
Message-ID: <6201949f.1c69fb81.6f207.1461@mx.google.com>
Date:   Mon, 07 Feb 2022 13:52:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.21-112-g0472630a5621
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.15.y
Subject: stable-rc/linux-5.15.y baseline: 126 runs,
 1 regressions (v5.15.21-112-g0472630a5621)
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

stable-rc/linux-5.15.y baseline: 126 runs, 1 regressions (v5.15.21-112-g047=
2630a5621)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.21-112-g0472630a5621/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.21-112-g0472630a5621
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0472630a562104918269888a8b355d06c5060e98 =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/62015de213634fc6ea5d6f1d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
1-112-g0472630a5621/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-b=
ananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
1-112-g0472630a5621/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-b=
ananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62015de213634fc6ea5d6=
f1e
        failing since 3 days (last pass: v5.15.19, first fail: v5.15.19-34-=
g61f904d1d627) =

 =20
