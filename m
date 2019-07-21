Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C57DF6F395
	for <lists+stable@lfdr.de>; Sun, 21 Jul 2019 16:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbfGUODw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Jul 2019 10:03:52 -0400
Received: from mail-wm1-f41.google.com ([209.85.128.41]:34952 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbfGUODw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Jul 2019 10:03:52 -0400
Received: by mail-wm1-f41.google.com with SMTP id l2so32907386wmg.0
        for <stable@vger.kernel.org>; Sun, 21 Jul 2019 07:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=t8t4m+wLtEFxmuLCG+NMsJ1QhQE/wgCQ83rdPUmbmUY=;
        b=NRvEm7aBNYUizLLIQ/6ZGoG6O9Uw7igq+GJB1jrwVkeco9Fo03oiIoxTYaDSs5QUJJ
         pjhb6W0S7n4tlLyziuk+vCyGphSfJcA4ynBYcgi+zyryZAuT106LrWnnbc7wdpN6qN3L
         7O7iKfar5TClGvR51fDR8pt2IQkpY+9mZf7dN/BswRICQaix5E2JbCfscZa6n2CzFqDG
         WJjaGKxOUyxyDHkk7ZhIHm0syEmtg377YvPaMHCHWgbcPgz4Ty84nNClhbxcO7ij/cf8
         eaipOQDYYcF3IyUH2LkggKL/SBEJK3OMDAxXyjAENF8MaQaaTvJzt88Mz/BsRrljp7JZ
         qSFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=t8t4m+wLtEFxmuLCG+NMsJ1QhQE/wgCQ83rdPUmbmUY=;
        b=hMsrqYdpM3CcpBl11amvaY+uf8yidEhynzPDzOEHO8ZDz3H8z6Vlxuy19K5xbayp0+
         kni53/mfQnGLCWoCsT1wuvTzvZvAVfkw5XQviJrJFoN5mAx5ZIQVZeVB0CS+fk6LC4m7
         D8Z10t1Az9KzZw6wUNZ/oxtddZYf7avxSjjwBd2Lg85VvztUalT3QL7nAKqFfzShqnJZ
         xtPYygSoadd9k0Q3UvXX/p4TO1Lg7NKALOppjepgVaz+6xjOw/eCE3uJzdzzpaSHvL9V
         d5ckp76h5u8+htgNd0Cl17vuekUdGz9baypMr5yegxFtr8skesrmFUIWD7UYzLcRD/Cl
         lTWg==
X-Gm-Message-State: APjAAAXQq31yOSOzJQe998nkJ0esFGDE3xHJ8+e5MNlcgbZKubc71r2L
        ymwgjTmh02Gbqbsv8gTbjXvPOTgM
X-Google-Smtp-Source: APXvYqxZJfFEJxhnj3aeyOFawWMB/p9uNXs6EEzICSJs1/m6AjvKm3KzK90tHVj0ZGidGXWZmF8/RQ==
X-Received: by 2002:a1c:cb43:: with SMTP id b64mr58121664wmg.135.1563717830470;
        Sun, 21 Jul 2019 07:03:50 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b8sm34768022wrr.43.2019.07.21.07.03.49
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 21 Jul 2019 07:03:49 -0700 (PDT)
Message-ID: <5d3470c5.1c69fb81.1dfe6.08dc@mx.google.com>
Date:   Sun, 21 Jul 2019 07:03:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.1.19
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.1.y
Subject: stable/linux-5.1.y boot: 42 boots: 1 failed, 41 passed (v5.1.19)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.1.y boot: 42 boots: 1 failed, 41 passed (v5.1.19)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
1.y/kernel/v5.1.19/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.1.y/ke=
rnel/v5.1.19/

Tree: stable
Branch: linux-5.1.y
Git Describe: v5.1.19
Git Commit: 0d4f1b2afde8df3b0ca79818123a43a184a0e1ea
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 23 unique boards, 12 SoC families, 7 builds out of 209

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          am335x-boneblack:
              lab-drue: new failure (last pass: v5.1.7)

Boot Failure Detected:

arm:
    omap2plus_defconfig:
        gcc-8:
            am335x-boneblack: 1 failed lab

---
For more info write to <info@kernelci.org>
