Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A89E1B3517
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 04:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbgDVCn6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 22:43:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725912AbgDVCn6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 22:43:58 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1149CC0610D6
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 19:43:58 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id t11so352698pgg.2
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 19:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+WJOqrZKs1Pb9xMgqIi6HMbTbUfC9D5ZMKmh7Zh65zI=;
        b=hX5/IWDXBDqC6bvFhnzgHXmPjporNmxlJQZ1WOxwlDsPxmnPGli75Wv32QG/lR5MhM
         r70316SdWI+LmZtHjC1lqtG7rZ9I6Z/J45CsWY8+MM2RVXS2TXhZb1guiEt5kZ8kuieA
         nXXuh+J2CKvhS2L/8ZuE7xXDJRachiNI7KixMir8nupcaqz2f+a3TF44dNz1sHw2VYZF
         b3bWnhoG+KWPNNoxs8jZAjNuxcCBzZlKxrPV6wUxfEpFL6MA87mzSqzIUo9ubrbiWsCY
         vrIXNlO+NE/LfvS2tPxBDOgb4QZN47LQ0SHUCFiVaFW6gnJMT1UR0kY1VjiPuO8KuEp6
         kz1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+WJOqrZKs1Pb9xMgqIi6HMbTbUfC9D5ZMKmh7Zh65zI=;
        b=A8/7f7zqoRAfskAkjjzklS2Cnd3y+wj+H/84O1ZWg980XwTq3rc/QAAggZnZsztqxW
         c2RyTKYtYENkdqHN/3Hajh2KQHd8+hX/2YR5FuzDLgtS3ouR5O3x11VKn1uY+t7tuRrP
         QudkVYb9jX/NmoH7Iz7/9tOCxQ5fjWx9gtdXqpMuiQ/jkzB8u76hoFRrR4NoLfx/bCC6
         ueVHNqIIgycSCZQ5zgFgZpAzln1x/dBo2il0yJmYoz0F/MYsbm14cnSYN2zBpT+uOIDf
         K4RI5YJySqXXaSwYIvD0nC4wOO9iiaN2LPUTHcEiJ6wanIqlVs75lwRHMHqYf4SFUQu6
         EKQw==
X-Gm-Message-State: AGi0PuaIb9VcMrFG9K8r+pe8pyN35kEbNZWxY6fD8VGbRCkSd9FjVm3V
        k6HvH+b85hKv6lhukvXiw5DVSozkdJk=
X-Google-Smtp-Source: APiQypL/TKPFZCYqQezj9Rklpi/gSKgztT+tB7sRKCDeAdqZwx7B5YA8siAP9Nt6LjhfjI1B6BEhMA==
X-Received: by 2002:a63:ca4f:: with SMTP id o15mr23529586pgi.122.1587523437116;
        Tue, 21 Apr 2020 19:43:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h197sm860910pfe.208.2020.04.21.19.43.56
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 19:43:56 -0700 (PDT)
Message-ID: <5e9faf6c.1c69fb81.ce89a.4200@mx.google.com>
Date:   Tue, 21 Apr 2020 19:43:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.219-101-g446e04a0359b
Subject: stable-rc/linux-4.9.y boot: 78 boots: 1 failed,
 72 passed with 2 offline, 3 untried/unknown (v4.9.219-101-g446e04a0359b)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 78 boots: 1 failed, 72 passed with 2 offline, 3=
 untried/unknown (v4.9.219-101-g446e04a0359b)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.219-101-g446e04a0359b/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.219-101-g446e04a0359b/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.219-101-g446e04a0359b
Git Commit: 446e04a0359b5084ed944e43dcf6a06c7b9356ab
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 49 unique boards, 17 SoC families, 18 builds out of 197

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 73 days (last pass: v4.9.=
213 - first fail: v4.9.213-37-g860ec95da9ad)

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab

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
