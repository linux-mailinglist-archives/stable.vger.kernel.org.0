Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C31C153F34
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 08:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727572AbgBFHSy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 02:18:54 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40171 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbgBFHSy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Feb 2020 02:18:54 -0500
Received: by mail-wm1-f68.google.com with SMTP id t14so5649440wmi.5
        for <stable@vger.kernel.org>; Wed, 05 Feb 2020 23:18:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xEkG3vhf8bQK8f2GzaXBmrWMprJWoFIN/8dQ0UOKA3w=;
        b=Rg7Ikql7x4YxuxzVZQelW1jA9LrKCl6EuivE0ZYgLpyIFT51Gh5RL6DMrgrBKdh4lC
         ZMIYr+t9OMkPUZNOxMtrj5dt69+GXDCoOR5pX52fh55T+d1BDVzi0p8wfwph+0QM6+ys
         Souzwx7BO2sNadqCQdyRhpPmcNiOKT3cnd8oo+c0hqQlUGYMcDSyrjXViYscldkVnDmB
         MRNKtT290MNgFqitbLpifc5+wffDTLdqCDbOK+aocoZBsJLUnBRVlrSahCizr6ISpUge
         Az67Z4Am8ZtvTzi4HZfWji/x5ncLKVumH4ge9UJ2WZ2Aoo/eHCYtfUs2xOA6RE+9VHEr
         o8FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xEkG3vhf8bQK8f2GzaXBmrWMprJWoFIN/8dQ0UOKA3w=;
        b=p8STTViK0MdKZZxvK0Rr3twe1OmUDROQRteoXMjKlkmx5WUWZPwukTBu2Un4b3pJaR
         9E3TqQfVvdMxMePoyRmpODKRLoWjk5h9absva+5bRi5Wtd900oxejrlLWISN3v3UgJ5s
         gVRhiTbtXhWPGNTZ6VQi7EBbJoYEjripdgdwclNvku3bJ+98jHh2RAWozSjx0Mh3wu1H
         wkjGhXV1W9BsKuN2SVV990rB9xltTJzvR8uUVvfuRMzM7rbNHs5zFKcSiHksXCF1pYRv
         BYTDb/1vWDqCCvyLH0bQoE4F+b6Uo9eXwSBIyNvI/ul4denlaFXRoZi1jbT4QIhlNZQ9
         NhYg==
X-Gm-Message-State: APjAAAXQ+/pXHXIC1Aqa2mxngVgXTduaVKYmoYeulHsSOjZdv2EflXHu
        JL3uqapzLAMCW2jMpBqIgqPIRcPVWlxWjQ==
X-Google-Smtp-Source: APXvYqz++rNk8INjhtmD/HxsEANkKVOhL7D8wCt1JXOgFF/hWFS5hhOI6kOY3CiSKPTXuhdBfOuu9A==
X-Received: by 2002:a1c:6a06:: with SMTP id f6mr2682958wmc.137.1580973532319;
        Wed, 05 Feb 2020 23:18:52 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y7sm9593227wmd.1.2020.02.05.23.18.51
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 23:18:51 -0800 (PST)
Message-ID: <5e3bbddb.1c69fb81.1bf85.886c@mx.google.com>
Date:   Wed, 05 Feb 2020 23:18:51 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Kernel: v4.4.213
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 3 boots: 0 failed, 3 passed (v4.4.213)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 3 boots: 0 failed, 3 passed (v4.4.213)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.213/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.213/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.213
Git Commit: d6ccbff9be43dbb6113a6a3f107c3d066052097e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 3 unique boards, 2 SoC families, 2 builds out of 26

---
For more info write to <info@kernelci.org>
