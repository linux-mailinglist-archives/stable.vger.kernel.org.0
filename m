Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9E192A8920
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 22:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732035AbgKEVdo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 16:33:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732504AbgKEVdm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 16:33:42 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC655C0613CF
        for <stable@vger.kernel.org>; Thu,  5 Nov 2020 13:33:41 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id w4so2231908pgg.13
        for <stable@vger.kernel.org>; Thu, 05 Nov 2020 13:33:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gwY0l0Tt7Px/u7S01YjMuZXNOebP/O7TmSRX6lEIEMQ=;
        b=cieqg++ArQSPuIqQAv3gticfh7CT4rv2SfBBaiDtcxZVfoGSs4wju3i9ErvOybXuL7
         Zf8vHd8vU3HNPwggeA1Q9H+okwmCRgHDhYIaXrUb+eVzwEFnQyzNXBiwBQ1wilQwKVnm
         qbuDXmQVEcTS9cfgX99x2FKKwSwMbLSicxRAxXhoS9MrNIRSQfJ0YN7JW317cszVamd/
         u5VyG8kBA+eaSeFIZ+i3vjQsaffpY0lnpPC7zEYQw4Kda8pvoXmCKYvrw/aA9kpRk+r4
         OwSzfkPWRShEUzSWKQLuSCLfrFqM9T1NLtZmL7cVlthRNt/svBam2cioCwC4VIMjKzXP
         PNbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gwY0l0Tt7Px/u7S01YjMuZXNOebP/O7TmSRX6lEIEMQ=;
        b=oTld3hyyEmEmvUzpsJD3duOnS/OZ273RkQlnmxiB5xAelNL9rTbvkXjGjgowU+ttLJ
         0heGIFiI4h+Wn8krXnqzorQwcqP2PrETYJ0miUh2DIdTfMUkG2B/Zy8454EX6CM93Kw9
         aaeLyD1Ehwzwr9kjOwV16qz/o5rompFCC7c+NPvbsR1D0AaxMj5e4h+PmUxYdb2RnDci
         v7nwM10Uj/Lv5mqy9C3cWQqPiwUC9EpmfpTsqGZ1GtRiVZWlLA8oQDLCHUbOGjGhKOx9
         ukd1mErV25KW4SIX25JwLjsTG3rlp/yBlwwARnqum5nMMoyakdsjCnv+Bc/pLkS48tkU
         MiRQ==
X-Gm-Message-State: AOAM532a2pPVZE3p5QoeDoLaJvpExZNZ+MLoSfaBKhyMM3hWle++PAsQ
        HqBJSubdy+G4dtMqFLmqcmN2AkvFejVbpQ==
X-Google-Smtp-Source: ABdhPJzwQPNFxwQSD/+wPmmuabEzSxqxK/uakXJ2jEP/m4tOUf0PU3q+0Eb5hR/xYMJuaao2O70SyQ==
X-Received: by 2002:a17:90a:4fc3:: with SMTP id q61mr1511836pjh.145.1604612020970;
        Thu, 05 Nov 2020 13:33:40 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c127sm3484626pfc.115.2020.11.05.13.33.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 13:33:40 -0800 (PST)
Message-ID: <5fa46fb4.1c69fb81.647c1.6cd4@mx.google.com>
Date:   Thu, 05 Nov 2020 13:33:40 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.75-3-g2c2cf8e6c77dd
Subject: stable-rc/queue/5.4 baseline: 210 runs,
 2 regressions (v5.4.75-3-g2c2cf8e6c77dd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 210 runs, 2 regressions (v5.4.75-3-g2c2cf8e6c=
77dd)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig         =
 | regressions
----------------------+------+--------------+----------+-------------------=
-+------------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig   =
 | 1          =

stm32mp157c-dk2       | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.75-3-g2c2cf8e6c77dd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.75-3-g2c2cf8e6c77dd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2c2cf8e6c77dd5b10b5405075192199960140b69 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig         =
 | regressions
----------------------+------+--------------+----------+-------------------=
-+------------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig   =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa43d96cdf4e38ed5db885e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.75-3-=
g2c2cf8e6c77dd/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4=
_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.75-3-=
g2c2cf8e6c77dd/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4=
_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa43d96cdf4e38ed5db8=
85f
        failing since 7 days (last pass: v5.4.72-409-gbbe9df5e07cf, first f=
ail: v5.4.72-409-ga6e47f533653) =

 =



platform              | arch | lab          | compiler | defconfig         =
 | regressions
----------------------+------+--------------+----------+-------------------=
-+------------
stm32mp157c-dk2       | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa43d50098081a8f0db8877

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.75-3-=
g2c2cf8e6c77dd/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp15=
7c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.75-3-=
g2c2cf8e6c77dd/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp15=
7c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa43d50098081a8f0db8=
878
        failing since 10 days (last pass: v5.4.72-54-gc97bc0eb3ef2, first f=
ail: v5.4.72-402-g22eb6f319bc6) =

 =20
