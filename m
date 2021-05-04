Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0AA37304C
	for <lists+stable@lfdr.de>; Tue,  4 May 2021 21:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231926AbhEDTHU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 May 2021 15:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbhEDTHR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 May 2021 15:07:17 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 244F0C061574
        for <stable@vger.kernel.org>; Tue,  4 May 2021 12:06:22 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id c21so4197040pgg.3
        for <stable@vger.kernel.org>; Tue, 04 May 2021 12:06:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KAMAjLAcE2X6pq0U0Rt2vBo7DlKwN2w+Y14RyxjsPtI=;
        b=y9++FHIOXeZCspEi2W/tColuoAqv4K8Bpb6cUPyevsjMFGvPW0ghZNDTI6y78WOX8e
         KXYhEB8+gok+2EmePymmN/yRxb2yaZuWc7SIrCQtyI2MVeMhpnpCmwYpDN7iS/hzvumC
         SgGIzRvJQNEQU7rI5JHeH6mB9+KWFZlgbNGsVWj252X0o45+4shEt1Ygzz3lNkj5SPLe
         VksmlmDVtcs8DhDQqF1LQuXi1C/eWcDVFUmuKzU+rymhPYq0oB55cJ1cO3xMWRaioLZn
         eL7CPqJhR0k2dOnoPNodhXm6rtlJ4cFdtKUxCFM1lXaDxQ9E6amYQQIhQKdf7sUGKls7
         3vag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KAMAjLAcE2X6pq0U0Rt2vBo7DlKwN2w+Y14RyxjsPtI=;
        b=JOAGRV68lfg2hPNfBqiYzLa27yge3xQKFEF0KmtaNHaRXU3gkfFJvfajuL91eeFZpo
         WMh4YY/PPerEIWhHeiELqykyH03n8JFTRWILIeg4CKcuaLHzcw30UYroW15O7ebzZzFS
         so5U2uZVPefvrfSXW5cI9z/AFVF1cEQ5KJeTZ/HrivEtzwR5dix/TH+u+uFDBTx6Wu9/
         nVF8F0uscMewIg4FanuC5FA+9fq7Uym3ORQtaD2bIuS/OOc3Y8CSOV/WetyNbRa1JnAl
         OPwMOCpbB5wKzY8m869fOWSqtm8Nz3YhAuRufwK/Bfbb1Ltgx2KqboiQHlrIXjTuk9/C
         fxwg==
X-Gm-Message-State: AOAM533wweWq2DX6RPm5gUXCYQQJ5rrBUwnA+gZ74KqYYh6wlWNrB2YZ
        tiW0yMRvHRoNPrIQQfVbNChaIWpZflvdLipq
X-Google-Smtp-Source: ABdhPJwmnUWd0X6/YUQJueNIMA/UymFVzAzIMIrnoT3XusTMSqhD/grrltW9+zuI8npswcOesFMGUw==
X-Received: by 2002:a17:90a:d50d:: with SMTP id t13mr6639672pju.14.1620155181459;
        Tue, 04 May 2021 12:06:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id gf21sm14507556pjb.20.2021.05.04.12.06.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 12:06:21 -0700 (PDT)
Message-ID: <60919b2d.1c69fb81.28f37.41be@mx.google.com>
Date:   Tue, 04 May 2021 12:06:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.11.18-7-g1b15e1a9a6fd
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.11
Subject: stable-rc/queue/5.11 baseline: 116 runs,
 1 regressions (v5.11.18-7-g1b15e1a9a6fd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.11 baseline: 116 runs, 1 regressions (v5.11.18-7-g1b15e1a=
9a6fd)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.11/ker=
nel/v5.11.18-7-g1b15e1a9a6fd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.11
  Describe: v5.11.18-7-g1b15e1a9a6fd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1b15e1a9a6fd47c1cb4a40ec4d7dd5e5d35d11a3 =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/60915fe38dd5c15957843f1e

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.18-=
7-g1b15e1a9a6fd/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.18-=
7-g1b15e1a9a6fd/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60915fe38dd5c15=
957843f23
        new failure (last pass: v5.11.18-5-g5163b88ca158e)
        56 lines

    2021-05-04 14:52:59.140000+00:00  kern  :emerg : Process udevd (pid: 10=
0, stack limit =3D 0x7e1deb65)
    2021-05-04 14:52:59.140000+00:00  kern  :emerg : Stack: (0xc41d7ea0 to =
0xc41d8000)
    2021-05-04 14:52:59.141000+00:00  kern  :emerg : 7ea0: c41f0840 c024fdf=
0 00000000 c41f0840 c41d7f50 00001000 c0e04248 00a39810
    2021-05-04 14:52:59.142000+00:00  kern  :emerg : 7ec0: c41d7f4c c41d7ed=
0 c02518a0 c02d3cc0 00001000 beb9f0a0 00a39810 00001000
    2021-05-04 14:52:59.143000+00:00  kern  :emerg : 7ee0: 00000004 0000006=
d 00000f93 c41d7ed8 00000001 c026ce04 c41f0840 00000000
    2021-05-04 14:52:59.183000+00:00  kern  :emerg : 7f00: 0000006d 0000000=
0 00000000 00000000 00000000 00000000 00000000 00000000
    2021-05-04 14:52:59.184000+00:00  kern  :emerg : 7f20: c41d7f5c d694685=
e c41f0840 b6f16420 c41d7f50 c0e04248 c41d7f5c 00a39810
    2021-05-04 14:52:59.185000+00:00  kern  :emerg : 7f40: c41d7f94 c41d7f5=
0 c0251b0c c0251760 00000000 00000000 00000000 c41f0840
    2021-05-04 14:52:59.186000+00:00  kern  :emerg : 7f60: 00000000 d694685=
e 00000000 00000008 b6f16420 00000498 00000003 c0100264
    2021-05-04 14:52:59.187000+00:00  kern  :emerg : 7f80: c41d6000 0000000=
3 c41d7fa4 c41d7f98 c0251b70 c0251aa0 00000000 c41d7fa8 =

    ... (38 line(s) more)  =

 =20
