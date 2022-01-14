Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDD6E48F1D1
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 22:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiANVFx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 16:05:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiANVFw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 16:05:52 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82E7CC061574
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 13:05:52 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id i30so3697071pgl.0
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 13:05:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CEFlNCCdOG9tSB0hYKFSnmukCtU9qNXrUQ/aBgJC7T0=;
        b=XUSpfXP4IKBlwj2ahdujhLaj9yF0yLvSwH2OCcHWQrgnTHSQSn9ex8jLzwAosFLQSp
         Wo3m+scYizMGuv1BLWoD1o5ukPhl54uLyV6PIRKiscsLAdTmMpTjSKpot+VUocGHxsio
         sI7rI4OogThQjnQC4W8fHEOPTvlfqxnONgFP97H7HLeM3qyrDGzKGFGU3bSdROe3ldyz
         3UZlbnRRQ0lJKJOTacDVsEdg2nn5Ry0s4D2VQL641uAfqH0lT4h6nKb5pGHPxOGRneag
         yUAQGC9VJvSF8imRILwJ3lOvjWyK33s4z/zxzVboC2x+5OsDihZfAUviqpj2muC9FSdU
         gz4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CEFlNCCdOG9tSB0hYKFSnmukCtU9qNXrUQ/aBgJC7T0=;
        b=esTthVqEZ1gBueomZIs5Zyttkfdyl25UwTjt9FUpJNX0t1lV4TS61irnsTTydZl4Hi
         vdeiSGAcbNZvk8fQQ2TweUAvomMWUCcru35VXkp0bdMjUGn3mAjwjOmg14X2Q+QVEUYM
         Q8Q/EeawEm19GMeHb7xb/RH7orBtX8FZeR9xc1mcF9EV6g056bv//rqtS6cp0WKKaOO2
         Ltkifhf5nmbXx7L9WbKhwAjQbiY+xKssN72wY0Lt5mKQ8WAEBUu1WiRdbX5/KpsxADkf
         wGZyhU7UYiX+Hurm5ZpGM5lcTcG2G14RbMqFTq3EDunwPe3zyuEofviW45n5HcnD2Kdb
         bayg==
X-Gm-Message-State: AOAM5300P1F/zSh26+8XeTc7/rbuM5QOneLp5P/9VQVgjiq2rRE2SP8D
        x0e2n+G6vhRmi54bowaQzXAuglK5E3bJ8CgP
X-Google-Smtp-Source: ABdhPJxOFke7FSsoiErwVHomiVHFO3+SDdGp4r5oVbzjXeOUDRr9cPHlt8lOSBSDiZffFb/7dkUfWg==
X-Received: by 2002:a65:6a8c:: with SMTP id q12mr9634051pgu.314.1642194351788;
        Fri, 14 Jan 2022 13:05:51 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f11sm5200734pgb.43.2022.01.14.13.05.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 13:05:51 -0800 (PST)
Message-ID: <61e1e5af.1c69fb81.59cf.f35b@mx.google.com>
Date:   Fri, 14 Jan 2022 13:05:51 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.297-10-ge7d7a9ec7c46
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 95 runs,
 1 regressions (v4.9.297-10-ge7d7a9ec7c46)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 95 runs, 1 regressions (v4.9.297-10-ge7d7a9ec=
7c46)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.297-10-ge7d7a9ec7c46/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.297-10-ge7d7a9ec7c46
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e7d7a9ec7c46cc274cae2ac741113681aaa77f3f =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61e1af4e8325a13e37ef6777

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.297-1=
0-ge7d7a9ec7c46/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.297-1=
0-ge7d7a9ec7c46/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e1af4e8325a13=
e37ef677a
        failing since 3 days (last pass: v4.9.296-21-ga5ed12cbefc0, first f=
ail: v4.9.296-21-gd19aa36b7387)
        2 lines

    2022-01-14T17:13:32.275659  [   20.316101] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-14T17:13:32.318199  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/122
    2022-01-14T17:13:32.327197  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
