Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDC457EAEE
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 02:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbiGWA6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 20:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbiGWA6l (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 20:58:41 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C16EEC
        for <stable@vger.kernel.org>; Fri, 22 Jul 2022 17:58:41 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id y24so5847644plh.7
        for <stable@vger.kernel.org>; Fri, 22 Jul 2022 17:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DapTRBr6UEQQEjzxgBXzIiyj4wCDygPdzSsyRqxCD9I=;
        b=PuR9T/dgdJ5YWktL8fNApTQST3HsePk9Wvr1Gj9NSXqXdfExKGtknJ+xeiS5PE39hB
         8rKlJee5b52vZUV/Y9EEKMD9S2UDBuEX648z3vJItZQC/NdAy9SsRQWmdOvEje9D2fpb
         Tg0mQQtROH4XRv+6ns+bVeRW9djpFMPeJgfetWty4MAzrRUr05ausGbwno6jrP8B508C
         TumIo9aT2n51tAvrsCFG/uxF+h4+B1K3QdJ7+6qw3Jqn4e5610TCe0/93VKgLeNB8E2q
         J03DTwEDW22yCBBjd50fNjee2y92O2aGKle1E37pTpH7tbHlHUYyTzQ2n06C+lOhCviX
         8b5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DapTRBr6UEQQEjzxgBXzIiyj4wCDygPdzSsyRqxCD9I=;
        b=67oYbqVyyo2G1EyZMaqnvGkhP/U+cl8ayhWRM30cBZW5G6NF5GIyNXrl2NyHWD1auT
         OovIJW2JTzuOoPhSsPXd2SKMka9pINzyKhr+oxXlTx4ay8KMUfNJ9jjrcTsw/eH9DUD/
         og/wkzR+y+l7KX/8C9gWdSuvbokJH3Ozz7TKrjrI+pXWwmWPAaApuhRLlRhnWUSVpqwI
         6jXwnCKVMXd1jXFCfvNlA45RS3IembdHvDvu4J6Rw50E4GmSvalpfg87fM0sZL/+yJ6h
         pZ5hKmAi8O89gXaBfQLV6exgmkm26epzxb2NGHQDZcPMYNkzkj4j1eQTP9Ubiyp20MEH
         atGA==
X-Gm-Message-State: AJIora/sHlTdIFp987cROeyU3Jqv6EPAuYMsqYnyPrkUmMxXAbYl3HuF
        tRgrpOwvE2U9be5BRNXXXduV6Jbj8IVWUBif
X-Google-Smtp-Source: AGRyM1tS3Rnvuh7nao817xpli/TZwni1AwGhuSfvZEMkGw2UUafl51eGHsdIuyYouYAHIRgjA/9ocg==
X-Received: by 2002:a17:903:1212:b0:16c:b1f0:5ab with SMTP id l18-20020a170903121200b0016cb1f005abmr2399472plh.73.1658537920421;
        Fri, 22 Jul 2022 17:58:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p2-20020a170902780200b00168dadc7354sm4370911pll.78.2022.07.22.17.58.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 17:58:40 -0700 (PDT)
Message-ID: <62db47c0.1c69fb81.fec04.72f5@mx.google.com>
Date:   Fri, 22 Jul 2022 17:58:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.56-89-g47b6f2de2df4e
Subject: stable-rc/queue/5.15 baseline: 123 runs,
 1 regressions (v5.15.56-89-g47b6f2de2df4e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 123 runs, 1 regressions (v5.15.56-89-g47b6f2=
de2df4e)

Regressions Summary
-------------------

platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.56-89-g47b6f2de2df4e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.56-89-g47b6f2de2df4e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      47b6f2de2df4e9194a8cb66f1080e53be6691891 =



Test Regressions
---------------- =



platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/62db13cae9f2009305daf08c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.56-=
89-g47b6f2de2df4e/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-sal=
vator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.56-=
89-g47b6f2de2df4e/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-sal=
vator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62db13cae9f2009305daf=
08d
        new failure (last pass: v5.15.55-168-gbe2291082cf2) =

 =20
