Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 964E212F23D
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 01:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725916AbgACAgE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 19:36:04 -0500
Received: from mail-wr1-f52.google.com ([209.85.221.52]:43522 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgACAgD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jan 2020 19:36:03 -0500
Received: by mail-wr1-f52.google.com with SMTP id d16so40961882wre.10
        for <stable@vger.kernel.org>; Thu, 02 Jan 2020 16:36:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QxgNCNsq3PiHSXOv16Fe18c8U7CsWX8yFPC7nGWLDY0=;
        b=uF36u7N1p+sToHBa45xYOVYrQses0ErUjDqeq+belxbwMngRKuUN91uNXAU9vz64bz
         P/8UHr/ZxQPA2Jk+l3bRklxyYUKMtGxfus+t+n5HuIG7XYtcnB61H4EwiTYHXn0SXU2l
         IjvAuyZiy99pstORw7VU1MSqo9Tt7jUkTTkr+AC3XOHwNFKiOJULB8NDkFZ7a5x+p0Y8
         NxKpNLI0MbqBNnwMvdIJTX8jxOOKhW5xLizULU0RNdNAeCx8eyW+OIG4T1B1WMJp3d+4
         krmquv45+Q2UF+tVU7UjLQv/2KgiPP6B0DyClZsulHbo/MJ6kTrbCJ/BFZdW+2v2x+jP
         zYuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QxgNCNsq3PiHSXOv16Fe18c8U7CsWX8yFPC7nGWLDY0=;
        b=GkMIiNyUsh+U+gnS0LhT5t5TO2RC0tBb3b05QS7JKaUaFsQfjeO2t7rxad3fohT04u
         jbxn/XTaRaqy/+Nwy0vSUQYJ/gIceC23+u9bL9mwce8JBabpx17vBxZND92lB+73USxc
         EAjinovJ9UtrP4cIhH/xbuvAZuFblUW26zIIHP2+Gf+29O+aJAv6mHJ+tA12FBcKBnQP
         j6LAWzTWfTokj7QA/vZ3ykfrsJnlnwOJb78U4MHHFVmZkxGggYnIe6D+I75Xgj5tHLae
         Ds5SLvzavteqFkIcw/tC5+ZXoqP71b0FTt1KQlLgD2ZTL64P0hQ0JotpvUFz8ojoMjsj
         sh8w==
X-Gm-Message-State: APjAAAU1CS+1Th+UIx0gCjH4kjp7yS8gocZLLYTNr04NW7MySVymsPII
        kYWaAZNbOPlK4OOJ0yPqmAuUtScRZBl5SQ==
X-Google-Smtp-Source: APXvYqz/7CkhIT7nuRa2o5V00EfQbkSSJWMh/Fl2UlptDcL8ic8WdRtzbF78rHbRjlxgpEA7XJOvyQ==
X-Received: by 2002:a5d:4752:: with SMTP id o18mr81715943wrs.330.1578011761909;
        Thu, 02 Jan 2020 16:36:01 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g21sm62482145wrb.48.2020.01.02.16.36.01
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jan 2020 16:36:01 -0800 (PST)
Message-ID: <5e0e8c71.1c69fb81.9e051.eddf@mx.google.com>
Date:   Thu, 02 Jan 2020 16:36:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.207-172-g68e2c317fb2d
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 39 boots: 0 failed,
 38 passed with 1 untried/unknown (v4.9.207-172-g68e2c317fb2d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 39 boots: 0 failed, 38 passed with 1 untried/un=
known (v4.9.207-172-g68e2c317fb2d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.207-172-g68e2c317fb2d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.207-172-g68e2c317fb2d/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.207-172-g68e2c317fb2d
Git Commit: 68e2c317fb2d72a73e3326783de446632df0498c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 23 unique boards, 12 SoC families, 12 builds out of 197

---
For more info write to <info@kernelci.org>
