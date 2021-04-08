Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA1A3588F6
	for <lists+stable@lfdr.de>; Thu,  8 Apr 2021 17:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbhDHPz1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Apr 2021 11:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231923AbhDHPz0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Apr 2021 11:55:26 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 392C7C061760
        for <stable@vger.kernel.org>; Thu,  8 Apr 2021 08:55:15 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id t23so1365590pjy.3
        for <stable@vger.kernel.org>; Thu, 08 Apr 2021 08:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lf57ptBQIN3bT5Loe4cXX8fF6+Ato5UJ/T01iNM5uT0=;
        b=R/mreubbSEFAQXKv+Cj9GR9L2Cwp02e0WucUMgrvw3OsV0CD3qgleFyDZAnmaEkjyg
         LfUQD/EE8qj1Sm/xGo5iGNTalN9kRWoedK46N1M5zAsi2JA9nuTX2e+H/4z5jO/qkXD1
         Ycs+SipS3WKJBsrVM7AeZp6bL5hnaCJU+W0TQdEht4zMEB6Q209ZcXv8pUEDLlvBb/Um
         EzAAcFgSDPs1Slw3LY3iKwLuuHmUQrhROvMzgFohtpuY0TbSgw0M1yXPfkUli/qE7LFs
         lxGCQVP9hsLKHMWedtyXMz4IK4Fus69QWATo+2BuVeuNHo1fKtDUNKL+X2vc5p6AhnQG
         7oJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lf57ptBQIN3bT5Loe4cXX8fF6+Ato5UJ/T01iNM5uT0=;
        b=C3x08ZIz2wCrMEAr/YPyDn8q74fkdIss2aY+XjiUMUFBbEFaRUweimTWau9jh1un6I
         xUI6SdwygP5ILA6g/fYyVGOezBT5QnYgBEphw6kUeSPcvm+Hqtlfi8K+oi0lgO5u6wkE
         gVE/aVi+6BtZQAgly8E+9AEl099G27CqcnHQtmhzIqQV7emeW0REvpnpatXkLDC0D0Br
         7CKWmSjSjfHC/bsxJ6y3EvDnvbJXne8Yc7LhCHn6xOj4f5qe0MCJ5I3JF8cUwMFwVY3y
         qLKVmlME4x7SXM+crcZ/n1p0GNfc3/BzmAIIP9Tukzz/64LgnGafu+X8hWBy83In//tm
         5I4g==
X-Gm-Message-State: AOAM530NRX+Nb/UtSRbgqolvxbHWK3zQIKNxmvYE/qElxNfGd8NsMyHs
        fawdvxl3UHvBSu3H/ejc6OUC6yrn0XDkSVoW
X-Google-Smtp-Source: ABdhPJyzQgR/CFjP7zM41WfmJUtxv/X+7wZyboC0Z/ljHYLYHDIGW/ngL8yFL5CbiCgVxBOZyPIn1Q==
X-Received: by 2002:a17:902:db02:b029:e8:fdd4:53c0 with SMTP id m2-20020a170902db02b02900e8fdd453c0mr8252766plx.28.1617897314503;
        Thu, 08 Apr 2021 08:55:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e14sm18518087pga.14.2021.04.08.08.55.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 08:55:14 -0700 (PDT)
Message-ID: <606f2762.1c69fb81.ba203.d1da@mx.google.com>
Date:   Thu, 08 Apr 2021 08:55:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.28-31-gcf92265c2e596
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 174 runs,
 2 regressions (v5.10.28-31-gcf92265c2e596)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 174 runs, 2 regressions (v5.10.28-31-gcf9226=
5c2e596)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 2=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.28-31-gcf92265c2e596/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.28-31-gcf92265c2e596
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cf92265c2e5967ba787f992481c06fa4708d6ac6 =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 2=
          =


  Details:     https://kernelci.org/test/plan/id/606eefa7cb8c02e6dfdac6c1

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.28-=
31-gcf92265c2e596/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.28-=
31-gcf92265c2e596/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/606eefa7cb8c02e=
6dfdac6c5
        new failure (last pass: v5.10.28-31-g95a6260004b2f)
        4 lines

    2021-04-08 11:57:12.818000+00:00  kern  :alert : Unable to handle kerne=
l paging request at virtual address 90c419ce
    2021-04-08 11:57:12.820000+00:00  ke<8>[   42.529634] <LAVA_SIGNAL_TEST=
CASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/606eefa7cb8c02e=
6dfdac6c6
        new failure (last pass: v5.10.28-31-g95a6260004b2f)
        35 lines

    2021-04-08 11:57:12.824000+00:00  kern  :alert : [90c419ce] *pgd=3D0000=
0000
    2021-04-08 11:57:12.869000+00:00  kern  :emerg : Internal error: Oops: =
5 [#1] ARM
    2021-04-08 11:57:12.871000+00:00  kern  :emerg : Process udevd (pid: 99=
, stack limit =3D 0xbf56cba6)
    2021-04-08 11:57:12.871000+00:00  kern <8>[   42.572122] <LAVA_SIGNAL_T=
ESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D35>
    2021-04-08 11:57:12.872000+00:00   :emerg : Stack:<8>[   42.583014] <LA=
VA_SIGNAL_ENDRUN 0_dmesg 75767_1.5.2.4.1>   =

 =20
