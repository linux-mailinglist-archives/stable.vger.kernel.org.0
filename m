Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08FA23FDDCE
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 16:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234037AbhIAOae (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 10:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233814AbhIAOae (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Sep 2021 10:30:34 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDEFDC061575
        for <stable@vger.kernel.org>; Wed,  1 Sep 2021 07:29:37 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id w7so2931935pgk.13
        for <stable@vger.kernel.org>; Wed, 01 Sep 2021 07:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ABcNqrfQuGoMGIQx12NXQy3UDmNrlMuWVZJymmZpwqs=;
        b=1DA5cCYNifNcOOH5Y6+GvelCNlrIrZyMQnssugbhqGTx64zh3/a6aX9WWu0+puqDyn
         arkOBoOtyxsxWGY5gr4lBvPMid4nXYeBnNY7tEmgYK9wp5TM9AWzialkJSQo1yJz1suc
         s+rBdS1rZrPAYrgq9IyTwP2QAhCqoxVo8oKMD6TKHKujXfLWrTrkULDnS1684zxPOQLj
         bfkXrZhQYTdmlw/Y32yqFnuWIMBGctwDomnGS2FIcHXC4s8wu0duTJRambrlJEkVimxS
         2usLYrVIvE0iBD2b5Usi3SCn/RcAOyqPjhN/7QxJ3cboVVPUX9KzNu9f1AXfhmzPommj
         q+fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ABcNqrfQuGoMGIQx12NXQy3UDmNrlMuWVZJymmZpwqs=;
        b=TaRj1HVlN2UWpBiom1iidczicsrGrfTpwzVtukLWNFCKbtjtnGR7ihN8XGnzzciuZW
         q6okcM+mxTs2QWIrR43eo8kpn6IsN/TsvMmAWxFuQzCYoutS5MgEbybvRC8RZkUl//dO
         0sV0RFFHTkwrPYXfY0mkgwj8bfcckocDaEzjrKOXcfH9o6rr6r60kmm7lY5xLeCbfhNR
         Gh4pL4KImuAgRYYNAIoNcDif9sM3sfA4Zp54uoKJO9s+R+Q14s3xjflfQO+V43sTmAYI
         SQ83lQMNvU2AMnTb7lxd4ksKvSR8TcLu46WHt7U9nP0+nasu0fxFeiCUaqfUMYsC4pUT
         R7FQ==
X-Gm-Message-State: AOAM530ldsT5MrdvGD9ALAQRNneE/Lzh4YIAYQBgExiEtQ25cIkpIsgG
        ydVqlKjka3SynG+UeTLUNAdIFj0h9rQ5DvhO
X-Google-Smtp-Source: ABdhPJxNWJKaNWUWfNACa/E95zeNZIIcIBzG1xV3gTiUNdYw0micad2LGL3IKWLJxmZnHP3ofNlBfA==
X-Received: by 2002:aa7:999c:0:b0:3f2:8100:79c2 with SMTP id k28-20020aa7999c000000b003f2810079c2mr28948292pfh.80.1630506576988;
        Wed, 01 Sep 2021 07:29:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 21sm170113pfh.103.2021.09.01.07.29.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 07:29:36 -0700 (PDT)
Message-ID: <612f8e50.1c69fb81.48258.0708@mx.google.com>
Date:   Wed, 01 Sep 2021 07:29:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.13.13-102-gb80430d7822b
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.13
Subject: stable-rc/queue/5.13 baseline: 152 runs,
 3 regressions (v5.13.13-102-gb80430d7822b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 152 runs, 3 regressions (v5.13.13-102-gb8043=
0d7822b)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig           | r=
egressions
----------------+-------+--------------+----------+---------------------+--=
----------
beagle-xm       | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1=
          =

beagle-xm       | arm   | lab-baylibre | gcc-8    | omap2plus_defconfig | 1=
          =

fsl-ls1043a-rdb | arm64 | lab-nxp      | gcc-8    | defconfig           | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.13-102-gb80430d7822b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.13-102-gb80430d7822b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b80430d7822b1cf0b1945288a8f51de4fc406653 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig           | r=
egressions
----------------+-------+--------------+----------+---------------------+--=
----------
beagle-xm       | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1=
          =


  Details:     https://kernelci.org/test/plan/id/612f5bec51279071068e2c7c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
102-gb80430d7822b/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
102-gb80430d7822b/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612f5bec51279071068e2=
c7d
        failing since 1 day (last pass: v5.13.13-73-g193ded4206f9, first fa=
il: v5.13.13-97-g4abdf2bb4e76) =

 =



platform        | arch  | lab          | compiler | defconfig           | r=
egressions
----------------+-------+--------------+----------+---------------------+--=
----------
beagle-xm       | arm   | lab-baylibre | gcc-8    | omap2plus_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/612f5a1f5d0b144ad98e2c97

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
102-gb80430d7822b/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
102-gb80430d7822b/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612f5a1f5d0b144ad98e2=
c98
        failing since 34 days (last pass: v5.13.5-224-g078d5e3a85db, first =
fail: v5.13.5-223-g3a7649e5ffb5) =

 =



platform        | arch  | lab          | compiler | defconfig           | r=
egressions
----------------+-------+--------------+----------+---------------------+--=
----------
fsl-ls1043a-rdb | arm64 | lab-nxp      | gcc-8    | defconfig           | 1=
          =


  Details:     https://kernelci.org/test/plan/id/612f5ff25939cfb9658e2c88

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
102-gb80430d7822b/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls1043a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
102-gb80430d7822b/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls1043a-rdb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612f5ff25939cfb9658e2=
c89
        new failure (last pass: v5.13.13-34-gaac007a8336e) =

 =20
