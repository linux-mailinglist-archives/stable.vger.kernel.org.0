Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E74F64DB3
	for <lists+stable@lfdr.de>; Wed, 10 Jul 2019 22:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbfGJUsF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jul 2019 16:48:05 -0400
Received: from mail-wm1-f48.google.com ([209.85.128.48]:51135 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfGJUsF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jul 2019 16:48:05 -0400
Received: by mail-wm1-f48.google.com with SMTP id v15so3616902wml.0
        for <stable@vger.kernel.org>; Wed, 10 Jul 2019 13:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LzQN8Nr1vZLBbPi45BZ3Dx/Y5u3sL14OGWrN5tdY050=;
        b=CwUe6yXs+NL+IvoMxGeq8X1K6hBq1ZWgPTHFUvsy05gLjZdvH/MI+fANBGiG9sPWrm
         7fZV0ONrALoeS8O2v3xyB+djTGuKRtHjwVFsKuvRP1bVNlwLIQ/ot/7q1OU9Up7DRAsw
         XdEhrvhHxDLxdvZnwBLxWy556cWDX/IgBl3Zdhy1UQCOQl10VTpduSnvv5uCm0X6ZZzp
         iLI4c/iYY/Cbfpx76/lcHrcBrzbTC8yBXyfOZuAJ1s9D1+OwFW1XbjLgb6SvnSiX3vDA
         5vwkwujij6T+zIGYSyvEs/M+wgPlZ2YIYPMCZ7tTyXuE6xXTitZD6EWl3/RVYlU548qb
         14xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LzQN8Nr1vZLBbPi45BZ3Dx/Y5u3sL14OGWrN5tdY050=;
        b=Uo1MLMNr6EOqBDY/Ij0cnApcTwKfdD2Z0EqDmPRa1JOV66nHqaBuYiL2UkXwNfqLwO
         tNVAtCTRqsZc/Ox+yGgUJ6tA68eiknfsb9PPmXMBAoP4Ezu8cl6eUP1Ub0QyrBtIXjlp
         G+e3EkXbbsvcguqZL4xwO2GTr64CdOqxrlcphaAWQybtqt6JFIqKloRWochM/eU0RhJV
         VdWEp+9BoqW6G845yIuJZ4SHeg2v3GfIf5jG8jbWMSWLvLL7+SWHPqrawrJX2cMgI8VS
         XSUIHSZiRNlVNeftBnVaFsTy0Vb48JD2Ou28KaGyqfGON75/ul2cKPLZDrrbA97E+zUw
         MTGw==
X-Gm-Message-State: APjAAAX6PSoqwi/DIEI1rHBk8zekU7NfXmcH8ydG072NciJcFnKJfz6x
        RlgXpCqQinGKVKsEN4EBl6PLU3gUQzre5g==
X-Google-Smtp-Source: APXvYqyulCTsEB1rWo96kG+2EH2StbqSqKDpt0Sk0cFLdTjZRL87IO02hP3MCID9WB8OwOxI990KrQ==
X-Received: by 2002:a05:600c:2549:: with SMTP id e9mr6919849wma.46.1562791682656;
        Wed, 10 Jul 2019 13:48:02 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j10sm5043242wrd.26.2019.07.10.13.48.01
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Jul 2019 13:48:02 -0700 (PDT)
Message-ID: <5d264f02.1c69fb81.e9bbc.de48@mx.google.com>
Date:   Wed, 10 Jul 2019 13:48:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.17
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.1.y boot: 127 boots: 3 failed, 124 passed (v5.1.17)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 127 boots: 3 failed, 124 passed (v5.1.17)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.17/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.17/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.17
Git Commit: 4b886fa2b8f167b70af8a21340dfb3e24711e084
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 72 unique boards, 26 SoC families, 16 builds out of 209

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab
            sun7i-a20-bananapi: 1 failed lab

---
For more info write to <info@kernelci.org>
