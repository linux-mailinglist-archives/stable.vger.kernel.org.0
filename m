Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCA7C6B8AE4
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 07:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbjCNGBG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 02:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjCNGBF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 02:01:05 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 123E092F2F
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 23:01:04 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id o67so2372164pfg.10
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 23:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678773663;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=lrm/XdRY0fkC56oElpUdfvLghLvu3wx0/nPnik2MlUQ=;
        b=JUAI3J18nJtwD8nxFqX5HSpEFgRlHJjJyB2iLRxunO6GLoS6BKE9J7i7M2ZE1bNM9t
         wKEzYVnv1X3gmF/9or9GgKTSspqJZC8OKdRLl/lzg180YYx5XQqRLjDeBCYpU2its/hL
         dTooSHjZG6QNvUgTpfyJDjw4WSInu9fTU53A9AD9GgGuFqal+CePRo71qlwoCi6pP4dj
         q/A48yrjz3r8SIqwPYjjgCNE51U0DcRheCWgMMIAEpoyNiAPmyQlmYzDqXn0QjZLRHzF
         cdci4+Nziw3UU61SPPclSGuc3AEFEhTl7fCuScnk4458fzTLNibB7C9mpkiBfU7DvzmV
         A3cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678773663;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lrm/XdRY0fkC56oElpUdfvLghLvu3wx0/nPnik2MlUQ=;
        b=SvrJZo78VbrO915tW7i3R6aSNkGUnl0e7OKzzYyYJY4Rfyqvyne/Aw1H45IdyOW8mK
         BFHePfsFSvyUL9wJZLHE6UPY+HRWjleERIe8u6l7hXFkhiAgJdjAnq4Gpf7mpxYdEv0U
         VDDZllzaBKo6nQUHez+sNTVm1/PB0UCWaDZkl8bxk6+4y4PSj5cT6R9uRPJ5/UFgU3ww
         eefsUpFKoUveTjmz6ocYz1vUWBac9hPx9pF3jDmBbHg6zJOpnGRANOLG2GCzDePBU6v5
         kR7uTWcj4hAOd2imMZHBBvX+/soaoWQjewQAlcYK2t1IXJ+QijKdK9ZNuvs7WsttsCWd
         S0jw==
X-Gm-Message-State: AO0yUKUXr2y/RGlfwlaGS4UJtWy/TYMCmYjuNRLISGLShWlI/S/a95My
        iZz7bdhsp/PHBUeBzOXOX/TV1jEZKOnC7cfTnpashwxg
X-Google-Smtp-Source: AK7set8FPlMVPGxXlsa5AND2y2xbNOXQ3TKciGBerJ9CU56WUXscIA8WQLQ+zgDejnO9gWPNuN8imQ==
X-Received: by 2002:a62:4e8d:0:b0:5cb:eecd:387b with SMTP id c135-20020a624e8d000000b005cbeecd387bmr28616870pfb.33.1678773663241;
        Mon, 13 Mar 2023 23:01:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v2-20020aa78502000000b0060c55143fdesm691030pfn.68.2023.03.13.23.01.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 23:01:02 -0700 (PDT)
Message-ID: <64100d9e.a70a0220.28356.20d4@mx.google.com>
Date:   Mon, 13 Mar 2023 23:01:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.101-4-g2ddbd0f967b34
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.15.y baseline: 162 runs,
 1 regressions (v5.15.101-4-g2ddbd0f967b34)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.15.y baseline: 162 runs, 1 regressions (v5.15.101-4-g2ddb=
d0f967b34)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.101-4-g2ddbd0f967b34/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.101-4-g2ddbd0f967b34
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2ddbd0f967b34872290e0f98fae32b91b4de7b87 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/640fda3f581c44370d8c8632

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
01-4-g2ddbd0f967b34/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
01-4-g2ddbd0f967b34/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640fda3f581c44370d8c863b
        failing since 55 days (last pass: v5.15.82-124-gd731c63c25d1, first=
 fail: v5.15.87-101-g5bcc318cb4cd)

    2023-03-14T02:21:43.413335  + set +x<8>[   10.006307] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3409058_1.5.2.4.1>
    2023-03-14T02:21:43.413850  =

    2023-03-14T02:21:43.523066  / # #
    2023-03-14T02:21:43.626144  export SHELL=3D/bin/sh
    2023-03-14T02:21:43.627103  #
    2023-03-14T02:21:43.729271  / # export SHELL=3D/bin/sh. /lava-3409058/e=
nvironment
    2023-03-14T02:21:43.730585  =

    2023-03-14T02:21:43.731168  / # <3>[   10.273829] Bluetooth: hci0: comm=
and 0x0c03 tx timeout
    2023-03-14T02:21:43.833320  . /lava-3409058/environment/lava-3409058/bi=
n/lava-test-runner /lava-3409058/1
    2023-03-14T02:21:43.834711   =

    ... (13 line(s) more)  =

 =20
