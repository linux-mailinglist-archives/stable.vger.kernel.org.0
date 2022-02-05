Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A20644AAA29
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 17:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349051AbiBEQ1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 11:27:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbiBEQ1I (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 11:27:08 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0063C061348
        for <stable@vger.kernel.org>; Sat,  5 Feb 2022 08:27:07 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id f8so7719126pgf.8
        for <stable@vger.kernel.org>; Sat, 05 Feb 2022 08:27:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=afB8giNZwY3paG5ldjCASLx9esvxVl8fXK/h4z7sMS8=;
        b=zBEkfSdfXYMHMHlf9PrdnNnh3CTWPZUa43eJoLMx87jEU/PQ9HFi6km6qZCypg76Ik
         RLCi0+L7xli+rNN3Q+KXTbtd299nZd1H/UmU3pGVgTBFXgkhW5U7/fIab5EndKocD6/D
         54BynkFnr9KfNKoGUukgABRzCMMZ7TfO/53F4ltFYhoJS83eWHZMTjq54ZprepcIBEhY
         l4fRaGhTJpq1tObXDYUSJI8/KoVr6WWjBQr4PjQsSLOlwo7nukFv7U/7tl40MW6Ol45B
         hHHug7yBqhHlX85c00nUNO3eAMY3C/BvHJ7ZlZFvyi8wFBomHf70O5w6eOfcGNtxUG7m
         U5nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=afB8giNZwY3paG5ldjCASLx9esvxVl8fXK/h4z7sMS8=;
        b=j60aBk2Kp1s1O6yte2czYu5iO533UCX9FePsYvfWgPfuwO7c9iOBlAwmSUyVKwoSzL
         BkhgPXfCq6hR295BbyH0Wo4H1Hv+rM5AqOqENpgdWxEjf4GoGAkCMBKjV5svGh7JRFAF
         ijtxlhmxzR441ghwhGPFR7nronMBbJSd3I171cSkHkadC2Mq64uRK41zr1ylqaQRwKsC
         /i0bsHlD0/e+A3oNyA5tIJP/reng5vU6Wqih5qF+KIwDTrm49V3bn84soLqg6UbAlZ78
         /0eSnrUBgJLGamPYRZECADchT8KbMRYmHl+H//weXLFFBeVt5tBtJisZlZHEHQ02B/Mi
         ioJg==
X-Gm-Message-State: AOAM5321DRPs/j0qCf3uUM3x6Yct99OIbVcTmw0cU1VveEgrNeOyH/zZ
        c+DFUnlAiSx9ecdt6e10jT2WDRJk1Xicju7N
X-Google-Smtp-Source: ABdhPJzcbYBDPNEtRiYEbBto5bnVbPuUHvoOfdSlo7aWKcwzq8eflX11OLFk9NV6Ooxbss9kiwroNA==
X-Received: by 2002:a63:33c4:: with SMTP id z187mr3372937pgz.474.1644078427028;
        Sat, 05 Feb 2022 08:27:07 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h11sm6078769pfe.214.2022.02.05.08.27.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Feb 2022 08:27:06 -0800 (PST)
Message-ID: <61fea55a.1c69fb81.71fc.019f@mx.google.com>
Date:   Sat, 05 Feb 2022 08:27:06 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.227-53-gadd784045dd3
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 136 runs,
 3 regressions (v4.19.227-53-gadd784045dd3)
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

stable-rc/queue/4.19 baseline: 136 runs, 3 regressions (v4.19.227-53-gadd78=
4045dd3)

Regressions Summary
-------------------

platform   | arch | lab           | compiler | defconfig             | regr=
essions
-----------+------+---------------+----------+-----------------------+-----=
-------
da850-lcdk | arm  | lab-baylibre  | gcc-10   | davinci_all_defconfig | 2   =
       =

panda      | arm  | lab-collabora | gcc-10   | omap2plus_defconfig   | 1   =
       =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.227-53-gadd784045dd3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.227-53-gadd784045dd3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      add784045dd351adb0e1c8f510d17a5f30e3d75b =



Test Regressions
---------------- =



platform   | arch | lab           | compiler | defconfig             | regr=
essions
-----------+------+---------------+----------+-----------------------+-----=
-------
da850-lcdk | arm  | lab-baylibre  | gcc-10   | davinci_all_defconfig | 2   =
       =


  Details:     https://kernelci.org/test/plan/id/61fe6bcc6fa7f9e9205d6f1d

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: davinci_all_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.227=
-53-gadd784045dd3/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-da=
850-lcdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.227=
-53-gadd784045dd3/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-da=
850-lcdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/61fe6bcc6fa7f9e=
9205d6f24
        new failure (last pass: v4.19.227-48-g5372ecaaa6cf)
        6 lines

    2022-02-05T12:21:18.929086  kern  :alert : BUG: Bad page state in proce=
ss swapper  pfn:c3000
    2022-02-05T12:21:18.929311  kern  :alert : raw: 00000000 00000100 00000=
200 00000000 00000004 0000000a ffffff7f 00000000
    2022-02-05T12:21:18.929484  kern  :alert : page dumped because: nonzero=
 mapcount
    2022-02-05T12:21:18.929635  kern  :alert : BUG: Bad page state in proce=
ss swapper  pfn:c3400
    2022-02-05T12:21:18.929780  kern  :alert : raw: 00000000 00000100 00000=
200 00000000 00000004 0000000a ffffff7f 00000000
    2022-02-05T12:21:18.929924  kern  :alert : page dumped because: nonzero=
 mapcount
    2022-02-05T12:21:18.965793  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D6>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61fe6bcc6fa7f9e=
9205d6f25
        new failure (last pass: v4.19.227-48-g5372ecaaa6cf)
        4 lines

    2022-02-05T12:21:19.103972  kern  :emerg : page:c6f49000 count:0 mapcou=
nt:-128 mapping:00000000 index:0x4
    2022-02-05T12:21:19.104195  kern  :emerg : flags: 0x0()
    2022-02-05T12:21:19.104363  kern  :emerg : page:c6f51000 count:0 mapcou=
nt:-128 mapping:00000000 index:0x4
    2022-02-05T12:21:19.104513  kern  :emerg : flags: 0x0()
    2022-02-05T12:21:19.170871  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Deme=
rg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>
    2022-02-05T12:21:19.171089  + set +x
    2022-02-05T12:21:19.171259  <8><LAVA_SIGNAL_ENDRUN 0_dmesg 1501286_1.5.=
2.4.1>   =

 =



platform   | arch | lab           | compiler | defconfig             | regr=
essions
-----------+------+---------------+----------+-----------------------+-----=
-------
panda      | arm  | lab-collabora | gcc-10   | omap2plus_defconfig   | 1   =
       =


  Details:     https://kernelci.org/test/plan/id/61fe6d41fe083eecdf5d6eee

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.227=
-53-gadd784045dd3/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.227=
-53-gadd784045dd3/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61fe6d41fe083ee=
cdf5d6ef4
        failing since 3 days (last pass: v4.19.227-45-g1749fce68f74, first =
fail: v4.19.227-45-g388e07a2599d)
        2 lines

    2022-02-05T12:27:16.058539  <6>[   20.885101] [drm] Cannot find any crt=
c or sizes
    2022-02-05T12:27:16.075170  <6>[   20.894714] smsc95xx 3-1.1:1.0 eth0: =
register 'smsc95xx' at usb-4a064c00.ehci-1.1, smsc95xx USB 2.0 Ethernet, ca=
:b3:cc:10:05:c5
    2022-02-05T12:27:16.082050  <6>[   20.907104] usbcore: registered new i=
nterface driver smsc95xx
    2022-02-05T12:27:16.092786  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/105
    2022-02-05T12:27:16.102632  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
