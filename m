Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45FCA1A04E9
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 04:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgDGCdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Apr 2020 22:33:00 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34519 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbgDGCdA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Apr 2020 22:33:00 -0400
Received: by mail-pg1-f193.google.com with SMTP id l14so1020628pgb.1
        for <stable@vger.kernel.org>; Mon, 06 Apr 2020 19:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=60yblaIwULlqCBLk7QWghT8yYUX6bBiUWvgD/Zhne7M=;
        b=U4efsP7QaeMd4JacksNstfCsUTecqrhHZZBRsQqIhwlDg9z7aPiv6ohMHikzYm1YIO
         UR0k34EepbvxgxjQbI62l+qYMXriwupIQkijhE2XjR3n0FSV5A8Pj65T54Xa8CAMB1U7
         9rnbDgq2d61s2hWERiCrNEsuIs5jHO8bYFachfvv8WI+W3tHUpCbYjTiDFMsT0WHoa/C
         xmoYkBve0Z7ReliDKCvEGmFFrrVUJLEI1Jdmb1lvm3JUyeYEkNuxcj1qUkG29eEZHUFH
         i341XNF35CVM443XX7ZKmCO2y4C3qxCb6ihsJXx5Cr+EDPLryM8H87ACaTfle2/QTyLH
         6hWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=60yblaIwULlqCBLk7QWghT8yYUX6bBiUWvgD/Zhne7M=;
        b=HcEyUVdV0O3CP6ohIIL+awhNGL7zjp3vo4pEq9i/s1sAHfeY+rSnqNEz87aAModW1k
         PF3YubZRv1mBdPXjG/NRkFX8Pup159g7RHqryt4ci3EootzcGudfIw2JmfCbQqWP56Q3
         sf+CixspJdoA6f08JDJunjcbV3cPNIddyR4J1nYLnVnsnTTlciR2KmkKxcozDOyaoiDA
         RsEuMqS39R6rbCdwpbAFtDCtjiw6h2XbtFJwWpq8+YOQoRGO/wpK8GUvy6BcQ33tq7nu
         g6LuWXgmZiAFaJiwH97r6alqOOjNWPBRdrspXHfm5DgwWhHEOMVork5jWcG6GWUIX6wI
         Ol5Q==
X-Gm-Message-State: AGi0PubP13QE8jmSj3oDCQeaC6+qWFXKXiunPBFTz15PDMQgnE6tZhUC
        os8Ax3WoowfLF5pAblwtbwvSbILSDNI=
X-Google-Smtp-Source: APiQypJNxGLjhxafKKWZzZO20yZgn0b7/nX8qPSvSkgAgXkFnK7dXWf7tcG++WqoVQG/fKsWRMKrJQ==
X-Received: by 2002:aa7:9695:: with SMTP id f21mr398624pfk.93.1586226778125;
        Mon, 06 Apr 2020 19:32:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y28sm12722341pfp.128.2020.04.06.19.32.57
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 19:32:57 -0700 (PDT)
Message-ID: <5e8be659.1c69fb81.c3529.ad1f@mx.google.com>
Date:   Mon, 06 Apr 2020 19:32:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.6.2
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.6.y
Subject: stable/linux-5.6.y boot: 102 boots: 2 failed,
 94 passed with 6 untried/unknown (v5.6.2)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.6.y boot: 102 boots: 2 failed, 94 passed with 6 untried/unkn=
own (v5.6.2)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
6.y/kernel/v5.6.2/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.6.y/ke=
rnel/v5.6.2/

Tree: stable
Branch: linux-5.6.y
Git Describe: v5.6.2
Git Commit: 9fbe5c87eaa9b72db08425c52c373eb5f6537a0a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 66 unique boards, 18 SoC families, 17 builds out of 200

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm2836-rpi-2-b: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

---
For more info write to <info@kernelci.org>
