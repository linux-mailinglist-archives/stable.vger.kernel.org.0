Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7450244293
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388928AbfFMQXm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:23:42 -0400
Received: from mail-wm1-f52.google.com ([209.85.128.52]:39793 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731026AbfFMQXd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 12:23:33 -0400
Received: by mail-wm1-f52.google.com with SMTP id z23so10759736wma.4
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 09:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fbFJcCZogG4E0hVeCzNVPT+VFyUUm0Zv3ff/zggRHYY=;
        b=nEiSJD4ko/pfwnRhv74QCOs3sRROjqEdqnr45AmWZfT/IGF4kLeuN7e3Q9cXPE9IPc
         DF9AV55DfFKFTXYSW8xajUTmGpa3xvLr5bA8GnEQCA68wcN+aUviyrq3CWi+rfNTNwrX
         yFrijlIpef8tnZRmOBL1QtfIZ8Hjh6hY93QD0SxySPSnq5u765H7kDHdK/OkKsBGhq3U
         3DWubQlVsyh588GssHaA8zq++0/1NFdS76tI485X2TOdPasAZCDWDvuxkI2WhAnHBCxl
         /TNeyrGqDmyjQGeaPRh1Kh4zESzxCiUyR+zzOcx5iMmTzDV8YdEu15j4zoCc+ONkHoqk
         1XWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fbFJcCZogG4E0hVeCzNVPT+VFyUUm0Zv3ff/zggRHYY=;
        b=QqIPzakmnqdVVBFghk4OOFEE4A8RB7jsPnzVQ51JoIH9T22vRXOq/xcRWaVuU/lZRD
         rSwtK5oFiDwCisWNpGa34d1P4ZhUD98IV12HKYLzSNcuCUwfI+JIvx9i9lBrfQA36436
         8eiYd4v7qpy6YQHzZRsuA54vmSQ8UjLHQGG+GYeNTgubgC827xTE9rJDReYoEirSKavH
         PZIVmUUM9X/N/a4BCIMXsAcwNq5SB5oQE06AgnXeXRG81Fxy4fr2OJ5WYsh+rJaAc4ed
         4OfYzbEZOV+Xq1Aoq8nEOWq+1uX4GVAUm4rtyNdPkC03xsiYUzOrsSLuLOFTf5pZsz9f
         3ofQ==
X-Gm-Message-State: APjAAAVyow/Tmut9dedURjd11/bDngjHfxKxY63o3C0jjcp+EGYaWDrW
        UZoLzTPzvQUk/cEGN1mH6i7GqHPVDfgU0g==
X-Google-Smtp-Source: APXvYqyEauuwKhdo5pBv3X+VwMn0kswTi6Dxno09robAKQCmcLtHyuF3pr1MK1MSjq7vGwaF9aGF1Q==
X-Received: by 2002:a1c:3d41:: with SMTP id k62mr4014536wma.61.1560443011441;
        Thu, 13 Jun 2019 09:23:31 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l17sm216856wrq.37.2019.06.13.09.23.30
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 09:23:31 -0700 (PDT)
Message-ID: <5d027883.1c69fb81.43ad2.13c2@mx.google.com>
Date:   Thu, 13 Jun 2019 09:23:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.125-82-ge64912eac71b
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 116 boots: 0 failed,
 116 passed (v4.14.125-82-ge64912eac71b)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 116 boots: 0 failed, 116 passed (v4.14.125-82-=
ge64912eac71b)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.125-82-ge64912eac71b/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.125-82-ge64912eac71b/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.125-82-ge64912eac71b
Git Commit: e64912eac71ba57be3613c8fcc36e316fe8aa601
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 62 unique boards, 23 SoC families, 14 builds out of 201

---
For more info write to <info@kernelci.org>
