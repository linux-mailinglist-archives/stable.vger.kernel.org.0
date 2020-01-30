Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C21C14DEBB
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 17:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbgA3QQG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 11:16:06 -0500
Received: from mail-wr1-f52.google.com ([209.85.221.52]:39086 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727158AbgA3QQG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jan 2020 11:16:06 -0500
Received: by mail-wr1-f52.google.com with SMTP id y11so4779972wrt.6
        for <stable@vger.kernel.org>; Thu, 30 Jan 2020 08:16:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VAVlHZPJwVg6t0w2y5GEl+M6jx2RT8Lt8MBDVCvRPRU=;
        b=DzKZ/2+ughduTQ6rNLP0+oMsnMTgpKUlVF/pxyNEYUb9LrXKl6XpBR8E5iRArQkuHJ
         89y3Ajd9LeZcChg+KTyfqljGKNHeQroj5pIp85SP4PodpF660id5o9DIgDxQHTeZWiU3
         Zp5gcAdBRV4mL049UCwFbS/h9hepGiCIQT7S8JYcs++zhY/gDBpJr3Y7RN73FwpqdTS2
         wJLVzi3FVRm2bfOKDaRj1hnuD27He0GcgIc0nBmFR2PesdpAFeH90D1QCULTRYc0Gpif
         k6wQJYtbl/8uemEwkmcaHthxahD8dgk8Gd0qJK8Qk6OLgf5oaIoicgrYeBWZ9/maO624
         rLMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VAVlHZPJwVg6t0w2y5GEl+M6jx2RT8Lt8MBDVCvRPRU=;
        b=Og2TXl03/KXs9JTDmLwWkNm2xIvx6Zj+NUOXBIQ6CS1Q1QQDOes9KO1EEl3DfTETHA
         urRN3eSZlzSBH1qhfgs3bk3Ua9NnH1qb3qWp6GlzLqTrtrGZM32hwFqkxokhST/gmYFf
         fRsrIhcnWmpa9JeEOQo3KFF1WgVhZKAJCe79/8kzUA5/JiIv4xS4qq9qGKJY3friQJ/S
         O6u+mEyg6f9bOt07VYkvJw/Uv1kPH4sQMEEbo+ThdialOiu+gFJOmczdPb/dVllM0LYB
         82ew8KZS/cG3KFSawxRNrIx+lXLIWVTiD0ZcXgx5l0wkgNIzqYkh1dXcMN6O/WV4R28I
         DkcA==
X-Gm-Message-State: APjAAAW8GKb0oRAsXsCdNoh/HeOw5YBo/FxUONyGxauWU0ffAn6CGGCf
        3rWPyxQMwYX+EKGYsZA+Vkwyy48SL3WkIw==
X-Google-Smtp-Source: APXvYqxHg2Ygnp26cVHQ0LOlW3+BeptNQxWL23NVMevIXQ3iqmz7/azOX151InUQv8JQWr+VQkKncQ==
X-Received: by 2002:a5d:62d1:: with SMTP id o17mr6606122wrv.9.1580400965038;
        Thu, 30 Jan 2020 08:16:05 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a132sm6738801wme.3.2020.01.30.08.16.04
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jan 2020 08:16:04 -0800 (PST)
Message-ID: <5e330144.1c69fb81.79433.eb55@mx.google.com>
Date:   Thu, 30 Jan 2020 08:16:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.169
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.14.y boot: 60 boots: 1 failed, 59 passed (v4.14.169)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 60 boots: 1 failed, 59 passed (v4.14.169)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.169/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.169/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.169
Git Commit: 9fa690a2a016e1b55356835f047b952e67d3d73a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 39 unique boards, 12 SoC families, 10 builds out of 179

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

---
For more info write to <info@kernelci.org>
