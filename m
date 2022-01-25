Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A759B49BFC8
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 00:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235030AbiAYX5J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 18:57:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235028AbiAYX5I (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 18:57:08 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA678C06161C
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 15:57:07 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id z131so8589533pgz.12
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 15:57:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SDWXOjZig2fGfGle5ConVMpswvs4UTbrHDF1Tu7gBg4=;
        b=AFWb1yBoy8PCPu4rpK8yv6VT6iont6vzSkFW+w1GiL2LWQrVp7Tv+frUDpjO7LWLUa
         HSft3IQu2BJ75SPw4BUkR+xxPJ5rgfoGgt9QXGoab9Dj4x0AL1ie9P9VIBpmnk9szNZU
         GfhNtaeaGW62iAcWB2U5H6thfyJ9rvt4mNP/wDyNV3Jo2Lk1EWkHJDiy3iIBiRO7t8sw
         GkfkUAXKcqLmCrGXLsArzfGWquoEMBjBvt9pPvKFblwuHB4vh4pbdOXclACUqQnFSCLd
         d9UrGMWUsLPbws/3yblvbTBlaYR/LgUgVqhgroJwSqvMZAESiFL5umDJYKytwI3SySZ3
         fZkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SDWXOjZig2fGfGle5ConVMpswvs4UTbrHDF1Tu7gBg4=;
        b=uJmCB6rVDd4A2VTy3oP0lgP52HL7RVueVQJi8eE/nL5Za9aAYxnSl1RgKGIZVxMymr
         5SJSDViwpAcsOpWLvNXFEewUcouLDOFB3gh2giKtYhIrf0T9r4+U1ks6dyFVbLIZPfBl
         lj5kX7St1RXJP8CLyc0lIExp+ol/FcDWQpjqMYQRL+wYqJVg9a03TqHtw3Tm/jROTcrX
         6+w/f8/x0F6eXWwOPBXjJxg+dEvgj6RGGKTQe8cjUUMgNPBhyXrprnNaaS7rsXawJzIC
         1PvO2I2BmstYgEli3OUIwEvFiXDaLmgQgLj/v+fylzOfcKVDFuI2PuirIuuuE3zR/Aw5
         /ydQ==
X-Gm-Message-State: AOAM531c3nDcHFiDp75V6wdljB0mKqB6zYWCBDTLT6NGJFOr7N0dCj02
        7TouLJT8GrOQc5dX3aX13gvKELPmHA7OY5Gn
X-Google-Smtp-Source: ABdhPJxCDqAb1R+g9tCFKiFmzcGuiESOVm41raP+gTAq3hQXfbYg1i/WhxtXNTVFNANbD8YQlkSS5g==
X-Received: by 2002:a63:216:: with SMTP id 22mr8210974pgc.7.1643155027089;
        Tue, 25 Jan 2022 15:57:07 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id na7sm1483567pjb.23.2022.01.25.15.57.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 15:57:06 -0800 (PST)
Message-ID: <61f08e52.1c69fb81.b9f3c.4c71@mx.google.com>
Date:   Tue, 25 Jan 2022 15:57:06 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.299-114-g67ca9c44f63d
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 117 runs,
 1 regressions (v4.4.299-114-g67ca9c44f63d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 117 runs, 1 regressions (v4.4.299-114-g67ca=
9c44f63d)

Regressions Summary
-------------------

platform    | arch   | lab           | compiler | defconfig        | regres=
sions
------------+--------+---------------+----------+------------------+-------=
-----
qemu_x86_64 | x86_64 | lab-collabora | gcc-10   | x86_64_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.299-114-g67ca9c44f63d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.299-114-g67ca9c44f63d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      67ca9c44f63d6f68d005676063726961c289fbba =



Test Regressions
---------------- =



platform    | arch   | lab           | compiler | defconfig        | regres=
sions
------------+--------+---------------+----------+------------------+-------=
-----
qemu_x86_64 | x86_64 | lab-collabora | gcc-10   | x86_64_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/61f052304407105431abbd36

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.299=
-114-g67ca9c44f63d/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qe=
mu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.299=
-114-g67ca9c44f63d/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qe=
mu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f052304407105431abb=
d37
        new failure (last pass: v4.4.299-115-g5b24bd65b9e3) =

 =20
