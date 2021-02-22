Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF06321FE2
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 20:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232820AbhBVTQw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 14:16:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232760AbhBVTOp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 14:14:45 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A9CAC061574
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 11:14:25 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id l18so207888pji.3
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 11:14:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=e6HVbn2W8CgCRCDmkOYPfPkaDO0dng0++02xiYcAemw=;
        b=IX+leDpQHdM19NIZx5IfzQLjiVxQKK95qa33rD5WipyKIrb/qFZYiUMg3Y59WqANP3
         YEu2rwksqHkho1PNmu+vIITv1BmbaoE7M0LK0XSQ9HBLG3xRnfmEI0LjzryrevQo+gIg
         NV4+9hLKZgHCq0qrKrXqUHenYjksUeVQIzstdCLoTqKtTMnHZiFSTvt0zgRz6cxaly1K
         DA5hOZtr2ppCXF7BYLE+mu9VIxZuhPG8jAQJKrqn3Niuv8MyQLVSRG+kdYnwCkAPvZuo
         YeaZxTFcalhTSuyDnXCXoiQe+lDMq1XdupKAGoYZsAUAcHpEx0SLKhyak41WWJ372xhf
         xUqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=e6HVbn2W8CgCRCDmkOYPfPkaDO0dng0++02xiYcAemw=;
        b=mXzt3CFHPuuk0fSCZWj+2WKyOm+JtjPd65CWeF45y0AGONGWTypTLfQmQ0BtSH9k9F
         SWcXyfYtrO5T56XA2JkUw4n9s781Z5iafrEH2dYEuozeZbj2+4jc2RDQFeeFMqS3IFtn
         sqpXxQCadAvSbGffcgnGGacw3+WrnfGL0ixO9mabggqU+WLUhpZx4SOpF6DPLiasYdeC
         7We62m8dViUFfK91zwlvDeTc9I1l+2Igm5miZR7EVLT2hknAQMbdNoR8FS2UAzFlyTZ5
         xJgV6L3jz71Ud8d/oCPX5r5Yd3xgneTe+Pn3Lyv/TzLQyapsCwH/Ga5zxtbWZcQSjdrk
         1Vyg==
X-Gm-Message-State: AOAM53115hu/wXGU+WS0Ja9VJVoN0aiQnZxN8rrVQJfY1+nruXrRNXxt
        jsoRw+CyV+yVOupVtVh1ui2uW7XNtx3Lzw==
X-Google-Smtp-Source: ABdhPJwTB5VjZ0dTccLLvCSmELB4Tft820CfwCiSFYTdVQcepYbTHbvPIhc+ULtAR0/sreNS5aL8iA==
X-Received: by 2002:a17:902:a60e:b029:e3:fb88:9b3c with SMTP id u14-20020a170902a60eb02900e3fb889b3cmr5367615plq.45.1614021264350;
        Mon, 22 Feb 2021 11:14:24 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u15sm19803548pfm.130.2021.02.22.11.14.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 11:14:23 -0800 (PST)
Message-ID: <6034028f.1c69fb81.2f7e6.a83b@mx.google.com>
Date:   Mon, 22 Feb 2021 11:14:23 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.257-49-gb69eb53e0f27e
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 51 runs,
 1 regressions (v4.9.257-49-gb69eb53e0f27e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 51 runs, 1 regressions (v4.9.257-49-gb69eb53e=
0f27e)

Regressions Summary
-------------------

platform             | arch | lab        | compiler | defconfig          | =
regressions
---------------------+------+------------+----------+--------------------+-=
-----------
sun8i-h3-orangepi-pc | arm  | lab-clabbe | gcc-8    | multi_v7_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.257-49-gb69eb53e0f27e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.257-49-gb69eb53e0f27e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b69eb53e0f27e89ff04246cfa74368acba53a34a =



Test Regressions
---------------- =



platform             | arch | lab        | compiler | defconfig          | =
regressions
---------------------+------+------------+----------+--------------------+-=
-----------
sun8i-h3-orangepi-pc | arm  | lab-clabbe | gcc-8    | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/6033d2f545ae0a3244addcb8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.257-4=
9-gb69eb53e0f27e/arm/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun8i-h3-=
orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.257-4=
9-gb69eb53e0f27e/arm/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun8i-h3-=
orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6033d2f545ae0a3244add=
cb9
        new failure (last pass: v4.9.257-49-ge7fd2353eaf6c) =

 =20
