Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D307344E29
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 19:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbhCVSLh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 14:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbhCVSLW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 14:11:22 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 652EDC061574
        for <stable@vger.kernel.org>; Mon, 22 Mar 2021 11:11:21 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id mz6-20020a17090b3786b02900c16cb41d63so8987540pjb.2
        for <stable@vger.kernel.org>; Mon, 22 Mar 2021 11:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=U+nNcue53jrQFC+zUHCU/oPH18W23htbcRcA3ROmZUo=;
        b=TdFZJf7twtiCPk6CHie6GckWvzHNjB+BrihWymssezcUThKZMB6KYdhGtGQZenZRFV
         t/y+EcVyZ1C4Fq+x5SUszkPTwxlGWdCjAWSX2up5l1IRgbsgIS86+/67ZXIdT4mAybvy
         fXZuUNzaVuwDRp6qiMrDXxY3aP8r4/Etp/V2j0ivdqYKNrG2u2fDqVDLVa03zN1J29Wz
         VU8WSpNa6+vahqurB7P2JM8mAEc/xUaoko20IFvGdikTGI+1PUe6elPV6LDJJcJhfxyk
         ehiVTtY2nvTh6dlPd5463+LfYlf83St3pXOFsPVhksqJ7SRqbNEYL+3ynbezNYEnuP9W
         BK0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=U+nNcue53jrQFC+zUHCU/oPH18W23htbcRcA3ROmZUo=;
        b=khE+FjwyvVBDFLRzyxhEFOmENtd6bZKPHNJa5zM+eH3uhOW+FQLHw2Q/JJ0FzkJw40
         lr8ErYZlXWFI9q9+n22Lv+AVXdLF0RJjQD1TsCnwhaFh8L8dPzJu05f1s8kZ7Fe1l3Rp
         /Ww0nAd2t221XWRrlJBgZoSY3ZfpcfY2l5a8cgHsDX8E1Xnxbi0zTTUF2VDRblBH0otY
         Mal74jd99s83eeW1tAQkYEUZH1IFLwZapgkZO8HJJXBZgwaE3Bttz8SGo2gfGJ+331lA
         C4dmtNqMw4b1ERS1E12JsG1HPhNLHoGhqJP7uHGuO18bbBvMF9iuui2ki4rpwPoXJ3+8
         NdOA==
X-Gm-Message-State: AOAM532U1edPTjBj7JYclLLObsmhN+zegmhPgpbB5Yd4jN29zg+aEaZS
        YmaLz6KPN1LTRQ+4rHd4ALyNz6uVs46hEw==
X-Google-Smtp-Source: ABdhPJw5ewNa4NLCx7+HZWi6qA40Sr57EJkO6EBB5YRmF43ZyYUyEoq+V36GzH6P7xxl7kGM5EsoqA==
X-Received: by 2002:a17:90a:9e7:: with SMTP id 94mr298670pjo.117.1616436680818;
        Mon, 22 Mar 2021 11:11:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t6sm12946857pgp.57.2021.03.22.11.11.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 11:11:20 -0700 (PDT)
Message-ID: <6058ddc8.1c69fb81.812d5.fdb9@mx.google.com>
Date:   Mon, 22 Mar 2021 11:11:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.25-157-g433dc9c7723f3
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 161 runs,
 1 regressions (v5.10.25-157-g433dc9c7723f3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 161 runs, 1 regressions (v5.10.25-157-g433dc=
9c7723f3)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.25-157-g433dc9c7723f3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.25-157-g433dc9c7723f3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      433dc9c7723f30bb6d278e05f99aa642f663729d =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6058ae34edb71eae9caddcba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.25-=
157-g433dc9c7723f3/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.25-=
157-g433dc9c7723f3/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6058ae34edb71eae9cadd=
cbb
        failing since 0 day (last pass: v5.10.25-122-g41ea6b8505eb9, first =
fail: v5.10.25-157-gb5c16f33a901) =

 =20
