Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3456049AC11
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 06:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240172AbiAYFze (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 00:55:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240515AbiAYFxc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 00:53:32 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ACDFC047CE0
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 20:11:47 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id a8so12826017pfa.6
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 20:11:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iNH8qiepSpEhc2w8QDvT19rzhl7foomtR3/loQQlDiE=;
        b=xD5iKT5tiwm78vV7UE3wlyKvSiFdKZ/48VaF0byAtUigVhHgT9tCWH8Dy0lIEJ83ut
         ggX8Nh+qJ42Eoh7pRX+UxVaKuboWgZ0VDRKDI8fKy5GyszKiNstYDDduLY+aHsrYsa78
         RQbpUissrDWKsVb6V3MUx9nfumxlWsKbr4OQ5cqwxM7N1OtK7bHTmFmGYgC6AVGfUu2L
         yAx++NRB5ItQrtsgCgEtfBx1ZgjvGk44c2eMCrGNJ+z9qUDe4W3MRpKkECFAoVFRZ78v
         BLbI83fLEuKKq6XBFFyUe+Jt96w8olaVdJFMAOwXIuu3uVURFPlFbj2GxuKvMESiN+GU
         hsOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iNH8qiepSpEhc2w8QDvT19rzhl7foomtR3/loQQlDiE=;
        b=B8/xz0bgJ0Ctcb91prhreRaJIuRxg+v0eWb/QNL652MAvJirq+YNx755jtxmAToEb6
         dBPcO3paqBFEEBmXocFMIS3aUWXwmpVaGgyIizyD0PevZUqWQQsv0rUt4O2EYaI8sjk/
         bC4OHsXJ+SIaEogkGDWsgTFut/Mxn2ILATTS7cOQDdkxUcKc21yb3EzELr3yTrb/BrWa
         5p2OVCqTBsi5qep/fn/y/PAYB3pQjoCgEc914aAmCB8JmU4xvQ3n6oEJrNl0nmRZMsBc
         JtJi0lA/lUk1VttYchdNvctMMmp4Pu07Td5RUDFgokuiH8cRMKE63oKDPDwkjCzt/WzW
         RiXg==
X-Gm-Message-State: AOAM5333Zm8BBNS5UQmu/2StnXwIiGGPlZ7ECtYCiVSEWE0HN8Ycjxsj
        4kQXIg9YhxbO6W9ogPjAe887fMO+8/BkyD/d
X-Google-Smtp-Source: ABdhPJyzyabznf8+GizvWN2iAXXy0PlUZgpsoKReO6N7z1/eIIPZQVA2zI8KaptKsJYjwyydS5KnQQ==
X-Received: by 2002:a63:f211:: with SMTP id v17mr7209326pgh.60.1643083906739;
        Mon, 24 Jan 2022 20:11:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k16sm4662022pgh.45.2022.01.24.20.11.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 20:11:46 -0800 (PST)
Message-ID: <61ef7882.1c69fb81.2d85e.c706@mx.google.com>
Date:   Mon, 24 Jan 2022 20:11:46 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.262-187-gb75a88cc2107
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 87 runs,
 1 regressions (v4.14.262-187-gb75a88cc2107)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 87 runs, 1 regressions (v4.14.262-187-gb75=
a88cc2107)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.262-187-gb75a88cc2107/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.262-187-gb75a88cc2107
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b75a88cc2107c6ec4bacef4c01c880b3c3ae9a18 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61ef3dc0b664ccfd85abbda0

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
62-187-gb75a88cc2107/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-=
panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
62-187-gb75a88cc2107/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-=
panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ef3dc0b664ccf=
d85abbda6
        failing since 10 days (last pass: v4.14.262, first fail: v4.14.262-=
9-gcd595a3cc321)
        2 lines

    2022-01-25T00:00:44.806711  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/97
    2022-01-25T00:00:44.815872  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
