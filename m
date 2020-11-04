Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06F782A668D
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 15:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730045AbgKDOkr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 09:40:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729662AbgKDOkr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 09:40:47 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 768B2C0613D3
        for <stable@vger.kernel.org>; Wed,  4 Nov 2020 06:40:45 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id i26so16768941pgl.5
        for <stable@vger.kernel.org>; Wed, 04 Nov 2020 06:40:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bfl5BcBuykkprbNuduozgt6O4TCIOVifRHzF+w8uUk8=;
        b=SNYVmLk7kmTopCsVsjlXcHWyC/09dSX0r9q663I5RIWvxrin/Hn0GbtXA6th4/HqIT
         cAfxs8m/Ojuh3BknkEpvdqy8jwHp+P+mP0LYnBQG45PgarnBFymaukYoxxwkhae7Qov3
         +YKv92lM6vTaIQEdKtnRDSDm8SRtb+6SGyS/efxnvv483VmbDk+P0YcTnwU/sllR3ycu
         Yig0ENcur5BH59nvLQayJnWJtl89MUNiD8bhewdf+GWkKF+YGpzeX/Zn1QU02buGrbca
         jQ4EyBvD0pSv0QDz2KWZwJxuuoHII1b+ePiRQg9JsJ0SQrX4n+1PfjnQiC8FnPWiqeRK
         Sdgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bfl5BcBuykkprbNuduozgt6O4TCIOVifRHzF+w8uUk8=;
        b=SpGo0SNrCeZxanKlLWPUMaeuUrc2dK/Hc4aOPs1kq9ShtERGOglxfz+WYQcNDztiCq
         eZ22VUVUPIwTFbJ4thauw/Zbo2aXAh8/qJVVuwMQiJ8Q22P8OExDhCR0PPVbkYvxKnUF
         SjfaT/eHW+jSSCXomWMnR7qpvBeEEbuNZS9ZQ/o3gBppkoD66JnJ2JUnOaZ60Orpdr0B
         UCA1RQOAfjRzjOAtubZhYVtJj57cS8nHBUHeW4KJNVt5oTXen+a6UCNnCqwGvOGUxM+r
         2h2M5VmjciQhdWTgQPHpZ5mM4Vogu9jSRAfBeH62agG/wr9xWIVUGrz8gNqA1kfBvYVa
         rdGQ==
X-Gm-Message-State: AOAM530XlIGDRIx9Q/TYZoDFWRJ8rQkpV9eD7DUhj2yds1flc7y165uu
        iQa/mSlyXnOQ2cADcdZ7Bc7Wtelp2+pV3w==
X-Google-Smtp-Source: ABdhPJxPeLuhhY9Fuj1W/DkZHxVRTE94UrkdQ5W14KZzklys7nfbjngV4ag3fBX6BRxUnvlvC9rS3Q==
X-Received: by 2002:a62:62c2:0:b029:164:563a:b2c with SMTP id w185-20020a6262c20000b0290164563a0b2cmr29870997pfb.16.1604500844668;
        Wed, 04 Nov 2020 06:40:44 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id kr14sm2465779pjb.26.2020.11.04.06.40.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 06:40:43 -0800 (PST)
Message-ID: <5fa2bd6b.1c69fb81.ac13f.59e6@mx.google.com>
Date:   Wed, 04 Nov 2020 06:40:43 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.241-65-g14295e030b41
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 129 runs,
 2 regressions (v4.4.241-65-g14295e030b41)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 129 runs, 2 regressions (v4.4.241-65-g14295e0=
30b41)

Regressions Summary
-------------------

platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1      =
    =

qemu_i386 | i386 | lab-baylibre  | gcc-8    | i386_defconfig      | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.241-65-g14295e030b41/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.241-65-g14295e030b41
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      14295e030b41db1fee3a1b5df6bbb916d7bd23d6 =



Test Regressions
---------------- =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/5fa28c0ae518b0e737fb5339

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-6=
5-g14295e030b41/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-6=
5-g14295e030b41/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fa28c0ae518b0e=
737fb5340
        failing since 2 days (last pass: v4.4.241-8-gd71fd6297abd, first fa=
il: v4.4.241-10-g5dfc3f093ca4)
        2 lines =

 =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
qemu_i386 | i386 | lab-baylibre  | gcc-8    | i386_defconfig      | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/5fa2890b5bc4e2cf6cfb5308

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-6=
5-g14295e030b41/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-6=
5-g14295e030b41/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa2890b5bc4e2cf6cfb5=
309
        new failure (last pass: v4.4.241-66-gcf149e8ad82e) =

 =20
