Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 738F31AD40F
	for <lists+stable@lfdr.de>; Fri, 17 Apr 2020 03:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725855AbgDQBWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 21:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725800AbgDQBWc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Apr 2020 21:22:32 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DB38C061A0C
        for <stable@vger.kernel.org>; Thu, 16 Apr 2020 18:22:32 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id p8so300392pgi.5
        for <stable@vger.kernel.org>; Thu, 16 Apr 2020 18:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=x0h7NaUL6JXsRXpRa3uZPfN0hoQ/qWTXYGa9hx0cO+c=;
        b=jssjtJwY0PfjyFGLhJ85gH1/U+PLeHoBmq+Bkd60V/uqrKNSQXbfheIAUrNphLPoSm
         al/QhYXmsmHa8WlfWY13q0Gm2Ru+vy/OUIVOpJHYEOVL62kGIeRJrB7+zrtnof+hceAh
         xU159ucGA/Aox2x/JHm5N56z5xoGEoM769ucQinsAzTSJF7brrDqHSff+H8eL2pxipB4
         pRoTNMDTXpAILJQap2g0wQ21531ipA0KFF+umxPbuImLfWe2UUQ7Sd4VjjU+QxuNtiRi
         9cWjWT9RR3lFaoK+fG//8Daj+A/KMpwEWguTVUQTp+VKi/xgkVdH4atVvwqjdty5PJyw
         fFAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=x0h7NaUL6JXsRXpRa3uZPfN0hoQ/qWTXYGa9hx0cO+c=;
        b=BYBhoXi11backRSWtF+73KX7r8YKcd6MM2UakeywRUuhnTFZU+RKRH/3AxWLyIFiMn
         lWpeFu1dbmkz2FKbTbDnLoQs5JuzEFLIcMomsZ/6g4De+1g0E+g8gOon174PT8/foYlk
         vXbAJtqok6mvcA7IUI8f8fUNKkwnlUxxg4KR7lBNHgDU4USxeG84rl/HEuIYu9Z/Kwgk
         RHGwBwq9EREVlGYe+LNkQN+mA/7i3E9N0lw86cGzGWrECOrsbQJjK1lhYPDWc+EIFuL7
         pkd3x5uKU3nfUl8BGmrR+/UxU8AMl9o8UmgYfwkV4sisCnirz8YdhLD+ioOrAmYw5MkD
         V6SA==
X-Gm-Message-State: AGi0PuZVQ5QKqpYTv8OCaPTKOKU7dbjuoD6Zzhh3soJCXYrORww2JU3k
        Q38n88/kkLxhjX5VzxuGAARSq+127Q0=
X-Google-Smtp-Source: APiQypKmeTQ0GqaPuHhcx4Dy2eGyrAoND8WvqW1AgCZaa38XL0JO4Z+vcBmmVa9w2I1HWRMGzovnrw==
X-Received: by 2002:a63:6d4a:: with SMTP id i71mr543348pgc.445.1587086550965;
        Thu, 16 Apr 2020 18:22:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a185sm18134982pfa.27.2020.04.16.18.22.29
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 18:22:30 -0700 (PDT)
Message-ID: <5e9904d6.1c69fb81.bca4c.092e@mx.google.com>
Date:   Thu, 16 Apr 2020 18:22:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.175-146-g0ac67c89f03f
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 130 boots: 2 failed,
 121 passed with 2 offline, 5 untried/unknown (v4.14.175-146-g0ac67c89f03f)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 130 boots: 2 failed, 121 passed with 2 offline=
, 5 untried/unknown (v4.14.175-146-g0ac67c89f03f)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.175-146-g0ac67c89f03f/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.175-146-g0ac67c89f03f/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.175-146-g0ac67c89f03f
Git Commit: 0ac67c89f03f66d03da8ac889485c71c4c7c04af
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 74 unique boards, 20 SoC families, 17 builds out of 177

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 68 days (last pass: v4.14=
.169-92-gb4137330c582 - first fail: v4.14.170-62-gd6856e4a2c23)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.14.175-146-g4bea164=
d1f6e)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-p200: 1 failed lab
            meson-gxm-q200: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
