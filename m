Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9C629A278
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 03:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442578AbgJ0CBL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 22:01:11 -0400
Received: from mail-pf1-f173.google.com ([209.85.210.173]:41505 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439618AbgJ0CBL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Oct 2020 22:01:11 -0400
Received: by mail-pf1-f173.google.com with SMTP id c20so7263936pfr.8
        for <stable@vger.kernel.org>; Mon, 26 Oct 2020 19:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=C2/A6Tpyr1ctlnQoHKMuf9KQdzlO3lfXdygD9WLGtI0=;
        b=IlaPVjkvyIFFQ5c8DjrPN18NcnY2se8ksbmzzBeUW0FAvVRMxl7oRsF/Gq7g0oE+IL
         EWd/bY5JS1tNUtzdGtZS2osY3XKozsy3vHr1eQ8DoRWbG9uM0vh8O/o5nsGXKmhibypf
         ohqT+KsUynAmzGj3WFQI+sZdqlha6bkj376MzItcKFFZyLm/9PTw5fV7FOJykV77FFmD
         cN/E8AcQB/wiYewGRw1LAhMf6iY3OCeOlPphwWtXgOI4eCr3CZRQAvWLfHCXiGZyqJLI
         1DuR6wQ9LZ/Qy/zDTFt0yv7PGT6HO7qjnnr3OnNbl6NgMBZ+e5I+5AKULdM3GMKifGQ0
         AnIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=C2/A6Tpyr1ctlnQoHKMuf9KQdzlO3lfXdygD9WLGtI0=;
        b=sCo01+RBzOYvt1jfYd6rJDVABOiHwHT9IrymhJ3ZAe20XwA5Ivnv+mUzz8YuT+djbX
         ALsgQGqSJqpaOAdM+XRxUrT3s6AEkbB8Om0CGaQjrACn/qqMwXBgi6k33+KEwQoeXIaa
         JL9hXlFd8Euo2WWFDi0UgGSN9dTr+Wq4VYhv0lQlnXoQYmUIHx8kNPXlCufSGPlGk/0J
         PEhKx6xdsLkJ3kFRTOHREz74TKm2m3Hfgl/4uzUzNYpmdwlJxvN9yBQ4Kinmqm+XZ+LY
         9Myw/FOjp55vVSd9JnGUjv3Ev0lIU2wnEQ/7OTCw6u7RXlu0PJMYqkNczWbVYBXCNd1p
         7m7Q==
X-Gm-Message-State: AOAM5319HDn0d3rXJh5PVn65Vvlb9sB/DT9VFsA6+nVsYDGoyE8+Nq7b
        GIw9rsFDemQ7TZxnz3vLcPXCGsFxuZd1fw==
X-Google-Smtp-Source: ABdhPJwrtHBTT6hiLstsrWYWvpS9Ik++qPAPYRxXaSMOHtuwnpSgoKPQJeWkNBHUrPKeRxO7lLyn9w==
X-Received: by 2002:a63:1d15:: with SMTP id d21mr16222160pgd.433.1603764070154;
        Mon, 26 Oct 2020 19:01:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b10sm11835349pgm.64.2020.10.26.19.01.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 19:01:09 -0700 (PDT)
Message-ID: <5f977f65.1c69fb81.dc23c.9124@mx.google.com>
Date:   Mon, 26 Oct 2020 19:01:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.152-261-gd2b228260b67
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 162 runs,
 1 regressions (v4.19.152-261-gd2b228260b67)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 162 runs, 1 regressions (v4.19.152-261-gd2b2=
28260b67)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.152-261-gd2b228260b67/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.152-261-gd2b228260b67
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d2b228260b67ec2e94165f44e66f362b9c2c2d38 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5f974d7356b14f72e3381041

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.152=
-261-gd2b228260b67/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.152=
-261-gd2b228260b67/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f974d7356b14f7=
2e3381048
        new failure (last pass: v4.19.152-260-gbad1094e2c61)
        2 lines =

 =20
