Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1795E379DE3
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 05:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbhEKDjG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 23:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbhEKDjG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 23:39:06 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A32F5C061574
        for <stable@vger.kernel.org>; Mon, 10 May 2021 20:37:59 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id gj14so10916100pjb.5
        for <stable@vger.kernel.org>; Mon, 10 May 2021 20:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JrnKGVVE2rUEH7e6xh52VXjFkCZcccuH3Y+IYpeZCsE=;
        b=nuHGQx99bQ4PVt83yRwaxWL+3y5TLTcUJFqhPmXnxq3tzvq0XV1O6ZtQgeWWCK1K0B
         4tdoT3kMGBBRVyPU1UG9cTjNhAK6mYr7a1dddfEGPyhxI0ZoJYLg/e1dE8BHKeMQIeS+
         I2xwAJBwvRg160X1H2QCUSZ7mEr4rlpuXUYzXTSjQ20fZF6/fS2yIAcbgHfXqPbPoieb
         sgwuL2omllKzsPindgTXweoUht9rrBNM4hWpF1+3FCdscuDr6SXnsN26DknIkWBZH20V
         wjc8yq83hZbfReQaqftJJ+SKMWVKchrePnNUagNl+1JAhlAWEcuTr45N9ePRw/dXEbGJ
         4SPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JrnKGVVE2rUEH7e6xh52VXjFkCZcccuH3Y+IYpeZCsE=;
        b=gOnxiH3OrSg+kMPV6LPsrAkq+8hsciymiLM+WjqoOf6lcqqHEq64DluwjMR97XbADo
         M09nB1XBeXwXzQSRHFwsDjPIlZw80gAkRXi2hMkdFr1USQweJvW5z0zuR9cuhfkZrMdp
         rwhwMwUBPFXH+a8tMXKDbyl/WY2rwOZyqFzNogz52FYiBc/VpYAccT7M576XzgfhIV3n
         VufVFqn702u9qnApr8WODYb5oUnRC6Ple7DyotujWxDQBJyiWgwTA3DyJFnz186jmwu9
         qtlNvuy0JHKI8QeohkElq4xjMdT+80eJz10hN5l76cMP09T2SgfVuhqvoVMnjCeXPE3f
         Z+Vw==
X-Gm-Message-State: AOAM530n+mPmB+XbT9UuELueqgPkv84XnTJheO5R5iA5iOeBkNIUXh34
        ujiU9E/wZliBu1Fg4tkIYZT9nTrH/oJg2rbx
X-Google-Smtp-Source: ABdhPJxZFj6xsFffnj6Ysf1N6MdB2RSfYlSFvcOy8g9J2wsQfgesguCb/vDoO8CzhC3q5sCSk8Z1YQ==
X-Received: by 2002:a17:90b:703:: with SMTP id s3mr32801977pjz.69.1620704278862;
        Mon, 10 May 2021 20:37:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e3sm12799773pjd.18.2021.05.10.20.37.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 20:37:58 -0700 (PDT)
Message-ID: <6099fc16.1c69fb81.72898.7dd1@mx.google.com>
Date:   Mon, 10 May 2021 20:37:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.11.19-342-g92380429268e
X-Kernelci-Branch: queue/5.11
Subject: stable-rc/queue/5.11 baseline: 158 runs,
 2 regressions (v5.11.19-342-g92380429268e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.11 baseline: 158 runs, 2 regressions (v5.11.19-342-g92380=
429268e)

Regressions Summary
-------------------

platform      | arch  | lab          | compiler | defconfig | regressions
--------------+-------+--------------+----------+-----------+------------
imx8mp-evk    | arm64 | lab-nxp      | gcc-8    | defconfig | 1          =

r8a77960-ulcb | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.11/ker=
nel/v5.11.19-342-g92380429268e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.11
  Describe: v5.11.19-342-g92380429268e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      92380429268ec4d8772a1038246140a53e28b950 =



Test Regressions
---------------- =



platform      | arch  | lab          | compiler | defconfig | regressions
--------------+-------+--------------+----------+-----------+------------
imx8mp-evk    | arm64 | lab-nxp      | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6099c86b3806dc6eb56f54cd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.19-=
342-g92380429268e/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.19-=
342-g92380429268e/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6099c86b3806dc6eb56f5=
4ce
        new failure (last pass: v5.11.19-296-gcce8f74c8b60) =

 =



platform      | arch  | lab          | compiler | defconfig | regressions
--------------+-------+--------------+----------+-----------+------------
r8a77960-ulcb | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6099c7b6553e7b6c916f5483

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.19-=
342-g92380429268e/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77960-ulcb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.19-=
342-g92380429268e/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77960-ulcb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6099c7b6553e7b6c916f5=
484
        new failure (last pass: v5.11.19-296-gcce8f74c8b60) =

 =20
