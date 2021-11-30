Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C38AD462BCF
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 05:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238270AbhK3Euq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 23:50:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232769AbhK3Eup (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 23:50:45 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC0E5C061574
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 20:47:26 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id r130so19343443pfc.1
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 20:47:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZbjtdEbLw5TpN3r6MNMrvmTZylz4v54c3JVCdnIP7dI=;
        b=bf9E21Ujpw9sWKodF/RJCccL8Bbr61p0sOR6vyVuL1TAsKJn6P7J+IJ12xyZ8RjHtQ
         hnhxYwrznMns7FrSCnRtBRxLnAHbUVdwvn534nhgVm/65YQeYmhAijSP8HuvXDiHXXlB
         ErP2sCi54Rxvdoq5n7nq3PXf42WyvN0tYLxM3T/p7qX0LL6MW/wK53X1ObOJMt4hoCGz
         Jf16M47rBPRceCbvOmNBD6hs2X0a3PUCVysmGoc3ToC+bWDtch37JtkEF59pj8n8ZWfa
         edzNgxj0w8SzYan35y+KTDzUWc0IcA00z8TFSbt056r3xXkX7/+Xb8YDojh3ZXzvzPmY
         6gtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZbjtdEbLw5TpN3r6MNMrvmTZylz4v54c3JVCdnIP7dI=;
        b=zDf2u9ToUtdkNWfxl2YpFesZbGTtEX5aPW15sYI8Wvum3IOlQ18Qeu0jF6rO/5er+3
         7vbkCogJ2p3Dp75faiTTM47tjdBsZmgl6A5MEd5gAcMcPNXcsqpSTK7aN5JxeLfH9bFd
         S3+59KtIYBtF7EJMrgA6t5wOEA3XuUNDFPkZ+hs6gpZVKn/9HAFeeBJXqkQRh0jpX5BD
         hFM6PEztjFFFSMJmjxY7ATqR/OIRg1P1fO0GU57aLUrfnKE3NlIw0aoVAGogam46x4Ch
         vfpc8GxJAfbZmtLZCs3a5TQ0tgLHJBadT0gJoqsEIIEdnKxyJ/7FCiO3iy2HSH08qybr
         idLg==
X-Gm-Message-State: AOAM531j4ozTLcfIFaJwn6IWa3GlUz1lPZYOBdyKW/MvtEnD+mpDNOwt
        Ze1s2S5XyLL2uQUrKgDV9bkPK91g8S3kFSmO
X-Google-Smtp-Source: ABdhPJzQOPBRtChZrewcLpWA8qM64TJXUKDGNAxI5Oh3qJVWUhwZVNjlF0syNZccDY+jZxzGPg3JVg==
X-Received: by 2002:a05:6a00:1822:b0:49f:c55b:6235 with SMTP id y34-20020a056a00182200b0049fc55b6235mr43695230pfa.66.1638247646249;
        Mon, 29 Nov 2021 20:47:26 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p16sm20120927pfh.97.2021.11.29.20.47.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 20:47:25 -0800 (PST)
Message-ID: <61a5acdd.1c69fb81.86928.7333@mx.google.com>
Date:   Mon, 29 Nov 2021 20:47:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.5-180-ga6dab1fb6f7d0
Subject: stable-rc/linux-5.15.y baseline: 123 runs,
 1 regressions (v5.15.5-180-ga6dab1fb6f7d0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.15.y baseline: 123 runs, 1 regressions (v5.15.5-180-ga6da=
b1fb6f7d0)

Regressions Summary
-------------------

platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.5-180-ga6dab1fb6f7d0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.5-180-ga6dab1fb6f7d0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a6dab1fb6f7d0b0357301dcad771ff9d349fd6bc =



Test Regressions
---------------- =



platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61a575cc17fa5ff05218f6fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
-180-ga6dab1fb6f7d0/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-s=
alvator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
-180-ga6dab1fb6f7d0/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-s=
alvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61a575cc17fa5ff05218f=
6fe
        new failure (last pass: v5.15.5-173-g0378d8e52f9b9) =

 =20
