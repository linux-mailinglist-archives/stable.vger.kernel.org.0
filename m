Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 236ED34F163
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 21:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232925AbhC3TBs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 15:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233050AbhC3TBk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Mar 2021 15:01:40 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B190C061574
        for <stable@vger.kernel.org>; Tue, 30 Mar 2021 12:01:40 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id y32so11248311pga.11
        for <stable@vger.kernel.org>; Tue, 30 Mar 2021 12:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Tn/b30b6P4sTKYKKub/81DTMFkPUKeegTBpRy8n3kcA=;
        b=WQOa4YiIyATebZTuo1pa8S4iwRZGXTqiUIs/IBgzQIhjVlXgC8+8tN6rWFxEJlNvah
         4Fv7hWCO8BdI+zucH+lWxOYR3hnE297dU/A5JilsGFzfXvbOkop9MxpznGxPL5AqIOUl
         L8gCEj7c2vGqiXPQ9TCwiHq33uSeJsriHZIQclfFrvzWpzKjqJaZvHZDCCvSz5J47xrV
         ZZpVpitebf7aOyTadB1S06XFkaKqRUgydE2OnYi3PKMeqFDZ1b8OqcUuxqaDdaerfepU
         likItUOT47dL86LAeGn81JkJRkR7fdEv9boAG5tiA2De3Trcvwnmpu5rQgWTPvt06jUx
         P6qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Tn/b30b6P4sTKYKKub/81DTMFkPUKeegTBpRy8n3kcA=;
        b=lSxhwr3NK04Zp+hLwSezeU6gjs8bsblMHHOeMRTo0TPOcvZGMJFZnfnrZf3Ph+Jd8y
         nbC9TLTk4WSva2h5hJ4LnfktxcfMSd3zoCbc2yQZM6sHoaWX3XxTT4++6cdnInM0e6KS
         901rrGtr7L18gnNo5eNiRlRBOSEpKQjC3mG7zEM1sceDRyj9IfwfoBv5kdJcZhbCBaIn
         6W8OmcT6P5nYr3+8194HVO+0KC7AVJoESBUz+MT/pZ9LMuYs3SMazCiO2YUseRcAReLU
         nDvjM6C+jM8CB/18rbuoEWsoKDpxR3yqSVQRKhMboZy2+zI5FbT2utwJFrRIGQBgCmfZ
         RWVQ==
X-Gm-Message-State: AOAM530Qqura+N4dEOpEgNlpWExA0wqWMAxWhvxbf4KB17dC+UlxzqxQ
        2RKtsJJQwIKPNp48Q4MlrIXtZI+Ic2GxrA==
X-Google-Smtp-Source: ABdhPJwOe1crhZWFQr2XTto/iKGtpWiQ4XQ1geJdWzMZcMNc2CfSWkiZ7BFjPAsTpjtKRYznVRA3AA==
X-Received: by 2002:a63:c4f:: with SMTP id 15mr9333139pgm.379.1617130899858;
        Tue, 30 Mar 2021 12:01:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j3sm21225000pfi.74.2021.03.30.12.01.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 12:01:39 -0700 (PDT)
Message-ID: <60637593.1c69fb81.44fd8.44e1@mx.google.com>
Date:   Tue, 30 Mar 2021 12:01:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.27
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.10.y baseline: 186 runs, 1 regressions (v5.10.27)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 186 runs, 1 regressions (v5.10.27)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.27/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.27
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      472493c8a425f62200882c2c6acb1be2e29b3c03 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/606344b944ce500ab7dac6b5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.27/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.27/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606344b944ce500ab7dac=
6b6
        failing since 12 days (last pass: v5.10.22, first fail: v5.10.24) =

 =20
