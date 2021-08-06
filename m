Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 392923E2DCB
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 17:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234217AbhHFPa6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 11:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242735AbhHFPaz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Aug 2021 11:30:55 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B19EC061798
        for <stable@vger.kernel.org>; Fri,  6 Aug 2021 08:30:39 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id e2-20020a17090a4a02b029016f3020d867so18303886pjh.3
        for <stable@vger.kernel.org>; Fri, 06 Aug 2021 08:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Cp6Mj+sa7LqNyNxDSqVRaevpbeHrA/0K3TmyocXvOTE=;
        b=kZk67UVrnW9NyAiWkeg5y0K0iYuCanpwkNUIjR9AONrhA/hffoWYx9civt5LqUnsIn
         ppt7O62xVPIO0mMZGryTYb+YL9B2adPXFtwOIUjppFnKs1KhOdruxdwYuqPhAH9d5zI0
         YexU1lu55EJ/UyLjQwDweBY74okBMML2KFO55h5qTkIODvZXbMmqiaWYzNLsXR7PAG3S
         xKjd0hUWx3jnMAwpQrwFm3On6ymIJAyFNXKHCaZnu8g1le2XYTdpiigeVbqeSNIzpcj9
         Iwy1gDBoBwnC4ZZsffnc/EkbIvwhM14jpsjE+gm+FxwwhX+2ggprVqIHMAiyGjX4k0y/
         dDRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Cp6Mj+sa7LqNyNxDSqVRaevpbeHrA/0K3TmyocXvOTE=;
        b=RVxQq7T1UXBCogcVrqRSmZuU50on4pXgXL35j9jVvJ7fUkaSgaTqmHAey0AE16J2v9
         hm0tHR1qflnNgY2ze4L8uk1bVeMKHc4kAOapeBj8xkyDIn5XTU5hSOccnQgUtvajTXql
         e5znSvxoHAYQq5upT0AbDppYHuby5A0axMJP7XvU9fqV0er/qjUDGcXZU3c6rqur9q0n
         kCmTCezjENFjo1GWLbm5E955V9XY+G3TeDWuMQech9/2aDCTZrvS4W01qbpMCHRyAby0
         mE4KpM/4qC04uVf5q/A2ZW9gQiQSf+G4pgLwHHtfxi4FZdr4EAT/b6AqDcyOQJA0FHuz
         QiJQ==
X-Gm-Message-State: AOAM530eAPy/S5S7iLtUoM1c3au1zTqXQWFoybxeCifwxmzCBdvIn2XR
        lH4oLa/1TR1IUvcwAh7OTC9a1TuUVBVfxg==
X-Google-Smtp-Source: ABdhPJxycoXEluZ03zkEjErq7PXuzuGImAP+OnVf9xabIdTlkFq4OIdVw2IXrtHZW8NJn+qnDIjYDg==
X-Received: by 2002:a17:902:f244:b029:12c:cfe9:b01f with SMTP id j4-20020a170902f244b029012ccfe9b01fmr1380552plc.33.1628263838378;
        Fri, 06 Aug 2021 08:30:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w67sm10970952pfc.31.2021.08.06.08.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 08:30:38 -0700 (PDT)
Message-ID: <610d559e.1c69fb81.61a78.0334@mx.google.com>
Date:   Fri, 06 Aug 2021 08:30:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.56-30-g28636e4060d8
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 118 runs,
 2 regressions (v5.10.56-30-g28636e4060d8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 118 runs, 2 regressions (v5.10.56-30-g28636e=
4060d8)

Regressions Summary
-------------------

platform        | arch  | lab     | compiler | defconfig | regressions
----------------+-------+---------+----------+-----------+------------
fsl-ls1043a-rdb | arm64 | lab-nxp | gcc-8    | defconfig | 1          =

imx8mp-evk      | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.56-30-g28636e4060d8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.56-30-g28636e4060d8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      28636e4060d815db974087f02fe44e5721336651 =



Test Regressions
---------------- =



platform        | arch  | lab     | compiler | defconfig | regressions
----------------+-------+---------+----------+-----------+------------
fsl-ls1043a-rdb | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/610d24532ddabc7e28b13693

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.56-=
30-g28636e4060d8/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls1043a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.56-=
30-g28636e4060d8/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls1043a-rdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610d24532ddabc7e28b13=
694
        new failure (last pass: v5.10.56-19-g64ac3b65bc37) =

 =



platform        | arch  | lab     | compiler | defconfig | regressions
----------------+-------+---------+----------+-----------+------------
imx8mp-evk      | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/610d22a971f95e9ad3b13678

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.56-=
30-g28636e4060d8/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.56-=
30-g28636e4060d8/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610d22a971f95e9ad3b13=
679
        new failure (last pass: v5.10.56-24-gaf82390c457b) =

 =20
