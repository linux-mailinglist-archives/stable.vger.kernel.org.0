Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E658B280BF8
	for <lists+stable@lfdr.de>; Fri,  2 Oct 2020 03:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733260AbgJBBcn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Oct 2020 21:32:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727780AbgJBBcm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Oct 2020 21:32:42 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB1CC0613D0
        for <stable@vger.kernel.org>; Thu,  1 Oct 2020 18:32:42 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id o25so429873pgm.0
        for <stable@vger.kernel.org>; Thu, 01 Oct 2020 18:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZQjVdZ6RC/77md69jO0mviEAQ+AwA9iz9K6sfDoeJys=;
        b=G+tKk8yA75LEPDcCQRAp57K43FbUBvuK2cNS0YmGloccN4NtQdU2nKh1ZLes8Asdmh
         OBAVykyQ+b2yns4tOaoBXNv4A6oSPrboQ8zjGL6osE7lVKvxCU12qJEcd+z6kf6gYaRI
         O1nQplfaWML3ojibK8wFvZ+LhqeNiJYjmYhJFZ3RxLqdjXJJXGGA0jwoT/W0uY/hXNRN
         czHkjZkNDuobPW5nFFktfP/VxwnUMRkZQErv4LOS25pZyhn6vs0UtXW9iplwk9/Xlcdz
         IC/1ltOR5OGXLlsOds3DJfXkJ2u/Lz+xg7y0NGQ7p0KkYsGC8o6ynhakP2h2iYATl/OF
         pZBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZQjVdZ6RC/77md69jO0mviEAQ+AwA9iz9K6sfDoeJys=;
        b=SUQK9SBVeAjeoQo3hfqymoycUn+vkfRMrPvoBvDQgnCj+OG4G4su3CpePTsnDIWAXY
         Y8Q8MbiZdzNl4qxLUTT3RDO46WmCVUBE744EBkXbcrui4DNKMdNycmhIyJOhLrF6XSMY
         te2+mtxB2nSiufpVp6IkQ4TyMhIu+ZgC/vbhfpzs5Q5c6fQO1IuC+O/s+zacqsz22WGe
         Pn6J3PYAg/nC9tpNBUkX0UWJTAgJBmohJle4MppGySKs/Behd6839VTPcF6Nwmy/CYcz
         Qk5JxGoqQ8kD521GKgWiw2VSkmmTqt5G7SKT/Tzj7S1HstmhLiwvQ44zal4UwO8J+Ec1
         Vx1Q==
X-Gm-Message-State: AOAM532n6UbM0azgI3Vn6PVicdGR19nR1DtYwsDmoOjFMc6W3FVjWTwB
        9Rt3Bm5Zl9QVMUtyV9xXfdHGeazB05l2/w==
X-Google-Smtp-Source: ABdhPJz+NT/wYiFwz5dllYn9/lq4OHt6olhSF0TdgGOOuVdSj5fMWsftp76Kkkk/vtqtdwaKWsJ7Lw==
X-Received: by 2002:a65:4c8a:: with SMTP id m10mr8130859pgt.403.1601602361999;
        Thu, 01 Oct 2020 18:32:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z9sm7961599pfk.118.2020.10.01.18.32.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 18:32:41 -0700 (PDT)
Message-ID: <5f768339.1c69fb81.72a2b.1671@mx.google.com>
Date:   Thu, 01 Oct 2020 18:32:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.238
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.9.y baseline: 62 runs, 1 regressions (v4.9.238)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y baseline: 62 runs, 1 regressions (v4.9.238)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.9.y/kernel/=
v4.9.238/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.9.y
  Describe: v4.9.238
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      716527d016c783b7bde0896b641c342c08809703 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:     https://kernelci.org/test/plan/id/5f764915ce6fc7eb46877198

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.238/ar=
m/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.238/ar=
m/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-2-g61393d279614/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f764915ce6fc7e=
b4687719f
      new failure (last pass: v4.9.237)
      2 lines  =20
