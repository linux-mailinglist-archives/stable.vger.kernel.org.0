Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A75F045512A
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 00:31:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241613AbhKQXet (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 18:34:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240122AbhKQXer (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 18:34:47 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 919BFC061570
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 15:31:48 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id o6-20020a17090a0a0600b001a64b9a11aeso3947511pjo.3
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 15:31:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qxU4hzjpWjhE4zVeasorJSrrowCWmKhNB0flkzQ+nQk=;
        b=3ZOX8FHXkd/L03EKgYQi2P84ers0XPx+heSNS1IPJCRdOj0stl/jhdSo7MOQZRpYKB
         ZLuep7dDyQD+sevX1FNqihagMMn/wf+dp/6B5Ez8fBPJ8BrugMg0e3KlH71aCvLZBBEE
         6tLAaO3Mh7rDZdJLkMIl2pV6XQhpth/WRpSovDhS0lt9ncwSPzo+QyOCpF/QBnsgIdMp
         T+n2+sYvrxEQEv2BtFql2Bhmkuy2SXRs22RdAyZj2mP7IU96sl9Hq0TeDVBsZ9tm37yc
         GP5YzUCaA4N5vAlnOkSGeHNv5u8/kaTcocOzDKewlCQaW7r9RF0FGAkH95qNH8sjlzpX
         WfaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qxU4hzjpWjhE4zVeasorJSrrowCWmKhNB0flkzQ+nQk=;
        b=OOw109DEiApHfIaa/FLuUNSjSbNAF4PjArtEU1BjbHcY4CtOtFq+Uta1nEjoUU1rO6
         U6/Ok+WBbGAruCZb19iv8We6g32yvFpXj9uoyDurbnRmjvm8c4TUeY5CqyxLKP/LbUFe
         6SmgH7adrFlBzTuski3E/gC86d3SwwQOZrKBrQV8Ml9KGwI2HJtpUZwSqj9r4Fm0EWoE
         P/T7GXT3df3TZW5tQnGmFPsZBfCPMCmWsN+olF1SLyxbTFhUKlrXMMkOEZfs4fIt7LnP
         9pdLuKQ96ewcKi3AKuE4B6+kgdLPR3txy7/oUP9bo9zgCZNrTYBUMPGwLhRgF/WgA92J
         GdoQ==
X-Gm-Message-State: AOAM533D+JbP9WWWToHMcYPVgl76ta/HkpFVWXDqebZ6XBQSMU15ZVib
        kFgIV79KCZtC7yRv7WvQ5b9um/zuupzBQKnm
X-Google-Smtp-Source: ABdhPJwiu/dlSCxC7y7peKxQfQ509gTsPS7bsD5EPhp9q+L/glbnxEZhAGSg7ui5AqxGa0cAAG+MjQ==
X-Received: by 2002:a17:903:2093:b0:142:7dff:f7de with SMTP id d19-20020a170903209300b001427dfff7demr60813695plc.75.1637191908012;
        Wed, 17 Nov 2021 15:31:48 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s3sm676613pjk.41.2021.11.17.15.31.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 15:31:47 -0800 (PST)
Message-ID: <619590e3.1c69fb81.774b8.3b72@mx.google.com>
Date:   Wed, 17 Nov 2021 15:31:47 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.292-113-g6228095756d3
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 101 runs,
 1 regressions (v4.4.292-113-g6228095756d3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 101 runs, 1 regressions (v4.4.292-113-g622809=
5756d3)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.292-113-g6228095756d3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.292-113-g6228095756d3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6228095756d3a74fa31d885ba454436e02778fb0 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/619556da4c126213823358df

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
13-g6228095756d3/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
13-g6228095756d3/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619556da4c12621=
3823358e2
        failing since 1 day (last pass: v4.4.292-113-ge9a92f80c735, first f=
ail: v4.4.292-113-g643cfcb15c40)
        2 lines

    2021-11-17T19:23:50.648386  [   19.471343] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-17T19:23:50.698498  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/123
    2021-11-17T19:23:50.708646  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-11-17T19:23:50.727523  [   19.553375] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
