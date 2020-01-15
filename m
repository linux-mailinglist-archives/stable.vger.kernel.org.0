Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC7C413B802
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 03:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728879AbgAOC6E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 21:58:04 -0500
Received: from mail-wm1-f46.google.com ([209.85.128.46]:54504 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728883AbgAOC6D (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jan 2020 21:58:03 -0500
Received: by mail-wm1-f46.google.com with SMTP id b19so16164892wmj.4
        for <stable@vger.kernel.org>; Tue, 14 Jan 2020 18:58:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eC8mHuFRt+zDpI46tVivch5uXy6VeVGU1KYkmpUiPW0=;
        b=dKXrxLgo+ui/Edcd1KFvo9dwf+otmw4uZkfUwb8cB222J5XuLnTf4MtWfqhi5RzARg
         LjUzdlKPF7WpvaIXaFBtWjPtO5fxDtXjjVCInAqSbO4yeeho4HEleWMiW7jCHAyKjsEP
         Vhpl3zD2RpmtZvW/yqxUd90lruIaSE1/OfAIaBxty3L7KmJxSchnXsJlrynXBNWhYPIY
         3/QfLglsAXM6uS0/Qo0HC225MJ12Xsw4f53FxFForSS3+F22+AsLK9p5ZhunVfytEJoK
         TYcwt/XOJbmJtlhrn5W8YP76O51qqRvWyLBk0w83wSdHnF0Qe1mjxJWnNxplqim5CMOU
         v/7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eC8mHuFRt+zDpI46tVivch5uXy6VeVGU1KYkmpUiPW0=;
        b=m7ixKSNE1QZEiyr3LEGyLtVkhxftJeQN6wcVpBjXbraN32ZVGn6to02LH5etv1MUiC
         FLycHwzzXo/x0Kygi3xbbOgcl31so1mPWq6RjCedaS+niM0/ULPGztOsPx5J3rYuBlZH
         ABbfdUmwyhN/cqBPqSLx6pmigXamgSyVtHnxFQBc+RGRuHIHy4X2OU7BprIp5Pth5bNB
         zhuYBD2FB32FjQ2crSlJrrxSR/HWhT/XY5U4amCsM0ggZ+y0kP9Wqn3vqB30QJF98iVI
         NBvyC7q51y68XMFsBNvUVCCyJKhltsoUMPUCx53EYeVv6fnQJszVrmfkKGWTOQNc2aYM
         60vQ==
X-Gm-Message-State: APjAAAV8PDtzvL/39s7OvEtCeZSmCt/eEseLxMtjNtpHz/zLrfye8kOC
        jx6QSx4AWGKATdok4qdqGUkxhhvTJiva5A==
X-Google-Smtp-Source: APXvYqz9zrI9eDIWEdF0T6/p23I9ab/GvTS/s4PmoGC7F9TEiKIYrhpo4i5wpZLF/AXB9td5wVtYPQ==
X-Received: by 2002:a05:600c:1103:: with SMTP id b3mr29378381wma.141.1579057082032;
        Tue, 14 Jan 2020 18:58:02 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f1sm22912956wrp.93.2020.01.14.18.58.01
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 18:58:01 -0800 (PST)
Message-ID: <5e1e7fb9.1c69fb81.bbf20.f9cb@mx.google.com>
Date:   Tue, 14 Jan 2020 18:58:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.95-48-gc3b4cb017658
Subject: stable-rc/linux-4.19.y boot: 90 boots: 0 failed,
 89 passed with 1 untried/unknown (v4.19.95-48-gc3b4cb017658)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 90 boots: 0 failed, 89 passed with 1 untried/u=
nknown (v4.19.95-48-gc3b4cb017658)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.95-48-gc3b4cb017658/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.95-48-gc3b4cb017658/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.95-48-gc3b4cb017658
Git Commit: c3b4cb017658a6dacd7a052ad3fabb9641c9a6ea
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 52 unique boards, 15 SoC families, 14 builds out of 206

---
For more info write to <info@kernelci.org>
