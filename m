Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 913F51C79A1
	for <lists+stable@lfdr.de>; Wed,  6 May 2020 20:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730482AbgEFSpi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 May 2020 14:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729895AbgEFSpi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 May 2020 14:45:38 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49844C061A0F
        for <stable@vger.kernel.org>; Wed,  6 May 2020 11:45:38 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 145so1437593pfw.13
        for <stable@vger.kernel.org>; Wed, 06 May 2020 11:45:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5h+U4uNEilakzI5vKqYzl+wlVU9JwYpKPgcDOXEsn1I=;
        b=TiyEad9MW06XBBpaHAbvQ634W8ug+B/CsCb67UZ6kbgPey1/YiaoXG2ipmnx8nu7YO
         nQXKjV2WdNTXHExLulA1qzaP36rKqpq9TLsZaBLVoFum3CLk75yow89of6JxEhLH9rRf
         XU8758E9ElgZ0zDDvI291ZNj1QlPyyEvKfp0Z+V6Ku2i7Utm5Dda+ynNf+H25AUZ8tCN
         VOcLYfcYcpJpnLeBDETmrhR1Qcy7Y6IE6/mWD8pu8BLsrRmu8iyUujS4DeEogDFeSX95
         QF+s5HN+SFKRNVrmp6lXtnJ/LXKfSNOhl2yf7BMds0x4iVZKmidXGMTT1YdR9l/cYJe2
         SHpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5h+U4uNEilakzI5vKqYzl+wlVU9JwYpKPgcDOXEsn1I=;
        b=Toprre6Fr84CW2F3sSL2B9XOVdmqPT93NCS3EDsewo6e86RgXQWK5y+bAEQapvNC+P
         y6A1Ov2BKwXs9haDIij7W7cxyibZw2Q32nRxbAAuplKDn9ymeJIri5P6feSmsd4QvP4H
         7DrInzAd9HTgAqPpVHVI1ln8CKiZ49W9yocXixLmpU9AB3+ufBlsoRYeoTYr6LGO5bJ/
         Sfddc1c0QGWXyLfPjRZJNnaGmEZV1+AmuKYVmH2ZVAhJAu/EUzWIQ30n71mEU4Kpz/lj
         IwV5PDd1e00XchY87vMJKBn8r3DUWD7B8dRyI7jmdDBDQ7D5Ovnhs3Cd20jE989vj+cv
         eC7g==
X-Gm-Message-State: AGi0PuYmLS74FA0IMgmHgL831pjYIT59zvkWMzGp4diToRvF26vk4vpQ
        JoLBg5fa1FXRyKK63gF3CLXHzRG5sjeT3A==
X-Google-Smtp-Source: APiQypJGBISThy7OaWqDL6WOYcqwI/1q2UcxAkHuPqnZzV1qdZrEqSjnyr4UBSdI8XTR/Cr3/Mgu6g==
X-Received: by 2002:a63:de0c:: with SMTP id f12mr8213844pgg.172.1588790737495;
        Wed, 06 May 2020 11:45:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e21sm2192236pga.84.2020.05.06.11.45.36
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 11:45:36 -0700 (PDT)
Message-ID: <5eb305d0.1c69fb81.4d324.72fb@mx.google.com>
Date:   Wed, 06 May 2020 11:45:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.222
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.9.y boot: 115 boots: 1 failed,
 104 passed with 5 offline, 5 untried/unknown (v4.9.222)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 115 boots: 1 failed, 104 passed with 5 offline,=
 5 untried/unknown (v4.9.222)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.222/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.222/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.222
Git Commit: ffd00fbcb56063b86629a83b426d2ae3f701b171
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 61 unique boards, 20 SoC families, 19 builds out of 197

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 88 days (last pass: v4.9.=
213 - first fail: v4.9.213-37-g860ec95da9ad)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
