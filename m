Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 409BA489516
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 10:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242809AbiAJJVC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 04:21:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242733AbiAJJU7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 04:20:59 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB4AC06173F
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 01:20:59 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id i8-20020a17090a138800b001b3936fb375so6268505pja.1
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 01:20:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bnXzR+209Dpj37Z+B8UNMyPf6n0DhjucdifLlUwBo9Y=;
        b=Nv7OlOFfohaj6uNHKbFeG5riJLzs2IGIlEY218HO1GM3kPlyj2Pshfvwf4Lm3qtRlf
         v5b6Ton7UHkmHeEZ9L5TmlLJ1seTMOf0ZAOfGszT1Uz1JEsH22gnLxunoyim+DJ8P05x
         ZL3KOiwoVuTCmm5NarKccMeinXN4PbI8e93kXh0+ItxPffTYL76Fw9IK6jEgrkynqzZI
         jSMwzcQ7EnTfXujJsDHNyLtt7GXxtzlNtH7oHdRpfU1ZDzIUsTX/l059BL1l7cBOl9OT
         FBtM93gjQHHeFVE0Jqyz6VbW85uJraNTUHA/ZCvIOVr1KxAtKnn8hbH4fxCQrHQopGm8
         gJgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bnXzR+209Dpj37Z+B8UNMyPf6n0DhjucdifLlUwBo9Y=;
        b=WgCkV9Uzt73kBYN4U1zp3X0+WL9h5cYL82DvR1An3plD8n/HyK/X9N0I+fZP/t4u0m
         cZRifIXkZuSayVb+IL6OgFuhMFsN4iQinfcr6gM3fkNdtmElZnzRL018Znkip53wScVL
         kmMLFz9mFX4A9SIB178SZOZGxNPSI1Ldgi3g58XSTHZsKep0oGesg864klncUlalwEOB
         yLOiGvwAVDgzvop5e2KuKAjoUyq8BBJu3S5ltQHIBz1ClS53xZ/XTEWd4KO12713DWD0
         +d3aupBfv7hioOGEqIMtBKTY/0hWT20kF3jQwJCGGg68IcA/qLKAnabnwBUDyAG0gxO/
         kNtw==
X-Gm-Message-State: AOAM530dUjtI9kCE4nzQ3m47MB8rbYpseHHRKjsBhCKRTiwrbVs4mpyP
        sdowM+dMlcKc0ixHjkuSB2hvTjnGyS8MEbL9
X-Google-Smtp-Source: ABdhPJzN3ck1w+tDapXFbflojJOrDPcJaormpVPECIE3EVDbLV9CoEttLkhJUNS2jo8ooEK1e2PrkQ==
X-Received: by 2002:a17:90b:3c0c:: with SMTP id pb12mr24213683pjb.45.1641806458778;
        Mon, 10 Jan 2022 01:20:58 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y3sm7945620pjp.55.2022.01.10.01.20.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 01:20:58 -0800 (PST)
Message-ID: <61dbfa7a.1c69fb81.b055d.4b6c@mx.google.com>
Date:   Mon, 10 Jan 2022 01:20:58 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.90-42-g2497db683e3d
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 153 runs,
 2 regressions (v5.10.90-42-g2497db683e3d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 153 runs, 2 regressions (v5.10.90-42-g2497db=
683e3d)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 2          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.90-42-g2497db683e3d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.90-42-g2497db683e3d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2497db683e3d20ec4cff3745b8420f83f2978290 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 2          =


  Details:     https://kernelci.org/test/plan/id/61dbc93da7e048ce51ef6784

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.90-=
42-g2497db683e3d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6q-=
var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.90-=
42-g2497db683e3d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6q-=
var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/61dbc93da7e048c=
e51ef6788
        new failure (last pass: v5.10.90-31-gf757523866a0)
        4 lines

    2022-01-10T05:50:31.642161  kern  :alert : 8<--- cut here ---
    2022-01-10T05:50:31.678158  kern  :alert : Unable to handle kernel NULL=
 pointer dereference at virtual address 00000313
    2022-01-10T05:50:31.679563  kern  :alert : pgd =3D 6908e6a9<8>[   11.37=
0128] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dline=
s MEASUREMENT=3D4>
    2022-01-10T05:50:31.679831  =

    2022-01-10T05:50:31.680063  kern  :alert : [00000313] *pgd=3D00000000   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61dbc93da7e048c=
e51ef6789
        new failure (last pass: v5.10.90-31-gf757523866a0)
        46 lines

    2022-01-10T05:50:31.729034  kern  :emerg : Internal error: Oops: 17 [#1=
] SMP ARM
    2022-01-10T05:50:31.729299  kern  :emerg : Process kworker/3:1 (pid: 57=
, stack limit =3D 0xec1ebbbb)
    2022-01-10T05:50:31.729775  kern  :emerg : Stack: (0xc244dd68 to 0xc244=
e000)
    2022-01-10T05:50:31.730013  kern  :emerg : dd60:                   c3a4=
f1b0 c3a4f1b4 c3a4f000 c3a4f000 c1445cc0 c09e3b64
    2022-01-10T05:50:31.730234  kern  :emerg : dd80: c244c000 c1445cc0 0000=
000c c3a4f000 000002f3 c3aa3a80 c2001d80 ef86d460
    2022-01-10T05:50:31.730707  kern  :emerg : dda0: c09f12cc c1445cc0 0000=
000c c2350dc0 c19c7a10 33432f17 00000001 c3aa9d80
    2022-01-10T05:50:31.772172  kern  :emerg : ddc0: c3aab180 c3a4f000 c3a4=
f014 c1445cc0 0000000c c2350dc0 c19c7a10 c09f12a0
    2022-01-10T05:50:31.772679  kern  :emerg : dde0: c14439e4 00000000 c3a4=
f000 fffffdfb bf026000 c22d8c10 00000120 c09c7280
    2022-01-10T05:50:31.772920  kern  :emerg : de00: c3a4f000 bf022120 c3aa=
92c0 c39d5308 c3a3a1c0 c19c7a2c 00000120 c0a23c70
    2022-01-10T05:50:31.773145  kern  :emerg : de20: c3aa92c0 c3aa92c0 c223=
2c00 c3a3a1c0 00000000 c3aa92c0 c19c7a24 bf0160a8 =

    ... (34 line(s) more)  =

 =20
