Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25CD029F986
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 01:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725926AbgJ3AMe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 20:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbgJ3AMe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 20:12:34 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97194C0613CF
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 17:12:33 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id r186so3716616pgr.0
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 17:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=P67CXAdqQGN6O6/YiY7cELxxBxqW6+KxOMBKCimbZ3E=;
        b=ITOVZAoG3rPOjyineBywgGB5FkIm77kYt4DK8atSoYZOHDp90iBYmxnwCbogLBDNZ7
         oNOSysRm4Pe1OZ4EJgFkG3RXaBT1q4u0nokxmYC3LT8PQtFyUFe8XvvJwddPW/L+pp/e
         Oc1C3J9YcBe8dAlTxHUXB3G8WI+Pt2fkCQpsyOXWz4DaWEn3mQVi4XfhtKqzPWIsJbz5
         hmHN+7FwktB22CRoe8qofFg7GAWFCwaODHfIa226Wl/18bwx1btpFZdXbJc77rWasYCY
         BBpcFsN4w6Nr9dZTRRM4CtfIst4d7VIJxkAWvEG5RwilEeIjo4RHEUSlq/WQ+XZiZ6aO
         ljMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=P67CXAdqQGN6O6/YiY7cELxxBxqW6+KxOMBKCimbZ3E=;
        b=E5SaqLL+ueBDOxpU+7opw/kMZ5Z9pB+lf+C/ooy7B5BBxoO/oXyJH2Emn1GTm5i+C2
         AlzMJxnndIjADZlXB86n35m4FBcAEvS/XsRzJdcFUAt9xtgBL637xCwqQCWxuMOH+xu1
         p2IGvJNYyZPxjVHva7QfvNteHXod0CP7+9chAgcZ6cTB00kLiTtmc9Sg+ufe9bZ2u7kW
         7MoXwytcCUPZMy9bq38Igy8XLjix+upCdO8lI7GT7GDlH0XQfTQ5qpeYW0kcGuL0PgWw
         N3pltHBqAaMdSfOLnjX568rJTfN2BkngPyDFgVz2WASgOZnfyfTSi0X61ls7QsxEw0kl
         KSBQ==
X-Gm-Message-State: AOAM530n4lW9JUxuhG8YPs24JpmejXsVlp9iXQl/j2wn5GinAOv9OtdG
        kXDBG/XiG23Hc57Oil+riz7EMGWZF+pGCg==
X-Google-Smtp-Source: ABdhPJyxIqW7mxI1xVZh31iVOSjU6txfwUBggL/Mxwo0eJ2Ss2moLV1g9LyrMMJF8IqSPY8dqLhXCQ==
X-Received: by 2002:a17:90a:e545:: with SMTP id ei5mr1792096pjb.60.1604016752854;
        Thu, 29 Oct 2020 17:12:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w187sm3989999pfb.93.2020.10.29.17.12.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 17:12:32 -0700 (PDT)
Message-ID: <5f9b5a70.1c69fb81.fc942.9c00@mx.google.com>
Date:   Thu, 29 Oct 2020 17:12:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.203
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 6 runs, 1 regressions (v4.14.203)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 6 runs, 1 regressions (v4.14.203)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.203/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.203
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2b79150141611d3c6e1b55d4e70f49602482f0b8 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5f9b284a24b47467a9381015

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
03/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
03/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9b284a24b4746=
7a938101c
        failing since 5 days (last pass: v4.14.202-11-g83970012a2ed, first =
fail: v4.14.202-22-gc247dbbd6699)
        2 lines

    2020-10-29 20:38:31.053000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
