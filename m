Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED94452934
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 05:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240721AbhKPEsj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 23:48:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238278AbhKPEsX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 23:48:23 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59149C2287A2
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 17:49:38 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id z6so16647771pfe.7
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 17:49:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Lt9CQ3qPasZjQIaGJhxtRMD8KRgTxwjv3SoSDm3o6qg=;
        b=AjypDcnAqtT0fAheSIh+5B5Ho41M1UYcdZP2xh9lFWvgtQdXhNC902WSNi1Wc7IE0H
         xs6bLIUbn2irnL9vW/RwNOkjqnzB/nqY9H2Wh4hdcvDdX7zG1y+fjmFzlxpxbgit00ax
         1KV9CnQBCKu45EC9xQPL93qHkVb8BRoDlOCJxzBzrNngqksG9iscB0eMf9MW2Rr2F3F/
         KS+2HWVECs4En5OQDt2/43dDwEkSzWvJd3Icd2yF3HOVtS6IVuiJra8paxJrHOJ2oRk9
         7Fk2hksfCN+15PNyhrjw4i/+am30e0mm7nKWFqemHm5jCfjV2j75VDBH6Vw6tUHp6oIp
         5Ang==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Lt9CQ3qPasZjQIaGJhxtRMD8KRgTxwjv3SoSDm3o6qg=;
        b=M8/VvMYcxBEjgY0FA7Zi+9/ZG4FIY9FziXQSJ92wmsmv7EN2JsTzM1oo4+s0R3wYS2
         CY6rhossVoroHQgCzHzMlyQ/fjFIuf1bNOX/04BU21gthW8a5sMgk8/rJ7E9Uu/Jq12v
         FigPMs39rHnpyCZtmBO/Rgj0tl9croCR6sMsOsUwrTQBbHQbymHoACSp4922Nc/JkaNQ
         O/5JxDDzy4WyBbJvvAF2nM2a65DuBEQRxFv00L5+CcUdoQBCsaCThXV/ViriOqyWAh21
         V2QIrfI+EtwvGs/+CKrzAfp7le//sEkLOefF5eKSUD3Q9l/nMaxeaFhjbSuSkas7VYyI
         a1YQ==
X-Gm-Message-State: AOAM5300tRms12C4oBd2AVxKLYe2pAOAnvzM8xAospZveuK5UcX7c/cD
        t/Wk5uNA4mmidHLjXul91SL70/+UjhYhA3Pm
X-Google-Smtp-Source: ABdhPJyV8leyWKkNjZtDulyJTkgH1F86oUZX3CUHEFaRQtH1YRhacWNB9r6HPiW08GIAoBh6usKeGw==
X-Received: by 2002:aa7:9597:0:b0:49f:b04e:e669 with SMTP id z23-20020aa79597000000b0049fb04ee669mr37387022pfj.62.1637027377777;
        Mon, 15 Nov 2021 17:49:37 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k5sm18078891pfc.111.2021.11.15.17.49.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 17:49:37 -0800 (PST)
Message-ID: <61930e31.1c69fb81.9bcd.3ebf@mx.google.com>
Date:   Mon, 15 Nov 2021 17:49:37 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.290-159-gd7ba0cd7a486
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 87 runs,
 1 regressions (v4.9.290-159-gd7ba0cd7a486)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 87 runs, 1 regressions (v4.9.290-159-gd7ba0cd=
7a486)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.290-159-gd7ba0cd7a486/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.290-159-gd7ba0cd7a486
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d7ba0cd7a486d404b3900021c267e5e2d9b761e2 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6192d4d8bf7661ef673358dc

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-1=
59-gd7ba0cd7a486/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-1=
59-gd7ba0cd7a486/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6192d4d8bf7661e=
f673358df
        failing since 0 day (last pass: v4.9.290-56-g5c0fdc0dbedd, first fa=
il: v4.9.290-153-g690c63d8995e7)
        2 lines

    2021-11-15T21:44:40.030026  [   21.164855] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-15T21:44:40.073424  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/120
    2021-11-15T21:44:40.082513  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
