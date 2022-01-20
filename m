Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD8384955EC
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 22:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377837AbiATVZK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jan 2022 16:25:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377842AbiATVZJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jan 2022 16:25:09 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4258C06161C
        for <stable@vger.kernel.org>; Thu, 20 Jan 2022 13:25:08 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id t18so6342409plg.9
        for <stable@vger.kernel.org>; Thu, 20 Jan 2022 13:25:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=V1zgRW+I3b275OmBNpNJNCQyCeyBnQPy6uIBX3I+vUs=;
        b=zYKhF6FHaicnPJqJVk8/8cQEpSZgTDc1eVxKUUinPH6VICFaO7ayS5Wd1cD7HwEvu8
         Je0AYa1MH4uCkgJl+DurkIUaOga0/qWCg0CvZ1soIq8R5NptP2cFfEQvtg+nGAgw5JR+
         dj8pXRn+ba55+vtt6IpIdiSt5Xpjg1tFGJg87ln8vky/u37IPzb1wI21ut7dErlprE84
         0+ogojHm+uqjKv7sX54mHUe2vyiIS4rdG4m5tjG2Zj2b+SWd06MbS5Lh/WULxiZQZ/AW
         NF3jxJvT9GEW6awbeAJLA31dU/RFdIOHzjqDHtwMmJdYYqWIjr87Rm0r2IjGOPea6wnk
         dRdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=V1zgRW+I3b275OmBNpNJNCQyCeyBnQPy6uIBX3I+vUs=;
        b=Tx8ZgsLV9DGMClDGtevHRVVuW1MsMBisUBEVLExJ/uGjP5U8wuuXQx9OWihkMomYgX
         9gIK6Y+MQZe9NS13lVcRt5S2/SAM0QtWveEJz7xsfWieHfX17rZEc1IHewnjjhHMwb4m
         4V2or/hhzIJRvVup6/a+O/uEoQMtgHjNJccG7B4VB4jKzXh3RYsb8fBqXO4mVEVYUsMu
         atsmgIbmIIrk2J1WMNXBrKzr0cQQQO3OGrP7FF5HLv45qurOl0lTzEsKODfSckXoIQyP
         E8SyWiUqzHBCR3WW11tcskTW3Lu77+FeZ5q8uZa+tWarusZh9CsBkoDCj0nuUZZmOAx5
         nDeQ==
X-Gm-Message-State: AOAM530w66JFaOHqIsGdrUPXIrNY3Z2qa8iov0YXonbXSiB/I2qWlTXi
        1Vnql9iHyDjor4OE7g0brpNhOSXPKfisdtws
X-Google-Smtp-Source: ABdhPJxEo6uRUDWB1sp5pI12hsmz+K3xmr/GxPovafJ6zMEcCG96WU/vA0xAvhjOubX7iyvxQQWtVQ==
X-Received: by 2002:a17:902:9306:b0:14a:18ab:298c with SMTP id bc6-20020a170902930600b0014a18ab298cmr596966plb.87.1642713908050;
        Thu, 20 Jan 2022 13:25:08 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nh18sm3199811pjb.18.2022.01.20.13.25.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 13:25:07 -0800 (PST)
Message-ID: <61e9d333.1c69fb81.8f841.9622@mx.google.com>
Date:   Thu, 20 Jan 2022 13:25:07 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.299-9-g7958be08b7c2
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 102 runs,
 1 regressions (v4.4.299-9-g7958be08b7c2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 102 runs, 1 regressions (v4.4.299-9-g7958be08=
b7c2)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.299-9-g7958be08b7c2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.299-9-g7958be08b7c2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7958be08b7c2f5e180fd9a35077dd90b1342cd31 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61e99feb384f444b15abbd1b

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.299-9=
-g7958be08b7c2/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.299-9=
-g7958be08b7c2/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e99feb384f444=
b15abbd21
        new failure (last pass: v4.4.299-9-gf0ed06ea70f9)
        2 lines

    2022-01-20T17:45:58.503864  [   18.825378] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-20T17:45:58.547967  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/112
    2022-01-20T17:45:58.557033  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
