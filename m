Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05AAE5F9F66
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 15:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbiJJNbH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 09:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiJJNbF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 09:31:05 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E3D18B3D
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 06:31:03 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id gf8so9834828pjb.5
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 06:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=hN7YdBPD+rIhGDRBLbYhTGFg6CL2ybn6z1ciVUSelKs=;
        b=lXPFhL+KhXJRnVyGbCA0cZ0nF7OAHgjzqMS6rBPVERo8jHq8G6bBpm36gepG0lCg+i
         EWOtigygERGsc4nXGggEQLg+cj0P3ct+Z1AteStV5zA62KBwyNkdNPwY/RsGxAkOjB+J
         2vD1mJnWk9b6TgSAP/35U/pdAKe2ahqUdsuUVlwXCiM6c2Qjza6GPuAQu9WRamee9b2I
         9Snn9YpjW501wbWamxBiEUQmQcsZFaDwN+nJtnl47X8bhiv/GDxWJjETYp+dXkknMtxr
         rL34HwXbrjjzZEyS6IZYaZluAdOypE7NJose07v0Kgrh8ybAzOlG8NOV1DcRsQ3CcQIv
         y/sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hN7YdBPD+rIhGDRBLbYhTGFg6CL2ybn6z1ciVUSelKs=;
        b=BYvkiVHeUMIFvGH5ncMZRLLKGIv4QoWyIc7woJuiQBjuSUS5Nq5h1lAXd7OZgMrTfS
         JETcUKANcWXT9KPeqacbnZQ10/rBZvorv0paBv3yHrkGiFCjpiQ+qP7CH1rKSUeknLYZ
         YLWAzLvGyzXzyP0Dkf5fT+XVFNktDUNnIihkKO8WzqAHcCD+AKA52t3plbHkYQtqIIHr
         dlyEsTn0UcmUZKaJPHws2aKVO2BNCweJbmcFyj660TMUulxJzdTUU5W/D6XMcD5b3Tx6
         ud2iqH4mQf0mW5X0zqFUvN5BJ+wFuZr1SiKUeeW+bYRQ38dCgpvDyY7Xi5bsTpiBx4yT
         4RVg==
X-Gm-Message-State: ACrzQf1C/ww4XnmJysv4NSN7FiqgeUMUmw6irlmWfhlLmdxx/QtPcFt0
        mdch9DS+bzl+tVtBSdzATN/LYpii/zsaKp1jWlw=
X-Google-Smtp-Source: AMsMyM4jkRZwGHKQyU9PYKlKXVgfi45lQlW/wndESiUgr55dAiB2/03ud6CUxXtPuFBK9hDyz2OAOQ==
X-Received: by 2002:a17:902:c652:b0:180:556e:1b58 with SMTP id s18-20020a170902c65200b00180556e1b58mr15804836pls.35.1665408663289;
        Mon, 10 Oct 2022 06:31:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h15-20020a170902680f00b0017f7c4e260fsm6628458plk.150.2022.10.10.06.31.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 06:31:03 -0700 (PDT)
Message-ID: <63441e97.170a0220.547ca.adc2@mx.google.com>
Date:   Mon, 10 Oct 2022 06:31:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.330-28-g4ab4407c29f3
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 91 runs,
 1 regressions (v4.9.330-28-g4ab4407c29f3)
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

stable-rc/queue/4.9 baseline: 91 runs, 1 regressions (v4.9.330-28-g4ab4407c=
29f3)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.330-28-g4ab4407c29f3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.330-28-g4ab4407c29f3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4ab4407c29f365878d117d88f2ff2d97f271362b =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6343edf6a291c1a068cab61b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.330-2=
8-g4ab4407c29f3/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.330-2=
8-g4ab4407c29f3/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6343edf6a291c1a068cab=
61c
        new failure (last pass: v4.9.330-19-g1b37de80282ab) =

 =20
