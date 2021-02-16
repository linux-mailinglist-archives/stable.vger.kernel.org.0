Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F08131C626
	for <lists+stable@lfdr.de>; Tue, 16 Feb 2021 06:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbhBPFLd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Feb 2021 00:11:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbhBPFLc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Feb 2021 00:11:32 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31DD9C061574
        for <stable@vger.kernel.org>; Mon, 15 Feb 2021 21:10:52 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id d15so4872522plh.4
        for <stable@vger.kernel.org>; Mon, 15 Feb 2021 21:10:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7Tr6fYKimcMwvM/TuByRzWbFPK7U6EyxL2O3TEwPSyU=;
        b=Ubf4q4mwQ6FcgMtiZ9ASTVWhTd5PR5pHWqZNKphU3VKms9mpqxKOwgkjqPia+55jjd
         sZyMhFo8m1heoNoT1uLV7IzegbAf5G0y5DsGCuAdWvNyBeGxF11Yn3FYMCjhIrd3OAuj
         BqTYRZHCqvhI2TjG+MsXj9+D5PCdzBYveEX4HvULJ2FRmeLwNMHKL5KNs32EuPZqotnG
         Ba0LSQu/NctufHdteoFHbLD2KY0IsFfT0wEf2WtHont194WHW/L2MzVB76P8gWgXJr/2
         I3/NtWMeNGJGFQMhyn2mhvb4UNpxF+PhUR/F+N5QZHwp4CwyCy98rMgVIK9FI1Suz8+f
         m1sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7Tr6fYKimcMwvM/TuByRzWbFPK7U6EyxL2O3TEwPSyU=;
        b=CyNTxmKMgsGFB1ECYXc2kjkGrNEzAqPBrBB99GoHG0GLhbLKzxrwfiKl924xletEjf
         0v/1bhcO/neMA+denpx0nqi00D3DQxqeC4pF9MfTczWWGRLlljxY0H6+TYrrSGUtsZo5
         8YKRWVAYBHgziWWXObGJCSDgtt29XybiSV80w8/p+R5za/mQIisTSTwVN/NHp0hFnKlI
         O4rGMOqi3zYmaHJ4FhkOD5z7SZewBs8Eqtho1mxekK52EQ3PqOKjIa93dp7rJtxIBa29
         Ob62IHlaUb7H41XNYEH0QjY+LLuDSOEgl4+WErQgE60RNRGkps5vYC6KAkUyztGo/brk
         3sdQ==
X-Gm-Message-State: AOAM531mEVygVtq2Gl4nO2KS0mtrT06/4JKeGNIjRmI4r4fqpBtcDxKA
        GSLUpsiM0FYaEry32W4Cp6pRQcxpr/xS4g==
X-Google-Smtp-Source: ABdhPJyfSv2ExsR0i1yTbFNTaa+1hT+yDHfMXF6Ijgmz1R13xrQ3dgihedia00gy+yc1J3/2GXhOmg==
X-Received: by 2002:a17:903:181:b029:df:c7e5:8e39 with SMTP id z1-20020a1709030181b02900dfc7e58e39mr18640749plg.25.1613452251449;
        Mon, 15 Feb 2021 21:10:51 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c18sm21072544pfj.58.2021.02.15.21.10.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 21:10:51 -0800 (PST)
Message-ID: <602b53db.1c69fb81.c4b91.cd77@mx.google.com>
Date:   Mon, 15 Feb 2021 21:10:51 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.221-40-geb9933ec8764
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 54 runs,
 1 regressions (v4.14.221-40-geb9933ec8764)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 54 runs, 1 regressions (v4.14.221-40-geb9933=
ec8764)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.221-40-geb9933ec8764/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.221-40-geb9933ec8764
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      eb9933ec8764a775b85a2ff8c740ddebb12f005a =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/602b3016c17071d86baddcb2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-40-geb9933ec8764/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-40-geb9933ec8764/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602b3016c17071d86badd=
cb3
        failing since 69 days (last pass: v4.14.210-20-gc32b9f7cbda7, first=
 fail: v4.14.210-20-g5ea7913395d3) =

 =20
