Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39F9D14D501
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 02:34:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbgA3BeU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 20:34:20 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44649 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726618AbgA3BeU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jan 2020 20:34:20 -0500
Received: by mail-wr1-f66.google.com with SMTP id m16so1895008wrx.11
        for <stable@vger.kernel.org>; Wed, 29 Jan 2020 17:34:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+rfyVesWLhuTsOCPKZqHSQR6D6RMGKRQxHn+eD6oalo=;
        b=bgoZe9DNJ7DXZdb6VCF2BFaCv0h7k9jMU5oRQdqGjpAEC6mHyTVak15MvtDXAlRKE3
         yGXw9vUGfDs07XX/X0h6TY3lN8QIzKVy1DF43NWEyNT+z+yUAGaUFrfBuSG7XW6I2pfN
         i8c1WkIxmdL6mK2c5VP2ex6+/XxrOP8mnB6qTB1m1CUxwgzqeZ5uuc9/vLoXuj9jcK3g
         L6EzCGpzLAIcd0K5I88RmN/CPGxshwKzpd88pk3X6i3+U3FNwrYDBE3uqf3h39wiSMEs
         xZi1lnazyVXBy23JJxs8o3ply6tlbetNfVIDOU5xxWM8M0co9n+o2neH3bNPSqkOaFmD
         FzjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+rfyVesWLhuTsOCPKZqHSQR6D6RMGKRQxHn+eD6oalo=;
        b=L1UnOmc/hii62Yf/vxlivoWYH/+g6X/CpI4V1RK/1fzYT7WtI0BGb6sZQzUt0fI5ox
         terND9i3p+cMqLOQxa2DI2S93B0nis28KC/4vSQ2Dk2oc60uQpASyGnVxV7tpKJE+dLb
         NKWzqYQhXFRuB0yPybuDD2x90H1wMeaHkF6i6i/MwcFjCLRchdZnsVkjHfwlTqE0o3L3
         saVYwp8iOyztt59NIU57b2rsHTeViZKmX/OF/Fi79j1ofJ3AJTsPVmXtBzt5BZpBS8GE
         tWNLZtn9UEkrA1BinSWLYEnW3qmteJy21rbfpXGIkJkmXyUzMtcaIXf+67lC1cCvo7Aw
         rgVg==
X-Gm-Message-State: APjAAAXCxroMIPx7qTkYqwK8+9BAj86QP3cp3wSZn++VIrbaEpFqFQR2
        2khCLZH/K7TAcrSeFD9r38HvfWnuwC/Y1w==
X-Google-Smtp-Source: APXvYqzZ1cNAe6qFqKKF5HOKNcZ37LKAYPpQCr6Kg+073NHpUtD/uhLAer4Tas7fdnfpJDEiai8zrw==
X-Received: by 2002:adf:dfc2:: with SMTP id q2mr1959705wrn.251.1580348058413;
        Wed, 29 Jan 2020 17:34:18 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id k7sm4200424wmi.19.2020.01.29.17.34.17
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2020 17:34:17 -0800 (PST)
Message-ID: <5e323299.1c69fb81.232b7.3ed5@mx.google.com>
Date:   Wed, 29 Jan 2020 17:34:17 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.212
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.9.y boot: 18 boots: 0 failed,
 17 passed with 1 untried/unknown (v4.9.212)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y boot: 18 boots: 0 failed, 17 passed with 1 untried/unkno=
wn (v4.9.212)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.212/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.212/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.212
Git Commit: 6f8dc95670980e30a1de22c75999d61fd143b693
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 16 unique boards, 6 SoC families, 6 builds out of 166

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          r8a7795-salvator-x:
              lab-baylibre: new failure (last pass: v4.9.211)

---
For more info write to <info@kernelci.org>
