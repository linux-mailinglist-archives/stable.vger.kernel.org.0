Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD58248BD1B
	for <lists+stable@lfdr.de>; Wed, 12 Jan 2022 03:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236391AbiALCZP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 21:25:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348458AbiALCZO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 21:25:14 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494B7C06173F
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 18:25:14 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id a1-20020a17090a688100b001b3fd52338eso1006439pjd.1
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 18:25:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iFVFnsGygVq8y7cSseuglJ1JaUydrvuIdTuT3zQpz+c=;
        b=h4xsEQ6JMqUa4lxpeTO22roi69tNnaxenjDVtpSD2QYz4CfbY/RQdhHpfFFffhqOKb
         GOifkcPYanF/Bk0EH+ACAW3z4F+c2ImfYV1abfeAACdYBI82VeT198XcdB5jZox4moyh
         VtQthuDrS/Is5bRq8fZFRcK3efRmwH8q7jIZxcnlnXI/pKG9r1Pl7lPHZHSbxUCmz/ch
         VCj1sm/xa2Ki7mNxLs2/Oj/ks1KVlCJDFoEvPlF1vreu0zoyjlm8A2u9Qoc46RuEYPo4
         mZvIFvZ/IiRx3M5zpx404dQyc3QzMjyfgT1cdl6I9d8wvgrQn8Fn/HgkFCS/pPUWJA4Z
         zrqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iFVFnsGygVq8y7cSseuglJ1JaUydrvuIdTuT3zQpz+c=;
        b=kc2HVxdGmrYgJ9Alllk9wiLXLhzHluh347X9OOs0w29GSfMh/kn8sRwoAeNa1VYVd5
         DXRgB2cVitERskYJR4uScl2uGu0xT3Zi3IFuPmiWlYpJJrxUeRpOwubTjYQGmVW3KAyb
         syltS/odmvuPNRiU6LGj1Nyld9POTqHa+FgLh0qzNiopnXdcuVUeTmAoy6PZZfXtyGKp
         55cKa/XT9OZsSmwcO+zGmf+Px223WG0tMjykMvH7Psz+UiGWDDnHdzfBL9db6Qz46zPb
         okTDiEz2PApXTKD5hCWbvNYvVaozPYRAakxBFiM8AweWPCLLdJZu46hMT3yhkFlSIDE3
         Ye3A==
X-Gm-Message-State: AOAM5319cC3SV/cbT6K+9nKyQaKuXe7JpbeiFzB7JtTCAJFEDEzVyYAP
        uiZaUqTnmh9tQvNPU5HeSFXUkXm2aXrxp+Gc
X-Google-Smtp-Source: ABdhPJz858y3oEJwyDMyf6TV+eRZJxYiFE2mZcz2+77w91R6bOqdS9B5lWG5VtjJuRbJF04pxFjFZA==
X-Received: by 2002:a63:b217:: with SMTP id x23mr6555225pge.174.1641954313638;
        Tue, 11 Jan 2022 18:25:13 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h4sm12066320pfi.79.2022.01.11.18.25.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 18:25:13 -0800 (PST)
Message-ID: <61de3c09.1c69fb81.5379d.e91a@mx.google.com>
Date:   Tue, 11 Jan 2022 18:25:13 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.91
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 152 runs, 1 regressions (v5.10.91)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 152 runs, 1 regressions (v5.10.91)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.91/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.91
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      df395c763ba08b8b4385481af07d5d1c658dd917 =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/61de09ff61ea065bd8ef6759

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.9=
1/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.9=
1/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61de09ff61ea065bd8ef6=
75a
        new failure (last pass: v5.10.90-44-g83e826769db7) =

 =20
