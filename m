Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 923DF14233
	for <lists+stable@lfdr.de>; Sun,  5 May 2019 22:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727343AbfEEUCt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 May 2019 16:02:49 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:38451 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726905AbfEEUCt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 May 2019 16:02:49 -0400
Received: by mail-wr1-f45.google.com with SMTP id k16so14585711wrn.5
        for <stable@vger.kernel.org>; Sun, 05 May 2019 13:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BSLNib9DvnPuPqNLVp4dEersvTcGQn2rD8jiqVUUxOA=;
        b=Ri8xa12PZHzS5FHsuv127+DSqGWS6fgqFnNwcypOBytz8j4+kJWxWsiIFH7USM0cJE
         EIOYlZDvaRoALJGVH6hZ5bRXP6dO/TRV48ylOexvtM7G+0y236OVIB3B56KQzOODC6TT
         UZbYRXV2nUiSXdlLrIKG5YSe1KWgRCZjyKXon0FcdpqsBFbjd2aW+oHyeWG4zQ9KwgfT
         v9o13Mv92f9VBDuL/JwrgNDAcRikUWDgryXvhd6v9W4uCneAxz6UBttngpcH8YvB+Zgw
         4Ql8PcT0l20w0RDCQFGI40AGDYx7FHX9i7KvKcNzfW9Ab5ADQKvQZ79WjkcNkNqcaI0j
         nSMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BSLNib9DvnPuPqNLVp4dEersvTcGQn2rD8jiqVUUxOA=;
        b=c5xT/K9oD013hSWqVbRZx0g/HM2/k7f6cT9JxUrcFIrrdFWRUKSHHZXQUT/vMJOaO0
         d7t9cZDi2D1mrGmqnEcMUZiWlk+uCC0mtfjVsMWkoCX+K4oqFXcbpcSil9AnWkNR6EXT
         loEHBps0UL1DuWPFTWoEOOedXN8dSh4f6re0hp39f5x+nj2lMNhT807OqWJC3t9mP0bM
         3xJc5nlkeRmDplauEOho6be1ZGR9IFc3jwvF0P9cqYHFg0/AVKM6nrIFyYwV9s5AIwOr
         FOfUhyDylH+i8UoqWZ4QgOUHhTV+rtItqfZSMHzdIzXDn10wcBofVSrzKikiMaHwvsCG
         lzAw==
X-Gm-Message-State: APjAAAXszClZXFngjcCExcbX1/mA5XY2Bn5XixpwFwg2HHcnYmj2tGTx
        UUnSqvtu5bw5fpWOw3osl7swyDZNCBU=
X-Google-Smtp-Source: APXvYqzwLq0P7eitK50PKPUJYMIGFXa0cidoV+L11L1LoUbQMkcYu7fDq5t94yJobb5iHHx/qwQVSA==
X-Received: by 2002:adf:eb0c:: with SMTP id s12mr14613608wrn.229.1557086567594;
        Sun, 05 May 2019 13:02:47 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 15sm12695924wmx.23.2019.05.05.13.02.46
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 13:02:46 -0700 (PDT)
Message-ID: <5ccf4166.1c69fb81.2c7f.6b6c@mx.google.com>
Date:   Sun, 05 May 2019 13:02:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.173-27-g3d90559ea516
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 104 boots: 0 failed,
 100 passed with 4 offline (v4.9.173-27-g3d90559ea516)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 104 boots: 0 failed, 100 passed with 4 offline =
(v4.9.173-27-g3d90559ea516)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.173-27-g3d90559ea516/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.173-27-g3d90559ea516/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.173-27-g3d90559ea516
Git Commit: 3d90559ea51678863eb996c86c05a2b9f1487681
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 51 unique boards, 22 SoC families, 15 builds out of 197

Offline Platforms:

arm:

    davinci_all_defconfig:
        gcc-7
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-7
            exynos5800-peach-pi: 1 offline lab

    multi_v7_defconfig:
        gcc-7
            exynos5800-peach-pi: 1 offline lab
            stih410-b2120: 1 offline lab

---
For more info write to <info@kernelci.org>
