Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0E6C427D16
	for <lists+stable@lfdr.de>; Sat,  9 Oct 2021 21:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbhJITWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Oct 2021 15:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbhJITWE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Oct 2021 15:22:04 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 885C4C061570
        for <stable@vger.kernel.org>; Sat,  9 Oct 2021 12:20:07 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id m14so11055870pfc.9
        for <stable@vger.kernel.org>; Sat, 09 Oct 2021 12:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YIdlmdMkOWWPJ+t8PFWAt/pJxYTFY38sO5MZHC9/UBw=;
        b=yIOC/oc8bChXPWuMzDPqCDSURMdNqxZUpm5nwYwy//0RmynjPHZjfNgOG5WS2IOUjz
         il8pfsLpYghGsx3w9GO7hzLMxSzQ5xjW+ogbzBxQdvoi05kB2JWEYRUFCrMjXdsy28MB
         Oi+WgQUmuyQl0QRg+KpP1tFmJ+AujGJ0vBPjPNn8747UtQUz++GmgPrQ8xPxLhV/jm9z
         JHRkmTN+mfE1pliD77elu9UJE7INtsZOGs8jKPrKnYmsFeYlKG08bLuiSfpdym5uk7Ur
         mzdIm+khvOFU0F9OjfYEo7dywmnblb1bpqGNaKDJGH5cMWcRzsQ9FyVFGhbgv1t57K2l
         YKKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YIdlmdMkOWWPJ+t8PFWAt/pJxYTFY38sO5MZHC9/UBw=;
        b=mzBwfvlrkH7lqmLeZPzWE5J+mFBHQ/hvDe2inkMaESVkO9sh+/j5LcjVTd6NzPRqt6
         kjbcXLHgEo906FZRNj9pnmWfqr2cR9rbXXjuMtpPc8EXaqTlnDzyQF9VtFN9X3Mx/057
         OK3o9aoI4WVA/XTsTTnqcdwtnJcFOlL30MdkQH3IAy+eRMrytlsu7lVHUdLQJ+BvOhuE
         Mw4ZmK1NaWw6t4CXWqFvDxOFYm3pmhHA2l0TZ2H2A1HtpagBdG3Z/bIf1qJI7nb8ltAW
         GCKpLVO285NU+qJD2YQDe++0yYImEjIbK51Z8FHoWu4/yf8bQNRxZpkUcOnW8OVi/38X
         zcLg==
X-Gm-Message-State: AOAM530wb2TinXJzkOnyN5q9wN6m4bpR/MVXKl97ledZKy+Gv5lWfX2J
        iaXBVKjKnlCwS3l6GGSubWIDne6G9FtkFPFw
X-Google-Smtp-Source: ABdhPJzggWOc8eRFrzjN9I8gjVd13syrJH+HJo+x/kL0dJjguUYJbi6S9nZuYZjlIvo9VxmrY3eHjw==
X-Received: by 2002:a63:b00e:: with SMTP id h14mr10879804pgf.135.1633807206577;
        Sat, 09 Oct 2021 12:20:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 197sm2873800pfv.6.2021.10.09.12.20.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 12:20:06 -0700 (PDT)
Message-ID: <6161eb66.1c69fb81.23652.82a9@mx.google.com>
Date:   Sat, 09 Oct 2021 12:20:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.14.11
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.14.y
Subject: stable/linux-5.14.y baseline: 139 runs, 3 regressions (v5.14.11)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.14.y baseline: 139 runs, 3 regressions (v5.14.11)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig  | 1          =

beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.14.y/kernel=
/v5.14.11/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.14.y
  Describe: v5.14.11
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      924356b31dcbb1d5a4a210d3614372fc4c27e6f3 =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6161b268610e42737f99a2df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.14.y/v5.14.11/a=
rm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.14.y/v5.14.11/a=
rm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6161b268610e42737f99a=
2e0
        failing since 2 days (last pass: v5.14.9, first fail: v5.14.10) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6161b59c15b9b99f1c99a2ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.14.y/v5.14.11/a=
rm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.14.y/v5.14.11/a=
rm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6161b59c15b9b99f1c99a=
2ed
        new failure (last pass: v5.14.10) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6161b19276d53b098999a348

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.14.y/v5.14.11/a=
rm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.14.y/v5.14.11/a=
rm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6161b19276d53b098999a=
349
        new failure (last pass: v5.14.10) =

 =20
