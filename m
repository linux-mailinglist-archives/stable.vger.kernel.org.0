Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8713B39A506
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 17:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbhFCPzR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 11:55:17 -0400
Received: from mail-pg1-f173.google.com ([209.85.215.173]:33747 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbhFCPzQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Jun 2021 11:55:16 -0400
Received: by mail-pg1-f173.google.com with SMTP id i5so5510932pgm.0
        for <stable@vger.kernel.org>; Thu, 03 Jun 2021 08:53:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HRN2f5lz4lgyYeKcgxh2Dnf7UB9EC5SNbC52gK9vpb0=;
        b=SfjKhjTxlRBIAMZC5mlY5sAY3kQNjZuZFfJWZF/tWbAOv0qw0osA7uBhUJ2fbHq4+Z
         1bTjdunONHAiPBa3GYN0jh7uIyqKziIHCtbEcvR6y1SUd8yfml9Foqce+lBu3gg8ZY1y
         M2mraZt00e6E6HyISeSiUVIS7QL6AL/s302Z0V6w3cTs82J4m3xBbbV5aHj5OfdeCCNF
         w1AvCQycBNFf1pKTU3GXxwy9FdzzivHmC4qMislr2PE6fkCCBm23H52edHyfp23t1NbE
         WocsJBSW47IbabAk+eAipWhRL8RVLvLu6VQeFp5DXkPptl6fMlaumn/JQA08o48oLk7p
         43dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HRN2f5lz4lgyYeKcgxh2Dnf7UB9EC5SNbC52gK9vpb0=;
        b=C6GWSsYTyNio+7Q3aMv6jH5mIbqHROM+sQNfTr4HbaaHhzVwmikRrKge6ak/+EeCje
         6gEoeBU1/Z92w8O4cStmXYtWIf98w3EDDNM/evKkLro4J2UdD96NMaXP4FtEcDnRD2md
         fLRJ4gPCjJy4n8Jgl7LNO0u5y7mh30JdGUd8F2+/JtfaVwWczr+cbavkWaPSZlU/9Qbl
         t2wrr0i9RJR8ClcuOMgcKE6yALEE0XQIepSYHmUtx/CNauskN1HMqanvCohmjSSCKHvh
         zJlR/tA9US3xrCIdVpJr+kzibwkegymrUYTTlUzu1tezPhYnOu6RmvVBdQ6IYML7jyeA
         dnYA==
X-Gm-Message-State: AOAM532OHBmQwFZLN8uzmP/+66I+11NU4GV/k84tcbcE0ykg+x12ScC9
        LRilc8naKomiEYDWet416av47VZsPWKnsw==
X-Google-Smtp-Source: ABdhPJxuylaqn6kzw7xr/DXgbPXyIPmOUUHGeX67bmA0pEQm80v+Xz0vqn4PRt5vnJ9zTNESXiEGiA==
X-Received: by 2002:a63:7e11:: with SMTP id z17mr146777pgc.9.1622735551834;
        Thu, 03 Jun 2021 08:52:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c62sm2684210pfa.12.2021.06.03.08.52.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 08:52:31 -0700 (PDT)
Message-ID: <60b8fabf.1c69fb81.bf715.83bd@mx.google.com>
Date:   Thu, 03 Jun 2021 08:52:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.234-84-gd2294bde5706
X-Kernelci-Branch: queue/4.14
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 133 runs,
 1 regressions (v4.14.234-84-gd2294bde5706)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 133 runs, 1 regressions (v4.14.234-84-gd2294=
bde5706)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.234-84-gd2294bde5706/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.234-84-gd2294bde5706
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d2294bde5706086f4fab3fedc2b7c77f2eb7e999 =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b8c5701fcae60951b3af9a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.234=
-84-gd2294bde5706/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.234=
-84-gd2294bde5706/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b8c5701fcae60951b3a=
f9b
        failing since 94 days (last pass: v4.14.222-11-g13b8482a0f700, firs=
t fail: v4.14.222-120-gdc8887cba23e) =

 =20
