Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 421F7DBC35
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 06:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389944AbfJRE6L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 00:58:11 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52310 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393732AbfJRE6G (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Oct 2019 00:58:06 -0400
Received: by mail-wm1-f67.google.com with SMTP id r19so4692343wmh.2
        for <stable@vger.kernel.org>; Thu, 17 Oct 2019 21:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Qrd+uqjewjZCrHujpXseNa75mr2lrfPIQg/ZOtdpnzE=;
        b=CQKJzeI2O2yskztc7bKLBwHyj5BfZ+3dRc/L1N7qaYu9MM+J2yuz7h7saHxJT3FPIO
         8y8bb1+XKryCR1lUaMvlr64/ld1Q8Y5KXP1gv+2Scc5phTZwJ6EJGu7pDLmwmUpRG1EW
         RpQwWczriSBsT76v/XVPx6NeZ5LnDuRSjXR7ewRx38NGq5hKStSA/P1cpQUtUw0nIe2T
         4TT+dPcwQSNahqU4T9WJ8rPEUXqURNC1G8Wly8HfLOobXDX2//WEA+t9vUdZYHHWlhso
         dWLdeuvhrzMQPw8VW+eEw+ghdDyobx8yJ7d5+gLP8CngpI2RKl4iOm4o8hoABSbPRZ/o
         PyBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Qrd+uqjewjZCrHujpXseNa75mr2lrfPIQg/ZOtdpnzE=;
        b=RclRzjDswvBDEDZBYRz5Cg+zJ08THhnyM1nxmKPU/cE6DBgMn49kPja3Z26RCFQEs2
         AN5QqERJy5SZOxse+QdX5yzaqO/fevSbm+vGQlsHWfG/kSDDIhXjyah8GwLaQIVFgyS6
         L5TjESB6M4Ru3ID2I34ufmYLtdTsRSCq8wxmaEvGqLjLlVBLMZY/BUFAPDLUz9cJatpI
         2FeggN8ZpIiyaKWOuwPbTE+8ounVgwJDcECodUMt6Zv1/DIWC1AE4IueOgSvArtLPn7q
         9CfBRI9B3CYgtZhtOh++jvM9QHsdlSAwY1NhTQHk2TFd4kmkP7t6a1EfhMk7+XifhXyR
         s8lQ==
X-Gm-Message-State: APjAAAWvyEuBhiyrvWLl6Qly0NM7HhkyQganF3hT8FylTKMHG3uHHQiQ
        SOT01MorWDcGaCdkJVcDVwuHtkiNw32M+g==
X-Google-Smtp-Source: APXvYqzy88R9o0DsH/5aFaBCrmDJwKHG4BJA9gpe+exH4YJ5WCcABMgumbJpstxNHjtrHYFqxMCB+g==
X-Received: by 2002:a1c:6308:: with SMTP id x8mr5729675wmb.140.1571372929042;
        Thu, 17 Oct 2019 21:28:49 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r7sm4063584wrt.28.2019.10.17.21.28.48
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Oct 2019 21:28:48 -0700 (PDT)
Message-ID: <5da93f80.1c69fb81.18020.5147@mx.google.com>
Date:   Thu, 17 Oct 2019 21:28:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.150
Subject: stable/linux-4.14.y boot: 49 boots: 0 failed, 49 passed (v4.14.150)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 49 boots: 0 failed, 49 passed (v4.14.150)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.150/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.150/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.150
Git Commit: b98aebd298246df37b472c52a2ee1023256d02e3
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 33 unique boards, 14 SoC families, 10 builds out of 201

---
For more info write to <info@kernelci.org>
