Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6FB1AF836
	for <lists+stable@lfdr.de>; Sun, 19 Apr 2020 09:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725903AbgDSHaB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Apr 2020 03:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725446AbgDSHaA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Apr 2020 03:30:00 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB76C061A0C
        for <stable@vger.kernel.org>; Sun, 19 Apr 2020 00:30:00 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id v2so2726212plp.9
        for <stable@vger.kernel.org>; Sun, 19 Apr 2020 00:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XNH9uUVigAQ0PdUABAnc3aaFBCNeoPAiKMef4fjHVxQ=;
        b=cSAVEIdDBi4KnI1ffTNd0/PKfUtPOxT77IxGfztNJI0/+ObgYZ4GjA7q12NfyoGrkW
         KjRzT4gbHo4npoa2KljVXuO02PLTIeoZbnlStB4eLdjz8JehdRiFXhOnufe4UaBoR15j
         TWqmP06BmMlBEJLiST7Br8VpukRM7f7RbFGFsX6+QMjLku3xDg/8RxfxILKnEvDCRgPx
         OMYMXX1obrjkIUxgxWwpYJhhxqHcnrI1kUcM9vngMX7HrpXwfT0J2D0oOY/zNx35C9hd
         5Gh3crvX/LhN1YJMdJMfLYIuQjlTC0T98rfRHuXQJjfLIGqXcRYVhmOMZbHKuW2oStCk
         gIuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XNH9uUVigAQ0PdUABAnc3aaFBCNeoPAiKMef4fjHVxQ=;
        b=W5Dqrc1/lSnTlBbcnbIYqzfNmykAZNrPzl+ng0ZsafbHJQPO701jnoZBgd0xygmo2l
         mVWQKtqSUnq2iq8hV9XW3OegPo5nBsDjgNmbX7efNXGCXrOqQsgTuSWMT4yz9JG+JFEW
         wxM+k5JMHsnZdNun/TeAcSNiXAqcPeLjuyrXJFLapc2GOvjfSQBPYFN++dH8J+OEvGAS
         lmyg3DpCqKw3jUgAhrVQJiqsNcLWr9tmC7o6eBTTSVibtCM6fjXOsC381Xol2OLjC23l
         qNGXpyvn4Xhrrydj0ELA2eP/onUve1QYfSU9LbmWh6ckwVRBGo7Yxld9VwMGYkqDV+r5
         5Biw==
X-Gm-Message-State: AGi0PuacvaEP3U1ybmRGiAFxiDhPjMLEcg8dBim51nbUoK9kUmVs1yMW
        wOimqIA23VlBvUfQVQii+ebPGLZfS/g=
X-Google-Smtp-Source: APiQypIgP1ieWTBTDOjBN4Wj7ViwIedI+4Y9aiKkY3kNA9g0+AU6cHDQOUIiPMcyLaecbUXOdD1PjQ==
X-Received: by 2002:a17:90b:1a87:: with SMTP id ng7mr6787712pjb.84.1587281399639;
        Sun, 19 Apr 2020 00:29:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c3sm23885090pfa.160.2020.04.19.00.29.58
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Apr 2020 00:29:59 -0700 (PDT)
Message-ID: <5e9bfdf7.1c69fb81.43792.5cda@mx.google.com>
Date:   Sun, 19 Apr 2020 00:29:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.176-124-g10e2890241f3
Subject: stable-rc/linux-4.14.y boot: 131 boots: 3 failed,
 120 passed with 3 offline, 5 untried/unknown (v4.14.176-124-g10e2890241f3)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 131 boots: 3 failed, 120 passed with 3 offline=
, 5 untried/unknown (v4.14.176-124-g10e2890241f3)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.176-124-g10e2890241f3/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.176-124-g10e2890241f3/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.176-124-g10e2890241f3
Git Commit: 10e2890241f3e0a85ad154700a5406acff9d9ade
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 74 unique boards, 20 SoC families, 18 builds out of 201

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 70 days (last pass: v4.14=
.169-92-gb4137330c582 - first fail: v4.14.170-62-gd6856e4a2c23)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 59 days (last pass: v4.14.170-141=
-g00a0113414f7 - first fail: v4.14.171-29-g9cfe30e85240)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

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
            stih410-b2120: 1 offline lab

---
For more info write to <info@kernelci.org>
