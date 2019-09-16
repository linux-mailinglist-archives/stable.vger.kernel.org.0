Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2D9EB398C
	for <lists+stable@lfdr.de>; Mon, 16 Sep 2019 13:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727479AbfIPLil (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 07:38:41 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34471 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbfIPLik (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Sep 2019 07:38:40 -0400
Received: by mail-wm1-f65.google.com with SMTP id y135so7136567wmc.1
        for <stable@vger.kernel.org>; Mon, 16 Sep 2019 04:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pWflVpSu7yLYaDI6fjUSr4EhnMyA6jUQ7Wk7d80Lm+8=;
        b=eQR9/xyOj1+rjOMwW9wp0Edbq+JAeGNNrc5PfPAIyS0+h+adAcFypCQ4mhy8j+yFQ/
         LiHfX4In1Bh22uTGww9l5B0B3MRRnhgkNjWowlGhQUMzyjcbxl/3X+8nLuCKoTj7YYY1
         V7TozSY5EnGYnZSUofVd/szXbsSOw8hC755u+2Qnc8eGNiNZctYrzJxQtps5sFNITjWX
         S0lVPOd7n0kkYVQUFxfxYHDnYZ901hCQLlOOgBx/YXtT9H0vqq+Ddd8Pl6fF2qFxPh30
         dFQZMgXeFQ09cIWUzhELpvh4NSZYD9drk4XeieRbX9B3sXJlEFjWfybO9l3iRbWTebvT
         B/Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pWflVpSu7yLYaDI6fjUSr4EhnMyA6jUQ7Wk7d80Lm+8=;
        b=IKX/nYlyTN+Nzw+o23RXAH2pqG/MHs67JtmdR6drpE617n82LZIuLu+NvrIS3wG7jy
         NTFJk+hp/08E3YweDvm98imh46la8MghO+jQFDx0jxv0Hr2B010mk+/0w9PdETjhOMD+
         OB1H8We6H73RjxiTcLo7Vmjd6SNChigQcAFI8YDaB6yZTlIwVfAoLIGGDKTWEHrSw6pO
         r/ZehU8lO5c7CRAlEbKYlAT0yOGXd3nfvL3MDFjm2RD+MWfQZBwybTYgst3WUuIwuxe4
         q2FBoG6D/hJ5lQfD2IhVgm3AcZDEo3dgt+cDgnkKY4RWaqHGOABi6wAU6MWM+KFc9aDv
         43wQ==
X-Gm-Message-State: APjAAAX5GWCfjkGe3yhUHx6wOZcHe2/ee4sar2gI6W+YhE+fL8O3Y4lq
        nCB/o8/dhYH2WDGZubM/p9h8PGch5qg=
X-Google-Smtp-Source: APXvYqzu1EWM7zSS11CX3Z/A+wdVJfSq9lELVRv3sXM3pgCxyAeTA8h4y9swwKGkPhIC2eSUs0EKvA==
X-Received: by 2002:a7b:c013:: with SMTP id c19mr12918007wmb.34.1568633917770;
        Mon, 16 Sep 2019 04:38:37 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id h7sm9977701wrt.17.2019.09.16.04.38.37
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Sep 2019 04:38:37 -0700 (PDT)
Message-ID: <5d7f743d.1c69fb81.aea86.b220@mx.google.com>
Date:   Mon, 16 Sep 2019 04:38:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.144
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable/linux-4.14.y boot: 84 boots: 0 failed,
 83 passed with 1 conflict (v4.14.144)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 84 boots: 0 failed, 83 passed with 1 conflict (v4=
.14.144)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.144/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.144/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.144
Git Commit: 968722f5371ad5deee23fc20269fdc44c23014b1
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 39 unique boards, 16 SoC families, 11 builds out of 201

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    multi_v7_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
