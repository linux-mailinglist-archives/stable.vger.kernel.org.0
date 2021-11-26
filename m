Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F88145F73E
	for <lists+stable@lfdr.de>; Sat, 27 Nov 2021 00:43:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234602AbhKZXqy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 18:46:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbhKZXox (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 18:44:53 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B23C061574
        for <stable@vger.kernel.org>; Fri, 26 Nov 2021 15:41:40 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id y7so7626200plp.0
        for <stable@vger.kernel.org>; Fri, 26 Nov 2021 15:41:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tPZ8AwvBiCWWAlIQsvf/KqfWFl5H3P9U+k1YgbIjOG8=;
        b=Hg1hPymeYdtMqKpvb59XWVYSsPInqfRcOHrI++5fTW92RZmrKQfc7nsu+L+QA6Y/y6
         /W0uGENLKISn90cR0b/SSm90fmUVP+35JcujWxO7747q6HoEc8puiefJV9LEHu5zwQhR
         CiYfUTqzblEgSqT2TD2ga4FCScE0ZPU6Ka66W1gaRFPOXooway9YZ3f17bE00/stsAFs
         Rz8JMMFP09gI3Cbf/NLnAIqki47W1HndxubAFgdaRxogaCRARUGH+JlSbm2LFmrGu21C
         EAYt8Zf7xM1u4jy/pFzUOY7LOELyfh2659NvKj9MQnEaWEoDaOd83y8gKCXISZytsb/I
         l4Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tPZ8AwvBiCWWAlIQsvf/KqfWFl5H3P9U+k1YgbIjOG8=;
        b=xk8dkbqXuswPJR22fx/54bWL5iUfqq1MWRnW3rTk2F/jWxDdo7PBykoS04Xeepem9d
         HDABscKOGcrkPMQ5IYwW89KfnWOVh5lXs8T3oNnGzEiXEruTh1nggX72365DrQzB7EgG
         hX743jaeSmcin2zsY4L+zgCrS3gChTh20YIsFrnRzCJ+IWzGnBLHHDTmVlbzig2XeyRT
         VPPGaXDW8CgwiApZLqJwQ0z1LxxyEKIyCrxAn4G5bmk4inT7Ox8CUXD4uELNJyNHSQHM
         dA9nXk7Zk1AA5COu0PNpZWXLgO1UEB7D7Z64lSOyg6ctabIrAHRTE5nf2n848UN2t1f9
         dGUQ==
X-Gm-Message-State: AOAM532uDt7WBSzBbtyLFWcwGDMRZB1FZRensy3ezH9WTz9W5HaRa/Se
        D4LfOxlFrsa1wZWM9jBGNzs03YpUr1gS7Pu4
X-Google-Smtp-Source: ABdhPJy1zrjE7mXPSVEVLFupSNEEquxKySZBUYyiWruMtLmAS3r5YcnjLY7Idz2uH7WxHwsZuQOwyg==
X-Received: by 2002:a17:90b:314e:: with SMTP id ip14mr20014410pjb.130.1637970099639;
        Fri, 26 Nov 2021 15:41:39 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id lj15sm6607032pjb.12.2021.11.26.15.41.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 15:41:39 -0800 (PST)
Message-ID: <61a170b3.1c69fb81.a816f.2b49@mx.google.com>
Date:   Fri, 26 Nov 2021 15:41:39 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.217-320-g21a671bf3b0e
Subject: stable-rc/queue/4.19 baseline: 99 runs,
 1 regressions (v4.19.217-320-g21a671bf3b0e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 99 runs, 1 regressions (v4.19.217-320-g21a67=
1bf3b0e)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.217-320-g21a671bf3b0e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.217-320-g21a671bf3b0e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      21a671bf3b0e73fa85953f351dc06728bd065c80 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61a1396f8c0cbd211518f6f9

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.217=
-320-g21a671bf3b0e/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.217=
-320-g21a671bf3b0e/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a1396f8c0cbd2=
11518f6ff
        failing since 1 day (last pass: v4.19.217-320-gdc7db2be81d5, first =
fail: v4.19.217-320-ge8717633e0ba)
        2 lines

    2021-11-26T19:45:35.083034  <8>[   21.319427] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-26T19:45:35.127786  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/109
    2021-11-26T19:45:35.136647  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-11-26T19:45:35.150242  <8>[   21.389251] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
