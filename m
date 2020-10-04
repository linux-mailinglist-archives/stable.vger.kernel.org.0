Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D18F7282B95
	for <lists+stable@lfdr.de>; Sun,  4 Oct 2020 17:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725826AbgJDPt2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Oct 2020 11:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbgJDPt2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Oct 2020 11:49:28 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC03C0613CE
        for <stable@vger.kernel.org>; Sun,  4 Oct 2020 08:49:28 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id az3so342239pjb.4
        for <stable@vger.kernel.org>; Sun, 04 Oct 2020 08:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=720L6xvcuXuNczU8B5+GEojrGtoNxmf35CERzPnnHHU=;
        b=DOipN1efqQj76IEF25zQ/+vcA9eJWpnlNAwfKYOBb5PfQDpjui/F2EtPCRuxN7lKLy
         xnqMN9LJvzU9NpeGODtFqbaDzOXYezZPAfoNd+RlYqXVw0EK1CWrh44UAScSR2VJQusx
         IvzQxwhr+JQBQM7xeSwZ/RqffAwx5qWrMuTg3zAN66kwad5MzXbNQlqeXYL0IbJlQV+p
         bTq3PMq8ZVH/iyF+6tbF006G2yIbWm8KIyRK1Y+J0LODSXPmaHHOUZgOwqFFVqka5ZRM
         VhEpuHbyEHejOhmlfUzrLmkh3owMND7XMIRDZpCmF+YkejGh1Es3VuvRDPeiYFu2u/fe
         CjeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=720L6xvcuXuNczU8B5+GEojrGtoNxmf35CERzPnnHHU=;
        b=QhVL/bf3Rh+BJa6XvdiYroQRmnDpAUEsqqnEBoE2kXIBUoiX6i20d0QBt3cxreb/5O
         J4xgOmwBnNWG5/TTq0x9aETtWQ7JoOm7Z/asKhHorCU5XuOmAFhqLj5EjJ9a2Dq5kmNJ
         2ZDXpAWZTYoY2qQnJ37D763o6RongR7rbz8e/zoVGf/nOmLHlfJAZn4QvflaBY9PKnkz
         qvypMuHfqPaQQsX8TfGsbUKDbLStqNeIWLYzuKlsgIz7QmdWGCCVQ9qbzf6ClEnKanlf
         9Y6bDucie0lhLXpTZgy/aQOtFlgRPPiMzABqttDDmwffYq3U0d2gegTI77Df9ptzUe1F
         txHw==
X-Gm-Message-State: AOAM532ih1pG2Vfs3A6ZtJbIQ1YCkV090Oayj+VFAaOEWTqrcp5zWXJP
        PrsbOv4CTif8n5P8l5bhormgmOWqlrUQbQ==
X-Google-Smtp-Source: ABdhPJy86jAviAATeknlFvCHL1LJJxi6QisdKZlz8SpS5g5Mnz8aRqaPymrM1DnluJBcyalGopqpuw==
X-Received: by 2002:a17:90a:d704:: with SMTP id y4mr12985990pju.159.1601826567439;
        Sun, 04 Oct 2020 08:49:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m13sm8559239pfk.103.2020.10.04.08.49.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2020 08:49:26 -0700 (PDT)
Message-ID: <5f79ef06.1c69fb81.16739.1321@mx.google.com>
Date:   Sun, 04 Oct 2020 08:49:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.200-8-gb1ab1c6f9ae9
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 90 runs,
 1 regressions (v4.14.200-8-gb1ab1c6f9ae9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 90 runs, 1 regressions (v4.14.200-8-gb1ab1c6=
f9ae9)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.200-8-gb1ab1c6f9ae9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.200-8-gb1ab1c6f9ae9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b1ab1c6f9ae96c7a9d5552b948afc16bc1074ae7 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:     https://kernelci.org/test/plan/id/5f79b5adcd98b2f6d54ff408

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.200=
-8-gb1ab1c6f9ae9/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.200=
-8-gb1ab1c6f9ae9/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f79b5adcd98b2f=
6d54ff40f
      new failure (last pass: v4.14.200-4-g2338e5879b46)
      2 lines  =20
