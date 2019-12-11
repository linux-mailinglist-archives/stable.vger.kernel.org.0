Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70B8A11BE0D
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 21:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727489AbfLKUi0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 15:38:26 -0500
Received: from mail-wr1-f48.google.com ([209.85.221.48]:35601 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726242AbfLKUiZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 15:38:25 -0500
Received: by mail-wr1-f48.google.com with SMTP id g17so155331wro.2
        for <stable@vger.kernel.org>; Wed, 11 Dec 2019 12:38:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZgpTALvCxZtpn/coHdo8q2GnNFUa+4VWx05k6lWc9tk=;
        b=JJfNYFrNfzFfcmxt+dxb8s1mWI4zrUwDSKMJASi8SoSjf0Gt2ibYN+JsYNOZ3x1qhP
         PqZdj6v0gSTACJxS5joX+GaxhXuch8akd/FzMjkX9gzVG4TroHpAMMEnEOOkgAls7Eau
         IWnhHGAXnPS8bYBkzE3eEpGcNPRHGb8nhOIRLUQLghtzX2AnoT55/TQ+wEWCVlYOjTcp
         JSVrOfAsXSFQjCYNgmTFAbcoTreHyq7G+6eT9z+ZT7eAQfW96nhXdfwD9dqkNjMtOExA
         MPmMk/RG6WlXPc62BvL2QaswPsgkxvHAqZQa/1vSZdm990QExQDfSI59Qb25f6wEolGQ
         RmDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZgpTALvCxZtpn/coHdo8q2GnNFUa+4VWx05k6lWc9tk=;
        b=IjuzHUO3bEkmDiSJ/5yrPJ7q1dBlmi8J23cDtfWo8d9MkjPW91Xhf83K2sHsLvM/ct
         2E6+dzpwO9rrTLv9aCgTmHwq7THm03am3BErnNqAg79fM1beDG7TC01ycYjMu+uzWwSc
         XKzZSRTI2i2RJRLSDmhFcsQ0iHBqtvFkUaThc8+UT5Ii9F0oktKdA2HdJkXB1qBI5PEL
         T/G10FZ3/sHdnp43wnfHbG3lZPsLQsy0AcVoWZ7Rwtl0YN2BJ1MRf7itvcYBgfN3m1Y6
         AvkcZyF17twl/KaZUZ6VM4Hnn8A9nT1Gyn7HIwP7hsdO8ZNR90EqXJKa0PtIbHAv28wu
         gTrA==
X-Gm-Message-State: APjAAAXbMPKSSokRWjeDebo1MeWy/nw12vNl36/izZMxLFyG12JHr1SU
        q8OlpmUQhkuPVgGw5yXwoc0ty67xPU6G0Q==
X-Google-Smtp-Source: APXvYqzIlC7BIuPqzugmqLw28TmxcowJrsepE6xrwwlyRXLly3GqtQP9nJOMJnPETbVIf/xfowa1PQ==
X-Received: by 2002:adf:ec48:: with SMTP id w8mr1870888wrn.19.1576096703477;
        Wed, 11 Dec 2019 12:38:23 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z21sm3582667wml.5.2019.12.11.12.38.22
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 12:38:22 -0800 (PST)
Message-ID: <5df153be.1c69fb81.9eb36.239e@mx.google.com>
Date:   Wed, 11 Dec 2019 12:38:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.206-92-gede24ca9232b
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 63 boots: 0 failed,
 62 passed with 1 untried/unknown (v4.9.206-92-gede24ca9232b)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 63 boots: 0 failed, 62 passed with 1 untried/un=
known (v4.9.206-92-gede24ca9232b)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.206-92-gede24ca9232b/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.206-92-gede24ca9232b/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.206-92-gede24ca9232b
Git Commit: ede24ca9232b565f0f6d655b1670e89e25814bb4
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 31 unique boards, 12 SoC families, 12 builds out of 197

---
For more info write to <info@kernelci.org>
