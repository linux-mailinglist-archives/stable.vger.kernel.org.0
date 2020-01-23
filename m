Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4956147372
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 22:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728831AbgAWVys (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 16:54:48 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40326 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727215AbgAWVys (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jan 2020 16:54:48 -0500
Received: by mail-wr1-f66.google.com with SMTP id c14so4948916wrn.7
        for <stable@vger.kernel.org>; Thu, 23 Jan 2020 13:54:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lAu112vuHegsSzgDm3eSYs/EzfEBvv1uOjTKRUVj0Pc=;
        b=KC2EODl4WtcOiO8uz/bUjVAobBR7ktVuEwqLSxSDYPqF02eSLQibHhJgsFi7cKFINI
         x0jlVIz0XSPCgcVF/9M3ascVfwu7cEiv1DZw2KfPlsw3dIZ5q4YR49LK6Dq+/bceKUiW
         4QvknLvMdbiuBFezQ2trsu438MphJLtMxzoGxzAWqHb/ageTWYIz6iIM6Y4RaqxpPhBl
         wgsL/U0/RddLaCcPvErRUsJ7Hjkgx4OP60YHCXQW92NIq+BUz7gsBfah7xhMy18kQNBE
         NEeBsNoPINvBRpuH6O5t8OhyY1drzhN8lVTTr5AuCHr+lw6EAG5YXgpca+HLYd7Y5WIW
         /B4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lAu112vuHegsSzgDm3eSYs/EzfEBvv1uOjTKRUVj0Pc=;
        b=agaWUe/lLdTO/haf9YtC6CNUGl6MISAGCW9mpX8eIOsPBb7RJnGgW8uBdJU3G9aT4W
         VNjUlfqTguxX90CeyXVx495A8svMJsVygN7tl1RN5zObgGofRoWY/3AClmX2dab6Rcg0
         o6CAcGEDLUwPSKFrxO1KF4B62OMLho0xOEF6RNiN7OinHxb/5ZJu4KA+llrNNBcuyrT7
         8/YscVg14B5EaXekamOc0TxH81u2Y+6rhhRSGmHGR+RKw3FBuZ7EklMSvAn3BRvKiYpq
         Zv73ulPqOACXhD58gIvTUEAo3kVJA3Wqnk6JrwpagHA6IBwD5V3I0L0Ges28ASHtuML3
         eumw==
X-Gm-Message-State: APjAAAXeU1D5OLE1EbuKXWjrXmXtpOshf9x8ticUlJmUcrj52KLtTkxC
        9AfEgq63Z4ynLMvQKpj4HhhKNFOaZdNhUQ==
X-Google-Smtp-Source: APXvYqxASBkzUg3q58k/CMXwVg2mi600ZrG6kbnW/MHErZkbBsuWbOm/Qf+pIzlg6EE9lBxhLh/yDg==
X-Received: by 2002:adf:ec0d:: with SMTP id x13mr162386wrn.400.1579816486683;
        Thu, 23 Jan 2020 13:54:46 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n187sm4355919wme.28.2020.01.23.13.54.46
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 13:54:46 -0800 (PST)
Message-ID: <5e2a1626.1c69fb81.f5ecc.3318@mx.google.com>
Date:   Thu, 23 Jan 2020 13:54:46 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.211
Subject: stable/linux-4.4.y boot: 51 boots: 1 failed,
 49 passed with 1 conflict (v4.4.211)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y boot: 51 boots: 1 failed, 49 passed with 1 conflict (v4.=
4.211)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
4.y/kernel/v4.4.211/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.4.y/ke=
rnel/v4.4.211/

Tree: stable
Branch: linux-4.4.y
Git Describe: v4.4.211
Git Commit: 4a070f3c06a103066c3155bd1ed3100aebea1a78
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 28 unique boards, 12 SoC families, 9 builds out of 179

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-collabora: FAIL (gcc-8)
            lab-baylibre: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
