Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93A47114175
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 14:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729236AbfLENam (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 08:30:42 -0500
Received: from mail-wr1-f49.google.com ([209.85.221.49]:44440 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729048AbfLENam (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Dec 2019 08:30:42 -0500
Received: by mail-wr1-f49.google.com with SMTP id q10so3567288wrm.11
        for <stable@vger.kernel.org>; Thu, 05 Dec 2019 05:30:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HlILHC1IimDK2cMcCcytkUsKEFYW7Y6l/lNabN4K+m8=;
        b=C45r1YgltGY35d8Dp67FFkzaD1QEY8LAjcuikDFYRReo0SswHCPJR386k4ZrJPLIpl
         n4ZsC3IQOGpGjanKetjaCRJyzbwSWHYVW8rnkiTd0GW4SbG6fr4K8A63VnOB9APjMgHA
         J+ABE0C5CV4IUYbz80Qg7AzLWXoOyKpKLaWtg/v3LGlluHDPrS7v0zR6GdNVscn2Dp7n
         IXdw+ZtDc3wHN9F4qGeJ4wO00pfsAxRujqyucjJMzhkPv/5648IwLBjUdTlJb/uDJquw
         5I2q90jKoheTXvXa4jo1LE4K5ucWI+Ko5N7MGk+lS14ev5H3VxrFUuNjUlVTh8uDXz31
         2LQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HlILHC1IimDK2cMcCcytkUsKEFYW7Y6l/lNabN4K+m8=;
        b=HlIrCQ87+HAX1eO7aeaHM3eC9GDAauin3CNuh+96wfDSSLskyHiwmmO0lziZHDqkEV
         6IvzDeqiPxW+XpFiQLisnYpFk2C2FcFiIVxFYb/HX+abBaom3w3t0DUDqjNRcu8BtY0s
         WA64Z2SLaUz1zrPzdymfCw/IK29vSZkC3fv2VBAKybFbbNXaK8zpH2y805d8NBEZNWSi
         QpNBdsUWDlRQG4/625xaPAKykmMxCjeJWkVrdRe0grLQuR/5bBHMPOEzbqgEgALfvDNS
         Pfosulig35MDXMjl4CzoiBC/RKsMjq4u0qsLkrxxS01s3ov2EVU93UTrIUDEDlr+FpnD
         GyPg==
X-Gm-Message-State: APjAAAUMuNCsiuGTpxeTOLEbwZp5ePglQRAhnYR6alDUghDIXszWlot7
        Toqe5Mq7t7NoZZ+snuFYi59aItiJqnKaaA==
X-Google-Smtp-Source: APXvYqxALAdS29qwpjN9gl9yMGKxtOVbbFr3h3QmoDE9shm0JTY/sE1DqgU0iORQNabm3G1F399AkA==
X-Received: by 2002:a5d:6ac3:: with SMTP id u3mr10551772wrw.25.1575552640627;
        Thu, 05 Dec 2019 05:30:40 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o15sm13125893wra.83.2019.12.05.05.30.39
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2019 05:30:39 -0800 (PST)
Message-ID: <5de9067f.1c69fb81.fd6e7.3aae@mx.google.com>
Date:   Thu, 05 Dec 2019 05:30:39 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.88
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y boot: 88 boots: 0 failed,
 87 passed with 1 untried/unknown (v4.19.88)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 88 boots: 0 failed, 87 passed with 1 untried/unkn=
own (v4.19.88)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.88/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.88/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.88
Git Commit: fb683b5e3f53a73e761952735736180939a313df
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 51 unique boards, 16 SoC families, 15 builds out of 206

---
For more info write to <info@kernelci.org>
