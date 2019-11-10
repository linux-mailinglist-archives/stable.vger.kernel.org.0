Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD31F69A1
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 16:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbfKJPSz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Nov 2019 10:18:55 -0500
Received: from mail-wm1-f41.google.com ([209.85.128.41]:38602 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbfKJPSz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Nov 2019 10:18:55 -0500
Received: by mail-wm1-f41.google.com with SMTP id z19so10764498wmk.3
        for <stable@vger.kernel.org>; Sun, 10 Nov 2019 07:18:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=X4ol+dzEDzDm6vgreY+VD9PsXZx//HqiTNycpBq/K7I=;
        b=iRKZ22mWy1wUQDxJdb1ga9yFEeaJiP86coEBTOcf1dpRm1i53w/2gutmpoX/pExG7i
         0Da6od2JAWkrE2h007VpeNzsfxNuedor4GZi0BOSmZ9OLun+YvKZ03Inq6uJ+mC/XEAd
         wDAxdA3jdjCPO4u9WSKryKCw/QLUnBYFJ5QrBcfZYMpzHrKe5UBVW9WyFDTNFTzRb+Pl
         o8y9zwt+OgTbjBgUjWKMP3TAPZWxn/RWqGtXUVfJzu1v8MG9hpv9MArI6dQqsHw2Hrcn
         g6q+S1OdLkGT9TkNPPlhSZCstlSMHu0XI8jV+ZGQJ3WMmhf/wilVceG/1ZDT42adm77m
         Cq8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=X4ol+dzEDzDm6vgreY+VD9PsXZx//HqiTNycpBq/K7I=;
        b=mx2c5iXJEseF6ukPWVshv43ePoNCKYCP2h/OHWZKT4xRN7UbRenziHFesthELAuWEY
         OmOW3VA7Ax2kEVZTqfUWThCXV9H5jvpvw8b0CJhrhqfRx/g6F0riC84/r2acG6CHaRHr
         wPaOK56f+ZhpGEKiKhG7YsAh+r3LOq2uYcFMtKPrwraSl1VUsl1HO+NxqtyXUrWbv8Mq
         RHiX1nKQd2ahmd89BAmS+MaWulFV1C287H3X/iPkR80dhlRrRyg4Dr2+g/3Nl9qT4Frd
         bquNo7v6hPf5fvR3A5kbuoq1lQiIW6p4/+dOzjWm/3Nk922KsbW2DRyZguYzQW9hXX4x
         bxLg==
X-Gm-Message-State: APjAAAVtloqXL7Eq9cCEq4QmyomjSMX4SX0hotzFNtTtH5FXO87D7VKg
        9oLWOCaktm7/7Mk1XFSnwD6s5Otd4SU=
X-Google-Smtp-Source: APXvYqwHNx6xAR56RdGho6ovuC2HtgQRxywT69x/4ftuatJP7K3BMY2DGkkHTtZ4bxrML0mF9pinTA==
X-Received: by 2002:a7b:ce12:: with SMTP id m18mr17730558wmc.130.1573399133202;
        Sun, 10 Nov 2019 07:18:53 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c24sm30045630wrb.27.2019.11.10.07.18.52
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Nov 2019 07:18:52 -0800 (PST)
Message-ID: <5dc82a5c.1c69fb81.a19b2.662a@mx.google.com>
Date:   Sun, 10 Nov 2019 07:18:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.153
Subject: stable/linux-4.14.y boot: 51 boots: 0 failed, 51 passed (v4.14.153)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 51 boots: 0 failed, 51 passed (v4.14.153)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.153/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.153/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.153
Git Commit: 4762bcd451a9e92e79d5146d3d4a5ffe2b4e0ec5
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 30 unique boards, 13 SoC families, 9 builds out of 201

---
For more info write to <info@kernelci.org>
