Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D86B729EFDE
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 16:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728230AbgJ2P27 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 11:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727941AbgJ2P27 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 11:28:59 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE27FC0613D5
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 08:28:58 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id f21so1459753plr.5
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 08:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=z45/meuYgcB8whMYLLhVXnPKnL+KnoijTnhwotrKn/U=;
        b=n17bzJe0zR0UFwb9Fp3xkQlnWG5uH1V0ML5Cl4ZlXvWUz8LTEnffZ172n6gFM3t8s3
         uCU7Z12Wbbe+UXr3PXNZy+LXzozJJ89X/1ywxck9hHBlUjshG/qR/7dnRJ/WVv+6qGdk
         RYPHt5Poxj7F4Pa1rm4P9IfBVdnog9r+nh6ecTpNd/4/5DPUFkGGui5zwieVlxZ4/zoY
         M+ru3xFS0VeZCeBRWo3+d0UwA/laNNsJV8llAAOMMDw3hKk0p2tSbdcMKnXvig9HqRzs
         aHTVltSNEuX4/cAOclIUJGDP8h40IyN8Nk8YWGVxHlN0N8MsaCg5+J7HbL/rKzXaOENL
         cGBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=z45/meuYgcB8whMYLLhVXnPKnL+KnoijTnhwotrKn/U=;
        b=NfI/s8SdArZlSNN7+Nxs/xw1O/lvbzfq083uhrUEU3oklHI9zon9RjVdcwpji4md4V
         VWqSS09VNEnMQBIYXZbxngEDXJ64DGpZXxtvAG7sUs8oU42vEGO1QwoxT60vuV9tu3Xb
         HSEgJxvwFnDDNOd/jYoaSh2HjmeJEl4VseNDBtK7e2d++68G7x204Zfthu5nFQf0GPst
         clasK7t0Ifrd5HuK/7eSkwozZ9h1ZaM+MMe9Kol1MjIGPfSvM37bB0Y18Eu5k0afT6ZQ
         MRNJy8HqVo87oSGgJhYMlD81B9IJux07cT+IWum5jiMmYAMngl/FmXFQDv380KsiyytL
         59fQ==
X-Gm-Message-State: AOAM533buRMuRFP+haPygTXpyGLUmycDV6/IX5o//1TsbDgF2Pbp3WB+
        /CRzwlvLv0tmpCes82ErztI5y1aKUppM6Q==
X-Google-Smtp-Source: ABdhPJyjsL4dy8vBXe7oSgIocsY0dFhLtHcYtQmoCvkuVZzt0+2WeBkrHXO21B9C1oONZRTAtDoWAg==
X-Received: by 2002:a17:902:b28c:b029:d6:528b:ea5d with SMTP id u12-20020a170902b28cb02900d6528bea5dmr4810874plr.54.1603985338206;
        Thu, 29 Oct 2020 08:28:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ng7sm185622pjb.14.2020.10.29.08.28.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 08:28:57 -0700 (PDT)
Message-ID: <5f9adfb9.1c69fb81.10c0a.0598@mx.google.com>
Date:   Thu, 29 Oct 2020 08:28:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.153
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y baseline: 182 runs, 1 regressions (v4.19.153)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 182 runs, 1 regressions (v4.19.153)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.153/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.153
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      79524e8c64bda80bb35ab490177d0e6813bf112c =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5f9aaedf88a9b4d88238102a

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.153/=
arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.153/=
arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9aaedf88a9b4d=
882381031
        failing since 14 days (last pass: v4.19.150, first fail: v4.19.151)
        2 lines =

 =20
