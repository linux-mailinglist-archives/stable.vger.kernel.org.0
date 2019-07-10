Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFB0C64E96
	for <lists+stable@lfdr.de>; Thu, 11 Jul 2019 00:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727680AbfGJWGc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jul 2019 18:06:32 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51416 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbfGJWGb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jul 2019 18:06:31 -0400
Received: by mail-wm1-f66.google.com with SMTP id 207so3756489wma.1
        for <stable@vger.kernel.org>; Wed, 10 Jul 2019 15:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1a9rpnfcYOYsKIl+UyLzmikFdBxY9GyOWhqt3Pmtm3U=;
        b=mQdqvrTUI3vtkfhFBjN8DENBaJL0KtFujF86sZbmE3c0dGToMIhcMfRoTz1e7TlfW9
         /W9V/xr8fFoDt0a89QAkjbuKtOgWlaxgSr/yjYzQNNQncuj8Ke53VPDoYLC8RAFZFlNu
         PqOHhrLf1pG1ywtNmKFb90d6yhgEHNPawdLtdkFLaM5YpyJr7cCoafrDTy1ibFSMVqaV
         9natxxL1+y+WHciRF8afRWwyTepflULuBdE+FDFZWTLWheWFGfIN+WiUPvsMDrtunf9K
         yRUoAl9+W4fpfSAApMEYuw57zpC26zLzW26VuzUSazikxDgFRoF6cltJLdw82cn0S6TY
         ctWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1a9rpnfcYOYsKIl+UyLzmikFdBxY9GyOWhqt3Pmtm3U=;
        b=jw7/wZrliqUE8vzj5hU6WHcEBkYFGNg8K827Ff4JAJYh9HcWkoML1WSO1TYrHHXG5p
         S0V6HBvZPk/f0irNXRwY183hIweyU/lojyBf8Yv/fMqB5TmdVdt5+Qc7MjT/XCrwebzU
         Jz5ICUBOEfaX0ts8YKdQ+z0AP9kne2GOIvczakmBRkb8qSY9QUUpWv1/OvQfIQMwpIpS
         WM2uy3DJiYD/kyoscajMIwUffTCUGRaXdu7FLXmU9zQ7RKuYIJ1BgaQDzXBHUi/6Qb0U
         qWyjXTkq9e4JzFJhzZhMV7g042xZL5uBEtbwOica7NRQMrQ/G4X5UAAdtpW43KsdKFtl
         gg+w==
X-Gm-Message-State: APjAAAXr6X5dsT9lOWUfnOqMjxHf9I4kD5KzAVtQC3QHrKCjm3i5ieLD
        XMOZ2dZdrUKKUEyFFoGRK2eSN0jP+U0=
X-Google-Smtp-Source: APXvYqySweBQ1+i8pPczjFsKwR0VV7oJfkICrWQqkSPTNQv60ONJfzbyQZoqceDzXrpLTusB5RCyHA==
X-Received: by 2002:a1c:a985:: with SMTP id s127mr43301wme.163.1562796389642;
        Wed, 10 Jul 2019 15:06:29 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id q7sm3526044wrx.6.2019.07.10.15.06.28
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Jul 2019 15:06:29 -0700 (PDT)
Message-ID: <5d266165.1c69fb81.928b8.50dd@mx.google.com>
Date:   Wed, 10 Jul 2019 15:06:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.133
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 123 boots: 3 failed,
 120 passed (v4.14.133)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 123 boots: 3 failed, 120 passed (v4.14.133)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.133/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.133/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.133
Git Commit: aea8526edf59da3ff5306ca408e13d8f6ab89b34
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 66 unique boards, 25 SoC families, 15 builds out of 201

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

---
For more info write to <info@kernelci.org>
