Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C16012E11C
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 00:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727446AbgAAX5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jan 2020 18:57:33 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42780 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727441AbgAAX5d (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jan 2020 18:57:33 -0500
Received: by mail-wr1-f68.google.com with SMTP id q6so37763024wro.9
        for <stable@vger.kernel.org>; Wed, 01 Jan 2020 15:57:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=U4+Er/L7uG5icVJItQcQAoZFN2ypOyfLtrHDlYZpkTw=;
        b=w2Zyres02/vcWd9yFn5KMAAsI1JyBrAwCZJMPeJoHba0wcjVrmqVG3KYiWOY02JWjX
         rnNhmadL0r6ZbjUSJRE4/AUOuE5PB7Z/CWuVJDDQu4W0h5Dis0NL97VBsNdWJluInrDW
         BtdemE19zzIyFGl6XFs7ybXUPIb1Q7yxYaR1WUtAhj2+U3t33iUutUEdYVY2JVqcYqIy
         ywdUSE5KKcaGcd2tnHx1iVQCk4F42XFTuXbuL6BG4UJqZR7fXb3soA5CAqDJWnCF6B2B
         VEXo3sZSXkRCKZc2gJOXUP0rhTZPFrVnu0JAVU/VErGoLs2I4mpjzoS8mJfcnFK37loE
         qTzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=U4+Er/L7uG5icVJItQcQAoZFN2ypOyfLtrHDlYZpkTw=;
        b=bBrnrS3w0rMqEsSevR3GvihFuxklVJdwroXUK6K2yKMyJIOaMivs4QduBoeVKuierq
         bEJTEYURPkuLvR3m5HZOYEQG0oQjqZt6p4vrGMKgtG2v0REEA8rMTKFvKYyXiSKcF9NZ
         LW5xsL2wMDdaiNQYhcmzCcYUwG1NbQkKvfmA5HJ4FXA1YajARfpnpCWP9FcHlagbXCGm
         LSRZyOxvmOYyr+S/WCiLqiuQlKns6kl/8fbXSuMV3qoTpiF3sxQyxKvjF3u6GawGp2ya
         IoOxsR6DqQiVgnDrJbYW3VH143owuj9zUhPSshNXQ1ZciQoB6FRRzA7PFrkrnIeyMgXU
         1iLg==
X-Gm-Message-State: APjAAAXfVVRJux9xkMlaWitZEA78EDycfLZkyWsjkkCBSZ38cSoM3Osh
        s8yiTenz0frRcMQSgt6x6L7obpFd4JfNGQ==
X-Google-Smtp-Source: APXvYqws60JCSf0VGZt98EAAGijzLE5uy7Lm/2Um4tkg5iWINxGGkj5UbcLzA7ABsERcb7elnNFfqg==
X-Received: by 2002:adf:9c8a:: with SMTP id d10mr78202065wre.156.1577923050827;
        Wed, 01 Jan 2020 15:57:30 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id p17sm54856895wrx.20.2020.01.01.15.57.30
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jan 2020 15:57:30 -0800 (PST)
Message-ID: <5e0d31ea.1c69fb81.f3ae2.bd73@mx.google.com>
Date:   Wed, 01 Jan 2020 15:57:30 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.161-71-g304199b2cbbb
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 56 boots: 1 failed,
 54 passed with 1 untried/unknown (v4.14.161-71-g304199b2cbbb)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 56 boots: 1 failed, 54 passed with 1 untried/u=
nknown (v4.14.161-71-g304199b2cbbb)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.161-71-g304199b2cbbb/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.161-71-g304199b2cbbb/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.161-71-g304199b2cbbb
Git Commit: 304199b2cbbb59e5c61a32a19e753299a2692968
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 35 unique boards, 13 SoC families, 12 builds out of 201

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

---
For more info write to <info@kernelci.org>
