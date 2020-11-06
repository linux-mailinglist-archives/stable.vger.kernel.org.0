Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9F2A2A8B57
	for <lists+stable@lfdr.de>; Fri,  6 Nov 2020 01:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732415AbgKFASk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 19:18:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732046AbgKFASk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 19:18:40 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95787C0613CF
        for <stable@vger.kernel.org>; Thu,  5 Nov 2020 16:18:40 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id z3so2686349pfz.6
        for <stable@vger.kernel.org>; Thu, 05 Nov 2020 16:18:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HsMoNU0jA/KwXSuE6zSYIJz79bb/qCofF80W/E4no2I=;
        b=Kjy0tL/22Mfggi8RSpyJfo3rMgrKvT3J90z6QrCeQJSvBEEaTQ3w6gjHsXUQtjTw0D
         VQ20JduVeeY/l7y4kdilG8DNSrIiSlRJc7xYjgC1wauipsfabWxXAynVAc4VJ+1slWeZ
         M4bIanchxm+14g2hvh4bjydmbgjF9vLF1sk1p2Qg8+hGpTL3VQ3377M63/1iX0caYyFW
         MHAsgQTnX4809kxqTU7sTsbZHVJkgHmwqVj253EewcOnDuVFgK34vMsZm9jWpeW9eyWj
         I4hp4mabo4IRmrNn/uCrcjPQWJhvOM86VfPqIbIhEY2nRwT6oJBfh2eWkap9DF9H9vKf
         FEkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HsMoNU0jA/KwXSuE6zSYIJz79bb/qCofF80W/E4no2I=;
        b=qam7wCR2HXDKUXEx7hkxr1y+iDydlahL7Z4EWTCiBMo/XIh1AfdMKAndpOk7vTPknx
         huzV3QFUlv+IG3qQs6Jsu3tyw2+rlwY4REJvCJmqtNAZaDSVPgtmt6nlZQYipwI2l7ZW
         bp2ormfceYaKBAxsXkbOsauzaI5qP1FOOUtUyJnaEWSIiPGVyFFbJPvBan5+K9sSr0XU
         66nn7vmeyXS6XbbCf0YMbiAc/Ekt2t8XKOLEbNw1UVDIUIF5r57DkdXLxml8mMNqP/lx
         QaETTFeLdT1AENaXfWw35Ck1GyClrwnyYSG0eEvroVMz1OB1UlzduDSp7YWFbnJHiFt7
         IokQ==
X-Gm-Message-State: AOAM5320Db9RDBcSJKcS/sTOEoZb006YIGYtqn6mL0JdGdPrbbl+aJl6
        KWEllaovvdwOrKWC3+Hmz/Nti3JbmBXiUA==
X-Google-Smtp-Source: ABdhPJzzzsBFi/Dp/ryn5TdTuv4EE37UCKkb+sFjmkPEP7JLcGrxzqcHesML/CfRdBIC1G0W+QHsMw==
X-Received: by 2002:a62:5f83:0:b029:18a:e039:4908 with SMTP id t125-20020a625f830000b029018ae0394908mr4973474pfb.23.1604621919735;
        Thu, 05 Nov 2020 16:18:39 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x123sm3933963pfb.212.2020.11.05.16.18.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 16:18:39 -0800 (PST)
Message-ID: <5fa4965f.1c69fb81.c39e8.7d9f@mx.google.com>
Date:   Thu, 05 Nov 2020 16:18:39 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.241-91-gd58d4144209f
Subject: stable-rc/queue/4.9 baseline: 143 runs,
 2 regressions (v4.9.241-91-gd58d4144209f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 143 runs, 2 regressions (v4.9.241-91-gd58d414=
4209f)

Regressions Summary
-------------------

platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
at91-sama5d4_xplained | arm  | lab-baylibre  | gcc-8    | sama5_defconfig  =
   | 1          =

panda                 | arm  | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.241-91-gd58d4144209f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.241-91-gd58d4144209f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d58d4144209f4e8e4513b11fa55a55ef4006785c =



Test Regressions
---------------- =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
at91-sama5d4_xplained | arm  | lab-baylibre  | gcc-8    | sama5_defconfig  =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa4631aec372fd914db8867

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-9=
1-gd58d4144209f/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-9=
1-gd58d4144209f/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa4631aec372fd914db8=
868
        failing since 7 days (last pass: v4.9.240-139-gd719c4ad8056, first =
fail: v4.9.240-139-g65bd9a74252c) =

 =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
panda                 | arm  | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa4630043d8c70ba4db887d

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-9=
1-gd58d4144209f/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-9=
1-gd58d4144209f/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fa4630043d8c70=
ba4db8882
        failing since 1 day (last pass: v4.9.241-91-g303dfca2bd68, first fa=
il: v4.9.241-91-g387309f11ff9)
        2 lines

    2020-11-05 20:39:24.492000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
