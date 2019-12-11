Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE67B11BED6
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 22:06:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbfLKVGq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 16:06:46 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51949 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbfLKVGq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 16:06:46 -0500
Received: by mail-wm1-f65.google.com with SMTP id d73so5500050wmd.1
        for <stable@vger.kernel.org>; Wed, 11 Dec 2019 13:06:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=caTv96LdPSNNo4SPqYplZ0U6ONFv2YrV8MGDYMMwvXk=;
        b=BGDD7UdVFcTR9BWfp3ucCZHaKDCJEhBZEyIk62r/UxDYCgHZadqTqih3QjAFT2vG9a
         9YEHvoo9QHfMYapnp8cwtnGu/f4o7A5IG/Sp+1KFC+Xh2ktyXCBzOvMl084bKDoOA8li
         H4qbP5Y/a2INxruBj8uDGBCNeQIEKPZxv2ylf+3MbeKMQhIBmgwpAYCHaNc/YrpxtnT4
         27W/lao2ciZX9cEGwWsSEimZ19+925KYhMEw6jvZTzT9xhGNscT53U55u0murUi3TiNr
         jNXcyaCkAlGO0mFGI3EhoA8Cyebws8WxuAWe7JqKE9+Ad1SUOVC+enKB0m4SOKQX8Xct
         zC8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=caTv96LdPSNNo4SPqYplZ0U6ONFv2YrV8MGDYMMwvXk=;
        b=Tiroh0ouFaofcgdJkQ8/CULPG1GPAZyaOnWoZS71DEgUSGwwi7OV5I4MMkQrRCWvz9
         5vxnGZFheW6p4QjcM8ea9+9H6N+C+gu8R71hh1LdBSfIPnvbMBb9GHVAKa+YSVIlycDG
         xGKnsZY91X/BXYpncsxjzcbygXEWW7jU6d1c3fhqTLT9rUBq5RStzhpVQThNoyoXRd0a
         RPgsui+/d4XIBqshlmNT0LQgG5qZc8JCYm9RGkj1fGgWxyQkzX+Vq4i+bURFl/Q1QaKN
         4K1DYL3RdffOjOr77GJ3k+2M7X+mMkxWVnD3NAIIoJIOS45U5HhYMw/+anVuhYGtV5Kb
         xbrw==
X-Gm-Message-State: APjAAAWmJ09XnvqzGMlZpOQQso5jG4Hiz3crtDY3eWWShE2+Xe0lk7SO
        Uy1AYcFv6et30JQRd0dMr83vZ8+AZ7A9IA==
X-Google-Smtp-Source: APXvYqyBBYzAwrpzw6fDBKtzjt/SFtqCEehjZfAlbhGInO8YdXEiys4bqV112iFGKlxA+lQOOsIUDQ==
X-Received: by 2002:a1c:a9c2:: with SMTP id s185mr2017574wme.119.1576098404278;
        Wed, 11 Dec 2019 13:06:44 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v8sm3586469wrw.2.2019.12.11.13.06.43
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 13:06:43 -0800 (PST)
Message-ID: <5df15a63.1c69fb81.e20e8.296f@mx.google.com>
Date:   Wed, 11 Dec 2019 13:06:43 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.88-244-g62dbca0959b3
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 84 boots: 0 failed,
 83 passed with 1 untried/unknown (v4.19.88-244-g62dbca0959b3)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 84 boots: 0 failed, 83 passed with 1 untried/u=
nknown (v4.19.88-244-g62dbca0959b3)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.88-244-g62dbca0959b3/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.88-244-g62dbca0959b3/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.88-244-g62dbca0959b3
Git Commit: 62dbca0959b37287a49ac6a949578849d490df83
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 48 unique boards, 15 SoC families, 14 builds out of 206

---
For more info write to <info@kernelci.org>
