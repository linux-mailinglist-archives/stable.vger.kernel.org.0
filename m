Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B06F513AD8B
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 16:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbgANPYN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 10:24:13 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35846 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726839AbgANPYN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jan 2020 10:24:13 -0500
Received: by mail-wr1-f68.google.com with SMTP id z3so12582805wru.3
        for <stable@vger.kernel.org>; Tue, 14 Jan 2020 07:24:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NjKqLmyl/PrqkT/Vw70saU/zwzCrKOm8Sc3EizWTniI=;
        b=P08Q0CpP+qHizqOhNFPpphg86OizJWdIFlPldcCmRZJHDG3BVkH8Lb3TrnBIB3gw+a
         t1Kx5M47/hIold9NebIJ6TwuO5oz6ErnQWPNHuAkfy5bBwMCkF9Sm5k3tRP1HoFIbGfx
         nuhRKlhLp8O5EovirrHcnrA5VnIiLsxWXDI5h7/bvGoLfRU1efoYMp99i52jql4/sMNC
         p+h3a7gulW8fMenErfiKWO2vRF55moyFmbuF3ILkXft2SwCTw9mQ/XUvytULMyq5OnHM
         R4KzcmNJS00np6tvFjEsuU6/jUdG21uO/eS2ejRI6KrajCuu0TY4r1/9Lkh81xZ4pPx0
         iMxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NjKqLmyl/PrqkT/Vw70saU/zwzCrKOm8Sc3EizWTniI=;
        b=eOALWxg5on3jr0PUMSRV8mkZqNYHarfjkNUo1m565TiAZnV+ExOrpBKWpEkD9Pautd
         58geO24nsHguvtxb8enYcetA8nxPYjSaEy83ziUiGCiwa61adYwJmCKex8S4W+4O1aYG
         kWPoO6c+nwbJzRqAybs/t1r9t2LX2RoTM8E96CnDEwB9SRgqV2WmNNED86JlRjcXN+IA
         +3LipkOYBQ3xkl/GSVLW0u8M3PADJEf8x8CJzAPj2TB/3HokDmtKKmmknmcGFg/V1qHa
         XoHwVNi9zs+ZU6Y5piHi2EoabgGNWvhNi92Zw+fOLY1d7Rigy9CSbbfHp1Pch1V6eiGy
         ZRXA==
X-Gm-Message-State: APjAAAUwQ1UbI/yck09Xo8i0aKPiwCT9hyNEMFYOHFkVy7uYhL0tRLyC
        yQ/i5t1kOKtIvXis72JC51a1zVW9zrfaSw==
X-Google-Smtp-Source: APXvYqxzz6uL5ieEkFn+BlFwaPz+Ys2I0udWxlY166JqwZ5JKS4MlqSKK6hgUUAkM3d8mxpd+8d6EA==
X-Received: by 2002:adf:ec41:: with SMTP id w1mr24448536wrn.212.1579015452109;
        Tue, 14 Jan 2020 07:24:12 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t131sm19658751wmb.13.2020.01.14.07.24.11
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 07:24:11 -0800 (PST)
Message-ID: <5e1ddd1b.1c69fb81.2de9b.2259@mx.google.com>
Date:   Tue, 14 Jan 2020 07:24:11 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.164-40-ge7b83c76590b
Subject: stable-rc/linux-4.14.y boot: 74 boots: 1 failed,
 71 passed with 2 untried/unknown (v4.14.164-40-ge7b83c76590b)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 74 boots: 1 failed, 71 passed with 2 untried/u=
nknown (v4.14.164-40-ge7b83c76590b)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.164-40-ge7b83c76590b/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.164-40-ge7b83c76590b/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.164-40-ge7b83c76590b
Git Commit: e7b83c76590bff9d45ebc9dde116730878f8178b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 42 unique boards, 13 SoC families, 12 builds out of 201

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          am335x-boneblack:
              lab-baylibre: new failure (last pass: v4.14.164-28-g1a345cb17=
863)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

---
For more info write to <info@kernelci.org>
