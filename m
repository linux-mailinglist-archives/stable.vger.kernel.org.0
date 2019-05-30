Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB8982F854
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 10:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbfE3IKd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 04:10:33 -0400
Received: from mail-wr1-f54.google.com ([209.85.221.54]:46909 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727330AbfE3IKd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 May 2019 04:10:33 -0400
Received: by mail-wr1-f54.google.com with SMTP id r7so3495497wrr.13
        for <stable@vger.kernel.org>; Thu, 30 May 2019 01:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WtCAXTwAkrdeG9KNtGkpEqVQZWYFaR0KgJ5gewK+STA=;
        b=WTZ9Q+DJrXSz4mcJMl+rOqIIGvnfoKvSo0dE/vCBAWD+i939FyyuRGnpI8QTtDOdvT
         1TYLHPIyNMMUoPh/eNe+3HCJG5Zwv92x0qqiheBPWveWzMazSI+2+BoBViA/57OhGo0z
         8NXqCyfz80TeJuFITmY/ETVTeYu58PN4mSgaQ05q31ArvEbZD6vMAIgxyzzpsBI++F93
         flWrcjgKwibvqN/7s8jsSiYo/hzeuGUFlWJ2dJH0auC6ML8sY0oUa/kvrNiBDSu+0gY0
         j2GQmfWs5i/X/w8bZuxJxgtqR5MAoA2DvXhsi7ESFJKUAZdQPGFrW7vSlrPVSGM3VcpU
         fpgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WtCAXTwAkrdeG9KNtGkpEqVQZWYFaR0KgJ5gewK+STA=;
        b=mCVCiEpRAycZj9MfshcWFHF5QYNS93hL2fRBZVeErdicvBn72zA9RPOekh6fntxO7Z
         +dqZWDXDhsFujtml+Kh3nL4SWXjrdGzIAGk7z4iicWSZ8VauqA6ZcU2w7UDktHajwXsl
         15zv204XLlWBABTWIPh2mYhZ7hPXvC1p2AlfNlEA1vEb48FuG1rBiYuiKZvufJk95WNM
         f3lqJrwdIioMoE4DZFiubSnSceeMtxZc/A9pKOgagKFy4qQzqXAf4Ei79GOMbLU2gdgF
         pjH/apVwyhI0hR/kSziidc1FktCymudp2W7mShPiCP0iXObXnqmpLry0JiMWQRCRGpCT
         fLiw==
X-Gm-Message-State: APjAAAWIaUaPe5HNnJ49Dxe1ga1Uc4N4rgfoX/DOuHVxBLUqFqoSqSgQ
        QyydRz5PEcqXbMTDH7Qj8uhr88SSyv5fbA==
X-Google-Smtp-Source: APXvYqyd1ade/bw9kq4BGm6c2XORnndHJKCoQuUihn23xScg4Tc2FpxhrF6CQQzvrCrZpN71xh+M8Q==
X-Received: by 2002:adf:e70f:: with SMTP id c15mr1618699wrm.311.1559203831817;
        Thu, 30 May 2019 01:10:31 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n10sm6371595wrr.11.2019.05.30.01.10.30
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 01:10:30 -0700 (PDT)
Message-ID: <5cef8ff6.1c69fb81.cd319.eaf1@mx.google.com>
Date:   Thu, 30 May 2019 01:10:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.122-194-g0352fa2fdaa6
Subject: stable-rc/linux-4.14.y boot: 115 boots: 0 failed,
 115 passed (v4.14.122-194-g0352fa2fdaa6)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 115 boots: 0 failed, 115 passed (v4.14.122-194=
-g0352fa2fdaa6)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.122-194-g0352fa2fdaa6/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.122-194-g0352fa2fdaa6/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.122-194-g0352fa2fdaa6
Git Commit: 0352fa2fdaa68f3e27866e6f6a5125aa9efcefe4
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 59 unique boards, 22 SoC families, 14 builds out of 201

---
For more info write to <info@kernelci.org>
