Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83A202AED82
	for <lists+stable@lfdr.de>; Wed, 11 Nov 2020 10:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726644AbgKKJZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Nov 2020 04:25:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725986AbgKKJZJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Nov 2020 04:25:09 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FE5DC0613D1
        for <stable@vger.kernel.org>; Wed, 11 Nov 2020 01:25:08 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id g19so365928pji.0
        for <stable@vger.kernel.org>; Wed, 11 Nov 2020 01:25:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=imUgfMINLIJH5znrC03eyqQj5AEx9MB0+kF1jC2F/PI=;
        b=dPUZhoE0WMfF5VTUZE5GegjvS+jTm5XVN49dkI+S32sUsNvSyH7siSoJMIuN3CfDj4
         FxuSPjDcDyVc2CabuZ8fA34ciWzMOjhgOFDbEfvhPhWi0txihKOwmoxw2DWGs7bNb1cg
         VpJQOe3VlNtUyPDuUx8s3qrHlQx4UV5TL9yUPFrwyhHwcUgj6RIydj4XTXCd1WlKVAbC
         WmSwejNBxMZvMjOS0k39Tn83et9sboyXKgcd2zKQhHqIkt2DVDRbrBFVme6qEezoQACA
         R4xp/p3cBL4G17pOinSj14p7lcDNwMI1WN9DgjSMcuLsJomZG7NBoi2bpvD0qrKLG4eR
         SaYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=imUgfMINLIJH5znrC03eyqQj5AEx9MB0+kF1jC2F/PI=;
        b=bK05tGpSlBICXeGi8eQeRYw5r1Fqiyl/4grkBzSvpAVdsDaQR02XgWUY/Wuw9saw7x
         Bz8QHM4xeDQUsxjEu2kDuzsRmrvsUXbJNekne3uqvmZgUtpfz2Q7WdBGKqZzoLwIFr1O
         1OcsgcUSTAx4XuOcdKWNgA7CF20BnXjgaF+hFWFsDX5y7WmpWutdjh7sqI9NZNB0SrKd
         b1rt4KQYTQABp87P3l35JQr6Aea8+bbawmGmx0lMz5J/Vv23LFohJw2tDxJFaoBaBBvK
         cTIcZqMWDWGzuaUdSqjSg8UJf5nZd+ws1GBlXSXLf8Cgx1ttdj/AAEcmAQe/8fCr8PO9
         vYBw==
X-Gm-Message-State: AOAM531YLJ8bm55b2DWyhSSVEJExPJoYup9njh2+HSv+wRSvFCUaOAR3
        0LnCd05S75Y/KXmUqGdAwigEFcblIPwVpQ==
X-Google-Smtp-Source: ABdhPJySrtziYpLU1Rc1gAqmJV7XhB9/RD2HfzTtQwwK2rbFG3v5AnfltcnrC36lXla4SXGmuYolNw==
X-Received: by 2002:a17:90a:9dc6:: with SMTP id x6mr3115992pjv.100.1605086707714;
        Wed, 11 Nov 2020 01:25:07 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v24sm1708510pjh.19.2020.11.11.01.25.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 01:25:07 -0800 (PST)
Message-ID: <5fabadf3.1c69fb81.daba.4103@mx.google.com>
Date:   Wed, 11 Nov 2020 01:25:07 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.206
Subject: stable/linux-4.14.y baseline: 157 runs, 2 regressions (v4.14.206)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 157 runs, 2 regressions (v4.14.206)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =

panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.206/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.206
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      27ce4f2a6817e38ca74c643d47a96359f6cc0c1c =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/5fab7823cec947003cdb8876

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.206/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.206/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fab7823cec947003cdb8=
877
        failing since 222 days (last pass: v4.14.172, first fail: v4.14.175=
) =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/5fab76fd459e1f8ecadb885d

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.206/=
arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.206/=
arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fab76fd459e1f8=
ecadb8862
        new failure (last pass: v4.14.205)
        2 lines =

 =20
