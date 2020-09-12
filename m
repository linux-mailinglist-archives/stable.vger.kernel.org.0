Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96BA82676E2
	for <lists+stable@lfdr.de>; Sat, 12 Sep 2020 02:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725889AbgILApM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 20:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbgILApF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Sep 2020 20:45:05 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A9CC061573
        for <stable@vger.kernel.org>; Fri, 11 Sep 2020 17:45:03 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id w7so8526030pfi.4
        for <stable@vger.kernel.org>; Fri, 11 Sep 2020 17:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VnZ7tkbpMp+OP8QFYlrWd+P3lB+DFyz1dRl6jVMFwaw=;
        b=emDfdXLZDoY1XTMSVKsI0cABSRRCVvlHc8kFs31HcpMcSDcoKBORLAaZXnrwEp33jg
         XSDJ+z1z81qBncF4PWfX18UWmoYpcDwVuGA+XNGslvwFBIF7guPnIvsCjwk+d+mvZdQb
         OcdNHPJNaxVFDYYKD/N61gth+PvfCk9qSX9MLByvDm/KQS8J++i/SXx/YA+MIlIduYfE
         Pra/EKj8cpK8nwIGjSEuoa+5jzPPc7pmUJRplfuKVIFaoE//OuUiSrDwYQryFS/U499K
         1e2LhhPHrZvXXAHOGrW9D5pjsn9xt7PxuWohFs8SRS6UYfTJkGW014e3Q5WZRNsR/Szx
         /pVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VnZ7tkbpMp+OP8QFYlrWd+P3lB+DFyz1dRl6jVMFwaw=;
        b=YdJJNf4dEzCzyVKogtT9IHor906i6YR0y1itqfPCJoGeKaqhBNifvc1ugfYEEU/O+6
         Ns+cNzR3v8N+vt3QOJbXOZSRaXvz3QbCuUOHa7mRiAXeGNyhyKF2/6Xp8g81RPgsmGp0
         AxW4uosjD8p4iuEwOboQrRKL54NNIkOo7cXEXue7jdttEkX29Sg2k6uR88bQbmMLW6qe
         ykEVnRijsX72rUZSD13USTZH9E6ooKGd4o9LaMkiJv6OV293Hvid0rRGNm922D87Juy3
         vRrSXEJpZCrfzo5Q9q6tqNSpf8zU2KYNX26z69YLlLfkCdfqNt39uU6I0NnkxS+DExlm
         forg==
X-Gm-Message-State: AOAM5313evDHPCH04SMnK6bJloOc/HusW0D9LpJf5S0rjz66hVloAbAf
        bJ8YT71MsPgPeNmbvf1kXz10MUoYACwnkw==
X-Google-Smtp-Source: ABdhPJxqOf1OehEnYpJx2jipv6rz4FGBw6L6kmlbVLik0aYvxPyyOM8IcyQmZ0dCODllicFSUxvRFQ==
X-Received: by 2002:aa7:971d:0:b029:13e:d13d:a08a with SMTP id a29-20020aa7971d0000b029013ed13da08amr4171086pfg.33.1599871501273;
        Fri, 11 Sep 2020 17:45:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a19sm3390118pfn.10.2020.09.11.17.45.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 17:45:00 -0700 (PDT)
Message-ID: <5f5c1a0c.1c69fb81.81919.9771@mx.google.com>
Date:   Fri, 11 Sep 2020 17:45:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.64-9-gcdcf7cd54ebd
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 182 runs,
 1 regressions (v5.4.64-9-gcdcf7cd54ebd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 182 runs, 1 regressions (v5.4.64-9-gcdcf7cd=
54ebd)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.64-9-gcdcf7cd54ebd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.64-9-gcdcf7cd54ebd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cdcf7cd54ebd34795a39be0bf517dd1017873640 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f5be2b129ad7798bba60917

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.64-=
9-gcdcf7cd54ebd/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.64-=
9-gcdcf7cd54ebd/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f5be2b129ad7798=
bba60919
      failing since 1 day (last pass: v5.4.63-130-gbe965cc6b079, first fail=
: v5.4.64)
      2 lines

    2020-09-11 20:46:37.336000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-09-11 20:46:37.336000  (user:khilman) is already connected
    2020-09-11 20:46:53.351000  =00
    2020-09-11 20:46:53.352000  =

    2020-09-11 20:46:53.352000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-09-11 20:46:53.353000  =

    2020-09-11 20:46:53.353000  DRAM:  948 MiB
    2020-09-11 20:46:53.367000  RPI 3 Model B (0xa02082)
    2020-09-11 20:46:53.454000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-09-11 20:46:53.486000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (380 line(s) more)
      =20
