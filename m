Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C73B01BECE8
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 02:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgD3AOW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Apr 2020 20:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726279AbgD3AOV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Apr 2020 20:14:21 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A91CFC03C1AE
        for <stable@vger.kernel.org>; Wed, 29 Apr 2020 17:14:21 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id p25so1960607pfn.11
        for <stable@vger.kernel.org>; Wed, 29 Apr 2020 17:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=upxsTdkMmn/E2U3LiUDkf6kd561qKW/Bgc7wo3MJ1YQ=;
        b=gG6/IJKUhaMzNz7Fb4hdQGvZexGJVt7DVD5+3BcxzVEvesAQOyfnvHZqkPisoGHoqY
         pRyMaXesvYiOk2U4v75atMKKOmYOztz0gHcUNVJr2Xy6SYzejw2I4EJd5uydJNBUSFZu
         oXbQVd8E/7KX5rSEhJAI5oeUdSopdBnhaaVeYKAwJqCONJThB9+6I0RSokHSgHZNAQLl
         68K4L9b+bH5prT7y3esvjzxRUby4U2TSNAU4bRWcuQaRIVmC8rSs8TXtgJJNjPLND0oV
         4fVvHgBEzdlQc8+rIzfv7cYC/5qkuvZWgXzKZ9M1fiXzmg+5Z3kz3sL2AoE4a5V0hDgL
         Eczw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=upxsTdkMmn/E2U3LiUDkf6kd561qKW/Bgc7wo3MJ1YQ=;
        b=Ak0i+kI8N+gMlPQUgsnm6e9DnW23youDLBsvTmileTLxQ2X46mbtwKJ3DQEs5z4VAp
         VkyyVm3R4o6/V+rcejLix4US7TfA428TEWzt+MZ/yf7JVO3ITj1IrsCfLKxxzAA+joEJ
         4GeB5rKtycD9rfaGgvukyPC+u87miDBVJ2LCgd2FZ0MWZuPfV/Zb00wXRr7ikoXDHgwO
         40xZBEJKeJbDQ1YWqWqentg1y2pfgRKaxWgrx4JtSb1gOUEUqQOZmVL0d5TaB4cF5+oH
         0yPWZX+gKR9178gjfyYB9jvnSCIyTRYLSNmgiPMH4z1DvTSa3d3PTEGqSoKuqkI6C93e
         OubA==
X-Gm-Message-State: AGi0PuZCqGgduMqnDYvTDvsCMrcirQopJfLOTKf+KWobFo+I7Xo440+q
        LazNekpBmj9ysX8v/fQV3xWLF4wVe5c=
X-Google-Smtp-Source: APiQypKVp+Zh8WV8s3cj8q3TUSdMSyiDFkstVca7aD5a7vJi6uKyxx5iojzILpm0UDN4NC2ibvEs+A==
X-Received: by 2002:a65:4107:: with SMTP id w7mr696430pgp.438.1588205660706;
        Wed, 29 Apr 2020 17:14:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z60sm313659pjj.14.2020.04.29.17.14.19
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 17:14:20 -0700 (PDT)
Message-ID: <5eaa185c.1c69fb81.d28f4.1b3b@mx.google.com>
Date:   Wed, 29 Apr 2020 17:14:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.19.119
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.19.y boot: 112 boots: 1 failed,
 106 passed with 5 untried/unknown (v4.19.119)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 112 boots: 1 failed, 106 passed with 5 untried/un=
known (v4.19.119)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.119/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.119/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.119
Git Commit: 765675379b6253b6901563e649a2f87d28ada3ff
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 65 unique boards, 17 SoC families, 19 builds out of 206

Boot Regressions Detected:

arc:

    hsdk_defconfig:
        gcc-8:
          hsdk:
              lab-baylibre: new failure (last pass: v4.19.116)

arm:

    multi_v7_defconfig:
        gcc-8:
          sun8i-h2-plus-orangepi-r1:
              lab-baylibre: new failure (last pass: v4.19.116)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
