Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C739C46013C
	for <lists+stable@lfdr.de>; Sat, 27 Nov 2021 20:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234158AbhK0Tpt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Nov 2021 14:45:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234861AbhK0Tnt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 27 Nov 2021 14:43:49 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F4A0C061748
        for <stable@vger.kernel.org>; Sat, 27 Nov 2021 11:40:34 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id x7so9460164pjn.0
        for <stable@vger.kernel.org>; Sat, 27 Nov 2021 11:40:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=aru9ekemC+GFVIvh5/gtVA8HUECVHqHki6ge1E8e5CY=;
        b=GwQt8bhBP/zLLAXcKdIwQ2I1qesHY2VgQVRuiONRe8CMJihvlNcb2c8EBkxrBzAKOo
         LZQw2/dk1jgLPnG3tUjKwCzOosnyryqkxErRDkPkji3vpFUIZKaI/9URFM9cMPdDWZhC
         /fD8F7d3c4htzhEzu3yRsjBLsBHPd2tNspxmEm7wdzDfVHTmSaOp9+m2oVw81nTQW5ff
         EcMzFZNRNYl0KIvdJ6aXbP7lGAXVnbfm2Frnv9EDg5ADal+0GaWG6ioe27rsob8g2Rbh
         v8jau0bgedkxgtuDP7y0aSbMxzpl7j7sZ8AnU82lqYNrFlpFJsHKdka+aiRqPOgyUkdV
         kSlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=aru9ekemC+GFVIvh5/gtVA8HUECVHqHki6ge1E8e5CY=;
        b=jA22kd1LsF1ajt1MxY2l0SBWDZyvfCVoeqiKgdLFr13vE7HiJLPNYSC52MNYtmqKqn
         86ox7QZbPs5WqIE3q3z75uC0EUqrmfW6uMndHyF4sU30OPs4D+3B10DlO/QBXZq13KPA
         9Q3UsUxY0fw4XQlX4a24P//WU1DpsbrmmBLQ4zVFs3a2KabtEQk9wNwQHWGbVLfgM+tu
         VZ5aahlKYpqVJyRnLg0Ug36OUfGG9bUJmsO8uUYj8n8CCNUSLzXaIQFagX1oFzR4dZ1r
         XpP6QnYLNK/vB4vGjjoQtK9XFUxOBPSduorSRNw7b0GPgnSD316ulluYuT+45iJcaG7a
         Ct6w==
X-Gm-Message-State: AOAM5309UoNTj++X1rLWEDg4MGDafEQL9RSkiTrpOnxYA2gFEelZXfpp
        UyCE0YYcMsoFX9JzD/hMFn24dkXnVTOwnMst
X-Google-Smtp-Source: ABdhPJwJBjLbuoeOsoW/nAUAJKtGxPrp8MEUcvnp7DY9DbS7zGw1UX/qHXz8m4dOp4CSJl6RIuIbWg==
X-Received: by 2002:a17:902:f54e:b0:143:cc29:c058 with SMTP id h14-20020a170902f54e00b00143cc29c058mr47096529plf.57.1638042033745;
        Sat, 27 Nov 2021 11:40:33 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f15sm12961386pfe.171.2021.11.27.11.40.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Nov 2021 11:40:33 -0800 (PST)
Message-ID: <61a289b1.1c69fb81.9b21f.2c3c@mx.google.com>
Date:   Sat, 27 Nov 2021 11:40:33 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.256-10-g331524e11e259
Subject: stable-rc/queue/4.14 baseline: 105 runs,
 1 regressions (v4.14.256-10-g331524e11e259)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 105 runs, 1 regressions (v4.14.256-10-g33152=
4e11e259)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.256-10-g331524e11e259/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.256-10-g331524e11e259
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      331524e11e2598247a02bb32d432451e030935b3 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61a24f966d2f47ca7c18f6c7

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.256=
-10-g331524e11e259/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.256=
-10-g331524e11e259/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a24f966d2f47c=
a7c18f6cd
        failing since 2 days (last pass: v4.14.255-248-g646bcac5a19c, first=
 fail: v4.14.255-250-g0b1b1688e7ac)
        2 lines

    2021-11-27T15:32:23.282928  [   19.903717] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-27T15:32:23.330037  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/93
    2021-11-27T15:32:23.339472  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
