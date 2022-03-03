Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC0D4CC915
	for <lists+stable@lfdr.de>; Thu,  3 Mar 2022 23:35:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbiCCWfr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Mar 2022 17:35:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiCCWfr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Mar 2022 17:35:47 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 525ECC9935
        for <stable@vger.kernel.org>; Thu,  3 Mar 2022 14:35:01 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id mg21-20020a17090b371500b001bef9e4657cso5699296pjb.0
        for <stable@vger.kernel.org>; Thu, 03 Mar 2022 14:35:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DUrg0vPqYLjnQUmiAhae2Kt59OD//oBkVIR2nxJ4fpc=;
        b=gilp9Cbe1uIczNYJAfvsqfvzEOg/TcIdQjqEpN3l79DDuOvAsrb8krG1g1475K+wdo
         n28ncdbUlYTBnq2icct/q3xskvypoiMOONAk1vepHntrdYnJok/m2F1G9ctjSXzkRAt0
         F1dXMQ5cKMtITH3mTcgSIjhpXpxSWCb/hLU96eOD0dlEvzpmhy5xPXP0wUeQgm0FYjzw
         kWwWXPvUoGxJwj4WL5dC/9Lk2FQO84kynWU3MGhKOsIRqJjrS+e8FKj/5ImbjYzQ1LxK
         1gDaxvNxgbyfgn72NFDTtrI4kvdrWYAyBwaRY4mbHujeW77XS/qEy0NZO9Hs0sc0Ht8S
         fMiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DUrg0vPqYLjnQUmiAhae2Kt59OD//oBkVIR2nxJ4fpc=;
        b=uCtEibh/eQ670pkWCM3xgTva2bce7TaiqcHg0ItmkGzMktqaT0wihJQFpqftxDG19n
         pofhjfKOiZotS21Nh6IGi6z2QP68/9SMf4MA0aYqnrkBMCvMR983O+WUoyCi88X+lI/H
         0zV2WhE1JugxL41jGdiD8/MvlKjAeTAw1/EPFdYyjNqnWpvHZqzDdFL3VWgx7pWkxtSO
         SEFdaOj/H1sXYZVycEwbgism9ahFLH4rFnwZSc3/4AjDwvGqJ1+8k00QO31bHCxYVgy5
         e8CtrHXKM1L9Nw/RhAMPg4S3mE/mM9+UicGJHgrS5qZiV0caK3Y+3DNZkqiVQnXCSssx
         yCcA==
X-Gm-Message-State: AOAM531/E0FxfvOHsZ/St9LK0SQuAabLpaciremubJKK0YpoNNRyOxrj
        Vew3VxuY21cMkJ7XF5s6E7uCaXK6qyG+A7TxqJE=
X-Google-Smtp-Source: ABdhPJzL+GIPw7eAEkHQF9nsSnvBDpmKp8fOa1Q3c2Tp/Li+L0WIaET1SAhoVYFXel3SVhHmdP+P3w==
X-Received: by 2002:a17:90a:6b48:b0:1be:d73c:f6c6 with SMTP id x8-20020a17090a6b4800b001bed73cf6c6mr7557844pjl.81.1646346900683;
        Thu, 03 Mar 2022 14:35:00 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c18-20020a056a000ad200b004cdccd3da08sm3492378pfl.44.2022.03.03.14.35.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 14:35:00 -0800 (PST)
Message-ID: <62214294.1c69fb81.ffa88.989c@mx.google.com>
Date:   Thu, 03 Mar 2022 14:35:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.103-17-gda6937c6cb24
Subject: stable-rc/queue/5.10 baseline: 101 runs,
 1 regressions (v5.10.103-17-gda6937c6cb24)
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

stable-rc/queue/5.10 baseline: 101 runs, 1 regressions (v5.10.103-17-gda693=
7c6cb24)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.103-17-gda6937c6cb24/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.103-17-gda6937c6cb24
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      da6937c6cb2401e7eb6604c9c7700601609ca4ab =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/62210e59c95f5d9ecec6296d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.103=
-17-gda6937c6cb24/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.103=
-17-gda6937c6cb24/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62210e59c95f5d9ecec62=
96e
        new failure (last pass: v5.10.101-50-g66126a333ca1) =

 =20
