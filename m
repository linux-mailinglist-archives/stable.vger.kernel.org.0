Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA344264CD
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 08:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhJHGpm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 02:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbhJHGpl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 02:45:41 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D46C061570
        for <stable@vger.kernel.org>; Thu,  7 Oct 2021 23:43:47 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id y1so5494678plk.10
        for <stable@vger.kernel.org>; Thu, 07 Oct 2021 23:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dD5y0jfUxthsPBUZBmE16nQIz7GwaJoQWslhIXuQ4jo=;
        b=mBztZOx+R5bjZu6Vurtwh/zggWD1DBC5rANO+H6gemlCEwCGf62uCk8pLZe2tiTGII
         5psKWX6DGmJLz5tVMAiV+nbfKn3BAh9lNQbxWG0t2X7+YNLWHPTdBIrTpjro/NpWnFgg
         HLJL5phiFCtixqQC9ZvMPq7urDxS8W5zYu8sZ0u3mj1AARBvSTSH9p5AV3LcqXNy81J4
         jV+EQ/qYk945a4cSBp/R/LvCrgjajVQgch3Ws32q7O1Us2sWGRlcXrydgBk9RJv1EfLL
         C8ukuVMhVVaDU5WOrrD216v8y1wkK3UnG/WGin7aoatB5wX/0ySWiJSE+EU6i7vhMXuj
         bdUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dD5y0jfUxthsPBUZBmE16nQIz7GwaJoQWslhIXuQ4jo=;
        b=7R6E2wdAiKejo27IzZRLZHrnFqrQgMt8Tasnwcp/Qc+lzzZT1BYz+yRvZmBt8yjUjq
         ue+E1WWcQbDfOBYWaFHSDfXaX/MahXqQ2pM24uZLTZviwxbJnPuSmZKRHMPot0iyIFGh
         Zi4LdP7ovRseWIsHbmqQg1URgkjxoo8RZonZnu3P09LCb3R+eppprZcycyoXTMpqKXuM
         C613IWwijXXk0GNdWxuArkNhckx0UVnSrXjkwhuajTkfL21unT1ui7wF07LNNdCTy63t
         CNY5WgpfYIOPTqYavW4FXriIruA2Gqw7UfNH0/7nI7ESkClrNMf+1aWd2xuXQ3fQC0Z3
         oYtQ==
X-Gm-Message-State: AOAM532RdEg+/b/ki8y49f6Cr/lZ0iIh2VRTGUXj7+/HDqK6Dyr+JDcG
        7PMjMo+2NjLqzCrUj5XoU1KIeF9ufGJ+snNn
X-Google-Smtp-Source: ABdhPJzrIYkivhdTBP1buSmvV3s6TMNVN27haysA0h7thXO8UN/X5s981ZuZBVpAVUrdBX5SpGtu5Q==
X-Received: by 2002:a17:90a:4502:: with SMTP id u2mr10284403pjg.186.1633675426348;
        Thu, 07 Oct 2021 23:43:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b142sm1430449pfb.5.2021.10.07.23.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 23:43:45 -0700 (PDT)
Message-ID: <615fe8a1.1c69fb81.b9994.4f67@mx.google.com>
Date:   Thu, 07 Oct 2021 23:43:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.14.10-44-gcee0088c496d
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.14
Subject: stable-rc/queue/5.14 baseline: 149 runs,
 2 regressions (v5.14.10-44-gcee0088c496d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 149 runs, 2 regressions (v5.14.10-44-gcee008=
8c496d)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
imx8mp-evk              | arm64 | lab-nxp    | gcc-8    | defconfig | 1    =
      =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-8    | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.10-44-gcee0088c496d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.10-44-gcee0088c496d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cee0088c496d5ca1ae56c0900f3af08adada5847 =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
imx8mp-evk              | arm64 | lab-nxp    | gcc-8    | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/615fb4969c96e7416599a2e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.10-=
44-gcee0088c496d/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.10-=
44-gcee0088c496d/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615fb4969c96e7416599a=
2e7
        failing since 3 days (last pass: v5.14.9-73-gb9d08ffadf94, first fa=
il: v5.14.9-172-gb2bc50ae5dd9) =

 =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-8    | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/615fb3ff209f404bec99a2dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.10-=
44-gcee0088c496d/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.10-=
44-gcee0088c496d/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615fb3ff209f404bec99a=
2dd
        new failure (last pass: v5.14.10-44-g08b40de697db) =

 =20
