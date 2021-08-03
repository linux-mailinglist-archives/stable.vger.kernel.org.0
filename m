Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EADF3DE6F9
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 09:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233958AbhHCHHe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 03:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233677AbhHCHHd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Aug 2021 03:07:33 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31544C06175F
        for <stable@vger.kernel.org>; Tue,  3 Aug 2021 00:07:23 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id dw2-20020a17090b0942b0290177cb475142so2582401pjb.2
        for <stable@vger.kernel.org>; Tue, 03 Aug 2021 00:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=H9Q9P4ncZmHW6WGwd1G3slYV2TsgzY6XFGu1oQeZSyI=;
        b=uNpvkj81PoZ2UoYy0T3yMVaTAmiddvOm5a5uTCJmi9Ypa2Ihz0G/xNK/hB4UVU3sGQ
         fkroHuuPsyDqECDOyb6W8kKUAsgxf//nYxxTF3ebkPtgZruVMsYbVJ+OwokdeIRIw6A9
         Nw1Td2AAMdK1IMXmUSEybJr16kNxlclrO3jTobDu79CMQCT5PqCSk43cQeIzg89pUzcK
         lBg18lbVuGg74bdsKYx7NSYH+0CnTW0q+4m04o4FamnTDk6zRkJNN1alChzavBItNSOJ
         RohNBE7VIRpO/MDmQT6Nn72FHZyqXgdQyoFTU/f3V2HsL6V7+6uOwIVdtwATR511+j2y
         4NOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=H9Q9P4ncZmHW6WGwd1G3slYV2TsgzY6XFGu1oQeZSyI=;
        b=REOjtRHpfsSCxRErbrw451SD8JUivpVNWX+RPzQuZNa8ossrKg5N3FUKUfHdg2bZLr
         y7Qf9aQh0m1LcYMoS+GReqEvgf0C8fRZE3AiB6RByVmC+TLlgM3UpM3A0FZT0kh9LhL+
         n+w+0VXvq/+xUhI52UYQXouI/k+50Ct15+avsnI0u8xZ+iH85iE1kiTxAZceCUjhePJg
         twXPMG2VlrLApDCBsrfCuxsFej2NkZmKUtl1auL3p4QazJAypmB28AJMJP/O4TldUFiR
         3ovrDGe7gVAv/P4C7SZsjSz5pAZbNSA7YvXQHU8iC5+bJHaVQ92EF5V6tRCHrgr+9+AH
         MFRA==
X-Gm-Message-State: AOAM533knFh3cm+9D67/0wbuI50eHiOjbLA2R5FaCcLdzk8Y+E/KWeDl
        x/bGFnCdnnFHF3qZeGY/CwZvW5kDYthijw==
X-Google-Smtp-Source: ABdhPJw7Nr6ulLufTbcUQoAHS8BlhjjIC8JF66a9m3GSi6eZOuCtNmtfhDlXyEs9hpyte69gCtrYJg==
X-Received: by 2002:a62:8c94:0:b029:3c0:d487:4445 with SMTP id m142-20020a628c940000b02903c0d4874445mr5939222pfd.15.1627974442500;
        Tue, 03 Aug 2021 00:07:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v25sm13882888pfm.202.2021.08.03.00.07.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 00:07:22 -0700 (PDT)
Message-ID: <6108eb2a.1c69fb81.90c2f.8a79@mx.google.com>
Date:   Tue, 03 Aug 2021 00:07:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.55-71-g29b6502ddb40
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 82 runs,
 2 regressions (v5.10.55-71-g29b6502ddb40)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 82 runs, 2 regressions (v5.10.55-71-g29b6502=
ddb40)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 2=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.55-71-g29b6502ddb40/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.55-71-g29b6502ddb40
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      29b6502ddb40cf8a8ee101aca9e08ff74385f010 =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 2=
          =


  Details:     https://kernelci.org/test/plan/id/6108b47ed6d2f4a3dcb1367e

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.55-=
71-g29b6502ddb40/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.55-=
71-g29b6502ddb40/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/6108b47ed6d2f4a=
3dcb13682
        new failure (last pass: v5.10.55-67-gb533974270fb)
        4 lines

    2021-08-03T03:13:43.358390  kern  :alert : 8<--- cut here ---
    2021-08-03T03:13:43.394189  kern  :alert : Unable to handle kernel NULL=
 pointer dereference at virtual address 00000007
    2021-08-03T03:13:43.394952  <8>[   13.485569] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6108b47ed6d2f4a=
3dcb13683
        new failure (last pass: v5.10.55-67-gb533974270fb)
        17 lines

    2021-08-03T03:13:43.398431  kern  :alert : pgd =3D 2fad40dc
    2021-08-03T03:13:43.399133  kern  :alert : [00000007] *pgd=3D0420d835, =
*pte=3D00000000, *ppte=3D00000000
    2021-08-03T03:13:43.439091  kern  :emerg : Internal error: Oops: 817 [#=
1] ARM
    2021-08-03T03:13:43.440256  kern  :emerg : Process rcS (pid: 127, stack=
 limit =3D 0x17c16ecd)
    2021-08-03T03:13:43.441008  kern<8>[   13.527583] <LAVA_SIGNAL_TESTCASE=
 TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D17>   =

 =20
