Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B82D844C365
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 15:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231731AbhKJOzf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 09:55:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231703AbhKJOze (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Nov 2021 09:55:34 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B129C061764
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 06:52:47 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id o14so3215798plg.5
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 06:52:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rrNkgYs2KmLus0iHO25km5VDDTh/mdjzmezX6EheYoM=;
        b=MdWDhJUBponaSSh7jzzz39ekAuWXAePndxyQGQkLh8GP0yMkBIelT63HIWWhcYl6tx
         UjqYluQ4sd5EXssF/2FNtnhNKi38aBhlE19wsI0lU6E0e7FkPFg97Eb5q5wxVRvUDVf4
         4NCW1iUStyh3XHctImFa/w5BuGhaJJmbzGDrx/pcyNfd1/wYRa+nyniCKM2Cd2cAFL78
         dnlTY/xvE8/ct19Onep6A7BUyNN6BhqO3K1DKVNVSlM0GDJlOcKxx/F/YiG2qLT4zsti
         Qj51VpYIO7V2X/EawwZRVLglpWQeP1WI9cBobwdrZK5pkT8MPtwpc12ID3q5082uA59P
         hO7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rrNkgYs2KmLus0iHO25km5VDDTh/mdjzmezX6EheYoM=;
        b=HZH/SKQsfb8gpPxR7V2jMs5StO1mcTfbH0DEq+Pq2qnMl83jlaN88/WmiQRp4OeCe0
         IdTQqLZj4JcmwJYu1x6DHdv20J9CLJjtA8UhU5CginUU0PsnkLnniU6MXtoaZgiRLEN8
         5D5Ua7lc0KC/5ewulAyTl+ummCqqWWlVm7O/yHEdDsmWW4mRJuaMwDMblT3UXNwQt7hT
         XHJLBGdU3thXAR9jNbGbCxoSSMZfRxIIYAtEryuWZjzd4DyVO/o5SrNPGvMs5hLhXmMv
         x3mLo7XL6F7CJVx0CXSuz3UxDMz/+HcxXzxMKHyoqkqKAQ9wdNTNikdxdh+ZIU7QZ8S6
         VQHQ==
X-Gm-Message-State: AOAM530S7Gx/QirB0eDxeVZUlYYSq/qxwmCTY5jnha2jDFNKIqgFKu3Y
        9jQ0RDPBccqJ/1rcwIoYb5W7XsFcW6oKWmZh
X-Google-Smtp-Source: ABdhPJyHAZeIo8qW8GQwx89TDpkdc6UOieHSupgFMxM2zXb7ZGbtz4T1rMazXmmjCtA243vx2zqKGQ==
X-Received: by 2002:a17:902:b7cb:b0:141:b33a:9589 with SMTP id v11-20020a170902b7cb00b00141b33a9589mr16119516plz.9.1636555966576;
        Wed, 10 Nov 2021 06:52:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y32sm25638825pfa.145.2021.11.10.06.52.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 06:52:46 -0800 (PST)
Message-ID: <618bdcbe.1c69fb81.e5607.b30e@mx.google.com>
Date:   Wed, 10 Nov 2021 06:52:46 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.78-10-gd690741e8b33
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 217 runs,
 1 regressions (v5.10.78-10-gd690741e8b33)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 217 runs, 1 regressions (v5.10.78-10-gd69074=
1e8b33)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.78-10-gd690741e8b33/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.78-10-gd690741e8b33
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d690741e8b33eab8c76f63bf0b43c6e921c10454 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/618ba310391175f5603358ed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.78-=
10-gd690741e8b33/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.78-=
10-gd690741e8b33/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/618ba310391175f560335=
8ee
        failing since 0 day (last pass: v5.10.78-9-ge3bb388aea14, first fai=
l: v5.10.78-10-gbb7301181e71) =

 =20
