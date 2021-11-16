Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3589B453954
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 19:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239391AbhKPSWn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 13:22:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236659AbhKPSWm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 13:22:42 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E879EC061570
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 10:19:44 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id q17so18124272plr.11
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 10:19:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GJIA3UaKs1qzDDjieafHEl+eNM5qogSrpMHsP/KnheA=;
        b=O5mdsnWCrHQrkHvR8YvUXDfZjmYbgEnTVxocifTAIqnMswgex8eU5JK5+oQJ+RRZUt
         h7y1eXTgY0M/zEXA71xy7UeY6jsNkkjJKTnDZ5pRrJijqbRPZIAmv6kCeH3coudddNgC
         S6GS1VUAr7IoliR4EZnTXan/vCpIzPbkrkHjnpvTtllAZZVkoWVdWErW1KXOb7zRdNDB
         5CfcwZiRaIzIKEF4+rxw/hfhTGBezQRCUt7Ph9C2isOOKh2WMxoyeCy3ia3mYV3BK+M6
         9T75+3ROVyJMxr9YiN0gENBK+cZU3S946tiSpz9FFtPDcUMNS54bGT3gokvN6gxI2NaA
         gRAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GJIA3UaKs1qzDDjieafHEl+eNM5qogSrpMHsP/KnheA=;
        b=ufehr9bvRx7guSTy6b5ehTY+QhMdTLE1Wb89ovO/8g9bbtlujkRjY9gNWPf3MfePEi
         2Kvs3GmQFau+FWtT8QM16b8nZCTmjWsyfpERIMX8SfB8HyfafVhq5dpY7gXIohaB4XGV
         S86LMKTlHkzrKMk1C82uFIIXJZj/V5LSoI6LoGPQZHBugwKvDnJ2HsAxWmwWNUHlDz2J
         IZick0wWfatXYcNU85cgQmmUzbQrXnWzp2Y3HCw7UIJmEjTfMd9+61zLmtYa+nZt2v/R
         kErsQ2YpxuTzMNkNzlL4ZAsMBvLhMkPQvWlQIB2F+l4+K93MDan2tv4Zr9YaJ1EsBSZI
         oQJA==
X-Gm-Message-State: AOAM533OF55KZTvpMOMS8baP66Em3Okhl2bgjs4dG3kbWKpo70mtqll1
        VHMqYRHUl3MCOihmq0uUdLAWSkbRl++V1rPD
X-Google-Smtp-Source: ABdhPJw8qupqo6wA/1qiqygCkxwIeXvbU0EqKFlAFTyNxnzv8POJ2Uc8o9BYGookXRF8Af5ibU0PXg==
X-Received: by 2002:a17:902:7890:b0:143:c4f7:59e6 with SMTP id q16-20020a170902789000b00143c4f759e6mr23290225pll.87.1637086784196;
        Tue, 16 Nov 2021 10:19:44 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o1sm2937358pjs.30.2021.11.16.10.19.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 10:19:43 -0800 (PST)
Message-ID: <6193f63f.1c69fb81.1fecc.8db7@mx.google.com>
Date:   Tue, 16 Nov 2021 10:19:43 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.217-251-g8499e02617e4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 112 runs,
 1 regressions (v4.19.217-251-g8499e02617e4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 112 runs, 1 regressions (v4.19.217-251-g8499=
e02617e4)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.217-251-g8499e02617e4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.217-251-g8499e02617e4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8499e02617e49e065be3df07a1c126cc93ad47c3 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6193bbcf803ef01a113358e5

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.217=
-251-g8499e02617e4/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.217=
-251-g8499e02617e4/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6193bbcf803ef01=
a113358e8
        failing since 1 day (last pass: v4.19.217-72-gf6a03fda7e567, first =
fail: v4.19.217-85-g1a2f6a289a70)
        2 lines

    2021-11-16T14:10:10.625681  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/105
    2021-11-16T14:10:10.635145  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
