Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1AED4F63B
	for <lists+stable@lfdr.de>; Sat, 22 Jun 2019 16:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbfFVOfK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jun 2019 10:35:10 -0400
Received: from mail-wr1-f48.google.com ([209.85.221.48]:38729 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbfFVOfK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jun 2019 10:35:10 -0400
Received: by mail-wr1-f48.google.com with SMTP id d18so9285350wrs.5
        for <stable@vger.kernel.org>; Sat, 22 Jun 2019 07:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dvNFJhmbx+vyZ+29LUTuhaISOj+Vu9CqrYJ45KpnOxQ=;
        b=AjuDpjof1Q8ylo9bf51vbZ0f+XbfGUMQ3Toxsxs+iFk27zw2UK829XqHgkiju+ctps
         svJ9UzT544XIbuZnnl8cL5Dgt7xHdtX56tql2VzqFNAsgV8zBWeos4/i6eNS6B/BmtBI
         J2LDiqaE5y3uWbj8weMjBYQBff3S4xkgfMNrYdY1D0AQUpFJ27Wa8JpGV7othSBkVHUX
         DOOmiZC1Mx+IYk5wsuGxYxjeFk44hrsug1CnodPuA3c7EXWtVK1r1kUSSppw7A1k+5aw
         2dWUTcSCbfq+NN2k0Iy/Wl02OmusstHu8B3AB1Z9tj/l+H7MEhFQTSCFs4dT3Pikrcnt
         nefA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dvNFJhmbx+vyZ+29LUTuhaISOj+Vu9CqrYJ45KpnOxQ=;
        b=EEJp+BwYXKLO9zvVIPUwuhCouxbNYbYRGz6z/LCO8fJpqPKks7l5ItyKiT8iJXnq9p
         s0R8nOZqtwJQ8LSYIZ5RWO89G4ZZWBzToaTvpMHSplOE3v/go12WSisMdz8n3Ut0CIXD
         2jd3tdT8wbKub7tRWEBE+clZ/QKAsocjAPxr9+ZleisRKsXcNglm0tdMvfdsUWk7Y2um
         EmlUrG+Vbm6ZZrujb/NHIYRj2tep6mBhLi3QmE7SurQbhQedr1gYN3WeiCBL7/4VMnKs
         qWLms3WMAEXhOWM4N9FdoNd/LFf3YVkex6uVfmAbNmjMs4+820Z/ewkyj3x+t+d7Hwio
         yKWA==
X-Gm-Message-State: APjAAAXbOEACRPiwbFuCgauyHwnyirlEaarceamLNjhPY1sKW/nsfe0Q
        lr+1i3g7OmB/n6trCbqG8l6WTznbk5XEzg==
X-Google-Smtp-Source: APXvYqyPB8BzOGDFxSq+cZFZvn7y/QcuH7pBc4UrkVNyAJlN257+B9KAjJ8EH9NndRtyrpEzHRV6Qg==
X-Received: by 2002:a5d:4752:: with SMTP id o18mr31740737wrs.74.1561214108222;
        Sat, 22 Jun 2019 07:35:08 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n10sm4103724wrw.83.2019.06.22.07.35.07
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Jun 2019 07:35:07 -0700 (PDT)
Message-ID: <5d0e3c9b.1c69fb81.8cde.5282@mx.google.com>
Date:   Sat, 22 Jun 2019 07:35:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.13
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.1.y boot: 79 boots: 0 failed, 79 passed (v5.1.13)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.1.y boot: 79 boots: 0 failed, 79 passed (v5.1.13)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
1.y/kernel/v5.1.13/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.1.y/ke=
rnel/v5.1.13/

Tree: stable
Branch: linux-5.1.y
Git Describe: v5.1.13
Git Commit: 7da3d9e6cd75cca48bfd99ba55c874900c0135d9
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 40 unique boards, 17 SoC families, 12 builds out of 208

---
For more info write to <info@kernelci.org>
