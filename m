Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5481543A6
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 13:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbgBFMBp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 07:01:45 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37947 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727111AbgBFMBp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Feb 2020 07:01:45 -0500
Received: by mail-wm1-f66.google.com with SMTP id a9so6780580wmj.3
        for <stable@vger.kernel.org>; Thu, 06 Feb 2020 04:01:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VTAw99JrNpdhodOHXvS4cUbk/MvADwKXU/iOlIaZU2A=;
        b=AbYm7SXx5M2tKOKljOlhCl5oeFfg254Ji/QxDwCgWbY6Twvcuf3vj0cQNmHoTFMEf1
         HgtNDhpVrK+8rufbDNH9C7IeBPyqbsbcGFHse+BO+57M1RgznAT5D0txysl9/CzdKwnh
         OaaJNythAjfWcolnwTJ4nNgxKsVFMaJ0Y/9zzuSvrra41gxScM1dL2/qRxFY49UTy7g1
         pn9CWYSFJSqhJKP9KNjfzPE5Cutx/v/tH2vO4ZGwkQWimTQZTWJEEkN3bqjGIVaKKqz9
         lpkoSqZhBT+q6Z4ePL/n/VNNo2Eua2AVc8bE7v3DSKLJCZoJbCSMGagelFZRSPvYm6S4
         9F+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VTAw99JrNpdhodOHXvS4cUbk/MvADwKXU/iOlIaZU2A=;
        b=Ay7JfvdhwPYVMfmuXMkqkxTylBL8yUffi/oX8/bW6FKEmFKXqx1OPdinCvCHWVG56e
         84V9kQSDPoCnp6ZSjHXPR1aKnVc5/oJ+6ly9X4Qo0OhKTIU917yMFP+5IB7pJ7ZWQLl0
         WLsxezAP7YG/kyoDqDFk8b62YE7naNUFd8T4qKzdH0szbN5g100QZ84otAWnb3fTjRFa
         JTLH6NpBz1Ri334UQNd4U0oeKBiTm9d3dR0lWbIZdWbShup+DxSrVJmKr4GXsgZmy3i/
         dSUi6D68Ch+0+O2Twen91WHqTLMJvbROB4DGK4IZxxV1Y5ONUpvXUJGCjki6yc6lXoOH
         qdyg==
X-Gm-Message-State: APjAAAXedvHWg0ysWlJt06ndJVCRhSiNCNd+OAAy4C552YU5MEv9he/d
        fOAgvgYKU6G+p3k6/GJfAwlmLRVXzs5sTw==
X-Google-Smtp-Source: APXvYqx+7QXXPq3cEBsaCkvqd+lBbIFXpPKkAAhfr1uF/L3uAzeOyq2KsWhes5yt4Zw/IyHErubbig==
X-Received: by 2002:a1c:6389:: with SMTP id x131mr4360828wmb.155.1580990502814;
        Thu, 06 Feb 2020 04:01:42 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g7sm3940699wrq.21.2020.02.06.04.01.42
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 04:01:42 -0800 (PST)
Message-ID: <5e3c0026.1c69fb81.c9b78.1839@mx.google.com>
Date:   Thu, 06 Feb 2020 04:01:42 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.18
X-Kernelci-Report-Type: boot
Subject: stable/linux-5.4.y boot: 34 boots: 1 failed, 33 passed (v5.4.18)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y boot: 34 boots: 1 failed, 33 passed (v5.4.18)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
4.y/kernel/v5.4.18/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.4.y/ke=
rnel/v5.4.18/

Tree: stable
Branch: linux-5.4.y
Git Describe: v5.4.18
Git Commit: 58c72057f662cee4ec2aaab9be1abeced884814a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 32 unique boards, 9 SoC families, 1 build out of 27

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            msm8998-mtp: 1 failed lab

---
For more info write to <info@kernelci.org>
