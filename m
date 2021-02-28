Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86A293274B3
	for <lists+stable@lfdr.de>; Sun, 28 Feb 2021 22:58:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbhB1V5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Feb 2021 16:57:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbhB1V5w (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Feb 2021 16:57:52 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0645C06174A
        for <stable@vger.kernel.org>; Sun, 28 Feb 2021 13:57:11 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id b15so9786437pjb.0
        for <stable@vger.kernel.org>; Sun, 28 Feb 2021 13:57:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=W8eym4jtINFYzQD38TiQJw7XkNsx2CqwA9uU0reKdBk=;
        b=VCtrS7pU+xEhqthlh+QqPpUnCu4VF8k4ngkj+kzroLpTYRUogNPTUvhN9Gz21zCzky
         cm5kuVb19EmCnVo0Juk7DbHt4mkWPGUotSBok9c43TWLGmKoHZxz2Rm04VDfFU2vj2O9
         tRL7iMYcEONsr9NMihh88Nga93ObZKeVRlopt+R3jWbzDL3pOco9nMVrUZ6loA42pnVP
         u9r9IWq+1xPFDnSU0WRisRJdnSz84Va+cm7VjWsAsWNl4uksAklMf/fGRhPGrqAguaHQ
         ZqnaUzJ9Dh0q2DqgWsJBlQD3XwJKvwUXPK3f3vIAY6PnlmDzdfpPF5dZXA8MqrSvBR0g
         4gIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=W8eym4jtINFYzQD38TiQJw7XkNsx2CqwA9uU0reKdBk=;
        b=qlrfnkXV2l2w4hv7GMohT9FStOol7Z4rUp9weLrPj3P36k8t85lYd5szL4F1RMLSb6
         A1v+cXYXGrPFLE8fQ9MBGO+X/hnDZnoPhxBXeuwSFXzoIcCfEAQAxCtxf80JDIw3GFoV
         GHmqgM6ryspWN60FnkVJrbmYY91xx4l/AsrYiU/ojSQyLkkxRgpheoRS8Vth8gl2nWBk
         ejcQdQZ3qlkahP3mxc1hjJq1aWCQnkCsF9hbO6Vr2D0qHpCNqJilz8ksKeV1lIX4aV8b
         qB9p55pgctfVK6d1s7I3mQXUEvm2afV5sABXbuqB+sea32urL3gqQJ3xz+CvwcL97P5Z
         4uag==
X-Gm-Message-State: AOAM533eDNdogT31p3j98Nq4wU6ZEYt030efTjaCUNl3qfIK2PNWeHaK
        LndZHJEvdUYkl22HyfD5C3FzzUhvy0OUZA==
X-Google-Smtp-Source: ABdhPJw8h8UESrBgNQiBeGSm0vzT3oIPWRESt0dADrcoUqFrl68MKPP3x0zAFbObv/tpAiumYtxIHQ==
X-Received: by 2002:a17:90a:7344:: with SMTP id j4mr14444506pjs.216.1614549431006;
        Sun, 28 Feb 2021 13:57:11 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w200sm15658216pfc.200.2021.02.28.13.57.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 13:57:10 -0800 (PST)
Message-ID: <603c11b6.1c69fb81.32572.490e@mx.google.com>
Date:   Sun, 28 Feb 2021 13:57:10 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.258-12-g80c6cbdf1f84
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 48 runs,
 1 regressions (v4.9.258-12-g80c6cbdf1f84)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 48 runs, 1 regressions (v4.9.258-12-g80c6cbdf=
1f84)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.258-12-g80c6cbdf1f84/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.258-12-g80c6cbdf1f84
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      80c6cbdf1f842f153ba4168db22569504c268989 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/603be0d562f493a7c4addcde

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.258-1=
2-g80c6cbdf1f84/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.258-1=
2-g80c6cbdf1f84/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603be0d562f493a7c4add=
cdf
        failing since 0 day (last pass: v4.9.258-8-g02b1ce02a115, first fai=
l: v4.9.258-12-g07130f67e5d76) =

 =20
