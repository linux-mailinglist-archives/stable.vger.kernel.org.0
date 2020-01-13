Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15E7E1390F4
	for <lists+stable@lfdr.de>; Mon, 13 Jan 2020 13:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbgAMMTu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jan 2020 07:19:50 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37014 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbgAMMTt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jan 2020 07:19:49 -0500
Received: by mail-wr1-f67.google.com with SMTP id w15so8358515wru.4
        for <stable@vger.kernel.org>; Mon, 13 Jan 2020 04:19:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iPrJf9ZyiOgaDOwMZZMP6P+gxz0SM91z4rqm/9c3xQU=;
        b=IHfPGCu3vhK9GQ3SUi0YzvCQa6tc3wTjzstSZNDz3KXimxBPe6QP0KueEu2WDUiXUp
         1dUqQ5hP3R1zmZq1vShmr3Ue30WWWdNDN6yGq+TOoDl/MUzsFNkTY17GP1WmOunPOx9a
         rDMdfqtwDfpe/bQyjkdSjf0ab+KXB/9rL4yojl7L7A8Z7otwnGW75i+M/iyp37nmZpnj
         JEPb5Y7K3obRMsfJt2DDdSbgLx9vProm6h0NN3ivVd2u1pHBUKO7R1RxAMZ6enq7Q1Xn
         euLx4W7pCD+kakvavVlun8K9vJvYFmbvYJ3FJrZPfdmzwusdAqLYpEuAeaXX8AbPXrmo
         LBUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iPrJf9ZyiOgaDOwMZZMP6P+gxz0SM91z4rqm/9c3xQU=;
        b=femimt+3A+wEnDkqqcy4jSUa9Zj+cVtmNP2t2zVq44Qj8D8KiFYsF2WMX4v2iR0vxE
         RELTIPmln9h40U8ITQ73eQZz04ai58BjPp4BxdPzdgZUEfGYSZdpofB3L62RQTkj0AC6
         abC3A8uRECwpw8Ve8rRFUzkkYuW3Aek17gYVQKTh5C96ADjF4+UjQGusaKl96ADfDA5Y
         BSjfxDnZO0qR2s2sZaQnc/WLug2qVw4zuJgDkP8wsX91+QMFgRW6gGymhDO6wTIbKXny
         ilhdvi/eKlEEeefi1Bwxo6tJevYzs8meIUKw2Xv8VRHYuhJyudMNevR3xzb8+otOb2Lj
         RL6g==
X-Gm-Message-State: APjAAAUeth5BFhJl9BYQmZD/yVfb59I2iXy5bsPq2ES5aYTHzdsjBUmQ
        HRlBfnMEyKWilRTA2IivER9VoU9DtrKkTQ==
X-Google-Smtp-Source: APXvYqzJZe9TVYTWyNDC+q+NKOQQu/q+9RsTEYGMt6Y1b37wUXRulsUSGQ7KtKok7Soy4kO81STn6g==
X-Received: by 2002:adf:e290:: with SMTP id v16mr18758391wri.16.1578917987625;
        Mon, 13 Jan 2020 04:19:47 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w8sm14400389wmm.0.2020.01.13.04.19.47
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 04:19:47 -0800 (PST)
Message-ID: <5e1c6063.1c69fb81.a9fc4.b7d4@mx.google.com>
Date:   Mon, 13 Jan 2020 04:19:47 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.164
Subject: stable-rc/linux-4.14.y boot: 65 boots: 1 failed,
 62 passed with 2 untried/unknown (v4.14.164)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 65 boots: 1 failed, 62 passed with 2 untried/u=
nknown (v4.14.164)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.164/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.164/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.164
Git Commit: 6d0c334a400db31751c787c411e7187ab59a3f1d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 38 unique boards, 12 SoC families, 12 builds out of 201

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

---
For more info write to <info@kernelci.org>
