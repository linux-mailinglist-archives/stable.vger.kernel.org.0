Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF0C2AAE8C
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 01:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727979AbgKIAa7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Nov 2020 19:30:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727929AbgKIAa6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Nov 2020 19:30:58 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3EAC0613CF
        for <stable@vger.kernel.org>; Sun,  8 Nov 2020 16:30:58 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id e7so6239937pfn.12
        for <stable@vger.kernel.org>; Sun, 08 Nov 2020 16:30:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9K0Pk03vIGBORonrf2JjFggD5AAjz8KQo0N6tzl+QDM=;
        b=idF+W389mj5QsL0tUvpK5Z2rDqwIq88TGjaqiG/xeQZ/qsD/AB8YuAH+OSfxyBebj0
         2CdyANEzHH2HSMH0RmwGZft0kulfDziV91umd18+fbJZGGJauBUyfbWTzjDsNfFNX04t
         O2itzQ1zgNrBO2ksaVE448/mTKNOpamW77YS6WOEOUjh/HcO2v/CwIRtHE5ZmyosPnIW
         HhqoXVJDO53IMXerHStPZDVV9/x6O+ri5XpANWsSx4Tq1GcKCrSJTrKEAHjwwC/9cXWS
         JZggxCRkY4qqF8Se/UpdGJS8frGO75NRgyEkzTM5oWXOQZB/BF0UsvQwVSouJBpxurzN
         yUPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9K0Pk03vIGBORonrf2JjFggD5AAjz8KQo0N6tzl+QDM=;
        b=p4Hrmb3Fd56/mzWeC6WPlyYTT+3IL/IWZqtm+4H7rOL1alvH4V26bR+IkeO6ix7rmr
         Dzl7Zf6JZizSvlUqjpUQXXXOoojCfBrlWuqwWQEOuN6q5DJ04scKHLeT5Sln+z8xu/R7
         e77wYfPia9q6EC88h9FYCaGTt/nrAIc06MmYsg3gEOtrTVTaKTk0QMXd4ZvkoTUtekOo
         PbDHm1cwub5w5agmHtgmqUxVsnJ2lONyaD3ADqGkk75z5JAzjGJiWUmRsySObHgHUxQq
         5pPPyckkLnMcBBq/vx30ewldC61eth912NDyRBJt2eiS8OL4sVDs6arHhgWFs4MyFaES
         Hceg==
X-Gm-Message-State: AOAM530+7NJcG5nhlyYxWd0nEl6lTATNeTVI9Bv+RJziRd+Zviq+iDJu
        rxTwVGu51wjB+7W9DQCTws0xCWHvVQHl5w==
X-Google-Smtp-Source: ABdhPJwx5P0BEe0piHRwTrlTAX3PIdIEV6/yUl1r1+T3ZVhm6za7aHyBmTfy+d30Gp1SebPc/R3Ubw==
X-Received: by 2002:a17:90b:204d:: with SMTP id ji13mr10235363pjb.20.1604881857609;
        Sun, 08 Nov 2020 16:30:57 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r127sm9001440pfc.159.2020.11.08.16.30.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2020 16:30:56 -0800 (PST)
Message-ID: <5fa88dc0.1c69fb81.fe283.335d@mx.google.com>
Date:   Sun, 08 Nov 2020 16:30:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.204-25-g54b36d813bb8
Subject: stable-rc/queue/4.14 baseline: 167 runs,
 2 regressions (v4.14.204-25-g54b36d813bb8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 167 runs, 2 regressions (v4.14.204-25-g54b36=
d813bb8)

Regressions Summary
-------------------

platform    | arch   | lab          | compiler | defconfig        | regress=
ions
------------+--------+--------------+----------+------------------+--------=
----
qemu_i386   | i386   | lab-baylibre | gcc-8    | i386_defconfig   | 1      =
    =

qemu_x86_64 | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.204-25-g54b36d813bb8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.204-25-g54b36d813bb8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      54b36d813bb83d08c0dc35c3564ea72219184e0c =



Test Regressions
---------------- =



platform    | arch   | lab          | compiler | defconfig        | regress=
ions
------------+--------+--------------+----------+------------------+--------=
----
qemu_i386   | i386   | lab-baylibre | gcc-8    | i386_defconfig   | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/5fa85a5044117cecd0db8861

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.204=
-25-g54b36d813bb8/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.204=
-25-g54b36d813bb8/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa85a5044117cecd0db8=
862
        new failure (last pass: v4.14.204-21-gd9024a032a65) =

 =



platform    | arch   | lab          | compiler | defconfig        | regress=
ions
------------+--------+--------------+----------+------------------+--------=
----
qemu_x86_64 | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/5fa85a4f07004472eadb8869

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.204=
-25-g54b36d813bb8/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.204=
-25-g54b36d813bb8/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa85a4f07004472eadb8=
86a
        new failure (last pass: v4.14.204-21-gd9024a032a65) =

 =20
