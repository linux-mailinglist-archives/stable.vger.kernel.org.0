Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94F3E44EBF7
	for <lists+stable@lfdr.de>; Fri, 12 Nov 2021 18:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234572AbhKLR3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Nov 2021 12:29:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232231AbhKLR3r (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Nov 2021 12:29:47 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 159D6C061766
        for <stable@vger.kernel.org>; Fri, 12 Nov 2021 09:26:57 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id x7so7264273pjn.0
        for <stable@vger.kernel.org>; Fri, 12 Nov 2021 09:26:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lFxY7XTL1hQtCUd0I+FFLXep/SCMsTQy0pWvjx1zCaM=;
        b=ac991FZmyG7yzDp+CwhbT2xIN68/+OcWsplEc7I7idy3Je43TcSkJrWgtgnTlMBTZg
         tQnykJyj6Jh8nfWQGDq9Ql5BG6LdZpj5lX9PUYZLnmD+/KAj/Gu3nOuu0niHjJqv0oqp
         jr/sIhR7HyZTN8g80iWKP3GkSfM7ELsTZwLAYtBR+74YUpddd8V7sxNeQPPX6kVfAYYz
         Gt43cSkpz4rQPRnWDZtbDaGZxSLLLXPpTsmtdB0tkNSIsYVaIaDyHJgpZhoKcsmm7hFQ
         25ZXVc+guxJ8Lpczqh44A3h6W3uf/HnWWrDEvIrjpgYR0tRiZAuMMKqwbacVidP9Xi7Z
         tvDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lFxY7XTL1hQtCUd0I+FFLXep/SCMsTQy0pWvjx1zCaM=;
        b=RB4XIJv7AclNVtiBGFLmN8yR/fZq+H9qHC+0JQFmSkQvXvLoNndR8P9z9mQ/7O1E+C
         pcaidtUt/gy+HNLN0BcfCSsphG/66qU27qcWCu/RzWtGyyhJePw5HeiaxZHZKK8i780h
         QZLoyjgwE6LBQTnVswU1D0RjavgYUq9jWjwLAWXCUdNDo7+x8JZN6V/i6/QeJtN5RSvM
         Jdp8kA+9z5eJ47X7+rNgRLMtdjXnf6Kn9pwHLySJds256oCItwy4os2/CwPknQchNO8c
         aXgiy6j65uaAA/OhkCmRlMPCyr7DslMIel5fy1UgJ4EtUovw3it2MEstQGuPxjNZ0wbf
         Cr/Q==
X-Gm-Message-State: AOAM5320E8DVtf2h7ORB3cg6s8Se6vkpvBi3dQAW2zr8WDsAYTIZAeDK
        hMQhEI40lGNiQ8ezB55pkGRCZ20FA694MdOD
X-Google-Smtp-Source: ABdhPJwikXECiA+yKbQzPfRZjR/rxR6YpvVtnEXCPiqvajImMl/vrDGOgZlhLTbDPV1mj1CNKS8CZw==
X-Received: by 2002:a17:90b:1812:: with SMTP id lw18mr19754989pjb.196.1636738016442;
        Fri, 12 Nov 2021 09:26:56 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m12sm5728118pjr.14.2021.11.12.09.26.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 09:26:56 -0800 (PST)
Message-ID: <618ea3e0.1c69fb81.301be.0a44@mx.google.com>
Date:   Fri, 12 Nov 2021 09:26:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.216-16-g939af1e9357c
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 132 runs,
 2 regressions (v4.19.216-16-g939af1e9357c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 132 runs, 2 regressions (v4.19.216-16-g939af=
1e9357c)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 2       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.216-16-g939af1e9357c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.216-16-g939af1e9357c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      939af1e9357c0d1754d5394c207377a97d4ac5d1 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 2       =
   =


  Details:     https://kernelci.org/test/plan/id/618e68dec7dd4b7a7e335900

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.216=
-16-g939af1e9357c/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.216=
-16-g939af1e9357c/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/618e68dec7dd4b7=
a7e335903
        failing since 1 day (last pass: v4.19.216-7-ga721c571705e, first fa=
il: v4.19.216-7-g1cf3c1269574)
        2 lines

    2021-11-12T13:14:55.552008  <8>[   21.661193] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D3>
    2021-11-12T13:14:55.597627  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/102
    2021-11-12T13:14:55.607781  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-11-12T13:14:55.621512  <8>[   21.731323] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/618e68dec7dd4b7=
a7e335904
        new failure (last pass: v4.19.216-16-ge7c4b3bfd26d)
        3 lines

    2021-11-12T13:14:55.478865  <8>[   21.587707] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcrit RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-12T13:14:55.526519  kern  :alert : Unhandled fault: imprecise e=
xternal abort (0x1406) at 0xb6f3a898
    2021-11-12T13:14:55.529487  kern  :alert : pgd =3D (ptrval)
    2021-11-12T13:14:55.533084  kern  :alert : [b6f3a898] *pgd=3Dbc1fb831   =

 =20
