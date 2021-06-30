Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6B363B8937
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 21:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233681AbhF3Tmd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 15:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbhF3Tmb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Jun 2021 15:42:31 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA5F7C061756
        for <stable@vger.kernel.org>; Wed, 30 Jun 2021 12:40:01 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id w15so3360524pgk.13
        for <stable@vger.kernel.org>; Wed, 30 Jun 2021 12:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eF1iy2SDcNPFZ0eWFzvwtYPy2DlNxh/xA5ujUwzFhjc=;
        b=VnFXW1sfHX3eYhPqcKXHQ1+agd77yzoFsKwmRFbAtND9lNA8ahGL4NwUboEb2F5NOu
         +UVvwAZbf3wYgBZyoLvh/3vrwuQEE8p0hk3VIYohoxoLifYBOrPrdEKlszdDVgvHm6wO
         faJ9e9dmL/bK4uq2Q48SxMR3xWOrMHXupxUM6Ay7Jzf+fwrOxH5VsT7B7+7GWkH1lx79
         CUO9XwaWbVWxQUdXjInwuxIkKTUVhgpv4i7aLNyAxSmlHqzdYNS/pJBapvt8WRH4FPbG
         LFr3q96z77WzSeFVuMIwDxQGqld1gZ9HBA7uua+6wb3nlgGUO4RphN+8iOyTSIS+HFoz
         byTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eF1iy2SDcNPFZ0eWFzvwtYPy2DlNxh/xA5ujUwzFhjc=;
        b=oWxVnQR9t1rC8NLlHICVwcq355Iw+3NEGdILlpTI8c2vgMFhFqxfIF0ccT1RhGQ2Ly
         ceV3DAbdXbpn3gnCl+fOVj6rmnYmWkk1bmkUZ3UgMPYE2EJSb4aRwQ1xVKdW0iGDsl6H
         t2vfQN2K/5gQUctXaxBYf4aYl9cYNmY+NlybwdfWAkZIcRoJrRPhJb3lzrqDVlV1+dS+
         qNhmGPErNedAMJqDafqpl8BGVQakcmKRUKeww45ygt57zIjyEJCUE5SIebtg7DZfYlr2
         QdsyrF+TauFZFJKudIoEV108SwCc2KYJmoZIlrIZs+qpwaRckSmisCAr1cUMjuapWTwc
         CWrw==
X-Gm-Message-State: AOAM533tOxhTqXZDjLBk11zPNJTaTibx4qzUOzq7F0qlY+v16E4EuKiP
        zQeVvT/1DHm5bRkGYixJs6LgMVhZgn7FiZxf
X-Google-Smtp-Source: ABdhPJzkCnFDj9Q2gwJ+yE038RV6+/cMM92sk4LIev05uB4f1HP+KTBcwvsC3Bm8UEkd2UTZPBOwRw==
X-Received: by 2002:a62:1b4b:0:b029:30f:ce69:292f with SMTP id b72-20020a621b4b0000b029030fce69292fmr5574789pfb.10.1625082001099;
        Wed, 30 Jun 2021 12:40:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nr12sm7173389pjb.1.2021.06.30.12.40.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 12:40:00 -0700 (PDT)
Message-ID: <60dcc890.1c69fb81.301c4.6f59@mx.google.com>
Date:   Wed, 30 Jun 2021 12:40:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.12.14
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.12.y
Subject: stable/linux-5.12.y baseline: 152 runs, 1 regressions (v5.12.14)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.12.y baseline: 152 runs, 1 regressions (v5.12.14)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.12.y/kernel=
/v5.12.14/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.12.y
  Describe: v5.12.14
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      afe5d2361cfac43e2eb53d547e78386bd9fb9483 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60dc99570d603c1d8f23bbd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.12.y/v5.12.14/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.12.y/v5.12.14/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dc99570d603c1d8f23b=
bd3
        new failure (last pass: v5.12.13) =

 =20
