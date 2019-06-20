Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8234B4DDC9
	for <lists+stable@lfdr.de>; Fri, 21 Jun 2019 01:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbfFTXeW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 19:34:22 -0400
Received: from mail-wm1-f52.google.com ([209.85.128.52]:33193 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbfFTXeW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jun 2019 19:34:22 -0400
Received: by mail-wm1-f52.google.com with SMTP id h19so7910023wme.0
        for <stable@vger.kernel.org>; Thu, 20 Jun 2019 16:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1rEMOSLkLXhmvZY5HuOSKmGg6oZ+XQwBc/8alhmFjh0=;
        b=eYaNu7ndfDEq6sNe+AlStZIvvsk1TNeyXcJtVf8kekkYhTFgvghYnFIUdHLd3wi/Gh
         QqShmRGczRgTeWe9iZ6t39clMv6tbqcckMCATbC75fH1OakNGSa4+C7JGSrRpor7CDAQ
         nzzZo1UH0afK5a5E5UGbO4ThZOuoQ+495FMynYacc4Msrvut8WfNSZUlPgpuerN32jTV
         7j833FhBbsPIPr12XAJ1bK4tGsCC3QlHGP9blrBN6hARz/DHefcMjXXKTTtzYKFxcSCZ
         TR+zh8w82QvAzSUtxtWgSxB02Cdw4bxHlUK81ulaX7NQMs9bnsPJF0/v/8usJBnMOqiF
         VmSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1rEMOSLkLXhmvZY5HuOSKmGg6oZ+XQwBc/8alhmFjh0=;
        b=O9bPoOLBur8rF0uIdWWWzmMphvkak7te4mAYT7Vzksh1+ujQAXeEGvpPRoKslWYHb3
         vZQ2530ddWueKKEwniBguL7pegbAdYmoIOjbuprBWQ/GRBbNbGOIEz9byCOrZBSoyY5/
         nfLTJY/KF8UEaI71QTTueop9lFZ0IXZPDYucrvIgHSBxhiRXU9zTE6qF0o+33Tl2D087
         7wjb9pYrvoCvxfXSqrLapHOQMWbVUXECqmwwytnWGYri0GOOAsn11JrbpWdakubJYFOc
         Mda50FMyRSAqn4Das3OThJsY2tIJ55aDjPL5iWTyTNbY6haIP6i7mERGDHmPCDyxMp2o
         BZTw==
X-Gm-Message-State: APjAAAWZAZ6b4kypF7ePX8uc4Vu/8VT1tZCsaR2kc8brFPpayduXukFD
        Kh4XEOMzfkCdHkJRZfzMEh6Q+zxNAZM6qQ==
X-Google-Smtp-Source: APXvYqxUncvujJUh4QHaXNszpGPO4tIwR0S236Jingp7oCCZwlpF4zgFp5N2iIgoxK5UkcININyT8w==
X-Received: by 2002:a1c:7c11:: with SMTP id x17mr1151169wmc.22.1561073660290;
        Thu, 20 Jun 2019 16:34:20 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c17sm608765wrv.82.2019.06.20.16.34.19
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 16:34:19 -0700 (PDT)
Message-ID: <5d0c17fb.1c69fb81.4173f.3893@mx.google.com>
Date:   Thu, 20 Jun 2019 16:34:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.12-99-g10bbe23e94c5
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.1.y boot: 130 boots: 1 failed,
 127 passed with 2 offline (v5.1.12-99-g10bbe23e94c5)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 130 boots: 1 failed, 127 passed with 2 offline =
(v5.1.12-99-g10bbe23e94c5)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.12-99-g10bbe23e94c5/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.12-99-g10bbe23e94c5/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.12-99-g10bbe23e94c5
Git Commit: 10bbe23e94c5975292d0a3ff74893d1625c1e07c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 76 unique boards, 25 SoC families, 16 builds out of 209

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

Offline Platforms:

arm:

    tegra_defconfig:
        gcc-8
            tegra30-beaver: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            tegra30-beaver: 1 offline lab

---
For more info write to <info@kernelci.org>
