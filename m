Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46528326721
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 19:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbhBZSvS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 13:51:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbhBZSvS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Feb 2021 13:51:18 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ACD8C061574
        for <stable@vger.kernel.org>; Fri, 26 Feb 2021 10:50:38 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id 17so5755305pli.10
        for <stable@vger.kernel.org>; Fri, 26 Feb 2021 10:50:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AD2NbCViHaBVE4bgEJBO6tvgrJUCWoATDWonxnybtTE=;
        b=S2L7o4w4wHSd5kdqHjQ+g12wGsnz7MszqtJgXZhsVi2BkcK8Iz7ZTeVXRJLSlt8Daf
         myjOE9lXheMrFpC/5BdH07g4krcsS9ZuKNy0Bnr5nRNKz4+/x6cmppORqHEEKYAs8oqA
         2WEX+rXRykRzXvQ6xuNu/qGf1htI9c2lLEn7EBqedONIAyvCYqmB4vNEW752j2xwxKpj
         +cxb0csCsplr8f1EmZLhVG6+wYgarDu7dgKeYS/+Y1x7iI4YA+XGx69lpD7u4W1ZAUL+
         ugA0dRGZu3AsP5SXAOJ/f9etoYINy6kzL2WFufvu45cbsoeWc3Fgdy+ueHV7VB56Nd1z
         i3fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AD2NbCViHaBVE4bgEJBO6tvgrJUCWoATDWonxnybtTE=;
        b=iBMeS+qG7YP0202aVfjvZVANOdYvs1Y5umByfQVoLNonh9eSlj9q6pxFD/GHqKDyL4
         foi12myMfe6+k4ozWuvrj3/lTTnRp98ajjg6GFjhDdobrV3URkG4RCqcFYgTlZgJhWbV
         Y7zEjcQTDv4YnsXP0QCQA2ApM+WYdKxA/pyed59SGAFDmJsnO006Ce4b88HoG02oHGvS
         z+HRhNHRtWzWesIEUzCBX2mMWs0Z+e2XSS/7VfySa5jGb3jjKSlqZl/jrCleqlv6gdVE
         hzi4+NfNajzaDH/VnraU0wOHbdS0wMQMmWOjbkqpXyNsVUZa+MOGrewUwa+8IQi1huYk
         AqkA==
X-Gm-Message-State: AOAM532evNRaDZhl/HPnspMS3JOMsiiPnnT8bCsSpK3bzo7bIm+YZr54
        g5TMU0pB3e1Le5QZA1u1L2O0Ur+QgvqYQA==
X-Google-Smtp-Source: ABdhPJzzdR+tIOt0Vf2yaYSWRguceRySJ+GzWqkyNRqj8DBvXPoIfQMSChn1wjaWKQo/YKXUWk7KQw==
X-Received: by 2002:a17:902:7c0d:b029:e2:e9cd:6280 with SMTP id x13-20020a1709027c0db02900e2e9cd6280mr4607861pll.22.1614365437446;
        Fri, 26 Feb 2021 10:50:37 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b18sm10025389pfb.197.2021.02.26.10.50.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 10:50:37 -0800 (PST)
Message-ID: <603942fd.1c69fb81.56d28.6d38@mx.google.com>
Date:   Fri, 26 Feb 2021 10:50:37 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.258
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 60 runs, 1 regressions (v4.9.258)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 60 runs, 1 regressions (v4.9.258)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig | regressi=
ons
-------------------+-------+--------------+----------+-----------+---------=
---
r8a7795-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.258/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.258
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5b1d078507bd33ebf6c2083fa363cf5832809c19 =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig | regressi=
ons
-------------------+-------+--------------+----------+-----------+---------=
---
r8a7795-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/60356e563493c7290eaddcbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.258=
/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.258=
/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60356e563493c7290eadd=
cbf
        failing since 97 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-79-gd3e70b39d31a) =

 =20
