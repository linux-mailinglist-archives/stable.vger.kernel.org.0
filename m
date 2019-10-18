Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF11DBCFD
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 07:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389094AbfJRF2n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 01:28:43 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53959 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726458AbfJRF2n (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Oct 2019 01:28:43 -0400
Received: by mail-wm1-f66.google.com with SMTP id i16so4738687wmd.3
        for <stable@vger.kernel.org>; Thu, 17 Oct 2019 22:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3hNameFMWXC3BZ5D3W1apdMdrEv1BjODBlxcORYcG1I=;
        b=bsh3Nzel3S5W6rbd54bk1fJZGMc9XLxFbnNSZLV9LbXpnE2gq44puRDALbhSFGWcef
         qFIR5vwEXYJTH2kTjU1XcQlZ7JG7Izr27F36fynLex0XPj75zzpHY+B3ehUSEt6G6y7p
         5u/dmOqzc39WOvwszYhDe4Tf+N+U6XyD5PO9HNXgDLIAvTsdjQ+lZtQPI3lqk0L1gdoD
         a0jySfLOMSTiS1Tfo91X0SVBXLpMeWjNV5PZIz6o4MSN3hXa8Y21f9sx0cflKk6+IPE3
         AeOxORCvdTrpKuTtZgHKvQfKcmbvtgiVyb3c+j9Jw22zCWbWLKXN1dh3rtZ809sabEp/
         M6Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3hNameFMWXC3BZ5D3W1apdMdrEv1BjODBlxcORYcG1I=;
        b=IFh+GyL43LHDpULOBL6deF7fh9XhkoVDgIUhd7FRtBKwtBOmIxtkj2QhTChxFDBnrK
         CHTgHYs5c94tKw7Ust1EyszAkKTgcPRTKDEG+2h5+nLqgbA5JoQ/cNujBiVhxe1+xRoB
         jrxzgy+0KbKy5yR5kN7HaXcMK6g8cCmHzgqRo+yzXBNDqcj8qOs78aSYHu/X/CceqLA9
         D3BrP4fvR4UBHH+cBU58KFUUGv8mMXkfvU7OIuKKfh4MHJArnBptDsdUbV5OOQNwzXLz
         caKOu/812mzX6gwwDScdECCe9/9FsnvixOX4wJInPupwI3zXjaMr1jn0SiK/eL3yre7k
         8dMw==
X-Gm-Message-State: APjAAAXQaafEN+FderjGrZdKkj6+dITCGiW26pR64BDzt/lrZgSAgDk6
        PW5lksUiZ05X2Bh6m3NYrCiAynPhPk9ZNA==
X-Google-Smtp-Source: APXvYqyUz+V2fGwrKhrfCYBijrxGBwhViyEYpQ12Frtmqp4HcLnQDdgL//GZ5MWEE7cSDCvXPYdvpw==
X-Received: by 2002:a1c:5f09:: with SMTP id t9mr6248011wmb.124.1571376520139;
        Thu, 17 Oct 2019 22:28:40 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 26sm4147642wmf.20.2019.10.17.22.28.39
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Oct 2019 22:28:39 -0700 (PDT)
Message-ID: <5da94d87.1c69fb81.7640.5808@mx.google.com>
Date:   Thu, 17 Oct 2019 22:28:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.197
Subject: stable/linux-4.9.y boot: 38 boots: 0 failed, 38 passed (v4.9.197)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y boot: 38 boots: 0 failed, 38 passed (v4.9.197)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.197/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.197/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.197
Git Commit: 364ef83db0273acc89c6ba8ae1aebee70a133056
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 25 unique boards, 14 SoC families, 10 builds out of 197

---
For more info write to <info@kernelci.org>
