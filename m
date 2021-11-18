Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5350455FBE
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 16:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232419AbhKRPrA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 10:47:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231613AbhKRPrA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 10:47:00 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BEA6C061574
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 07:44:00 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id h24so5463225pjq.2
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 07:44:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bFB2Kd7VBsl4vHFftQvBkjbtNVbo4gvaTPqnlcqmWPk=;
        b=xXBFJB1vPV5/BWKLJg++T4tpsdB25+fBpvCv9GWxZBo3zNkcQpE01sgdsT13bBNS0L
         kiQAMU8rv2hX3XcA5YDaAc38029irGc6fCjlcUoqCIVM+dMAr2McgO6AhCyXQcSgwpOW
         6FRXKxQuh5EhJnysmygQRQt1Qo6IxXEpiMb6LB8gTvLW5ElQTJ1c9c0E4bPzMIM9rI5s
         Q8WjZNPDkIzxPJHwDirbTqoVlewBNinA0/B6EBq2XgHXXMdMa/RLzw8a4S7+yudj0OYy
         BngPdHa+oiA/9CnZz6Og9GAKEGiRolcLplzkFZpO+wJyU8jEth0kNdfJrzJarl+ZDNfG
         81aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bFB2Kd7VBsl4vHFftQvBkjbtNVbo4gvaTPqnlcqmWPk=;
        b=BwhM17DqVylX8EOnQeBGSoqPKOHZZQ4Bynwd+KteMvA8zGsV3YT0/1xRFiAN7m0IST
         gIU2J4oCt25CFsVnWna+TiXjyop4p1MynsNurnqhuo3gqpLwbpP+LyXq4hxCsTS/BC9P
         PImb5t+pm7Q9RNus1/Ayo3x0/VZNjKJWmmtFtIuEsARgbFQxUrE6h2wABDGYDyePTfBv
         Fl9pVBJW844vBGiMuXhJQhy1h3g31PJFQ++SaR/7Jj6308ChulrbBeEPAc/0H0zQbI8o
         P06EiqM7dDKkQPjLubHDgUUFEnnQAZavVW3Gpps2ITXfNbnb0Ku86B7U5hkYIK4/nCA6
         uU6A==
X-Gm-Message-State: AOAM531JqkXb6rwwfWJJO/PnA5J5F0nzOBfkUI0xBJ9TwzXUrqUCmnY/
        11nnXyI1KyfyP7VptukrOTsGHLaevc58AwhA
X-Google-Smtp-Source: ABdhPJwDr7Nwm2k9imF5/riwiXIjPpzboGTLtuVbaPhRW19J6mDB+ycqgsgcuXQPllETBpNAcYgL+w==
X-Received: by 2002:a17:903:2344:b0:142:25b4:76c1 with SMTP id c4-20020a170903234400b0014225b476c1mr67973793plh.43.1637250239882;
        Thu, 18 Nov 2021 07:43:59 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id np1sm9290258pjb.22.2021.11.18.07.43.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 07:43:59 -0800 (PST)
Message-ID: <619674bf.1c69fb81.b9611.9d6c@mx.google.com>
Date:   Thu, 18 Nov 2021 07:43:59 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.255-198-gdaf544a98bb7
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 127 runs,
 1 regressions (v4.14.255-198-gdaf544a98bb7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 127 runs, 1 regressions (v4.14.255-198-gdaf5=
44a98bb7)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.255-198-gdaf544a98bb7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.255-198-gdaf544a98bb7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      daf544a98bb75467cbca94b80552a241ecdec953 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61963b1dc23cef2336e551ef

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-198-gdaf544a98bb7/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-198-gdaf544a98bb7/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61963b1dc23cef2=
336e551f5
        failing since 0 day (last pass: v4.14.255-199-g07b05cbc7a1c, first =
fail: v4.14.255-197-ga09e356b405d)
        2 lines

    2021-11-18T11:37:47.236398  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/106
    2021-11-18T11:37:47.250953  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-11-18T11:37:47.259643  [   19.995422] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
