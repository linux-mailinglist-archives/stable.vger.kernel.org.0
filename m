Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D71FB452A1D
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 06:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239077AbhKPF7e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 00:59:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238681AbhKPF7Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 00:59:25 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72084C048CB1
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 21:27:41 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id gb13-20020a17090b060d00b001a674e2c4a8so1812146pjb.4
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 21:27:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7rHIYbC7LSlup31oUHbqBk+JpvfSj8WEfN8nK9mLNVU=;
        b=UcyV/6y5uT81v1VegS4lNtZh8GtX/f1EVrPG7RPeHPCI8uofHdlH1y/zdfvXT1BL+C
         jxZFXWKETS7AA2xwGOYilwP8+xcTclJ819nWd+9UTha5wGu7whCV1N5aNNLmF7DPQgaF
         PaR9V3p0H806ujHjtHzaUdvUc3gwCd9NZ8QkcV2yOQ6wB8OuP+wMwT9v4ukjDeJXRKEM
         7bHTl4M5E1G78AzyllmYPAK4MdA/rBSa23s+xiU5EbUL7Re50pbZ/i77mvOAnJxJY+jO
         rafAB9BvFHmnZjmeMCAf9AiEhv6Yroiq/4UjPvb6nLZ4VxyQtUb4FAHGJ8xo9P67YdQd
         ob1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7rHIYbC7LSlup31oUHbqBk+JpvfSj8WEfN8nK9mLNVU=;
        b=XEGrcqCnR5406Y24wIzwVC3c/P2jnQYwilHe91gxJFePtfx8PikL7yItvA9PkNNutA
         8zffV/bj0Sr1d9ZBosFLhoHVdp7ALeADLChKw8O3baVtHYNAkjEg0taM+jB8n1/egzsj
         fcTHz9oIW4AdGbe+k8yAwTHppOKKS8RuS4WNnkvaeiuqNwuqMQELOlYCm1t5Mf6W/xRg
         WbbA/MshCkkQKaxepmfGHf3Z86CYHYO2jVjGQjRE2w5V9XI59vRQgfczRVxnyoCIz9Nn
         Qq2DBw1CaeRfZ/tz55EvRdTWQLSkSv6n5fjmIvY/Lq1vYh3kozkqy43uB0lPdsZNTaIA
         TGcg==
X-Gm-Message-State: AOAM533Yi7pCWNnWdQfegW0NyHIMAB3Oxn1iBBwjMPLXQ3FR02efTJRg
        ME3WnbBID5xw+ZOsx0bmBFTh9YQ7m9+Ib5+s
X-Google-Smtp-Source: ABdhPJwN0v2Cx6MVe8hP735M3AqMOhz7avrb1ao2Kku9dh8lbSFyCLIjkMwzudFSSxOXdeUnjp+3gA==
X-Received: by 2002:a17:90a:5986:: with SMTP id l6mr5357925pji.215.1637040460802;
        Mon, 15 Nov 2021 21:27:40 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 17sm13135619pgw.1.2021.11.15.21.27.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 21:27:40 -0800 (PST)
Message-ID: <6193414c.1c69fb81.359b4.7e89@mx.google.com>
Date:   Mon, 15 Nov 2021 21:27:40 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.217-252-ge6c57234f303
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 110 runs,
 1 regressions (v4.19.217-252-ge6c57234f303)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 110 runs, 1 regressions (v4.19.217-252-ge6c5=
7234f303)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.217-252-ge6c57234f303/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.217-252-ge6c57234f303
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e6c57234f303743d1a3a358788534d7cf6f1480c =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/619308e2f81a5655433358f5

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.217=
-252-ge6c57234f303/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.217=
-252-ge6c57234f303/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619308e2f81a565=
5433358f8
        failing since 1 day (last pass: v4.19.217-72-gf6a03fda7e567, first =
fail: v4.19.217-85-g1a2f6a289a70)
        2 lines

    2021-11-16T01:26:43.974744  <8>[   21.265533] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-16T01:26:44.021414  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/105
    2021-11-16T01:26:44.030824  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
