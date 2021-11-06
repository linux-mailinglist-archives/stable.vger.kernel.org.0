Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3ED9446F5E
	for <lists+stable@lfdr.de>; Sat,  6 Nov 2021 18:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232571AbhKFRi1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Nov 2021 13:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbhKFRi1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Nov 2021 13:38:27 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3697C061570
        for <stable@vger.kernel.org>; Sat,  6 Nov 2021 10:35:45 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id gx15-20020a17090b124f00b001a695f3734aso5636416pjb.0
        for <stable@vger.kernel.org>; Sat, 06 Nov 2021 10:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vwml/0KSjGua90NQGvnCksLNKZ6TuoN7uJ2F1jR7d3I=;
        b=n/3oV5lzB2f8Z97ec9TYcNpRlWATrijW3oWJ4JIJ7dezoKD1qrgH6R75yyK7lknsI7
         eY3m1x4btCA/m7WxuDU8BYbItNaebk2npjO90NsZGtbHMFsVrFyRu/rjpxG+rA+9ykoX
         mgdAJ6R2zPlE1GboBuqHiJEWDAXfo2lfhBZS5KyvPMwmtJtsurl2y+8t86e3HVOobFQU
         zehZ9kIZYh69bEqf7ub8ZtW/WkooDK8ZdPQd8ETiPjhCmuDuC6tjurBAjC+3hITEJh0A
         1dEfQaoA4Ap1aZRmNMmk+UwEUtm2h/8230A7EfJymJefWhtmtmOH3GRfKaMCkA4RGU8H
         jcZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vwml/0KSjGua90NQGvnCksLNKZ6TuoN7uJ2F1jR7d3I=;
        b=oLquya2zIREWx7vUnUROU+U79q5Hq56E0TFW+DE9ApTFhNCRpFqvtCNuXBphA7JVFB
         dCN4hZeKeD6WWDr4TOgu4XmNCvQ9Aq1Riido4b9kJhr0Qm1Q2YNGvD7Gl9x+0w3CYZtX
         TUdDbz1tIRmaafll2zIpqQAGvFnHtkQQxsGr51VKidx7wj3bWCmZZZIO5BMLqN9rGW/v
         yc9By/0hdeLD4hxMPNlGiBZln4ceGQWDHe7rPVDBXFV/zgyMXRdHPWv7tyJJjvnK9E1i
         lHPvr9v0vTYMpIC2XUw/PGKMWVBSN+9p4wNIhJppgcsxmBECUaosQcpnvJfBXtGwnaql
         xlpw==
X-Gm-Message-State: AOAM532H235yIdRvmAjAf8fi3wQMG2TXoNW9TxyKg1tcXzNaN9yTTE31
        NIUp9h50pviZ4B7sS5Ie1zkt1C181cBoX/7h
X-Google-Smtp-Source: ABdhPJxTJaJJLy5oWDcpgHZ4nGhO/NAmyf8vPrTY8HD+xzrZiRdaTyiFBs5ze7fgyBg8jsJyyq0ZGg==
X-Received: by 2002:a17:902:ce8f:b0:141:f85a:e0de with SMTP id f15-20020a170902ce8f00b00141f85ae0demr36829063plg.69.1636220145184;
        Sat, 06 Nov 2021 10:35:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c25sm10438965pfn.159.2021.11.06.10.35.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Nov 2021 10:35:44 -0700 (PDT)
Message-ID: <6186bcf0.1c69fb81.e7be0.23b4@mx.google.com>
Date:   Sat, 06 Nov 2021 10:35:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.291-3-g4b7696b55f5d
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 91 runs,
 1 regressions (v4.4.291-3-g4b7696b55f5d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 91 runs, 1 regressions (v4.4.291-3-g4b7696b55=
f5d)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.291-3-g4b7696b55f5d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.291-3-g4b7696b55f5d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4b7696b55f5dbc9e0acdabcadd6f45c5f2e36e72 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61868b4d5ee93324d53358f7

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.291-3=
-g4b7696b55f5d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.291-3=
-g4b7696b55f5d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61868b4d5ee9332=
4d53358fa
        new failure (last pass: v4.4.291-3-ge1223ca4fb61)
        2 lines

    2021-11-06T14:03:37.553367  [   19.376800] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-06T14:03:37.595977  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/119
    2021-11-06T14:03:37.605035  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
