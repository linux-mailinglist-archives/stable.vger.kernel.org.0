Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFA4E3A0B0E
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 06:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbhFIETM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 00:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230492AbhFIETM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Jun 2021 00:19:12 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7358C061574
        for <stable@vger.kernel.org>; Tue,  8 Jun 2021 21:17:03 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id g6-20020a17090adac6b029015d1a9a6f1aso2911217pjx.1
        for <stable@vger.kernel.org>; Tue, 08 Jun 2021 21:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4+3VvQ5/I/bJadY9OsNnQtVY14zFqeRsLrRX/XfHavA=;
        b=XrMcTqZByxudJ42HMXq11Hqu74QKxnghHo/h/uG7gyiu/2HDnJwOmEVdIvYVmos5V1
         WP+xrjWXUp04LzEq+H2Oe+k/ZfbSvoFmCBCan2CNSQEsz2S6+yMDKNL6VSxWe5xgn4cG
         AWUGd5jAJZkH7vCnXHST3ARMBfWugLJt+ISUVWcT9KLZ91SMAKleBXi77l82Q2fG+/BF
         RRprKEXBON2/xq2iRp/08atu0Qg2cz37ClZa55+eJpaDoVlFwMn3bp1A+U9Y/6jf72+J
         Gn19YvJf7wAmrYAWlpULWgFBdHLPhdAl/9NTE8WHtReaIdcvr8LNalvmXz236SNxbWm6
         8bqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4+3VvQ5/I/bJadY9OsNnQtVY14zFqeRsLrRX/XfHavA=;
        b=kTFG8TXbihfrOJugO0OaWWBnmQNetOy28qAgR0x2ADoJzwvm2PRhrbmKS6ijuQQlW9
         YcTNNefXhToJ8R0TYW/aEQIw3ZmS7dzgoLguT+pCq1uMjg2fnitfC6gbKArRJHjDXBRX
         tTuYQMCDHa1zesTffnsWjKj2xD29xhV6phaRlOsoA8ipnfyMq04KLbUaFU68opv+815m
         Y/SBZWawsofE4RsgHX7Nv+ApE0nCfbbkWkznhnJ1XjEVsivU4o/H1wjKzlUpGKjbGpbf
         iLZldoxQ4ILB8ax3TkN7vmeAOsG6M8wQTbgS6m6HKuF+ydzFicB4zUQ1Gt7mf2N6BWMZ
         tpYQ==
X-Gm-Message-State: AOAM530roLfUMCqZQ+qN6WtMADtHVk7fxguhd18yh2ZvkUsvLdh4Jc3J
        qtTtcVdXUYlb8GEDn8N+bko0ymXh9viAeLMQ
X-Google-Smtp-Source: ABdhPJwZhqeey9vdYWq/UhxzsdhtxGSo8nm7E18wZn8A98jrjBb7wueJfHY4nbbCMWluuRHJXqcL3Q==
X-Received: by 2002:a17:903:31d3:b029:ee:bccd:e686 with SMTP id v19-20020a17090331d3b02900eebccde686mr3211123ple.1.1623212223281;
        Tue, 08 Jun 2021 21:17:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c15sm13133215pgt.68.2021.06.08.21.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 21:17:02 -0700 (PDT)
Message-ID: <60c040be.1c69fb81.cdd34.9940@mx.google.com>
Date:   Tue, 08 Jun 2021 21:17:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.12.9-160-g06ca62e1f692
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.12
Subject: stable-rc/queue/5.12 baseline: 107 runs,
 1 regressions (v5.12.9-160-g06ca62e1f692)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 107 runs, 1 regressions (v5.12.9-160-g06ca62=
e1f692)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.9-160-g06ca62e1f692/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.9-160-g06ca62e1f692
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      06ca62e1f69233f6ff0f3c829f66d1232ccb8859 =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/60c0095e6e5be8fee80c0e0a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.9-1=
60-g06ca62e1f692/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.9-1=
60-g06ca62e1f692/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c0095e6e5be8fee80c0=
e0b
        failing since 0 day (last pass: v5.12.9-153-g7a4b632f5146, first fa=
il: v5.12.9-161-ge6befd55293b) =

 =20
