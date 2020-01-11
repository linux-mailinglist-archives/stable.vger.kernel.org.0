Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7291383DF
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 23:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731551AbgAKWyR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 17:54:17 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52980 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731594AbgAKWyQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jan 2020 17:54:16 -0500
Received: by mail-wm1-f66.google.com with SMTP id p9so5712954wmc.2
        for <stable@vger.kernel.org>; Sat, 11 Jan 2020 14:54:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wEDn0zcV6HBFmZbMYvwjQ5n0fTJOUZEM2XCszSyP610=;
        b=GdvWNQ3SgOo8guIGPEI3sv3e8YNDzwVmnVMD2lxZ2vOnXBSHtIvkMYgdGbWna4DsdP
         fYHyHwS+eh2vWXiJ36ZHGM0/krlei5fOJf9+5YL8/jjlamE1yhs76fau76SsIfKbtXue
         6Yf8pQZGgcEJZYWL1R7BUOIfunLV0OG3JjB5OSJ79dDviu/z6Nq6M1OgE1/RsKbAuQ2o
         KyWBSrX+zsqHNclku7fEJvQmc40frNHdkHVGWmkCk6nWP5XcDCoztO9s1j7Z1PemyZBa
         rDr38tHPoPIaw0yIZtBodbBV2dC5SHv4CxGOzF2sf/QhzdkLmUCnIioKD9T+vBO3XPCe
         tG3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wEDn0zcV6HBFmZbMYvwjQ5n0fTJOUZEM2XCszSyP610=;
        b=fRnrjKc276/RI36hbpM/k6SUTaFQdi6q3Eo3pdFQp8arab+MZL6k92vnt7bBnmDPzj
         M3RmrD96nbGa2pwi1aAgSDtlKxZuOpKlfTpYORVI4iF9+4MD1Sr8UqwYbffVhN4or3WY
         J0kON/ZpvY8uU0WZUcwmWI7a1VMdAq2YRuRyM32Y2SGMOlY5ScmfG368oaBqALoyIb3L
         X+IAyklQZ6jkieK8KHX4bjOYYgR5S/zxAKknH8fbYRB/wCyTmsn3ghSgv/RkR2cJd96Y
         2kIB08yk3dP4TJwvJBP+56XC8jPuWRVDnVxeJgGfjFODdnAHM1V0lhzhtx+GIdkJf73E
         eWTg==
X-Gm-Message-State: APjAAAX0auSOQFArlUJx3VhM5Ayd2RHCd2SEjCSRXDheEE2kU832CdDv
        H7pyXbFeGsoAcgQfjK172S4/llv5ErJLJw==
X-Google-Smtp-Source: APXvYqwRqfBxxR9PJAOAP3hw97VR28dOWcJiZmOKAqTzfLxZMb1GeyD+S9uFNXqAMcyntDEafz1JIQ==
X-Received: by 2002:a05:600c:d6:: with SMTP id u22mr12273616wmm.77.1578783254928;
        Sat, 11 Jan 2020 14:54:14 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g2sm8122327wrw.76.2020.01.11.14.54.14
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jan 2020 14:54:14 -0800 (PST)
Message-ID: <5e1a5216.1c69fb81.6926e.26aa@mx.google.com>
Date:   Sat, 11 Jan 2020 14:54:14 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.208-60-gce8c9a6be3d9
Subject: stable-rc/linux-4.4.y boot: 49 boots: 1 failed,
 48 passed (v4.4.208-60-gce8c9a6be3d9)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 49 boots: 1 failed, 48 passed (v4.4.208-60-gce8=
c9a6be3d9)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.208-60-gce8c9a6be3d9/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.208-60-gce8c9a6be3d9/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.208-60-gce8c9a6be3d9
Git Commit: ce8c9a6be3d9aebb56382d5a4409a7cd44305989
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 25 unique boards, 11 SoC families, 10 builds out of 190

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
