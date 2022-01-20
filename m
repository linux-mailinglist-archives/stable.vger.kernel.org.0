Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEB554951EF
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 17:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376839AbiATQCu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jan 2022 11:02:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243632AbiATQCu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jan 2022 11:02:50 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD895C061574
        for <stable@vger.kernel.org>; Thu, 20 Jan 2022 08:02:49 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id 128so5965499pfe.12
        for <stable@vger.kernel.org>; Thu, 20 Jan 2022 08:02:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6UJtAHiYaNKiu/1QdfHvsja3KFPYr4VYZ26sC7Krdsw=;
        b=GhJAP4xx1jKpNpDg9FGBcAVdt4AmIYTjmeRq+73h9GcQVzLxMCj7ziHltTM0qUELzV
         owLpdo9MumEM48bef/2HP39XPbMsz6t+fCwOKWmE59K+eL7QHCR/oZm0srXwgeqw08LG
         wAir5MV+TUj4v8qTJncTOBUihdV7X2DpvRBggPd6GayhfAFdgZblarJ4Y96OXaECpqzk
         FzYvksN8DR6nIVSypms/rMAwCoGUUOTHwJTJGn5IhvH11dxcqc244lQF39JMY5Zz56rG
         g8c+VvVIOU6MDu3MqqdOLs19JUho7VC1VxJ3AgDcGAwvmXr++iZYOReU3u2HAMmZW5am
         5/Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6UJtAHiYaNKiu/1QdfHvsja3KFPYr4VYZ26sC7Krdsw=;
        b=cpBh9JPWDZ3NAlciLhecITtH0VLViSilrDYYCFrHcsI21vh/IG28mRajGDrtqSZ3ew
         VDjUxachNTDjsLsxCXlGDd9rUcdi1pr92TCiZTPB8FmT6wj6lxkJGkuhT1XXpJHcqddA
         rFvw8QUBoeXHVGp2Gm1Ht2o+5p7aJXYSApKQ0/6bt4ppwwre/aG8gFMxyNO8b9UQwLHL
         DD95eGKC9MZI8L0Yily7IxroD998sqcRMKWCnFcOaUui4FQCoQ/wUVzxfjg8m5SsSkMN
         uAQAGHOEBqqumDrrqv/iu+lQFAs7BmJe/fdoyfOyFU4iXxbEzLK4xdxby796Oe0LROzz
         14/A==
X-Gm-Message-State: AOAM531ID0iceFl4EtSInPtszlNtbIIaTi1QJzoDEV8xHKtiWf8ODttC
        rQDlCVL8YynUzhBweuLLc51glRuPaFe02zp8
X-Google-Smtp-Source: ABdhPJy2j5jJ7wO/PyvnkKUmcrayU39mqeh7uRb1MTEd+S4inV+3NecIubTAXyxmWcelbSpN76YNhQ==
X-Received: by 2002:a63:88c7:: with SMTP id l190mr24153981pgd.121.1642694569112;
        Thu, 20 Jan 2022 08:02:49 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f6sm3975798pfc.203.2022.01.20.08.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 08:02:48 -0800 (PST)
Message-ID: <61e987a8.1c69fb81.6e254.a58b@mx.google.com>
Date:   Thu, 20 Jan 2022 08:02:48 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.16.2
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.16.y
Subject: stable/linux-5.16.y baseline: 169 runs, 1 regressions (v5.16.2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.16.y baseline: 169 runs, 1 regressions (v5.16.2)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-g12b-odroid-n2 | arm64 | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.16.y/kernel=
/v5.16.2/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.16.y
  Describe: v5.16.2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      5fd3e07fd10e79694bff69fff1d38e97b47e77f0 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-g12b-odroid-n2 | arm64 | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/61e951fd923b537367abbd36

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.16.y/v5.16.2/ar=
m64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-odroid-n2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.16.y/v5.16.2/ar=
m64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-odroid-n2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e951fd923b537367abb=
d37
        new failure (last pass: v5.16.1) =

 =20
