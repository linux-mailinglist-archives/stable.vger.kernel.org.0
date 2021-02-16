Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9924431C489
	for <lists+stable@lfdr.de>; Tue, 16 Feb 2021 01:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbhBPAQQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 19:16:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbhBPAQQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Feb 2021 19:16:16 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1249C0613D6
        for <stable@vger.kernel.org>; Mon, 15 Feb 2021 16:15:35 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id r2so4555847plr.10
        for <stable@vger.kernel.org>; Mon, 15 Feb 2021 16:15:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bCIG77zaR0S0JONgFOEDlXVejuDZPFZvkb4NIgPW8Yc=;
        b=vdn+0P6otZhy8fmU0WHWFvnCvbL/PxIp5e8JDIeknpeErbITHIPyzX7IuosWlZECCT
         Qr7hwo3zPe98bVzLiXQVtK0c64vmxhJcXjMP+ieXJTF7K+mc9P1+PyXb9o6GcAIfDquK
         EvQIYi6Oa38JEgX4xQPTDQaPOocM36xPFbBzPAPKnw5iUN9IwZSuawyR5Ql0V51Z0YrC
         eoFF8qtk8vv0Oq7rTLJioTfAiZGHKkjajxJMYphm11B/WHUNFGzxe0bf/+djWnjRb023
         UNKM4iMqIIGg6+R47U4ki85+OiKzo9COpV7I2NWt2SO77hidse6v9NvrqIJqPdak41bN
         Z11w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bCIG77zaR0S0JONgFOEDlXVejuDZPFZvkb4NIgPW8Yc=;
        b=tOnyMZvCR+InNH6c5h2vQbE+K/d354jgTLKtFSUuXtX8ZRBNMdmRL7G5B8puAIpXv+
         avOZr1rlDPoFRwCR5Zzkn01WLPL0qfdqwEN2TOarThIHddZrQo2aUIv/IYuSx62tM0Ok
         2kfVtfezsEKQ7L8kd/PMLhRfuTplBpDnRNBaWVARelGMaBHLXD6BFDfOKt52dh8nqago
         bBHAoBWsx1wvIXR472FpC7M48pN0aEzm/HF3sNjYH6kP1+nuF3fbhaMC2/3YB9T0NKMC
         fT32weeVWX8nplPVlCDis2LFbitFT0GE3z5hfqDMcg2fH3OiiHsCTEFEORBlxS3KeKtH
         DogQ==
X-Gm-Message-State: AOAM533bhXc3ESTimBdr4AO9UfpXttjia4JifBF8ynGYCqKPEoPG/MMz
        jE+eGHOBuML9sL+/aE9BazYM8VoBVOu5tQ==
X-Google-Smtp-Source: ABdhPJwQaBZSNxDKY6ClZ6B3pdVmjEzDQQbqCKhWMVFOwkv+hqJNn7VoNcsf3933YMsv2Z0bDYynXQ==
X-Received: by 2002:a17:902:bd0a:b029:e0:612:ad38 with SMTP id p10-20020a170902bd0ab02900e00612ad38mr18045751pls.30.1613434535230;
        Mon, 15 Feb 2021 16:15:35 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x28sm19779670pfq.168.2021.02.15.16.15.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 16:15:34 -0800 (PST)
Message-ID: <602b0ea6.1c69fb81.401c8.9600@mx.google.com>
Date:   Mon, 15 Feb 2021 16:15:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.257-21-g34d79ceec663
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 27 runs,
 1 regressions (v4.4.257-21-g34d79ceec663)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 27 runs, 1 regressions (v4.4.257-21-g34d79c=
eec663)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.257-21-g34d79ceec663/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.257-21-g34d79ceec663
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      34d79ceec663b171ebb66575627742563f78e912 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/602adcf8f910e5684caddcb1

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.257=
-21-g34d79ceec663/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.257=
-21-g34d79ceec663/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/602adcf8f910e56=
84caddcb6
        new failure (last pass: v4.4.257-14-g10235a8a7b92)
        2 lines

    2021-02-15 20:43:32.870000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff26c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
