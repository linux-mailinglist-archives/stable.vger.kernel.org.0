Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97A214975D7
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 22:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240285AbiAWV4N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 16:56:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234697AbiAWV4N (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 16:56:13 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00DCEC06173B
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 13:56:13 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id b1-20020a17090a990100b001b14bd47532so14632284pjp.0
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 13:56:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5cl8NJ5S/AAQpxrZhSeK6LJc+VsxzBtoGIjp9OYU0aM=;
        b=OD8/cwq/hovzTmnkYp+PnNZ8oxckScBWSqlGc0rNkaA34fTX9F6+BNgwIIjG4D4ZwR
         F0OhhS0hMi7Xrj52BYDC3YM1pgf9XasyuQKIqLgPTKY6k7NUemzuRtmfCW/pX6ZP14k0
         BIU6PZzvYGrr859FcQSpto4MoS8MBMWo9foSmO3AuZvCyWbFnxumhh/JpKJpDyvxhSy3
         2SJrLVVOP+Nn5xOmOEyAyM+6cXnapg2lNFiLjLVd+aLlpJaZ1ppe5UzaUfBrKdG0c4P2
         XMW6ST+tXSytEFFL4xZDOh4GlwoM+2CMfhepT+5PxvW6Z2z23ZOGOFvGpLZrseg85uvl
         4DJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5cl8NJ5S/AAQpxrZhSeK6LJc+VsxzBtoGIjp9OYU0aM=;
        b=6D+vSE8qFtd5uuj0jMCtTYR+afhGFcCDnFXTtqAzuMHM8E/UriP0n92gWIzuIvqkdA
         bD0BVFipKj+Ar0sFl1YCWsCrO/IdoV6C5/5kAUWf1mq68ZBYdMBbiS7bOMi+dDnAECl4
         +5Un3N7ZcX6NHyvmn8JNPLTjD+DpiljiY6L6AgGTzFU0L9aGWbOGIPn0C6DusetdqvVq
         +zRtn3tS41qPGBqI6JIQZQsNZgtuInyF4Fm9tCZSFBp3+U5n3y32S1VKXrPSgUm2gR/E
         JKX1W6fSyKqXIoNMSCTvCHmbyiuGJ/41fawfPatSD/Eec+zlEB8HoeXAkB76z7+uW0Ei
         rajA==
X-Gm-Message-State: AOAM530hG7pPNTWHY36cG2W8aCHLy4SQoAH4+KtHXRlgz0CLjkN4trOY
        GILWVemodV5pXKWeXj7uG91eyinkkMTmdxxy
X-Google-Smtp-Source: ABdhPJxpBI5fH4iLd28cK4Do/pLK7OLWOr4ClxypMLk9xb8sjP0yRXMWnYmQAmLab8CM5MTd6ajXRA==
X-Received: by 2002:a17:90a:6c89:: with SMTP id y9mr10434495pjj.48.1642974972371;
        Sun, 23 Jan 2022 13:56:12 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j11sm14205859pfc.188.2022.01.23.13.56.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Jan 2022 13:56:12 -0800 (PST)
Message-ID: <61edcefc.1c69fb81.b81bc.68e9@mx.google.com>
Date:   Sun, 23 Jan 2022 13:56:12 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.16.2-847-g4e4ea5113e47
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.16
Subject: stable-rc/queue/5.16 baseline: 193 runs,
 1 regressions (v5.16.2-847-g4e4ea5113e47)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.16 baseline: 193 runs, 1 regressions (v5.16.2-847-g4e4ea5=
113e47)

Regressions Summary
-------------------

platform         | arch | lab     | compiler | defconfig           | regres=
sions
-----------------+------+---------+----------+---------------------+-------=
-----
imx6ul-14x14-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.16/ker=
nel/v5.16.2-847-g4e4ea5113e47/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.16
  Describe: v5.16.2-847-g4e4ea5113e47
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4e4ea5113e4739afb152231ef1d40b8bf328537a =



Test Regressions
---------------- =



platform         | arch | lab     | compiler | defconfig           | regres=
sions
-----------------+------+---------+----------+---------------------+-------=
-----
imx6ul-14x14-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/61ed95df5d37fdfe17abbd38

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.2-8=
47-g4e4ea5113e47/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-14x=
14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.2-8=
47-g4e4ea5113e47/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-14x=
14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ed95df5d37fdfe17abb=
d39
        new failure (last pass: v5.16-66-ge6abef275919) =

 =20
