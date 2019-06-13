Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 654EF43B02
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 17:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732036AbfFMPZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 11:25:21 -0400
Received: from mail-wm1-f48.google.com ([209.85.128.48]:52604 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731584AbfFMPZU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 11:25:20 -0400
Received: by mail-wm1-f48.google.com with SMTP id s3so10671009wms.2
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 08:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QISU3lFBcIy5XOSh+gXasbkRG/Tuky+59UUEOe/XrFU=;
        b=fs6sqLQaAskIMzAPyqIVhRJB7I0ZnQJT2pzwqd0gfu9iklPtckQ0mp0bjIFKQ/Fd41
         7dY3XcypEDQYVVA1OufeZVSdPg14K5q3XlYUGNYiNVaOGNeU23yohp7cUetSaBn1vLUg
         SJ0fK3pq6DieCcVE+kEnpZdkTyL5AabelFew6mmXfx2gv5GBFyt1vjOlPCSTlYUUQf0U
         8qUr+yv3fYqoB0r41zJ2W6qbPJmwOYlFrgpMF7N4RuXUWiyAXkwd8RwAcMNUVfvuupij
         nnh0RptdHV3ynOrm8eCXx60lW5RK586mHeyarn5himsNpZoQyalFf1A36qMoBnSxbAGV
         pY4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QISU3lFBcIy5XOSh+gXasbkRG/Tuky+59UUEOe/XrFU=;
        b=bqz/z1q2HPnxKNSlQTHQwutz79xvlsvpJhip4R4OVJNwKMCNTkN/xgJVzUDS55Tw1j
         eei5dKIlkE6c+r9HIDoWIvx7DCsByVqBp1g6oC1VPHNE5dKNyREwXtr3egDl/Lg/PpQa
         h1sjXjVcYJA5SM+UHEqmuD7dIEK6zpW5sIEjrpDbXIEwMyRxV/LbLQQvlIYjEtYlp4fV
         4zBIMYQorC/b0mSB6UuzmrxhvHl1jQnXKis9QPJ6a8YJYMhtJVWIr0CydhThLDuX8R3A
         2t/bFGEhcIvaEzVlaUo171h8QmX9FTLzP2WrCf85z2OZ8+8xmE8YoIxJZwQMFDWqFd4P
         0Iww==
X-Gm-Message-State: APjAAAXTEU5zJMYiuiG9i8PLtgXDOpI9sI6416VDcCTc3jWYcLBETcHg
        wBjHAkJX2nuyDaZupNHV/k8jWWBn6HjQIA==
X-Google-Smtp-Source: APXvYqy6nv0/tCXxVBZ6UpDENhnjsKpL0/bM/EjwPmc1sTTbvqCjNj+CDRHI3fCWNQ+mmVWcA1ONww==
X-Received: by 2002:a1c:e914:: with SMTP id q20mr4430158wmc.55.1560439518745;
        Thu, 13 Jun 2019 08:25:18 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id q20sm7366541wra.36.2019.06.13.08.25.18
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 08:25:18 -0700 (PDT)
Message-ID: <5d026ade.1c69fb81.11643.7d17@mx.google.com>
Date:   Thu, 13 Jun 2019 08:25:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.9-157-gb7eabc3862b8
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.1.y boot: 131 boots: 2 failed,
 129 passed (v5.1.9-157-gb7eabc3862b8)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 131 boots: 2 failed, 129 passed (v5.1.9-157-gb7=
eabc3862b8)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.9-157-gb7eabc3862b8/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.9-157-gb7eabc3862b8/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.9-157-gb7eabc3862b8
Git Commit: b7eabc3862b8717f2bcc47f3f3830ec575423c8c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 75 unique boards, 24 SoC families, 15 builds out of 209

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxm-khadas-vim2: 1 failed lab

---
For more info write to <info@kernelci.org>
