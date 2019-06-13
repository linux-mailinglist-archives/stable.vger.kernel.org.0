Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3302C44F19
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 00:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbfFMWaz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 18:30:55 -0400
Received: from mail-wr1-f54.google.com ([209.85.221.54]:35799 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726958AbfFMWay (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 18:30:54 -0400
Received: by mail-wr1-f54.google.com with SMTP id m3so442479wrv.2
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 15:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=G1zfwNGyGsIR0bCob2h13qu32Wz3N/yO1T5W1D1pcY8=;
        b=dfJ3cgC642eu9acBB5GSvZPCZzwibKIjBXh3qcWisa77v1RmKqXzDVenGQYgJu+egp
         mMACO/pSL115dbzHUfXJr5tO+5/uvSrPqsAkl2b780fAcMsteeeYI/zmwAhPZcYlIZIP
         Jau5Ohun0vcablUdsxAmaXMWugpowdXmeccpuFhbnydulmnSWBzV0EQWsYpmsZH5Nk+q
         J6KtuNcAbY0GBgUyOvRFK2LnKzbMmNIhJncGBDt59hRuj/tHRssB6inoapSpjaw+1fhp
         ptPf0hBQr6yXr9sI5zvxZWf+rtq7yXRMTbotwve6OQRTmAQQv0OY+F512ttSvVa9KlP9
         llpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=G1zfwNGyGsIR0bCob2h13qu32Wz3N/yO1T5W1D1pcY8=;
        b=qw51EgZ9gK4gyQEPrLsSB1ccARnRj73M7QvzJgJX3XWTX84XzwQDGKwczO40ruJIgF
         SE0zWb2hkpNMm2tZvCaw68J08Sy8doyX/LaVPBnFbx533vxTFGe+Jole/NhZIdBcEyOZ
         J+i4wLiEep03xG41Z/k5mlLQKmBGfm84hEInBax5RN/HXPv2QLcw2PjfFP46WskyYRGq
         fYwi4HxbLtNIxVxheS9wLPE7RaQr0blYfNJIr6L4bAzGLjVU2diNo3MlbKCp8QreN3V5
         haZdny/bwBb+TZQbj4h6L9n+3c7JXm8zcTgFXqYj7li6xDP/e+bav3XBe/n5vCH/t7GB
         wKNw==
X-Gm-Message-State: APjAAAV5ZIiRyNcVyPQlYWnXF06xmQBKXIbp+hHWThUPM31oX2poZnsr
        mOi3iRNzJ5Nv7h2YWlqJICVfMEG0vTYFYA==
X-Google-Smtp-Source: APXvYqxEVaKpgOB1tkC2ZfPsOhZztw4cCtbPnHS0MHSNsUHh66i7q1vlsoUt8emDkn7iP3I1VxtkMQ==
X-Received: by 2002:adf:e841:: with SMTP id d1mr62107283wrn.204.1560465052615;
        Thu, 13 Jun 2019 15:30:52 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o4sm682814wmh.35.2019.06.13.15.30.51
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 15:30:51 -0700 (PDT)
Message-ID: <5d02ce9b.1c69fb81.54bd8.3b71@mx.google.com>
Date:   Thu, 13 Jun 2019 15:30:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.125-81-g743300ca6410
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 116 boots: 0 failed,
 116 passed (v4.14.125-81-g743300ca6410)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 116 boots: 0 failed, 116 passed (v4.14.125-81-=
g743300ca6410)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.125-81-g743300ca6410/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.125-81-g743300ca6410/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.125-81-g743300ca6410
Git Commit: 743300ca6410e30133ce3d09a668fe6477d3a67f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 63 unique boards, 24 SoC families, 15 builds out of 201

---
For more info write to <info@kernelci.org>
