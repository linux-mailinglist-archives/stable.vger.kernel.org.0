Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B36C4795AA
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 21:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240908AbhLQUnk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 15:43:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240909AbhLQUni (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 15:43:38 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26237C06173E
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 12:43:38 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id j6-20020a17090a588600b001a78a5ce46aso6808117pji.0
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 12:43:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1DeYbpvLTHB4VV+cDAdSGj5Qkje9YFfV5ClxHbcsMMk=;
        b=lW/KTezRiH4tU+1+k6o3qbUNDSORP3cgukCW9RdnucSi1x8e14L4133pZWZ8v91QNr
         W+Iw/SUFulxmBo25hTqDSbMtCN4gUv7d4jbnrfZZOmLroJ/1I6h6hxXIhh684b0fSOcP
         +OiyIERz9i4UsPIEvBy19GUbxJ4Nod2PPLHIF5k9mQP3d8vo/jHpHYKaRi17QLw9Eg3l
         8GUR7qRCJRySchLa+TkD3++fXqy/6MogcMdLjyQJxMuOuaOteUnlAeE63/Z2e0UeuyXc
         WegmGHAEuqQqK3eiPGj78q46sGSWmFUSY8Hn8qfNm6ymgzYtKS+zcO879SksrwrobVhI
         eaiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1DeYbpvLTHB4VV+cDAdSGj5Qkje9YFfV5ClxHbcsMMk=;
        b=SPnxrvb2FWX8r8Pbj+YAWT9QMfdE+ux/vhKNdx7u2hLAZ79mimQktQYmwmEnO7/k4c
         LRH3+SXTGKJpkjdDhtPGl71O+3phgrMfHJUGFg37wbPIs01GuW9H/Y8KwDAOSiOrC95J
         Eqlis2TzlQpS3fryXbEnz9DlazDWZ68ILFuBJlGXEo7zKBN5946msXFz+bNh6xwHU1DA
         4Zyy2kGXtvTRn2xz9X6QLkRiJHFVj55GkgsO3LAtpt6Cr/CmGrSQ8krcI/kM/zCOCHGB
         /YDb3Q/fY1YWEl/rsCi5zPbKClZ9UHjS2qrswER7VQ2Aqias0/VBzN3gM19Psb3PNOQp
         YkLQ==
X-Gm-Message-State: AOAM532sIq0x/LTvq8L0PblM8zDdvKi3+6EKgh1FoeQZGtRu5E+nX1U8
        XcQLAcmxOLddQqSeTC2cfyvOtqecURE62MiD
X-Google-Smtp-Source: ABdhPJzJmeuMjUO5PGp6v5xy/4NshDS07xIZmKseGF+JVWW1ma/6sOPCkSkmpCTBNar6rsHyEVRKEw==
X-Received: by 2002:a17:90b:4ac9:: with SMTP id mh9mr5808689pjb.25.1639773817521;
        Fri, 17 Dec 2021 12:43:37 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g1sm10016537pfu.73.2021.12.17.12.43.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Dec 2021 12:43:37 -0800 (PST)
Message-ID: <61bcf679.1c69fb81.c7fb1.c945@mx.google.com>
Date:   Fri, 17 Dec 2021 12:43:37 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.258-16-g61a721b2d716
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 77 runs,
 1 regressions (v4.14.258-16-g61a721b2d716)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 77 runs, 1 regressions (v4.14.258-16-g61a721=
b2d716)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.258-16-g61a721b2d716/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.258-16-g61a721b2d716
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      61a721b2d7163cb97f60c87e3b97f451d3b3812f =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61bcc001a90196ad2e39711e

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.258=
-16-g61a721b2d716/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.258=
-16-g61a721b2d716/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61bcc001a90196a=
d2e397121
        failing since 4 days (last pass: v4.14.257-33-gcf9830f3ce18, first =
fail: v4.14.257-53-gbe1979ab4cd9)
        2 lines

    2021-12-17T16:50:50.582200  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/102
    2021-12-17T16:50:50.591020  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-12-17T16:50:50.606636  [   20.214416] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
