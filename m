Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64AC34AAD73
	for <lists+stable@lfdr.de>; Sun,  6 Feb 2022 03:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234916AbiBFCJM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 21:09:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232151AbiBFCJL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 21:09:11 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3459C043186
        for <stable@vger.kernel.org>; Sat,  5 Feb 2022 18:09:10 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id h12so9351417pjq.3
        for <stable@vger.kernel.org>; Sat, 05 Feb 2022 18:09:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2IsPqTgFNzV1yLzOHpefa67JA/yUm7gjro1PuN7I1Qg=;
        b=8PIex9byov6mCQpOv0X2yCFbB2y8U3XHyvWapqQwFgk4n6kLB7A78PAv4hHxnHZsDZ
         WWG6UkC2fps7xbqouDFhBZOc2uLvBEi6c16j0NOgSzvPzwh0dLrlYq7gTntMwUl9Vyd8
         uaQE53hsWW1b2z9cGuOJuKuafRkTXk0r5g2q9RprjRbr21Wf7dZ3CjsNTv6gNJiKZiZx
         GFrdlIvzbc6JqwJAIZQkWp0mftzzw5SZLDWmp4D5N2FCtwQWPKIScPqdOlEYh/iaenPF
         zoQQcblmCYCDZXIp5n32oeXxyBKNHWT6EKMNzpjSqxaaqQ2hf3CJWzUDRY0wlUfIi2sM
         WxBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2IsPqTgFNzV1yLzOHpefa67JA/yUm7gjro1PuN7I1Qg=;
        b=qKjDND8O1ux84rgRd8oTZZZF0k4tGkHqcfZTnQMZ5chRUcXWN3P4sQhcVpDiBCA57p
         Sji/spa9X99dLZeh2ccgwrzUeZg4oDeLspbjmQwfAEO1hgoEj+A6Vp4miAi/XxbNSp5h
         1UHz5rBn2HY22TvjzI61Xf1r7l8la6nnc0CUZrBzBuqinuLn66BRR2aDNM2UnG3ddZmF
         7BjsYivPvErcXnPi1prjzp/fHkmlOQt2rToqpZ7nF3OEO1Ih4HDbD4QSI0qTB4XO6E9p
         /jplZHkcdKTaH7iYfWCFPOZcolY9eqb/xDMS86DAFsoj+5q2p4PIbPfyZlE4cAIEL2U6
         vaMw==
X-Gm-Message-State: AOAM531QZznGTrYzQ5gvdQ7GTzbbVjIhhWJrpAMywH/xD7JKpKqXwrY1
        0GXPkNh/0ZVAdRtKUqK0yqZo3qCvL9wtpIFx
X-Google-Smtp-Source: ABdhPJx9mDuOkooQJ2h/DDadElxYG/qbx4/xewWTTP9HiEsRV7osuoUm18cxEqIJk2yMF06dSt+DEA==
X-Received: by 2002:a17:90b:1e06:: with SMTP id pg6mr6988698pjb.4.1644113350322;
        Sat, 05 Feb 2022 18:09:10 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id oc17sm19575046pjb.12.2022.02.05.18.09.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Feb 2022 18:09:10 -0800 (PST)
Message-ID: <61ff2dc6.1c69fb81.9dcaf.1c4f@mx.google.com>
Date:   Sat, 05 Feb 2022 18:09:10 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.299
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 145 runs, 1 regressions (v4.9.299)
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

stable-rc/linux-4.9.y baseline: 145 runs, 1 regressions (v4.9.299)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.299/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.299
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      224d99f50f25ec3234b99556c0076a7130e230c6 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61f5531160f12348e7abbd3a

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.299=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.299=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f5531160f1234=
8e7abbd40
        failing since 26 days (last pass: v4.9.295, first fail: v4.9.295-14=
-g584e15b1cb05)
        2 lines

    2022-02-05T22:08:58.194337  [   20.037658] smsc95xx 3-1.1:1.0 eth0: reg=
ister 'smsc95xx' at usb-4a064c00.ehci-1.1, smsc95xx USB 2.0 Ethernet, 2e:de=
:de:f8:85:6d
    2022-02-05T22:08:58.201107  [   20.050170] usbcore: registered new inte=
rface driver smsc95xx
    2022-02-05T22:08:58.233395  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/122
    2022-02-05T22:08:58.242863  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2022-02-05T22:08:58.260050  [   20.106567] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
