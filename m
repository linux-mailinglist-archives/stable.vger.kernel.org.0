Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23CEA80AF9
	for <lists+stable@lfdr.de>; Sun,  4 Aug 2019 14:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbfHDMiO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Aug 2019 08:38:14 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37144 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726034AbfHDMiO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Aug 2019 08:38:14 -0400
Received: by mail-wm1-f65.google.com with SMTP id f17so70534480wme.2
        for <stable@vger.kernel.org>; Sun, 04 Aug 2019 05:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EkEzABRGHUOO00QWl/HxCbjJaLQe7o2woHQsgifAITA=;
        b=Z3en9rF98PY2ZPvMhcgfw8aYPlz+cMW1F1nN7ltLgHuicxgRG67ohHBe3cUBkLwTKW
         eXBnngiC1+q499DAKU/xRzi4iHFJwQ/c2cn7UY8jOQtYAhjjbqIfpzx5DZoexjRtv8LB
         7edauHi6bbF6vzHlykPje7PgbOgPA1fGG0RO2pF5CjcU+cekTcWg1WVPpncBB5XsoxCm
         GIVwYc5ZH9/mOyMG9+8e8aPep8Blebi6lFTSv/CL/toBp4D7eUtWswDVCNsta3Mcbp1d
         D0OLa8p8szjxnIXyL1rb/p4QJe3lupUxMKSPwwQIolR/zQ97D90B8D/gNFz8pp7OOjs/
         km2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EkEzABRGHUOO00QWl/HxCbjJaLQe7o2woHQsgifAITA=;
        b=seYMpCu0IVd6gIVYMwYJsITG2d1IcCaFiOFnkhYbTZAddeY3Ye90DoTyAZ2dK98/Fy
         ybA3b/q78HL8HxpFm5uaF/bsYNarxT7Atk57Bus4hkBlvP/pKzMHGqyXxJt7g1zFl/XX
         ZgRWtkM3z/BpPBbbqkQVUXTP9sxSUhmsBuEIBNPC6EfBJuYPcb7COVrdXY0+6d7OU7Pc
         IKhPxexRoq61m0+yov22JY2AjHPFRc26M7vJLPtXHv9ocM8fLc1zHHx4dU/YqKTUtGQ0
         +s8WM4aYQjb6EpLAKq1PFRfZTuOcsPR9oa/rqXT/ORyT4DGrgQqbCIGStqfWPWP9L/qr
         OlcA==
X-Gm-Message-State: APjAAAVOji+zOPQHPORHsYPdoGBbn/LdXG4OkBNfrXcAoCJQ4HkTOpCJ
        p7lAyD+9AXGAoBwS4fhJpQxucNMJ
X-Google-Smtp-Source: APXvYqyAM+3pdaFhCOCMzJRcbwEzHqIQSrng7PUsPI0JERSCECP2BScuutHTopcMcn/o0gXqfVrNvw==
X-Received: by 2002:a7b:c212:: with SMTP id x18mr13607055wmi.77.1564922292155;
        Sun, 04 Aug 2019 05:38:12 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id h14sm80697609wrs.66.2019.08.04.05.38.11
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 04 Aug 2019 05:38:11 -0700 (PDT)
Message-ID: <5d46d1b3.1c69fb81.831de.1a5a@mx.google.com>
Date:   Sun, 04 Aug 2019 05:38:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.19.64
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.19.y boot: 64 boots: 1 failed, 63 passed (v4.19.64)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 64 boots: 1 failed, 63 passed (v4.19.64)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.64/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.64/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.64
Git Commit: b3060a1a313ff7a545d658378f62fe9c250acdee
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 34 unique boards, 16 SoC families, 12 builds out of 206

Boot Failure Detected:

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

---
For more info write to <info@kernelci.org>
