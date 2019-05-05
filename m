Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAFFE14293
	for <lists+stable@lfdr.de>; Sun,  5 May 2019 23:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbfEEVnB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 May 2019 17:43:01 -0400
Received: from mail-wm1-f52.google.com ([209.85.128.52]:52019 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726905AbfEEVnB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 May 2019 17:43:01 -0400
Received: by mail-wm1-f52.google.com with SMTP id o189so2439776wmb.1
        for <stable@vger.kernel.org>; Sun, 05 May 2019 14:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gkh2Hrhj8/UNfOvI/LYMLdLuL2OoPKvjXbAxhy8kyn8=;
        b=zKMIK0B+kT4TuDBSVQUf2RVXduOpYffOi/NPCNyKIA6FuJImbqH82g3cts16/YiKP/
         ui9FX/rzf/eAZ4TuksBQFru585M54dmfs4ykNWRXvcbwoexBCUqquval8WfTXhgwZUCA
         lqn66vPVcyz0N1NfawYxVnhDugzwiCZQOhGiQaka5yyTWkw+o+zTMV7Th/schE2yj57l
         0r9Ld1cP6LlEZom1PWZjICxyEhsBaqhFfkTvqxqnyR41v9I7yogvuwkE5PjGO712wnoH
         wecAe1obl9i2AdHKrDf+DRTDqJhQPN6pj3GDIETsEWc5qLMjT/T0qvJd/4rup91JjHkL
         ua9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gkh2Hrhj8/UNfOvI/LYMLdLuL2OoPKvjXbAxhy8kyn8=;
        b=LKwPzfUrMEBD00BMX7lGW5GQqwEC54iwJZG8Ql5FwmKiyxooAQcT+NqloQtg8SXEGv
         eD8nHSRiKwM91/lkzfrkxGTP8ZvcTz9Wce1jEJlA1SHnDKuFzxjS0Gyn5rSenCIIX0zN
         bh1ZMa1VxujuZ+cnZD7TTUmqQvCaj6NI13TeX/ysjNopAyQt2BXeERs4TOVHzQsSUA8H
         Fp2Gt4dqUkpx3laLcKM9j/EhswoySBogAJH2ayKMs1evGtlnw8poye7ME4FjSdA9u/LQ
         CwTKQC+IkuRBGXGy6WOsd4m/OFqUo4v4wYqHd9XvOJCcLRzriyXX1wTuKmbEexQmRTyH
         zfiA==
X-Gm-Message-State: APjAAAUi8nsNofqzGOD2Jz727TBLs1HqBAwjZ9bEDzwClMIZF5mosrns
        SHG7LU4hZZWY/4dfB2WUOaAblxXoWFA=
X-Google-Smtp-Source: APXvYqwper24jb8YrU+VMqK5FtAbi5FokiHIDQDpzWdCRC63BWxL8tQgk+6+ppzx718ama+uXXReJg==
X-Received: by 2002:a1c:a103:: with SMTP id k3mr14583324wme.8.1557092578860;
        Sun, 05 May 2019 14:42:58 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id u17sm6390293wmj.1.2019.05.05.14.42.58
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 14:42:58 -0700 (PDT)
Message-ID: <5ccf58e2.1c69fb81.96470.14a4@mx.google.com>
Date:   Sun, 05 May 2019 14:42:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.40-19-ga3ac089a8ea6
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 127 boots: 0 failed,
 125 passed with 1 offline, 1 untried/unknown (v4.19.40-19-ga3ac089a8ea6)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 127 boots: 0 failed, 125 passed with 1 offline=
, 1 untried/unknown (v4.19.40-19-ga3ac089a8ea6)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.40-19-ga3ac089a8ea6/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.40-19-ga3ac089a8ea6/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.40-19-ga3ac089a8ea6
Git Commit: a3ac089a8ea65d97006cc804e6155d8acf07fa86
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 69 unique boards, 24 SoC families, 14 builds out of 206

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-7
            stih410-b2120: 1 offline lab

---
For more info write to <info@kernelci.org>
