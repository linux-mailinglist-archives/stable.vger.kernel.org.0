Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9FB273A9C
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 08:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729217AbgIVGRe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 02:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727027AbgIVGRe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Sep 2020 02:17:34 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A602C061755
        for <stable@vger.kernel.org>; Mon, 21 Sep 2020 23:17:34 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 7so11072927pgm.11
        for <stable@vger.kernel.org>; Mon, 21 Sep 2020 23:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=I9g2pDEXc7kzjMKz54IbzXE9oTaxnd/XJJCByzjQfAs=;
        b=D9sWoFgWx/1FBOEFZsf7mIekrCyqJIAUf7LeKnLblnlKGCRcX/L5NxUs4i2GjTqv1L
         wXvGbXpqAhkAP7XfADsCaf1tvxvYFG4v6Jgg9gHZ4YGhk0bM4kEbc52u7esr0hAuLujk
         kdoQe+y0nIVNHxT33Umdy1DFFH4pktP8TDMZr3kuxgtcRlc6SgioRLdS6otcwltKx00f
         ycifHvIqwdXXmPnUukTD/J+2CBg5AwgwybprHUcqAUjN4yQqEdXcwCSodiTlQwFdSC8O
         nWSRE8MRmzWRseM0tnCn08wg+u/RjYaCOMNrkf/DDl9Jf/MN0ehrSvNaPnRYYPlhuO7K
         dsoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=I9g2pDEXc7kzjMKz54IbzXE9oTaxnd/XJJCByzjQfAs=;
        b=cS8uwqqHBUIVUylUoSeEzdF/dTX4AbNDwj5zoGkDB3DPph+v1/dzG26g4ovTYY3X2+
         N27R6X2k4EcRVaL0QDWaRy6fXIE3zKgfeDbI9vlWykiVt607Q/6aZxF1S6a1EuaHAq1T
         c+X5i7BOUylHgEf+jZjZ0SrUgdI5spaHyjdW7weNgrT9yOahC+qyxZnBPs3FIw6XVfEu
         OECYgzQ6b2kurGKrYnKknyIea/hjPxFJPYX9F2zFSBQ+WlFYTLU6QlIgnxFLmwGtdsTx
         CU2NiiDljivRlMc+2QOIb8vRPZP2LiEbqLoqdRbNe1+mAMcioBylajd3Eo9I4UY1bfnI
         OQtw==
X-Gm-Message-State: AOAM533z0C4s5guqNDZ212ru/qG4I1B/JX2PoqUWzCz1g13ryv26PJRj
        9g5Cje4K/OKAJhhKjlO9FBPxE3SQ6UNLtg==
X-Google-Smtp-Source: ABdhPJzno1O2GcueBVA2KbFb/cGNtZe1xw1jCeHUjqN+FpWX/kLeUpbz4a6/1G1S5ib7J2QlIW3sEA==
X-Received: by 2002:a17:902:8e85:b029:d2:42a6:bb6 with SMTP id bg5-20020a1709028e85b02900d242a60bb6mr799541plb.72.1600755453527;
        Mon, 21 Sep 2020 23:17:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g23sm1146334pjz.51.2020.09.21.23.17.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 23:17:32 -0700 (PDT)
Message-ID: <5f6996fc.1c69fb81.c9530.3f1c@mx.google.com>
Date:   Mon, 21 Sep 2020 23:17:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.145-129-g20031549a4cc
Subject: stable-rc/linux-4.19.y baseline: 161 runs,
 1 regressions (v4.19.145-129-g20031549a4cc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 161 runs, 1 regressions (v4.19.145-129-g20=
031549a4cc)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.145-129-g20031549a4cc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.145-129-g20031549a4cc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      20031549a4cc9e0c3576a84631ce04afddf88f07 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5f69642f9348ee0c2fbf9dc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
45-129-g20031549a4cc/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-s=
ama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
45-129-g20031549a4cc/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-s=
ama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f69642f9348ee0c2fbf9=
dc3
      failing since 97 days (last pass: v4.19.126-55-gf6c346f2d42d, first f=
ail: v4.19.126-113-gd694d4388e88)  =20
