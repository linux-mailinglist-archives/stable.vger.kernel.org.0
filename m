Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D30B449E6A7
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 16:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243224AbiA0PvJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 10:51:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242857AbiA0PvI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 10:51:08 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04372C061714
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 07:51:08 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id d7so2799860plr.12
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 07:51:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=F+5bt6Hpom0lq5RJeFGvqm968upqf+gUuWdhjwtTbuE=;
        b=10g7HrLj0lk/ueyHubofETAJKIRPkXWTfdLCJy/SE9WZ0gtrGVmLi8Qx7g6ob7MChl
         R6UK23GkUxgn9SyHKE5N9FW9QFwEniidgdZcgv2TnN3hshlm2UuBeUuURfvoON3j2FC0
         2k4d2QDXPJKflec1ndUkRBz8V/39XX2USH+P/E02d5AWAGVUS2xPRNQYBIULHef3fXx0
         1OQYaUpDEIYn03NMlH++vyCXA2HUBgBJZ6QYsKi5Y2swfmXHwNt8onRmlVF9VmEDpEHw
         wpTmRJM3jg462luuk2UiIlaZrfAGfv4/KmjVba9jAHgKA8YpGaJzmkBxAWFlcwqTiGbf
         d+JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=F+5bt6Hpom0lq5RJeFGvqm968upqf+gUuWdhjwtTbuE=;
        b=HeXXGt6VXBOBHREyEEBJEeKeO9CDOoBCjePlXCCzl9ywDMGuEADRbPI2UrVn0zNIT0
         dTIi2HoICpC+G3QZGu05WdCfaNguJjmRhLh6PGzrr+y99JP2CR0ZXVlSy5N281jwd0OZ
         hxu0KO0iCoZhUIPbtE2C55RsEkDzM3tBUuPaTHPv2+p2rSML4XKGkOZg2qrWEST4vGjY
         whsTP7ZkGoNmAS+7ZBQsdt8wZFLZofWc3I5rKPr/nb4yS9mOLpLJKtPau22aAW1b0ehd
         E4Mav7k4x6Ihs6FzE0mbl0K+Qyh9ks/Gsu8ttQMY1LBUZ6vXPPWyUd/icqKbHZRw8apW
         KJ/A==
X-Gm-Message-State: AOAM531cJJ71wp+W9McNq1wciQHfWnflJ95aI7vx4Z15U7GaA1oO8wa6
        1c65qjrUgyhkBHeU7B8gEadNOV7cpogEKjzH2uM=
X-Google-Smtp-Source: ABdhPJy/pW+bTL+vF4YuiMjB6jBcxOCrnHFvELjiTeAku1jDyIWtMGKjYHWeALkq0iYHyZl/+yab4A==
X-Received: by 2002:a17:902:cec4:: with SMTP id d4mr3797639plg.56.1643298667207;
        Thu, 27 Jan 2022 07:51:07 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id lr7sm3956288pjb.42.2022.01.27.07.51.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 07:51:06 -0800 (PST)
Message-ID: <61f2bf6a.1c69fb81.88575.9397@mx.google.com>
Date:   Thu, 27 Jan 2022 07:51:06 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.16.2-1032-g26156ffc8fad7
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.16
Subject: stable-rc/queue/5.16 baseline: 189 runs,
 1 regressions (v5.16.2-1032-g26156ffc8fad7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.16 baseline: 189 runs, 1 regressions (v5.16.2-1032-g26156=
ffc8fad7)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.16/ker=
nel/v5.16.2-1032-g26156ffc8fad7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.16
  Describe: v5.16.2-1032-g26156ffc8fad7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      26156ffc8fad757fd8d2c866ba8039212df9f11e =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/61f28c394b3800d43babbd1b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.2-1=
032-g26156ffc8fad7/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3=
288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.2-1=
032-g26156ffc8fad7/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3=
288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f28c394b3800d43babb=
d1c
        new failure (last pass: v5.16.2-1033-ge4f2c5155f37) =

 =20
