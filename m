Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5218139A932
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 19:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbhFCRb0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 13:31:26 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:46848 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbhFCRb0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Jun 2021 13:31:26 -0400
Received: by mail-pj1-f44.google.com with SMTP id pi6-20020a17090b1e46b029015cec51d7cdso4274407pjb.5
        for <stable@vger.kernel.org>; Thu, 03 Jun 2021 10:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PMOUjlZtq6zJXarUSfW5iyc4UBwoRnkvwX39s52Lf/U=;
        b=xviUHN+PSj4XAH7JCb6GEdZpXLtXlm1DjRP75O6PZBAHZ/WlABsJN7q7ghGTmuNreG
         sE1nvKDLkkM4ckQyh14qPjiACXoBTJ3Z8UgV2wstLC8fWOkLcHjviUOMDNy1W2OBcGnr
         g94TXE/UjgwmDPoI1b71O/vnOwmr47bLam7eDdQwNdjMRNMLsIrpU3rDOOAJv3HtEetq
         UxMHPr4bGmYk6QervVw4Ce3cKFWD42P4cbFS2rHYKILxilJkHOHPfhP8uoLdwnM/Lx+7
         qa8FDhcfRZNAdE2LkeGdpSMvf7atSy3GtsHczgKC2RLUR31/Iyyha9iUP92I4UBDR4jf
         ghDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PMOUjlZtq6zJXarUSfW5iyc4UBwoRnkvwX39s52Lf/U=;
        b=fDI/heauKB3XQl+hPDWLEy+p7az15nZk497exGkCX36x8VXttSzHwJsFEDW65HR46I
         B/a/dJrW023L97mr+ttrQqO7892bE6hbXHv/pNRneKjPidebWR7iy2heYrK3INoCg08W
         bs7WuRV5w68aXFASa8hmpzcVp0zS4mDTa9fZ9X+pygB08OsfqcHXx5dIVYTmA9khzZu8
         VtfIhQpcq7++xPFE9cRO8j9T+GNSzH0AMrjlamcaistVFiloRD6BEgHLYddKvtV60bdg
         1tPthPtApMpeVFD6YGB37vCUHc7eY5S3xI7aiUKdUxZA3cZL1Gc4zb2T7EzEHmIFRS8Q
         C6zQ==
X-Gm-Message-State: AOAM532HGniw6DsNX7RNBnsN6S3FO2W4P9VGNeuEHC0Oa4xaPpZoXnT6
        6oo0d8W8iJXPE1lec7dYKItCJ5obj+pmkw==
X-Google-Smtp-Source: ABdhPJy6EJpA+JOWhblJ9Z/UFMQFUpPaysbMexQRE046Xju8aFafquql8Fw8dU6Bmt7xJW8E0t1pkw==
X-Received: by 2002:a17:90b:234d:: with SMTP id ms13mr285935pjb.135.1622741321253;
        Thu, 03 Jun 2021 10:28:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o24sm3071161pgl.55.2021.06.03.10.28.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 10:28:40 -0700 (PDT)
Message-ID: <60b91148.1c69fb81.9b9f8.9fac@mx.google.com>
Date:   Thu, 03 Jun 2021 10:28:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.41-251-g1360515527f5
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 152 runs,
 1 regressions (v5.10.41-251-g1360515527f5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 152 runs, 1 regressions (v5.10.41-251-g13605=
15527f5)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.41-251-g1360515527f5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.41-251-g1360515527f5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1360515527f54cb0e6fe90514e428e5f16176a7f =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b8df484cc5df11f1b3afaa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.41-=
251-g1360515527f5/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.41-=
251-g1360515527f5/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b8df484cc5df11f1b3a=
fab
        new failure (last pass: v5.10.40-261-g8e56f01eb8e7) =

 =20
