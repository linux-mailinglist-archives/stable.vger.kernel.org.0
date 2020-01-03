Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86DFD12F4C8
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 07:58:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725890AbgACG6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 01:58:13 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34329 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbgACG6M (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 01:58:12 -0500
Received: by mail-wm1-f68.google.com with SMTP id c127so6340646wme.1
        for <stable@vger.kernel.org>; Thu, 02 Jan 2020 22:58:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+qLgZ0mZxTNjJUOJ0rJS2Xbs4eWNJvR+wJp7/pTOFx0=;
        b=GD1ZAvHrGjSw6DjW3WNf/z8oG7lw4/i+mPDCO486N75KiQjjdlcK8W4/muNMq/7PSc
         cad+53s/Z+Yc42gvd9w2/qMLwEOpqWPvEbLmN4M9n8CUEJmOxhRis7VWI8qWfhIM4SsL
         3oNW1FVe1LHZk8A50nJ/gARA6ZszzCR6brhvdCSr/opO3vkjbX8DjKM+sVBfnw8n+06P
         kLS0RdxabinMLU779YdDzCDWITDF9ZPTW/Am4ke9wVTWiO8tL7sCS7PS5u5E1apwdbQK
         WElqZb+YjOXMnoVVLCOao7vS5KhA/XL+2yhs2rjrxuS0udQ0RMaY+0od4S9IMGVngOwJ
         GCqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+qLgZ0mZxTNjJUOJ0rJS2Xbs4eWNJvR+wJp7/pTOFx0=;
        b=hplOZappFAiwuj4bVvEqr8lTcESUnb7aJOX6MWf5GBgk1hky6YM98kVNtiG9iLc8f9
         B6AvqVmltIuaY/rqi1ZjRHOVAvt8rxfsq7UYDPGCp/cZXqfWBB+lKxXu9AwSPISHnRp4
         rlRHgBQrlx1vTIMLLAD6kj8FaCSCYO5EhB380L88jdf0X76uumweBsX6Jozb/LuLEcxn
         yEvEoSXHyCSN8+4uQk6Kh+8O2A/3tBEVXcFypRuP2RwK9/XRiXlfDdcAk3QkPbXUcA9l
         UKtiq7MG4Jr+i54u4U+0un1Gsbo9NzyHmXdiYxF5WTI6QQj1KZ6uYyBy+NyjqSaD+8tq
         klWA==
X-Gm-Message-State: APjAAAUWlEWIxvNqhuVnjt65dnqVf1pWVX6uBaLeA3PxNoZxvcbglejL
        XshW/Zb8+CFTgeB/TFzRTKbal8rCWpkI6Q==
X-Google-Smtp-Source: APXvYqzc8xqqHvOHMmIIHWrh9VeZtEl/+Wlzhdm0NkgE1rtjkGN57xd1BfKgMxMorXuDeW/SwAAInw==
X-Received: by 2002:a1c:7d93:: with SMTP id y141mr18574731wmc.111.1578034690658;
        Thu, 02 Jan 2020 22:58:10 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w13sm59570232wru.38.2020.01.02.22.58.10
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jan 2020 22:58:10 -0800 (PST)
Message-ID: <5e0ee602.1c69fb81.45f7e.1643@mx.google.com>
Date:   Thu, 02 Jan 2020 22:58:10 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.161-92-gbeaf509ee27b
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 52 boots: 1 failed,
 49 passed with 2 untried/unknown (v4.14.161-92-gbeaf509ee27b)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 52 boots: 1 failed, 49 passed with 2 untried/u=
nknown (v4.14.161-92-gbeaf509ee27b)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.161-92-gbeaf509ee27b/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.161-92-gbeaf509ee27b/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.161-92-gbeaf509ee27b
Git Commit: beaf509ee27b5e0f370d06b10dd05851efabeca1
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 33 unique boards, 13 SoC families, 12 builds out of 201

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

---
For more info write to <info@kernelci.org>
