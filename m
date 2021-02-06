Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E212311FD0
	for <lists+stable@lfdr.de>; Sat,  6 Feb 2021 20:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbhBFTzr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Feb 2021 14:55:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbhBFTzr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Feb 2021 14:55:47 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F092FC061756
        for <stable@vger.kernel.org>; Sat,  6 Feb 2021 11:55:06 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id t11so3341936pgu.8
        for <stable@vger.kernel.org>; Sat, 06 Feb 2021 11:55:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3fX2qzl36WUS11SnRVcVX7vZpxFjvUW9QN3RHNp+jKA=;
        b=rYX10z/B5q8rlHguaEqYvOmgz8lYOJPu+hYB6Xvd9dtPr7U/1dMd7wuAxGPXzBo7KU
         Ocxvv5HYaPLy0iM3jci8Uy5GQFvPM7sBIztDv1tRzwfBCSbPDTU1/Leulxc53OIyjmW7
         vm2KJgW3RnPkNbLxtbzJ55cc+OOENiNrfDhUqaUTCStpezaR7ZGrp387vduGbC5Ymvpf
         RPHiBVM6hkA8jgRRCh//Y0Rxjy1Wwc5RhiCJDBRFY9JbyHN5S1hlAnToSzG7N81IjHq0
         tbqTWly2D9apPaUxqYgDBfwhM5DH6/R+UqwUpOWtMtFSB6VcKz1OWvrVeyj/nnwxTHlT
         g3RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3fX2qzl36WUS11SnRVcVX7vZpxFjvUW9QN3RHNp+jKA=;
        b=hwQjVhumzlx4IGyaR+7QFhLkaxzB0gSV6+GbMkYq7G6rdGKNWugJhI2NmVPpU8Yo50
         UF8PMnze3Xpn/4+AbHMq4YhgOASfZRhxR0oPBE06O8GI1V4v9KzbUzYqaivc7qmFaZPU
         XySHC7JDrZft/7ino9VBwq389gRwN/qveJFVd1lQ6DAVVu9rns6hXVNXpv80N9lUJb9E
         LAXwv2hQGRo1a9CTaN5z7TNQZItkWKx/0GojAVZLlSkamsP68eJLxqXah4tdFHW5v5mR
         p+tu1PPziKfIXWZQa89EnCjxeiLCXedP8iezvSc2D+iNwFnJiCCSwMMQ6+MaOvFkGQ7q
         XV6A==
X-Gm-Message-State: AOAM533w7iQ990GLX3csZpDoSBvcdH1X5cRntoef2jnXW8yeUU4ACxP+
        SKvZ5o6juYQy6hApQiWabL2XTde3EP9Z/g==
X-Google-Smtp-Source: ABdhPJw8dpVAzREMPCd/MXWlr+V2e3xvyeccu0mVHkfwk6ciZSM1mphQln6iv5w+6aSwRNgzBvQK1A==
X-Received: by 2002:a65:434a:: with SMTP id k10mr10428685pgq.98.1612641306270;
        Sat, 06 Feb 2021 11:55:06 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x28sm3992067pfq.168.2021.02.06.11.55.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Feb 2021 11:55:05 -0800 (PST)
Message-ID: <601ef419.1c69fb81.197bb.87d1@mx.google.com>
Date:   Sat, 06 Feb 2021 11:55:05 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.13-57-g815bee96eacc2
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 184 runs,
 1 regressions (v5.10.13-57-g815bee96eacc2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 184 runs, 1 regressions (v5.10.13-57-g815bee=
96eacc2)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.13-57-g815bee96eacc2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.13-57-g815bee96eacc2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      815bee96eacc24d66403f6a32aacc0e35b713a1a =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/601ebf570e6ebf28293abe84

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.13-=
57-g815bee96eacc2/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.13-=
57-g815bee96eacc2/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601ebf570e6ebf28293ab=
e85
        new failure (last pass: v5.10.13-57-gc75a45613b6e) =

 =20
