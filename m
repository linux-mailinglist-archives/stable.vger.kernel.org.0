Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA4312F202
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 01:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgACAJP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 19:09:15 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34027 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbgACAJP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jan 2020 19:09:15 -0500
Received: by mail-wm1-f65.google.com with SMTP id c127so5917411wme.1
        for <stable@vger.kernel.org>; Thu, 02 Jan 2020 16:09:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dpddI/XIX88Gv9z1CaG2HMgphEfgypKzVUoGMxd33Gs=;
        b=ImaOSYQgxW9fY6D/Z3X+cCWIRVdffi9Xd6TgGhmLegE8/IPkMQgaS4JypIzpZgblM2
         7cqM0GEwM50yb/CQifN9D1WU0FXZz9K6unqX6VgD36QsGHSOIMIHZS56D+3kXu9ItaK7
         e6rK+sFH123MdtFdIHGeeF1e1xHjrc4ZPfvwILcm4hNokGHExd30di+ysRV4YdO0W4oF
         8/zkrwVbJZEs3s+AJniAN33AZDQkvlMyeSWEp4SSwayC3OyoJivfRn2TAYyJm+jFMMne
         5105VnRBCGb6ZAP7et7d8amnlevDngB/WqPPonu1MoWJ33c2AV7q53UDtLpJGOdOTo7W
         6mcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dpddI/XIX88Gv9z1CaG2HMgphEfgypKzVUoGMxd33Gs=;
        b=LxfC9aVAXt31gR1cjIvyidPXKMT7UE1U2KeBuqc5YWq5wc2Pj5nsXq/8qQbqWfpmoZ
         K0V7ganLOtXrx5J0NLhVfDCKoIKc54nmie+cLu1nHDu3vXhbQx0Y6zVudy5t+wGHN6hO
         E1jGRN+vmquH9gOMGTnOF8+rWK0+eHBh00YXyKkTUkZQ3G0jKosJQFQP7XzBT3AqxU4O
         htPRYZZHLqWyIlDsLg7Ym6ccSzqBH+hsW9Kap34nZXDfUEip3BfINmM5MPdldSoaKJNk
         T43scIzhpeRB63YpEMjo3qofnaEjy8Dj5XY4TcDZPhJJrwwBDRq/r4BFWILgu7lvq3fo
         WWbg==
X-Gm-Message-State: APjAAAW5PnyaA5qW7QviuS5qz0JGhS90+HZqQW+75KXPRB4TgTN1ap6p
        aDKJEkmRz7FnJReLyt/Cx74D6c0X5VBEIA==
X-Google-Smtp-Source: APXvYqxLvTUGgnMGjfUdKXYSMKeVzHdIEoTu5dCPDXqV/+YHfjirk05taXOzW+nyFzV1rUuQuuUJPQ==
X-Received: by 2002:a05:600c:21da:: with SMTP id x26mr15799800wmj.4.1578010153895;
        Thu, 02 Jan 2020 16:09:13 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g21sm62404125wrb.48.2020.01.02.16.09.13
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jan 2020 16:09:13 -0800 (PST)
Message-ID: <5e0e8629.1c69fb81.9e051.e988@mx.google.com>
Date:   Thu, 02 Jan 2020 16:09:13 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.92-115-g2c7ea6557e21
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 63 boots: 1 failed,
 61 passed with 1 untried/unknown (v4.19.92-115-g2c7ea6557e21)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 63 boots: 1 failed, 61 passed with 1 untried/u=
nknown (v4.19.92-115-g2c7ea6557e21)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.92-115-g2c7ea6557e21/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.92-115-g2c7ea6557e21/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.92-115-g2c7ea6557e21
Git Commit: 2c7ea6557e21c6c5182966a85696eec040e412f8
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 41 unique boards, 15 SoC families, 14 builds out of 206

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            hip07-d05: 1 failed lab

---
For more info write to <info@kernelci.org>
