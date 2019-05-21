Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C51425A2D
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 23:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727174AbfEUVsn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 17:48:43 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:38116 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726907AbfEUVsn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 May 2019 17:48:43 -0400
Received: by mail-wr1-f46.google.com with SMTP id d18so20275937wrs.5
        for <stable@vger.kernel.org>; Tue, 21 May 2019 14:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nF40Mer+CyTZlTiDCgtLb+gprATpGFZJ2EL8IlGG7HE=;
        b=llwZOuVLkBPdd6VLFRGda6+R1Ma/QVsxrkZl08nOMHAyzXD/InctjX2juPhI1ZgPdI
         f7aLclDYCO8X+3Wd55CkiU6NYBc0P28ftsRJ01ekS0quaINmsE5A8kk9Dyk11FBxzT9o
         LJoCHZKeHdLMqom1aKV0kII7Xm3j5WbYBfeUlT6rHcCmt+K/7mC5Bissby3ENr/onW3l
         uD6nzXNu+g4YrZoH3ZDjQUg8xN4BukCF5hETMZVOviWyKkFg35gXoELbjZvkW9uoHYFG
         SIIVJHstVBV+KR4eQs94q07OlsZ1KoqofHwxQvJyqiln+VHuCTKm7X4X/FpRT7WBkizw
         ag+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nF40Mer+CyTZlTiDCgtLb+gprATpGFZJ2EL8IlGG7HE=;
        b=AKfwa9+U/F8753qLtShrzw2gC4WJAwiXipPJ1udijlSiIKJjGCZmKxCFj7vCq/8J6Q
         Cm24fScsQybMiBnPXEVXIWqbAPtOxP6s/pHGGP7n1D959EhhEFGYiXK2oE+Rf6Xxsyiu
         6aeef0J3uDrbU4SrZ6k8glze9Ak0W4FMMd3BLoW28fXmpenlYwd7TVKliQkrDCVK3hWK
         VkLfMlgYg6MiLMvxxm6u69csLZ0lYvKFXMvJrJVllBBL05sV0HqROb/3cac0+ayEUfH7
         aYxrKix/tLXvNJnVvbOXbeICIySIMxD8XcQOJ7iujHPT2Pmzvw/XZcwcOdVYe4tfkEsg
         pEvQ==
X-Gm-Message-State: APjAAAW0xGU643/qKIAq8ta5VdgniLuPkEuhVHex6QM38mS5f9kHoqa0
        R/i5LRiCx7O2pDuFL+zzr+14AlQ8D3z/DQ==
X-Google-Smtp-Source: APXvYqzSa1ROxASXDyLmLTh36ZNQb/G6bOOsoJ+SW6WsK4gOJ4wAQRwcgNW0giU/6Hpp/DPT4TmFpA==
X-Received: by 2002:adf:ec8c:: with SMTP id z12mr42272449wrn.209.1558475322027;
        Tue, 21 May 2019 14:48:42 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t66sm7815646wmf.39.2019.05.21.14.48.41
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 May 2019 14:48:41 -0700 (PDT)
Message-ID: <5ce47239.1c69fb81.189f5.665e@mx.google.com>
Date:   Tue, 21 May 2019 14:48:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.178
Subject: stable/linux-4.9.y boot: 42 boots: 1 failed,
 38 passed with 3 untried/unknown (v4.9.178)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y boot: 42 boots: 1 failed, 38 passed with 3 untried/unkno=
wn (v4.9.178)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.178/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.178/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.178
Git Commit: a5f56b52c878585b12b8bc37f737dcce4a660c64
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 20 unique boards, 13 SoC families, 10 builds out of 197

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: new failure (last pass: v4.9.177)

Boot Failure Detected:

arm:
    omap2plus_defconfig:
        gcc-8:
            omap4-panda: 1 failed lab

---
For more info write to <info@kernelci.org>
