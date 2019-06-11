Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA643D775
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 22:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405940AbfFKUFW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 16:05:22 -0400
Received: from mail-wm1-f51.google.com ([209.85.128.51]:50911 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405706AbfFKUFW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jun 2019 16:05:22 -0400
Received: by mail-wm1-f51.google.com with SMTP id c66so4242522wmf.0
        for <stable@vger.kernel.org>; Tue, 11 Jun 2019 13:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Tmcv2Ev7rXT+p1gmCUZrAYMMC7RRrIfM0lUkjfCMrgQ=;
        b=k1wiWoPfLa4gmnzmGibKoQnhhXswp2B3BRSdPvosQsRdQyN0gVN0S5NTvuKyUCR5qX
         mtjUtB1B/XSsynKnNyop4qak+ke0T/k49sO02X0eSZjFjEi2KBKzbwINP730SFhaEd0A
         B2+OuhYK1Agke/XR/gw2t3HD8LHHYoJoQMtm1R+ze2wCtqQZojts7hiTCk9gFaI3eZL4
         jR1awFUzxqzTGZWuU8QV3D5eXYXwyJU1+GAadxLsQVVw7xhQUO4eFyol2/oqcHUqL3BX
         SaGQ7JqEK1ZOfz1M8C6w4IVMztfIaEYgVpEhlq7siv6MRZRHnigBCrinnv5h2lwpGW9D
         BaGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Tmcv2Ev7rXT+p1gmCUZrAYMMC7RRrIfM0lUkjfCMrgQ=;
        b=iOk+SWyACa5FYvhMYnroMWg1vnzt62amYqp3/Aot++G722MplkVe0eqd7/YZqZSYzB
         JPuodgcHrVOEJpFE05H9zeHnNMTIb35S5LwGdwL9VDPxSfZ+mnCJQRVhyoPzV6pe8mFL
         VOBbKBH7zVKXImBeZQU7kZxrQvX58kB/V2k9CfdDg9Zinc7hHeukP7XYWqTbIRZsLuWr
         QXLgnLNQ1R15CUVprXyTemcapebby/+JMXnvsn43oIblkrw5PLyk3LZuiEU9A0aFjgw4
         5G1b57+6Q5lWaTGdx4lUolR9TMLID22kKRea2uFQe6iNDvxUs690jFPBB0WzGGXFgIo6
         VtnQ==
X-Gm-Message-State: APjAAAXx5y01RZF+GIJcnWJ0J9gzfytYCdLcFGh2E54BizWUrLlsYHMw
        E5l4Gi9uy2d5hhNwxljbZBAGBgDUX7pbqw==
X-Google-Smtp-Source: APXvYqwUbTfUf5gXv+5Ginec2z/L11JKglDxr0gOeK9bgxbgle3GweY/gWTp4WUH23nZE8Xb5qgmag==
X-Received: by 2002:a1c:4b1a:: with SMTP id y26mr15121173wma.105.1560283520183;
        Tue, 11 Jun 2019 13:05:20 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f10sm24318292wrg.24.2019.06.11.13.05.19
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Jun 2019 13:05:19 -0700 (PDT)
Message-ID: <5d00097f.1c69fb81.c594.e4f9@mx.google.com>
Date:   Tue, 11 Jun 2019 13:05:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.181
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y boot: 90 boots: 1 failed, 89 passed (v4.4.181)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 90 boots: 1 failed, 89 passed (v4.4.181)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.181/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.181/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.181
Git Commit: d7b7345c3a5d9560ccb9d1551c7aab1d0126837c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 43 unique boards, 20 SoC families, 14 builds out of 190

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

---
For more info write to <info@kernelci.org>
