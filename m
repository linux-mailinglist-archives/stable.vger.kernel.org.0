Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18CDB4AADB6
	for <lists+stable@lfdr.de>; Sun,  6 Feb 2022 05:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbiBFEfk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 23:35:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiBFEfj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 23:35:39 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3354C06173B
        for <stable@vger.kernel.org>; Sat,  5 Feb 2022 20:35:38 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id s2-20020a17090ad48200b001b501977b23so17012863pju.2
        for <stable@vger.kernel.org>; Sat, 05 Feb 2022 20:35:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GmPTXWQPNKXlJfvGLBA5wqMbkR2IUuCI8SM3/QXmppQ=;
        b=ci6OqsSK3f2XXBPWwJWXvr/wHyL4oqGC082w0IxuRS4AEnmdKjtfVs30QwDHy1IaGF
         +bzrLXyHzbQeRA9uYvgm/sXHUehb9Gw1SYeqUp3/o/6C1Vmml82IDVCIFUDrdQqip3P6
         FmbaZoMwYyK/syixoE3Q+Hav2HuPoVVbkdVdL/EqQVaVf6vrLTGxNveMV30LCViNdPmn
         RJQuQl3738njvBU/hLpterWIv0VzD2Ku1ttaoF9cUvJJx4H/JxqLbdTL1pK6SqU5ZBWP
         vSJGEVoWoYAzx72UKVzVEUd8P9kxLp+U8+HStSpu5ZS6Ux0HCyV8uevlihjjqcb4Dny/
         0dpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GmPTXWQPNKXlJfvGLBA5wqMbkR2IUuCI8SM3/QXmppQ=;
        b=o5ZXSlg1b/jaeBUL0PkwNjSeczW1lIC5gqK3V/wwVQVaSWAROlT8V/xDgwuaUhS2Ll
         b5ZV3eBCtK/2ejCqSL8R7gwFJoaLC7+GxJSeGHJv2oJns3t1xkRM6QuLnJ1IxHYjVB3a
         PN7gvI4PApYL1/Xi2thAcBuvA21qnET0J1/I0HB+Yn/+G+49yLBSiYDsWFIOUtwnNKEY
         /nYAxTlX1g2Atoh+K4e/GgEBcnsTnlMrC4uGQ3XdMkU9gYMbPVBv8fbn5WJqnxYjWj1k
         SL4P4KiME100zgWi0SzB+P9NbsBVo+K7PQDUqNNYD/B8wdWW46+D21oo6zV5JCP7+Gdb
         Vm5w==
X-Gm-Message-State: AOAM531IeTTUJAZTJx7ZgXBfxX0Utf86hM8nfWx7wl39/WFVI58C/dYz
        /J8Jj/Mx7MB66m254S2bYTiMzNsZjT9UsgTk
X-Google-Smtp-Source: ABdhPJwEnTLf31ThRq15M8l+R2bIGDdj4HqIEbxIjxFtNuUYh2HfL/VKbIw7wibqlRoGsgE5RHHc4w==
X-Received: by 2002:a17:90a:15cf:: with SMTP id w15mr7308282pjd.79.1644122138164;
        Sat, 05 Feb 2022 20:35:38 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id om18sm6665108pjb.39.2022.02.05.20.35.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Feb 2022 20:35:37 -0800 (PST)
Message-ID: <61ff5019.1c69fb81.c325d.1526@mx.google.com>
Date:   Sat, 05 Feb 2022 20:35:37 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.299-36-gc1de43ee78a4
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 64 runs,
 1 regressions (v4.9.299-36-gc1de43ee78a4)
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

stable-rc/queue/4.9 baseline: 64 runs, 1 regressions (v4.9.299-36-gc1de43ee=
78a4)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.299-36-gc1de43ee78a4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.299-36-gc1de43ee78a4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c1de43ee78a442882ed33a2f8cd5e16e14219ee7 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61ff18780b3c3ce8f55d6f63

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.299-3=
6-gc1de43ee78a4/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.299-3=
6-gc1de43ee78a4/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ff18780b3c3ce=
8f55d6f69
        failing since 4 days (last pass: v4.9.299-13-g3de150ae8483, first f=
ail: v4.9.299-25-g8ae76dc07a67)
        2 lines

    2022-02-06T00:37:54.591558  [   19.792510] usb 3-1.1: New USB device st=
rings: Mfr=3D0, Product=3D0, SerialNumber=3D0
    2022-02-06T00:37:54.618626  [   19.822509] smsc95xx v1.0.5
    2022-02-06T00:37:54.634332  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/128
    2022-02-06T00:37:54.643403  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
