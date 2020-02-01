Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C84A614F80F
	for <lists+stable@lfdr.de>; Sat,  1 Feb 2020 15:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbgBAO3Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Feb 2020 09:29:25 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52004 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726679AbgBAO3Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Feb 2020 09:29:25 -0500
Received: by mail-wm1-f67.google.com with SMTP id t23so11131299wmi.1
        for <stable@vger.kernel.org>; Sat, 01 Feb 2020 06:29:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0DNelTMQM3Uf2+LhHWmhmGIGgZCYCJ4ZE3m2e01v0dk=;
        b=WZSYol7u7l2Lzi6tpP+1pQIxnUCpEfWUDDMkTcSXlgwFFullHaQ81Oq4SPFlVPNbO+
         HZ4Wf0wrhfeFGxd/QgOQo6+qFoHbZe0nwgSJBWnrpPswjIjbgxdoErvLQ5OIVT+MdRXH
         p9fPb0qtzYyj4UaDqWpeT9jdHFEzH5TTVn/aYIHBYrVr2YhHjd1T5L0x/F+hOIG2dmsn
         m85LxEGwdUOgdlsQzyPAsrBkiJ7eW0nKbVc15dQLnrgd+Uev+BiFMHVyGEZFC1NxEWi5
         UccaFmr8vapzqEkkEF98p37XP7iv+YqT9na8RBRR59GLsKXfXmvP62uH7RpoRK96SHjz
         hMEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0DNelTMQM3Uf2+LhHWmhmGIGgZCYCJ4ZE3m2e01v0dk=;
        b=DxFXzLVG1Zt4BsXefp/Evh58bQh/HT34yGSeJkUCAUJ2cuE+hpv56BmOyqhyekIa8T
         cpHr8TJzMmpWx4mU0YNYUHUmfe+/07XOy9LMJNHqJxq/9Ah4pxOMojceB8+gFYT78x4+
         u55KaaCyars81xAb6tygAH9xhEeP9Jp2OLScb1iFMp4Jd5oYMI7ukKMmYdRr1pcTMSKG
         HZSu3onuI6qs/zQlj2b6Xz9vv7FCcG00/uk/9+DvcKl3ODTqOnBRihG46gD80u9vblBq
         mttUR9IqemQLsMvpF6VL0jPx0n+fS3zLCbbOYueETgSGkk//q/RwdgmnGGelf3xgYydU
         KGJA==
X-Gm-Message-State: APjAAAXeaFB7IvKguByNn7l8tNX/TAUpuPKwsPjZMA6v1J5wVYBqfVtp
        dKy/HEJMI8xnCbO9RFkwDRYqph1sTklJKg==
X-Google-Smtp-Source: APXvYqz65UGQpwZfeRCPwUPEsoY7WpbKrHPCoF0/R2g5mgUAoBhqOHwIUXNoRQ4PO+KsV2UIg7h8LQ==
X-Received: by 2002:a7b:c119:: with SMTP id w25mr18809400wmi.116.1580567363657;
        Sat, 01 Feb 2020 06:29:23 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 2sm16427152wrq.31.2020.02.01.06.29.22
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Feb 2020 06:29:23 -0800 (PST)
Message-ID: <5e358b43.1c69fb81.6d934.7f24@mx.google.com>
Date:   Sat, 01 Feb 2020 06:29:23 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.101
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.19.y boot: 39 boots: 1 failed,
 37 passed with 1 untried/unknown (v4.19.101)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 39 boots: 1 failed, 37 passed with 1 untried/unkn=
own (v4.19.101)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.101/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.101/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.101
Git Commit: 32ee7492f104d82b01a44fc4b4ae17d5d2bb237b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 25 unique boards, 11 SoC families, 11 builds out of 187

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          sun8i-h2-plus-orangepi-r1:
              lab-baylibre: failing since 2 days (last pass: v4.19.98 - fir=
st fail: v4.19.99)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
