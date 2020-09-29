Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67BCD27BACC
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 04:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbgI2C1J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 22:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727088AbgI2C1I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Sep 2020 22:27:08 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED2FC061755
        for <stable@vger.kernel.org>; Mon, 28 Sep 2020 19:27:08 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id k13so3070597pfg.1
        for <stable@vger.kernel.org>; Mon, 28 Sep 2020 19:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FHp//qf+a3+Dr5TM4JlN+CI4g+Y3bNQMtiw/7YY7j8o=;
        b=Dbr7fVgxTF8qYBLMGplqrmZT+Sdzd1hjnK4LTORryp9P4B+xsys8y5KcrJ/ub3AA7T
         9swwLPXQLYxy683y+/4f6u0P/nCEehhnVT41y2jluhzsYDHJWN1wETTupSpkw2KhUkPM
         nymRWFrBFkGgiN0u2cyxfTOpnFBg4AKnxUwjWlDH2ZGhBp9/9KFcFXE+1GYYGkJYWq6N
         YV3a7uGp4v4l4JfkGB3lQ84Lph5kxjvNy/ES167euBM+4HqEwXDNQ9/0Gcq6ZVli5tuW
         TFxjkg0UUf9eDyTLX+2ddX1QEU9P7awbiqemwd8ZpxgNEK+JmdKEjwqrnTF5XWoMd9Ok
         mv8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FHp//qf+a3+Dr5TM4JlN+CI4g+Y3bNQMtiw/7YY7j8o=;
        b=jkW0tJ57MaBwSYxKTt2uuLCLSSg9jpAktCcqCeKLgya/OcT/Cvd1tpnUcaUpkKKYHD
         woxxjNQObInyUhlbhDXQdreF155pKERM0pWgYXwJ1XZiXEpM1OTM17pDGfE0Z8tU74Z0
         RM1VXlqfh5sYQ1CvKRnO55OoLAeULwGzhOZ3ys0NO39usps8NBPJMcuAjj07VS3kTkuJ
         UpsdMZoKQYikT0kpabGxrK0KjSNnxbSNF0zxLKPwT1RLarC2nUVzvIzFSvdZsNwfwSzz
         91RHj/5phc1yVv8f1LbUgiX/SYrlzlSlje82qIyFZ2SDEJGoDSOGz8vglovI0WeX7hl9
         scjA==
X-Gm-Message-State: AOAM531zB1wf2arET6WZ2sgdWJ5D93s3t/kydekh5hxsySWfNjGUP4+r
        0gUHdcyJa6gnbjOYEsg0s+1v3ELCL01qhg==
X-Google-Smtp-Source: ABdhPJzyo5XQJnDs7YaLOw/vFHR74iBRUorEQw6OM4URoGCYK5jdmah45X74VA76eIf33i4aFVmKjQ==
X-Received: by 2002:a17:902:6bc7:b029:d2:6aa:e177 with SMTP id m7-20020a1709026bc7b02900d206aae177mr2177693plt.52.1601346428095;
        Mon, 28 Sep 2020 19:27:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q193sm3082031pfq.127.2020.09.28.19.27.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 19:27:07 -0700 (PDT)
Message-ID: <5f729b7b.1c69fb81.d3553.6bf3@mx.google.com>
Date:   Mon, 28 Sep 2020 19:27:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.199-165-gb0afa020df97
Subject: stable-rc/queue/4.14 baseline: 156 runs,
 1 regressions (v4.14.199-165-gb0afa020df97)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 156 runs, 1 regressions (v4.14.199-165-gb0af=
a020df97)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.199-165-gb0afa020df97/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.199-165-gb0afa020df97
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b0afa020df97e131505ad03e360871c2610e925c =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:     https://kernelci.org/test/plan/id/5f72629e8e44ed3d1bbf9dc4

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.199=
-165-gb0afa020df97/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.199=
-165-gb0afa020df97/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f72629e8e44ed3=
d1bbf9dcb
      new failure (last pass: v4.14.199-17-gf2d2015b9abc)
      2 lines  =20
