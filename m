Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60CE2383C00
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 20:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243988AbhEQSPA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 14:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236884AbhEQSO6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 14:14:58 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9A60C061573
        for <stable@vger.kernel.org>; Mon, 17 May 2021 11:13:41 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id x188so5522998pfd.7
        for <stable@vger.kernel.org>; Mon, 17 May 2021 11:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JAjioGqG/T2i/DoeqLJTfvuQNhymEw2IxQxAvHQYNYQ=;
        b=PzadQqlPcFpTO0yyRabJJG2HyajdkC2+JbX2ZUsI6lpDsEGI+NZ4ilur10OEUCLLgz
         I/SvgxJFzzc27/Hw4ZFkAc2w9O/g7ZjHaztNSsjM4E8UNfQr34hVBr1OMcUqyN0ZH8Oc
         jjeYoZKTZ6VUK8WhUfjMfBpyI69OMaUsKMOq43RPieOl8XcVG+AVTEvyUlcwN8h8XfNv
         yB7FsIu6hAzYIs/3/iuTAqP8zOjMWjRFNWH++WNCo3LaIwg8j3gycgBJu+240unEbAzY
         qo1quz+PLpfvaHRylInXCGhmIek8DMmnTDFucXygaefjDQLjPCfjLpHedjgEk4uv7Pf0
         BWWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JAjioGqG/T2i/DoeqLJTfvuQNhymEw2IxQxAvHQYNYQ=;
        b=tNaOfkxX1hWxs2bPxgYiXXj7aWJ3t6ttI7vYCYHNCc4j/mQFb4FnrfObpdNzGMFSBt
         iU0rdrNMzqSzuBmCKU+95+qACPJYlhhvbzH8zd/owCOwl1l4s0ArWOHPB3PE8+OAtQua
         XTzvFZ/yLD2EdfOGRaXxdveYwjULj56x21bORnHxGA/kwNeiRRcUUTwiq/BfILXr0AjJ
         QUPpy5aeWkgHjNBcAs/P6N7OWimjb/sKig31FPQ6PGSjFoU6Z6ntKbbs8ap1yfrQDaRX
         7thmVMDDJ6bQ3FBM0/uNlaU0aI6DkmSxPasYYPmIppQ6Cs1CeUvBrMnZIu5RNS8BIUw6
         RdGA==
X-Gm-Message-State: AOAM531FI56aAbhOKVrS5yVxFxYwJONWnqzuV2buDHXFw0SAEoFS+GAz
        NhAmEMt69xBBg9rgY/yiX43Udg4qnaNG9Aus
X-Google-Smtp-Source: ABdhPJz4DwMK16m4dujt5537mA8jhOgDAOYcXxzCviy0KiN60QkqgSRGbCgIH+sBhhlSZuhCM62LOg==
X-Received: by 2002:a62:8389:0:b029:27d:28f4:d583 with SMTP id h131-20020a6283890000b029027d28f4d583mr721399pfe.33.1621275221050;
        Mon, 17 May 2021 11:13:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c83sm4920036pfb.10.2021.05.17.11.13.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 11:13:40 -0700 (PDT)
Message-ID: <60a2b254.1c69fb81.14995.f7c1@mx.google.com>
Date:   Mon, 17 May 2021 11:13:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.12.4-363-g103a5cc56863
X-Kernelci-Branch: queue/5.12
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.12 baseline: 136 runs,
 2 regressions (v5.12.4-363-g103a5cc56863)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 136 runs, 2 regressions (v5.12.4-363-g103a5c=
c56863)

Regressions Summary
-------------------

platform                 | arch  | lab             | compiler | defconfig  =
         | regressions
-------------------------+-------+-----------------+----------+------------=
---------+------------
imx6ul-pico-hobbit       | arm   | lab-pengutronix | gcc-8    | imx_v6_v7_d=
efconfig | 1          =

r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip         | gcc-8    | defconfig  =
         | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.4-363-g103a5cc56863/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.4-363-g103a5cc56863
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      103a5cc56863f9a466db7a8be460989a185f93a7 =



Test Regressions
---------------- =



platform                 | arch  | lab             | compiler | defconfig  =
         | regressions
-------------------------+-------+-----------------+----------+------------=
---------+------------
imx6ul-pico-hobbit       | arm   | lab-pengutronix | gcc-8    | imx_v6_v7_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a27e77fdac167b3eb3afc4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.4-3=
63-g103a5cc56863/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.4-3=
63-g103a5cc56863/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a27e77fdac167b3eb3a=
fc5
        new failure (last pass: v5.12.4-340-gdc9ee8b28006) =

 =



platform                 | arch  | lab             | compiler | defconfig  =
         | regressions
-------------------------+-------+-----------------+----------+------------=
---------+------------
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip         | gcc-8    | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/60a282504e537a9b1cb3afd5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.4-3=
63-g103a5cc56863/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg=
2m-ex.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.4-3=
63-g103a5cc56863/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg=
2m-ex.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a282504e537a9b1cb3a=
fd6
        failing since 0 day (last pass: v5.12.4-307-g93ac62543375, first fa=
il: v5.12.4-340-gdc9ee8b28006) =

 =20
