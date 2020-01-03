Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 680FE12FE78
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 22:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728679AbgACVwA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 16:52:00 -0500
Received: from mail-wm1-f44.google.com ([209.85.128.44]:52218 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728657AbgACVv7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 16:51:59 -0500
Received: by mail-wm1-f44.google.com with SMTP id d73so9530264wmd.1
        for <stable@vger.kernel.org>; Fri, 03 Jan 2020 13:51:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mr4+DOUwC8DUO7IcQYsbUU1xjTMNqMLTGshmaLeouFk=;
        b=VwqfXkjmA54d8wNZJyJctJPGMTSmQZ6suT9DzzkzVWfO8FNJH+yX05uYRPHn636awW
         N70Il4tmu3epZYUe+6dkJWaOOupCzEncd0/l5hpSPG70hi23UBp6vZc5tbYOCGbjEYib
         hYWTMmGEhuz9G0xfI0TUtB7bJ+x+mS2TSu3QkO5kbV5HnW6/8xqbFt99nd8TkPrt0pLZ
         3Cvua7J0VVQM+LKVf+93w02Pwpym7v1pVjGxF5BdsBm7YPpa3vj2ssCoQJ2GwgYnrluY
         EEwgOa0e0dLAph+RlOk4m27pMNQbFzpBV5TzvpAZjbJ23uMrjGlrs+f3qaPBZ1uQRh69
         1Duw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mr4+DOUwC8DUO7IcQYsbUU1xjTMNqMLTGshmaLeouFk=;
        b=BJYVIt6EzpR9tli8XaJc5SJyp8zwc+4y4XCNIHBP09YCaK6uTVqs3SUnBiBZ5uTQdX
         1MXXwDpo0mDLnW4BKNStcbVtj8np7m+lBDh11GOgwvVsE99gosb+Ov1XaPWrF0r92Mqn
         xwdwRXkFNe0ijReBcjTfELWa5DufvH4mM2fC8TK8Rodvt5qvcZ92laTQq+QVaWw7fe7s
         zoSgTvoHOgEnuK4hqRF2syMj9KIABgS4y7WtkjN4Udgq84hag7qdVHdnrQVefsxYz4Ja
         neb5xIK3NA3k6GoJcEe7wreuXH4yiZL2rGxnLkMJVgfK8GbdnVRsd3JXZeNQVW+7kwPb
         vGMg==
X-Gm-Message-State: APjAAAXk3taFsDoQ8Vw/QKNi54b7Iy5i2C0gfk5DiWGwzSpt7djOFY6a
        x9rXzQ/tzqrGQxLJd8EWkOnOs98tf5OTig==
X-Google-Smtp-Source: APXvYqzBLSZb3W87ZPqfcR1mD5Hn/fyCQIEbMpiWyLZTWtp2uOIpDyBCKSoUO5uFjW49K5T/sW/0DQ==
X-Received: by 2002:a1c:e108:: with SMTP id y8mr21000960wmg.147.1578088316688;
        Fri, 03 Jan 2020 13:51:56 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id e18sm62300571wrw.70.2020.01.03.13.51.55
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2020 13:51:56 -0800 (PST)
Message-ID: <5e0fb77c.1c69fb81.825df.e334@mx.google.com>
Date:   Fri, 03 Jan 2020 13:51:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.161-92-g6ddc8c5d33cc
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 41 boots: 0 failed,
 40 passed with 1 untried/unknown (v4.14.161-92-g6ddc8c5d33cc)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 41 boots: 0 failed, 40 passed with 1 untried/u=
nknown (v4.14.161-92-g6ddc8c5d33cc)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.161-92-g6ddc8c5d33cc/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.161-92-g6ddc8c5d33cc/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.161-92-g6ddc8c5d33cc
Git Commit: 6ddc8c5d33cc1db17feb9d06adfbb798df284641
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 26 unique boards, 11 SoC families, 10 builds out of 201

---
For more info write to <info@kernelci.org>
