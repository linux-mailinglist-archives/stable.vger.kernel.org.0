Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C434B5CF1C
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 14:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbfGBMGc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 08:06:32 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38824 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbfGBMGc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jul 2019 08:06:32 -0400
Received: by mail-wm1-f68.google.com with SMTP id s15so721277wmj.3
        for <stable@vger.kernel.org>; Tue, 02 Jul 2019 05:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=M6EDEsy2gmn1Zph/dj0lXGE/ceeSTIjFta5c4Hqf3Ig=;
        b=ON/OtVZ5jQChw9gEyGCU8+MFpKNO32j6fy0QbCYkYXuePlWNDfYDMRkSoGXqNOUufO
         n/j14XqRqL5VQUY5t21S/NNH/abG37SWz+BWNwcVQZQEvJl2rTYGe3ujcxLl5M+oqfrL
         IQutNW7Di+6TUnzw3BJcpL9ncJnEl+XFribxxuSX0kEfyw6NnjgLZBqQVcIaO8TYx4lE
         nOBU3M7Gqko5WmuGzdolMH7i5iTiCT8H1IoPnhF66iy6W1X7iAhf3YR+oM+MwejcfF67
         8Bx+Fd2bt2LBPRdECLyIWO6//f8wzMU2qEaZdje2TS66/TdDmElZo7LjAWWFTn8HQQ89
         c2yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=M6EDEsy2gmn1Zph/dj0lXGE/ceeSTIjFta5c4Hqf3Ig=;
        b=S1xgPnxD6+bu9KraAvtOKUnOw+1GqTR3+YqZVoRZ9oeXGJosgYZ00/0oayT6UXzWAJ
         8g18Dd6co8mK8lckkB6t3NwQ7Y4zTgbBxQ76iSxzxB6gcb3nffAZn+b4CZ3ecvm/YaR2
         zOMtyXQcjmXMrulYLplsF3zVU223n1R753jLxXVpDUhNy86YjfF3Z6ZCeso4qEI/5qSu
         YxXsKR9SCt+JYemUIZA998qhf0l9oRlYqydgW1xnWJaxxLPyi98Rl+uCdIjbRVkdvzLL
         HFKfVPg0mXKfzdIwKaVc/yAhaqgIBcjjrJfa2+KLkgD4721+B1eIALysgsxrV/4KfoM5
         wIeg==
X-Gm-Message-State: APjAAAVaSZLdAA92DfB3PpZYXIoXNHAyc0ifkreqQPxbrrqCYTMRed20
        KTICB+O4rmlgGxw4PqR5bDgkTu138Hw=
X-Google-Smtp-Source: APXvYqxxgeiKB3oshJseH3Cn9qwp44WfIXCTV4DbBk3yg7hsoqAmThRuQqaDLPr6qklIU9hKJekARw==
X-Received: by 2002:a1c:5602:: with SMTP id k2mr3027222wmb.173.1562069190232;
        Tue, 02 Jul 2019 05:06:30 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 15sm2082521wmk.34.2019.07.02.05.06.29
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 05:06:29 -0700 (PDT)
Message-ID: <5d1b48c5.1c69fb81.dbec5.c205@mx.google.com>
Date:   Tue, 02 Jul 2019 05:06:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.184-64-g04497578632d
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 109 boots: 2 failed,
 106 passed with 1 offline (v4.9.184-64-g04497578632d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 109 boots: 2 failed, 106 passed with 1 offline =
(v4.9.184-64-g04497578632d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.184-64-g04497578632d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.184-64-g04497578632d/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.184-64-g04497578632d
Git Commit: 04497578632d49f9d70331eaba37cc6cbf6ab3f3
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 53 unique boards, 23 SoC families, 15 builds out of 197

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab

---
For more info write to <info@kernelci.org>
