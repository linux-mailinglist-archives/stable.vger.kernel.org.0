Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB0C506037
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 01:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235079AbiDRXbK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 19:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235040AbiDRXbK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 19:31:10 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9ECE201AD
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 16:28:29 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d15so13562807pll.10
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 16:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iwIy+R92chRxz2xdoHFEibsqm1uW32lBJ5txBlv0vtE=;
        b=QsSgAiK8KBN0PkNpk0mlNHWGuCerA9wDEd0GqmcVgrMsjYesmoS+jKetHHklAN/lU4
         Ccjmjtu+Wtn1Jk7MFfYNxgbIyh7PYM5v1Rz6MYqHSmIYe8MpHl/BvX2ExPHgCteH8Pfc
         SmR5ARDw1rjABpQ+TFeUatP5IzF7AbGPrmbDiKfsJTEHCFGA/XmiStRI70cTycbG2A/f
         FVTsENXP1FB3e47Gg7XcRDWdTIJc+U5seKnGS9XFgz22EvZw9JXXFzIxtxPIrud26QYX
         KzQ4+6JRvDB6kG2OahxOOTfqze7artnO7OdwCJh4vu+X7BDFySLek5xsnLWiPE37vr97
         jPnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iwIy+R92chRxz2xdoHFEibsqm1uW32lBJ5txBlv0vtE=;
        b=dGhFijqnRtzyHNju1CZbzyFFBIPVp5SA0iz7EwrObhOFh4JJJaWC4VvYp+Jxu/bBi4
         xach5XenjA+FSONzh4XHFCvMTLTaIxzaE1pcOdd1qaLna8SWmEraOExz9a3NsPfTZgTv
         dTDZ+9dXuQO9h91GQj/krNLBusp4LWDHH9P3OUfcq0YVrqIASFR5czovCkozJNkPXw5Q
         PU40hMJD2BAlfXlnYA+yZ2FXsz0lc5uN9LicXL7Dd+rYsmd3Ic3kFGsOYtTvn6mfzmgN
         D/OprVUfq7nyLvxnv17lAcTEe3/QeGF/kydDApUiV0oXFSk1MfJR1rYPXZ33Pn5ZYUWT
         Dgzw==
X-Gm-Message-State: AOAM531+bBKFk6qgvz255z93TKU9/8NtjPSlWBw1TWtni+PoH12ZW5Uh
        A+eoRSc0NdskuDISWRr8Pib5kJ2LZOaf2LSi
X-Google-Smtp-Source: ABdhPJwhXD54uD9Ec+bNWEKxJfcaabSlkN9JF1amQvXK7oJ+FsirKY1vr4tVypCGZPHEPgwZ4+MDSQ==
X-Received: by 2002:a17:90a:d083:b0:1c9:94bb:732d with SMTP id k3-20020a17090ad08300b001c994bb732dmr15531662pju.106.1650324509198;
        Mon, 18 Apr 2022 16:28:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z16-20020a637e10000000b00382b21c6b0bsm14232088pgc.51.2022.04.18.16.28.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 16:28:28 -0700 (PDT)
Message-ID: <625df41c.1c69fb81.14fe1.1d7a@mx.google.com>
Date:   Mon, 18 Apr 2022 16:28:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.111-106-gd5c581fe77b51
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 148 runs,
 1 regressions (v5.10.111-106-gd5c581fe77b51)
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

stable-rc/linux-5.10.y baseline: 148 runs, 1 regressions (v5.10.111-106-gd5=
c581fe77b51)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.111-106-gd5c581fe77b51/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.111-106-gd5c581fe77b51
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d5c581fe77b5122ed284c7739724414ca5059b0e =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/625dc2b18bf5ae05adae0697

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
11-106-gd5c581fe77b51/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora=
/baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
11-106-gd5c581fe77b51/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora=
/baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/625dc2b18bf5ae05adae06b9
        failing since 41 days (last pass: v5.10.103, first fail: v5.10.103-=
106-g79bd6348914c)

    2022-04-18T19:57:14.785993  <8>[   59.655093] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-18T19:57:15.815443  /lava-6118037/1/../bin/lava-test-case   =

 =20
