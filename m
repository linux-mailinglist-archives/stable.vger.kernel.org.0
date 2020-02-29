Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C69B17478A
	for <lists+stable@lfdr.de>; Sat, 29 Feb 2020 15:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgB2O7g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Feb 2020 09:59:36 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36722 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727068AbgB2O7g (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Feb 2020 09:59:36 -0500
Received: by mail-pg1-f195.google.com with SMTP id d9so3090469pgu.3
        for <stable@vger.kernel.org>; Sat, 29 Feb 2020 06:59:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=T0NY7pkWWRFGtnCDXRmrw2DYvbvZKAmm0CMNimVq3lE=;
        b=vcr7Fg9FlUNIdG7NhvFrUFgDZ9ioTyzvWRzXAWiO6l/DRIX4Vlenc7ZKnmzULiBsZT
         W6KMlkAQgbPsig3bRHXLbDMQupySz/nXvWZYjtN2TbFVVFLN+WdMpNm4PbuR0ObJrXN5
         aN8Pu7L2fHfFK/R5YfWolGaT0EARdcJb4o6Eblfe0+g7iVBZ5Ba/0hDfvWSbslIxJiQS
         xDCrxkjDw6nUlAeQOc1AOvwWNY2Vh6xN3KtAGAVkexyoYLWNWXCohHCJx6+6nYwUgILp
         JY/2/tmUliJsXQBjZ8p6fhL9bgzNMLSZ840oqT/6S5tFBDwRd3Tg3J+sN7gGuPWkervu
         n+Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=T0NY7pkWWRFGtnCDXRmrw2DYvbvZKAmm0CMNimVq3lE=;
        b=ln81uF0Xg+WZk+rSIHod+Sc23w/BdzQlvjUFiqi8iaA1FGp6Bt3MecVmebwRRlL9Bp
         tME/MFqPQMA+F9vAHVr5sQIyB/2/jxiWf3/P0aMT0zLDameyTNsXLzj5QZyxxcITDyXb
         AheU/VNg+Bl5HX7ovr7aGKPiBM6z2TE4KhSP5irx7SpFeKWPDoxDm7IQqMjg1WyIuvBJ
         RHGCMP4gl1v6tBYXO/ktoIe/V7+UELdFw7vvVXGOCC4Gu46yXce9BDO5xGjPXqAhxy1B
         qK0RNwYS+yz+7HZxwaB7al7HBxntG3T7IQJ6NrtoAJvKQMNPnbT5rwBJg3Pc8lhgfU0i
         Wd+g==
X-Gm-Message-State: APjAAAWY+0ATcnvitbolEfvDnxcyx8L46/GdQF+ZBCPmmpX1n7KVahkZ
        Jn3XgIJkZfDQGCqDL+AGbwWEBNgWGCs=
X-Google-Smtp-Source: APXvYqxI9BT4t/0vH27wiao7iql5/ac+RFVc6Th8JUoIsR2BS9N/2/OUmGGVALP55q50iXkEhAQ6ww==
X-Received: by 2002:a63:1210:: with SMTP id h16mr9952341pgl.408.1582988374723;
        Sat, 29 Feb 2020 06:59:34 -0800 (PST)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l21sm6201125pjt.7.2020.02.29.06.59.33
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Feb 2020 06:59:34 -0800 (PST)
Message-ID: <5e5a7c56.1c69fb81.cbc9a.e7e8@mx.google.com>
Date:   Sat, 29 Feb 2020 06:59:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.215
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
Subject: stable/linux-4.9.y boot: 20 boots: 2 failed, 18 passed (v4.9.215)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y boot: 20 boots: 2 failed, 18 passed (v4.9.215)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.215/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.215/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.215
Git Commit: 4cd444443b6f3732fbe0552315cc5e5b35112a85
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 20 unique boards, 9 SoC families, 10 builds out of 197

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v4.9.213)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    omap2plus_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

---
For more info write to <info@kernelci.org>
