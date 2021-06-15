Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76FBD3A72F5
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 02:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbhFOAZl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 20:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbhFOAZk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 20:25:40 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C5F5C061574
        for <stable@vger.kernel.org>; Mon, 14 Jun 2021 17:23:25 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id mj8-20020a17090b3688b029016ee34fc1b3so888469pjb.0
        for <stable@vger.kernel.org>; Mon, 14 Jun 2021 17:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SfACALLoOvMbpyfP02WBacpNbsnoW7E48EsZTNrfObk=;
        b=JecNYftez+hJbsqn4YDXBT0x2yt2+qGFG1OdohITAaxuObfpA/Zkrrgoolcbfs0N9I
         bkgDGHnbp/pCfvfWgal/lgQAivfK5Jtm+VL2tA8wqvqVFTXmvNopOL+gpEwaKkZB7b3e
         eeOJ4UBlo/1TWjOakghiAirGuCvew6SAwWQw9prisLumr7ukCMpUR9ARrKzqJQcLMLHO
         yKi2s86ialr3F1Rmxy8qGFmeDTRDiVuM9qnQpQUy+qRSkVE3GfPb/4KRO8pzftF1SiPJ
         5HqFGsxTRJxUHb5pnZa6TjwzY4/VfDoweMld5BCqBeNMSIZZ6sSnWYtuh8UVJlarFzYG
         /7WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SfACALLoOvMbpyfP02WBacpNbsnoW7E48EsZTNrfObk=;
        b=Snpz9pisph4pp5HGC/MgFmA/sBCYuoRsAXYKEeNIBx4Mnj1kHce43rksEo3Y+IYQi9
         ohXAXpFKsYBVZalFkBK09FcTNSQJ7ETSvgnaroOpOJgBAWGHGAOayzbeGREsqnRA9ZP5
         U5b2oEhe8zDdtCQY724QeMWRIfGz70wU5Z7OdS4KNdSJ7E45XLg1Xdq5oPLTjNbEFz02
         fTvWoJBb2lc+w/ZIZn2L2wGbYFUsaI+OOCcmi79h5RBXZ08GZi/FQFjVAT9fxXNM3Z8v
         +y7x1wS8ZumNvVvy9Lxxqqm6kzBbq9gvG/5QVSYHDoPnDD5Lt60YrdYydY0gLkY225tR
         fRpA==
X-Gm-Message-State: AOAM5310BxytypZ4MlX7SAH10ivdJlKfzhboxHpmd1/6lDsF+sww8XJX
        10hBVso/iFZpanE7Vdl9w6tM+jajBQQ5CxZQ
X-Google-Smtp-Source: ABdhPJx35ACwKRAwvdmxovixjPE2lgLJKKdRCk+t9OfMM3cPA1Od0/Wrgw3wZwPwcS+gZzr+iFB0TA==
X-Received: by 2002:a17:90a:6b01:: with SMTP id v1mr22050876pjj.10.1623716604783;
        Mon, 14 Jun 2021 17:23:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c3sm13296592pfl.42.2021.06.14.17.23.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 17:23:24 -0700 (PDT)
Message-ID: <60c7f2fc.1c69fb81.75131.7995@mx.google.com>
Date:   Mon, 14 Jun 2021 17:23:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.236-49-gfd4c319f2583
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 136 runs,
 1 regressions (v4.14.236-49-gfd4c319f2583)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 136 runs, 1 regressions (v4.14.236-49-gfd4c3=
19f2583)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.236-49-gfd4c319f2583/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.236-49-gfd4c319f2583
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fd4c319f2583a75ff58203593a3a55a18e012a64 =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c7d530871bde0782413294

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.236=
-49-gfd4c319f2583/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.236=
-49-gfd4c319f2583/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c7d530871bde0782413=
295
        failing since 105 days (last pass: v4.14.222-11-g13b8482a0f700, fir=
st fail: v4.14.222-120-gdc8887cba23e) =

 =20
