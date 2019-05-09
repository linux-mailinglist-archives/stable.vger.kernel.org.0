Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACA9E18ABB
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 15:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfEINbR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 09:31:17 -0400
Received: from mail-wm1-f43.google.com ([209.85.128.43]:52120 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbfEINbQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 09:31:16 -0400
Received: by mail-wm1-f43.google.com with SMTP id o189so3313165wmb.1
        for <stable@vger.kernel.org>; Thu, 09 May 2019 06:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cLhAhIM1+usZ0x4GJqSNRiiS7MA9pKNbU5mSbz36ifI=;
        b=gBOFj6jCqe1HQcks0CuUR+hwIiVEqvyNLw6eCl+t/CXwiQV7snwQS77epXxsy1f+1g
         S98HyHGleYicWcfin4KTAzDN78aJ/wdWX9/6R2moX1hF0h5RwiTNN5x2uih+49yyQEfU
         GiAH+fCRE3Rpy4ZtpAZbZT5at6lVjVX9HtNWt4EPJXHxy8GVPDI3fXXNSdFNPE8HvqO5
         EgOxd+X+8wAxx/xUrhVItfZLkyfBVi1bJcA+HqaHWVS+QeMzzSZaZDDQmqeNUfOb9jJc
         fIC20TAIaK/7XNHCNrsx+u9+0KBRiTXcNJioid+q0QWPejWsa9W6W4iHwPb4jluqK1B9
         ROJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cLhAhIM1+usZ0x4GJqSNRiiS7MA9pKNbU5mSbz36ifI=;
        b=Hm/lKgq8Ri/hHyF2v5l6+qP7E7senAsNdW4njUBp31EmGrmFIF0qzlxATY5asKNtK0
         VZe8fRLeUpgG/8PPTwpCK2WgG3iQBQ7F4fnpmejDSiQbHpQZviAYyMJW6cH/13wd9YRA
         f8afPyxt4ABocOVqF+dG3LQGip5Lm47yjuCXPJX1bdRAi231Ty4G09zpTbd/UCSou5iL
         ok4sd5UFM+s8y5EhPYxt8GiIms4j7wZFqHxdOsTO0Ekgou3slujb8J4YmlV1RRx+LCxi
         gJzrwhl0BemNCUR5T4Oi1g7A3NkpSK2BjDJkAwrLyz6e4qz7yMKoNN2vL9GzLJ/GOJwU
         odRA==
X-Gm-Message-State: APjAAAU77cur3jj9ceFEqlluLZ3pyJlLlpruDM59ejhFRsN7J7iPhF3w
        AEyaSBJpGIDtNiYaKclbt11SU+SLvLzlpw==
X-Google-Smtp-Source: APXvYqweo0+cwZo4jO0i46Q/PNpuWjUzNWoz4592P1WdsZkjWQ8b2XdicPaHY99aD6P2cQn7lhTzYA==
X-Received: by 2002:a1c:f413:: with SMTP id z19mr3067546wma.71.1557408674276;
        Thu, 09 May 2019 06:31:14 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id u8sm3336970wmj.27.2019.05.09.06.31.13
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 06:31:13 -0700 (PDT)
Message-ID: <5cd42ba1.1c69fb81.e650f.0333@mx.google.com>
Date:   Thu, 09 May 2019 06:31:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.41
Subject: stable-rc/linux-4.19.y boot: 131 boots: 1 failed,
 129 passed with 1 conflict (v4.19.41)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 131 boots: 1 failed, 129 passed with 1 conflic=
t (v4.19.41)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.41/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.41/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.41
Git Commit: 21de7eb67cff193e92a4556ae282a994e69b8499
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 70 unique boards, 25 SoC families, 15 builds out of 206

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: new failure (last pass: v4.19.40-100-gf897c76a3=
47c)

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    omap2plus_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
