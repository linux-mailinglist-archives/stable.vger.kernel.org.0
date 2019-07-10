Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9956264EA6
	for <lists+stable@lfdr.de>; Thu, 11 Jul 2019 00:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbfGJWRR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jul 2019 18:17:17 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35053 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbfGJWRR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jul 2019 18:17:17 -0400
Received: by mail-wm1-f68.google.com with SMTP id l2so3779396wmg.0
        for <stable@vger.kernel.org>; Wed, 10 Jul 2019 15:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eBgHG655wHMUVuVlExTb5sXYTnP/xgrm/pgwZVxsDzw=;
        b=OQgcKYQWQV59n1hfe+FY96nxNjBSxU9xlAqihp67dqBUObS6t6x8lNEUfOaDLBv4dj
         o+YL9QecWQqrzpznLHX/9hd9WuALHrErKowEVDQlSKpSMfglzu1D/NXDvDRhGk2705NB
         EemkyDAYuiTeQ0C1cQjk6F3JDMFOZxuZbu15rAHHaQeovbeHzoG5ja8v5wHr0aunDVB9
         9Zy/tdqOHW08dJqpVHiCMYNSpDKeeowmH6XRLxGTEkQUIdCdpnAjqbtcRlbe/MHEOhhG
         JGmb78pEo95ijmx5AYEf7l82E6nv/GVoa3F+KqnEzUBbSaF2KejVWI0QOouGzSMWhchJ
         pJiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eBgHG655wHMUVuVlExTb5sXYTnP/xgrm/pgwZVxsDzw=;
        b=L7JUPCPCdDcDqin9qe6WrJWkzD38KN5sPlbmUXKzV+6l3cHImVyYyEdVT9mKZWwVi2
         8Pb2P3B7KD2JHgca7Dq4/kRhwiXNkqSSw0mmEn56V2g782U+hfbYP4ZY8BdOpgGXEUhE
         Rt8LrJ1Mp079Oh+42Y+TYW7ZB/QVo0P5VAq+ofXR0cf2CHE55MeUkGM0izTE/Bn/IfRm
         6QvjAQk2d9rKUwkNy6mrTskP+ziWUFoxnmZpkPif2+cV/feT1+eKHSFeM1nqRZwHo241
         g27fG1h+jtYMh8FHpbA1xN2dUnchXbkqjM++BvZ6kGCLzbLavs26q/03NF+s+xlTkVT4
         Y6pw==
X-Gm-Message-State: APjAAAUFxBoJ68Bg8J0IG3jhm9CBrc+yrBwfPz7bwnkuAvimaIZMbdG+
        gCAmybL+KpVjtsBfax5wKnl3QGuImQo=
X-Google-Smtp-Source: APXvYqx8Z5QzdDEXGnmwJCd64AZ/7yCtQ/8xMezgcghDSz+8UJnrHN0YyiUpZd1TQGq5ardxxNMylQ==
X-Received: by 2002:a7b:cd94:: with SMTP id y20mr100362wmj.94.1562797035091;
        Wed, 10 Jul 2019 15:17:15 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 4sm4504986wro.78.2019.07.10.15.17.14
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Jul 2019 15:17:14 -0700 (PDT)
Message-ID: <5d2663ea.1c69fb81.69154.b2d1@mx.google.com>
Date:   Wed, 10 Jul 2019 15:17:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.185
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y boot: 100 boots: 4 failed, 96 passed (v4.4.185)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 100 boots: 4 failed, 96 passed (v4.4.185)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.185/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.185/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.185
Git Commit: 7bbf48947605d6ccef21a896c4b44dc356dc8726
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 46 unique boards, 20 SoC families, 14 builds out of 190

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab
            sun7i-a20-bananapi: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

---
For more info write to <info@kernelci.org>
