Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB406105A10
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 19:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbfKUS6r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 13:58:47 -0500
Received: from mail-wm1-f51.google.com ([209.85.128.51]:37495 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfKUS6r (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Nov 2019 13:58:47 -0500
Received: by mail-wm1-f51.google.com with SMTP id f129so3619579wmf.2
        for <stable@vger.kernel.org>; Thu, 21 Nov 2019 10:58:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pLGmhcKK/tPO6jgH/nd5+sJJJb62f86+rS7cJx42q6o=;
        b=x0Rwd1YtQB89qdeAifKlyJwfNs16uobt+igvjLLRED6hpWhKWrpqxhwMp38c6q25rb
         JtwZSXvjXSmP4gRwiU7SstwcWVTTNIf2nPryanwE4PW8xOPaiqeZFtvhlOHhd+VC7NEF
         kwCJF/W7824Cq53kLc3RvlDaaLPY4JY8NyiGQhh3ah1dnGz3GIZO3ixjQMI1qhcmTJIi
         dhYj8zWrM036UaLeEtsWOUa6I3tFrfycRgsrQ3dov+vsmPmtI+o1LiVim/aM3lSkiHAA
         54Qb0fRF/UtSX834cc3olwkE85qYl1UjpBCXhyS0ocKDy3YBckLKGj8FDX74qy6oO9Gl
         d8fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pLGmhcKK/tPO6jgH/nd5+sJJJb62f86+rS7cJx42q6o=;
        b=KQV+kQV4CiGhvHd+qp2ou2I0IE4MCuNkoEIwRTZRKFnBxV8YGRZYxOM9dAUGvhmiVs
         63PUyZg9f9uVc8u2nQdyvCfzRJiMKMi1ppoKYt/n9mraeceSD7FTt0AYXyf9yzS5WhQ1
         wfOPltY+iVhrV152nyr9D0UDV+c4MzR/JpMYWd6TYQPOTLYEIyB5eqMki0hHzD//7Sd4
         pFcSAZcYdHJrrYK1ClJ6WT9P3wUYbLGxzDkwBnAhx4/KAV6+mUh00+tFBoWjW4O4UK1u
         5GcQWGzgjRrPOHAV/+ww6GTLR2frw/oICxtvYEbqiONLOdstlqVk2+mZfFW7lqbymm9H
         KOBg==
X-Gm-Message-State: APjAAAXu5pwEmN+FmE7mh2uynkwH+2rq4/6MFr93OvyYGICUQgcMQJDG
        PA4kki4MUtREKKYx8M7hKzlD+cu8uXIzBA==
X-Google-Smtp-Source: APXvYqzo7xY97oTPAN0i/nnAlrVOJtiCS3yra8WwF6Ko7k/i/fNSHHXRvJ1WlvU+zs95r2jcp/wr3w==
X-Received: by 2002:a1c:2846:: with SMTP id o67mr12058183wmo.7.1574362725262;
        Thu, 21 Nov 2019 10:58:45 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id i7sm4445890wrs.38.2019.11.21.10.58.42
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2019 10:58:42 -0800 (PST)
Message-ID: <5dd6de62.1c69fb81.5a116.7131@mx.google.com>
Date:   Thu, 21 Nov 2019 10:58:42 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.202
Subject: stable-rc/linux-4.9.y boot: 106 boots: 0 failed,
 102 passed with 4 offline (v4.9.202)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 106 boots: 0 failed, 102 passed with 4 offline =
(v4.9.202)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.202/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.202/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.202
Git Commit: a86e4a77b558b9bdbae1192188ea744a3cf84176
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 54 unique boards, 20 SoC families, 14 builds out of 197

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
