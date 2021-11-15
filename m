Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E90F9450181
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 10:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237514AbhKOJgg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 04:36:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237629AbhKOJgM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 04:36:12 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 424CAC061746
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 01:33:06 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id h24so12328438pjq.2
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 01:33:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=s1hT8Yr4fx35Z7WrLlw8+kAPVV3Vt3GvUl0rS8XUZkQ=;
        b=HKiA43mHiaEHClCcmvOe+mxXLF6xtw+b5ktMkA0ZI5aGj91KoFvn+CMBfwkiPaK5ju
         TGL7Wls+EpCeMcCoUB7f90CZVjMglqEzjA5WawAwOTCdo+79Csq+mvypt0kD/Gy9hCjZ
         vy+lqNTIONNNGXVOaroesiOFxgwO8HfrklccBLWUV3iu66EzQDXMX8eMB1wmwg6D4SDi
         E2ryb8sxVIQp4cYbn1Qn3M4e5QQSKMpoQbG4niz9p6++0QJyX9Ha/ZpIvCPttusQmZ5g
         5QTsTMJt7jzzDv3Oi0+dVk9Yg7PrQ3/whQCmH75sp4NHhuCWRCHhJ2GUMUeNvCW++jdX
         Brmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=s1hT8Yr4fx35Z7WrLlw8+kAPVV3Vt3GvUl0rS8XUZkQ=;
        b=lENbdANeX33qQufISyG7d56rBC0H90OFwOFHEPCxzoW9jz367LwtEAipgtlCKxnK7o
         gdJC9hTei81n4xjsJSHW1puosqkl7pRR2hWzian3ApxWDt/QSSQTai24RXSEfS0VrsyS
         1GMUlcUs+T6zr52g180i+U5Xd9DNU3lJK3DCRy+NIDhA92vlIsQFxPQTeXS9LIcZlIEH
         7ozJsyKQ8AWy8bL9w0yUF2vfmMCSk4SvqsQwUyhCVyKl0UfEtlTyg1YNxTyqbwuQ6j61
         ZCpyKcuTGH69nMC+38klXie57SX13c19y1GcsBatjRKbu2V/Otpdhk4eLQwlz1ZxEnkg
         g5bg==
X-Gm-Message-State: AOAM530qbg9wZ6lantXoF9NnjGsRQsqiftZYCpxs2DP4szKgHBY4NA3Y
        MOz0SBxXuhQPu7jNVbaGg9sJ+E3IBhWrUZxz
X-Google-Smtp-Source: ABdhPJzXziIeRt6q/nduWUn3BoBJPRcW2pxVH3gBsMz7EqiQu1BAUwtsexRPmUIeBf2ueuEcNK0qTA==
X-Received: by 2002:a17:90b:155:: with SMTP id em21mr63853703pjb.12.1636968785654;
        Mon, 15 Nov 2021 01:33:05 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f4sm14098054pfg.34.2021.11.15.01.33.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 01:33:05 -0800 (PST)
Message-ID: <61922951.1c69fb81.fa530.8d13@mx.google.com>
Date:   Mon, 15 Nov 2021 01:33:05 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.79-539-ge1c22b684563
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 209 runs,
 1 regressions (v5.10.79-539-ge1c22b684563)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 209 runs, 1 regressions (v5.10.79-539-ge1c22=
b684563)

Regressions Summary
-------------------

platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.79-539-ge1c22b684563/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.79-539-ge1c22b684563
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e1c22b684563234fb3a50eb9e537fe3806bdfab2 =



Test Regressions
---------------- =



platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6191ee7975b58719eb335905

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.79-=
539-ge1c22b684563/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.79-=
539-ge1c22b684563/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6191ee7975b58719eb335=
906
        new failure (last pass: v5.10.79-162-g8fb515630122) =

 =20
