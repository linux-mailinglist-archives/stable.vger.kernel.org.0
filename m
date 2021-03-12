Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 394C7339877
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 21:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234923AbhCLUaU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 15:30:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234673AbhCLU3w (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Mar 2021 15:29:52 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F358C061574
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 12:29:52 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id lr10-20020a17090b4b8ab02900dd61b95c5eso9030783pjb.4
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 12:29:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=oie7InIHRa24BifmF4f/Unqy2tpkox70tntre2kM2qE=;
        b=DpRQjEUDu4vmzxEJjZ/VXYER85yeCchUPj+Yr1hHmTpOJyW8OR8J953i8Vsg3ksz6B
         dmFbbWqYDFnf4UsdkngvqnrX9a5gGouhVTRj5OBTxO4rJMS+TVeuEwq/5p84p2wzp/mK
         yqok/06BmlNX7JIYIGp/va+hJEyGwhdp7UfIdL0nitX8OvTffN7TSG1JTtw5guJEe5eh
         y4uglI50LKSHbwvc2TVIoHzUKWXCdytQL9HYKAFMc5dNzQ4plwmSscDCCocfeQsMzK6d
         DfHvtnIeERLkdU3Uaf5ziFX2q+iTStePVJ7wRU7yMf3riWYl6M8mOfj6NS2YT737beUQ
         TNzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=oie7InIHRa24BifmF4f/Unqy2tpkox70tntre2kM2qE=;
        b=fGB4GL8YtWKC0Mk6Z5z5xiwgTEbo89zGo6rWMinwOPl6OINLK0ubFIzyg+AIzN60hR
         5djw6cu8nm1anntX+WJmVAuJVjQRWclRlpQ9N9BDXVuGu8NNLwlB7qyakEqIIDC5es00
         5yvIWSp8swiwxA4C6GbUej3QAErnwVSaRWEDAdUL5mFOPj+LEkiQ8eMSV/WMhkrLQE92
         QMOoz1aet9caKMQs6YZy5t4Y/so8X9e2JnA0905j+UKrrSTO0ZShsfh2ndFdu/qEi3GH
         fr3qVEpMMfYp41WyzAKlhpv7Ld+4hOlSrZvlpacOK+cb/x7a8BWc1sNVIjPYmmGrdXth
         hMog==
X-Gm-Message-State: AOAM531e2W3rkBFahW559wWoUJVbd3xzIlVNXblMolGNS4BJRVsmebOM
        RlYp+fAIfD5n9jEGSOapADGTjxwJXh+kKw==
X-Google-Smtp-Source: ABdhPJz/IdTsysNDe4f+AJhCFDXdLEualZkotTM5nxmLC8z+L04+mbji2HGZ38SPJdy6Yi5mciyr4Q==
X-Received: by 2002:a17:903:31ca:b029:e6:65f:ca87 with SMTP id v10-20020a17090331cab02900e6065fca87mr234247ple.85.1615580991630;
        Fri, 12 Mar 2021 12:29:51 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g12sm2933759pjd.57.2021.03.12.12.29.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 12:29:51 -0800 (PST)
Message-ID: <604bcf3f.1c69fb81.7913a.7664@mx.google.com>
Date:   Fri, 12 Mar 2021 12:29:51 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.23-108-g78b73fb5a5f43
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 164 runs,
 2 regressions (v5.10.23-108-g78b73fb5a5f43)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 164 runs, 2 regressions (v5.10.23-108-g78b73=
fb5a5f43)

Regressions Summary
-------------------

platform   | arch  | lab           | compiler | defconfig | regressions
-----------+-------+---------------+----------+-----------+------------
hip07-d05  | arm64 | lab-collabora | gcc-8    | defconfig | 1          =

imx8mp-evk | arm64 | lab-nxp       | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.23-108-g78b73fb5a5f43/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.23-108-g78b73fb5a5f43
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      78b73fb5a5f438e0eb0f31046ed064b741d3fab3 =



Test Regressions
---------------- =



platform   | arch  | lab           | compiler | defconfig | regressions
-----------+-------+---------------+----------+-----------+------------
hip07-d05  | arm64 | lab-collabora | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/604ba29deec8dbe060addcde

  Results:     2 PASS, 3 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.23-=
108-g78b73fb5a5f43/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.23-=
108-g78b73fb5a5f43/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604ba29deec8dbe060add=
cdf
        new failure (last pass: v5.10.23-37-ge21780881c24f) =

 =



platform   | arch  | lab           | compiler | defconfig | regressions
-----------+-------+---------------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp       | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/604b9f4ee1a97cac0eaddce0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.23-=
108-g78b73fb5a5f43/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.23-=
108-g78b73fb5a5f43/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604b9f4ee1a97cac0eadd=
ce1
        failing since 0 day (last pass: v5.10.23-31-g559d8defe7bb8, first f=
ail: v5.10.23-37-ge21780881c24f) =

 =20
