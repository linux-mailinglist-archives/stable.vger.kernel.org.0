Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE1712FEEB
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 23:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728816AbgACWlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 17:41:50 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37577 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728794AbgACWlu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 17:41:50 -0500
Received: by mail-wm1-f68.google.com with SMTP id f129so9862059wmf.2
        for <stable@vger.kernel.org>; Fri, 03 Jan 2020 14:41:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VtsujMqD6BR3ghjaRCKTcSEEda1eHxqCaYI1YEGNuEI=;
        b=sAt+y21gIM+r2OivFcnJ4AmuhgLg6EjiQyaoe7N/y+jTfQEZW5Z53KjC4sx/NekAph
         i8Ee9FcAFUNg7NOYc/Y45InIlT8CvM3+v9UPTVI2itqdFJxuoYO0KsIqatxKiqWvqSLY
         z6bpG7uloccH90GMM00BHkB4zRAUXrCWd/6fMq1WQc96tuugZgfYrylpO96vd1RZjCVI
         A5hp1Dvzj3lrbRHjoiaFY76k/eIYCqBYpuBcCPZGZmubCWhbZFTwaXw7+2hjohkMkKZf
         TWswRnCwQYek9wp7MopHTQoy8ys+a2oOGU96aUMMYLXlNurO/8c15eFCnBRebEjqi/UY
         o0XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VtsujMqD6BR3ghjaRCKTcSEEda1eHxqCaYI1YEGNuEI=;
        b=DoTTQhh1+4XOQCxX6cSuvotecqoKcRo3D1cAZsQ2PmYauFjiQeaSzWYylhY66R+6WF
         TOtrNOIOnN62P5Zj/Hi64C5OilO2bN8DoewJnDQA/LJ11OMGBM8Nsyn//tjKtoRTP1Df
         y0cg42/B4Lx5NLW6xu6OUrtX8e1cefj1xLprOxPSy0zgyMq3UKSDgkRf863/CJWn3xxv
         7EoL7NU+a80KGXMbHBsTITljnQbQo7wngEor5YmU8gpkryvevupIkZa/Nf2+08uxpq6/
         hFUAJfZ2nJSDmn7+ERGJIq6ZAhOU3CnpQmi3gLeO8ZL2tvJME9CZWHIKXQYaEfl0uepr
         H1Fg==
X-Gm-Message-State: APjAAAVl/liacUk6Z1MxJx+XqwfUdhFI8vCDZxnmEwZKqzU0noXxKOjv
        E/g5yOM6DC3POFF/oNDdI8OEnSk8oXjwHQ==
X-Google-Smtp-Source: APXvYqxZFjSp5BomowTU4Z0fX06QVeka/NsbOsMyhpzRSjhpAwtd7V5yeXXcYhvCcz3Q7QTt2VgBFg==
X-Received: by 2002:a05:600c:2488:: with SMTP id 8mr21246181wms.152.1578091308337;
        Fri, 03 Jan 2020 14:41:48 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b68sm13598235wme.6.2020.01.03.14.41.47
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2020 14:41:47 -0800 (PST)
Message-ID: <5e0fc32b.1c69fb81.a50c5.db97@mx.google.com>
Date:   Fri, 03 Jan 2020 14:41:47 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.92-115-g9ecb5b1714ae
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 62 boots: 1 failed,
 59 passed with 2 untried/unknown (v4.19.92-115-g9ecb5b1714ae)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 62 boots: 1 failed, 59 passed with 2 untried/u=
nknown (v4.19.92-115-g9ecb5b1714ae)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.92-115-g9ecb5b1714ae/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.92-115-g9ecb5b1714ae/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.92-115-g9ecb5b1714ae
Git Commit: 9ecb5b1714ae62e5f10cc711b473d902b465735d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 40 unique boards, 15 SoC families, 14 builds out of 206

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: new failure (last pass: v4.19.92-114-g6a2e2a4c8=
65f)

Boot Failure Detected:

arm:
    omap2plus_defconfig:
        gcc-8:
            omap4-panda: 1 failed lab

---
For more info write to <info@kernelci.org>
