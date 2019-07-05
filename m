Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A45E560E14
	for <lists+stable@lfdr.de>; Sat,  6 Jul 2019 01:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725917AbfGEXSA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jul 2019 19:18:00 -0400
Received: from mail-wr1-f54.google.com ([209.85.221.54]:38799 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbfGEXR7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jul 2019 19:17:59 -0400
Received: by mail-wr1-f54.google.com with SMTP id g17so1168544wrr.5
        for <stable@vger.kernel.org>; Fri, 05 Jul 2019 16:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ReotNAujUqPXuKbIk5BLCjtZwPy8YRB2JBgB05DlYFo=;
        b=GCf75RdgmYV3uXmbZbCNAGGii5Yg+ED7SkLdQFg8O6xUBmHU7zpAbx4MENfeVLgVJ5
         SvmUtGx9SJ2C07kqKwXjOSZy8H23UrFJlkQrjb4Pk5OUhW4uTzoy/yrHuFIw6ApGakfc
         CF4bnxs4wpAb7/3Y2daGSNfc4PgVKp+gc7W5TcJaS6b2W4Vg6hanUFsrk1gDtcQXDJlm
         TPNtqTzEJEj14+bVPjWO7b+ZxUwp4MKxI9CWgDH4LGuGmxSmiZolOtZX+d3QUclUOssh
         Cfyo/+2MBoRLcOxrCspFRLglkzc/fs2U3L56aXmgxSz9G1pwjLfBKiynvQTy+CM/SxCL
         DWRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ReotNAujUqPXuKbIk5BLCjtZwPy8YRB2JBgB05DlYFo=;
        b=LKhq7kYoIOYQjCua9ioFUtbrd6aI31aK9uvc2k+n6j485X9uIY/hIhNt0KS2G8zxnA
         qcixT0OdG8lSc2OTtEYCJWPCi50t2b14Xg+qBKkdgTRM21I7VLD+QxRrrsk7WPtp7WuD
         UOKPOwRGH+Eg3Yr+hLorv9OQ93FTJLverxFh7CpEokrnK0ChW+M9GKfdFqEKuVsUz/uH
         Nvkk1YvNZFR/x1i6ATcRvgMsGccvGg9YW5HR9QOcJ8GvJG0B/j4uQNQpIf5cGlClWHRo
         x7dSqiTpJiYnpHJxqW2oQVkzl9IHtuk4qWyut6TyDU9UQdeYhwuCB9fOk1f/mxX6KeBR
         7KoQ==
X-Gm-Message-State: APjAAAVEPUWGFJmnUj65TjDAg9M1YTRXMZ5tB0SPRWOCN32lC5jzVvE9
        1m47XE520LgIVXvKoW6tuarTzU3JK0ldJQ==
X-Google-Smtp-Source: APXvYqy3cZ3mZuGlsZVOUfCPIo0kmxJ7EtHVhZLy+8/9wHljQ+YOseXnkmLPdH8/EMiPraJIxGBPlw==
X-Received: by 2002:a5d:4cca:: with SMTP id c10mr2398524wrt.233.1562368677863;
        Fri, 05 Jul 2019 16:17:57 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id q15sm6987340wrr.19.2019.07.05.16.17.57
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 16:17:57 -0700 (PDT)
Message-ID: <5d1fdaa5.1c69fb81.52a43.6939@mx.google.com>
Date:   Fri, 05 Jul 2019 16:17:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.57-82-g8bbb06fa4646
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 131 boots: 3 failed,
 128 passed (v4.19.57-82-g8bbb06fa4646)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 131 boots: 3 failed, 128 passed (v4.19.57-82-g=
8bbb06fa4646)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.57-82-g8bbb06fa4646/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.57-82-g8bbb06fa4646/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.57-82-g8bbb06fa4646
Git Commit: 8bbb06fa4646086e74ae93d80d55d2feeb6b5d3d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 73 unique boards, 27 SoC families, 17 builds out of 206

Boot Failures Detected:

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

---
For more info write to <info@kernelci.org>
