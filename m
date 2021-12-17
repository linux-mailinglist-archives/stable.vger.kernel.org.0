Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 553E94794A4
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 20:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240588AbhLQTM1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 14:12:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240596AbhLQTM1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 14:12:27 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 002B4C06173E
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 11:12:26 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id gn2so3091420pjb.5
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 11:12:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xh1XUNNZUa3w7YWhFXoiZnKcr1XP6tbHdz8Eqzz2J2Q=;
        b=ZwqDG+e/QNKqGjLYdsRudhd6IYj0dupeVsEQh+c4tGk2WUR8ZguHC14yPTqHFwds7l
         m+boAqZRHPIljFt25hWBeyFPjbYUX6zEcFSqwj5/oNbLT7VjrvEvyc72AsoIHb/vJwRT
         osW1cMf5s34K4FRvBdL0xussJF9Iwuez173M04QHlXctd/glmxjwTW8q2mfL8bnrAiVo
         4Msr9Xg5pgU0kJdNu3ZJiblpceV6GzrCqU0bndLnvDqFUwM59fBkSvR/Fv8CjRBqJADd
         3qrvD6tnM3SVh8Wz0yDk/vvnESLvPpDf3MJ/fcGnvGMt+SLJOrdv9bdPhECbiAv1MMJP
         GFUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xh1XUNNZUa3w7YWhFXoiZnKcr1XP6tbHdz8Eqzz2J2Q=;
        b=BNkdUGZBR4hQfbtKiFrdWdz6orz3kk4+rJ9daUD9bsTvwY4gjnH8kOtmE7CuWV6FBM
         fDKKEmP9AGXjXPRyLIvhVW/DtPLu0HkbLg/XLnQrAxqcXE7MChxTj8n15A56XtFmxfId
         Z34bxIec9mGJczzorqoj9/hu6zNMHgG08lldAr4MKE5MDLGXfqAFktr9TNOpCWBjAt4Y
         L4b09LpYRMIMFDHCRKA6KK0dZSq2el1ZEM+VLnVJguvZHd38shMz7HkGPM/qB2usm1Yu
         Ve1hLQx1Pe/xKvQ0bpP7Aar5RQs6386qH02CfMU7VHUmGju6iQ6kVM8mva412SaRiz1M
         u3uQ==
X-Gm-Message-State: AOAM53096QL8fg180P1QfXAE7p3Xuzrb8Z92+K5GhkixKJ523aBxWT0x
        qrlJoD7pJvY0ZCidHFPXpbc0AI5eDBL+0yU+
X-Google-Smtp-Source: ABdhPJwicZJUX4Rlt3GcS0hZHzTYawItlEVCnESRA6ofxQ3DHR9aqkUcM0iM6qn6Y8rjUjfQyTEARQ==
X-Received: by 2002:a17:902:c410:b0:142:2506:cb5b with SMTP id k16-20020a170902c41000b001422506cb5bmr4818722plk.36.1639768346380;
        Fri, 17 Dec 2021 11:12:26 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r21sm9115067pfh.128.2021.12.17.11.12.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Dec 2021 11:12:26 -0800 (PST)
Message-ID: <61bce11a.1c69fb81.c3ac6.adbd@mx.google.com>
Date:   Fri, 17 Dec 2021 11:12:26 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.293-8-g910ce43700b6
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 94 runs,
 1 regressions (v4.9.293-8-g910ce43700b6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 94 runs, 1 regressions (v4.9.293-8-g910ce4370=
0b6)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.293-8-g910ce43700b6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.293-8-g910ce43700b6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      910ce43700b6500476262f663dde8571aff1154c =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61bca5554a20216b9d397141

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.293-8=
-g910ce43700b6/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.293-8=
-g910ce43700b6/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61bca5554a20216=
b9d397144
        failing since 0 day (last pass: v4.9.293-7-gd89b8545a1fa, first fai=
l: v4.9.293-7-g534f383585ec)
        2 lines

    2021-12-17T14:57:07.635513  [   20.145446] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-17T14:57:07.686859  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, mmcqd/0/83
    2021-12-17T14:57:07.696638  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
