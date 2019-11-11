Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55C49F7729
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 15:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbfKKO4p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 09:56:45 -0500
Received: from mail-wm1-f41.google.com ([209.85.128.41]:37365 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbfKKO4p (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 09:56:45 -0500
Received: by mail-wm1-f41.google.com with SMTP id b17so5240401wmj.2
        for <stable@vger.kernel.org>; Mon, 11 Nov 2019 06:56:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kp5GVk1/Jnvrb+Dhmy4SRnGaxcEjIUGalx7OWkBv2b8=;
        b=osKw5vWx96d+pp4qZYIGqzBmfEdCN9ymIkdf88Yc3In+HRIABCl6YeXgRFwv8nc/r+
         nqhfznC7VLarmUksj+SmXctqcni17GkdatqMrhN5AYE/wilfai3OyiyusMCpcy3INFSo
         kEmGnkxl7isWv8naGcQGkse5XGjoZaYjeWB99hGwnVD1R5ZDslcHuTkAi68xlY4NEXvk
         Pam1IQWY4Rdu4+lk7LYzG+69CS0TR+RsYCxv0ngpDGHUpfxwxpyLsFY2LTNwCU6JZ/C6
         Ccu7vosf0xljJnOrJLldRx9wINvZNW9+hJCo7XSDV6S7tFwh89bQPWBs8HPefKYBH8/8
         HU7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kp5GVk1/Jnvrb+Dhmy4SRnGaxcEjIUGalx7OWkBv2b8=;
        b=fbR7f/3JW1SaQf+e7dMiIZefmoRH4HONMMKk0EF68KEU3Rq7uOGeCItmd8P/8QuU84
         s0Ucm7H3qQ6R0kqdZK00cIVJd/VFlLO6bUL5cP64wSYW9Mn0UQHL/jRsQRXEeUF0B5DD
         JlYvXNsuZbaeZbuV3E9VWWWyMsYZFH7XpRp00RpnuAECVF4oubknUjGgj6tbHI5gZnjh
         4iWwj5RdaML/FlCZy1i/K5CPG+yRqK0Ugc+67j13ryN6AuX0ib+Ujm0FmHU2G+c6zCjM
         7p7yV/KAeyIgfVzFf1Pji7MMzGPQX97peBOu4Q1tWaH1xXTEemFVehbyR2qaHIfEn/3c
         dtrQ==
X-Gm-Message-State: APjAAAWWU5KyFUloS/cLYJk5tV4W0pcTBdqk2MUkXjXZGnCiv9NE9QPe
        FkDxxyCY8H37B2r6uW09ekVZuzt08tLarA==
X-Google-Smtp-Source: APXvYqyoLGEkk+rolZOELUAjOIyHiEOhVR1529tYes6mjHgGT/ETGUEn65pUOQ87UveaYHpUBd4Ftw==
X-Received: by 2002:a05:600c:301:: with SMTP id q1mr21631163wmd.141.1573484203127;
        Mon, 11 Nov 2019 06:56:43 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 205sm120857wmb.3.2019.11.11.06.56.42
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 06:56:42 -0800 (PST)
Message-ID: <5dc976aa.1c69fb81.8dfdd.0881@mx.google.com>
Date:   Mon, 11 Nov 2019 06:56:42 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.200-27-g0966ff473ecd
Subject: stable-rc/linux-4.9.y boot: 92 boots: 0 failed,
 85 passed with 7 offline (v4.9.200-27-g0966ff473ecd)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 92 boots: 0 failed, 85 passed with 7 offline (v=
4.9.200-27-g0966ff473ecd)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.200-27-g0966ff473ecd/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.200-27-g0966ff473ecd/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.200-27-g0966ff473ecd
Git Commit: 0966ff473ecd7ebc73e6ced2f7bc638c9a4a63a3
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 48 unique boards, 19 SoC families, 14 builds out of 197

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
