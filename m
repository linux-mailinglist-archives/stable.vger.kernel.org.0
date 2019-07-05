Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 043ED60C7F
	for <lists+stable@lfdr.de>; Fri,  5 Jul 2019 22:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbfGEUma (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jul 2019 16:42:30 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:42258 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbfGEUm3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jul 2019 16:42:29 -0400
Received: by mail-wr1-f52.google.com with SMTP id a10so9967205wrp.9
        for <stable@vger.kernel.org>; Fri, 05 Jul 2019 13:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=i4VXV6ePPGfYdHi34tf5djbmfd/xyF6oT2SFQw0zExk=;
        b=seVHJRTOqxLs/ozpb1H+D4NXft6b8yhf4GMCXoACqRpDLKCcJcC569pBkrrbjz6W5B
         GqFZ/PzFo3A/9OUvu8xuiCyWhVFh+0zZV9aZmcb6er3GHIK0uwuGHxcRb0dJuAFzbUeK
         vF3zvEuEq3gv3NiIt9EhWa3lwTvFsEjpfUa0x4FPW8N3YBupzle8t4rcP5eRKrqvaXgK
         PwjRkC1sttyZA+V7e3SAag4+PSqFOwXsY8MbvOsQp6KWaXA/IbbE+dBEuE/9H+0CIZB2
         p6qWIgDSscqJio3wR1amqsVaeZ9XexfPk0fkjaGgNYTV66o34vR3KTViVMwgZzjL5jK1
         +CoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=i4VXV6ePPGfYdHi34tf5djbmfd/xyF6oT2SFQw0zExk=;
        b=Xz5lhiCh7zj72Cb8wcS/q6M+nVUe1RB+4i2OtdUC5h8NuIa3QSgg/O99whf+t+M5/8
         kILXcX5SlhUkNSOyBQbokTU6E2ywRGChoQnl8lQDiZzSIlyzNzbXP2YotuZWa+DR9wYg
         DUPXiXCXEfFcc0YldoEm0st1S5aKSQmG3GbxFtMy+CVAFntlpY47XWBYqDxAhY8ekDIj
         E33hqFM0Mp2/oJm2nZ5k3KA7IV+qG9hJctyvwglEpoZMDWjBmJMH+2drXAggmW60/6gX
         l/hOzFCFDkNplTmqlTi2p3dEIddqxWxHcZ3q+cNJoPTUBuh79S1tqHDkZ6IdVzvj33dw
         3kEw==
X-Gm-Message-State: APjAAAWL3xy/3XpnqWoCofdsYGBIHBXvHL4LXKcGwwAg4hEohXKuIW0P
        9dYMYZeVIRzv+QXWm2VFm6oq9Rx0Qc2cSA==
X-Google-Smtp-Source: APXvYqyXjKhLj756cdNZvr+aQYA5WxXBbqDvPI4EGtykvagpE34dwp+eADZ0xNFJ1hjcfZWq5saw/A==
X-Received: by 2002:a5d:6783:: with SMTP id v3mr5303183wru.318.1562359347622;
        Fri, 05 Jul 2019 13:42:27 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t63sm8256655wmt.6.2019.07.05.13.42.26
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 13:42:27 -0700 (PDT)
Message-ID: <5d1fb633.1c69fb81.d43ab.eb81@mx.google.com>
Date:   Fri, 05 Jul 2019 13:42:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.16-83-g4af32c555274
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.1.y boot: 140 boots: 4 failed,
 136 passed (v5.1.16-83-g4af32c555274)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 140 boots: 4 failed, 136 passed (v5.1.16-83-g4a=
f32c555274)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.16-83-g4af32c555274/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.16-83-g4af32c555274/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.16-83-g4af32c555274
Git Commit: 4af32c555274b35986f3178dad912fd4d7c18d1b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 79 unique boards, 27 SoC families, 17 builds out of 209

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab
            stih410-b2120: 1 failed lab
            sun7i-a20-bananapi: 1 failed lab

---
For more info write to <info@kernelci.org>
