Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA87B34D6CB
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 20:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbhC2SQQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 14:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231383AbhC2SQG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 14:16:06 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6537C061574
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 11:16:06 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id gb6so6429205pjb.0
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 11:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tsIiTzwXxlsBzK/M8aGNLQ56iQqls9rqDcANeQfkyHg=;
        b=CGNMLHMWQgyHWysMo0idsKY5VBjbmt0X9h8hs5E3VEFw4ijz1aP8lJMteKkGG/bKZ9
         uwb0t5asMuyUVxiWybGQtxX8XMSB/QjX0Xsn4eKYfOtjyE9d6ffCjDHpyJc7pAcxXXJ6
         Kfxb/FKR6SP5J2GYrAa8+rqa8mIQ3i2WGl5f6eXq8+/D30axvzhIZahVdNpws1fuH87b
         CvNMavXvp4cKWC0vmgrrFUj6QaSfMVcBULkgGZ6wmQXPMLzFRXQKemr+PLdMN30JvO6m
         R/ViFidHL+l5z9A5/REHXRbwas0p2Ij1zJ+nYE9mi1AMKBUmhJ4vDjo/Q+eUWTPndNel
         VGfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tsIiTzwXxlsBzK/M8aGNLQ56iQqls9rqDcANeQfkyHg=;
        b=rD8naPQ46IHy4c5fVvW1sd31o8HkHnlEtsmuORpFi5ig0AC9DciySxxEpNVSXkyUUm
         v9q2+jQwlV3fllaQYb3JzLXnA/dL9kg8jOFtkSgA/jAlqOFNxyyMOQ9e8HconU4Rj52A
         RkPy0rD3IpBNGDNedI2ycQDnhUy/wK2nktk1BuX94Uv9mNwOfMGgvAfF6aQ8tjqAHeBs
         tP1HZL9l3wm7nD4Y2fDLBnblzoMEu57chLgfSAV84ZumtMul0eN6oUfKXDJ2xNu9pAlJ
         KjN8P5EjJkK1J/dZ8p/7o/ovbcb4StYCMNaaZ7LFOzlS8MpADnLZxCACN+9aExfWgAjR
         yg+w==
X-Gm-Message-State: AOAM532t3i31D+4+4B329pzu4rPW8RhglQ91WEGeNAckCVnTYpIeCWi4
        odC5UPYxvZgzvwWnokjRM844YkZdUWT/npmb
X-Google-Smtp-Source: ABdhPJyAXndCEFs7ajC4Hrt/Gzxzhp2tlE/x6IkbFGfGh2nPSkDbKb2Rt4uhfi2+okN+sTtFPqXMgw==
X-Received: by 2002:a17:90a:de90:: with SMTP id n16mr422580pjv.10.1617041766201;
        Mon, 29 Mar 2021 11:16:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c24sm177913pjv.18.2021.03.29.11.16.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 11:16:05 -0700 (PDT)
Message-ID: <60621965.1c69fb81.de4c9.06b4@mx.google.com>
Date:   Mon, 29 Mar 2021 11:16:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.26-220-g8c8bcec351223
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 167 runs,
 1 regressions (v5.10.26-220-g8c8bcec351223)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 167 runs, 1 regressions (v5.10.26-220-g8c8=
bcec351223)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.26-220-g8c8bcec351223/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.26-220-g8c8bcec351223
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8c8bcec351223764ccc3ab7551540172989b5194 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6061e9c26fb218a4caaf02d9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.2=
6-220-g8c8bcec351223/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.2=
6-220-g8c8bcec351223/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6061e9c26fb218a4caaf0=
2da
        new failure (last pass: v5.10.26-91-gfa9a491e09c62) =

 =20
