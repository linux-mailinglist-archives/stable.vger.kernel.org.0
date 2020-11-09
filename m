Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1DA2AB019
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 04:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728814AbgKID6r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Nov 2020 22:58:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728038AbgKID6r (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Nov 2020 22:58:47 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B6DCC0613CF
        for <stable@vger.kernel.org>; Sun,  8 Nov 2020 19:58:47 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id i13so1139304pgm.9
        for <stable@vger.kernel.org>; Sun, 08 Nov 2020 19:58:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=J48mbmCu77BHlGPfmO+aAUgS3bMkV/C+7Vs3O/qt3mk=;
        b=1bMdk8Y5AZZOHUqjcHmzt19fM8RFYTjsXeo135Z+K+ng6rSCQGwWTFBAmQXVmUoLoU
         tceP5OUeQ1i435YQJ0xfZaXdJ7jjFXSz6uxVVKRmLrZ/OfO2ItiLyK0NYRlE7BmkXkit
         MkCkdctsZ5iJ5g8TajMiHMNMSlAnf7oYTQTdu1RMSr4y7dBy+5PgQD8nuUChJacnGzB9
         uSaESawdXMBkRlCfyhhPYcXwIHYLnLfwhvlSzdsBrlM6xfPr/FdNI5q29mk+B1YOgyrY
         XcJeTi73cRPpNTA0cpTiL4jEnno8UYiY2CozcWJgYm016iOwHmbe3WqI19FQqdYR247a
         6Bmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=J48mbmCu77BHlGPfmO+aAUgS3bMkV/C+7Vs3O/qt3mk=;
        b=fmVPkd72lELgDZXjb3mOWRjzU5bESGrqpO3IBdqliRi0erh/DNtAyQv0ikuhL0lFb0
         vAfFZiIjPZZNW776a30hmJJHo6BmUoeyBl1qduFIofnMYmUlH244h16K10fm29Xl46XA
         VH1EkgYwrDVcHhvdxOQRXe35TFYXvMtItKneepfcThneOHJHTIdw/Wn/46OO5mGi4t5N
         c1jB0nQ0bVRtaOSgfZMS38pgRaC1wTVQJpu9C8bPnz9P8x6gVhdS3weRDxQUjOKdKhBt
         N3kKBMWjpiiCxjuV7X7JQDTMQtVEzIMpiqugsFlOCsn5wq8LvC7bai3363Om6zzAN6v1
         1FMw==
X-Gm-Message-State: AOAM531Mqpn5BpJQWxe2S2aSPbdbNbiJ9gspktyYWApU3ox0isoJh1i7
        v2n8kN9lxXdksmNbxTTUMYTCWjJOtVZM1g==
X-Google-Smtp-Source: ABdhPJwMLMwBRVpckZbt1YcT1tOivk+OcE1H6cHCpPRDyQZnRap+29WHCVWksBDRvTj0f0tWQd0yuw==
X-Received: by 2002:a05:6a00:782:b029:18b:99e:1a72 with SMTP id g2-20020a056a000782b029018b099e1a72mr8854963pfu.63.1604894326419;
        Sun, 08 Nov 2020 19:58:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j11sm9470887pfe.80.2020.11.08.19.58.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2020 19:58:45 -0800 (PST)
Message-ID: <5fa8be75.1c69fb81.3a563.4a15@mx.google.com>
Date:   Sun, 08 Nov 2020 19:58:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.75-63-g46f91663a79d
Subject: stable-rc/queue/5.4 baseline: 204 runs,
 1 regressions (v5.4.75-63-g46f91663a79d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 204 runs, 1 regressions (v5.4.75-63-g46f91663=
a79d)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.75-63-g46f91663a79d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.75-63-g46f91663a79d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      46f91663a79db905839efcab687acbc6f57555dc =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/5fa88a112c0cff0816db8878

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.75-63=
-g46f91663a79d/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.75-63=
-g46f91663a79d/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa88a112c0cff0816db8=
879
        new failure (last pass: v5.4.75-41-gac2add4cf5bb) =

 =20
