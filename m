Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6D6547F522
	for <lists+stable@lfdr.de>; Sun, 26 Dec 2021 05:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbhLZEox (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Dec 2021 23:44:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231407AbhLZEox (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Dec 2021 23:44:53 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B2E1C061401
        for <stable@vger.kernel.org>; Sat, 25 Dec 2021 20:44:53 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id b22so10826947pfb.5
        for <stable@vger.kernel.org>; Sat, 25 Dec 2021 20:44:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FPpwtikRyYAIau6YY4agd7+XloH1jq8osKruGwuKThw=;
        b=cnYqJQ5SJDmeUjdI5cHoO6LB+1qobDFmtRqBeOgdu/F3XH3fFVZp2yxE/9B1YM7GUf
         b3OxxZmiCO5laFjsfjWlXBuuoyXMlJYApsIhvyeEXPD7XX5DaaSfEOL9TLj359HdYPCL
         k/T+bSzI6UEzrTZYhF4g5EfIUtZPm1ZoFsv0iNUxucrt+n4bpRCvpjxiBHKhG6hjQhLD
         Sph7/qwUCpMF22RLW/F337ZsN/Z1wPPUtniTEfb3rxbmoV8LmDr37K+7WHu4eRtEVpCc
         XzWHBWAdg8WS8yzTFP7t4u/UP00FcLe3wcpUwbjSB9QPtF21jZZjfDCVtj9rzkJ6mS7I
         vmgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FPpwtikRyYAIau6YY4agd7+XloH1jq8osKruGwuKThw=;
        b=jI9gLHXss4uyf4VLPKBGivhSXi6q3l8UNS3S6dysUpTZcePeGK1shVbI0YeuZKBE/t
         +V/OgWmzidTfyNGtBajP5v8PYsHKxn4Dl2RbKkufcm10I1T2xXONAr4Ke0catcqX7pkR
         /+Bghwiqqj2zEgYcX9Rb+8uVmM1WINIFgbM6WPx7k7M0mMrHwg51BP8a+eLqpPhtaCA0
         lejvTkIt7MZYM3RS0ogijWXtYUdst2+xIcYaKi6rLuuF/IKvdkkTQxlyXqA4wplpLSON
         O33Kfb6qImdlpRyeTpO1WyppkJYyxVGKJRfqA+aiiimze6vx+gkTFJW2I5+wluqhGCwH
         wRNA==
X-Gm-Message-State: AOAM533muqLwB65ImbDBVwy/MU3OG5wam3tFeVoHb7Qj8dbvcqe/+5gL
        oZr9HzsM2f8jhsr5tZTrOJ55YmaTCCi00ilO
X-Google-Smtp-Source: ABdhPJxRFYlXxqW4QumZTRTozYwh2ExJAFn1UqriO3k8/+B/sQmvbky9q71F3hOj5nn7jtN6C62fQA==
X-Received: by 2002:a62:80d8:0:b0:4bb:a8c5:868 with SMTP id j207-20020a6280d8000000b004bba8c50868mr7480575pfd.25.1640493892117;
        Sat, 25 Dec 2021 20:44:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id om3sm15159272pjb.49.2021.12.25.20.44.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Dec 2021 20:44:51 -0800 (PST)
Message-ID: <61c7f343.1c69fb81.5120a.c7b8@mx.google.com>
Date:   Sat, 25 Dec 2021 20:44:51 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.222-19-g5dbd0f2afad7
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 179 runs,
 1 regressions (v4.19.222-19-g5dbd0f2afad7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 179 runs, 1 regressions (v4.19.222-19-g5dbd0=
f2afad7)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.222-19-g5dbd0f2afad7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.222-19-g5dbd0f2afad7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5dbd0f2afad774e6e3cd7ab13ed7976af9f9a1c1 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61c7bd9f1f8684c93939716f

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.222=
-19-g5dbd0f2afad7/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.222=
-19-g5dbd0f2afad7/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61c7bd9f1f8684c=
939397172
        failing since 9 days (last pass: v4.19.221-9-ge98226372348, first f=
ail: v4.19.221-9-gf48d5f004d75)
        2 lines

    2021-12-26T00:55:44.783836  <8>[   21.558685] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-26T00:55:44.828597  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/100
    2021-12-26T00:55:44.839092  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
