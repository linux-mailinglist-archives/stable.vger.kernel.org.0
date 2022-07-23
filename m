Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EFCA57EFFD
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 17:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237704AbiGWPPo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 11:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237409AbiGWPPn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 11:15:43 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB59EE1C
        for <stable@vger.kernel.org>; Sat, 23 Jul 2022 08:15:41 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id bh13so6686985pgb.4
        for <stable@vger.kernel.org>; Sat, 23 Jul 2022 08:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+gWKQkSK/a830O4dbsi+e738872yAl2gHA1/JgLZRfc=;
        b=6daUM+SR4iV+Kce985sVy2X8hMJwT6GLAZp5JvVXWglTcTB80mPBVbDcPFgAXYoK6g
         PDacsI/uJNBpQ8QqEBofB4A83i6vJHk8uZ/ecz3GiEj8k5QwyZCSQVk33YrzT+fYrtLV
         yxCXuW+8UTLy3T6P4XCWkYppH3BAwh/O+MymajqUV9RfLtbHq3SC1zphf6mNL5vlNS42
         E57rbXTo8z8zNMnWL70P0IwhcubMoJ04HphSjZwORKuqcQyv5mx/bzeS13r0hovC4gcT
         c9Cp30xAc0AVTUvDGVeRYypIPVfW+s+ACwxA5fa6NU1s7MqHEjaXm8qPbaYK2zWUEbwL
         UMZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+gWKQkSK/a830O4dbsi+e738872yAl2gHA1/JgLZRfc=;
        b=sO8ZhtC4AFwTHno3IC4P+VB6VGQ9z/s4yDMsHYaL+TKCZApfJ9iSA8PSP3J+K6E4of
         k/Dwa8p4/OoxPezF4u3kphJo0Q41Jn35FsnvXl4UBd0Itp84u64BU9cp949f0Dx6P/Ri
         c8OlmMfVxifuJBdDR2QtfP6l5XQi/3j122hcKbCIaL3DVDWU0rDJ45ZnLo/PvkpFDAZb
         UddLa6yvu4sgDueEgwM7AXl8bSr2Fjl0/8dvOb2mpyyYic0kA5iknuBZtix1C309NXCJ
         g3sApGIRqsRDwquX/9Rn04Bd/x9nddsBOq4fImU8vCK25drle+F7RB9nIwQj3iCihR9a
         wFpw==
X-Gm-Message-State: AJIora+M83tL+CjdvglD9oK6xOFWiw5+KxfRaBAxe5GvlGgynSLFMksD
        2uMpLQUzvc+oRVoQND0EVv2xBB6A7JG5te8q
X-Google-Smtp-Source: AGRyM1tHtXoAziJHMCslvbSjPH/PyxBZL6rWCIpaQ3uy6yFFLIB6irFt3sxTWHo3sK5nqwMmxcFgCw==
X-Received: by 2002:a63:2ac2:0:b0:419:8145:639b with SMTP id q185-20020a632ac2000000b004198145639bmr4278323pgq.42.1658589340816;
        Sat, 23 Jul 2022 08:15:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j4-20020a17090276c400b0016d3935eff0sm4498145plt.176.2022.07.23.08.15.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jul 2022 08:15:40 -0700 (PDT)
Message-ID: <62dc109c.1c69fb81.2b617.6e1d@mx.google.com>
Date:   Sat, 23 Jul 2022 08:15:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.56-89-gda767b441272
Subject: stable-rc/queue/5.15 baseline: 117 runs,
 1 regressions (v5.15.56-89-gda767b441272)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 117 runs, 1 regressions (v5.15.56-89-gda767b=
441272)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.56-89-gda767b441272/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.56-89-gda767b441272
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      da767b441272e9b57fbcbe24a3af231b136c8469 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/62dbdfbca7ba9d9fdbdaf05c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.56-=
89-gda767b441272/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.56-=
89-gda767b441272/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62dbdfbca7ba9d9fdbdaf=
05d
        failing since 114 days (last pass: v5.15.31-2-g57d4301e22c2, first =
fail: v5.15.31-3-g4ae45332eb9c) =

 =20
