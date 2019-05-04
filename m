Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBD0813962
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 13:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbfEDLAY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 07:00:24 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40411 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbfEDLAX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 May 2019 07:00:23 -0400
Received: by mail-wr1-f66.google.com with SMTP id h4so10973824wre.7
        for <stable@vger.kernel.org>; Sat, 04 May 2019 04:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=giIPqDE9BDO471zhXmc25O36QVokEE31gao1fmSRbHw=;
        b=aOlBH708Bbqu0uFbGvhqP9rRYhqrKUNTBVRLOUrNtINiA2VvtooNdZ/v/C/c/mgWRX
         nzDZsO85QuMCAMp0Asgk7tLxnhn/y/hHdzz7oyMjHdDOvYb0aadg5dkZ75OVfFQZMzHu
         utGBAFDxCzH9QD6cW5eCD8X1UhT2wOe3loJOrolfvlgrcqxv5auwAvsrQY+YiN32nMDM
         2aw4m3lGpCf8Tzi+aMxIUXJoqf8VFkJzitDNCExirpAIIpThJKK/3JGjL4XguGxT4/jp
         WCVgSchXNnk7Z5Vr2NCrnYq3igJJZOJ9cUkcH+BlgrgomZShkZ4kKyooizjjHG2lfcgK
         YUVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=giIPqDE9BDO471zhXmc25O36QVokEE31gao1fmSRbHw=;
        b=o/waJhuy+zgv2L/Ak9WCf/RMXvga9W8rtZagXu6nEKD/her54rXU7z7jnPW7JPF1Z0
         wcIjYrtzPvDH9Amr7MLsi3zrw9nq2NCyS5k/SAw0rDr9poq7oGRxQK+rvyD8GH65lWCv
         vWS668TqHpn5VvN0wM9M9PkWUSvPD/6dnbahA7AZzQqiuG8mzq6ELAO0v9g5WIaetEmh
         ycrr75Nfk6PCNCCXc478A3Hf90/9nRuvvZiK4RMIPeozYZjiWf35db8UyWBg8QbLTiIC
         lGehs3DITn0LNAdy/gnz64XNgbU1p4OaKR7NY8tKwfrlKJ2aeDnNBu42lqSPak+4v74N
         mR1w==
X-Gm-Message-State: APjAAAXiiwCtutyh0JcrE3UFCpvqjRnbmCdol9c1l6Ts4yDf9rsDlJiL
        RQn7JMB9LY6mGHNq1eSMJuWw67kmTu/8PQ==
X-Google-Smtp-Source: APXvYqwB4TTfigrer+CPMAmfP+DXKS5J/KeASm8xEuOL584KhuZLu/FIONR16vvWGLpItH2IJY5vZg==
X-Received: by 2002:adf:ea8e:: with SMTP id s14mr10032818wrm.4.1556967622185;
        Sat, 04 May 2019 04:00:22 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id u11sm6579146wrg.35.2019.05.04.04.00.21
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 04:00:21 -0700 (PDT)
Message-ID: <5ccd70c5.1c69fb81.f833c.5710@mx.google.com>
Date:   Sat, 04 May 2019 04:00:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.173
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.9.y boot: 44 boots: 0 failed,
 43 passed with 1 untried/unknown (v4.9.173)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y boot: 44 boots: 0 failed, 43 passed with 1 untried/unkno=
wn (v4.9.173)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.173/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.173/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.173
Git Commit: 4b333b9c99aec82a0ef41f23eb4cd2e3b3e46026
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 21 unique boards, 12 SoC families, 9 builds out of 197

---
For more info write to <info@kernelci.org>
