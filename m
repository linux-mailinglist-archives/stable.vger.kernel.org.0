Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ACA1221939
	for <lists+stable@lfdr.de>; Thu, 16 Jul 2020 03:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbgGPBCF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 21:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726479AbgGPBCF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jul 2020 21:02:05 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1B8BC061755
        for <stable@vger.kernel.org>; Wed, 15 Jul 2020 18:02:04 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id l63so3960656pge.12
        for <stable@vger.kernel.org>; Wed, 15 Jul 2020 18:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fkiKPT2POriAf7HJMZZ9tir5HHECWKm5q0n+n3Cgu14=;
        b=1K7Pddyo3sxnAlUwyX+R0J/w+zehwxGHI08jcd24rUkeIF7kZ4Q56UyNRStONW8UVJ
         WSMwLbwlDZUguTaZu82HFNhRaX3lJQAmp4h1g9GVZjGdhMa3cR8V7f1Fr0qgZGQN8gnc
         x0eYkZqK1y6tesTrVfXZ8CGMdn2rUiD7RWUZPjm8heO20P/3BonsoQJDXfjf+vIgUTyq
         hTkrWTFD3BGoHjG3c1doPMYacOBebGnHQqF9w7eGt/yXDtmy284Y9pO0EkQF23dK01ir
         tcl8EaqpenwCxJ+IIHoUMdtBMlnr8QDi4TIQxD+YpDtiBCxKkU4Yd/VSglDC+9R+Bj94
         CpRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fkiKPT2POriAf7HJMZZ9tir5HHECWKm5q0n+n3Cgu14=;
        b=CjYdlRcPYEcEhUXu3LY5siWys55y+t5+zvY5ZuiN7NPQaIKeoGXvlxTFbWainxwqo3
         aIb0+KekRmGS7JZjNGza/tle1R/9Xs6m9ZTXEvSs7bXqcyIkwTqmJVNYRPe5iVku592p
         MOh98fdQCG7hNBB80G2ogT22MarQvDxJM/J0r2Gf2gB0OIClSXrXMsolLTxC3P80Ol6L
         YJcFTrwbxeCdx3JP4MK8skt7lwQSLQJEAbcon+LXjD6K4YjoHC0CimtjStP+qgutOn6g
         oeQHz9KNW438HcDzmrGx/g/Y/qZtCpKBLfOOwHzxGOyfg2HyLKYdqJVIwcuo6NpjM+nj
         Uzig==
X-Gm-Message-State: AOAM532WWLFDkKrX5fOZiAGKyNnO6Tc7ma3u6OFaXU8jhvstHF+nVrV6
        GSkT7FU0HGyRVwWjL1OeHne+vxoZ+Oo=
X-Google-Smtp-Source: ABdhPJzXOCJFPxdzJoirfewlMzJIO3/a4Wt4SbPV37daCBU5XajqIUiVShZ573GoZFtl5UmOWQzloQ==
X-Received: by 2002:a62:7a56:: with SMTP id v83mr1592934pfc.114.1594861323998;
        Wed, 15 Jul 2020 18:02:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w20sm3045331pfn.44.2020.07.15.18.02.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 18:02:03 -0700 (PDT)
Message-ID: <5f0fa70b.1c69fb81.b1201.8fc4@mx.google.com>
Date:   Wed, 15 Jul 2020 18:02:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.51-111-ga4b36fa05420
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 90 runs,
 1 regressions (v5.4.51-111-ga4b36fa05420)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 90 runs, 1 regressions (v5.4.51-111-ga4b36f=
a05420)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.51-111-ga4b36fa05420/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.51-111-ga4b36fa05420
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a4b36fa0542081247babc8a62b4857a5a78c8e3b =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5f0f711d564839084485bb43

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.51-=
111-ga4b36fa05420/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.51-=
111-ga4b36fa05420/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f0f711d564839084485b=
b44
      failing since 95 days (last pass: v5.4.30-54-g6f04e8ca5355, first fai=
l: v5.4.30-81-gf163418797b9) =20
