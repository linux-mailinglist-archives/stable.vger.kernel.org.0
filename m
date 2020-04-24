Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 774301B6F11
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 09:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726008AbgDXHbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 03:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725898AbgDXHbI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 03:31:08 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24CA9C09B045
        for <stable@vger.kernel.org>; Fri, 24 Apr 2020 00:31:08 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id t4so3424745plq.12
        for <stable@vger.kernel.org>; Fri, 24 Apr 2020 00:31:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cjdozNVexF+mYmbS8YaFTkeFqatyFDn5JbYMnKHT5fs=;
        b=WJlYIkv6WSYxpmdIXsHGTK2glvD9wI3qQ//aF54ZuPiydT3suEAdyEX6tSr03QZKsp
         aTmtvmbXlSTcPGF5sAvhxhF8E3v9FcYl4wdW5f5xZh4CXamXfY3EtSmbZktl38+hO5Du
         W10w3khWPnWt53OzyOI68NuBxmWqVZckVj3RPJGxxCx8FH3EJdkVtN8gQkmTCnR3U35i
         oHnQew287SprY0dc5nRM8vvWiELsNuoI2dbNE7tuEtZsPl2LraIIUZpJBXZk6Gs4GQC4
         lbj7ERJUX1Z+9zdBTjEkKj6EpmKobarr9ObBhDPA4rWXiEc5TKr1WgeRtidK/511er/0
         xhFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cjdozNVexF+mYmbS8YaFTkeFqatyFDn5JbYMnKHT5fs=;
        b=GOpZxdmQXXuJIHp/W7rheskt6PIvVHjiyJynItuUTyl4Ty+cWZQWzJdamKueswYE8M
         61G6+GVYBTwRdHJHJODvCRBgAM0K/Xev55kv85ArHmFA2uM72H0/5fSzXdTVkSU8veP5
         u6g4NVbwCGrDs7xBACh9qDl/0cpzF//bzC+tICimJ9HTZTong6GDO1QtnuP6L+4ZCNpF
         GDrorEh3GBtRAQu35UJ17nbuqTNgCYjuOjtnGw6sJlD5W7Rz60T4azAkKbSEbKKZo2cL
         vJHTxidnJbBjCEH+2ZcXN+Ngp5bHj1dKPGAYtdKQHz7ZP3JR0b5ZhO+42noDvLnR2Wuv
         tYtg==
X-Gm-Message-State: AGi0PublfCwhTGYrx2KsCKGOD4JIXh5t1uFMKbds9Qy1uevSJy9PC8Zj
        IXE1Wm/HL/PxDM0lwdXuxnyKKe4dyzc=
X-Google-Smtp-Source: APiQypJ1ru45qG1zdwAbuI9I+P2Ms00vf03LD1L+tOXzuAS/C49+95dVtsqRyRKc1X2jytZluK9osg==
X-Received: by 2002:a17:90a:1946:: with SMTP id 6mr5131825pjh.42.1587713467177;
        Fri, 24 Apr 2020 00:31:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g3sm4115206pgd.64.2020.04.24.00.31.06
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 00:31:06 -0700 (PDT)
Message-ID: <5ea295ba.1c69fb81.17d10.d2c0@mx.google.com>
Date:   Fri, 24 Apr 2020 00:31:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.219-125-g01b8cf611034
Subject: stable-rc/linux-4.9.y boot: 12 boots: 0 failed,
 12 passed (v4.9.219-125-g01b8cf611034)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 12 boots: 0 failed, 12 passed (v4.9.219-125-g01=
b8cf611034)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.219-125-g01b8cf611034/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.219-125-g01b8cf611034/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.219-125-g01b8cf611034
Git Commit: 01b8cf611034623c2ad49e23a48b0b99231b708f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 6 unique boards, 2 SoC families, 5 builds out of 197

---
For more info write to <info@kernelci.org>
