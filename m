Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03684459688
	for <lists+stable@lfdr.de>; Mon, 22 Nov 2021 22:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbhKVVUa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Nov 2021 16:20:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbhKVVU3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Nov 2021 16:20:29 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA70C061574
        for <stable@vger.kernel.org>; Mon, 22 Nov 2021 13:17:22 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id u17so15210967plg.9
        for <stable@vger.kernel.org>; Mon, 22 Nov 2021 13:17:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BNSc8MPULqVsy+i6E1qXx2nJtfd8uf/EtbPD8qQ2c4I=;
        b=kReAzoBNDqlaSgPFRlVLbzFraAFaj7SFfyWKmNNQqSJtI+CXVosnXc0Z2J2rThleNj
         uvGsRxSma2eK0eM0oOUDUZStMXtk0CRBKxVof4f89suGh8gpcJqAJIjXc48VSodHNPLA
         r87/M50b6ec5kie7Cot5U3MiQuVV2FMvGxxY+baKDNjBKYOdLUpvVzpXzBycNbaKaidS
         9/Fq8m8GM5vioVDLeq59Djr7GorZq45QT0GeyMYyU+pO1m1m9u9xuteZSRWAPuI7pHEw
         6HA/69/MsPOfXZvBopQ5H6WIJB4HW2DN99Ow31ipS2SoUiBZHwcR3Pq0nzmNFrMYWsJF
         7tZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BNSc8MPULqVsy+i6E1qXx2nJtfd8uf/EtbPD8qQ2c4I=;
        b=vMtRwVtYzrwxLYNrp3InfSCm8xVkFWCUI/p19Qb7t4/R+oLWyJFADA14aDkum/kIcz
         1GOdoqZyt754AHwINTO2Mn7lY/BoyThkWdJATdUMzlcEhfze32lMom8MP7nXEoJcHCrm
         2ZLzs74Mx4RnQiTmTjMaiFoVeFtaudiUfJL27DGbg3HPx6E2meYmWj4JSGW1nm1XQ0K9
         bnD+SurhwEBQgCfo0VJOswMRczGPFCZwHGyLo7jkL1HP0sV7WetRpAOmfdgRhdBSL49l
         rfd3AiFWN7USwnflxLjcpDJdc1QQVLsoXNiNYnhsMN6oO+UyWyxQf9AkdytYJr0Cpxkn
         twZQ==
X-Gm-Message-State: AOAM532F0K5uCR4NjUeWS3hZJBtIfa8ZcnsbRKbANaNnvpGEF84SL7Pw
        8R4ucH/TRMrVNzhBt3x7dclvOvvrDvdAZEs7
X-Google-Smtp-Source: ABdhPJySIW4xjRAwoQSq+LII7yVetiEdbgM1kX+gCflWdT+relr/FwojFFvxhlkswNPfi6c6Io2mPA==
X-Received: by 2002:a17:90b:4c8d:: with SMTP id my13mr36092007pjb.107.1637615841858;
        Mon, 22 Nov 2021 13:17:21 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x9sm16523308pjq.50.2021.11.22.13.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 13:17:21 -0800 (PST)
Message-ID: <619c08e1.1c69fb81.e6e6.0f8b@mx.google.com>
Date:   Mon, 22 Nov 2021 13:17:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.292-143-g38a064392378
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 67 runs,
 1 regressions (v4.4.292-143-g38a064392378)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 67 runs, 1 regressions (v4.4.292-143-g38a0643=
92378)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.292-143-g38a064392378/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.292-143-g38a064392378
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      38a064392378cf1f3c4cd07e8b886d68a3e42058 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/619bd0a5fb24feed1bf2efb8

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
43-g38a064392378/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
43-g38a064392378/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619bd0a5fb24fee=
d1bf2efbb
        failing since 0 day (last pass: v4.4.292-116-gc13aef2ca259, first f=
ail: v4.4.292-140-g1794f2b1b0d51)
        2 lines

    2021-11-22T17:17:06.261957  [   19.161193] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-22T17:17:06.304712  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/117
    2021-11-22T17:17:06.313976  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-11-22T17:17:06.328746  [   19.228668] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
