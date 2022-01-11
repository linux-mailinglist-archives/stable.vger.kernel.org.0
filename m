Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF2E748B741
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 20:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243925AbiAKTVf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 14:21:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244124AbiAKTVe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 14:21:34 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C021DC06173F
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 11:21:34 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id pf13so713315pjb.0
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 11:21:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=glW6nMJJ8fXIpv53V14/lSID3RsSMeXaTiw7kNq/UJs=;
        b=Eib1JwDV1iNKB3wUq/2x5Fph17UDVyAUx0S297m4hTtDQj/W5GIDbJrxnWxD2/dN3q
         Ogje7abSUXGoukOrsxi+NYzj3Lu3/RR6+ZOfh+pGmkmJC/s1u0MdAT8FL8IUCoGjS19j
         N+aH7skfnJjDVN/bu8ijboNIu6DqzwQGOl7Jy79jJGznqWG0cRP+FbLuEhPQ7ahPe0BM
         yMM9Nih+Uo1m/yWNzhJP3ZXWfkAvq5g/y0FhXr2jx7E8kr1ZLWIkaJ4gsPrTOwWVkuHO
         MnXhegh42AHqsy1v8jjULvXZG6Rja4OtTC5huK9FN+kofJmRItdM25EIJrqew46iYqcE
         W4nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=glW6nMJJ8fXIpv53V14/lSID3RsSMeXaTiw7kNq/UJs=;
        b=j7M64ZAK4FD72A/ZBwILUPLoOvP+rrmvR5CaOaS5AkMspbN/i4sF6MB64bh1EK0ghh
         PrXPztxbPO2E5peiCXSjgG2IhlaEATGhg265caTj6yWlLYF6nl7sgz3xtvElqhqvQkX9
         bwCrlfmolvisVInc+uhWV8vzgtngRjl13DS2nE0c9mbqyjmr+w/dJsX6s3Fsyev+wCDV
         oj5Cu4XmJq7Yoy1vdj8WwAqfQvF5RFmHsq4KwkV6ihIpxjCJ1W0F7qwNOA1hu4XmKmqF
         JhwGPTQ0EEZFbr0OT4Lk8XOaSeZGswJol7Ogin5REHvBT2VhrEB9oldBrmvMszg494MH
         CSAw==
X-Gm-Message-State: AOAM530WjsgWvIwisX9FtnV2bUMNcrJxmlxFtzCjZWkTipX0wwFussip
        1EddBH3vVBdI3gEKHN9qRZPVNStoeQSVVio2
X-Google-Smtp-Source: ABdhPJyMkyg5nyg0lDbObN0enpJfHMfm0MBtx13wRqReHfTpbYDeUDOvtY+pY2IPCrb87oUhyKKcYg==
X-Received: by 2002:a63:3341:: with SMTP id z62mr5298441pgz.99.1641928894148;
        Tue, 11 Jan 2022 11:21:34 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 20sm3525476pfh.71.2022.01.11.11.21.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 11:21:33 -0800 (PST)
Message-ID: <61ddd8bd.1c69fb81.66e64.9c8e@mx.google.com>
Date:   Tue, 11 Jan 2022 11:21:33 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.14.262
X-Kernelci-Branch: linux-4.14.y
Subject: stable/linux-4.14.y baseline: 129 runs, 1 regressions (v4.14.262)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 129 runs, 1 regressions (v4.14.262)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.262/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.262
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      4ba8e26127c393c32776dff6d79c5b82de6dc542 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61dda05aa22e6318e5ef675c

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.262/=
arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.262/=
arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61dda05aa22e631=
8e5ef675f
        failing since 28 days (last pass: v4.14.257, first fail: v4.14.258)
        2 lines

    2022-01-11T15:20:38.782322  [   19.989898] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-11T15:20:38.825135  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/98
    2022-01-11T15:20:38.834134  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
