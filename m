Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE9DA1F6051
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 05:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgFKDJW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 23:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726279AbgFKDJW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 23:09:22 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8440C08C5C1
        for <stable@vger.kernel.org>; Wed, 10 Jun 2020 20:09:20 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id m1so1919542pgk.1
        for <stable@vger.kernel.org>; Wed, 10 Jun 2020 20:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ks0Nsck2a17XnXO2T2QLyi2eroQQBvRtxDLHMSf3oZ4=;
        b=LPuvIvgVQCkKSpM+GtyDRBUwpogeSw/ZAmegFvNd28BtqT+Wl1gWrnJM6ntR3tELwB
         7XP5+uEgS+oZlZLDW5LWaJlsh39NxpW+0yq4GTZ7TKIStV/4xUl0F1/FRnph1xLxiT6y
         QKozZmMwDsmp1EsSa2tu5Wx4/HEKaiEIf2/+oXAxFv9yZEfUMSVYc269Txl5Bv8jRaCA
         V01VbXR6JNzs5QSSi+QXeVEkUq0NXHzbwdD+kWlMLi9Ab3l3N75GQjJOFb5N3UIDigvV
         kM1Cr8EfcGzCn/8MN6BSUMjQziMCIo6e3uHp13a9RFWsxDSnnyGy+mHrRaxXf/sys1xT
         Ztzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ks0Nsck2a17XnXO2T2QLyi2eroQQBvRtxDLHMSf3oZ4=;
        b=sCrOCYe9LDgjTwNb4bTO3BqQVYaVXcxESoPO6nJBHRCO1+D2dquyU7+2IWzNvh7uMB
         DDViXlLoTBQAVK/8cs3OQG6Rftn1JChgSYiH7w7KtPhcvNdhQuGtmqSTLxb1BFFYBS9z
         ENWU6TCjVjV+RnrpS7oiEZOFzzVGNFCuWjZqeilMn1zYwVUsH3I0+4mWrwRjMWMnkhge
         tii7N03t8h+nrmk8vIKtTt6j3hu4kVE11Jo94mbvBvCprZ7PAvuzHCUzJqIFgaJgqG1X
         mlrblfGMNT0EhsJnjyV9qmn6KurMUc7ZitexdEEbB1bFhkW9uuGGl6zVgsbq16oBPjSH
         BHcw==
X-Gm-Message-State: AOAM5338iFmRKeSgKm/kjK4JW4cIjN23GqtI8gBnw9ncuuq/Zem171d4
        Ax6Zoiq5sQnQc3p666a7+weW7f3jQ2I=
X-Google-Smtp-Source: ABdhPJxUqFUiT932lgzTE3EgQ3XCGZz35XSqReIQ6PeyN4JYiLmJGpLmU5sGPf7ltwhTEorR+26GUg==
X-Received: by 2002:a63:214e:: with SMTP id s14mr5057741pgm.20.1591844960038;
        Wed, 10 Jun 2020 20:09:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i12sm1305289pfk.180.2020.06.10.20.09.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2020 20:09:19 -0700 (PDT)
Message-ID: <5ee1a05f.1c69fb81.a9c78.5513@mx.google.com>
Date:   Wed, 10 Jun 2020 20:09:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.4.46
Subject: stable/linux-5.4.y baseline: 111 runs, 1 regressions (v5.4.46)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 111 runs, 1 regressions (v5.4.46)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 4/5    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.46/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.46
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      5e3c511539228fa03c8d00d61b5b5f32333ed0b0 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 4/5    =


  Details:     https://kernelci.org/test/plan/id/5ee16a72f5dc2dc28b97bf23

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.46/arm=
64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.46/arm=
64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5ee16a72f5dc2dc2=
8b97bf26
      new failure (last pass: v5.4.45)
      1 lines =20
