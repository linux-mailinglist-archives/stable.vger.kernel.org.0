Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47D664A5709
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 06:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233494AbiBAFoT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 00:44:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbiBAFoR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 00:44:17 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C33C061714
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 21:44:16 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id d5so16075119pjk.5
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 21:44:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9vRHxgPB6ujNN/nRMzv5ntHYa4tF/BpPTxwUeVPpHrs=;
        b=E8nAahLTObfeLcR3u4R30/r7u/IK7l8ZeSJ0ixPv/63cxg0WJD5SCKlp9BUKBwBc68
         9e1DeMyUAyUgZWCwoZfcWcDPLD8SYHqAa8KHKH1S+9uCX+WM8xhd1A08dRWfiDsqtg9V
         +NvFCz2M5R2ISWBu4TFoR38V3LB6TWi7C2RCQo4N3+gk/dLrTpf4DaxwbKKoS5VOLYou
         mjVtp/qnC0m12vQZjeravCDdMwD6SIjW11U6iJlSNzV4JuyU5p1Pkx0u3JT0Uf9+uz4K
         NBCGHVRHt5mhBd6g6mVun0V8FOIivSP+002nV883olXuWCxdpwWfLfZ0CKx6m7Me88I8
         iyVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9vRHxgPB6ujNN/nRMzv5ntHYa4tF/BpPTxwUeVPpHrs=;
        b=lcDryLMNPR/ahIqGzoQ7pCsZJgttn+ElEB0crf5psBPEM0q9hBaXs845FrijsktZsy
         Sn+JJgojtrhrMVoO6dvfCIKCj2KIr13bXKnkiqsTvuH/JR3qapgETyl7R3Mb5NspxkN8
         wjcMG/SVlO6CqdSxPKBWIkOhMUwrDggIbmVSTAAy/K4fmCydwoiCpzxtDUKY30rjnANH
         Azl4JIGJXaHEeEMc+YglrNnt1G+m21e7KuQqxjMLMY55K6RUZIn76YUqu96L/u013gay
         5KD3DywSmQGTgRC0d53P8FTa7n6pj62sp+wErT/mNKFp/c9jEyOsZo5QPFqUt7KyToyn
         Kljg==
X-Gm-Message-State: AOAM530pJVyzKm+7LiQN/WpLmdFsIMK7kzEmtKoAb77aIx1Ye5T88EWw
        SkuoF6byoHPSFfRIug2zOtGY2R3FtEo9v0XF
X-Google-Smtp-Source: ABdhPJzzb4OhUDTySyOs/NDXSE2UkDvjXVg3KAC7M/4nvj6e6FHMZlbI4h4aHzzaSFH/sH19ItBw7g==
X-Received: by 2002:a17:902:9b96:: with SMTP id y22mr20253503plp.100.1643694256356;
        Mon, 31 Jan 2022 21:44:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 197sm19465976pfz.152.2022.01.31.21.44.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 21:44:16 -0800 (PST)
Message-ID: <61f8c8b0.1c69fb81.44f39.4d02@mx.google.com>
Date:   Mon, 31 Jan 2022 21:44:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.301-23-gbbcda064239a
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 117 runs,
 1 regressions (v4.4.301-23-gbbcda064239a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 117 runs, 1 regressions (v4.4.301-23-gbbcda=
064239a)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.301-23-gbbcda064239a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.301-23-gbbcda064239a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bbcda064239a5c2af69b5b1f5c18658875c64128 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61f88ed597d5a7b9cb5d6f1f

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.301=
-23-gbbcda064239a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.301=
-23-gbbcda064239a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f88ed597d5a7b=
9cb5d6f25
        failing since 0 day (last pass: v4.4.301, first fail: v4.4.301-23-g=
9b80ba4cf655)
        2 lines

    2022-02-01T01:37:04.462671  [   19.218505] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-02-01T01:37:04.513406  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/118
    2022-02-01T01:37:04.522504  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
