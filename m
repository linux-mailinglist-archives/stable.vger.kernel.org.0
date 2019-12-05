Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D02B91148A2
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 22:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730270AbfLEV1r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 16:27:47 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41904 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730289AbfLEV1r (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Dec 2019 16:27:47 -0500
Received: by mail-wr1-f65.google.com with SMTP id c9so5405405wrw.8
        for <stable@vger.kernel.org>; Thu, 05 Dec 2019 13:27:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wUf2ODf5cHhqBpFaMzpUrgva5Bki5b9udADDsp0wiZI=;
        b=l2EK40qI3FogCAxlFFv8xGyoiopkyJiqlk9J2/nqothd1vQCriL6/ENOAVhF2wS+nt
         VxPp8bEiIO5JKY250oLjtgzAnF+kd36n1QGTc9/G1kGyaNkqC7EwOXMp0IvziK2RbZIB
         1ecEVIUFsUAMiHNKbd5xHJZpNogVXuU3BLHxLXLuTBEpgda3x+eXYkJ8WwxufK1T+shi
         NGPzXbTIVzuDHttPKfmeXImMvTXWFsBRy0Bbri+44+SAxtihe302h1fR7AXIRNihjI1j
         Io5+H69uIM+CBgOqWfIeQezqig1zNDwhgTETcg7ezLWzgPkSPlazvuHT9pguBfWzbM60
         IGgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wUf2ODf5cHhqBpFaMzpUrgva5Bki5b9udADDsp0wiZI=;
        b=exp0GhIeUvceZIO3p8M170L0W/qSEh9WFDwzjd7tmBs94IpJ7Xx4QtjiIRgdtd5k2R
         8J61iTk++zCCA5naTwG+sEFxygofKx4eGOcdSdvRgdT1aVT8jkdbFoQuOn/vGimojuZV
         04mk9mL0ucfC0fnEz1o6+pjRZ0OVkOQSXCIzH4+3EVm6LcD3OsC6dclHwT4+baPsgR6y
         XnVbc+Sc72BC06lVSitgWjMcpuTHhbOieqQ7ZKcvhaK/w8I6P8Da72EqFpv5FEzQqMPM
         gq2FnkGTqCFVl6YHZVrb57wjZy6exyfJnk7NdRSlsWj9W/vU5CrwydJACZefUFM6pbCf
         5CWg==
X-Gm-Message-State: APjAAAVT6iBo9xs99bvZbqm0tPeiXW9Lb9v4ChnJh2bkr+QfSCTp9Y+7
        z2mGTe0yAUgh3tGh/YLMJD4jl+RDnPW0dQ==
X-Google-Smtp-Source: APXvYqz8IPq/T/ZCm65hhsXVKF0Wbo+jvK2h5t41Dmp28u2Md0GSgR3BBQfSU8RD8w1b4oLDzr2XXA==
X-Received: by 2002:adf:eb51:: with SMTP id u17mr12188820wrn.29.1575581265464;
        Thu, 05 Dec 2019 13:27:45 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y6sm13449411wrl.17.2019.12.05.13.27.44
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2019 13:27:44 -0800 (PST)
Message-ID: <5de97650.1c69fb81.e2a19.74b0@mx.google.com>
Date:   Thu, 05 Dec 2019 13:27:44 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.206
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.4.y
Subject: stable/linux-4.4.y boot: 53 boots: 0 failed,
 52 passed with 1 conflict (v4.4.206)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y boot: 53 boots: 0 failed, 52 passed with 1 conflict (v4.=
4.206)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
4.y/kernel/v4.4.206/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.4.y/ke=
rnel/v4.4.206/

Tree: stable
Branch: linux-4.4.y
Git Describe: v4.4.206
Git Commit: dc824ef433c6b378e90bd87bd6a57fd607de7c32
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 26 unique boards, 10 SoC families, 9 builds out of 190

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
