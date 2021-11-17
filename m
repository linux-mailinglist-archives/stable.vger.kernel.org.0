Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1872D454A1D
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 16:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbhKQPli (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 10:41:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbhKQPli (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 10:41:38 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8C8DC061570
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 07:38:39 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id s138so2595660pgs.4
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 07:38:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Jxo3d94yJjFrbeTjVkzxv2MfHfiyNUstAKer9ppIEtg=;
        b=B2p9lTF98Lis4RJM4mV82J8jH1RL1RLXGzqmCfokBeKd6gt7263g39IKHI4MOClNKn
         06jFrMVpOdQhDgBmAqx8dOPnacapo30OBO1Ooo088qem9KhGdI/wm0KaPKuKhi+rVnGu
         Yu33CWOkE+rN1vI5IhXSZ3Bjy7KhcyRA5L7iZKzXXyUCL8y90VGrv1hPUGYtF+hSYSiI
         bx0Jio0Y24BhqC/y4gAhxuhhJXBfooExPH3B2E55PByJ8K8KHdzns+ZdCEhWrvkxtoh1
         Ld+7X/WDdRfRLmGKRjYV6+GKiX4ON2thRNlx2WylYALb52Cxso4Sr+LHER0C6ysBiWg6
         GOuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Jxo3d94yJjFrbeTjVkzxv2MfHfiyNUstAKer9ppIEtg=;
        b=hD/zV0u9/q79vv8abgcZD0YyY2rnRAhihyXqZgx/WdsW+eyTOPar2nS3yAcC/uTVHq
         l5+M0l4bVjq/TsfGq3OrRCOKgk+EJ3nzDCs6EJs3vJ36nNC47Hr7UWQgjM9mIWN0Ldhd
         J0DIApUF69YdEpZEC1bI8uYlgEAUWioMIRaAhioMmo1FyFLqJe+D6k00Vhz45Zid9/jN
         BO0m8v+QRwl/NUYnkHwHZr9vyTYUhUJsmvRY0ia6Au+BpUZFCLeXoAiZKfmBPVPvzKoe
         VIeA+LJ/oMxQITJCbLXMHd4K/prRwmhZ5oiIAwJa8cRiq1eQ4cS87bFGHGHM8l3Z5EN+
         1hAw==
X-Gm-Message-State: AOAM531ZhxjADqnBSk/xsccWj65p+iqvL8EhtFcZu+SeodgVEF5ILYeQ
        ypwf9JZk11V0rwG6Yxrt1wXLkJjvnufz7q5c
X-Google-Smtp-Source: ABdhPJxVCxcawd3HP4VvDoMxF2reYUidkFHklaKeUX2GfZafx/zEbcP+/Tnff+jiRGyGZWAeQ6OwKA==
X-Received: by 2002:a63:83c7:: with SMTP id h190mr5936719pge.126.1637163519085;
        Wed, 17 Nov 2021 07:38:39 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f130sm69706pfa.81.2021.11.17.07.38.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 07:38:38 -0800 (PST)
Message-ID: <619521fe.1c69fb81.986b6.04a5@mx.google.com>
Date:   Wed, 17 Nov 2021 07:38:38 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.292-113-gecc196609cf4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 87 runs,
 1 regressions (v4.4.292-113-gecc196609cf4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 87 runs, 1 regressions (v4.4.292-113-gecc1966=
09cf4)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.292-113-gecc196609cf4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.292-113-gecc196609cf4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ecc196609cf49276a73940497dde469840e57e1e =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6194e7bbf71632f445335904

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
13-gecc196609cf4/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
13-gecc196609cf4/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6194e7bbf71632f=
445335907
        failing since 0 day (last pass: v4.4.292-113-ge9a92f80c735, first f=
ail: v4.4.292-113-g643cfcb15c40)
        2 lines

    2021-11-17T11:29:48.240265  [   19.149475] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-17T11:29:48.291698  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/114
    2021-11-17T11:29:48.300800  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
