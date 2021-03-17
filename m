Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B50133FB28
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 23:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbhCQW2c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 18:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbhCQW2B (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Mar 2021 18:28:01 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F027C06174A
        for <stable@vger.kernel.org>; Wed, 17 Mar 2021 15:27:50 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id v2so142447pgk.11
        for <stable@vger.kernel.org>; Wed, 17 Mar 2021 15:27:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=oCvX3F8Yu1wf8KVZXBfN9GLgma5rimbpgHACqbK+qXk=;
        b=o6rVJV5mj75whPa+MyXGMRc0j++bYeY8atCRlNq+OW93nesvg32F+Vrab4OVYyzd8s
         tFpcLBNbeaw4BJIkpqMWlRBBmLj+NUTK6Eq+qkUqVG07nh+7mp2RF8hSO96MxAkDYiXp
         8n+oSu8qXAcLQ9nkq1p/PndgXO5Erfi5x4UX0ADzBOd5SE3s+mTKLeCbJqbw16iAlcZ4
         N5g5dVVDaSacr9Grd+7OdlccsNZxHYhjKCUg1SD7nYM0E2xANqGJAIX5p+EnX4HC9bI7
         EV0A9I6zncXgsJ4SD6z6/9t+HrqZlp66Bw4SnHFJNB9nDMmxfagE82+a8wvdhyyKMPtk
         tTNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=oCvX3F8Yu1wf8KVZXBfN9GLgma5rimbpgHACqbK+qXk=;
        b=hKKxaXDpcvwYib799PEkb17JrMLlG0Qhgp6KUpfIba30VZaHz1HX40zPy3A58VDebR
         O7jBg/tmdSZyppwgHpypJmPrFEFxIur4zUixIkfcMCBVrOlPjaXPH5kP1OcuaSeDgJV9
         StyWcybAlP1CJ1inFt1SmJVRfQey4Azl40V69gx0n14FU0lE7+9P6A+TraAQW/YQUssn
         6Q3soUbbVMfRTUC6dO5O9/9xTUMQWEXnJuYIauiZkrfbcsa4VXwVKsemT99GfkP/mce9
         WeZTl0gPseMPIHrBopyFni2tMoAbbKh+0D+Nsc6v6evj1VorRkdAEDgglDkJ3jMxjxOi
         41Bg==
X-Gm-Message-State: AOAM5327hGH+Dq2apNrHFE4OkxfjTAZpxMotmW6WNECklgZ41Zu9ALgG
        EB0fbzfzwzckjVYJqCVKEZQKI/GsDM0vCQ==
X-Google-Smtp-Source: ABdhPJzN1LrKWWCbhs8tgUeONCEOXQONFc3dtDj61GZ/ZYLNWsjBA3eAr2JqIjOp2fZPWYRuET9fcg==
X-Received: by 2002:a63:e5d:: with SMTP id 29mr4277181pgo.450.1616020069855;
        Wed, 17 Mar 2021 15:27:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 63sm100011pfg.187.2021.03.17.15.27.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 15:27:49 -0700 (PDT)
Message-ID: <60528265.1c69fb81.48e39.06b4@mx.google.com>
Date:   Wed, 17 Mar 2021 15:27:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.24
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.10.y
Subject: stable/linux-5.10.y baseline: 123 runs, 1 regressions (v5.10.24)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 123 runs, 1 regressions (v5.10.24)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.24/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.24
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      05d125f7524e9ad200375c52799575184755d340 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/605251794d7623eb34addce2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.24/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.24/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605251794d7623eb34add=
ce3
        new failure (last pass: v5.10.22) =

 =20
