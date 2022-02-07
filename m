Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1B44AB63D
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 09:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232683AbiBGID1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 03:03:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243076AbiBGIA4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 03:00:56 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D168C043181
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 00:00:55 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id d9-20020a17090a498900b001b8bb1d00e7so1950196pjh.3
        for <stable@vger.kernel.org>; Mon, 07 Feb 2022 00:00:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KMxbYOX4e3bYqHuFU+GDKza0vnwkfFbcz618yXPGRgg=;
        b=mffZx5jAsBne/RZ7WrzA2bBmn4FseF5LxYLDVoxysFx2xSWIo96tmMxlBn/OHB5grf
         ivCAAfARq71C22KTMdr/xDO4+sdf2tncR0c01bRtKNpVmdABiYc7+7Ja7gYl2NU9wX+W
         OpRuJ+LhijRau7f655cRoCblRUyhADufcos1ABBH3YKZnRsLVI8jWaUQW43esLhTzqgp
         jTenwZVlYnVxcoH0CQisVd2w6rqI0HR6XwxLnyC7+g/2b156UWQmFCI2Xms8MeTIqswn
         dz5hGQq2g/SROcnE32E3GWpYPewxzBhnQrAZmUcTDIKM8Ig6XhyUjmNuJWUU376iXu9t
         tr+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KMxbYOX4e3bYqHuFU+GDKza0vnwkfFbcz618yXPGRgg=;
        b=Jd2/sqTzuPnEh9CNmQdh9858ZvwmWxqTZBdvK67GsRzMBK2JKAL0bX0E90n5it0tX/
         v4zVDVmvwVRQspmHGAzqjHnNOJu/OHJEyxNt5CbjtKlX8ETrnbpf+bzmt6zxfAIGaJ1l
         O+tEJH/gJAerhOVqfd2EbLdhE2mrFQ1IDyfS0T0ThvfDie/1B5wh2t+3rUT4AZUhOtsg
         jd9WcVux7IyrxR4H9Ejas3CmczrGGCistfo2F3IENn2/AA5NIHnt6s6QjXFDmNSszfCG
         4xpjDED73qyD2R0n67EgHOin59qATN8BoOpf9LgBbrzmFxXwXr9vW38Pg48N0Fwzz8ts
         uNWg==
X-Gm-Message-State: AOAM533D6fiC9V/e3QFUxzQadIvSNUZu3BxWd3+5eQ4tuUlEo/4ItWB3
        D4rLiI04Io/5Nsxz8+inqBBIle201C/LjKuC
X-Google-Smtp-Source: ABdhPJy2nxd7c96MPSa68dLieWa7VUEQO+x8TCTBaoJ7SRZl9xq//wxVuoBtQ1OYbSIDjmDKrUiDHw==
X-Received: by 2002:a17:90b:205:: with SMTP id fy5mr8880827pjb.111.1644220855010;
        Mon, 07 Feb 2022 00:00:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d21sm11651621pfv.141.2022.02.07.00.00.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 00:00:54 -0800 (PST)
Message-ID: <6200d1b6.1c69fb81.c9b9.df85@mx.google.com>
Date:   Mon, 07 Feb 2022 00:00:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.264-66-g5c29d837c61f
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 95 runs,
 1 regressions (v4.14.264-66-g5c29d837c61f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 95 runs, 1 regressions (v4.14.264-66-g5c29d8=
37c61f)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.264-66-g5c29d837c61f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.264-66-g5c29d837c61f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5c29d837c61f968f0923ac762748ba0b319cc656 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/62009be95cf510abb15d6efd

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.264=
-66-g5c29d837c61f/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.264=
-66-g5c29d837c61f/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/62009bea5cf510a=
bb15d6f03
        failing since 1 day (last pass: v4.14.264-40-g54996bdd9ffc, first f=
ail: v4.14.264-45-g6b11d619aed4)
        2 lines

    2022-02-07T04:11:02.871859  [   20.315093] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-02-07T04:11:02.914879  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/101
    2022-02-07T04:11:02.923867  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2022-02-07T04:11:02.942570  [   20.383728] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
