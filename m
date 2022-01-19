Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD1D6493351
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 04:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351172AbiASDIO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 22:08:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238949AbiASDIN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 22:08:13 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8172C061574
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 19:08:13 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id s61-20020a17090a69c300b001b4d0427ea2so4497360pjj.4
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 19:08:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2ZSZq1T0fPDSG5l8JETg/PiX/JoeRp79NCgDgseCFFQ=;
        b=c8ffXS36AqzgEaDB4mE0FcN6twAtQa00BwZ4aTxg88DST2C5X0h3RUYmz0xwAoFPM1
         d6w01dpG2zd8tzuz+9flgAvBsa1gEWRUO4dzE3fkhxQIGfDiDnCbtcNN0UK7y8ylGCXE
         Vvv74Pz0XOT7xt3wTkE3cgRQAU2S0n2av1GUREz0yyTwGJSJxdT9D+RrzBaWJwbolJBq
         mE5ah0566b6LNMqJkaCns0Z6yRpYQTqwAXtpCI+gILEwIJ0U1njzw8VSr+09dUgqzrWp
         QLliWELF7TSVY8Fau8eKAEaZwXFoCCgtpCMDjvnJcbwDYidWiTyVnsI+n9EiHmCLbFpz
         qUAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2ZSZq1T0fPDSG5l8JETg/PiX/JoeRp79NCgDgseCFFQ=;
        b=4SyWah5VcMa5xr+7jkus1Lo3ewGNlB9GXzhUF/Z1Ccmd74AU6P8SUCyOgNxN1Xii4H
         bbZ6BoJRv13U8sxZP9JiZ/vMFvN/k7gvAqXlJJr6FALI+CfnKELsFidDMtJOkOj3ipbL
         WWmiINwvw4b62cLj3vJeJl+iR2mHLrj8SjSCsfxkHmv70fNXAovG11izrAk3FKrP86NM
         UbmDO3WtmMmT/FdC2NI64lIJy3/lIxRkrjnFnEjOtYxUqPqdQ+LCgf8Z882kF/AfCSMr
         k92r2AxD7ExWqnIR1IFJmmbKcD3SEcfKZOsvsRfuR/LK20Fx1qdnHBELuWR9sLPyD6al
         3VFQ==
X-Gm-Message-State: AOAM533Rv46hNDAMnZME6A3e0dXnFiwOlVrBBnwhpyWaTFjF3JcL3qyv
        5ztflrUhUZ/iQq61JT5cyBFwt5NzJcy89656
X-Google-Smtp-Source: ABdhPJzUUBk5bozZ2qCvWqGPPJcihxwsXMmpdAUUR4gcpOKbUbyBYF8zFG/twrZewUWIekd2Vhd5FQ==
X-Received: by 2002:a17:902:e202:b0:14a:e525:b675 with SMTP id u2-20020a170902e20200b0014ae525b675mr4214992plb.11.1642561693110;
        Tue, 18 Jan 2022 19:08:13 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y129sm17975410pfy.164.2022.01.18.19.08.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 19:08:12 -0800 (PST)
Message-ID: <61e7809c.1c69fb81.bf4d0.1c26@mx.google.com>
Date:   Tue, 18 Jan 2022 19:08:12 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.91-49-g9703e54f4016
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 157 runs,
 2 regressions (v5.10.91-49-g9703e54f4016)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 157 runs, 2 regressions (v5.10.91-49-g9703e5=
4f4016)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 2          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.91-49-g9703e54f4016/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.91-49-g9703e54f4016
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9703e54f40169134cce44987fb3c7556b816b0cb =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 2          =


  Details:     https://kernelci.org/test/plan/id/61e74bd11a4714cfefabbd27

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.91-=
49-g9703e54f4016/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6q-=
var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.91-=
49-g9703e54f4016/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6q-=
var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/61e74bd11a4714c=
fefabbd2e
        new failure (last pass: v5.10.91-47-g6c855c89aa97)
        4 lines

    2022-01-18T23:22:46.905892  kern  :alert : 8<--- cut here ---
    2022-01-18T23:22:46.906526  kern  :alert : Unable to handle kernel NULL=
 pointer dereference at virtual address 00000313
    2022-01-18T23:22:46.907386  kern  :alert : pgd =3D (ptrval)<8>[   39.41=
2823] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dline=
s MEASUREMENT=3D4>
    2022-01-18T23:22:46.907775  =

    2022-01-18T23:22:46.908034  kern  :alert : [00000313] *pgd=3D00000000   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e74bd11a4714c=
fefabbd2f
        new failure (last pass: v5.10.91-47-g6c855c89aa97)
        46 lines

    2022-01-18T23:22:46.959349  kern  :emerg : Internal error: Oops: 17 [#1=
] SMP ARM
    2022-01-18T23:22:46.959642  kern  :emerg : Process kworker/1:5 (pid: 96=
, stack limit =3D 0x(ptrval))
    2022-01-18T23:22:46.960158  kern  :emerg : Stack: (0xc36ddd68 to 0xc36d=
e000)
    2022-01-18T23:22:46.960422  kern  :emerg : dd60:                   c3a3=
a1b0 c3a3a1b4 c3a3a000 c3a3a000 c1445ce4 c09e3c94
    2022-01-18T23:22:46.960670  kern  :emerg : dd80: c36dc000 c1445ce4 0000=
000c c3a3a000 000002f3 c32ded00 c2001d80 ef85dbc0
    2022-01-18T23:22:46.961165  kern  :emerg : dda0: c09f13fc c1445ce4 0000=
000c c234b340 c19c7a10 09d03d33 00000001 c3a80d40
    2022-01-18T23:22:47.002341  kern  :emerg : ddc0: c3a87300 c3a3a000 c3a3=
a014 c1445ce4 0000000c c234b340 c19c7a10 c09f13d0
    2022-01-18T23:22:47.002952  kern  :emerg : dde0: c1443a08 00000000 c3a3=
a000 fffffdfb bf026000 c22d8c10 00000120 c09c73b0
    2022-01-18T23:22:47.003244  kern  :emerg : de00: c3a3a000 bf022120 c3a8=
0340 c3b6cf08 c3b16dc0 c19c7a2c 00000120 c0a23da0
    2022-01-18T23:22:47.003499  kern  :emerg : de20: c3a80340 c3a80340 c223=
2c00 c3b16dc0 00000000 c3a80340 c19c7a24 bf08e0a8 =

    ... (36 line(s) more)  =

 =20
