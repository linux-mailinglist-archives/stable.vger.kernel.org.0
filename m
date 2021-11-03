Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6514446F8
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 18:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231551AbhKCRX5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 13:23:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231489AbhKCRXx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Nov 2021 13:23:53 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA2DC06120F
        for <stable@vger.kernel.org>; Wed,  3 Nov 2021 10:21:15 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id e65so2961165pgc.5
        for <stable@vger.kernel.org>; Wed, 03 Nov 2021 10:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DTRGMiNHKYebZWCWx62D8CEQ427I5y7QtDJufVzLmnc=;
        b=J5llLhLNkdZAMCgq28t0N25Wqgyq0OUzEtsIt4H9vUq00yoSBWOx/zIgv7OfxEfxMk
         xNlcCpUEA3pOIQYODkQPr4Gf/jIqe9+vltiH+Xu3oDvTWI0xi8v2+wMqQegCsADEr38v
         03qitUFQpa7RfYuRNpSUCHO8jFtSVawc3N3vYGu16oOu5oTXKMFdZcku2CdbRY6s+DAN
         kk/DHauzzl1wg9kckEPVohfF9c4hGCUb3cTQpdZBbMp3+LEpb5hPIQo5Y+cjU/UsNd33
         Lvb1oVxGYtycof41eSIt/Xk6JJnZ+G5NyNKfVneC8+v2gejQLlK0442Tp4Rgl6DzqevD
         CPAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DTRGMiNHKYebZWCWx62D8CEQ427I5y7QtDJufVzLmnc=;
        b=1YCg/kgYtRKZDve1VlDcTVIkz2rmdEs/3EQavofTG2c+rak9vKyMba5aVA82vPQugH
         7skfwDrqs7dve8LrdekrmPwwugypZ8I09YUYar4bRb4fIbaixmJvAwB7EfzG7cYzCFiv
         vMzsJj01KxZQ71W1dRkp8qDXqNq+YL2+oiEUzCmPxzUtfHHxoVI65iaY0LIYpyYHN/5g
         XbfJgIO88ux1bgurJqn3KhABvRAK4NhLzMkkyS9/bYY9T8SG9kXF4bog9atXgMkqc4B7
         B+rYrLnMUEa255ZaO5CWe9+AppQw/FOg26VDE3D5s45f4icoPZCCQ8rdizC13W4pN3Ts
         ZBXw==
X-Gm-Message-State: AOAM531gw+zS0az3R5cWi3neqiY91EsTJI4QJBcwykz9Y2Kzslj5Q92j
        FOjgknsqj5bXEPppI5slloS+yZydd9mibIQm
X-Google-Smtp-Source: ABdhPJybaEBqjCDz5br2zxXMVXKY2XLsBIRWD9e9OszLg8tjiXfXm+pQHDo8DgTpdz/kwjbz9zPBgg==
X-Received: by 2002:a05:6a00:15d3:b0:47c:1c91:93d with SMTP id o19-20020a056a0015d300b0047c1c91093dmr46053490pfu.80.1635960074718;
        Wed, 03 Nov 2021 10:21:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h11sm3325580pfc.131.2021.11.03.10.21.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 10:21:14 -0700 (PDT)
Message-ID: <6182c50a.1c69fb81.467e7.9aa7@mx.google.com>
Date:   Wed, 03 Nov 2021 10:21:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.16-4-gde92c86f0526
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.14 baseline: 149 runs,
 1 regressions (v5.14.16-4-gde92c86f0526)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 149 runs, 1 regressions (v5.14.16-4-gde92c86=
f0526)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.16-4-gde92c86f0526/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.16-4-gde92c86f0526
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      de92c86f05266dbb413a317102a6c1b5de0853e8 =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/61828d7c895c5bb2d433590a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.16-=
4-gde92c86f0526/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.16-=
4-gde92c86f0526/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61828d7c895c5bb2d4335=
90b
        failing since 0 day (last pass: v5.14.15-125-ge59bfc32a9f1, first f=
ail: v5.14.16-1-ga1fb46604823) =

 =20
