Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D27EC381F8B
	for <lists+stable@lfdr.de>; Sun, 16 May 2021 17:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbhEPPxi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 May 2021 11:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbhEPPxi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 May 2021 11:53:38 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33266C061573
        for <stable@vger.kernel.org>; Sun, 16 May 2021 08:52:22 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id t11so2408974pjm.0
        for <stable@vger.kernel.org>; Sun, 16 May 2021 08:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TWa+6hed7vJkzvJlSRIyQEAm7NoDaJL1zB0qydjFnUs=;
        b=Jb+X2d/jHGIXzpoyc9PV1FCrblvZywXUnh5e4YF+q4xSTYwZv08zvmDWI/2OkO5Aza
         3QQy9QkXKsEz7D0+4bZKiR5aJ7u2NPfR3bpw1prpwhTI4DxMMPvFgAfi1e96uLPLGIgq
         55wsAXg9idMk42A5z3aRhnUgkH0Dg7ojgsr7DaRhn8/JFE4g031G6Sxb7qZkPipUHA7x
         u/65WjH3cR53Xg+m1Tr5lU3teiCFsv8FPNgKmKLre4Ad6dS7yD0/q0PG8RpAXcUhvUn7
         a1BIIAbF2jeFqB9EkgLSX5AbxmAZ2UwmU03q6AaNHOhh5jzh1ZmANHgE2eE9vZI4Kg4P
         JU5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TWa+6hed7vJkzvJlSRIyQEAm7NoDaJL1zB0qydjFnUs=;
        b=SrhG3f9T0vGMX4I1tYTUm2Y4d0A4g0pZOJTwmuHRX5OIRzYEJxMaXOY1vRAZ/NamQj
         iAUI0Qofp94W8BTvzMCqqxjpUyObRqs5To1b1NR1uqCODzht4T9phzw56XHLd9SgrL5b
         XjySO938q5IvIZpk0SncZWQQwyHSHNqv9sRk/DvA/WMsiOMj1ap7LC0o9FwcJoiCG7cJ
         xW9dQJgV43e4u6HIx/VgvU/AJClFJuQecuj7I80SVMCdqNm8USGhyaHtmxIfeLgo6sav
         omcteW4N5WsXjrUVDIZ9yagFl3CYOxkMY17xNxr+EQ/9nSCpxC4+i1441C3HvP+WK17E
         7muw==
X-Gm-Message-State: AOAM5338RQKar02W1ohqXd8alr0x9P8uvZPqtE8KLJNLB51EAJUOH40n
        M7ZzJ1Jd9CkIvb4kej3KHzG2kVQorcgm55I+
X-Google-Smtp-Source: ABdhPJwWfJAop0j523ZjNHUBPvOVKS8n4ZOXIwxDnlxrc5WRVUz52aqAZOM5D8e2/OmoM1WL0m9qfQ==
X-Received: by 2002:a17:90b:1bcd:: with SMTP id oa13mr22309550pjb.22.1621180341382;
        Sun, 16 May 2021 08:52:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z7sm8199467pfb.93.2021.05.16.08.52.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 May 2021 08:52:21 -0700 (PDT)
Message-ID: <60a13fb5.1c69fb81.148b5.bf23@mx.google.com>
Date:   Sun, 16 May 2021 08:52:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.119-104-g700d2de76117
X-Kernelci-Branch: queue/5.4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 126 runs,
 1 regressions (v5.4.119-104-g700d2de76117)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 126 runs, 1 regressions (v5.4.119-104-g700d2d=
e76117)

Regressions Summary
-------------------

platform                 | arch  | lab     | compiler | defconfig | regress=
ions
-------------------------+-------+---------+----------+-----------+--------=
----
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip | gcc-8    | defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.119-104-g700d2de76117/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.119-104-g700d2de76117
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      700d2de76117dd2d7af7d0267fe82a9a3b65594d =



Test Regressions
---------------- =



platform                 | arch  | lab     | compiler | defconfig | regress=
ions
-------------------------+-------+---------+----------+-----------+--------=
----
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip | gcc-8    | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/60a10e068a3f95b7bbb3af97

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.119-1=
04-g700d2de76117/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg=
2m-ex.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.119-1=
04-g700d2de76117/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg=
2m-ex.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a10e068a3f95b7bbb3a=
f98
        new failure (last pass: v5.4.119-94-g0960a1ee7f69) =

 =20
