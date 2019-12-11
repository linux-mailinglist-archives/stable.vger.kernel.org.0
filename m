Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AEFC11BF33
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 22:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbfLKV1Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 16:27:25 -0500
Received: from mail-wm1-f50.google.com ([209.85.128.50]:51000 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbfLKV1Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 16:27:25 -0500
Received: by mail-wm1-f50.google.com with SMTP id a5so3058267wmb.0
        for <stable@vger.kernel.org>; Wed, 11 Dec 2019 13:27:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KsGGYXI9YvY/DEUqOklrQZJBdA+IA2sP0+LuBKNozcY=;
        b=MSAJ7QiuIkWY/sCatdFr/W1bWYD5qY5rI4hjD3hxOPfaatQxEBS7CvhGgQqbujUv1+
         ZidFDgc96h56RFaiPZBz2wmj+8a5Uowkpjq4YCqJHducS/HWH/D2COrY0i14llhh63Zn
         Qq9Us+ykZsWsXlX74HLT3hLIyI0C08V/U3/HQHseReaIBo3wfe1parIbYeWf2WJpGZ0Z
         8zJbL840v6qVkL9H7bNjRt3JcCbK62SCCJ5TBfSYTvcIWt7hC6sWTD1Ft06KchNJSc7a
         QLuGEvDMJmnyS26uRQeogrcd3wMf1AJ3IIL+5OAvpK6SsKDbtMMWt9lsaVG/Z/n8odrh
         TKEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KsGGYXI9YvY/DEUqOklrQZJBdA+IA2sP0+LuBKNozcY=;
        b=RxVOvi73G0QRQVve/1sS65cs83GNc6AOn5OThD6JrvJrpNkH5xriVlSwMfQOWSWDsj
         w4ywuTqGszPZmWgz4o1LXHd/MBnfpEbgvikGzd/LhX9UwZl6pwsBK7V6fTzp8swPyyKq
         DWIENPnDwaO+vGq3Ke2kDtaw57TP3W09l+1JsMUejoxh6ZgvLrfuWxKps8237F4grrEc
         X8nJfSPbe4pfOHawEtKWIREda4qh1lCbE8GASUPgOTYmy1tSbx4aBqO3kIF9AUsfE1NE
         iNfj8MOHUxnlyqVjLT1e/LTROC6BC3SGto2ZBTB0RRMBctisPMl6P8fm0LpVHS0qyomL
         m8jw==
X-Gm-Message-State: APjAAAUltr32AHWViuF/hxrLYkjtCZFrOVLxV6l429UjSVY2jYHnz2kn
        GV/Uhcd/1Jt9l8t2nXgw6DRgz6k2ecTS1A==
X-Google-Smtp-Source: APXvYqyU1wldT8XreF5BbJIVxihGaWXTIrb/ESrIhfv9+BY1rgoCifyZ4j26yNcZUTttank2tEHWfA==
X-Received: by 2002:a1c:6884:: with SMTP id d126mr2163593wmc.135.1576099642911;
        Wed, 11 Dec 2019 13:27:22 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v8sm3639667wrw.2.2019.12.11.13.27.21
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 13:27:22 -0800 (PST)
Message-ID: <5df15f3a.1c69fb81.e20e8.2d8b@mx.google.com>
Date:   Wed, 11 Dec 2019 13:27:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.206-71-g9e88c306dad6
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 54 boots: 0 failed,
 53 passed with 1 untried/unknown (v4.4.206-71-g9e88c306dad6)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 54 boots: 0 failed, 53 passed with 1 untried/un=
known (v4.4.206-71-g9e88c306dad6)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.206-71-g9e88c306dad6/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.206-71-g9e88c306dad6/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.206-71-g9e88c306dad6
Git Commit: 9e88c306dad62fbf851b965d9728a902587ba5de
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 26 unique boards, 9 SoC families, 9 builds out of 190

---
For more info write to <info@kernelci.org>
