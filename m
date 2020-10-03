Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 499402826A4
	for <lists+stable@lfdr.de>; Sat,  3 Oct 2020 22:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbgJCUtF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Oct 2020 16:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbgJCUtF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Oct 2020 16:49:05 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA88C0613D0
        for <stable@vger.kernel.org>; Sat,  3 Oct 2020 13:49:03 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id e10so3329620pfj.1
        for <stable@vger.kernel.org>; Sat, 03 Oct 2020 13:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TJc+xjBpXtXYvEKlJrZOGSN1EjbhaR0WMXqBYNEMla8=;
        b=r2/yumGHEZjmXX2b6x0qSKirCywQOJAL5Bnwp3wIq34gH8YPvcf/w+HWyuHcqADMsK
         7uKOPpT52pKf1hYznagjth6SiJl7wwHg1lWxnJ9UutVob6NtkVTSwHeeB7z1eZ8dM2Lh
         FCShvrPMgrq4jLjFQnz9P+DPEhTmDdkLZkH6sVpGX2gdxRO8FXhKHmOA12pA9LlBOPkj
         1scuosd/ea3o4Rl31Bgd0hPoPfSLRvUQmajfsG8csrpLSuGpbjuMdPKmwqAWNsrek20V
         HTTonYp5G/isZbkSkpNd8UgBcYzkR90ILjSlvDMmtmAK6IicgMuouTfZWMYvZktXIw0s
         ZCjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TJc+xjBpXtXYvEKlJrZOGSN1EjbhaR0WMXqBYNEMla8=;
        b=WxHZtRfsB93G7+m6zsnl01LzXIij032Hg/1oLgA25QEYTx/+exes0QFl8rE1BNUzdA
         8jfmsOWYkzCttoXh3KbOxREzzSFpe++xqw5IZ4DBtr0pWskVbKxSn0JZ6smzhP66qYsV
         XNPddAJn02rRJY6vrTValeQN6QYGX9+90jN+X0Xu+Etv2DAdP7UZRNw/osSmqLXAcJBJ
         MLwJ21mz8qVDbJPUNeortasYEFsc7Ak5dDiRZVwdXiBk2wIT/FUnI/o8yUvoSdOYqAuJ
         W26MFPp17ppjyEkX047/1lUXwfJWCxq4Onpxx61a7Zj32PLJQY7H41tWtBF1/3Wz+tsZ
         zHVA==
X-Gm-Message-State: AOAM531TllVXit0EDRgE1VQOhPPc5+w4UUGgUg0ZdQWdJ+y8sWlu7M0t
        sCZkKdBNtx84YFIWVkXGs4yckXFvyi63cQ==
X-Google-Smtp-Source: ABdhPJzsBTDT9lMJjk6Tw8rJX6xKatREMlDhtJphkwTB5eANPMlh3ng8KHRIAVu1P+ron6Mmr6aSBw==
X-Received: by 2002:a62:7894:0:b029:152:279f:5dad with SMTP id t142-20020a6278940000b0290152279f5dadmr8985740pfc.67.1601758142572;
        Sat, 03 Oct 2020 13:49:02 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k5sm6748454pfp.214.2020.10.03.13.49.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2020 13:49:01 -0700 (PDT)
Message-ID: <5f78e3bd.1c69fb81.50d46.cbcb@mx.google.com>
Date:   Sat, 03 Oct 2020 13:49:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.238-2-ga41cdac0290c
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 109 runs,
 1 regressions (v4.9.238-2-ga41cdac0290c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 109 runs, 1 regressions (v4.9.238-2-ga41cdac0=
290c)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.238-2-ga41cdac0290c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.238-2-ga41cdac0290c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a41cdac0290cf8a0c542e10d0aa8b42f9c379ade =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:     https://kernelci.org/test/plan/id/5f78ac736e06b494a44ff3fa

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.238-2=
-ga41cdac0290c/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.238-2=
-ga41cdac0290c/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f78ac736e06b49=
4a44ff401
      new failure (last pass: v4.9.238-4-ge285c292897c)
      2 lines  =20
