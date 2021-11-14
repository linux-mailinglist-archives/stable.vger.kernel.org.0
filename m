Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFD3E44FB50
	for <lists+stable@lfdr.de>; Sun, 14 Nov 2021 20:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236611AbhKNTvI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Nov 2021 14:51:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236913AbhKNTtL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Nov 2021 14:49:11 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD480C0432D4
        for <stable@vger.kernel.org>; Sun, 14 Nov 2021 11:42:49 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id g19so13181866pfb.8
        for <stable@vger.kernel.org>; Sun, 14 Nov 2021 11:42:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qwpLcpnt3bhyOjj+HdZ15FosOwd0wafNTOLDAESdEqE=;
        b=BQo/4hoLD2bpTqdd7eA+7XgeLgj5/n5dl4fMb8VzVKAHvnoU7uYVg6iwMAKxJA3GiU
         QZr8LvXqjXJQDMjB6R0QmwxOVXBCse0c6jimvX9HVOH7NeAgZStT/D+ouDUPFFnLuomJ
         703f23HA9rVpEfYxRaKgafOe5G2rmrjKkU8X0MgULC9GhoFOx90Y2CD6kPCyumcjnNMs
         LetV+NR0jzTrtuYvBaIf48WiW7oJJcExIv+Wfods5Is/J3pPUb5JqSBq7SYeQhsajmEm
         FacMuwf7TPjm5ch1H4AujptPZlRvQsqsD6GV/2KruGc4bGXpxkTIEk6TxCMEWHFjmq4E
         F6RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qwpLcpnt3bhyOjj+HdZ15FosOwd0wafNTOLDAESdEqE=;
        b=w028NU8/OpOqJ3JJUFTk/tOj+ZcO/Hcal4LRIlKcKjpNuetIRaJKMwpudBH2AQj9DY
         J8PU006X9nb/YLmCOGMba9Lyw1qcaAz+TWd/ebIDXyqJml1uOCtbi8gTpsc135m7J1lf
         Po4jEqHRJemjqXs/Gq21KOJTd1q2cMnJoGOT/ys/0JZKjQjNQY7+MhhLwKf2TsJ6yeYT
         y5sl0YYyw+2SFspMBxZBhAGZBmqrabJbCweqoCUSy4KdLkakLE7zlo1H16NHkYm6A8H+
         HrUY6vf88+koZjawmeCZdEH1HiOU6zC4uYKUTwiuYeU72ed1LGylYytLkbHWCKgUeNsQ
         ADMw==
X-Gm-Message-State: AOAM533kbDeLfrDEbnZ7G2o/JMB0PCjVq+Ad/klqkWq1zViuGwEUsU53
        WbdGEGCz2F1DdmHAOdRndewSJb7tuduN5jHa
X-Google-Smtp-Source: ABdhPJwBCreoc5pIt2nEA4I3lIWzRAmRgCDn3Kzkr8rVsVjww1YPcpqPL4LBCJ+nMqm/PUdX98UALQ==
X-Received: by 2002:a05:6a00:23c4:b0:49f:e054:84cb with SMTP id g4-20020a056a0023c400b0049fe05484cbmr28347006pfc.63.1636918968575;
        Sun, 14 Nov 2021 11:42:48 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u19sm12271800pfl.185.2021.11.14.11.42.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Nov 2021 11:42:48 -0800 (PST)
Message-ID: <619166b8.1c69fb81.67c22.34b4@mx.google.com>
Date:   Sun, 14 Nov 2021 11:42:48 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.18-204-ge1c25497dccf0
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.14 baseline: 157 runs,
 1 regressions (v5.14.18-204-ge1c25497dccf0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 157 runs, 1 regressions (v5.14.18-204-ge1c25=
497dccf0)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.18-204-ge1c25497dccf0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.18-204-ge1c25497dccf0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e1c25497dccf0b5a970f97659addfddfe37c969c =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61912e2f82549d623d33594d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.18-=
204-ge1c25497dccf0/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.18-=
204-ge1c25497dccf0/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61912e2f82549d623d335=
94e
        failing since 21 days (last pass: v5.14.14-64-gb66eb77f69e4, first =
fail: v5.14.14-124-g710e5bbf51e3) =

 =20
