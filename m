Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71A2B1087F4
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 05:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfKYEk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Nov 2019 23:40:26 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50516 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726998AbfKYEk0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Nov 2019 23:40:26 -0500
Received: by mail-wm1-f65.google.com with SMTP id l17so13932898wmh.0
        for <stable@vger.kernel.org>; Sun, 24 Nov 2019 20:40:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0DI5xC/vy5oCzoBsUIuXmfbYT7jVjC2pG1BzSDmg8wY=;
        b=d7x+aT287ROBSJQ6kvWZV6ZJhAheZPfEL0RlOw3r+vjnr8xW6TXdmXmQRDNQeTndSP
         CSWq36IomXNhRoLJJ+82jqG1jBpMBZKSfhU9QJ4dJxVFclQ4WYSGWFjV4QJ/QBncv6x1
         D2ud2plRqEAuxvshWD5L4OkIc3z1sbW1YXJ27Py1meqXQ4Lcy/j1ccruQp946XcoIeLh
         6rFjbI3zct9TCZL/9StfohadxDdl11kSN0pflJ6gVvmhCULOWN5bJYA/GaPOQy14Zu49
         ELwdbIXcG2fdrIQp7rtfUwpaSjdfA64lTLQ9/3LC8FeMzL8pRP8AI/sRzboPQZWaHpkf
         LK4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0DI5xC/vy5oCzoBsUIuXmfbYT7jVjC2pG1BzSDmg8wY=;
        b=ByEb2IQCAzwsp5Pj1aJvhkm7yv5ImT97QfL8DvB/0nscYsNowg4wGhfcwbWnAupaV8
         lX2cUbD7ewrvlAU7VnJXQIaX9Oe7crcdTDuRyuC1MaFvTInmeYm2ciEJ0m7Urkt6ZCnC
         Ot0ekdc0UgQpztDnVkpAbo7sgNHq2f8g8E6o1OWD8XyGt+XMnhGwilPp8GBQU2AITOTw
         CVoXU2hrTHUXW1oVuKJPmpLJRcaXxw97+liQrrjaZNDHJxDNBfkcMIUKTuIzWuwcZuiM
         ZfkYsQ/330taj4+//7lNAYlHrYk6nNzR4dQBbq7CItEfPULjEMq4ukez6XltOu+JYXSg
         bESQ==
X-Gm-Message-State: APjAAAVYM39pYea57VrPNfCCaHeztOjvYRWdk1ZPt0o8GwkiGv74F0r/
        3bQEDcHkXEM+8tAgJNcHHKB72uemtRnKDg==
X-Google-Smtp-Source: APXvYqwM7ZSIsagbk93Cw+DsrkxbmeqWQHa7yzTpYcdv4pJ8V8KatQ4cw7/7YJVxdepW0UXeEVMAOA==
X-Received: by 2002:a05:600c:290d:: with SMTP id i13mr14716825wmd.139.1574656824220;
        Sun, 24 Nov 2019 20:40:24 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s9sm6841665wmj.22.2019.11.24.20.40.23
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Nov 2019 20:40:23 -0800 (PST)
Message-ID: <5ddb5b37.1c69fb81.da0f6.1021@mx.google.com>
Date:   Sun, 24 Nov 2019 20:40:23 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.3.13
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.3.y
X-Kernelci-Report-Type: boot
Subject: stable/linux-5.3.y boot: 77 boots: 0 failed,
 76 passed with 1 conflict (v5.3.13)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.3.y boot: 77 boots: 0 failed, 76 passed with 1 conflict (v5.=
3.13)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
3.y/kernel/v5.3.13/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.3.y/ke=
rnel/v5.3.13/

Tree: stable
Branch: linux-5.3.y
Git Describe: v5.3.13
Git Commit: 42adce4180734a883f2d9b6cec24446d49c5c8eb
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 50 unique boards, 18 SoC families, 13 builds out of 208

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
