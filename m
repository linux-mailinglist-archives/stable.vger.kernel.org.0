Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8CBB262A8
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 13:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729268AbfEVLAT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 07:00:19 -0400
Received: from mail-wm1-f53.google.com ([209.85.128.53]:53621 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728743AbfEVLAS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 May 2019 07:00:18 -0400
Received: by mail-wm1-f53.google.com with SMTP id 198so1748357wme.3
        for <stable@vger.kernel.org>; Wed, 22 May 2019 04:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DnPFOhWbO4R90LD+nKJGk5VUMc/7uFhBdLgC3gWtAAA=;
        b=X6JB5ro5n+rvnt8hII9kfOmOppRdbSPd6csTDpOrvSY8E2wuR6i/cuCmTr6K3hVl66
         FZ5BfRHx7jtV3sTfI2Uc0SVYbxki4mIaeRc+qDM7GzYSobVquhVG9P32EyyAEFWfgBgA
         kaBGgr5aRtD1Tz75yPusK6IYrU+nPt+RsNjmMbRd9HGs0MiKM01pSqgwDO95+ZzZz3XS
         ybI/O5Z9GNb4uPmQBJiTJXDdHnLde5ni48BRPMKC9ecX39OaU91bA32rmQs0+1Q98mVS
         qnoQ6NGgTtaIMwA7+rk16EMiJU2kwUMbzAzl9wY+v93H6h06/wGuUpNKB8wFvURS5G5n
         1p/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DnPFOhWbO4R90LD+nKJGk5VUMc/7uFhBdLgC3gWtAAA=;
        b=FWy9EUMeAzSUhWzuPWDF/hcstgZ4zABs72WPDxp5zgnI9HHDBBDeJxx9QEp2I1pyua
         RDEKMOw3YkJHKur8V74lx3WU4ITfANmAd50aY7+uKEOXYuFy303qJRkmdku3BB0fu2/j
         1slBQJ5MSwJexhxatD15RgHIupJbLR0s+u0j9v7jvp4y4KcNlL9L/HMwcFusCaH8F30u
         yL+gFy+JGFYJ7UhIUPSsskaCuzXJgvimnHLzF8pVEv8H74+Xj1ISHJW/AL0kPn+xCnAh
         5eUoH0UlUj7VOLcFj0kXfGMeK88T4bw9bznRzGvZyeqPjU3BVHBkBNsrDjMWO9aEJBkA
         cMOg==
X-Gm-Message-State: APjAAAWfXtaxu1iq1+la0dLLhFGDwJwXxAQY4k89OHOsMaoMYcjIew2U
        80f66jVVXz5ISWDjywN6YRKWnPTkjShFig==
X-Google-Smtp-Source: APXvYqz7efzmDJYyCs+iCwHbUjx0hTHSzGGQhiVjo8QQe12x+t7bL10qgJCB71FFmorv/73vS0KpHQ==
X-Received: by 2002:a1c:ca0b:: with SMTP id a11mr7330056wmg.52.1558522816419;
        Wed, 22 May 2019 04:00:16 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f11sm21062042wrv.93.2019.05.22.04.00.13
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 May 2019 04:00:14 -0700 (PDT)
Message-ID: <5ce52bbe.1c69fb81.ded5f.c865@mx.google.com>
Date:   Wed, 22 May 2019 04:00:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.0.y
X-Kernelci-Kernel: v5.0.18
Subject: stable/linux-5.0.y boot: 54 boots: 1 failed, 53 passed (v5.0.18)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.0.y boot: 54 boots: 1 failed, 53 passed (v5.0.18)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
0.y/kernel/v5.0.18/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.0.y/ke=
rnel/v5.0.18/

Tree: stable
Branch: linux-5.0.y
Git Describe: v5.0.18
Git Commit: 8614793dbb41ccf8699ac1aa328702b47efb3b8d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 30 unique boards, 16 SoC families, 11 builds out of 208

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: new failure (last pass: v5.0.17)

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            omap4-panda: 1 failed lab

---
For more info write to <info@kernelci.org>
