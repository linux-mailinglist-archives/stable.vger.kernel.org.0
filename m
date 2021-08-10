Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04DAF3E5149
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 05:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234353AbhHJDEC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 23:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232897AbhHJDEB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Aug 2021 23:04:01 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A728C0613D3
        for <stable@vger.kernel.org>; Mon,  9 Aug 2021 20:03:40 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id fa24-20020a17090af0d8b0290178bfa69d97so3287142pjb.0
        for <stable@vger.kernel.org>; Mon, 09 Aug 2021 20:03:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5f0vFqtdoHmQyeaOVsLXnuPkifm7A80ZtCHerhacXOA=;
        b=SaFJlqtlzaK9EhgKx+Mk7e0UsMgJIopo9GNXJW+HhuYQCp3F+cCg0meMSzAbcQqtsn
         KPwuhPHl94x/awG59598deITtEbW2YFxskwj7wBDxz5gqaiMnropP08DMlGQFUVlpscn
         QAPkJRp+0elsGlp2bgr1+o8vNWO/XpHY2pPEC9/lLGM2CNTpZkVr9kHtdNEsqIbqnsJr
         o0b1VTvKb9im49jBaP2B85xJyk4gKsooxP0qiT/J+MiBxIs87ztsrjQLJoKVcfwqyzMn
         UQ8OYrd9AE+rK1vSOEYLJ7Q7UOP3ZPvFxvAhSNIygDFRwJzdCI049nb8sPmfgEa7Ji52
         /BUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5f0vFqtdoHmQyeaOVsLXnuPkifm7A80ZtCHerhacXOA=;
        b=WU78E8EauyLw4mp14bzipdng1tJQaFUwFQYUyFbH1NfGzI8vQ3izJ/eOyYL1CmXm5I
         nglb/gKmahHNInoz7qtFj0P9L8XLzg6lAOvDszQET+xjGXKKehrPBCSGO8ZWSZC+7Xwg
         Kg+uaqLZQt4md3ty8GLbAQAfMQxPtnR+DjqmKXsbYqy9JZTEY8/pAZANDu/hbmHrScsU
         FeLW4enoanZUTb8xXBL3sjM/swp4wEn1knRTvPg7EOFaRSZWiHD58RqHF5+kxyDR8+FJ
         gf5w/KFTnHNaXtFAo1JRRfO3lpQo/nltafj7VffZjr5PvsyByV9Dqj6xOlf1FZnazBcC
         Fr6A==
X-Gm-Message-State: AOAM530a6nxko+LASEjv4f/lAYxloozC+NfILwToApRHYq9CL0UGcC+q
        rdZ1rDrCgwStqjpnVp3ujJy30S7Jpy1kX0pI
X-Google-Smtp-Source: ABdhPJzB6EFYN4MUVP1bL9tyu03p2LT3ttMTzmGKRMPr//8CqOU8m/ED+LFNXOIZgz70HGPQIHIP8g==
X-Received: by 2002:a62:7f09:0:b029:3c8:584:72d with SMTP id a9-20020a627f090000b02903c80584072dmr19266123pfd.80.1628564619369;
        Mon, 09 Aug 2021 20:03:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u21sm6028821pgk.57.2021.08.09.20.03.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 20:03:38 -0700 (PDT)
Message-ID: <6111ec8a.1c69fb81.47ad4.29b2@mx.google.com>
Date:   Mon, 09 Aug 2021 20:03:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.13
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.13.9-164-gef2c23ffed7b
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.13 baseline: 172 runs,
 1 regressions (v5.13.9-164-gef2c23ffed7b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 172 runs, 1 regressions (v5.13.9-164-gef2c23=
ffed7b)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.9-164-gef2c23ffed7b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.9-164-gef2c23ffed7b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ef2c23ffed7be20c6198b0cf8e398c06fe18c58c =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6111b82f9d6bb33253b136a5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.9-1=
64-gef2c23ffed7b/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.9-1=
64-gef2c23ffed7b/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6111b82f9d6bb33253b13=
6a6
        failing since 3 days (last pass: v5.13.8-33-gd8a5aa498511, first fa=
il: v5.13.8-35-ge21c26fae3e0) =

 =20
