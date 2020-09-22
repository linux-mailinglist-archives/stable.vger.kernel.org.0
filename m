Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1BED273816
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 03:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728854AbgIVB2D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 21:28:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726913AbgIVB2D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Sep 2020 21:28:03 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112A7C061755
        for <stable@vger.kernel.org>; Mon, 21 Sep 2020 18:28:03 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id z19so10927206pfn.8
        for <stable@vger.kernel.org>; Mon, 21 Sep 2020 18:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kdvFXkXiNlrsJS3uTxalYAQwAJzdCk3Y01aKiYt10OQ=;
        b=BKhW8dfRI/ykZVBXaDkPKwxY3mriyJnXxkbjbbHhJWnM7Onyq1fLdo8QrNe0qfBX1F
         gTKPv2The2eLniwaHt8iKCqPMTkB5f6qGbOg4i7eHzoUBomLSUlhLvbEtnUdUKBdG1jY
         rWRc9BMQkaN834SqcV5Aze8+jyvtpWmgSjFHT6rMHXXJ7foq5xmG8R8JuyZF3Px8LR5+
         xS34IMo9VanLvTRdh5v9EqOuBsKKRC274WCSSidlkyG3M82ZxEHoBcXXF0sQ1jJeZbQA
         lpTDYAt6WHkyjzpSOoxpq9rOaN7ytenFYWhQM79dhDB9jsm96hOj5HLSF2dcxTkEXxBt
         Y48g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kdvFXkXiNlrsJS3uTxalYAQwAJzdCk3Y01aKiYt10OQ=;
        b=AxzhL7EUfodru9IRuJ/xulVtf7TWwwDP/wjyZL5KevFtdFG/Mh/pdDrEx8pEw1pxRy
         HTLMrEuiWrIqqaXMIGkiLQfatwaX+ZXf5/wEjyp+4P0HV7snhxATrynwCw44yY6cuyVc
         nsBkNoJkVZ+oET7dYyGsbrdjidk3wSJTu2a/l/ajlRUkikfw2+6sofSaS/CWxluxeJMF
         NhdJZNxa98HsnV1NobrCK1R5SBkAVGuFHRLXtb/ysPAHDrvy1YkVR4dHouJW9EboQHJ6
         Yu6nMsCFOgu6gSi0NnkPmJyjdjkXyK+r5wH/Db9ocuFKMIy5SAY27bvR0UUGgWulR+oz
         DeaA==
X-Gm-Message-State: AOAM53245VPdHQ35julJUZ0f9uUEEhT2flM/thuxx4d72uhyUTzzw6ju
        ze5nwrXJ4grmgNo/v/4ZQKGbEvI4ut4zQw==
X-Google-Smtp-Source: ABdhPJzRHt1vvHNV/g8NPN4IRPOnCQg7ocGtHu5tC4qMeys2HC4g+uj/b97ComaGcm7te6CMrMS6Pw==
X-Received: by 2002:a17:902:ba8c:b029:d1:e5e7:be6a with SMTP id k12-20020a170902ba8cb02900d1e5e7be6amr2377826pls.68.1600738082167;
        Mon, 21 Sep 2020 18:28:02 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c201sm13834710pfb.216.2020.09.21.18.28.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 18:28:01 -0700 (PDT)
Message-ID: <5f695321.1c69fb81.de0ca.1ed1@mx.google.com>
Date:   Mon, 21 Sep 2020 18:28:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.236-70-g65bc4d6ae4c3
Subject: stable-rc/queue/4.9 baseline: 132 runs,
 1 regressions (v4.9.236-70-g65bc4d6ae4c3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 132 runs, 1 regressions (v4.9.236-70-g65bc4d6=
ae4c3)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
results
------------------+------+---------------+----------+--------------------+-=
-------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.236-70-g65bc4d6ae4c3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.236-70-g65bc4d6ae4c3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      65bc4d6ae4c327aed9fe97a58789ae96d40455c9 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
results
------------------+------+---------------+----------+--------------------+-=
-------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5f6924f46f40949691bf9eb2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.236-7=
0-g65bc4d6ae4c3/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.236-7=
0-g65bc4d6ae4c3/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f6924f46f40949691bf9=
eb3
      new failure (last pass: v4.9.236-67-g8933534b4fa3)  =20
