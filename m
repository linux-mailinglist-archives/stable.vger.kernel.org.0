Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD1149EF2F
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 01:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232344AbiA1AXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 19:23:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232332AbiA1AXF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 19:23:05 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDAFBC061714
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 16:23:05 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id h23so3759488pgk.11
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 16:23:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pQFWycMRZMJqoEL7Y7eyVYPtv28REs/HsKTa6ys3Uyw=;
        b=wdr4PUypV8cpwh9qu/B9azmQ8eHjUSEPI/MwV5hWb4tpZRN7L+aB7CKjb/fiHjfTvt
         nilF6OBviEuN2ReUWS5/r18UzV4enPAUiRY6nvYl7zLj3hq9EdMcBOoeoBOpkX8Jsia+
         QDdq3YJNGNjwFKo6WJmYz2Sp45YSqpinrlYl5ZkoDZl2MFh8V71cdsr5TgrGdGewf77l
         +aTgEEDfxavCPWRbfkHaTZV1ZnarXLnLuZR2/f/B79U+ImdqUDt35mRff0j+I/q4Gp+S
         yEMpPCItjRg3YOpXeacN9qnOnzqnNhreCvcCOUtYGMgzXxLPkohtWeofEp8VmPBqabtX
         qq8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pQFWycMRZMJqoEL7Y7eyVYPtv28REs/HsKTa6ys3Uyw=;
        b=xUXJPaXY19r8dX/L9fqNrJzaMFnyl3aLFU/MR/dIufhUl9/sVvYsdbeow2SUrqLb59
         QoRE5Wui6dtYN3bs+o9uQZ8tCoHX7NAHdVPiZphZLKqxKcDZo2KUNTAIANyqHfsgKZY3
         6r5qwKcM6qnMkJJ3CbyF1Yj9y6dU/AbrXtPtxvK3qb55jlD2ZzIZiNRcWDgw/4glzvlh
         WKu1NefHsfiIUYt35/VERDJr0QTQJZrAKhTgN+eIS5uqWXjTBOD2lt7KxJm8m9NvPRkL
         nnhRQSzitFDuvV5STgiepbGYuLiTE8U8Nzf2c9DOW052jDvdLMsg9A3uXVIblCUOjHjb
         Ndig==
X-Gm-Message-State: AOAM531hknj0IvGUtCbFqNuN6QT0a0WM96NwjTpxtd2VmwF9UupsyWvA
        +KSWTeJfUaWuLkm8Yhb5G26wYIPxZ5nzrlrFNEk=
X-Google-Smtp-Source: ABdhPJzgdmwg2n16J+xl53jqW2aryLn5Hh3LQVUalh8esPGOpsfmgQ8c+rWl5FTFEM/m6zs3K9MpDA==
X-Received: by 2002:a62:bd05:: with SMTP id a5mr5335888pff.5.1643329385081;
        Thu, 27 Jan 2022 16:23:05 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n3sm6462182pfu.84.2022.01.27.16.23.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 16:23:04 -0800 (PST)
Message-ID: <61f33768.1c69fb81.9c829.282b@mx.google.com>
Date:   Thu, 27 Jan 2022 16:23:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.300-2-g187d7c3b8ca09
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 125 runs,
 1 regressions (v4.4.300-2-g187d7c3b8ca09)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 125 runs, 1 regressions (v4.4.300-2-g187d7c=
3b8ca09)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.300-2-g187d7c3b8ca09/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.300-2-g187d7c3b8ca09
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      187d7c3b8ca09131c71f6dbb8c8761f7f809402c =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61f2fff8e6bd1d7f44abbd24

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.300=
-2-g187d7c3b8ca09/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.300=
-2-g187d7c3b8ca09/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f2fff8e6bd1d7=
f44abbd2a
        failing since 0 day (last pass: v4.4.299-115-g214b7b038f18, first f=
ail: v4.4.299-114-g37c6a274092f)
        2 lines

    2022-01-27T20:26:10.739627  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/115
    2022-01-27T20:26:10.748252  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
