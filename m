Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46AA3361442
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 23:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236149AbhDOVkd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 17:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235046AbhDOVkc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 17:40:32 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 349D5C061574
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 14:40:08 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id u11so9157782pjr.0
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 14:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pUmy6VV68sAHPsxISrxeZ03sE8AspKvFRskHo0BU2BA=;
        b=s1QBFknEn0HDBKlTBSNyFaNLeytTuc0ktegOwv2RX8ukcP9YWzd+mSOjBDJG1nEHGR
         6f6sDc5UButBOG0Ke9gzoJ2MvsnBOvwy1ZVtKlLpsvqcs3+xbZAuMqlnrrNh1h5ZVzLx
         5oBuKmbttljeVhHW8sCN3IWEHjkpQFjoGP+EIvmxvdsPGFX5aAeJc0MnVAQw/bZ133Pj
         e7LD35Rj+kYph6MHo6zfhMQztJkvxssL8nQQtnlJSjxOJOTWDgpKVc9Dck5f0ubL32b6
         uy+j61qbm55bJf4hQTrPETGcEvoSc9oyJU4Z8hWuRIqIiFHtQWZ8+DedeALM8C6fyvqo
         ylrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pUmy6VV68sAHPsxISrxeZ03sE8AspKvFRskHo0BU2BA=;
        b=pUalWgan+m3qR9YuY9eVUl4jfywV+R43+r3ks4XAMQ4cuBxZrWzUdE1ol2dugl5KRe
         O0OFOhPyabH26v6MESw3P4SDrTRtYCtwF1hWd1ZhTzzXyLSybCQ6ovqawFkKPxRWAl5o
         SycORkWKUQedZoS0wNWGUPrZxiAcqLY5xsAb+VmfJLl8XlAyPH9Yhmy49ELq5SLSMSfy
         5ULOsvtcgBlP69fJ1niUA1PHM0cZkHtL/BSldmuoaG9Q04BVITWCtGHQQxYPUSadE/Mm
         nLUPiHWcwe+8M8dg1m3zGmwJqvR3w/aCbM9dw6roRnNj6w5m0ibZ01v8VH02P6c4GgCe
         IitQ==
X-Gm-Message-State: AOAM533XkF3t3Pu3gzwIFkW+GXvG4WfQFdwylb+ZRbKATLKPEHccvA0g
        83bmR4de05dqUeqiaSPAocKMvrFw6jaomS2C
X-Google-Smtp-Source: ABdhPJyIJtrCxeBt6tPI8HlMUJoTADXsYknZm0J50jsOFDsmR4anexs848Cods25UEt1QRToMQXIGQ==
X-Received: by 2002:a17:902:dacd:b029:e5:cf71:3901 with SMTP id q13-20020a170902dacdb02900e5cf713901mr5765552plx.23.1618522807514;
        Thu, 15 Apr 2021 14:40:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 18sm3021470pgn.82.2021.04.15.14.40.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 14:40:07 -0700 (PDT)
Message-ID: <6078b2b7.1c69fb81.e2a17.9a63@mx.google.com>
Date:   Thu, 15 Apr 2021 14:40:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.266-47-g1ee3749fc544
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 99 runs,
 1 regressions (v4.9.266-47-g1ee3749fc544)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 99 runs, 1 regressions (v4.9.266-47-g1ee3749f=
c544)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.266-47-g1ee3749fc544/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.266-47-g1ee3749fc544
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1ee3749fc544599398c0ab858e487c91a57b9057 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/60787ba38350215535dac6bc

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-4=
7-g1ee3749fc544/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-4=
7-g1ee3749fc544/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60787ba38350215=
535dac6c1
        failing since 0 day (last pass: v4.9.266-44-g7c3ef782e2f1f, first f=
ail: v4.9.266-44-gd938d15b3cf13)
        2 lines

    2021-04-15 17:45:03.921000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: dead4[   20.297302] smsc95xx 3-1.1:1.0 eth0: regi=
ster 'smsc95xx' at usb-4a064c00.ehci-1.1, smsc95xx USB 2.0 Ethernet, 32:ed:=
90:79:74:47
    2021-04-15 17:45:03.925000+00:00  ead, .owner: <none>/-1, .owner_cpu: -1
    2021-04-15 17:45:03.931000+00:00  [   20.314544] usbcore: registered ne=
w interface driver smsc95xx   =

 =20
