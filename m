Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A42DE383BD8
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 20:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236792AbhEQSEl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 14:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236683AbhEQSEk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 14:04:40 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D62C061573
        for <stable@vger.kernel.org>; Mon, 17 May 2021 11:03:23 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id t11so4140646pjm.0
        for <stable@vger.kernel.org>; Mon, 17 May 2021 11:03:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=d+RbHa5VSR3B5WWhHiOevyuRhThfTTAB186MdYQewkI=;
        b=IzBd6G1mURXIBqoG4CIYJBhQ8k+oGIWNcotisilAs7g8kGPSFZTW6jK09qIYhmEBqp
         VWuc9AUBcJgIWlxV0/bnQ+QqdW9qmoV9632JCxrzAkdttKhIV4qMAPZ7rc1HpjzS/PsV
         rAZ5PZuSNeopV1AhZd/fmT79YNP0882t+UG5JUYPQxDevB74i7yfUvLY1ZxCp45RBbpF
         Z1RCq7KSR+IOQU+lDjBSuNnvJXL6kry59WpwD0UaXNeFhlQcuPYwwqOu9wyxmNBxLDA1
         l7jcdshxEZXbGLoOwNR4ZFNxu/8sgB+6Jx5zr3PtzokiGJySN5MPk/UQqAssBzjzf1uF
         B8yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=d+RbHa5VSR3B5WWhHiOevyuRhThfTTAB186MdYQewkI=;
        b=SzF48fDFxLKB6soOmBC6JkvLbiQ4x3U3dQ/LTRiNog9JD8xIFD+8EcnObNbDkMVq+v
         5+Zt+XOYPyttzbol57UqutXNZ0YWohKKUWhj6Gn1Iyn4U0N4ZXhx2HS35v2G/98l/02J
         lLGoRAKaOoroZV8MDSeFUaP7XK9pd/HEsUexteN6EgJTU4EhJAhot+0nqvZnhp2RWH5A
         abtV6Ww6xAn0DNq+mPpsht3ne4cAfuPfBbrvGTtxiyIhT72E6BBaquV6llVynkzkyrg+
         tDtz7xcWz6cZ6D7Lxj7zrd+RwKxugldSfRVTzd7MQI1he5dx2dAe+VurJ4j0qM+gqPNu
         IyNQ==
X-Gm-Message-State: AOAM5337GjxUFiQijhjce8ROGRiFWHqH6Ld7VXnHicHmS5PkFqegGaTw
        dQajLgTgG6hQ7l+qT4nthdqG1WXYMYpLJYMr
X-Google-Smtp-Source: ABdhPJyDYhxcLPaTb8yKtzithx2NISh0yith47d8siyOTNhoFaNYezVNaDSOcQMBxsiaCoGTAxJ+bQ==
X-Received: by 2002:a17:902:229:b029:ef:6107:188d with SMTP id 38-20020a1709020229b02900ef6107188dmr1303199plc.41.1621274603249;
        Mon, 17 May 2021 11:03:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b15sm10394656pfi.100.2021.05.17.11.03.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 11:03:22 -0700 (PDT)
Message-ID: <60a2afea.1c69fb81.2f1ae.2fd2@mx.google.com>
Date:   Mon, 17 May 2021 11:03:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.37-277-g938ce446b555
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 133 runs,
 1 regressions (v5.10.37-277-g938ce446b555)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 133 runs, 1 regressions (v5.10.37-277-g938=
ce446b555)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.37-277-g938ce446b555/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.37-277-g938ce446b555
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      938ce446b5557c4bf15350d99c9866bbbaa74e20 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a27e6afdac167b3eb3afb6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.3=
7-277-g938ce446b555/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.3=
7-277-g938ce446b555/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a27e6afdac167b3eb3a=
fb7
        new failure (last pass: v5.10.37-240-gb8f335cf282d) =

 =20
