Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62986F9ED9
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 01:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbfKMAHx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 19:07:53 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40079 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726912AbfKMAHx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 19:07:53 -0500
Received: by mail-wm1-f68.google.com with SMTP id f3so63247wmc.5
        for <stable@vger.kernel.org>; Tue, 12 Nov 2019 16:07:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=49PdPX+moDYC/1LhC15YtUXqFwP2lHjsWXTmAd2Fqtc=;
        b=kiSnpyGJ9vkLIKnFSvj+lLwZKpvD8Kh/e2LlaQ63MC3I+yGJliDATaBxK4heiKZKtV
         FALtot4Hb4qLVDwGlDIfu9lRqXHChbP3gC/2kO+OGHDP9w1/Y7jopNkqXcM6vbC1/KFk
         aUM3CzB5/+QY/qsgC1HSuaFkZmM5aNeCoBZt1Ttn0FWh9e8iofnRI8skX6XSKH5opLwL
         D8gkDcoEAcRcFTPeOYJRw/ppbYZlvCFxBduT86xjLNQ2gV3ky/tDfRhvfm+OxWzq0UdD
         1ItcWWIZ6KH62Xlz1Oa6kfLV7GooUu+PUJ9oDePeODwEJj1VmKNrRJ/XACy9GWmTf6zJ
         1gtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=49PdPX+moDYC/1LhC15YtUXqFwP2lHjsWXTmAd2Fqtc=;
        b=N1yJXeqogbV1HU/xZH3xmbBGWTek/83bYxM2i8Foru7PG6j1S8krhInFu0wBEX9EJI
         kVwgR4HmJp8Kyzhcr0Eq62aqGHGZdEPQAfECw14g/15k3WKpu2pG3/xd/dwg+4LEM0U+
         56nr+OTJ73jo3tzRfPZe9EYFMngyVygghWFgcr5K1DCsPVPWIZVdo82aUO8zWfMf5m0c
         +RPpcb+BPBejSLOeTLAD+H3WQ2LHMx6p0Vk37kkckCvm9AO2UH8aeUjBkGIdNvwOSvDx
         dlz9eh24QREG+c4PsvuGDzE+uChX6+3zi8F5VzHLDiBnPtBxsu0CtJR4wbehKR/F9X0p
         LlMQ==
X-Gm-Message-State: APjAAAVFmBInj6NY0YtXISVeV8Ew1ouzLB3FqrqilqfIcJKlc8dNdGro
        X0slPEa11QprvQZ/GMvwvXFHcqTCTI/bVg==
X-Google-Smtp-Source: APXvYqyFKH0UbOrsfRU1ickr4Rw5n59lAmfraBPyBDJoZm09HZKsJiZ20MehN8Q3H0zWgwkZ3WTNZQ==
X-Received: by 2002:a1c:e3d4:: with SMTP id a203mr82341wmh.173.1573603669578;
        Tue, 12 Nov 2019 16:07:49 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b14sm396318wmj.18.2019.11.12.16.07.48
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 16:07:49 -0800 (PST)
Message-ID: <5dcb4955.1c69fb81.e1191.1cad@mx.google.com>
Date:   Tue, 12 Nov 2019 16:07:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.84
Subject: stable/linux-4.19.y boot: 65 boots: 0 failed,
 64 passed with 1 untried/unknown (v4.19.84)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 65 boots: 0 failed, 64 passed with 1 untried/unkn=
own (v4.19.84)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.84/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.84/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.84
Git Commit: c555efaf14026c7751fa68d87403a5eb5ae7dcaf
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 40 unique boards, 15 SoC families, 12 builds out of 206

Boot Regressions Detected:

arm:

    sunxi_defconfig:
        gcc-8:
          sun8i-h2-plus-orangepi-r1:
              lab-baylibre: new failure (last pass: v4.19.83)

---
For more info write to <info@kernelci.org>
