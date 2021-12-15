Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22838475178
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 04:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239608AbhLODp0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 22:45:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235616AbhLODpZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 22:45:25 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 786A8C061574
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 19:45:25 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id k4so15268963plx.8
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 19:45:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hiv7y18sVV7dAJL5EfAfrMbbT6LjR9Gm25T7l57OE6I=;
        b=0cK7YWpsCUhSclEDV20mfK4YKwX+mmzaEC9+mOVcfOC5+ZPw5nYllcQfeUPVZ5NHCv
         HXpufrsdcAv3gWETYfjWBD5YVzx7eA54Lb0pR66az+/mfKYDFLbQxowDSMMC4da2G/pD
         3Qp5g8nnjvflwUvCOMawKXuzJq9KABZdFT9lkTmrRZaBdLmuLaGnUeq7cN6azuP2dSIp
         /txJbVbjQrp6gTG43vmzmpL0dPfxJto15ooKvgM08EL5ZuEPZuRz1MLvileEqzPKtmKv
         2+l4BO7TcKxx/smibSxdthehQYQWETxC/n3QGDq4SfUaHd60FuiJAL+8uMyNZXm3z+BU
         7Kyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hiv7y18sVV7dAJL5EfAfrMbbT6LjR9Gm25T7l57OE6I=;
        b=GiN1XAmYo343l3fcwrvtBH4QysUvvB7yTRDMnOPK3a4AvqRm/WZRfl1srmfmCjgAQ1
         UsiaBGy9+LRLA1za69jpxFT9m1ALIDF8fuAVuiiiva8oDQYW+QJlE7i+kXxc2UmYARbA
         fqj3gEVLRFYO6X9OZw1N3G8k02zt6XUinNsTUJiIqdqQYjwAMzheYv9B4WuHd8s9djYp
         /O3Xbbr49oFK5ZCsjorUjcptxXcl74PeaMbK7lDHC8pIsrvPKELS+BV34wmM+cETnt0+
         jajCIPlPNPE23G6Xzem5xsBXi4YbvtPMXNG9pmOiJaBTHdj7Of4d+czquBkAQ4Kwq7j4
         YfnQ==
X-Gm-Message-State: AOAM5333OwY53hYiG0oGNVniwDdfhFJnPE2qeFnXC8EHq+GeBrSyXjGe
        0Xp1SDkFwI/pLkD1FeXOtj4TRQ0U+OIhsa4k
X-Google-Smtp-Source: ABdhPJx+NMlFlDiu1bgLdOt/GNuYp1aQk1ueJMWdIrS5E6ihTVY/p8IXgPdy6Jdli2/SULzew5QtBA==
X-Received: by 2002:a17:902:f68e:b0:148:a66b:2231 with SMTP id l14-20020a170902f68e00b00148a66b2231mr1352280plg.106.1639539924887;
        Tue, 14 Dec 2021 19:45:24 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nn5sm3759455pjb.11.2021.12.14.19.45.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 19:45:24 -0800 (PST)
Message-ID: <61b964d4.1c69fb81.2a221.b422@mx.google.com>
Date:   Tue, 14 Dec 2021 19:45:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.8
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.15.y baseline: 100 runs, 1 regressions (v5.15.8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.15.y baseline: 100 runs, 1 regressions (v5.15.8)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      43e577d7a2cb60ad478387155c9de352f152101e =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61b92b0e76277d171d397160

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.8=
/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnowboard-turbot-E=
3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.8=
/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnowboard-turbot-E=
3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b92b0e76277d171d397=
161
        new failure (last pass: v5.15.7-172-g5eac0dfa371b) =

 =20
