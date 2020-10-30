Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B56D129FB0C
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 03:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725790AbgJ3CIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 22:08:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgJ3CIx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 22:08:53 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A889C0613CF
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 19:08:52 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id k9so2194277pgt.9
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 19:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Fjlbuk0Hsz5Gr+UhkmH6pj5QBDpNY5BCHc5JAPnjI8Q=;
        b=rtDHENmFt3t1MYxADjobsJLBlcRNd6DlTop+vh/c2kALLhg4iFDI39C4L2h2TUarff
         Z3mhPe/VpFh+qp/Rt7R+LrIsq6Ic3CMEdjI/07W3HeUSI8PMolpnGBAS9y9I9XUfcig3
         CnhkK8nkBhbIhPOlR8gAKIk+NOvNOevApyyGl57yG9fqHo9v+nfzxsPk6QRXq2QfoYYr
         LfAY8XMxjJjhCpuGZ6+QABKx1CFBi/70fZdprJjaKk5KtuJFNwMDU/rcHOVB+DG5x6Qn
         kSl9MiuRz6MsOx9fSFUUWyBE4Zjz3i1Y3rqJWbK3dMDYUXC8/00v3pvL/dCsLvfDjLfO
         +MRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Fjlbuk0Hsz5Gr+UhkmH6pj5QBDpNY5BCHc5JAPnjI8Q=;
        b=MCmnFCnSfRXToFhAubJk0Or7teJBYUWA3Ad9AqIAXqpUSxIPXbz5Lq2mM+fdSAePaV
         EWbwr2Lmi9UweAEndIK7+oEWoEXXSm64R5/Ga/Lex8PZxXcoF++lBmt7QbHDPkL5SqCA
         Ksp+A0HuCla5kDf837iEgXwDyP+K19YUg3uji5/oawoNr/l3kj4C0J/5O3LxETm+78Ar
         ai6iRBpFR6ifFBuRVB1KNB3RjF943ZLTSlREQ/k6zuRRhcGTDZq7K9zJnU/jIbFhnmbP
         /0khJP4bJfV9EZm10gdJjqWNpFgSHdpgBPuHMgW+15jzkO/iE9eqkDYGNEI/0QCGHi8o
         lTJA==
X-Gm-Message-State: AOAM533yeGnhXeGZyMMzAhcefCYzqU9XDQLji3kCoEoYfswDqOg/zyJE
        HexcMrONVX7wTZgsH7sV/r5og1OwtjbxaQ==
X-Google-Smtp-Source: ABdhPJxvERUmVBqIjSvF026Rahi232U2QhYvl7W7snHBnzguOfO2B1G0SRhi1aPuKV36DJdfXsmozQ==
X-Received: by 2002:a17:90a:a898:: with SMTP id h24mr7877pjq.179.1604023731453;
        Thu, 29 Oct 2020 19:08:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d18sm3687911pgg.41.2020.10.29.19.08.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 19:08:50 -0700 (PDT)
Message-ID: <5f9b75b2.1c69fb81.bd7a.8a3d@mx.google.com>
Date:   Thu, 29 Oct 2020 19:08:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.241
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 122 runs, 3 regressions (v4.4.241)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 122 runs, 3 regressions (v4.4.241)

Regressions Summary
-------------------

platform       | arch | lab          | compiler | defconfig           | reg=
ressions
---------------+------+--------------+----------+---------------------+----=
--------
beagle-xm      | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 2  =
        =

qemu_i386-uefi | i386 | lab-baylibre | gcc-8    | i386_defconfig      | 1  =
        =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.241/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.241
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8dfc31cb1f532f20ae71ca049a84c40226f30753 =



Test Regressions
---------------- =



platform       | arch | lab          | compiler | defconfig           | reg=
ressions
---------------+------+--------------+----------+---------------------+----=
--------
beagle-xm      | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 2  =
        =


  Details:     https://kernelci.org/test/plan/id/5f9b4382de644be978381032

  Results:     2 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.241=
/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.241=
/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f9b4382de644be9=
78381037
        new failure (last pass: v4.4.240-19-ge3d3be91473e)
        1 lines

    2020-10-29 22:32:51.112000+00:00  Connected to omap3-beagle-xm console =
[channel connected] (~$quit to exit)
    2020-10-29 22:32:51.112000+00:00  (user:) is already connected
    2020-10-29 22:32:51.112000+00:00  (user:) is already connected
    2020-10-29 22:32:51.112000+00:00  (user:) is already connected
    2020-10-29 22:32:51.112000+00:00  (user:) is already connected
    2020-10-29 22:32:51.113000+00:00  (user:) is already connected
    2020-10-29 22:32:51.113000+00:00  (user:) is already connected
    2020-10-29 22:32:51.114000+00:00  (user:) is already connected
    2020-10-29 22:32:51.114000+00:00  (user:) is already connected
    2020-10-29 22:32:51.114000+00:00  (user:) is already connected =

    ... (489 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9b4382de644be=
978381039
        new failure (last pass: v4.4.240-19-ge3d3be91473e)
        28 lines

    2020-10-29 22:34:38.019000+00:00  kern  :emerg : Stack: (0xcb971d10 to =
0xcb972000)
    2020-10-29 22:34:38.028000+00:00  kern  :emerg : 1d00:                 =
                    bf02b8fc bf010b84 cb9d0410 bf02b988
    2020-10-29 22:34:38.036000+00:00  kern  :emerg : 1d20: cb9d0410 bf2000a=
8 00000002 cb8a7010 cb9d0410 bf24fb54 cbc98390 cbc98390
    2020-10-29 22:34:38.043000+00:00  kern  :emerg : 1d40: 00000000 0000000=
0 ce228930 c01fb3d8 ce228930 ce228930 c0857e88 00000001
    2020-10-29 22:34:38.054000+00:00  kern  :emerg : 1d60: ce228930 cbc9839=
0 cbc98450 00000000 ce228930 c0857e88 00000001 c09612c0
    2020-10-29 22:34:38.060000+00:00  kern  :emerg : 1d80: ffffffed bf253ff=
4 fffffdfb 00000028 00000001 c00ce2f4 bf254188 c04070c8
    2020-10-29 22:34:38.068000+00:00  kern  :emerg : 1da0: c09612c0 c120da3=
0 bf253ff4 00000000 00000028 c040559c c09612c0 c09612f4
    2020-10-29 22:34:38.076000+00:00  kern  :emerg : 1dc0: bf253ff4 0000000=
0 00000000 c0405744 00000000 bf253ff4 c04056b8 c0403a68
    2020-10-29 22:34:38.084000+00:00  kern  :emerg : 1de0: ce0b08a4 ce22191=
0 bf253ff4 cbc44440 c09dd3a8 c0404bb4 bf252b6c c095e460
    2020-10-29 22:34:38.094000+00:00  kern  :emerg : 1e00: cbcab340 bf253ff=
4 c095e460 cbcab340 bf257000 c040617c c095e460 c095e460 =

    ... (16 line(s) more)  =

 =



platform       | arch | lab          | compiler | defconfig           | reg=
ressions
---------------+------+--------------+----------+---------------------+----=
--------
qemu_i386-uefi | i386 | lab-baylibre | gcc-8    | i386_defconfig      | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/5f9b431f413e950cea381019

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.241=
/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.241=
/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9b431f413e950cea381=
01a
        new failure (last pass: v4.4.240-113-gb3d9b0c29dc8) =

 =20
