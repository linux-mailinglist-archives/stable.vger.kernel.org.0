Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61B931303E0
	for <lists+stable@lfdr.de>; Sat,  4 Jan 2020 19:31:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbgADSbr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jan 2020 13:31:47 -0500
Received: from mail-wr1-f43.google.com ([209.85.221.43]:42066 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgADSbr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Jan 2020 13:31:47 -0500
Received: by mail-wr1-f43.google.com with SMTP id q6so45230614wro.9
        for <stable@vger.kernel.org>; Sat, 04 Jan 2020 10:31:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Wopsv9/N3dDFdOh+/XOvDAw+BhiffPH/oqRPntfCAIc=;
        b=svopz9CLGINrL64gjHEDiuX9jmb4NFB+l5Dp9Fq160ScxR/8llZx7MOgknFplrw2oO
         /lQQiqo6e39R4Lra6N8aD4W+XPyFgACXF+EmiCIjUzil2RknQe7AO9fo5tEoULNoPtgg
         kEjsRN9D6UGZPSg08QLVDoHBo4mBocOjNO0wae1Pms30Y3UlUwEJR21ViwzEJbhUtWJT
         nFXoG7bpKKUMb7zE1CifLUc03az71OqNmNBJgBRq3y43ssZokiX2yZUvlegs3a45u4pm
         yhBx0brki2lwz3Fsia9Uv4J00jUZpIp2/ocqNPORmhI+gwIePiZc/Hs9poUq0iT7szjv
         S4/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Wopsv9/N3dDFdOh+/XOvDAw+BhiffPH/oqRPntfCAIc=;
        b=ZRfKJmOeb200NBXPKxmCK1Vsns7WukAP0ols+H+/OG4QxN3eLGZ8LcpfCCTyo8dKwX
         Os3tDw/Oki+ZcDQ411NI01TtU8i7rbVywfxlilwXrphnEYL3/JLyFviZFqKf8ra/sD5+
         oPU90Cjjr+EFj+ldvQA6TFsdogFA+a0paiiI4UMKftXcjhnBfgPMylax5ACgLk9iS2YJ
         o3lUx76g4HnGW8UQaIyonfRnC+UnsgN7mLe31E9WG14KU+qFS2nVtHjAwtohoLvj+aht
         RrhDQJ2U/fNTk7Fvsu0kiThzKqcO9eJJ03qtsMC1wUHsTbTrDGzldHrgG7wY4cGJiXUl
         xL5w==
X-Gm-Message-State: APjAAAWltwdIWJCK5Md+i1GBaRMeMiEp9x5/VQFzHHM8U2wOcy3M/rFz
        H60s58J9qTLkeggMg1zb/hK/Rjte8vI=
X-Google-Smtp-Source: APXvYqxeT9pEVQ5MXMnM6qQuB8GTsGriwqwfrzSSggxZbP0qlkggnB/hxKZfYRRBVSJ0vQTb/3zpMw==
X-Received: by 2002:a5d:534b:: with SMTP id t11mr95835959wrv.120.1578162704889;
        Sat, 04 Jan 2020 10:31:44 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v83sm16766989wmg.16.2020.01.04.10.31.44
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jan 2020 10:31:44 -0800 (PST)
Message-ID: <5e10da10.1c69fb81.78f01.b309@mx.google.com>
Date:   Sat, 04 Jan 2020 10:31:44 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.92-113-g2686842f2160
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 45 boots: 0 failed,
 44 passed with 1 untried/unknown (v4.19.92-113-g2686842f2160)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 45 boots: 0 failed, 44 passed with 1 untried/u=
nknown (v4.19.92-113-g2686842f2160)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.92-113-g2686842f2160/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.92-113-g2686842f2160/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.92-113-g2686842f2160
Git Commit: 2686842f216037f0c0e44457fecc4dbf7f1a26d1
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 35 unique boards, 10 SoC families, 12 builds out of 206

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s805x-p241:
              lab-baylibre: new failure (last pass: v4.19.92-73-gdad83dacc6=
c8)

---
For more info write to <info@kernelci.org>
