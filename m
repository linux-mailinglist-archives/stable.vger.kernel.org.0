Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11C63F5CD0
	for <lists+stable@lfdr.de>; Sat,  9 Nov 2019 02:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725895AbfKIBrf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 20:47:35 -0500
Received: from mail-wm1-f52.google.com ([209.85.128.52]:35999 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbfKIBrf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Nov 2019 20:47:35 -0500
Received: by mail-wm1-f52.google.com with SMTP id c22so8054071wmd.1
        for <stable@vger.kernel.org>; Fri, 08 Nov 2019 17:47:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uVn2qkTljl+tTRkQyCgOVZ3dMV2RafY7lkEdIbVUGTM=;
        b=xSTyrSk8p0/iVd2jVtWrGHwigL0rzLdoS+5/C+TLsXjbCxy8pdtlRsZDqthZolq3ty
         3pVo2TrknhkFDtyLFKY4JlGDNQzJDwXqABk2W0ITxkjnfO+elTp6aq7+j1s4Hz1rqLh2
         tQ4XiyuTJlGSo8OmLuWIT5xAkEm08egpo2lbGOWJRr/7K0V3hroiXtOjOZMSltko2+JK
         F6heozvG/y8gGwYwylOb7SLDuKFfCN35QxzrlLbkU6WKIqgyaUIOGJQcR5aeSqmUDENf
         ynlbj8rCJyTD/tt8iIeM1iN1eGi+OpGScEJJcS22cMNSdObi7z/fbkhWM5rmJyauKWfI
         zGiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uVn2qkTljl+tTRkQyCgOVZ3dMV2RafY7lkEdIbVUGTM=;
        b=YsU+grqHtOTOWHIARE94O3D2Rek4usUYxLwzFHlHgzxffyr316FdQbxpdo8JAdpQ4W
         PykLIzyCQmFtMCEt1BU2E9g9mvze8Ubw+CFug+TUZXS7abv0+TwxzvTGLyKXycYrED/I
         MnS4qgBI+sQj5E9AopfI0DJiFZXPjIMcWImAfsyzhp/JvqrX3SCwCyBR5g/Y3BTcs0NU
         y8++44OJsakMJeWld7jZrbJ5omL3jVGnFGL7IAfTheNfXdHlXfNMk+y5EizCarnHj0Mw
         sPF7JXNHHnPWOhkSofbnK3FTUx6YVJjnz30IxD1qXUjKwWyzbERK0cWbrHpNmoaX+TiK
         qWSw==
X-Gm-Message-State: APjAAAWz7gv5z9ZBVhIpZcfPMygvl/VB6GQKY00UJ7qIMd2rYnggznS/
        OFSJdTOlcS3TylaVuZeZEu/z+SdCG8Wz8A==
X-Google-Smtp-Source: APXvYqyBBu9bDBwh71HRYK1OKlfnVsqDU6BwfgX4YVuXXr7bBNJBkPXx22WEtU8/NfFp38Ju+x+kAA==
X-Received: by 2002:a1c:1b07:: with SMTP id b7mr10853720wmb.111.1573264052751;
        Fri, 08 Nov 2019 17:47:32 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o18sm9320824wrm.11.2019.11.08.17.47.31
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 17:47:32 -0800 (PST)
Message-ID: <5dc61ab4.1c69fb81.eeca9.2b71@mx.google.com>
Date:   Fri, 08 Nov 2019 17:47:32 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.152-63-g2cfe0b7bdeef
Subject: stable-rc/linux-4.14.y boot: 110 boots: 0 failed,
 103 passed with 7 offline (v4.14.152-63-g2cfe0b7bdeef)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 110 boots: 0 failed, 103 passed with 7 offline=
 (v4.14.152-63-g2cfe0b7bdeef)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.152-63-g2cfe0b7bdeef/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.152-63-g2cfe0b7bdeef/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.152-63-g2cfe0b7bdeef
Git Commit: 2cfe0b7bdeef09a0ffe2895928288ebca332b8be
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 61 unique boards, 21 SoC families, 13 builds out of 201

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
