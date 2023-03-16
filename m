Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4C06BD59B
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 17:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbjCPQa3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 12:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbjCPQaY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 12:30:24 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDDCE305EC
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 09:30:04 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id qe8-20020a17090b4f8800b0023f07253a2cso2125629pjb.3
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 09:30:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678984204;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=6ozIxDm9Bx3iqMM/Jme10Frkz5QMP2fAkBSyxA66+yI=;
        b=RCK7o4gGBry/Ss8eRdmAo6PXsnyyK7Sy4GGPjI2rnqJqd/xTEMEy00iOO5Y4e9aT2q
         OFD96L4eFUGb5ODtNmMZJrjkCeVoZz7ZvN388O8R2eYSAyC7wxD23VIYx1N2XuXUVQw4
         P3sZLj0CZXzZzwI2T+1rViKQaW+nBNxKlppHBodFKj0mw4g9sIqFuzcGf8ueQZ20lp34
         yNpwp/ET5QctRCyNXWkAjzg6fUWmOIQYaTj0KBX1YUjc0NMCGUG9MsjAuwXITVh72DR/
         rMj0y7owmMzto94g356K+l/+qjMjJalWuZZMEWkqUOf3bUasZe/r3J2YhzapXccsldJk
         2icA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678984204;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6ozIxDm9Bx3iqMM/Jme10Frkz5QMP2fAkBSyxA66+yI=;
        b=hZ2CK0bek2Xk+gUB4lcoDI/pNY8ID0pcIRx3Og9QbC2MqJbARJ0J9RjOyrBAnNqU9e
         Bu/qAXxhZ1AgRlt6g8r+sKr4SvCgu3gy/m6MSUikNfEMa6BU4JqHR7KJq6QCLnkd5Gvg
         kWnYu0Hwi+3rx41TCeeEw+RXajgqNVanAYHxVMwpN0y9l0hEsN3xCM7/gDaeHeZJEJoS
         dACNbOj1iDMYwMaPqRBLJ1Vm5WTJa96GQvWmTodUQddFONYlKiKBBXHTu9NewtkkOlzd
         KCXIlZnQ9JLVAo42XSQCEVrQkdGxCo3vWz0q3H6Aa0uVfF+6slF763vhc/D2izj9nC4r
         bi+w==
X-Gm-Message-State: AO0yUKUQUlennewP3gQMd1TUJKW/gMHqJL3WZZiLynGsltMziMmJ8f43
        XkW8hfSU47JMVZGFuCaa2JXOYfEgytep4KKKL/XlK5Iw
X-Google-Smtp-Source: AK7set+d179uoOw6uXh9ql2TkKuHzWA9SpSY+FPNge8BtiO5P9a4Iv5waad6ypHFBZtxfoR5KVdFyQ==
X-Received: by 2002:a17:902:ea05:b0:19a:ae30:3a42 with SMTP id s5-20020a170902ea0500b0019aae303a42mr4447350plg.21.1678984204151;
        Thu, 16 Mar 2023 09:30:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x3-20020a170902ec8300b0019ea9e5815bsm5883510plg.45.2023.03.16.09.30.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 09:30:03 -0700 (PDT)
Message-ID: <6413440b.170a0220.16649.d24b@mx.google.com>
Date:   Thu, 16 Mar 2023 09:30:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.18-144-g88546018fee83
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 174 runs,
 1 regressions (v6.1.18-144-g88546018fee83)
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

stable-rc/queue/6.1 baseline: 174 runs, 1 regressions (v6.1.18-144-g8854601=
8fee83)

Regressions Summary
-------------------

platform        | arch | lab           | compiler | defconfig       | regre=
ssions
----------------+------+---------------+----------+-----------------+------=
------
qemu_mips-malta | mips | lab-collabora | gcc-10   | malta_defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.18-144-g88546018fee83/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.18-144-g88546018fee83
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      88546018fee832896034565aa32e75b75d02b658 =



Test Regressions
---------------- =



platform        | arch | lab           | compiler | defconfig       | regre=
ssions
----------------+------+---------------+----------+-----------------+------=
------
qemu_mips-malta | mips | lab-collabora | gcc-10   | malta_defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/64130ef3285b2a99958c863e

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.18-14=
4-g88546018fee83/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mi=
ps-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.18-14=
4-g88546018fee83/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mi=
ps-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/mipsel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/64130ef3285b2a9=
9958c8642
        new failure (last pass: v6.1.18-146-ge0f25c5308c10)
        1 lines

    2023-03-16T12:43:14.711836  kern  :alert : CPU 0 Unable to handle kerne=
l paging request at virtual address c19c4d68, epc =3D=3D 8023f540, ra =3D=
=3D 8023f524
    2023-03-16T12:43:14.712036  =


    2023-03-16T12:43:14.732272  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
    2023-03-16T12:43:14.732455  =

   =

 =20
