Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6B382AC4FF
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 20:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730330AbgKITbK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 14:31:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbgKITbJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 14:31:09 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBB3BC0613CF
        for <stable@vger.kernel.org>; Mon,  9 Nov 2020 11:31:09 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id 62so7979171pgg.12
        for <stable@vger.kernel.org>; Mon, 09 Nov 2020 11:31:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DO68E1MeNd7OrwY8UV1MziJYsAXdEBvwXvNhpMHhCD0=;
        b=RehpVdis/Wn8c5z/fxpqQv+pdn77/zbmFmu0bz6SUh6Tm/41CiJAfK3VTJlEKhc9Wf
         4Kqlg9Kaowdq2RVVWOq4xekQ0e6I2yHWXSVJRM0JazzJr9BkRQn3aQhwrGXDK8hBQm9j
         ixMEhdKnrLjwaxvGZNNBkFjC2eA7ch6x5g0az+lrkKb3wqR0JFon4nObzZ5hO8sl8FHD
         7gxx6xwdn52gMjC0zKPnkssYrXAxiywNqz3cW56KSQozAY/hsu42kMbU5wTz1fdKV2/a
         xvGClQ4pqEQnetIPj+NDrRItTcTkjX9fXywpfv62wo5JdTmXY9FxwnAjHwJdMjLctWSd
         dvnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DO68E1MeNd7OrwY8UV1MziJYsAXdEBvwXvNhpMHhCD0=;
        b=uBnpvwtTMoqPBTiFETTft/fzyK9lSSqATTiErb4tri0D+kKGBSuPXxR3pcmJAbj1xM
         T4A/JTaobWvwp+vrwcz/AU7W99LlFfzPD7vmQ7HRFVF5UjARtJ1mvQBlM3uQhooG6TDT
         Ftaxa/qzlaKjTky//QIbFD0/CePuD868t7+TbBQNyDCG+uDzcX1unB3/I7PzMIZDGmJc
         hEJGacUNpWAxiVZxY+MHSa876mtZYTGM9qd8IZT9vpgRncpqKzQKCsAqVC+TUXjkm1af
         DsJRCx/oyUtAS+CACj9ZJhtBVgOgZya5bwOBcR04P058OfCDCNp4WXNrHH4JrNnx5iUJ
         i2Vw==
X-Gm-Message-State: AOAM531haZ7qTB5V83ZmVeiSv35CiV6CzWjckmvaCUsRQNgxIfN6/znQ
        7HCexY8MYqJ+s3BkRRauNAKkRVx7COTO4g==
X-Google-Smtp-Source: ABdhPJyo+7EaTu+SNDfSjm6jGml/4Pq/DN+s5uV71uRYB27lU+ptaagzz8BfPj+iu5P3cYNhxG4HZg==
X-Received: by 2002:a17:90b:4a07:: with SMTP id kk7mr731806pjb.175.1604950268907;
        Mon, 09 Nov 2020 11:31:08 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 8sm246752pjk.20.2020.11.09.11.31.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 11:31:07 -0800 (PST)
Message-ID: <5fa998fb.1c69fb81.4e9e7.0bb0@mx.google.com>
Date:   Mon, 09 Nov 2020 11:31:07 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.75-85-gaf478e97f172
Subject: stable-rc/queue/5.4 baseline: 206 runs,
 1 regressions (v5.4.75-85-gaf478e97f172)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 206 runs, 1 regressions (v5.4.75-85-gaf478e97=
f172)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.75-85-gaf478e97f172/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.75-85-gaf478e97f172
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      af478e97f172d981d6c2b8bf158df2c70928785b =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5fa9687817f508aa8cdb88a8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.75-85=
-gaf478e97f172/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.75-85=
-gaf478e97f172/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa9687817f508aa8cdb8=
8a9
        new failure (last pass: v5.4.75-83-g25ef9a88d0ad) =

 =20
