Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97699489F8B
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 19:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241484AbiAJStw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 13:49:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240226AbiAJStw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 13:49:52 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD9F3C06173F
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 10:49:51 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id oa15so13730278pjb.4
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 10:49:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ePSxuSsWym48yzkf94DnWL3wcHSLTc1OgK17lu9MvKU=;
        b=k4oacTXa3c3D/zMI/TB7AwpNPVREpoS2Ut3OZBe2+IaKE1koLYbPtkv5Nw751xkgZd
         2SDmt6Q8tLkLhPY7bcciJI1Mxcuu1gzp+V8x8IfP4qBVG2GPeeB227erSKCns5/MY3KB
         xxzTo20FnKvzJ3kbFHgIN0CQHH3MY0J86KZf6j3LEBzbuRjpLwO8BzL6TolImRDvo8ZF
         3zukAAJ7bacrQYWC+uikPm5B6BpEy9wEZYL0JmD8RkabiS2PPkuGc+xAGbb3/Pi4ufXF
         WFypzoQ08T+3VT6fj5nRUj7xsRlEhKcJqZfpUnh1WUM01UJ96mbnkauGv+WsKOXCdPK7
         PQWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ePSxuSsWym48yzkf94DnWL3wcHSLTc1OgK17lu9MvKU=;
        b=gyAsIjqz93muUUhEGt5r2M6oOoGqB8nX6ibiNaRT8MICuw6Gry+NJx5XMrDeEwPDIu
         nIklnIsOcvDz9qOoUWZ7EhntXXjV1yXcwNwF4vbnJvk1uggUAgaU5/pzqbqYcrAhZuC8
         we+/ocCn5OXy6rTggV+oI0y+Va5bRKgBKld+ytuR/D+/rMUDHb0UiBeU77S38vkdUxoZ
         TVQyAkAkMiXXVEus/eVb78m5pDnMqYqoeGJmCza2YIRkpT2hvcNTAVAtFbV4o+yeNcDS
         XetI53VFOlbouYnYTidkQHG+Y+qC7Fz4ekgHAxEKQsm4oGBN7TsDy9/cVeuXAXBOuXWq
         6mPA==
X-Gm-Message-State: AOAM530QIrne8DRLla8d9Sfm5/bIfxEbsVb+oOzoEKbxx0q8QnHma/jE
        ieYVBoZFIM5GPPU5MyeW87TOnMdqWynbNcBz
X-Google-Smtp-Source: ABdhPJwcSNLPgfjQjD66alpL9FDv9X/zEQLpYXMAn6bx+74rq8Cz6KDwb5Sk+ycZabBvZhBWDkX/Bw==
X-Received: by 2002:a63:202:: with SMTP id 2mr953929pgc.204.1641840591264;
        Mon, 10 Jan 2022 10:49:51 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ip5sm526212pjb.0.2022.01.10.10.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 10:49:51 -0800 (PST)
Message-ID: <61dc7fcf.1c69fb81.2a7af.1a11@mx.google.com>
Date:   Mon, 10 Jan 2022 10:49:51 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.298-15-g039b69cc9b15
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 115 runs,
 2 regressions (v4.4.298-15-g039b69cc9b15)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 115 runs, 2 regressions (v4.4.298-15-g039b6=
9cc9b15)

Regressions Summary
-------------------

platform         | arch | lab           | compiler | defconfig           | =
regressions
-----------------+------+---------------+----------+---------------------+-=
-----------
beaglebone-black | arm  | lab-cip       | gcc-10   | omap2plus_defconfig | =
1          =

panda            | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.298-15-g039b69cc9b15/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.298-15-g039b69cc9b15
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      039b69cc9b1536ea691fb3f09f95f82e60cf96db =



Test Regressions
---------------- =



platform         | arch | lab           | compiler | defconfig           | =
regressions
-----------------+------+---------------+----------+---------------------+-=
-----------
beaglebone-black | arm  | lab-cip       | gcc-10   | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/61dc4e0ff66e0bc952ef6757

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.298=
-15-g039b69cc9b15/arm/omap2plus_defconfig/gcc-10/lab-cip/baseline-beaglebon=
e-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.298=
-15-g039b69cc9b15/arm/omap2plus_defconfig/gcc-10/lab-cip/baseline-beaglebon=
e-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61dc4e0ff66e0bc952ef6=
758
        new failure (last pass: v4.4.298-15-g73006be3a625) =

 =



platform         | arch | lab           | compiler | defconfig           | =
regressions
-----------------+------+---------------+----------+---------------------+-=
-----------
panda            | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/61dc4ca1196ec827b5ef6783

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.298=
-15-g039b69cc9b15/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.298=
-15-g039b69cc9b15/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61dc4ca1196ec82=
7b5ef6786
        failing since 11 days (last pass: v4.4.296-18-gea28db322a98, first =
fail: v4.4.297)
        2 lines

    2022-01-10T15:11:20.383350  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/114
    2022-01-10T15:11:20.392448  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
