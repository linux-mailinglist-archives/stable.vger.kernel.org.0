Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8239F2D0D8
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 23:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbfE1VHa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 May 2019 17:07:30 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:42585 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726683AbfE1VHa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 May 2019 17:07:30 -0400
Received: by mail-wr1-f44.google.com with SMTP id l2so123483wrb.9
        for <stable@vger.kernel.org>; Tue, 28 May 2019 14:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DmfBMhqHu6wSA0uWnDMNW+UGrGEcGwTMFAVe6uPcTeI=;
        b=FTMA+IXubKIt8/+VMjtW1KRsmhMN3FQJVjglpuhn5SRyl0c8ghwsLzbh876QcEmXSZ
         R2gkEq7evo9z8/ebwKUmlSowNWBBrMV8pxqIt7mZ93LVPqk8aQleqduSn2raOeQ6loSO
         Q1EHxf6m2z/pjLM/xwV1NeCVePIhta45XjkM7glX6tGL4481T97iBidY80hg7Xqf/WHY
         OTR/Ht359vKKFwBWhwZ9MRY7Sqdu3aPKzqEYE9+ylPHdrV+zieBoGYrWXepQtAICzkqL
         en1gt2D0yIyLsP9tYExqRZjqjaqhdsNxJTuB3BmEmGMSpzHt+s+mW04HqldV72oQbH+s
         IX4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DmfBMhqHu6wSA0uWnDMNW+UGrGEcGwTMFAVe6uPcTeI=;
        b=odsP7rTvEn+po+7UePP0pvUsy2CLLhUl5bO8acVMrjhXyrTvDsVhs9kTp2QpQb7rAe
         15ERvStqNpmEZ7qLR0KYHL1XF2wC/5/GNQXwfTt8bZqMx6aYCfBR/e7HiirKo+6G2oIC
         OOBcy94qtZC+cHjIyUL8bEfFXiNLXRDkp6RJ+WbWgWtmS41nWVmVHyvvOA4sTSXq6Aky
         lYpAZrizRuKpKg6YVSCPTw4cBYxzg77paJkbPP0bV5GQxdm9TD/uolItHQtCoweSzfwn
         jaER3fDSjyzJqvj/7s62WRsEIlNGEbg0ICD7G43d7Yf7I2zVho+M4rtUBABHinPNEqpY
         zo/w==
X-Gm-Message-State: APjAAAWhiaopNIHJ9KaCmF/UV3d/y6kUjIiD1n28M8G1iSWdKOjarMSP
        btGQLEzP8S75KugYBXw0F6PqfOU+wfZNsQ==
X-Google-Smtp-Source: APXvYqwfJNnwkczCAx0Mt8ou90C8HILJ3PZ1FzWle3oUt8TTETGSiJUIL4cm42Cuij+4SSVnFHGo2w==
X-Received: by 2002:adf:f7ce:: with SMTP id a14mr11846048wrq.164.1559077648529;
        Tue, 28 May 2019 14:07:28 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z21sm4121312wmf.25.2019.05.28.14.07.27
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 14:07:27 -0700 (PDT)
Message-ID: <5ceda30f.1c69fb81.2c58f.6f4b@mx.google.com>
Date:   Tue, 28 May 2019 14:07:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.46-32-g256cbdee8310
Subject: stable-rc/linux-4.19.y boot: 120 boots: 0 failed,
 119 passed with 1 untried/unknown (v4.19.46-32-g256cbdee8310)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 120 boots: 0 failed, 119 passed with 1 untried=
/unknown (v4.19.46-32-g256cbdee8310)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.46-32-g256cbdee8310/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.46-32-g256cbdee8310/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.46-32-g256cbdee8310
Git Commit: 256cbdee831090e617e420970574fda48aa8d58d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 66 unique boards, 23 SoC families, 14 builds out of 206

---
For more info write to <info@kernelci.org>
