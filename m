Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB4AE49299D
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 16:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236062AbiARP0E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 10:26:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235669AbiARP0D (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 10:26:03 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 364D6C061574
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 07:26:03 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id hv15so23604086pjb.5
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 07:26:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xEYxwbwUmvM3i4Fik8RXzbBE+qUD5riGDHorYeVQOCA=;
        b=jvr+nnIlpK0Rd2+drF6Ldx/1AlNgwIAnjXHSc+fhCjhpOSn48FcLAWLclROnA3VPFV
         mtuimRkLMw9lmSgFIqA1M1+jbFdbdZL9ASjzQPTh6rz0blilvFyqDJMqwtYY7Bb+EgNf
         kkYasi5N/M/6PvIuasOTq8ypdwsKfVwAflM9QgHuzza5W/N3nVL3VEow8EDtwpP5gfrE
         /wLKDK2qa6kSDL3TxoXl161QEYkabTmyMJhmD/3WhyxvLElkfYsI9OAKO9W8s6AahTMV
         Z2urt0WngrHxOyUD6uL7Nn2r3G0GixwbE3z/hFGTqu+l2mNzOqOetRtno1/1jVvaukVY
         9HrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xEYxwbwUmvM3i4Fik8RXzbBE+qUD5riGDHorYeVQOCA=;
        b=d+yOEaxfgfIdn8ceJXsNk1pt74zKrY4QqPNykw2BTlz4mVfhzMBY+xKPIvtKBAdgZS
         tApC2r/q3WP/s477I37IBOYnmt/8OF8SrATPrnykERK+2kf6zCquizd1aGgq5EDjysGh
         Nj8B9Yaoz9WXPtUdV4j8h5t+3UVPX9mVnmSllhcBdaQxWTYmQMqHRxvOeA7jdIj6jm09
         2L/gsBZb9Tgq4d2PRecSu7+IgN6/uCCM6NL0uAeTAt/XrrQmrNi0AN7zBjQu+aABKumd
         HUPxahwQnFpA7V9QP4JoIpuCpqJ29tEv/5nJT7+IlKCKrLNwsYoWSQVjPJCPPKhjE07R
         efBQ==
X-Gm-Message-State: AOAM532CRzVglHjAeQACR96psH9enQuIXvP2ozIZQf58HVTq3NQ7X7fB
        PllYZBNp9kTEpBDlDjpcXKJftd9ABOzHpazv
X-Google-Smtp-Source: ABdhPJzo/2tU3QQPvkb+quG8jcSgYFwTrgv6qoo3kJoHGVjxtMRmTfQcHjqhRlhUyF/IEc9hcfmeBw==
X-Received: by 2002:a17:903:32c8:b0:14a:695a:f381 with SMTP id i8-20020a17090332c800b0014a695af381mr27998055plr.156.1642519562362;
        Tue, 18 Jan 2022 07:26:02 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id kt19sm2957169pjb.50.2022.01.18.07.26.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 07:26:01 -0800 (PST)
Message-ID: <61e6dc09.1c69fb81.25bb1.7856@mx.google.com>
Date:   Tue, 18 Jan 2022 07:26:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.262-13-g01f6e3343a5a
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 146 runs,
 1 regressions (v4.14.262-13-g01f6e3343a5a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 146 runs, 1 regressions (v4.14.262-13-g01f6e=
3343a5a)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.262-13-g01f6e3343a5a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.262-13-g01f6e3343a5a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      01f6e3343a5a48ee599171a52b9ee9ecd6c09bdf =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61e6ab6837061455b3ef6767

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.262=
-13-g01f6e3343a5a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.262=
-13-g01f6e3343a5a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e6ab683706145=
5b3ef676a
        new failure (last pass: v4.14.262-10-g93d10bded874)
        2 lines

    2022-01-18T11:58:17.447474  [   20.113616] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-18T11:58:17.491168  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/109
    2022-01-18T11:58:17.500221  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
