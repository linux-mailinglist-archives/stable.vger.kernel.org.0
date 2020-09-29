Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD6327C014
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 10:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727730AbgI2Iw2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 04:52:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgI2IwZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Sep 2020 04:52:25 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B019C061755
        for <stable@vger.kernel.org>; Tue, 29 Sep 2020 01:52:25 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 197so3301245pge.8
        for <stable@vger.kernel.org>; Tue, 29 Sep 2020 01:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KQTxS5+Ju3sga4dx6qQK/VYvQYApyK7bVlcwyUqJ2vY=;
        b=P9WYmJCiTUcoJp9k1bWBsBXR4fUZwK+Kan+de1jfLUTj81oAtjSvSu4GSTNDcU/P1t
         dnkaD3AzICg9gCjDt7t2DAxjsqdXpJqVat7bA/H4LjW0w10yOgnjc41SDwPM31Wxi0Iy
         Wg8yNN+7jjL7ERVT6TevESi90XpWBSRQtfAI23ioebS6FI/juLbLrVr2Zv/111PQf3MS
         WSxN61zx3rs2Pbsa76iuY6vFR148kSKQd+H3nle8pKnGWj3N3SIKmFJ6H4YFmsyYvxpr
         qFpS/GCC5UPgR1SXUh25dlEaKEhmaXj+PN8bPEAHD+XLnDzh2bPGNDMymDmD7DU11sZM
         A31A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KQTxS5+Ju3sga4dx6qQK/VYvQYApyK7bVlcwyUqJ2vY=;
        b=SehhWD7J38GaS9FH12zUbsoCwBzhLfcpz2wXpLMl4srIRHfALzYWosIKK2abd9fOZa
         8U9JqxhwFv3ObZTkB8ujJQy6ijdcXVtZYY4JefGh383rtjhWbCPqDIMOhdA531A5emdp
         dT9pvlJ6HyhD1fQkyHvILI2ckZ69b0MdbmjcWYY7nkd99sOqgzKnBwawudzAPWSaxDUi
         2weUzPvjlnqyBW9qYgRZDqocappovohgTt5j8apYnmHobdFH2IZhb8WKJtjh+wDrGsI4
         WgHpFFObuynUry+sQUqihDHKC/4UeSpsUH8z+LX5UO1tTAzEJkv9Ri0JKrkWRyP69biJ
         iOlw==
X-Gm-Message-State: AOAM530Q4iwl4GEQrMSixpafhb8lrxMJs8fW+qKHzInD1H+/Yrp3cqr8
        5K27xAMQY5LIXZqn5VlUQC0+4daof2XU/g==
X-Google-Smtp-Source: ABdhPJzPxjv7Ey/0sN9/iuKg0dP/o/efel95XOVXSM7uZjPxWRRBg83wSB1WWkYtEDDS7iWwGmvzkg==
X-Received: by 2002:a17:902:b688:b029:d2:43a9:ef1f with SMTP id c8-20020a170902b688b02900d243a9ef1fmr3491658pls.9.1601369544403;
        Tue, 29 Sep 2020 01:52:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x3sm4550833pfo.95.2020.09.29.01.52.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 01:52:23 -0700 (PDT)
Message-ID: <5f72f5c7.1c69fb81.7ac07.96de@mx.google.com>
Date:   Tue, 29 Sep 2020 01:52:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.68
Subject: stable/linux-5.4.y baseline: 166 runs, 1 regressions (v5.4.68)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 166 runs, 1 regressions (v5.4.68)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.68/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.68
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      5d087e3578cf9cbd850a6f0a5c8b8169f22b5272 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5f72bba753f77a880fbf9dcb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.68/arm=
/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.68/arm=
/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f72bba753f77a880fbf9=
dcc
      failing since 103 days (last pass: v5.4.46, first fail: v5.4.47)  =20
