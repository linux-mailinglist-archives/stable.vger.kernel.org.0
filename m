Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9C6A4AAC53
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 20:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234370AbiBETp1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 14:45:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233594AbiBETp1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 14:45:27 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CB1FC061348
        for <stable@vger.kernel.org>; Sat,  5 Feb 2022 11:45:26 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id c9so8026393plg.11
        for <stable@vger.kernel.org>; Sat, 05 Feb 2022 11:45:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ytOBQRxlISBfStHkHibhSqWJbCtMh5pEy4ierajvxJs=;
        b=ukwFz/7BJk5+42ry5AQvKq9eGSYRaDiTW7iLWP9zFJcQthpJlPeGr+536vXg4z5k3F
         fm2xKdgGVLlbPSCZttKSrgJa1awgpqnZd6GgxlajYUv8aWXXglqjxQGu7IC9eDWjNVwb
         0+bcgtZgeOtW9nre1qeHrC2CbeG3uvPL9vs+Yt8UlsLzgBCwytc/AWbubE8VJft/RWol
         vVFEh7KkMrJXFLxRJiN5wjGyb73XSkFGl+QhTGGv45JUh1iqZyiGGlmaNsUXTf4TxRC8
         MUTzL896NbMN0uLhelXFhdO+h3suK3h9inm5VRiuqJPNDtLtDVk9IZWz75iB87SZ4Ds1
         Bnwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ytOBQRxlISBfStHkHibhSqWJbCtMh5pEy4ierajvxJs=;
        b=UVxLds1slo70pIbwqFb1lsokd0GIK/f3xJviDgguAy4TWI5BkzSfk9pkAFBKxmyMzd
         Z+IAZvyM98xXH62qjTgALRpRVUhSbV5ZBF+RGev1/wuQesaQdIEsWAcYwcy3MxYLz90Q
         INR9RUkzyzaCViu9YZyg5Mk5zFCiQk4kDyLK6EXuryka7VdhraB9vxMC6JQIFmCHokVY
         DFgnlOKkkWjmKxaix9ltcv1kbSBsjn9jG2xvwRSbGsQB7fjGurCGh7vTdnwxbGGj7YgT
         FUw0Q2LN/BdXAQQ1OJL0T3FOi1AmY5tpRVQPKJ43eudEkgFo0qeQbcSmhbfq4fnTXFDK
         IMTg==
X-Gm-Message-State: AOAM530FuTsPUaK4HqPT7Efv3FzxV/T7k7s2dEQ4DYc56fEpXNLxt/zl
        gAVc89vfrSqUAvca1gP7hCKsGc0jSP1n+UNF
X-Google-Smtp-Source: ABdhPJy4sIi71Ke4igux6lcHdFck9rWDt/GLFtyGrho6619wirQL6CbV6A8BBvl1Z5OI5jqBkrkldA==
X-Received: by 2002:a17:90a:c8b:: with SMTP id v11mr5856850pja.50.1644090325448;
        Sat, 05 Feb 2022 11:45:25 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mw14sm6186367pjb.6.2022.02.05.11.45.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Feb 2022 11:45:25 -0800 (PST)
Message-ID: <61fed3d5.1c69fb81.56ebf.f598@mx.google.com>
Date:   Sat, 05 Feb 2022 11:45:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.96-46-gf063d5e33f46
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 120 runs,
 1 regressions (v5.10.96-46-gf063d5e33f46)
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

stable-rc/queue/5.10 baseline: 120 runs, 1 regressions (v5.10.96-46-gf063d5=
e33f46)

Regressions Summary
-------------------

platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.96-46-gf063d5e33f46/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.96-46-gf063d5e33f46
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f063d5e33f467addeab889abda9a740fc6a2fcea =



Test Regressions
---------------- =



platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61fe9d378dd40ec09f5d6f63

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.96-=
46-gf063d5e33f46/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salv=
ator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.96-=
46-gf063d5e33f46/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salv=
ator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fe9d378dd40ec09f5d6=
f64
        new failure (last pass: v5.10.96-12-g0ed6af8f5e3b) =

 =20
