Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55B9E4930BE
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 23:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350015AbiARW1s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 17:27:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349970AbiARW13 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 17:27:29 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22CB7C06161C
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 14:27:29 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id t18so264095plg.9
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 14:27:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NYKrM4NNNXN9ZFG53aDhwpw7guegA64senT9u/dMOsQ=;
        b=2tmdY/j1NcrplgiapZV5VAEfedxved31uOAvVyZ7zwtIatD0QLKnfxpUf/WwWvDEXT
         qWzTTS/iJkJxRRCLnvN0Oy/0WIyJXnehvM7fNDlaEHYXI7lxf19D8sOb9qLl8XsfLtlR
         U/h18i1Y5snXlI/PIUnM2njrXs0nADvy2FnQAmDUHtNqsyLSvAHEM/Tkeohu3DOvX4pr
         t0HufROavQIzFg73AOz4yU5+XIX+VhnHghq2f6FHxFX+FGldlbbAedLTKA1LMMFw7g5s
         +7SC6oW8K7bFbRUYTYQa6mc1jf9ujFF9IcEdbQNGbkhPPyXnKVRvz+MRK24g6itVapnm
         wtSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NYKrM4NNNXN9ZFG53aDhwpw7guegA64senT9u/dMOsQ=;
        b=ypCLeC+znN83SwPoufEAmGHh9dvBLcjO2mwlTpI5RpFhkSdwqjPi4rRFBCa+u1hK+r
         aZkcxg2+ahnZmKwmqKo6QR3FlZM4NbJ0cUyZKa7DQZ+ZuB+1PWt6wHTe4eoMNJgqSlnT
         WF3zTDspiYRGIDJD6XhsPd66NAq5Cov854HQc/xn+fjkFJUYekV77eEswUOFgt4b/s7j
         UPkoiHG0j5/fQ19JKX3l5xsU7fEyxkmYJNL+RZzbWeaRVuhtM8ZYlUyxVS4RmVKs+JVk
         weAn9gGV48BxxzS+5Lq/6yo+lJ763J12axwspQNA4pTeOodPmtBXcYGfYdev4Xt0FrK6
         m14w==
X-Gm-Message-State: AOAM532KDB4+rcw7/H7qE4OsevANxY77iQDKSxCOJoxgsxAjkoTeM62v
        ZLOpXFZTeyl2l17kuPohZ+BXWsgNkg8k5TX9
X-Google-Smtp-Source: ABdhPJw9UNTCZ6YWIB7UKEQoYJd4in/Wlik1KVSqwaxlDo1QQ1/iaW6lMGwqFZtRxjou28vFsgy2kQ==
X-Received: by 2002:a17:90b:33ca:: with SMTP id lk10mr777749pjb.33.1642544848525;
        Tue, 18 Jan 2022 14:27:28 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ip13sm4041077pjb.13.2022.01.18.14.27.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 14:27:28 -0800 (PST)
Message-ID: <61e73ed0.1c69fb81.b7703.ad09@mx.google.com>
Date:   Tue, 18 Jan 2022 14:27:28 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.297-12-g5c0e5629e5ef
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 113 runs,
 1 regressions (v4.9.297-12-g5c0e5629e5ef)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 113 runs, 1 regressions (v4.9.297-12-g5c0e562=
9e5ef)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.297-12-g5c0e5629e5ef/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.297-12-g5c0e5629e5ef
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5c0e5629e5efc8c19bb8cda3b1868b67998b7a7e =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61e7072489f86ffd35abbdb3

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.297-1=
2-g5c0e5629e5ef/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.297-1=
2-g5c0e5629e5ef/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e7072489f86ff=
d35abbdb9
        failing since 0 day (last pass: v4.9.297-10-gfdec8da75479, first fa=
il: v4.9.297-10-gece287e6caf0)
        2 lines

    2022-01-18T18:29:35.321383  [   20.543182] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-18T18:29:35.372705  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/120
    2022-01-18T18:29:35.381613  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
