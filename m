Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 269F933FA78
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 22:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbhCQV1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 17:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233488AbhCQV0v (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Mar 2021 17:26:51 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9169AC06174A
        for <stable@vger.kernel.org>; Wed, 17 Mar 2021 14:26:50 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id kr3-20020a17090b4903b02900c096fc01deso2019086pjb.4
        for <stable@vger.kernel.org>; Wed, 17 Mar 2021 14:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qYkAmuGjeTXqwd4X6SBuRzEHo48tFHKiOQOKzccbz8Q=;
        b=SlZZXfgqQnICkxAOY9ezE/9DOwqK85Ewc2isI0pleqm3sj7zeC7fs3N6TYjBapHE6B
         +fxDuSC/jOxkOvw8tD0k2WO9sk2kB4rF/cATTjEiEqEoAQE60774nOp5N8ZU9AxZn0B5
         Hbz4C7LLuhs5LKRn87zj4bfaQzSLRB/wCxSsuIh+nQTAZa8qVii1V9OkrPu8JRN4g0IM
         LDMbvojRzRX5RGauHssWUB7FJp73wxqWM43WZRGB5Rdr2YxZxVIGApMfFV6IYgkQUdqu
         dk9ZnExzNSz+xQfMSE9ecNoPAbDEfClQXRTjQtdSNgCIsVC3uc8PtHRTsZqtKxikCgFS
         54Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qYkAmuGjeTXqwd4X6SBuRzEHo48tFHKiOQOKzccbz8Q=;
        b=pR6ww5L2gWEX85W7yfVxAo3CPF3Ga9hpMMPXPU1I7YDe3q0h+0eWr0idlRr9/ev2y9
         3j8bFea03mkWvempiyKh2cVF4T3gSddcGztvMy7jj+dZoacMaxbrHRWGPGnvLelvhvms
         u3Po/+dWn/IQp3LBWFLLzgmMPC9EaLMmwcf9AZhG+GmOGkzNHutZrNnNcmnkRMjsfBvP
         ZunotVv5NNFompbEZMM1yQZLm/C5kAfQkpCNEx5PAcRqSjuQTQ+CarXciflczFRxF64J
         z09keEcJ2Pl6RMIbFSLdY/cvCuqoGLHiwJXKvJlOXj2WEPXBrQuXrc07enaZiM7ZUMK2
         4fVw==
X-Gm-Message-State: AOAM532irJAJ1rW0s+ZvtGliOVIClpUpwrEOSIe9TCj4kZI9CxvZKAHQ
        ZC0QQBKMjEP+vmbIqc43njVspXVOuvslIw==
X-Google-Smtp-Source: ABdhPJwIpEoboG4gVt0pZ0GrX8NfpKao5M96KHcD7j7fDCC64zovJ4KdMUKJhCrIg6g8uzojSngF9Q==
X-Received: by 2002:a17:90b:2304:: with SMTP id mt4mr832370pjb.179.1616016410021;
        Wed, 17 Mar 2021 14:26:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 8sm42114pfp.171.2021.03.17.14.26.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 14:26:49 -0700 (PDT)
Message-ID: <60527419.1c69fb81.acac5.03d4@mx.google.com>
Date:   Wed, 17 Mar 2021 14:26:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.23-289-g9ee0b4dbbfce
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 178 runs,
 1 regressions (v5.10.23-289-g9ee0b4dbbfce)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 178 runs, 1 regressions (v5.10.23-289-g9ee0b=
4dbbfce)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.23-289-g9ee0b4dbbfce/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.23-289-g9ee0b4dbbfce
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9ee0b4dbbfceaea3bf0a680fa3ba9f7ecee23620 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60524521f3bbf7126faddcc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.23-=
289-g9ee0b4dbbfce/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.23-=
289-g9ee0b4dbbfce/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60524521f3bbf7126fadd=
cca
        new failure (last pass: v5.10.23-289-gb6c4038ab5994) =

 =20
