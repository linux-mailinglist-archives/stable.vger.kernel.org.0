Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6FC2352EB
	for <lists+stable@lfdr.de>; Sat,  1 Aug 2020 17:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgHAPPS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Aug 2020 11:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbgHAPPR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Aug 2020 11:15:17 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC895C06174A
        for <stable@vger.kernel.org>; Sat,  1 Aug 2020 08:15:17 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id lx9so9138751pjb.2
        for <stable@vger.kernel.org>; Sat, 01 Aug 2020 08:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yI72fgoWVksvzjYyuamqoY5uq9PaHd9t1nVBs3h8NEY=;
        b=ew/8tG/D5eCaSMpRYHAIQynK1DKx2718S59oDKMSM2/6MiHjmoleqRnZByj22QoQ6q
         Ix+4u3DEvsS4d0ngUef682CtpeOFytdm4MqUqvitZznVbn6ihKToc0Dg1NjgMJLxAlWA
         dNM7Eu7WvuV8be4U1pAgcl+JyzJHgp2uK585vf5cyOl1SNzdg3vXqpFtW6macTUrzijL
         f1ylGSiJg9jn12HbTCPLfMm5tHPs5Zh0W3ER5qJFC/cAjaFf13C6BjAUsQ/N5WRbQsBR
         6htYJljBFM6ocV8iCtQgacLcMmnvYJPq6iy3MsLFNZ8uKo5587JLYUWIdUsWuiR+46yf
         azog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yI72fgoWVksvzjYyuamqoY5uq9PaHd9t1nVBs3h8NEY=;
        b=I+Wi23ziNhkW+EqhHnNtrxwPe/g9/RKKxVWOcdo4b37cboX++AljdZ9R8yQcPOdmR3
         KYv1+C18M53yl2RKzC5OT0sYZQtUVN/NmGYQoCd5Ijo7DEXzudqerMhtViGAxUgvayII
         A7ViyV8lL5nI7LvVBuRCMgvbSZUYpTzVXGfwv8dq3HnLI00bLWqJv5+zyE4E/ZuQGp3o
         2Tix3gVNgn3U685lwqDVRIAERCMriEL1ll1Wpt2muWl1TS8CJ5chbgYhIo9OSIJf8usC
         R6r7tL+dtP6aPovEr9JUlfD920lGX682b06l52vC+Ylx4uccAejKnWQ4CDIsOF1D0nkS
         bArA==
X-Gm-Message-State: AOAM533vMpkzwnTrydVeveQhvGyyVJD0/T1uwkgVUxoX51FYDhBvmWyJ
        SXaT0bgH5fsSv9zeLYOEjdawh2kvoNg=
X-Google-Smtp-Source: ABdhPJxm+QM53RLGnBAmXwRZUHs3NO58ZjIIDy2auRr/6GhDgAdIpXU2+Xf7bFOCAov8/7gYKpKqqg==
X-Received: by 2002:a17:90a:bc45:: with SMTP id t5mr8990326pjv.139.1596294916518;
        Sat, 01 Aug 2020 08:15:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x9sm14772836pfq.11.2020.08.01.08.15.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2020 08:15:15 -0700 (PDT)
Message-ID: <5f258703.1c69fb81.b8a54.2fbc@mx.google.com>
Date:   Sat, 01 Aug 2020 08:15:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.191
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 164 runs, 2 regressions (v4.14.191)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 164 runs, 2 regressions (v4.14.191)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =

meson-gxbb-p200       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.191/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.191
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7f2c5eb458b8855655a19c44cd0043f7f83c595f =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f254db8490b296dfc52c1bd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
91/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
91/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f254db8490b296dfc52c=
1be
      failing since 7 days (last pass: v4.14.188-126-g5b1e982af0f8, first f=
ail: v4.14.189) =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
meson-gxbb-p200       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f254eaed14cd4930a52c1d3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
91/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
91/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f254eaed14cd4930a52c=
1d4
      failing since 122 days (last pass: v4.14.172-114-g734382e2d26e, first=
 fail: v4.14.174-131-g234ce78cac23) =20
