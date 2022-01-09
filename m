Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30AF3488C49
	for <lists+stable@lfdr.de>; Sun,  9 Jan 2022 21:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbiAIUau (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jan 2022 15:30:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiAIUat (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jan 2022 15:30:49 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 976B7C06173F
        for <stable@vger.kernel.org>; Sun,  9 Jan 2022 12:30:49 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id l16-20020a17090a409000b001b2e9628c9cso13845254pjg.4
        for <stable@vger.kernel.org>; Sun, 09 Jan 2022 12:30:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Pmp9PWideZUbsU72g5Tc7Jxjm+UmxXtZvmrAkWCEx5o=;
        b=L2xoVte1DXve05F3vuIuapISN+oDcQI/Coe+GSlTlrDROkI7Oq+0gO7VURSA+mFeNn
         O1Rbrzy5diW3/OBAEi4KW2aHsVbfM3R67JOOmUX4OjPguXQNw+MozCMSf9GaAentoqOI
         AJ4UN4hV9hJ72H+40Y0QPH+ua33zycwxULjDjw0iTU/2Gzz9ZIkMbRtJk+9L/L/xxFWd
         V1Yxfd+Z6aDu/vzyyd1QmA+agrKatWqerAMfXl2yPUwH8WexhURDl65vUoy6do/oe9VL
         0E5r2KXJQKrCTFS48m8eJbSha6EZKmtG9zm3kxoGq7vhP41V/8h5sOllZfs13DAF4c1f
         rbJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Pmp9PWideZUbsU72g5Tc7Jxjm+UmxXtZvmrAkWCEx5o=;
        b=Bulw62gfWUECBE9h+aKotzg0iY4IdflQyJpdwF9tOseCYzhBB4SHI4UFXk/Tt+nOax
         EKogyMfA637sLsSNWNJm3sn1TPcTOaAKgACwNUfjOtNORo0DbnJSvIAT+dqVCSm+mWNB
         kBhyIL3UPkbNjoEfnGswrsHWeOPwqTyo4lfeVDI0eMdXSpnQJn90+Pm6zbcOMSgjctSg
         wdg3e3raVoTO4qC0XC8LhAbJRUscZ4l41t27ljDanet82y8kav2yavr4YPZk0rgovMD2
         3LUrdr59NZAcT2pZVZsX0e+zpNLQNj4dRT7sSnAo8S/UwcGssB2T7rHxvIDgVAMuY+1c
         +A0g==
X-Gm-Message-State: AOAM531D6cOxD3pIA5dvz0uiHT8e+wzVzLQ/EjVN3MEUpsbvDFjOhzO3
        490YpR2UgMbp1aTv4ZO76mnyJ9jQ+W7BDWWJ
X-Google-Smtp-Source: ABdhPJwYrJ91kBdckMzs4Wo9pk0ntCGK10dFfIQ0m+Ft0eGDCbT0JokUn/x2q9MCxKibosKauWU7kA==
X-Received: by 2002:a17:90a:188:: with SMTP id 8mr14140958pjc.182.1641760248857;
        Sun, 09 Jan 2022 12:30:48 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f7sm4334538pfe.71.2022.01.09.12.30.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jan 2022 12:30:48 -0800 (PST)
Message-ID: <61db45f8.1c69fb81.6b1ed.a91b@mx.google.com>
Date:   Sun, 09 Jan 2022 12:30:48 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.90-31-gf757523866a0
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 172 runs,
 1 regressions (v5.10.90-31-gf757523866a0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 172 runs, 1 regressions (v5.10.90-31-gf75752=
3866a0)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
tegra124-nyan-big | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.90-31-gf757523866a0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.90-31-gf757523866a0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f757523866a03c2a793f10b3764288bfdd5af3f0 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
tegra124-nyan-big | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/61db1bc48e49f671dbef6747

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.90-=
31-gf757523866a0/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegra=
124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.90-=
31-gf757523866a0/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegra=
124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61db1bc48e49f671dbef6=
748
        new failure (last pass: v5.10.90-25-g9e8cfbc1c8c9) =

 =20
