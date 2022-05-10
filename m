Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00309522578
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 22:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbiEJUbL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 16:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233446AbiEJUbK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 16:31:10 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 489DC2558F
        for <stable@vger.kernel.org>; Tue, 10 May 2022 13:31:08 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id i24so142519pfa.7
        for <stable@vger.kernel.org>; Tue, 10 May 2022 13:31:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5rJsxy5DK6O9XL6+DTiR/9o5hoI/4ksAJqZvgN7CCnQ=;
        b=BVfVXNCUj0c0QMqGSKPeUuvswgKWfzFrvIX20k/b6/DJ1vU28GCzCGv03tXfdshTFO
         NnmOiyuJyv+oauK/j7L4uc+fv5nn1V+tcbsih9/d1blfzkushzsR5dDDItp/EgJ/tKaA
         rX5F9ecRYmho72cOC16IrsXJzgsQz/c30M4o9WFa2w2Qou0C2DYrNWvWVuaLQ0XgZS2d
         bcdtOA+6DRBdknVIjDSqtHjTyXQ8sFNfYwxrtTUp8JXLxLmDrg+CHUzJL2KRpk22vVL5
         kNdCmYCv+kRSPe03zZLs9UalT1TxrjEJKqYQAHKaLlzRqOJqZYt2EL9MclnSlm9PfwQk
         uMbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5rJsxy5DK6O9XL6+DTiR/9o5hoI/4ksAJqZvgN7CCnQ=;
        b=v0S1KxUWTt9f8CCNRnKE6be4JOfztNtCnNJiRVw4BRFMHIDBluQ119KhfI+QI649DX
         K/54sPBDFdqcKVdbyEApfPKS5D/8aJgMdXw34AC0FH7B2uq9ai2YfQHMkEnnDj2TYXXi
         VCw5//s67pIwNc6T/aM4bDEkPiCiY9Yod3MtbawurZZTVScIdLNUet8aMW7QD+MR6Q1/
         tRzxeei0zQUqGsoDlM8dlr3KNHMumIVdpaAQKUeYK9SUsj/M4tGcME2fZlT8pdD23qMC
         /vW45DmLGPKxYyRtnZEU+nGf48lRwVMuQGsO359y7jrCQHXvebId3fj/DfeGJTcWKcOm
         nFnw==
X-Gm-Message-State: AOAM5300FsDaPqoJKyL+K2ER2IGjopSaZQo6MUNXLXRagHOwtxU0zsZh
        scupGFpIgNz7psRRrpSJtK3gUeMRvmUolivwyAQ=
X-Google-Smtp-Source: ABdhPJyNgx2+3XT9Btfgmr+Z8OIyddmqe2ZYzzX9NDegQXH3stclYA8G9NyASktKLgnEqK6aqF+v8Q==
X-Received: by 2002:a05:6a00:a02:b0:4fd:f9dd:5494 with SMTP id p2-20020a056a000a0200b004fdf9dd5494mr22243920pfh.68.1652214667695;
        Tue, 10 May 2022 13:31:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id lp11-20020a17090b4a8b00b001cd4989ff53sm96961pjb.26.2022.05.10.13.31.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 13:31:07 -0700 (PDT)
Message-ID: <627acb8b.1c69fb81.c59d1.05d9@mx.google.com>
Date:   Tue, 10 May 2022 13:31:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.17
X-Kernelci-Kernel: v5.17.5-365-gc68c3b953062
Subject: stable-rc/queue/5.17 baseline: 138 runs,
 1 regressions (v5.17.5-365-gc68c3b953062)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.17 baseline: 138 runs, 1 regressions (v5.17.5-365-gc68c3b=
953062)

Regressions Summary
-------------------

platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.17/ker=
nel/v5.17.5-365-gc68c3b953062/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.17
  Describe: v5.17.5-365-gc68c3b953062
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c68c3b953062f905470454903f54118e41fbfddb =



Test Regressions
---------------- =



platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/627aa6d7e8eefebbbb8f5752

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.5-3=
65-gc68c3b953062/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salv=
ator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.5-3=
65-gc68c3b953062/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salv=
ator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627aa6d7e8eefebbbb8f5=
753
        new failure (last pass: v5.17.5-346-g895169a33871) =

 =20
