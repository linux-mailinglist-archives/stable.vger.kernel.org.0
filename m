Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B118297CE9
	for <lists+stable@lfdr.de>; Sat, 24 Oct 2020 16:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1760031AbgJXOsh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Oct 2020 10:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756171AbgJXOsg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Oct 2020 10:48:36 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC37C0613CE
        for <stable@vger.kernel.org>; Sat, 24 Oct 2020 07:48:36 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id i26so3051398pgl.5
        for <stable@vger.kernel.org>; Sat, 24 Oct 2020 07:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VR/440Jamf40v0cddrogKv7/iq1ZW7njcLK1CxQVhFA=;
        b=guhopwN/r19JBX00EhaaIVZMvjobtAzctdwoERKcY+u0FZKBqCKJp3vveVO6s4APSr
         LRGlU5bDUgqsA5dT38a4IEBFt88IgUdm+7xVTjapHrI4i5Eb8/xTwo9U62pW2Lke2WVe
         rzOfiuK8NCrTF8/gOTn+tmYsAaAqqo2MjF1LAs+hp0+hJiXLvhirS5u7QmCtGqWT8iO7
         iHbaPq/fo+HZk2x1yQ6j4DUtLTL3WEdJnMN777VpK6+5BnH6Nm1ggtZerhg4WHgFGBBR
         y//PBoMjroiU5doDZqJwDi6zovICBFZ6DrDTYE2tbSzlTW/ZSFVpVrmwHRz9vEg2I1zm
         wm4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VR/440Jamf40v0cddrogKv7/iq1ZW7njcLK1CxQVhFA=;
        b=sKYGf8INw5/ZioLpWJVCHvMX5OCG/qmZ0/csVW5NRY6hLYSW4o4dBDehXI2X0/Bgyo
         WyJtej5HpfB/kmIjdk9CxOE7dRHMUH4A6CxJreSJdeP3KnCIQRfWGFY0ssZXxfmVwaaP
         CfJuihZhqL0H/qIwH97yzYki/eYsORlOc9Na8JRuusajOTyo8Ut0rkCGXAlKZNQLtAHo
         l7zpZQRMAmCClMt8w2YUpveeDoE0qXm8fqTFPsnj1Fm9fwy9eO7iJ9oaxNZBZvoOd3pO
         st0rAv0Xk8EwjnG1vEE8qIFsPGfEAs9+ih8kjATv1jYbDBNsbAFzcU4GloBOrP3N6j1o
         ruyA==
X-Gm-Message-State: AOAM5339QBzFpmNmfxC2GxDQQN+JwBreeNNu78Ckrb+YerXhwxxHJk7F
        QF4NvqOTW7LsiZfNtH+Puu1rGs+9l/rfXQ==
X-Google-Smtp-Source: ABdhPJxmc4FZCBMxv/CJ1Ab9RHSmDG/ytyaXtM3oCSvB3fXgADNyJKlBjCQY4ZJM+a1VFwNw3MapHQ==
X-Received: by 2002:aa7:8588:0:b029:152:a38c:fbba with SMTP id w8-20020aa785880000b0290152a38cfbbamr7682074pfn.0.1603550915771;
        Sat, 24 Oct 2020 07:48:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 32sm5512862pgz.11.2020.10.24.07.48.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2020 07:48:35 -0700 (PDT)
Message-ID: <5f943ec3.1c69fb81.3625b.9478@mx.google.com>
Date:   Sat, 24 Oct 2020 07:48:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.240-18-ge29a79b89605
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 98 runs,
 3 regressions (v4.4.240-18-ge29a79b89605)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 98 runs, 3 regressions (v4.4.240-18-ge29a79b8=
9605)

Regressions Summary
-------------------

platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-8    | omap2plus_defconfig | 2      =
    =

panda     | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.240-18-ge29a79b89605/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.240-18-ge29a79b89605
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e29a79b89605e13367fd24e0ccca3fc09ba1ca1d =



Test Regressions
---------------- =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-8    | omap2plus_defconfig | 2      =
    =


  Details:     https://kernelci.org/test/plan/id/5f940c61cc46a1128638101f

  Results:     2 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-1=
8-ge29a79b89605/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-1=
8-ge29a79b89605/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f940c62cc46a112=
86381024
        new failure (last pass: v4.4.240-5-g7222bd699321)
        1 lines

    2020-10-24 11:11:45.122000+00:00  Connected to omap3-beagle-xm console =
[channel connected] (~$quit to exit)
    2020-10-24 11:11:45.122000+00:00  (user:) is already connected
    2020-10-24 11:11:45.122000+00:00  (user:) is already connected
    2020-10-24 11:11:45.122000+00:00  (user:) is already connected
    2020-10-24 11:11:45.122000+00:00  (user:) is already connected
    2020-10-24 11:11:45.123000+00:00  (user:) is already connected
    2020-10-24 11:11:45.123000+00:00  (user:) is already connected
    2020-10-24 11:11:45.123000+00:00  (user:) is already connected
    2020-10-24 11:11:45.123000+00:00  (user:) is already connected
    2020-10-24 11:11:45.124000+00:00  (user:) is already connected =

    ... (464 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f940c62cc46a11=
286381026
        new failure (last pass: v4.4.240-5-g7222bd699321)
        28 lines

    2020-10-24 11:13:33.380000+00:00  kern  :emerg : Stack: (0xcb92bd10 to =
0xcb92c000)
    2020-10-24 11:13:33.388000+00:00  kern  :emerg : bd00:                 =
                    bf02b8fc bf010b84 cbbedc10 bf02b988
    2020-10-24 11:13:33.396000+00:00  kern  :emerg : bd20: cbbedc10 bf2200a=
8 00000002 cb9bf010 cbbedc10 bf24ab54 cbc7b390 cbc7b390
    2020-10-24 11:13:33.404000+00:00  kern  :emerg : bd40: 00000000 0000000=
0 ce228930 c01fb3d0 ce228930 ce228930 c0857e88 00000001
    2020-10-24 11:13:33.412000+00:00  kern  :emerg : bd60: ce228930 cbc7b39=
0 cbc7b450 00000000 ce228930 c0857e88 00000001 c09612c0
    2020-10-24 11:13:33.420000+00:00  kern  :emerg : bd80: ffffffed bf24eff=
4 fffffdfb 00000028 00000001 c00ce2f4 bf24f188 c04070c8
    2020-10-24 11:13:33.428000+00:00  kern  :emerg : bda0: c09612c0 c120da3=
0 bf24eff4 00000000 00000028 c040559c c09612c0 c09612f4
    2020-10-24 11:13:33.437000+00:00  kern  :emerg : bdc0: bf24eff4 0000000=
0 00000000 c0405744 00000000 bf24eff4 c04056b8 c0403a68
    2020-10-24 11:13:33.445000+00:00  kern  :emerg : bde0: ce0b08a4 ce22191=
0 bf24eff4 cbc83640 c09dd3a8 c0404bb4 bf24db6c c095e460
    2020-10-24 11:13:33.453000+00:00  kern  :emerg : be00: cbd136c0 bf24eff=
4 c095e460 cbd136c0 bf252000 c040617c c095e460 c095e460 =

    ... (16 line(s) more)  =

 =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/5f940c61a7af909eae38103e

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-1=
8-ge29a79b89605/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-1=
8-ge29a79b89605/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f940c61a7af909=
eae381045
        new failure (last pass: v4.4.240-11-g59c7a4fa128e)
        2 lines =

 =20
