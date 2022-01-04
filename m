Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58C0E4846BB
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 18:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233299AbiADRN4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 12:13:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231733AbiADRN4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 12:13:56 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1A99C061761
        for <stable@vger.kernel.org>; Tue,  4 Jan 2022 09:13:55 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id co15so31875326pjb.2
        for <stable@vger.kernel.org>; Tue, 04 Jan 2022 09:13:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wj2EiLDj+U9YykxLoREnbWv2+G0TgQhl2EADR40s3DA=;
        b=b5/EeS1H8nZiAjIETd5MUbS8yR1a1la2u4XobbxdbpVtqcBNVsDbD9IxRNZ4fNxavG
         wpK0+ymaTvtMPW7ijPu/QgL0qJiP2FrtebVw4giYvj9ev6mW4ZDkiCo8Da2n3Ghw5WEz
         jzhh+ojAofkNOKTwJw6GjdTdb7ueL0xw8FpOxHIMShHSzAR/TqF69z5S8Pf9Aw+pDN0N
         HebUVs8ztKfJL36+adjDeHsx+h9r5wZbBpX6HokYQcbR04nhxth6XdUCYcd5rYAihvZz
         9qy+AlkrcX5rO7cPlPM4ohUwte7noNPOPhQpU2XIErTzuz6wIygCS25GqEXzlDtjegiq
         25vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wj2EiLDj+U9YykxLoREnbWv2+G0TgQhl2EADR40s3DA=;
        b=KUn6TkJb0uscZGKC4J3r6bkW9g6yJsGbr1gV/bW6bZDw8ElxHjbqwUasqtONPBSpNI
         QOHRvYm4uhwE8t4lqj+E/y69e7WeNdacampozDWS8+wjgtyowrbZkg66s3b/Wdy+kgte
         xE/jUkEk5C2H4AQYebhb54uQGr0Aq72x9ecJ6kyawUzGlq9YViJ4XVujC5/nLYRw2nrQ
         66XFr9/NLAU3mMDNlAAsk1rOcLCQUa+bFFEaUMm8sO/TPrCcwfkvW/4MYP2s/LjtFuaG
         f57Xa96fUQc891c/FRH/0/c4h7Fq5e4iLPMMn0lImhfnW9CAyBZ2xq//Teh/BpoHiPRq
         xHzw==
X-Gm-Message-State: AOAM531LH4iKzddVUKTO9e+x9+y0OLu7nrvAust2LYd+uv0kc91lVN4E
        ZYV0iRcifWB+QR1LhPCx3+PFFv/hLoKWFKyr
X-Google-Smtp-Source: ABdhPJy6BhEJp6XTV0E49vNAaVp+xCoZYwt7mZo9E1Nvxgf8TO/hJQMYrIVZwO5SZAw2gcpqxlYiDA==
X-Received: by 2002:a17:90a:5411:: with SMTP id z17mr23449467pjh.176.1641316435208;
        Tue, 04 Jan 2022 09:13:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id bk17sm43201043pjb.3.2022.01.04.09.13.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 09:13:55 -0800 (PST)
Message-ID: <61d48053.1c69fb81.75324.49bf@mx.google.com>
Date:   Tue, 04 Jan 2022 09:13:55 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.295-13-gf65af3015b1d
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 102 runs,
 1 regressions (v4.9.295-13-gf65af3015b1d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 102 runs, 1 regressions (v4.9.295-13-gf65af30=
15b1d)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.295-13-gf65af3015b1d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.295-13-gf65af3015b1d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f65af3015b1dc9e0b99d1a258c7ea9777d76b3b0 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61d44c86ec00387c9def6768

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.295-1=
3-gf65af3015b1d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.295-1=
3-gf65af3015b1d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d44c86ec00387=
c9def676b
        failing since 7 days (last pass: v4.9.294-8-gdf4b9763cd1e, first fa=
il: v4.9.294-18-gaa81ab4e03f9)
        2 lines

    2022-01-04T13:32:36.279482  [   20.451721] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-04T13:32:36.322733  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/125
    2022-01-04T13:32:36.331679  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2022-01-04T13:32:36.347357  [   20.521087] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
