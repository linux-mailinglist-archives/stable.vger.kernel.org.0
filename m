Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8840E60BD3
	for <lists+stable@lfdr.de>; Fri,  5 Jul 2019 21:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbfGETkQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jul 2019 15:40:16 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50440 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbfGETkP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jul 2019 15:40:15 -0400
Received: by mail-wm1-f66.google.com with SMTP id n9so10231286wmi.0
        for <stable@vger.kernel.org>; Fri, 05 Jul 2019 12:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=urstHGL1VEf4ji6T5eXxLuEcSoEkh/vsgej5s45q7uk=;
        b=gvM1A++0ghpk4fHP2x+7/4r2odylOEfObRxDk+kjaNwZxuInyLnR5KLM3dGWff+sOd
         OAc23e7+CIJzsJQN8SJhPJg6k+tXC+0N/FIFMfYhANTgi5swI31LShu75MDozNaCXGFi
         ajKUfw6nYeb8F8it4YkRpT8h4wfkPBJHdnNyzwsMugaMv9o5bF+njH1BYq6WmQhd9Gsy
         na4/gQ2f/AyUOgrHcNDyiNbZcNQ8XpZQn5BHo0o1Zg9DQ9v/kCU5VdKOl3OdXPOwT0Y4
         AZ2zTvSjLnxxfRMm+GEeUeEp2RtRImSOEompRqiDqWBWjSVpFbjPB9tohawwSGzsTxlt
         nikg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=urstHGL1VEf4ji6T5eXxLuEcSoEkh/vsgej5s45q7uk=;
        b=kGa8DoHCeA/W0/1RduqL083HgS0i45T+Ka1fsGg4sRmPe1KI3hT1ebHwh+A9MCG8Dz
         1TtxvmUji269cqiCIZ99GX00vyruZpa4Qn+f+PAPJptDNmikDy1o11VlG4GvaL4B/2aQ
         rZK37yydOV57SNml7uZtyEKwWJPTZ23BVyW+Xbjq3YX4ALE42bx/6CJaRa64fSdkBzwy
         t60kSfVZe6GXDonZub004/N/k0/UIYAxhcdektIn8UgVen7+98aQHJhuudkdHAVpD5U2
         ebdNWtn3gEZght4XIh2WIUJE5JoHHAmkjUoLKzMWdhSSOljS8YU6RothGnTOBT5Zc2TA
         mwTw==
X-Gm-Message-State: APjAAAX0Q+8szrF/L+P1ltkI908QXhzrR+xVX+PBc+NHGZfYjBouVtPf
        InBE7pr8I9hTu44wEe8DsTKO+mD7etoqwg==
X-Google-Smtp-Source: APXvYqwW0OLccOcbbuKwa0vAqKow9Pdq5Cjz9z+cUqN6VNxIuVkVZ2uJIH/nVBPXptUzGwc3uCGlZw==
X-Received: by 2002:a1c:3883:: with SMTP id f125mr4306565wma.18.1562355613495;
        Fri, 05 Jul 2019 12:40:13 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a8sm2849599wma.31.2019.07.05.12.40.12
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 12:40:13 -0700 (PDT)
Message-ID: <5d1fa79d.1c69fb81.f80e1.03b7@mx.google.com>
Date:   Fri, 05 Jul 2019 12:40:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.184-93-gaf13e6db0db4
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 110 boots: 2 failed,
 107 passed with 1 offline (v4.9.184-93-gaf13e6db0db4)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 110 boots: 2 failed, 107 passed with 1 offline =
(v4.9.184-93-gaf13e6db0db4)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.184-93-gaf13e6db0db4/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.184-93-gaf13e6db0db4/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.184-93-gaf13e6db0db4
Git Commit: af13e6db0db43996e060d2b9ca57f60b09d08cb8
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 53 unique boards, 23 SoC families, 15 builds out of 197

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab

---
For more info write to <info@kernelci.org>
