Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84795ED6EC
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 02:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728788AbfKDB2e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Nov 2019 20:28:34 -0500
Received: from mail-wr1-f43.google.com ([209.85.221.43]:40473 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728520AbfKDB2d (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Nov 2019 20:28:33 -0500
Received: by mail-wr1-f43.google.com with SMTP id o28so15160808wro.7
        for <stable@vger.kernel.org>; Sun, 03 Nov 2019 17:28:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=m/SXivgELp675lhWrQyipYATmUY8PBctZYWVUss3YSc=;
        b=slfFJYAYCN0FFmXW6+/ATgZFPmXdLXvmLZt/zOijgYU9Rg69I3Y8QPpwvVQgpJGFZS
         K86820lmkkpf4gMAb28FWSiFwk1pSp8T0UTry/lDieePxIZOKdPZw5re8YTe8apopzXG
         KKv124qWPyv8qx9tX12iQZs4PWf08NgGJy6VUIgpb3YpHrJmBcJyBP1Y9IYYnKwxLxrV
         u3xN054APn/B0HbCQKob9JoEFQbpDoLb0DcjaV6ZhgJcZaOYs2eM2AbwZCziaO6cjIeD
         rxuFUPry6JLF2QrJ9ydRHKcPvqJeGIXYFvHi7Wh/YAQ+5QpNgGKDFRgKCnHAEnZBswej
         02sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=m/SXivgELp675lhWrQyipYATmUY8PBctZYWVUss3YSc=;
        b=buSlmZ9blbMiQUfSr3+Xiq6XkVo8VN6ob51cbjSlPXnEvcIVehqawgoDZgEbonOuP8
         vSIeS+uj5Uk0n9uhpGtIBdFO4aNW0q49j5Kkuo75TfXE/WHMDKYJldk62aCfHIoR1tnj
         HxG5ue5IwA+2DmI7vYBrLoZsFKRM49Y4DP64u0HKuWyx56mbgNYC1EGV7ElX8mXm2wuc
         BP9NOLYB27cdCFYaCxrs+Qnm8l1PwWfARVxAGKXppDvsG7Kv3dDPtAb0F4srJsDLXVNl
         V5UC5YjVHQqojzsxQ6sxNyNVqu0CghBbNLk/CFdp5uJt1SZFoL8WWnuXvmwVkuXU+dQG
         mNSg==
X-Gm-Message-State: APjAAAWYRvDEbRvbd110Y2d0YafqyXMUA39iIqXRF0K4Z8pvfwGn2cKQ
        NPwe1maJITkqcwlXyyvWdBj/OID7Q5NIig==
X-Google-Smtp-Source: APXvYqwNYnSMy2hDrsilBxfbJinzd5WGNwcpsb01KCJTecLfe/RJfM4oG/19MpDbIlpTFDK+q7/oDw==
X-Received: by 2002:adf:ef0a:: with SMTP id e10mr20135022wro.234.1572830911574;
        Sun, 03 Nov 2019 17:28:31 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x8sm15414040wrr.43.2019.11.03.17.28.31
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Nov 2019 17:28:31 -0800 (PST)
Message-ID: <5dbf7ebf.1c69fb81.e78ff.5506@mx.google.com>
Date:   Sun, 03 Nov 2019 17:28:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.81-114-g7db85d223311
Subject: stable-rc/linux-4.19.y boot: 50 boots: 0 failed,
 50 passed (v4.19.81-114-g7db85d223311)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 50 boots: 0 failed, 50 passed (v4.19.81-114-g7=
db85d223311)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.81-114-g7db85d223311/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.81-114-g7db85d223311/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.81-114-g7db85d223311
Git Commit: 7db85d223311c847caabc1e775e569857c2d90a0
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 27 unique boards, 11 SoC families, 8 builds out of 206

---
For more info write to <info@kernelci.org>
