Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D892F26D5B3
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 10:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbgIQIHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 04:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726455AbgIQIHu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Sep 2020 04:07:50 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6B6C06174A
        for <stable@vger.kernel.org>; Thu, 17 Sep 2020 01:07:49 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id m15so710563pls.8
        for <stable@vger.kernel.org>; Thu, 17 Sep 2020 01:07:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=b/idwmBeeDiktp7fv44zTiwbxXrN5/7aAxLGsZR3M6g=;
        b=WxhC6y8ymOV+P4xEbsRJdmsDpa5pmI4NAk5x+FmfjDSnMsXXyXhVH+5weQpp4HAgs7
         QDVKDVOyBwcakK8bdjT2hYBAolob/mgQ5Kluz9JB80q/eZbwdYfnBW75AePj+O3+3NZD
         T5azUzluXJgnBAnsFSdm7s5wSKIBsKZcf9NNK/a9AIXSYEIxq++3RMCtZrdCGazqLPhC
         yub01gS517aJC2EaOswVh3/c8dpfwSm0KGPqCyKxtNAePf8FR9utYMYWdSYTTBY+rMHC
         F6fDJygl6TPEK/pnG1stzKxrr6zRNkvXx6YzxCzD1rqO4T8Jk8Eo1+EsEzLO81e/nzcV
         t7qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=b/idwmBeeDiktp7fv44zTiwbxXrN5/7aAxLGsZR3M6g=;
        b=cCk9nhQtcIXVj7zlhU3AIDnUuCk2X4JCBbmDBV/Oep+agOfqwEM/GoP7AriIxFIVLF
         8M9G4p5MGb6wKnREJzZEVGpmlsY7EcbTjSIT/q9YWp5iJUjsAZK5PCnVdoNpC7qIlUiv
         KrYrmOgtgh+EgqE8tCLb8F772nBHgcX15bYHWhmTVPjUYM5qMvOnskg9xHs9TTlVLcRw
         KEFik4ahl0IgiGdULBOO5DfXbYAuP3MlP3j80dxUF7oNwmkYI2XgvrSfQObHRJVYdvd8
         T4IGRiIe6OJo0qJrZaXWYahO6n/JlsrIY0lLZdwRnhedjjt3T4VQfYRga57Y93PLNdpC
         iduw==
X-Gm-Message-State: AOAM531KtNm6w07lL1/UVhFwQfaMvagf8Aq81F03e4tgEhNQXHZ3DEC1
        /PBT0LOWwUP8BApc73gCvfyJKm0SP7DX9w==
X-Google-Smtp-Source: ABdhPJxZ5cGOYuwkFOhuF1bWGV56Jx9FA3pPXi44InqWuO1LchK40th2Zhu3/mkYZiI7YLzrgzHhQQ==
X-Received: by 2002:a17:90a:67cb:: with SMTP id g11mr7416598pjm.56.1600330068913;
        Thu, 17 Sep 2020 01:07:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e13sm4861150pjy.38.2020.09.17.01.07.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2020 01:07:48 -0700 (PDT)
Message-ID: <5f631954.1c69fb81.aebd3.b380@mx.google.com>
Date:   Thu, 17 Sep 2020 01:07:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.65-129-gf079af674800
Subject: stable-rc/queue/5.4 baseline: 195 runs,
 2 regressions (v5.4.65-129-gf079af674800)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 195 runs, 2 regressions (v5.4.65-129-gf079af6=
74800)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig         | r=
esults
-------------------+------+--------------+----------+-------------------+--=
------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 2=
/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.65-129-gf079af674800/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.65-129-gf079af674800
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f079af674800d11c53834712587c0f3ba98e9868 =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig         | r=
esults
-------------------+------+--------------+----------+-------------------+--=
------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 2=
/4    =


  Details:     https://kernelci.org/test/plan/id/5f62defbfe9a10a02bbf9dc0

  Results:     2 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.65-12=
9-gf079af674800/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.65-12=
9-gf079af674800/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/5f62defbfe9a10a=
02bbf9dc5
      new failure (last pass: v5.4.65-129-ge31830c7a7a4)
      4 lines

    2020-09-17 03:58:39.975000  kern  :alert : Unable to handle kernel NULL=
 pointer dereference at virtual address 00000015
    2020-09-17 03:58:39.976000  kern  :alert : pgd =3D 326eaede
    2020-09-17 03:58:39.976000  kern  :alert : [00000015] *pgd=3D2ae86835, =
*pte=3D00000000, *ppte=3D00000000
     * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f62defbfe9a=
10a02bbf9dc6
      new failure (last pass: v5.4.65-129-ge31830c7a7a4)
      40 lines

    2020-09-17 03:58:39.978000  kern  :emerg : Process udevd (pid: 93, stac=
k limit =3D 0xa01e0e76)
    2020-09-17 03:58:39.982000  kern  :emerg : Stack: (0xeaea5b88 to 0xeaea=
6000)
    2020-09-17 03:58:40.019000  kern  :emerg : 5b80:                   eaea=
5ba4 eaea5b98 c0278d1c c0278cfc eaea5c6c eaea5ba8
    2020-09-17 03:58:40.019000  kern  :emerg : 5ba0: c0279d04 c0278d18 eaea=
5c88 00000000 00000001 eaea5c88 eaea5bec ec004368
    2020-09-17 03:58:40.020000  kern  :emerg : 5bc0: 00000001 00000000 0001=
2cc0 eaea5c40 00000001 ecf77280 00112cc0 00000000
    2020-09-17 03:58:40.021000  kern  :emerg : 5be0: ec004278 00080000 0000=
0002 00000000 00000002 00000000 00000001 00000000
    2020-09-17 03:58:40.022000  kern  :emerg : 5c00: eaea5c24 eaea5c10 c01f=
0598 c01ef78c ecf77280 c0d04248 eaea5c34 eaea5c28
    2020-09-17 03:58:40.062000  kern  :emerg : 5c20: c01f0c8c c01f0588 eaea=
5c6c eaea5c38 c01e54b0 c01f0c80 eaea5c40 10a2bff4
    2020-09-17 03:58:40.063000  kern  :emerg : 5c40: 00000000 00000001 c0d0=
4248 ecf77280 eaea5d8c ec004368 00000100 00000122
    2020-09-17 03:58:40.063000  kern  :emerg : 5c60: eaea5d04 eaea5c70 c027=
9fa8 c0279810 00000000 ecf77280 00000001 00000001
    ... (29 line(s) more)
      =20
