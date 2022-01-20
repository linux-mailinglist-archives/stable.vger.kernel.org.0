Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC94649517B
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 16:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232746AbiATPa2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jan 2022 10:30:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376763AbiATP3w (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jan 2022 10:29:52 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE6B5C06173F
        for <stable@vger.kernel.org>; Thu, 20 Jan 2022 07:29:52 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id g11-20020a17090a7d0b00b001b2c12c7273so4556826pjl.0
        for <stable@vger.kernel.org>; Thu, 20 Jan 2022 07:29:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Vwa3NMPA771XAz5l1Gz468q/XU601vYKsCXyH7Ia0t4=;
        b=WdgZxPpPTjWOTIdbWFIMzG8FEti+okKHtBT341VtpSJVYEKj4J7QZLeTreJ1DnatOX
         aQJ706eSXq85S6sF1HVTRy/nbhmKyaQySbbD8bZhEMU7gLmOxalLZ6VGn2vfKyb38pxY
         rpzWa+lGd4xSnZgYXRlSiXeKSbPLOAGfDd5KEXqNfPpuujoImAq/TOP2wiv5bCP8gw24
         gwA0uPGxGLnO/u+yIxSZi488gf6OX/0B0h4MqGPUHhLjvyJz7aMtRntyL4ZrET+npjxC
         8WkAZVF+vKzA9Y1piP4d2rcoXF2vexfT8fe2jlh3OSkJcoQztu3a9ejLNaQSqY2pT9Hp
         aoag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Vwa3NMPA771XAz5l1Gz468q/XU601vYKsCXyH7Ia0t4=;
        b=Y/2txc1poIWumW0L8qsxdgPskOsBWustkpH45iGzyWi/XVKWMe+oBQSSg/fSuBdsD4
         W6JbCL6WiOblNHxWQAI9pZcljMqEze7aqmBGtvQ63ubfpI3Jpe9dN3ihLsjYhiZBCBqo
         A15bbi2aQiE27BYm8+a6EWMw2zcb166PuAfcij/V3hLM48qdSz2xItKiFIWTSMZxa+WS
         NREk5LcHvvUiZSBO9bewEgtjzbS+rOdbnRNOHXNRYDGM3p1ZzD6vqeABQztpZ6Bc/9Dr
         k21PBnCxRdK5SYNd0BjbY5OS6/sYyNsfWGP73rgK82CqtxnGq1mVNOm4rJ0IfItzTAaf
         78Jg==
X-Gm-Message-State: AOAM530icr0khhPyv5hdQ0USJyMWIQ7dC08kqC456o5T/NDZpMcT2NV+
        322OMxiwqzlaWnFLELvnf3lOmGA9YpCuLOv8
X-Google-Smtp-Source: ABdhPJwlRJQabmfZ03bUMT+XghgV96ihL05SsHMDbO8LHT12J+Va7qofYUO6wMjVzhHWf75e8SnxiQ==
X-Received: by 2002:a17:90a:6e0f:: with SMTP id b15mr2101118pjk.102.1642692592243;
        Thu, 20 Jan 2022 07:29:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s6sm3023648pjg.22.2022.01.20.07.29.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 07:29:51 -0800 (PST)
Message-ID: <61e97fef.1c69fb81.5a533.7f6a@mx.google.com>
Date:   Thu, 20 Jan 2022 07:29:51 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.16
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.15.y
Subject: stable/linux-5.15.y baseline: 159 runs, 1 regressions (v5.15.16)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.15.y baseline: 159 runs, 1 regressions (v5.15.16)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.16/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.16
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      63dcc388662c3562de94d69bfa771ae4cd29b79f =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/61e94e86acf88b27baabbd35

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.16/a=
rm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.16/a=
rm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e94e86acf88b27baabb=
d36
        new failure (last pass: v5.15.15) =

 =20
