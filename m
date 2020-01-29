Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2CFF14C7C7
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 10:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbgA2JAW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 04:00:22 -0500
Received: from mail-wm1-f53.google.com ([209.85.128.53]:38844 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbgA2JAV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jan 2020 04:00:21 -0500
Received: by mail-wm1-f53.google.com with SMTP id a9so5493764wmj.3
        for <stable@vger.kernel.org>; Wed, 29 Jan 2020 01:00:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+/Z/VDQbraboteUNkIZ2XGMBt9Zx+0uNSXP4F3WyPKY=;
        b=sCnjcERanDe6Bejek/KHZ5mLlSStR+5bCSX3DPkY/HhLGW7gdeo2/ZqKTzWnGOQa3e
         e08KawqnCyKo92GEuRQ/STYRAneAIFdQQ1J9xWuBGj36JrsfsusYTgk+J8jHlo5dYMY0
         iqrpCoCGba+0I2voNdoBQQhYwImRFXtl/TuRA3+MiMjmjeyww2LM/2+yanJ9bcfMmfPz
         +DlsVbGyxH9yeRk1JsSHsarSBkFL1/LzWLqLKhulaqxJoVJBrDkaY+4LGkHR1Q21DtkL
         aQTC0VDu3rLPuycrA7KWiGKcQWmTVDyyFqJtQlFl4qh/AoOfGDfAHEB7uKuK1Xw4LOwd
         q2vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+/Z/VDQbraboteUNkIZ2XGMBt9Zx+0uNSXP4F3WyPKY=;
        b=RPZQfhTZdg+RlfszMmgDLrwCffeSFoIjoAHPhBMpW9AGZBVrMTaCgyXj7/U+3Ej12m
         ZbPVhZL6UPevoChkNkVV6Ki31qZEfeYBY0I7EEE9NNNT0Wys8TMXqkv7fvAGr6l/HVPx
         GzazL7yNyigv7UGjPcuKyUbt5GJmcjhzkUQA3LZabjKftUACf9rlL4Cgk2zRc6FlxfKc
         iHXhNKv5zHEMZviJRuYEEigLDDeq8G+nvsenGkhTxSVSjrxXAiz11rlrx+UbJFP742EE
         XwpgvEF6tNo6wfboTGvDQHnvzJJsm2mJAeK0vZB2sWVnkvfEOlGo1nKho5NHhEkh0fvz
         ajHQ==
X-Gm-Message-State: APjAAAUsfJtlns6J74rhJOTHD76cDhqRBmuOJEYQp4Bse33FCrJ9szXQ
        r3sB4ixPcDgzry0sZ3/gG/o7guKHjuM6rw==
X-Google-Smtp-Source: APXvYqxNYo5z/fRpm/eDkEzMDmENUxe6S32WfK3GB8jyjlEv7PyU+PmiUithRCG5HK1rA+f6vtD4Dg==
X-Received: by 2002:a1c:1c4:: with SMTP id 187mr10434730wmb.77.1580288419544;
        Wed, 29 Jan 2020 01:00:19 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id q14sm1953664wrj.81.2020.01.29.01.00.18
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2020 01:00:19 -0800 (PST)
Message-ID: <5e3149a3.1c69fb81.c1dd8.8018@mx.google.com>
Date:   Wed, 29 Jan 2020 01:00:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.211-272-g91ff8226a074
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.9.y boot: 50 boots: 0 failed,
 49 passed with 1 untried/unknown (v4.9.211-272-g91ff8226a074)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 50 boots: 0 failed, 49 passed with 1 untried/un=
known (v4.9.211-272-g91ff8226a074)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.211-272-g91ff8226a074/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.211-272-g91ff8226a074/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.211-272-g91ff8226a074
Git Commit: 91ff8226a074449fcd2b96214d1927fd3e8d8114
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 29 unique boards, 11 SoC families, 10 builds out of 177

Boot Regressions Detected:

arm:

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.9.211-234-g33fcc657=
a28d)

---
For more info write to <info@kernelci.org>
