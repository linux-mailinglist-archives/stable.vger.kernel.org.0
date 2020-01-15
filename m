Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EEAE13B6B3
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 02:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728824AbgAOBO5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 20:14:57 -0500
Received: from mail-wr1-f41.google.com ([209.85.221.41]:43744 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728795AbgAOBO5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jan 2020 20:14:57 -0500
Received: by mail-wr1-f41.google.com with SMTP id d16so14116617wre.10
        for <stable@vger.kernel.org>; Tue, 14 Jan 2020 17:14:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EpGJagkQmP59VfkZR2v0QF7rgVQR/nzyCiSM5okq6bk=;
        b=JQyS9if+7OtDALeW0fvV4puoGS3pvpDhY071OxfkqZE9vejsw+hlw2r1z4BdKz4Ldw
         wngD+KgTYSpDxhb6yxUNdZf6fyQ0mg0ENy7mVvny229d4lF6XknWdJ818dEg223GxddT
         i1CN+qHEoov5B6Dcz/lra8akPq+LQRG14h+URBDh53xalMg6XOiwTt7jpFzWg8QqQ290
         X+8w8/7Y25HO6JNH/WdBOofXNdey775Tkve7ZSfgIPmKuJbyYJgJd3xbMtPLw76z0NN6
         0CaXMiM5Ep7fpam6q5siyRXvpaG9IFrp388nIWbe3lIqAzMrwXS1Juo8qNk0l7hVqId4
         l/pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EpGJagkQmP59VfkZR2v0QF7rgVQR/nzyCiSM5okq6bk=;
        b=Sh9kcDLVvNS3rTrH78uTRGn1CGbTGsn4T6atqiUBARmR27/tQMu3VolTTUGQ8Dvrac
         6QNGwCYcyzAP4wFQYEfs7JbsZ72gJEEfRtIyA66mqYVjfjtdonZwNnmlXnNvD3JACwUd
         RzSxgWIKpO4iv/fKJ/kWT5X2wvmnSzqQpK5+SYHWW3ZXHzjr2JT1k7hKio3xg009bN+8
         lRUahFbdQUhml1PFuDopTPfg9gQ4+7RKhWaOU5dqoMuVJIK9pNPdkOOixZI29Sw7vNOZ
         Symlw3gsYgonBATD0T0EjQLRpGyxBYpIPFntZD485P/pMP2OaRnLUMmDS56JRYnZIEi8
         6vEw==
X-Gm-Message-State: APjAAAXOFQXY6LHLhgw5OFXs5me7uFdF3kUJgpZI+PDpphqVOl8623wg
        uFvHAhJ8HrE/3w5XkvkUbDUOOXmogSLjcA==
X-Google-Smtp-Source: APXvYqxi36IWeSw35zJxgMhogZL5V4vXCwgT0wOGmesM8rMpkrYvIUioqMjEbnTQ1EGmT0z7YAJ00w==
X-Received: by 2002:adf:90e7:: with SMTP id i94mr27399759wri.47.1579050894929;
        Tue, 14 Jan 2020 17:14:54 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n1sm21242130wrw.52.2020.01.14.17.14.53
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 17:14:54 -0800 (PST)
Message-ID: <5e1e678e.1c69fb81.7b2e.a47b@mx.google.com>
Date:   Tue, 14 Jan 2020 17:14:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.164-41-g04f13b8f773f
Subject: stable-rc/linux-4.14.y boot: 46 boots: 1 failed,
 45 passed (v4.14.164-41-g04f13b8f773f)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 46 boots: 1 failed, 45 passed (v4.14.164-41-g0=
4f13b8f773f)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.164-41-g04f13b8f773f/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.164-41-g04f13b8f773f/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.164-41-g04f13b8f773f
Git Commit: 04f13b8f773f9890d67c8c55321adf4ee6fae268
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 32 unique boards, 8 SoC families, 10 builds out of 201

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

---
For more info write to <info@kernelci.org>
