Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3C36C9CE
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 09:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbfGRHNl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 03:13:41 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37126 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726423AbfGRHNi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 03:13:38 -0400
Received: by mail-wr1-f68.google.com with SMTP id n9so2349414wrr.4
        for <stable@vger.kernel.org>; Thu, 18 Jul 2019 00:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=sMWGdIBskAXlgSXElRU2iGkeNv9D4GYWdN+GpC7oXQM=;
        b=Bu2sT4EZELj0c4mj6KsnQtGkPvcSURG48zP8Mo3zAGHqhwrbyF+0r3DlgPh6f+7roJ
         039S3ngpUdbvKkYrqY60GFA1zqL9V4hhsPVD/P7EqrWmbG4jf3AR4Zs5eJBLAk0MMS2n
         wZTcvnBeB5iWCn+8XXtP66LuLgm27N+KwC/+5np+2aTaktl+pnxOV5bq3sP7PVOf03T+
         z2kbt+U/51T36AtdNSGovt1Oovm2LX1H318rLPGdC96xbXNEdUpq6VOI9Z0M0FKTqfJ+
         LiH7xohhU19kCP8kwEezDdZfQMQsSrp8KChoXCOEElV6LuVnDo9sjgvaT0ROtUOqgLL/
         ZHug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=sMWGdIBskAXlgSXElRU2iGkeNv9D4GYWdN+GpC7oXQM=;
        b=ubfwvRcjj7LkXb1PptNqpSdEe6kHauQvLZgUVkVAzhhD108KL1rABXd+x4qE+/0I2g
         L/kERw6pYsYgqri+YcPmATGDC4/aaVc9vq0b7peWi9+BaMm0qCwZV2dYtMcRciM0Tl60
         OqDltccou2GvMxZ/FxSMgaUg5+z5xbzoW4qOiei59MxL4wuEdqtwXuW/0dKR2Lj0wg+7
         gzL0ictJ5WAk7cynG2JtzsuFvq5iiZs5AftYO+nEuEgJu1chiOyHQTE56e7WilwdMcZB
         +v/JkD122/uqwbl/Q3IBRZjvjEYLf1zeKAX3I3y5dK7K1tRAwKjfd6bnzIJwiPlwni8v
         SrpA==
X-Gm-Message-State: APjAAAVN17b5o4pl1UCaRCcdfkaqjxD9ynzDBqYgMLpcgvrTFc+NZigC
        vJcAsGRGYo0W9838luLEkBAiNohQYPM=
X-Google-Smtp-Source: APXvYqzcBAb8Et9Z9adQ/ILXK6A7y1rUPXRoHnLrabxHArMt7RJHYGYahWMjFGFvMYuEyKVqSvhiBQ==
X-Received: by 2002:adf:e947:: with SMTP id m7mr48788143wrn.123.1563434016470;
        Thu, 18 Jul 2019 00:13:36 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id u2sm24648763wmc.3.2019.07.18.00.13.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 00:13:35 -0700 (PDT)
Message-ID: <5d301c1f.1c69fb81.74c54.ae89@mx.google.com>
Date:   Thu, 18 Jul 2019 00:13:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.185-55-gcc08f2abafc7
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
In-Reply-To: <20190718030048.392549994@linuxfoundation.org>
References: <20190718030048.392549994@linuxfoundation.org>
Subject: Re: [PATCH 4.9 00/54] 4.9.186-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 105 boots: 0 failed, 104 passed with 1 offline =
(v4.9.185-55-gcc08f2abafc7)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.185-55-gcc08f2abafc7/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.185-55-gcc08f2abafc7/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.185-55-gcc08f2abafc7
Git Commit: cc08f2abafc74b206e12ac1f1b11284ccc032572
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 50 unique boards, 23 SoC families, 15 builds out of 197

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-gxbb-odroidc2: 1 offline lab

---
For more info write to <info@kernelci.org>
