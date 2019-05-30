Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C81EB2F749
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 07:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfE3Fy2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 01:54:28 -0400
Received: from mail-wm1-f44.google.com ([209.85.128.44]:53631 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbfE3Fy2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 May 2019 01:54:28 -0400
Received: by mail-wm1-f44.google.com with SMTP id d17so3062574wmb.3
        for <stable@vger.kernel.org>; Wed, 29 May 2019 22:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ypF/KA9Dic146WE/lXlqQwn2IzYwEkhGA3zkwEb1X2U=;
        b=fZGZ0gBd9SqPgGOQKY9G4S+vPg/h7bOqRm0EnbbHwK0hlxe0cSj6L95Tvr02a+8eQ4
         JH/r+ebLabD582pEdfNXGgb1Uci/uC1aV5ALqidu2GkLRKurUPNaPknbt9M3IN9Q/7Gn
         vVcG0J9ECI+DS7o/EvRSCFR81aKMYS4znKdAJNgdKWiY6fDfI62Wr33fcl2vxHmfkauT
         Pgus/QDZNkYFdXD2/vIskE/1WlfJ62rsqrGEvHCV3v/q4eDZ621nUjCecK2T9tk4M12z
         dCXlLYAtNx0dH/YH3eLOLJJLLDKjsiwz4nuhFbHa/GU95Ggpax0Trz7YwLU5qhvODT97
         GbtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ypF/KA9Dic146WE/lXlqQwn2IzYwEkhGA3zkwEb1X2U=;
        b=MCg5tP0LCpoYsyGUzT4Wjs14VTiLcjwdQdjZqvx5YRUblbDfm50SiOh35A6wMOWcTg
         0soKs5DMnBJfJHDNtctKu7yFj80aYj46xggjZLb1pO+D1eqbpFya2SEKvuwmHBMaNNYo
         6Wf75nKMxk0laFJnBcVPH2s+sLdbVPfb2VUjr1rtKS2UuE0fVlDLRNrR/KxLaYc1vXc9
         w7Lw3KqnnO5Ei7kDcNZXCpeSjc7kZtqBqt/FjenUVq2RV29pTUKjK8067SKQMPiFh3E6
         jMb+mK8xEoK+XPdTU2C1xmvnHJuztTgq/US450C1ldXFPtJXplvTVJgh8BFjzHSvZSEn
         JMsQ==
X-Gm-Message-State: APjAAAURjn87UCdHwZbnmtouIsw8qu7dNlA2kXjzbBVep32glwGiV2T2
        u6l5c36ry0wtWA0WglPZKIx/MawNKR17TA==
X-Google-Smtp-Source: APXvYqzATMH3N+MsCJhTROUCgxujR2mJNet0u6+NtEfcBTZar6uMNZ/KR76Rj26lLI26oCUDU/tISQ==
X-Received: by 2002:a1c:c74a:: with SMTP id x71mr984423wmf.121.1559195665909;
        Wed, 29 May 2019 22:54:25 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a4sm3206591wrf.78.2019.05.29.22.54.25
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 May 2019 22:54:25 -0700 (PDT)
Message-ID: <5cef7011.1c69fb81.2145e.f7fd@mx.google.com>
Date:   Wed, 29 May 2019 22:54:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Kernel: v5.1.5-406-ge151dd0525b9
Subject: stable-rc/linux-5.1.y boot: 125 boots: 1 failed,
 122 passed with 2 untried/unknown (v5.1.5-406-ge151dd0525b9)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 125 boots: 1 failed, 122 passed with 2 untried/=
unknown (v5.1.5-406-ge151dd0525b9)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.5-406-ge151dd0525b9/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.5-406-ge151dd0525b9/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.5-406-ge151dd0525b9
Git Commit: e151dd0525b9aaeac84987d2790c30d8a89ae274
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 69 unique boards, 22 SoC families, 14 builds out of 209

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

---
For more info write to <info@kernelci.org>
