Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB7F6A9FD8
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 20:02:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbjCCTCs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 14:02:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbjCCTCr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 14:02:47 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E18125E28
        for <stable@vger.kernel.org>; Fri,  3 Mar 2023 11:02:46 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id m8-20020a17090a4d8800b002377bced051so7196791pjh.0
        for <stable@vger.kernel.org>; Fri, 03 Mar 2023 11:02:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1677870165;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=t7BAVKAmNvaKS/DRu1uRQuSXmbaMg+kQ+9llEJ3TFpE=;
        b=p3Q12LPI+z2hqTASQyXEN1hsMS3iv21SXbKPo2U4fiC2fJLoRGsLiPV2O/ZyvN7tzd
         XOsTWdHAipJ+ejXtcu8kd1plfdsR5ojgop2y0dKZqFlJYDTF40PBKB9psXivDTisq1ul
         IljTYjYUET7ePjettR9Q/nWWsIo8PbrLD6t9V4w4AP0tEguFJJzq/OQqhhgGQv4Ktzxb
         TjDphQGotCc9sZZV9VM9V4+VSBkkOdLivLHchamuHapdwCoqBLGmN0jRjY2FbQPbtu9h
         87c3NBJy6w6Igf64C5QcR1SxvaWszitlY5JcQexx+NnxD6NiTzqQIPEhb5/GDPCKvii1
         auuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677870165;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t7BAVKAmNvaKS/DRu1uRQuSXmbaMg+kQ+9llEJ3TFpE=;
        b=TkJOwP6fTyhComfaelY1nCeOZGERqg/IyrgaKUUGCJvHctnVenoPL5xAvLMJCx9kdi
         mYGNpa08i5YbJSm5+Bs7pwAb8HSBwPKn4ctZlCAG8G1EQdvo5WzCryX6bNwKExHnbU9L
         Le1fJiHUAcMrqrvLU0EdhU2YJ2MxX4iUQ49Hc+h0z4vDhHbLYbpWTfgC08qxjWi7bPex
         A3qgUdq8VH5UQlxJbSjhTCDdbf9jalUrZCHc958+lNW9gKTTKLreR+mhMWPEDWkNOygW
         0J1Q2kLh2iSKK73m/030atJGvk9rkWgl+KQIPRNg5MMXIyCF3wdvvjbPVKYmWpmhQhpY
         Zu2g==
X-Gm-Message-State: AO0yUKWBF8DPslCNzGU8a9KVWGFy9wPfOYW/joQhOSdv1jLdhkM8sC1Q
        lGzOYTrnnn3RH57RfgVzqTfzqv366qR/hebH4zw=
X-Google-Smtp-Source: AK7set/0uA+T3DHhHmSrWMOITzg6bmwrIpwZ0MNJSTvcHmRVawan3l3Jm7hMu+mk/SvZnnIaqeK48g==
X-Received: by 2002:a17:903:120b:b0:19e:82aa:dc8a with SMTP id l11-20020a170903120b00b0019e82aadc8amr3365547plh.22.1677870165544;
        Fri, 03 Mar 2023 11:02:45 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id kv3-20020a17090328c300b0019c922911a2sm1844409plb.40.2023.03.03.11.02.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 11:02:45 -0800 (PST)
Message-ID: <64024455.170a0220.a072f.3e11@mx.google.com>
Date:   Fri, 03 Mar 2023 11:02:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-6.1.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v6.1.15
X-Kernelci-Report-Type: test
Subject: stable/linux-6.1.y baseline: 186 runs, 1 regressions (v6.1.15)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-6.1.y baseline: 186 runs, 1 regressions (v6.1.15)

Regressions Summary
-------------------

platform        | arch | lab           | compiler | defconfig       | regre=
ssions
----------------+------+---------------+----------+-----------------+------=
------
qemu_mips-malta | mips | lab-collabora | gcc-10   | malta_defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable/branch/linux-6.1.y/kernel/=
v6.1.15/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-6.1.y
  Describe: v6.1.15
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      42616e0f09fb4e9a6c59892a227f7bdefbd2d6d3 =



Test Regressions
---------------- =



platform        | arch | lab           | compiler | defconfig       | regre=
ssions
----------------+------+---------------+----------+-----------------+------=
------
qemu_mips-malta | mips | lab-collabora | gcc-10   | malta_defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/64020ed477f9967f958c8646

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.15/mip=
s/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mips-malta.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.15/mip=
s/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mips-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/mipsel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/64020ed477f9967=
f958c864a
        failing since 6 days (last pass: v6.1.12, first fail: v6.1.14)
        1 lines

    2023-03-03T15:14:09.973565  kern  :alert : CPU 0 Unable to handle kerne=
l paging request at virtual address 24679f58, epc =3D=3D 802018e4, ra =3D=
=3D 80204234
    2023-03-03T15:14:09.973833  =


    2023-03-03T15:14:10.030467  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
    2023-03-03T15:14:10.030648  =

   =

 =20
