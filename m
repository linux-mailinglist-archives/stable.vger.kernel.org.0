Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 235CB45638D
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 20:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbhKRThC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 14:37:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhKRThB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 14:37:01 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CE8CC061574
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 11:34:01 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id y14-20020a17090a2b4e00b001a5824f4918so9066718pjc.4
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 11:34:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ObdiwfA/3kfxN6+lncKhIfLDZjDrUo4n595bcJnDs4g=;
        b=7uttg2e7wi4iEyyCHDr9aY7GZF0SFkhBQc84WU+jQKW9+PtT6zvdfxRd5RcQt9Je2N
         q3NYWuHZDN+HpDJ/mNVeW1/R+/jMdFTYrZFuNzEBe4KScJ88xmTmn7fcUK0kkT6xGEb1
         bDKUvUQz7ruDMsOnvpDFTHkYwqhVZS+2N9FZ+mdXdT0Dh3jpmZ+ViHASnqxgh/Omtry4
         UgOAz8EmdIJSmFPqi5WiYDgs4GKXtfI+9UVYXzft3k7FcSXYfIsk53EuGf2hVai267n6
         fjJO++Fnto4Z8Fkc8GN6AUiwk3BdvE1MRHytlmuMHNqPhfpHMHInP29brD669LrJi9JG
         sbHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ObdiwfA/3kfxN6+lncKhIfLDZjDrUo4n595bcJnDs4g=;
        b=ftTmU8NzjymjAZ2J1WoiD5mlV289E+qGq5a8l9mhnOlj9vLh0BvNhW52KATHntzMXC
         nxTQP9V4+FIdGq3ety++yUQ0zYxr/Ib+512d2qDk893Mb3Ro5F2x/kGzbKrdOS00i+Ra
         1XI1+ereyV/vP/jbksZ/BM3Jr7b8WvB1yTJiBYIDxXtv8s3SkZAM+bSgkV+twLAGb5CK
         XqS8G5WgBptsGLF5q2G/iigRw7OrsRzlK8K5cyxsWFaxkP9wyGbm/R18YarjNN1enZam
         lJ6cQEwFb2WLsg/zkeFSCEvL0EoR2SQ6RvSCZX+iozi07CZwOkQZETPJCggm5KojgibH
         v7vw==
X-Gm-Message-State: AOAM533vYwrjaWyF3Wj3nvr8vDMYCXKnDWkWYdm/ySPwB9aKTELIRr5p
        TA5mhqXQlWG7fEpfswTua0+m7gnkYTnl+7Kc
X-Google-Smtp-Source: ABdhPJyaPyNeLcBBpuAPd3fX5egHaUGG35XoUb2z39xQ4N7C+I0dNd33xQxzRo8+FV0QjHLyH05/GA==
X-Received: by 2002:a17:902:7284:b0:142:728b:46a6 with SMTP id d4-20020a170902728400b00142728b46a6mr69345869pll.45.1637264040652;
        Thu, 18 Nov 2021 11:34:00 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o4sm8848731pjq.23.2021.11.18.11.34.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 11:34:00 -0800 (PST)
Message-ID: <6196aaa8.1c69fb81.65d6e.aa33@mx.google.com>
Date:   Thu, 18 Nov 2021 11:34:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.79-570-gb8a534d0c374
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 163 runs,
 1 regressions (v5.10.79-570-gb8a534d0c374)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 163 runs, 1 regressions (v5.10.79-570-gb8a53=
4d0c374)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.79-570-gb8a534d0c374/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.79-570-gb8a534d0c374
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b8a534d0c3747ffc7d4c5842a4ebc5c347857008 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6196764e81b3f017b0e551db

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.79-=
570-gb8a534d0c374/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.79-=
570-gb8a534d0c374/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6196764e81b3f017b0e55=
1dc
        failing since 0 day (last pass: v5.10.79-569-g878c6aeb961b, first f=
ail: v5.10.79-570-g9b865fd3ba992) =

 =20
