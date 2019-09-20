Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3621B89A2
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 05:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437104AbfITDEb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 23:04:31 -0400
Received: from mail-wm1-f47.google.com ([209.85.128.47]:53871 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437101AbfITDEa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Sep 2019 23:04:30 -0400
Received: by mail-wm1-f47.google.com with SMTP id i16so662156wmd.3
        for <stable@vger.kernel.org>; Thu, 19 Sep 2019 20:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=waLXcJR0MnGH+J0ksYnKyGL1oEhoforOspZHaRd7yEU=;
        b=TPiEdJVVtshHcxEDMLjqRgHLqVJnxzGFpggYIjl6xI/XTNzjN/hLhsSEQDjJ+/VhGQ
         ydE11xgjWxlJ1HVFqnmIjtBsdwczNsl7FBGS/IhAfaHOGSKuImAMNnDZ5xOOjA7CCUwy
         sXshsON2hcIaWduH6jGinPFQc3d8y/Xez52ZaBrGvLdF7eh7F8LyxsuCZqZ9jDnOXiSg
         hPHHz1yK4ZEJ/SvqvNueg3ey5K+YG7G47yDMEefDgcC7qr2y0cEzEAOzRZ4f06zXfgYf
         ICV47+cCq+DlqPcctBEpUdssQbACaxgptsjkWim0h10I+TSbMki6Ha/uW+t7qYFwihqP
         Ikmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=waLXcJR0MnGH+J0ksYnKyGL1oEhoforOspZHaRd7yEU=;
        b=EDhzpPc9ewGAbPwgOGHpyADNVLNB/a716yWXTimkQk55eS0nq31SqXqSZunRqVPLTj
         BjiZezNnYAsgUKV+Npj8p6HdkfMNDXdiSCggWkw0P/LpT87ExNTc81GXniXPH5Ys2X5Q
         Il0cAsqc+Dn8V6nVYFJS840mDQLCL5XM0aQOTHiaWtsd69k79T9otwwlX8Qn1BcYZyM9
         fJwqhrtpnO1mkFWkOe3hbeYfrlf7KfyObLIH0XQjn7lMNdLIYMIj3IWg1k+Ih4wqgDQK
         /h48HGLkTgJAmYInptPM+XVNfJ8d5u6/yGW4G3o+XAzkDbfDyI7pyBtDp7BI9efEJcHQ
         Ia0A==
X-Gm-Message-State: APjAAAXCQ/6BAm8IShjPR30B5+HYFy7Kmb9K/7bv/+m9sd08Lyo3NZVi
        FueC7hZh94ol3K8xemM7mCO+0dTZTfuuNQ==
X-Google-Smtp-Source: APXvYqzympkr7xa1AOSRPb/ohg5jcdAKuCLToZbjG7EWfDSZ6SkauDeM0UnByQyDMK5Fo0x/krmGJw==
X-Received: by 2002:a1c:2089:: with SMTP id g131mr1064644wmg.33.1568948668471;
        Thu, 19 Sep 2019 20:04:28 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id d10sm497021wma.42.2019.09.19.20.04.27
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Sep 2019 20:04:27 -0700 (PDT)
Message-ID: <5d8441bb.1c69fb81.c2adb.1bb3@mx.google.com>
Date:   Thu, 19 Sep 2019 20:04:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.145-60-g981030d9563c
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 65 boots: 0 failed,
 65 passed (v4.14.145-60-g981030d9563c)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 65 boots: 0 failed, 65 passed (v4.14.145-60-g9=
81030d9563c)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.145-60-g981030d9563c/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.145-60-g981030d9563c/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.145-60-g981030d9563c
Git Commit: 981030d9563ce66bc738ff8fee0ed8c81922904b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 32 unique boards, 15 SoC families, 10 builds out of 201

---
For more info write to <info@kernelci.org>
