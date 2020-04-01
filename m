Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC7719B5AA
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 20:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbgDAShv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 14:37:51 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42884 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726640AbgDAShu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Apr 2020 14:37:50 -0400
Received: by mail-pf1-f193.google.com with SMTP id 22so409531pfa.9
        for <stable@vger.kernel.org>; Wed, 01 Apr 2020 11:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JhCszWMtmGci04makPXCKJdFwOsktu8ArphKtkLIj9Q=;
        b=tT1NsKtNL7c+86Nsii5dn76+kXopfDH84BeiOk8tMv2hZd4kdV/tFumB9tiep903gd
         TxrFYWoOy/9wBMUCKX0OUr+d72LynbaWHnH5Sb26cWoL5ZzTnI53h2/8PAtNM9PNohO/
         nwK9rvqNNYMaYhtzGeg1ywl446QQLpkrqZZFFiSvtbqe/vUINuuqvtnpc49dXnA6nud6
         oy+i8JymkSD6B8+M36gEgP330I9mPXcFU8FUoeFS7w4a8fcZw3wJGVFliQhqASSa9xJE
         e/G+3HYYbvkmuL0caNik3SeEu0sipNHe687SlNtbyYixdaY++uoRXBlKmVE9ibRkSAeY
         8W3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JhCszWMtmGci04makPXCKJdFwOsktu8ArphKtkLIj9Q=;
        b=fCsCcNBKxvXTmfhlGv0ieR30EPzPLzYO1CvMVwjGqWmveVYKqpwzGKti8zG+uw01sS
         kQKhACU77z5xyg/nuOhfgtQWzfloqw71Yeyh7EmZJXydqvEozqwsar91MdoX/OCrJP+9
         6Xewg688geFrxVfMNgDWsmTNTdna+Pr6Wo+OEX6smCV821wKPte1dXXjvkxZUSnHNlRB
         ko8IjcsAUQIDaWmRifksNFUgP+t0yPlx9jWWpV8cjjvP8GE5OY8frPQ/lOKAvD1bgoZl
         R4U9zgDkFxUbA3I8tetBsPX8TcGKDKhJ5zEBUqiKKvajwjb2eE5yCSItAC9Z9WO88OIw
         3pVQ==
X-Gm-Message-State: AGi0PuaCXJjFKx7n/WWFqQpLYIb1Owa85J3KNH6WDwXSRCDqkQyMiLCz
        fz0N9n9L6Ij3IFjvhqHGFjiMgAj5Xk0=
X-Google-Smtp-Source: APiQypIRM+/+X4WzmzVoaTVkkmP0iNLjAwkyheI3oEoReq30E6vGJhvoaP5Ql/wvLv13tzCXPU4l8Q==
X-Received: by 2002:a63:4c5e:: with SMTP id m30mr16370439pgl.316.1585766267044;
        Wed, 01 Apr 2020 11:37:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a13sm1911332pgi.77.2020.04.01.11.37.44
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2020 11:37:46 -0700 (PDT)
Message-ID: <5e84df7a.1c69fb81.92e53.8892@mx.google.com>
Date:   Wed, 01 Apr 2020 11:37:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.217
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 98 boots: 3 failed,
 88 passed with 2 offline, 5 untried/unknown (v4.4.217)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 98 boots: 3 failed, 88 passed with 2 offline, 5=
 untried/unknown (v4.4.217)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.217/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.217/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.217
Git Commit: 3b41c631678a15390920ffc1e72470e83db73ac8
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 50 unique boards, 18 SoC families, 17 builds out of 190

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: new failure (last pass: v4.4.217)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 46 days (last pass: v4.4.=
212-56-g758a39807529 - first fail: v4.4.213-28-ga3b43e6eae91)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: new failure (last pass: v4.4.216-127-g955137020=
949)

Boot Failures Detected:

arm:
    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

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
