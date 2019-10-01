Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB700C344B
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 14:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387849AbfJAMdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 08:33:00 -0400
Received: from mail-wm1-f50.google.com ([209.85.128.50]:51047 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387825AbfJAMdA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Oct 2019 08:33:00 -0400
Received: by mail-wm1-f50.google.com with SMTP id 5so3196545wmg.0
        for <stable@vger.kernel.org>; Tue, 01 Oct 2019 05:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8MW18BdESPNBZO6renjo2QKDuMMd78jPMErcrRzzJGM=;
        b=i79E8iY4Uo45KeyQMUEqpnuiyE8xwqchTDK4i3Y1vvQkPaoUoD63RpI8s4/FEeMWiF
         TtESe7VlV0jZjj3hdsGw8w8/r6DOVd5lbRwQUuUy8Gxo+ClfSBkYmGZa4igSCbFEcH6c
         K7z2k9GGM91ziL1YQzfP2zesT24mp6ErDoGM/RFQ8MDcVSt3S2yMK965vanhmt5DnH6r
         juG3LTfhVqn+9ksDlR2aq0Kih9a7gZ34hg+t/TwZ/vlJ0EbyFvZbbqGbBU5Kv5zbHGez
         O/Mb+jL9xQ1nAVW2T/2mwYqGoIG+yElljnRHk9NdEjpzVZAMVuMgoUOr9khNqB4fgt77
         TkNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8MW18BdESPNBZO6renjo2QKDuMMd78jPMErcrRzzJGM=;
        b=beI2Zbpk1OQAo3NCGjq6lIDV5x21bM1k69k6nQDrTXMmjTryjkDdhBlrmMgrG6PM8u
         KyQZAuOuU1Y1XQv5UN0wZ8vj6XKz9cAGpLezFD416ax6ZDvULBfjW5FakK1IiAhMEDgK
         zkaAPqQCTn8ztwcmIUiSWJokCnNFcYH/jOgSHEdi0tl4SZOCOFNRR0xYpijYNUBGtiFf
         9wzPVyPmzuPn4j9VoTL8PCw1mLipjOwmwsOGzIcSvhvszg+aoYQDFkY/sU2QK/ie32dS
         Cd5JEcc51GRH6f5x+eYG5EfRuaDX9vgPTWftZKzRgXtzlQAWsvMKZE6lDNFXDb1rxreY
         58Gw==
X-Gm-Message-State: APjAAAWwB3uDF076HGGHNLvXW+vYnCrVkQVJiJErO+AhCBFQjmqAz7QZ
        9iew9h54Rg3xsO2KZxlQ7Iyi0/C1DDKXfg==
X-Google-Smtp-Source: APXvYqyuOhtqi3kdz8yMipe2EUUhoU/nLYD5JxfYErm1M5TVSAJpQlFlenHwHDpjiw4/5or5wh+Txg==
X-Received: by 2002:a7b:ce0a:: with SMTP id m10mr3470372wmc.121.1569933178268;
        Tue, 01 Oct 2019 05:32:58 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y186sm5842108wmb.41.2019.10.01.05.32.57
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Oct 2019 05:32:57 -0700 (PDT)
Message-ID: <5d934779.1c69fb81.1ebb5.c76b@mx.google.com>
Date:   Tue, 01 Oct 2019 05:32:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.2.18
X-Kernelci-Branch: linux-5.2.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.2.y boot: 89 boots: 0 failed, 89 passed (v5.2.18)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.2.y boot: 89 boots: 0 failed, 89 passed (v5.2.18)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
2.y/kernel/v5.2.18/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.2.y/ke=
rnel/v5.2.18/

Tree: stable
Branch: linux-5.2.y
Git Describe: v5.2.18
Git Commit: 0a9d6a58b4acfa52384b3175bd3d0742467bcf65
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 52 unique boards, 17 SoC families, 15 builds out of 209

---
For more info write to <info@kernelci.org>
