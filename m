Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B45E313916D
	for <lists+stable@lfdr.de>; Mon, 13 Jan 2020 13:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgAMMxd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jan 2020 07:53:33 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40795 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbgAMMxd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jan 2020 07:53:33 -0500
Received: by mail-wr1-f68.google.com with SMTP id c14so8438042wrn.7
        for <stable@vger.kernel.org>; Mon, 13 Jan 2020 04:53:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6yzRCt3WyjBZQXR5zvtupKq9/2xuMrwk0+cW2XGinVc=;
        b=V5upr8Rc/HgbytumGFHc90ZTqB2ogwfFQkLWiidFd7e8ZXwH+cipdhEATBgqmj6S7B
         cvY2q4GQRxNomk/AtKrWUaW//mUFIxCGB0/kXs1MnO3Tbz2TtU81sb8TS0CStvgY8WEn
         4q7JN0kuilKQolZdKigR7Ye+E/yFgvayRllFSMz/ISezin7D9q0i72fs9f5JaZyrIVC+
         ty5/euy9K8k2ymYsIUn/8nz9MH+vdhrrgS/fWRvpkwahianJ1cHG+/sZ4bYmMm0rxdyK
         dK8gRXTqCJmspYfQ+wgTYaNFGw9bW6lYjiReDONx37K8DJ57aN5DVhzUD4X1VZvVwm6N
         97nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6yzRCt3WyjBZQXR5zvtupKq9/2xuMrwk0+cW2XGinVc=;
        b=buSkWkcR41r7orYJ6L6lWIu9NM0C4F6YLXqQjsUyec9U7JifR5wyLvjc4vURqEka33
         GbAWAXYbqrd+bGwu2EXy4eq7fsspViSHxDW4bb7dr61dwrPzCMscxag2pwYymFmD7ynV
         DdILMqbBLHyLKi1ZZnGiVvhFGccpqEOb5xDod+MleQYJSNhQAWWztv2PwVeni/rPv9sl
         s3LE3Qe6z23DZIG1gEeStiP81SK04xWyG3oIMxEWeIDPXzWMU30KbrdBFGMlPJuzQ3MA
         m2hbZo7gOlySQwoEtW0167ynWImuQTBcUGdp0hIZtREpB7WRV+Iq6/ssalK38QukDe3T
         c8lg==
X-Gm-Message-State: APjAAAXaewX9KFGxB0ZVBYdtEITVlaQQtPt8mt+IL6uvttDO/2CQUO7N
        v6AhBaxPNkh0vBPFh2RcdpKXY3KMymdSLA==
X-Google-Smtp-Source: APXvYqynr8DGQk8zpl4OGcDBMSd7jNLCl2HUvqZv82a0uG8BAyFnuH7ZkT0JroZmqWUm5HhnRCgvdQ==
X-Received: by 2002:a5d:5452:: with SMTP id w18mr17782702wrv.333.1578920010861;
        Mon, 13 Jan 2020 04:53:30 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s8sm14477737wrt.57.2020.01.13.04.53.30
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 04:53:30 -0800 (PST)
Message-ID: <5e1c684a.1c69fb81.38c15.b1f9@mx.google.com>
Date:   Mon, 13 Jan 2020 04:53:30 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.95
Subject: stable-rc/linux-4.19.y boot: 79 boots: 0 failed,
 77 passed with 2 untried/unknown (v4.19.95)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 79 boots: 0 failed, 77 passed with 2 untried/u=
nknown (v4.19.95)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.95/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.95/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.95
Git Commit: dcd888983542055210f5e68f1b1f1f8fe11a369a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 46 unique boards, 14 SoC families, 14 builds out of 206

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          sun4i-a10-olinuxino-lime:
              lab-baylibre: new failure (last pass: v4.19.94-84-g4f77fc728c=
70)

---
For more info write to <info@kernelci.org>
