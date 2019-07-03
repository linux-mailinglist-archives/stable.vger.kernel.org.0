Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB4545E92C
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 18:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfGCQde (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 12:33:34 -0400
Received: from mail-wm1-f44.google.com ([209.85.128.44]:40302 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726823AbfGCQde (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jul 2019 12:33:34 -0400
Received: by mail-wm1-f44.google.com with SMTP id v19so3082109wmj.5
        for <stable@vger.kernel.org>; Wed, 03 Jul 2019 09:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UhoiODPjOKEl7pCLJbadjOZBPIcp2zIL1rtEAwCDwIY=;
        b=g1ZPIMPYtE2Ql4/aSS+0YMZTcNTB2cTndeTjD4TXOTxSojJBom1LhC9lkmWQ/kB65G
         7CjECHLreDjfDivlkHRpx7cAH/buIMcD56n9CdVl07SAqeQT3eC870HVf7nvQGyGwGte
         d26MtuWESArCnOFjz7zI9vuARmnaeQE+5SvHlcYamIwQSGq54Ul3t2QnBkIOpItG2WJE
         Q8GcRZ59SBnRaJL1ldfAwVwM4EgGOrj0lP+Wm9DqGaFTOuqn0M7F5cO+fQ6fP7FybpyK
         h/ZUbOW5sNY2MreSCoTja9rewJf0/a4jARqqQPR+b6E++hUGc2cyYgS5WOZuqlQze4u1
         5mOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UhoiODPjOKEl7pCLJbadjOZBPIcp2zIL1rtEAwCDwIY=;
        b=oDZDQAFB4XWk8cBaFxAC8gp3E9+PLLHoBr5514O8DaMpLtUARTjnYrsCnx0w5AoV47
         2uAOkJiDRz4tm+nDxrILK2Dvtsd/ZeOr4XU+TxIKPK7XUI/uH1qn312K14gQQASNLWv1
         UK7pFKWsDhvhC/dS2T+YLwBZGerzzfvkItk0tQs+BvxXULdt7qg3l3Dcvzg/hoyplgR7
         vSUp86GwxalquW/MY8rBjy1Mp8IzKPwY2zAwwvLGlE7LBwo7PHQC65uSQkMqX7w/D9wm
         T/UWo9OLndfWj1egFHGGctMa1DEzaojNtU/GXxNF1/5O/vqp0fOQfvbeY0rMq1onvGCn
         XLTg==
X-Gm-Message-State: APjAAAV76FhWRqFPb+DBghY9C/qXu4a3I85LCZlY7UdnxHHRvsWdD7GM
        E/dHKNJViXHoytUrkJpkYdF4zNndw7M=
X-Google-Smtp-Source: APXvYqy20m/Fx3cWxohC5pXMIl03lJKEk3kiAKcPbPj97xqw9oKo+XJ/P1+ApqiTHNVt6cX3rkz36A==
X-Received: by 2002:a1c:228b:: with SMTP id i133mr8781738wmi.140.1562171612380;
        Wed, 03 Jul 2019 09:33:32 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y16sm2850453wru.28.2019.07.03.09.33.31
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 09:33:31 -0700 (PDT)
Message-ID: <5d1cd8db.1c69fb81.3c79b.04e6@mx.google.com>
Date:   Wed, 03 Jul 2019 09:33:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.57
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 127 boots: 3 failed,
 124 passed (v4.19.57)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 127 boots: 3 failed, 124 passed (v4.19.57)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.57/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.57/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.57
Git Commit: 1a05924366694d17a36e6b086d5bba1a8d74b977
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 70 unique boards, 26 SoC families, 16 builds out of 206

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab
            sun7i-a20-bananapi: 1 failed lab

---
For more info write to <info@kernelci.org>
