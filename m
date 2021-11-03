Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57DDF44434B
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 15:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbhKCOV2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 10:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231834AbhKCOV0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Nov 2021 10:21:26 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21539C061714
        for <stable@vger.kernel.org>; Wed,  3 Nov 2021 07:18:50 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id x16-20020a17090a789000b001a69735b339so1495396pjk.5
        for <stable@vger.kernel.org>; Wed, 03 Nov 2021 07:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=72+TV60tSEH+SXGnlJGsIJxw1cbKcnktZOXzlmkIZlE=;
        b=CvwFzIei0actFgyDJ/LBIX1/ZXMU1oyfVYYSDgNw4q9a9rL3LxReUd3txJzZScZmN3
         y7PH3mA9GA1/OJuThfeYHYdhgIKgCVEMyar0Tk2FqSvrgdy+yJEGii+VnQN6aiLKzOG/
         TAnIrSU3fx2hhcj1ZghhD9xeMu//xacO2h8sWd+KG0R1RldWqPuWzkf79RHMuchlSA7J
         h5SRxZUO1wpzb8d2TmIg7WFlIVmWRgp9D/Am8mVdIAOwOcTWYDHaQSGPbFb6evSihDsS
         kuA36bzs3WD6AVmHHT88R9aKnWub2/i8PIahN6WnZnj4XJ+YRaGyngFc4UZzOO0voz4B
         lbqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=72+TV60tSEH+SXGnlJGsIJxw1cbKcnktZOXzlmkIZlE=;
        b=s5Q3pvFztMcx55WNOBQN4lIhDOGWgm/eq5qdecVshO1l9THJ/kLMY5d65IZQM/z+43
         mecorbuiGCAHvTqf1MCexqjyHBth4Ggo8H+OoXhFDvl2yubk/OmPN7XNgQzTksdGPApo
         BDmwRypiDlXwTTTWiAKLtI8KoxNQCh/dJWL0hhEBg/qJ43d6BZkEao5WFHOyPWLPhRGp
         DZt68HF2e+Mb+sQ0pmWd1AZvoT/xczbqR7d/yNTPorNBNCU6blVImVqGu5rVvx/ARsq4
         HuaFO1F0Ef8MYMuFeC3YCKtJMTpxazGLqKUkPFFgC62IWddYScHAThh3hhIuXhmxVNoL
         4GUg==
X-Gm-Message-State: AOAM532v0J/0mXduuaZkBjqdAywxDFte9IrafOH0txNhO7R4JfB3dzMg
        z/lcKbwP4wEuXTYICvAjCek4H0kxObhFFlDi
X-Google-Smtp-Source: ABdhPJwL7YClSak4jIGrJyZMjqreQUXOBQnUvSV5ckrObkM4NUCVPJuKQSYEr0G2obfd7C/tngZ2rg==
X-Received: by 2002:a17:90b:1c0b:: with SMTP id oc11mr14945826pjb.237.1635949129547;
        Wed, 03 Nov 2021 07:18:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x17sm2550585pfa.209.2021.11.03.07.18.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 07:18:49 -0700 (PDT)
Message-ID: <61829a49.1c69fb81.8d0ca.799a@mx.google.com>
Date:   Wed, 03 Nov 2021 07:18:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.254-1-gf8e8f2eb28ee
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 124 runs,
 1 regressions (v4.14.254-1-gf8e8f2eb28ee)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 124 runs, 1 regressions (v4.14.254-1-gf8e8f2=
eb28ee)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.254-1-gf8e8f2eb28ee/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.254-1-gf8e8f2eb28ee
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f8e8f2eb28ee42578402dabb6d868f68f47a973d =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61826220d8af4e0861335913

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-1-gf8e8f2eb28ee/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-1-gf8e8f2eb28ee/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61826220d8af4e0=
861335916
        new failure (last pass: v4.14.253-25-g6cc20d83a7ba)
        2 lines

    2021-11-03T10:18:53.754985  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/105
    2021-11-03T10:18:53.764073  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-11-03T10:18:53.781017  [   20.198211] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
