Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C867B15A275
	for <lists+stable@lfdr.de>; Wed, 12 Feb 2020 08:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbgBLHzm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Feb 2020 02:55:42 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44426 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728381AbgBLHzl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Feb 2020 02:55:41 -0500
Received: by mail-wr1-f66.google.com with SMTP id m16so941093wrx.11
        for <stable@vger.kernel.org>; Tue, 11 Feb 2020 23:55:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WpcDomuTUzyP4KjRsKuidRqjrRYu2K9CWqZplPcXd/M=;
        b=k84CTTVKnAsIRtfU238qQF46dE8Xuc2hSbQjvgtw9EtuySiEbyYTwrJHkjew+DHboh
         REwtnhnpOagBaKkmWdY8UoIyL5veqT+qt6X+QNJ67vfddK3YlN9S6TTTSB6Nh++A+le9
         ze/cwE3T4K76iqErcojUr3G/4+PIYgohcLDqHTiFVm0DQXQti3SFSzRA74cGuE+f22vk
         wi1FU5LmXfEDbLuUwvLYh0G2yQ451A+xLTmTgKT5OCB03h/o8wiS1HHAB9VePmrGqFAf
         P9T46612w13XEoBR26+WvTpZke+DHuMTqlQ3j+wCI9QMJIyG/XHa4NM90DSHnNv6vEGL
         ln3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WpcDomuTUzyP4KjRsKuidRqjrRYu2K9CWqZplPcXd/M=;
        b=MV2b1qJsXTQ/o4IuX/LK6AzpR4pSF9Ep4uu9rSx8ZvECy4HUWkoaHEpl+PaheEx0oY
         EfkyJ8d+YiUI/ajvM/2p9ISSIkF/MyBxqyKRxsE5BIpo0Oz1SYlu+CoE4Lq0sVZXoV5o
         IkX8HWQ6Exgi+AuXLXiNY0/dQs/Icx7bl35qUAOffyc61tuhUf4I+7N8XF1gcghTE1Lq
         ISLuk3k8sMkfafxSEshYq4y/iCFKS+xfndYGo+6YDlNONjKCWQEE/3kAGZQ85jwDPoRU
         /JTn3nJmsBJk5oQb3+Ol7Ey2FLDOJLNSWpEz5KqjsgDOY6eB90CAOZb81R36sTOFn37T
         KGQQ==
X-Gm-Message-State: APjAAAUU/m5KpMfVmzY4QfscnV7JgJVjxsLobBvYWp+/eGE8pIpGBmzl
        krJVK4bohI44mkd7SbinbmU+MinLfduqHw==
X-Google-Smtp-Source: APXvYqzRCVIa9Wu4tStGRahXuQY4E8QcdQ3L1/qjZe2jCxq/mNzXKQkr+jo3ukfjigtbSlhv1JF9Ag==
X-Received: by 2002:a5d:484f:: with SMTP id n15mr13592369wrs.365.1581494139608;
        Tue, 11 Feb 2020 23:55:39 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z19sm6924702wmi.43.2020.02.11.23.55.38
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 23:55:39 -0800 (PST)
Message-ID: <5e43af7b.1c69fb81.d1eb9.f6f5@mx.google.com>
Date:   Tue, 11 Feb 2020 23:55:39 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.4.19
Subject: stable/linux-5.4.y boot: 49 boots: 0 failed,
 47 passed with 2 untried/unknown (v5.4.19)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y boot: 49 boots: 0 failed, 47 passed with 2 untried/unkno=
wn (v5.4.19)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
4.y/kernel/v5.4.19/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.4.y/ke=
rnel/v5.4.19/

Tree: stable
Branch: linux-5.4.y
Git Describe: v5.4.19
Git Commit: d6591ea2dd1a44b1c72c5a3e3b6555d7585acdae
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 46 unique boards, 15 SoC families, 9 builds out of 147

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          alpine-db:
              lab-baylibre: new failure (last pass: v5.4.17)

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s905d-p230:
              lab-baylibre: new failure (last pass: v5.4.18)

---
For more info write to <info@kernelci.org>
