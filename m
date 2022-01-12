Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF27C48BBE7
	for <lists+stable@lfdr.de>; Wed, 12 Jan 2022 01:34:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347256AbiALAeL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 19:34:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236299AbiALAeK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 19:34:10 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D95C06173F
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 16:34:09 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id u15so1531929ple.2
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 16:34:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=g3mMw2qi/y8NUneGFo2wwSsxNOzTCPEKH+QcQrjDR+E=;
        b=lELZnryGFcsCWA05BOEISSEtHUsR+uN3ghcaDddf+6PmELu56CjN5e7ozFmhdRBLmC
         2aus5gq8LhHn6nZeDZi7s40KzLV/NOK5wpHOTXAxOii0s5sjejyKET/3/o0dJSHl0Ygt
         r9nhQf2O0cJ4OFhUq+tqLzlKN0UVOtF3ep+sJmm6x4wMz0BAei5G4AciqJ6pn5DRtZmW
         jwZyg3vYq4ILSQKpgnhj2kTEVsHrbJJBzUKQK6dM4v8Ip7xmwjiySQkkzY1zNn/n/pbu
         m08TaizguhuC8pwhLxg94h6oObv+gihNF6zrdjEyd101taOYKpnLrF7uqj/gO1YT3TZz
         Bu0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=g3mMw2qi/y8NUneGFo2wwSsxNOzTCPEKH+QcQrjDR+E=;
        b=vqQwJWvRjNZrbIst7W8OKuOVOYSNlBvsuoadkRVlDOz7yw+4X+MdME6aJ8Vpy25YyE
         zMmDum6ZurcMA1+/k74rAigdmMccOo6AlzyE4+WE0wvdYS6hc4fD0+wQH4XQJH+9yV9v
         MMIyOz3mvOEnm1NLBFRXCVS2aCDqN2JFBzIcbUAnEQP/sdAHRoelix5oJ6dZFSlKtd8l
         YA7qup+aiEjldJ/ijQZ6bUrbNaJDKltLMEk3dsBA695VY1QZry+dF2E0mW/3Nu22QpYz
         iQBgxPrsb7BJx1PVe4zT+pmwWgF9w7CMAj/DUuokcSqszA04QDTjFOE76AQmZ494HykJ
         9Nuw==
X-Gm-Message-State: AOAM532OPVOsIO/6PChtfHUbpyKNxRaY4mh2ZeBykodyoHfd7MFTnufX
        6EXaUMak2fuxlPX3/zgMt8dX2TlpwlCyQI55
X-Google-Smtp-Source: ABdhPJxZF0yGegE0t65rUJiVVNOW6O5pez4dgOGAVLejSAHeM73qkpz1o/wkQGJ3aDl5PmBUST+qUw==
X-Received: by 2002:a17:902:d2ca:b0:14a:26b8:199f with SMTP id n10-20020a170902d2ca00b0014a26b8199fmr7147560plc.107.1641947648699;
        Tue, 11 Jan 2022 16:34:08 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id oa2sm3471384pjb.51.2022.01.11.16.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 16:34:08 -0800 (PST)
Message-ID: <61de2200.1c69fb81.ba26e.96f3@mx.google.com>
Date:   Tue, 11 Jan 2022 16:34:08 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.15.14
X-Kernelci-Branch: linux-5.15.y
Subject: stable/linux-5.15.y baseline: 131 runs, 1 regressions (v5.15.14)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.15.y baseline: 131 runs, 1 regressions (v5.15.14)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.14/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.14
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      d114b082bef784345bfac1e1d5c17257005284f2 =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/61ddf0ad8130c6c38def6766

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.14/a=
rm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.14/a=
rm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ddf0ad8130c6c38def6=
767
        new failure (last pass: v5.15.13) =

 =20
