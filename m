Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC493A442B
	for <lists+stable@lfdr.de>; Fri, 11 Jun 2021 16:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231535AbhFKOiP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Jun 2021 10:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbhFKOiO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Jun 2021 10:38:14 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8D91C0617AF
        for <stable@vger.kernel.org>; Fri, 11 Jun 2021 07:36:01 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id o10-20020a17090aac0ab029016e92770073so160194pjq.5
        for <stable@vger.kernel.org>; Fri, 11 Jun 2021 07:36:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Dnxgw57Cd3Vq8bD04Zr6+vuwl4WvqGq4Oz5oevdWRg8=;
        b=JieXbi0RICu0zOVn3khQInagV0tRWe1ngrWldTHU3AwdNg76Cqd9WtyiD8rhxbTGdr
         OJKFKp8QdB2sWZhySoxz172FLGc0QWqwk8vPSLeBgUcpRPxJ/rSejiQhReUzm++0vnc9
         aHVfOPY/65/zC8DmCIqe3x5NkS/xfdkOFgmvRdUGQPm5EEjI5IgduBeKwcHZQSZmqJlr
         ZWYlotQPRWMXJ93neASpbdobDDCVnC0t498emEVzLDmh46fkXsS7hrDRMyjc9n8hXu7r
         u7ZcYj26fK11R/8KDKvn4ToU4QLGJYkX68Q+1kns7XOg8ySfxd1AhKQWHlurGULOGtRg
         i59A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Dnxgw57Cd3Vq8bD04Zr6+vuwl4WvqGq4Oz5oevdWRg8=;
        b=h7AhFv2Q6j8dDlbhQ+46J23x4CCq4mMo+iPYnfyNmBWrF6lo2H7jUk0DmpI9NdTpK6
         DwHIY8AWhJh/JYVPIOHacA2em3HyJrw8IueJG1rNu7dYxYRN1GWXrDwKTzfR54ePaXTv
         5vwZ1rBkWK/q0FBK3Rzfbu7AdhqFH0oEbfPd0pOSJ1uxV4kr90f316ghxIIVCTj4i6go
         U8ay5wJhSm3WXQNN7F0JF/VF5vF0AsR1vjM1sz3PIv1M86IB8gnxZCUIimKYepmbEJWJ
         5EFb9ryX2eeVyMlwk8DJdSehvzKP9UT6UXT2h1wh/wRyLvgQockbDEyi+86D0c9pjmRH
         B2hw==
X-Gm-Message-State: AOAM532z7byHNvWw6XNlWWa+uwLfSpArynh+eiQ7Aiy8cofnodL8eyoR
        t6Gny26wTGRudaB+nNGF6Ucr6UJnkX5Ux+m1
X-Google-Smtp-Source: ABdhPJxaHFQ0mC8TpLpdn84QRd5N/FC3GUWcy3cN2qc7GFZtwsEI/y5/EZWh3MRFTnA2WrDZS8fKXg==
X-Received: by 2002:a17:90b:b18:: with SMTP id bf24mr4818353pjb.220.1623422161188;
        Fri, 11 Jun 2021 07:36:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y5sm5649115pfo.25.2021.06.11.07.36.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 07:36:00 -0700 (PDT)
Message-ID: <60c374d0.1c69fb81.a3727.0a06@mx.google.com>
Date:   Fri, 11 Jun 2021 07:36:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.12.10-48-ge647b3c62a13
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.12
Subject: stable-rc/queue/5.12 baseline: 191 runs,
 1 regressions (v5.12.10-48-ge647b3c62a13)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 191 runs, 1 regressions (v5.12.10-48-ge647b3=
c62a13)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.10-48-ge647b3c62a13/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.10-48-ge647b3c62a13
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e647b3c62a136fb152ee168e06bfd772705f9f02 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c3459787483b4bbc0c0e30

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.10-=
48-ge647b3c62a13/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.10-=
48-ge647b3c62a13/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c3459787483b4bbc0c0=
e31
        new failure (last pass: v5.12.10-48-gb06b6d506b83) =

 =20
