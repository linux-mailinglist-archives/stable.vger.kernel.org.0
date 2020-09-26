Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07EB9279674
	for <lists+stable@lfdr.de>; Sat, 26 Sep 2020 05:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbgIZDqm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 23:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgIZDqm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 23:46:42 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ABABC0613CE
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 20:46:42 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id k8so5038633pfk.2
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 20:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PTSqUuwfigvT95r9gVykooOMVIvBbsajWM0ewUAWYdo=;
        b=UD5duu4XMT6uA7IzhFr3c0dw1RszEHZVf6tEKbyqpBKh6jsKqncQ1fudMHqHul1VNl
         Dxdf2oQ1PaNlEzk765X6rCPFufKHXLILUevqpsQLoBoFrQoUjPZ3UieiCKQmrAbZsVxl
         ph3IqVfgARAPeIhfu9a1NvpgbRtmP6I1Hqg8ie5Cl5ZWjo/9qR1myeTPYmMqYAvlqEVP
         88Oq4J+d+uD3wQYv1Awix08YMNftpf034+9vD36bpggCOas9nZLymHsHFk+VEvRirTIq
         IzhvLXgtH1WhrGEVrBI22RaGdgHrI4gf791ZqBkLzhCrq7FE6j7dFBzdn6yDKLWFHBh6
         0xGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PTSqUuwfigvT95r9gVykooOMVIvBbsajWM0ewUAWYdo=;
        b=tpj4l6cOPTWrKTCtsDak2/4y5DhqY9MK/ddLE9+9cT517VSXe/ngdSaqvlTarHMiA+
         Zom2jCi9Y0sK9CBNlN90rPqL3udNOuRsGu4H+hRsHdX2ekJLzTMoT53TBg4Zj5i9cHSK
         MIXfY/FuexrocpmG7MsicpbPuwnlCQlDVbfYpffM9SJdm4oWDgt7QtHRdfDrES3VxfnC
         +EM6xi8sveyNoV43Nc7/DUQpdVXBTfrOAQbPBvIHwcky3LwzPswpve6MR6G3WjX3AsBA
         14fB5MTKMKstc6lN5rlnVyCZe2fxKtbijQP9cZk0DWp+MAwniNi0yVEemhTpHK88s188
         Fbxg==
X-Gm-Message-State: AOAM5308zOWieGy6JZlhc9tTn0iyzU03tI5iJuDlGj//ykr8/a7UHeXo
        VfO0SAoXqRODIKn//Bm/uSNDeWATwSYTbQ==
X-Google-Smtp-Source: ABdhPJzMJkXeqQrf+JhIsJ/r/E3gpa6xkLVtVf0tOzegQdEa4QVD/TxvszTNgKqXmNrgJIjrnKNIAQ==
X-Received: by 2002:aa7:8397:0:b029:13e:d13d:a07c with SMTP id u23-20020aa783970000b029013ed13da07cmr2043427pfm.19.1601092000991;
        Fri, 25 Sep 2020 20:46:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id kk17sm445794pjb.31.2020.09.25.20.46.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 20:46:40 -0700 (PDT)
Message-ID: <5f6eb9a0.1c69fb81.1956.203b@mx.google.com>
Date:   Fri, 25 Sep 2020 20:46:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.237-14-gb0cd150f03d9
Subject: stable-rc/linux-4.9.y baseline: 126 runs,
 1 regressions (v4.9.237-14-gb0cd150f03d9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 126 runs, 1 regressions (v4.9.237-14-gb0cd1=
50f03d9)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.237-14-gb0cd150f03d9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.237-14-gb0cd150f03d9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b0cd150f03d924671dbf160b5c30917fd0218759 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:     https://kernelci.org/test/plan/id/5f6e86e08b4d7c3e8cbf9dbe

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.237=
-14-gb0cd150f03d9/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.237=
-14-gb0cd150f03d9/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f6e86e08b4d7c3=
e8cbf9dc5
      new failure (last pass: v4.9.237)
      2 lines

    2020-09-26 00:10:04.357000  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/119
    2020-09-26 00:10:04.366000  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
234 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
      =20
