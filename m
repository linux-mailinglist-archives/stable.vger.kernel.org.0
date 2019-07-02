Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC8985CF29
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 14:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbfGBMLz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 08:11:55 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38728 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbfGBMLz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jul 2019 08:11:55 -0400
Received: by mail-wm1-f66.google.com with SMTP id s15so741805wmj.3
        for <stable@vger.kernel.org>; Tue, 02 Jul 2019 05:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=e+9jO3EwOEXl25neut37mAgd7vjkxK0lA1LxJ9WXw+Y=;
        b=UEnZUh8P2ygeiClu6YiSC2dkWdRHDv+XG327Hpzx6Q3jCQoTQkIp2x4cRaYUfkXT1a
         Tg2q0cidLAxdPgLRrW2ld7Rp0EWZUVLOs9GRFo/sGSIE5wQ3giHjl/VNXjXh77+qAN91
         I1bAPfM1n2e0XdR/G89zklQZ7j+yoMY2/r/Y/ti+5j8keN3vAk5f7hiS+WjOm6UJvtou
         2NB80onjpt20VchouKQWDPTS2gUQCHVwITBlVAaw/6y79be9olXjuM1CasM7Wdo2N2Qo
         h2sWoc5QgtxkOOYahqNwaQCyo/GLnJH5NpTNaOKg8l5t9b0dbyDYa+BHhfdGis+V0df+
         Z2SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=e+9jO3EwOEXl25neut37mAgd7vjkxK0lA1LxJ9WXw+Y=;
        b=pFE4knQ0YOldGSQoZajkEwQqD7CBGX8DHmQ7E+eGGx78FJxv6tXB5mYXPTT0mTukVn
         YceJZm8xOgXdRISQMv4a9k8SFwnRiw725wfM9bCPUMn18yJYS6xO0X0ywAFbZsJ2oCTq
         cGtm7YN0T9oEkMz5WeNjHpo6lPnvDfJrXvojflcVrVqEvBrJd0U8Bgv9sqBT4/8MnqM7
         Qs3SF7BPc2lR6+eEjIyk4DMDNqOjgfKvA9AEhXCwWpVZad8sH5IKVHNhdfBIDAf1ZT9A
         WKr3TG0Vxuyg7nkBX5QegHZaWnhXml2kCvYOaBxarFgzAYJ2UUMpRAzWr9TrDhWCNTcb
         E49w==
X-Gm-Message-State: APjAAAVk3D1/4ZWRpGmgrV2iuexOmdF9KNMPvvH+TYGg4i8RfsTWA+Sv
        q+gh/gfxA0stY3zRWCM1N+GT34Ef6s4=
X-Google-Smtp-Source: APXvYqyQUmDbpwGQooPq8ZAURhrVDX0Fj86b3tBBVsncvIMx0JuiOnyf0t8GQwNmp/5t51QPCXQmSQ==
X-Received: by 2002:a1c:be05:: with SMTP id o5mr3382815wmf.52.1562069512877;
        Tue, 02 Jul 2019 05:11:52 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x11sm2591658wmg.23.2019.07.02.05.11.51
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 05:11:51 -0700 (PDT)
Message-ID: <5d1b4a07.1c69fb81.84e76.f976@mx.google.com>
Date:   Tue, 02 Jul 2019 05:11:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.56-72-g828a73287676
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 131 boots: 2 failed,
 128 passed with 1 offline (v4.19.56-72-g828a73287676)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 131 boots: 2 failed, 128 passed with 1 offline=
 (v4.19.56-72-g828a73287676)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.56-72-g828a73287676/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.56-72-g828a73287676/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.56-72-g828a73287676
Git Commit: 828a732876760accbd58e1c3ce70be8b6ae0c03f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 73 unique boards, 26 SoC families, 16 builds out of 206

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab

---
For more info write to <info@kernelci.org>
