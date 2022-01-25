Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF48449B5C9
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 15:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239155AbiAYOMC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 09:12:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385771AbiAYOJ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 09:09:59 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 972DDC061755
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 06:09:54 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id q63so15414791pja.1
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 06:09:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=32SaXZB+qqH4NuiKugp275a33DM8INOMngySvwrfqwM=;
        b=tx2+VnE7FODWgkoPDjGvJzO5rB9CWHXreNasszjO43njJ0QDVGCkb27k45L4fb93iM
         eXtgnOMr2E4+FC829TqFwWdVBjG9JltQLL9hv7EHk8YgarVyawo7QZCs4ZbtDPSu36eI
         i3wcyOhQg0IPOScPHZvLqAsBTTG7ygHIagRrByWKdV7e4xHUmejLwGHmSzNsYgVpUkQS
         acWzFd7opLmT/8ipmUUd3E6Q5drej9YJrnNibAKVBVJ9QIwquT/CyQ5tBP/RoIonPNLf
         AjXzAd75M64bGEvddFleEK9eDc9AsrEp7wwxxLmkAQom6g5duDZxapzPGeKw1bgVIqcK
         ov2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=32SaXZB+qqH4NuiKugp275a33DM8INOMngySvwrfqwM=;
        b=KowiIiQqTEdNlogjlV9/0pD7POsfxd8vQ+uJeknNMYNdY1oOa594fwMQ3N99YHjcgG
         aNViaj1Cyz0Hppi5SykdMdgHWWboF4XilFa0IBTqhwHN9/0oN0+FXfGKusM3sox4BEBm
         wQq8fQegkfAqu9hJ0ZBOflugmEhJ32Y7phNoQ0lO9YQcNFl8XJ7Yg7l7pRJpeYxoUEjs
         Bl0ItaLcD+CPJJbXG2/gE1RFwB9mb3WsdpMrJ4hrXwtPayr8JviwsV/+DqdPqxKy2Hx6
         pZizGBBlnwalUZusPYohGKI/W/AzaM8ypbXFrIAn2Yxepr7cSKBGUBwzw42Bhq5z0U9c
         9Xbg==
X-Gm-Message-State: AOAM533H4oqmzyNcjYg3PETrXgpJEKI6o5jL1vG1Csote7rO4UD1OxP2
        wMgqbgij1CHzbzqgeXTv+featrdPWDciWYXg
X-Google-Smtp-Source: ABdhPJw0Y0WaznxR1Fui5SyUDpT0qdJJLv+GcxAeOKRQH5V4agQpbf8P+qOdAifYyohK390Q/YxhJQ==
X-Received: by 2002:a17:90b:f10:: with SMTP id br16mr3670243pjb.57.1643119793626;
        Tue, 25 Jan 2022 06:09:53 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n22sm19101806pfu.193.2022.01.25.06.09.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 06:09:53 -0800 (PST)
Message-ID: <61f004b1.1c69fb81.f3727.4214@mx.google.com>
Date:   Tue, 25 Jan 2022 06:09:53 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.225-239-g654885386fee
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 139 runs,
 1 regressions (v4.19.225-239-g654885386fee)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 139 runs, 1 regressions (v4.19.225-239-g6548=
85386fee)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.225-239-g654885386fee/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.225-239-g654885386fee
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      654885386fee8724f0d8c7b190bcaad358ad72f3 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61efcc60d97058eab6abbd3f

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.225=
-239-g654885386fee/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.225=
-239-g654885386fee/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61efcc60d97058e=
ab6abbd45
        failing since 0 day (last pass: v4.19.225-239-g087a7512e40c, first =
fail: v4.19.225-239-gdd903a45b8a3)
        2 lines

    2022-01-25T10:09:18.553395  <8>[   21.150451] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-25T10:09:18.597729  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/108
    2022-01-25T10:09:18.607163  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2022-01-25T10:09:18.620950  <8>[   21.219512] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
