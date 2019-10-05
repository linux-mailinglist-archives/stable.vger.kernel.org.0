Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F34ACCBDC
	for <lists+stable@lfdr.de>; Sat,  5 Oct 2019 20:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728245AbfJESDq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Oct 2019 14:03:46 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39555 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727466AbfJESDp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Oct 2019 14:03:45 -0400
Received: by mail-wr1-f68.google.com with SMTP id r3so10712390wrj.6
        for <stable@vger.kernel.org>; Sat, 05 Oct 2019 11:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=aG+DdpxErZCL5qcugZDYxbBbaP0DLahXxw//3THWCLY=;
        b=c7nTaH5e/9x1RtVyzyas4B3yv1yD9VjTcSmvlbLBQ/GUiG2jAoDkZmLEfY1/HAX4sB
         butltEZFiTWsAwKDQHt/QFpzQb+mkQHHMHVxJRjTq1BmucrhZH1uyEQKazrqM2enP0vB
         cnNXsno4of/P8OG8CX364Bi9EnuAFBrwK9o29Pj6hktyEHgIETu5j61t02tnWfcgFLct
         dZKpZDdvBiO0SXVitF7M1r8Bs54DbLindvnhQxay3tfXp4R+EniZi/DtyQOsWGM+ajy5
         wXBJDhdTWjS22PxK53q7GvfhhhDjnCiZm+ge1loJwVihEtpkV84OBtN/KQdAfAygq5jT
         Y0lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=aG+DdpxErZCL5qcugZDYxbBbaP0DLahXxw//3THWCLY=;
        b=sphgNE+SybKTtHz4rT59W6lBodtK0CHkQtLVY9PfCWsChsLesLxPdDO70/6vMDOZo9
         to+QLQ/DsfVRkpoEwBluOYks7F6yG3kcm/o5FazYiPiR6+mLHPI5oTUZbZcCUVr0XajU
         KYst8zLCIcoi0Fk8syOxty2w47z0+A2dzr4A4Ve3jxzLjDFr9SKPx1clNmAXk52LGjfS
         PiFHz0tCUoNV8nl+iahkQls0alookPxr6+FxsKachbHwyfhqfJbXDFMOGaTpvtTNf8nZ
         KUFzsosNqnStu61rmhGfc8oYwygOiB8z/rI9j+9beRa7H7vwRwIurX6SrS2l2fC+Cxum
         Wn9g==
X-Gm-Message-State: APjAAAUBmsK776Wqtm70PwKz+St1qYN9AFJv6tCpahfTyECNzf93Uwqf
        pUVE8an6mp32TmOZuEnyMA9JUA7NuCE=
X-Google-Smtp-Source: APXvYqxCE7wJQ9ZyZN2H1FVev2Y3dRfLXxfxOGy2CIZMuEIewt5FC/+jybaugAFVIHnnO9cm5FMPGA==
X-Received: by 2002:adf:fd0f:: with SMTP id e15mr4876271wrr.187.1570298622167;
        Sat, 05 Oct 2019 11:03:42 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id e3sm9031940wme.39.2019.10.05.11.03.41
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Oct 2019 11:03:41 -0700 (PDT)
Message-ID: <5d98dafd.1c69fb81.dec3d.7bed@mx.google.com>
Date:   Sat, 05 Oct 2019 11:03:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.2.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.2.y
Subject: stable-rc/linux-5.2.y boot: 62 boots: 0 failed, 62 passed (v5.2.19)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 62 boots: 0 failed, 62 passed (v5.2.19)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.19/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.19/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.19
Git Commit: 076d9f965e561de3557c0cf9263b157b1c7380b9
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 43 unique boards, 16 SoC families, 12 builds out of 209

---
For more info write to <info@kernelci.org>
