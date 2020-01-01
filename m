Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB33212E089
	for <lists+stable@lfdr.de>; Wed,  1 Jan 2020 22:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727282AbgAAVZG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jan 2020 16:25:06 -0500
Received: from mail-wm1-f52.google.com ([209.85.128.52]:53517 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727170AbgAAVZG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jan 2020 16:25:06 -0500
Received: by mail-wm1-f52.google.com with SMTP id m24so4177310wmc.3
        for <stable@vger.kernel.org>; Wed, 01 Jan 2020 13:25:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=snkfdXRPUwubjSEtXdh9m5EraH8hq8ApZsbKuiCbcaw=;
        b=sqHlUs6Bg4C4iv3vx4QYWfq7juqZf77SAh5aN9lDbHOeEV1fXqar7IbkY9obq/miZ0
         w+lfK/3AM/KFzVjDe4tHM07Y5WW+FBpr8Z8dA0dc0fuwYO9IlgBa7G8MdbupsVikrX07
         OR2AfxD/NP4G01vgoOX3njXNLjWhKFFen3eVfFxuVPDQdcBdAia0zJbIXr3IhEkRwMPz
         cO+gz06mXDIIoQf+oyUFoPnju9vsoFccO4rG1GipqcfZhK5GI4DL1Ex9Ou9FurKj+E+Q
         A/i4dlSqpCH5G6eix4UMA/KT1uUZa5427lb/1fwlkPMw5MpKu+93wV15Uu+5WdzakOkw
         GPoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=snkfdXRPUwubjSEtXdh9m5EraH8hq8ApZsbKuiCbcaw=;
        b=PaAdpB7WJV02sQRb86r57v4EIwv7sXx8fWAxHvmlYR69R1+9Rt4aftyXQ13vUdjOQQ
         IHqNG24ESPt7c3lXrjYKXQupf7IBAMtFxM+Yy/ZGZioBFY0fuA7UC0TnqwRyerWEdDOt
         jIjABZpgPFGgh2aPGUKXOeH9l0Lx9d2XIFTCCSpB9D1FjNcnqWIKfIsiArzv2ZBreKma
         cBjwDMX6QDd1TcTbb4zVDitvC3ZczWApRaKs4K3kqwgNnOgXaMrsPx6DqvVQKWoBMeAN
         5vd4f5OGLt+LtPehUukr4HrLyYFIHe2LMbCgyw7FzkuyEauw0N+tosKqPDUWZHLzpUY4
         MP/w==
X-Gm-Message-State: APjAAAX9FsrtHTxnkGVNOgOTVX0zX62dfoemegEzSU8rcuYHERnChd1k
        18zgl8QiNgtK93jxY3RLLPsoqR5IZkOLiA==
X-Google-Smtp-Source: APXvYqw5fXJRqBmtdKvuSMWFRxLGbh5/7u7F9+xCDZ5VsPIkmflqwurO+9tjwl4OMUFJTthRkDqfPg==
X-Received: by 2002:a1c:c919:: with SMTP id f25mr10716772wmb.49.1577913904043;
        Wed, 01 Jan 2020 13:25:04 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id p7sm6368158wmp.31.2020.01.01.13.25.03
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jan 2020 13:25:03 -0800 (PST)
Message-ID: <5e0d0e2f.1c69fb81.3ea62.d072@mx.google.com>
Date:   Wed, 01 Jan 2020 13:25:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.207-152-gd66f7d8c4dca
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 24 boots: 0 failed,
 24 passed (v4.9.207-152-gd66f7d8c4dca)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 24 boots: 0 failed, 24 passed (v4.9.207-152-gd6=
6f7d8c4dca)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.207-152-gd66f7d8c4dca/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.207-152-gd66f7d8c4dca/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.207-152-gd66f7d8c4dca
Git Commit: d66f7d8c4dcae90ab9f0898b39d6fc06f6476e3e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 19 unique boards, 7 SoC families, 9 builds out of 197

---
For more info write to <info@kernelci.org>
