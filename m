Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5C9349E4F0
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 15:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbiA0OqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 09:46:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbiA0OqM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 09:46:12 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55826C061714
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 06:46:12 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id b15so2678064plg.3
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 06:46:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3llGedUlSsxr/LuGkv+Wyz96KOWDxZUz9J7iUZlrnUE=;
        b=EhaD3oelprLSTjW5hJR3gg5WvQHqOzvPaDbLJlwkqmG/Gt4UkjKdvkHSyh6e2Gil0O
         OUl+aNlOXDRPzcqbwqoL42ceODap7YJDUi/3eCIE3bjWJuBvahBTbdxPgrHGPkN1M5my
         9F2yRJiiZi/Zsvx5kgKeSF78J1XxIJfxhxNfr/qFJp/AgaiblPwvXCmE/CROMjNVYK5Q
         tQIsPsWUJb0xFD4DwV8qpWalgC+pLdCda+Wc5pDA/+bBsKXq19Q6InnHRb2Atn8lODI4
         0UMsOyihpSa5hYgqLOnVAIqhAEU5Qr7iBPx+yijBnGWIOtnlJuXi6LBDRJybqDTMqba3
         KW/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3llGedUlSsxr/LuGkv+Wyz96KOWDxZUz9J7iUZlrnUE=;
        b=zvRxUhL7jeXw0dOsTSeSBR6MfX3HiBPfQzULEh3NOFKA2TfeXeijKG619kZRMsH2qk
         /XUyK4+esQel2iTHBqoANmjZJ0KdMs5c2pVHIulHa+4GU3zyj59YQ1HQP5Mn5jSQDDty
         cVL7QREK3kHjXRoKtl+Cp8wTpwGFuJtPrOuzSddnmtivtBHPGPHA7f7RlrhcbS4B8n74
         wM+Iix7bDUCAsMk4O6PCMVF9HV7lefeZZ7bZ3htCoXzF54tm4qXYC1xeCuPf5gjkH22n
         2f53s1Yl/ItErW1sbsMOO7B0jJ7KHeDa9VzBzBNjQuBytbaoOlAjlSWDiDwtfuEY3j+O
         Ejsg==
X-Gm-Message-State: AOAM533KcaaxS5BY0IMhWxpupldeH/rhOPfvFwgg+dnNM2+mhqz0R4Mz
        3+nt7C24rW+34KECk9wQSRj04KCL1pKRrXbynxk=
X-Google-Smtp-Source: ABdhPJyWXz5NqhKoK4mLY1re5l/OrPIQveBKHKGGYPjiWdR8VOVftOQwjTuI3sX8O7TS45Z8P/cyRA==
X-Received: by 2002:a17:902:a512:: with SMTP id s18mr3941077plq.51.1643294771713;
        Thu, 27 Jan 2022 06:46:11 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id om6sm7058622pjb.24.2022.01.27.06.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 06:46:11 -0800 (PST)
Message-ID: <61f2b033.1c69fb81.3fc25.2dd2@mx.google.com>
Date:   Thu, 27 Jan 2022 06:46:11 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.263
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
Subject: stable/linux-4.14.y baseline: 90 runs, 1 regressions (v4.14.263)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 90 runs, 1 regressions (v4.14.263)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.263/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.263
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      bbb957e1bd4a337c0d10d599d284a7475bca47cb =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61f274c69af3eac134abbd3b

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.263/=
arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.263/=
arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f274c69af3eac=
134abbd41
        failing since 44 days (last pass: v4.14.257, first fail: v4.14.258)
        2 lines

    2022-01-27T10:32:16.887185  [   19.941131] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-27T10:32:16.934225  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/101
    2022-01-27T10:32:16.944019  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
