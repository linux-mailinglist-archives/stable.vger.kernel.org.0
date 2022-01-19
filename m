Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED1B1493255
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 02:28:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350678AbiASB2z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 20:28:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344934AbiASB2z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 20:28:55 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F92C061574
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 17:28:55 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id w204so1002280pfc.7
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 17:28:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GOWS/jGr00I7lzU+oynFKtXBWl+6uxl/BK7DRMVEdRk=;
        b=kSsAul67dHPYJBzSVxF2UlcVQgI+lMOTaMAmWbr8+IILphR18Eg55/bJMVd0kGf0TL
         j6bTtmNaw5AWjdZWrG13ssFTRmF+eLZUH4j4W+PH+k+UZPQo8RhZI4/uYHokg8/Tairn
         hEuT7iZzwYdmzqsEpfWtdIBBy2v+g8tYJUUyXT3/yxvFPtQIAJYWUSxOn0d3OKGRQNAd
         ApgvAEhbiVfu5+WWaPpwvAAFDQy/VtFj9JH7kEf7vVaVgPM9Sv8XxZNehT11XUKSYyDk
         iOeYBFfqiusNaiO2zqvzPzUNVvw0U/BTAowkzg+v8P+0BuhPac5eLlCO3yca9r8B68PF
         XVUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GOWS/jGr00I7lzU+oynFKtXBWl+6uxl/BK7DRMVEdRk=;
        b=rBe0aMVX5H2krwtjsosStbHQJ/A7zdZnsxr0m2fWff/1u4aVeA3RLnA0eeJTgrog9z
         tzhx+0QYieA5Vn+zEYwQww4VeK+7Kbb8FD47preI4qhJS06xqq4eTcM1a3Uc/vvRnzC/
         zUSWMj2mjvYwoh3dO+JQ15Fvj6gneKyvGI+ur9TcTl87EocIYOwkS83dQQntLETPmXDz
         m+z4a/iypVV9VnA/alaM7WHHV+vn/DiUz/1oxcH3oNolEXgPnP94clnnUm5NxjvBWqLG
         o1HLM+iNQB+FG+g8PL+U0nOWd2dWt+yq8/ciQw+DhiH+GtX1viKRHTQG1/iJ+pOSFPN8
         byfQ==
X-Gm-Message-State: AOAM532WUmR3eoPmNzwZ0Z1wFSdE6wo7P3QZsdiNQPnfCYfY+C42rmcz
        cWE8wR9W6ikRfu3YQyGn7QKREViJKOFMoyk8
X-Google-Smtp-Source: ABdhPJy0r2E7layphavXxdP8iqBukJm62se6gb5SF6cFHX1OkH5GBeCFzzsbu0uWQPxpJVS4ilnK/w==
X-Received: by 2002:a63:bf4b:: with SMTP id i11mr25074238pgo.214.1642555734380;
        Tue, 18 Jan 2022 17:28:54 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id pj6sm3892510pjb.21.2022.01.18.17.28.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 17:28:53 -0800 (PST)
Message-ID: <61e76955.1c69fb81.e58f0.adea@mx.google.com>
Date:   Tue, 18 Jan 2022 17:28:53 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.225-22-gc200d1712464
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 144 runs,
 3 regressions (v4.19.225-22-gc200d1712464)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 144 runs, 3 regressions (v4.19.225-22-gc20=
0d1712464)

Regressions Summary
-------------------

platform   | arch | lab           | compiler | defconfig             | regr=
essions
-----------+------+---------------+----------+-----------------------+-----=
-------
da850-lcdk | arm  | lab-baylibre  | gcc-10   | davinci_all_defconfig | 2   =
       =

panda      | arm  | lab-collabora | gcc-10   | omap2plus_defconfig   | 1   =
       =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.225-22-gc200d1712464/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.225-22-gc200d1712464
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c200d1712464e368bc302df04642b8b90c0f3957 =



Test Regressions
---------------- =



platform   | arch | lab           | compiler | defconfig             | regr=
essions
-----------+------+---------------+----------+-----------------------+-----=
-------
da850-lcdk | arm  | lab-baylibre  | gcc-10   | davinci_all_defconfig | 2   =
       =


  Details:     https://kernelci.org/test/plan/id/61e7332921c1ff8863abbd58

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: davinci_all_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
25-22-gc200d1712464/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-=
da850-lcdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
25-22-gc200d1712464/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-=
da850-lcdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/61e7332921c1ff8=
863abbd5f
        new failure (last pass: v4.19.225)
        6 lines

    2022-01-18T21:37:34.486441  kern  :alert : BUG: Bad page state in proce=
ss swapper  pfn:c3000
    2022-01-18T21:37:34.487131  kern  :alert : raw: 00000000 00000100 00000=
200 00000000 00000004 0000000a ffffff7f 00000000
    2022-01-18T21:37:34.487573  kern  :alert : page dumped because: nonzero=
 mapcount
    2022-01-18T21:37:34.487981  kern  :alert : BUG: Bad page state in proce=
ss swapper  pfn:c3400
    2022-01-18T21:37:34.488374  kern  :alert : raw: 00000000 00000100 00000=
200 00000000 00000004 0000000a ffffff7f 00000000
    2022-01-18T21:37:34.488805  kern  :alert : page dumped because: nonzero=
 mapcount
    2022-01-18T21:37:34.524435  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D6>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e7332921c1ff8=
863abbd60
        new failure (last pass: v4.19.225)
        4 lines

    2022-01-18T21:37:34.660971  kern  :emerg : page:c6f49000 count:0 mapcou=
nt:-128 mapping:00000000 index:0x4
    2022-01-18T21:37:34.661774  kern  :emerg : flags: 0x0()
    2022-01-18T21:37:34.662450  kern  :emerg : page:c6f51000 count:0 mapcou=
nt:-128 mapping:00000000 index:0x4
    2022-01-18T21:37:34.663080  kern  :emerg : flags: 0x0()
    2022-01-18T21:37:34.728663  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Deme=
rg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>
    2022-01-18T21:37:34.729417  + set +x
    2022-01-18T21:37:34.730002  <8><LAVA_SIGNAL_ENDRUN 0_dmesg 1415841_1.5.=
2.4.1>   =

 =



platform   | arch | lab           | compiler | defconfig             | regr=
essions
-----------+------+---------------+----------+-----------------------+-----=
-------
panda      | arm  | lab-collabora | gcc-10   | omap2plus_defconfig   | 1   =
       =


  Details:     https://kernelci.org/test/plan/id/61e738501c86203731abbd30

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
25-22-gc200d1712464/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
25-22-gc200d1712464/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e738501c86203=
731abbd36
        failing since 15 days (last pass: v4.19.223, first fail: v4.19.223-=
28-g8a19682a2687)
        2 lines

    2022-01-18T21:59:28.949009  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/101
    2022-01-18T21:59:28.966119  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2022-01-18T21:59:28.988162  <8>[   21.467498] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>
    2022-01-18T21:59:28.988710  + set +x   =

 =20
