Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A52A64C0644
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 01:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235220AbiBWAjS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 19:39:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbiBWAjR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 19:39:17 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22E895F8DE
        for <stable@vger.kernel.org>; Tue, 22 Feb 2022 16:38:51 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id ck4-20020a17090afe0400b001bc64ee7d3cso1178712pjb.4
        for <stable@vger.kernel.org>; Tue, 22 Feb 2022 16:38:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XkgAWLGhoK7H3L9n++DMb4TkzeHfXDbG9lnjxJfwGiM=;
        b=dWL5OW1QDQYjErJ5ZhjuDGgkfrWJ/Pyaska6PTKRfYpgJMKTs0K0eZiV5nIJxlFQXV
         Scrgfrgm+n0NzYebVg1wPSdhwfWIrlmBabaLyqvMAkTOdPqsdXEzK2Avf5toLeSTOMa8
         7Rb41Vf0qI1zNoTFP6avuUGOQFVKqACTI4zUTeMiI38rYUPSbsdbxC8zkGfg7T9a9Xj2
         Omtie3qW8aHdcdZJ0tuS6mfuLFhRMxA7nZwQTkVFieEBiGXOwj2YxnEfen2mPr0PrJS/
         bxMKHinWkNV2mIR09bOXitBkIxY7gV3nNkTfJ26VA6gJ7Jg5QziLqpJqFiksEAAo7uNP
         1DPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XkgAWLGhoK7H3L9n++DMb4TkzeHfXDbG9lnjxJfwGiM=;
        b=LQtICLr5/LoFWe/TPJYV8Jclqt9JDa4wW4y9Bdzd82g3/AjiGezT/nVQ2a8O8NdOeh
         sOqcmkfnu0quVxYV5Sl/dnPfgXjxsPGmsKbAo2vPT2EPWLuKM+KCoNTdw0vIS1mb5QVY
         AtnZ7rBmRqWpNbfWo/dXwx4jYNt4FFgZRxIwaBAEHeaytn0EbS6o4v5qRpQ0rxwfZ6fw
         OXN7bk0/VKZBVw4GMFIAvTCkvDxCROtqSQH3DFKOkL+5wPqSQIfM0MkQWwlKx2Ie5xw9
         nN73bDUyv8mwDbd2LWd7mbO6feeUtZ7Moj3Z+odp7lbDbVlVWDIpKHfTBdEvcvTjM2Hp
         i/Lg==
X-Gm-Message-State: AOAM5301V4uwtztm0muTK7MLPPQLMKhIAgrEobvLtOBs+xIx9Q0oVr2L
        jT9UbPjr3daCguDsutGevzEm4MyRYw/nIvum
X-Google-Smtp-Source: ABdhPJwpnSKi/chCt9QLrjSwWA0OolNl05iTIJDAYgBHlEQr6jtbJ2a61qLF7d/omATFDEKnLHEz2A==
X-Received: by 2002:a17:90b:1bcf:b0:1b9:b03f:c34c with SMTP id oa15-20020a17090b1bcf00b001b9b03fc34cmr6696676pjb.141.1645576730520;
        Tue, 22 Feb 2022 16:38:50 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d13sm18047245pfj.205.2022.02.22.16.38.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 16:38:50 -0800 (PST)
Message-ID: <6215821a.1c69fb81.97dba.0e54@mx.google.com>
Date:   Tue, 22 Feb 2022 16:38:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.230-58-gd75e7a272848
Subject: stable-rc/queue/4.19 baseline: 86 runs,
 1 regressions (v4.19.230-58-gd75e7a272848)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 86 runs, 1 regressions (v4.19.230-58-gd75e7a=
272848)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.230-58-gd75e7a272848/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.230-58-gd75e7a272848
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d75e7a2728488f4216a4ed37565942cdb780f4ea =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/62154923e848aabd1fc62977

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-58-gd75e7a272848/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-58-gd75e7a272848/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/62154923e848aab=
d1fc6297a
        failing since 1 day (last pass: v4.19.230-54-g25a309390ae3, first f=
ail: v4.19.230-58-gbd840138c177)
        2 lines

    2022-02-22T20:35:35.682119  <8>[   21.580017] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-02-22T20:35:35.726850  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/99
    2022-02-22T20:35:35.736850  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
