Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2535944CAC3
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 21:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232583AbhKJUvI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 15:51:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232195AbhKJUvH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Nov 2021 15:51:07 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD853C061766
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 12:48:19 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id r5so4074536pls.1
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 12:48:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Eo3faO8SuzAYDDeDmysjtUE05T1G97fGQ0sTES9Cr3U=;
        b=Zdr4GOlNW9FgXxo+SlhzEqI9rMEA+5qCmDNVDjkBiaNc5o5ELJxxHWMwLBskpcI0om
         hrQiMi+Wrs3kVCtajcVgoCTtKhUisIjHwLHAX69h8Yj/7fLJk/V4/zsOSTFBy4ALOPHz
         WnIQ1kHYChYQYBejoQycW2xDJUqwqUOGzrL0smKRu+ZP//4ug1PGF0VxkRxIIFqDAU57
         htkV4PyEi32IMG5b2qQB6KlmYtmAgaxHxmdqJFFonLMGmClzme8o1dN91I8Veb9Wd0wR
         Az/Wfy3eb8pH4oLVuTrgB+nHZ4XqHI3oZmI9J49WLcQrRBq+KLnYJmmzk6GNye0Y9rtK
         KS2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Eo3faO8SuzAYDDeDmysjtUE05T1G97fGQ0sTES9Cr3U=;
        b=5ZriYiqZlB2ksN06Tyc1mFxkdfvU3b5YZhMEcK0S/sKD4nTyd9kJJMh+9uocJbJ1Fb
         ZtPOckRKNgCtY4GUuELrxORnW1DtFHRkfYyNUeH3XXLE8aLSG9MxRVWEBGEanoH3g7Tt
         jh96veownZdDmtRLbhsYOPDjNHzOs6tmP3hEDRaCvucaHxX0PKHXhnZsTeKFvZqX41uQ
         t+0z9y0LezUef45Bk3JtF90Cc+2fFjgQl9bWfavxu221b68x8C66jX1S7w+XyIpaBXWo
         TLG+gZlrEK0G1LlzGZ+kGtEy6DZE3gV70c5ZUwxB+MPcaJf03zi768gOvSjoTtNoYa6p
         krRA==
X-Gm-Message-State: AOAM530XH0CuaXErWG2UGXQdPaWibxVXrMA0PCiCh3XjsuwKuVcu8fJX
        yLz77t5jRq2FvZ8YpfEA6y0vcRQf3zgDDV+O9Ww=
X-Google-Smtp-Source: ABdhPJxj1vg8MEq/BOWzh3LOU9mLWAU58oEQlccqzskjg54M927mghe2I7JEWmAFLM1DJnU53W+ZeQ==
X-Received: by 2002:a17:902:70cb:b0:13e:91f3:641a with SMTP id l11-20020a17090270cb00b0013e91f3641amr2151645plt.13.1636577299118;
        Wed, 10 Nov 2021 12:48:19 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k1sm435103pjj.54.2021.11.10.12.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 12:48:18 -0800 (PST)
Message-ID: <618c3012.1c69fb81.ba167.1c73@mx.google.com>
Date:   Wed, 10 Nov 2021 12:48:18 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.78-10-g6d588d07b158
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 176 runs,
 2 regressions (v5.10.78-10-g6d588d07b158)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 176 runs, 2 regressions (v5.10.78-10-g6d588d=
07b158)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 2          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.78-10-g6d588d07b158/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.78-10-g6d588d07b158
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6d588d07b1586ac8d9a15ef21f489d2fb2f908eb =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 2          =


  Details:     https://kernelci.org/test/plan/id/618bf5fd84db445d39335964

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.78-=
10-g6d588d07b158/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6q-=
var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.78-=
10-g6d588d07b158/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6q-=
var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/618bf5fd84db445=
d39335968
        new failure (last pass: v5.10.78-10-gd690741e8b33)
        4 lines

    2021-11-10T16:40:16.550355  kern  :alert : 8<--- cut here ---
    2021-11-10T16:40:16.581551  kern  :alert : Unable to handle kernel NULL=
 pointer dereference at virtual address 00000313
    2021-11-10T16:40:16.582726  kern  :alert : pgd =3D (ptrval)<8>[   39.63=
9118] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dline=
s MEASUREMENT=3D4>
    2021-11-10T16:40:16.583012  =

    2021-11-10T16:40:16.583252  kern  :alert : [00000313] *pgd=3D00000000   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/618bf5fd84db445=
d39335969
        new failure (last pass: v5.10.78-10-gd690741e8b33)
        46 lines

    2021-11-10T16:40:16.640311  kern  :emerg : Internal error: Oops: 17 [#1=
] SMP ARM
    2021-11-10T16:40:16.640829  kern  :emerg : Process kworker/2:3 (pid: 84=
, stack limit =3D 0x(ptrval))
    2021-11-10T16:40:16.641080  kern  :emerg : Stack: (0xc32ebd68 to 0xc32e=
c000)
    2021-11-10T16:40:16.641313  kern  :emerg : bd60:                   c3ab=
a5b0 c3aba5b4 c3aba400 c3aba400 c1444e0c c09e2bd4
    2021-11-10T16:40:16.641539  kern  :emerg : bd80: c32ea000 c1444e0c 0000=
000c c3aba400 000002f3 c3aa8980 c2001d80 ef86d500
    2021-11-10T16:40:16.642002  kern  :emerg : bda0: c09f0324 c1444e0c 0000=
000c c32845c0 c19c78f8 c3741476 00000001 c3c72b40
    2021-11-10T16:40:16.683425  kern  :emerg : bdc0: c3c71000 c3aba400 c3ab=
a414 c1444e0c 0000000c c32845c0 c19c78f8 c09f02f8
    2021-11-10T16:40:16.683944  kern  :emerg : bde0: c1442b30 00000000 c3ab=
a400 fffffdfb bf026000 c22d8c10 00000120 c09c62f0
    2021-11-10T16:40:16.684193  kern  :emerg : be00: c3aba400 bf022120 c3c7=
22c0 c32eed08 c3949780 c19c7914 00000120 c0a22cc8
    2021-11-10T16:40:16.684424  kern  :emerg : be20: c3c722c0 c3c722c0 c223=
2c00 c3949780 00000000 c3c722c0 c19c790c bf0770a8 =

    ... (36 line(s) more)  =

 =20
