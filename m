Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB8F148DB
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 13:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbfEFLYV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 07:24:21 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:41474 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726034AbfEFLYU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 May 2019 07:24:20 -0400
Received: by mail-wr1-f52.google.com with SMTP id c12so16747042wrt.8
        for <stable@vger.kernel.org>; Mon, 06 May 2019 04:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1jnFBJYwiVMFP8GyKnBMq35WGzjZoz83BhlH74GmZKY=;
        b=cUQyDU7hynrYHQF+JZsTiew6cJ5Ntmf2CSNjO1r66WiUvq0KYxwT3yyzJU4XAmMZ4t
         RFA9UJnh8ZgQ6GCJeroHuqjIhgLvAM6fhOdAmu9YnouIzEUI9isnSay/OpDGaX62LouF
         e4rEnABbt4A9V6Ty+PtWiAxkuR6KcWm4wNajEUe+/nyNjOuVe5Aur3ueSLJ/cPJ1p0N4
         ZSchv4EK80bZBsPQ+HL9nyU4OoWfFgq2oQJBWA7cdVwLxO2Mn8Wkjt5OtQW3KWvlakzq
         +4yym43TdVtOt/P1u44ZhUC8EGM+aI6y3DH/Uu3IK9ykovgCNNC+cKWXeZceqOhjokT6
         hOZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1jnFBJYwiVMFP8GyKnBMq35WGzjZoz83BhlH74GmZKY=;
        b=TDfrPTEMdQK0LJox1BrICCuAnSN70GUF6vEIAe50jVP0mR0+jtr/6/zI9gt0ArpZTO
         +vic3Qday6Lvd2AYZQcSAMtrjZNrNikoXlgJWnU+hm0RGK4Sv6SxlcQEnnzkBE8lJiUu
         xenYBYBfSrMspEW5Z53cWLvj8OF1xnl8zkPdauoXrLfGyloA1Kkq8pS8Ant3PMd+BjzD
         cWT39uKbWHyBvspQhWQ3oG/bzn7a4VEAnmSc5umZRSKWiu0fTgSROaJs8qU9xJtJTqXB
         RC8yhNoCyr+o2lP2Xl+8BttaqzViIobIS6MZtahGk9EdvqDrC36OZr6ZjivqVYeMFXxl
         XwVg==
X-Gm-Message-State: APjAAAUp/1Jwb93e/tS3H3gUX22BPhRwCl+rS0XX28ye/vaZ9Hcme/Dd
        vXi2J5vGcdiKK0QRI3AVNThWeLlo3XH5AQ==
X-Google-Smtp-Source: APXvYqzHRVUUw/3wAAvc3DIonwE3uhljOC2DX3B1dkme6/M6dukdl3tk5VB43tU+7Hd/OQiMcujoYA==
X-Received: by 2002:adf:e712:: with SMTP id c18mr2007025wrm.202.1557141859163;
        Mon, 06 May 2019 04:24:19 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n15sm1292256wrp.58.2019.05.06.04.24.17
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 May 2019 04:24:18 -0700 (PDT)
Message-ID: <5cd01962.1c69fb81.8d4af.713f@mx.google.com>
Date:   Mon, 06 May 2019 04:24:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.173-55-g8ca64c0a5c66
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 104 boots: 0 failed,
 103 passed with 1 offline (v4.9.173-55-g8ca64c0a5c66)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 104 boots: 0 failed, 103 passed with 1 offline =
(v4.9.173-55-g8ca64c0a5c66)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.173-55-g8ca64c0a5c66/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.173-55-g8ca64c0a5c66/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.173-55-g8ca64c0a5c66
Git Commit: 8ca64c0a5c667ffcbbb5cca22c8fcb4cfd7ff49e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 51 unique boards, 22 SoC families, 15 builds out of 197

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-7
            stih410-b2120: 1 offline lab

---
For more info write to <info@kernelci.org>
