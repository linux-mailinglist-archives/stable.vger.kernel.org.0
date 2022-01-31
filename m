Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51D8B4A49C5
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 15:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbiAaO7p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 09:59:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349247AbiAaO7p (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 09:59:45 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17012C061714
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 06:59:45 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id b1-20020a17090a990100b001b14bd47532so14101657pjp.0
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 06:59:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kR7A1uVoMQxKRBTUe7PnpcW2omjIYlM4B9vP+tTRaXE=;
        b=s/w/EGCnfWtpn1F/pHH7uk5BqB2ocVIZbu+/xKVDkaC6ysDOQrrQElqv3MxhQRnEhj
         mTuHE8fGhSkhoLnuqGgf9DapaaCHboynO+UTCBbv4yF5eU5U4DSVeR/HUe6Mv13zCTPC
         F/q1CS5n+oKVEpyv6Bu9Ta2jsBCL8ACNnAXtiv3gq+ADTHrSLZ2JHaZSpkTDLSvQf/WD
         UjNUsKI6zCe/PPLc0I6y+1HMFnJ6Y2Mk3E5BL/DtqxuwWMue33+36UbMfm+2fXQ+9rf5
         3VTyPFizJKcBHNtciDuIRtvApl5iLMJx34aZWYfZ5KGp8btUhQAybPQeZgL/h81BLRhI
         uqxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kR7A1uVoMQxKRBTUe7PnpcW2omjIYlM4B9vP+tTRaXE=;
        b=l2ZX9A/+heEScg+p3tUoLlnpCaHR4qLdofB9LNn/RkE603qqWMILWlpnrGejwgRHkm
         W2pcIMJ3bqvVkImh8RU0yTTU7PexyMsEafZQxwzmRkISH42SokE07NoslUhOYrW76rYq
         Qus/TGUykHSmwVZ+yuW3EvQGmAgoKm2nW5SV7082a9lBTmFLMRjahy8yS4I/EIqvQaHk
         1GduFqJY1WvX+04dMiwPG4LouesnBT4b0vbRe8Oqh+R5ORvvyrSAm8DSzrcgAO6W6vCA
         ZP0hUY5UWPDRf/YVK04BATd0+Azc4Xm+8GdHUwb/Qir3Lw4Fw/5EF3MjaJtpc2pJZ2z5
         wyrA==
X-Gm-Message-State: AOAM531TvZvDNtwSOgUKYaiXMVxtb6HfgXZ7vl3ENYFh//nEczavfKnA
        4uVlMlK5Qjj1mq8b+IFhUBATELED6N9aYmOY
X-Google-Smtp-Source: ABdhPJxBXAb+Tft9j5G/BjmnmECf6dwXtfsKsd65KjtjSn0TltiPzNyf3iAai5BW5EVHAJBOcThu+g==
X-Received: by 2002:a17:90b:2385:: with SMTP id mr5mr34296623pjb.186.1643641184433;
        Mon, 31 Jan 2022 06:59:44 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q11sm17059075pfk.149.2022.01.31.06.59.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 06:59:44 -0800 (PST)
Message-ID: <61f7f960.1c69fb81.ffac4.9b78@mx.google.com>
Date:   Mon, 31 Jan 2022 06:59:44 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.227-46-gbb2e6b4c36502
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 89 runs,
 1 regressions (v4.19.227-46-gbb2e6b4c36502)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 89 runs, 1 regressions (v4.19.227-46-gbb2e6b=
4c36502)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.227-46-gbb2e6b4c36502/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.227-46-gbb2e6b4c36502
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bb2e6b4c36502b1902fadedce424125fcd73aa6b =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61f7c07fb1f86a378eabbd28

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.227=
-46-gbb2e6b4c36502/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.227=
-46-gbb2e6b4c36502/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f7c07fb1f86a3=
78eabbd2e
        new failure (last pass: v4.19.227-18-g010821c5a78e)
        2 lines

    2022-01-31T10:56:45.645237  <8>[   21.032958] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-31T10:56:45.690793  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, ksoftirqd/0/9
    2022-01-31T10:56:45.700124  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
