Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AAD22D0A5E
	for <lists+stable@lfdr.de>; Mon,  7 Dec 2020 06:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbgLGFs2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 00:48:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbgLGFs2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Dec 2020 00:48:28 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EC58C0613D3
        for <stable@vger.kernel.org>; Sun,  6 Dec 2020 21:47:42 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id b73so12343256edf.13
        for <stable@vger.kernel.org>; Sun, 06 Dec 2020 21:47:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=s1JG27SsYwFPS35ZjtvvHpn9uuRdySYB6PkAFw9ESvk=;
        b=HqoA8RyFZwMe4OE9JcVOnOl1+grJ4r7k2DHh3wxBimvSd8grk3zDmxT9L8YQ7PaLEW
         fdN3uhMAjFmfAFRJ9gPGK/LFbKe9fH1BiXibapQfNk58M5z7o65aNvZurT08hcgqk2g6
         G8xZKCUtyCxlYALNOeDWIwpbDFiEfiJxVC1cSQt3a6eUMLvurNraRSpbuollxiBZPHWC
         jnSA4W5IddNNsb4uEdkYXl0kb/y79q32+IV6a094VSGWqqTTXoakN5+FnZPlR41yuLqq
         4gFJmAsjIAGSUZHq7pTf6EI6xHI6/KKPlXwCs5zFD6/tlCwc855+5vXcyzt2A0Nwb9JP
         meRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=s1JG27SsYwFPS35ZjtvvHpn9uuRdySYB6PkAFw9ESvk=;
        b=b0+G72tsh22zQFYl2/quQeOLx+J3XjbDMRKI3uPjdA7MVOvQCKI4dWreU3S94U5GIy
         x64LlFGX8PNQHXQXxGKhErxE4aTTyBG6GehtT7M+ur+M4mA2y3QcN9eVWS224C3R3jkJ
         HT5OdpOysmJ1RerBqWZrbbMF5gQ4O2ko2pXofNIQEAHkabJQdtbcTpRuMhFzmeGmlXEP
         7p9kroyEFKsN0W9UHtvd8uuSzspW3vrvPZ1aGTvtrY94GdAivJLIqi9So5DgQraPxJ9a
         6gp44jw/b5//AoX+UQZbScC5m7w9MOBOHs/CRAWbFvrx+nT9UarfTRgRqSxMqcgdbk/W
         KHjA==
X-Gm-Message-State: AOAM530kbcymp1ikYqQVOSfnnhSiHtBrQugRQ56jaQNZp6R8Xgygegkf
        TWhKbZKfWBGFcdaxE5NUdViTWpXhwgt6bar+vwrG8zFd675jNPEE
X-Google-Smtp-Source: ABdhPJzNZzv9XWAl6HI340Qozc3hkY3l4KfayVbeBH6K3cVHYlwtTtddMMlkqEls20qIXbFZv+9QmoKCHYMeVA3791c=
X-Received: by 2002:a05:6402:3074:: with SMTP id bs20mr18456029edb.365.1607320060145;
 Sun, 06 Dec 2020 21:47:40 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 7 Dec 2020 11:17:29 +0530
Message-ID: <CA+G9fYs=nR-d0n8kV4=OWD+v=GR2ufOEWU9S4oG1_fZRxhGouQ@mail.gmail.com>
Subject: WARNING: bad unlock balance detected! - mkfs.ext4/426 is trying to
 release lock (rcu_read_lock)
To:     linux-stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, rcu@vger.kernel.org,
        lkft-triage@lists.linaro.org
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While running "mkfs -t ext4" on arm64 juno-r2 device connected with SSD drive
the following kernel warning reported on stable rc 5.9.13-rc1 kernel.

Steps to reproduce:
------------------
# boot arm64 Juno-r2 device with stable-rc 5.9.13-rc1.
# Connect SSD drive
# Format the file system ext4 type
 mkfs -t ext4 <SSD-drive>
# you will notice this warning

Crash log:
--------------
Writing superblocks and filesystem accounting information:   0/895
[   86.131095]
[   86.132592] =====================================
[   86.137300] WARNING: bad unlock balance detected!
[   86.142012] 5.9.13-rc1 #1 Not tainted
[   86.145675] -------------------------------------
[   86.150384] mkfs.ext4/426 is trying to release lock (rcu_read_lock) at:
[   86.157020] [<ffff80001063478c>] blk_queue_exit+0xcc/0x1b0
[   86.162511] but there are no more locks to release!
[   86.167392]
[   86.167392] other info that might help us debug this:
[   86.173929] no locks held by mkfs.ext4/426.
[   86.178114]
[   86.178114] stack backtrace:
[   86.182478] CPU: 1 PID: 426 Comm: mkfs.ext4 Not tainted 5.9.13-rc1 #1
[   86.188926] Hardware name: ARM Juno development board (r2) (DT)
[   86.194853] Call trace:
[   86.197302]  dump_backtrace+0x0/0x1f8
[   86.200967]  show_stack+0x2c/0x38
[   86.204287]  dump_stack+0xec/0x158
[   86.207694]  print_unlock_imbalance_bug+0xec/0xf0
[   86.212404]  lock_release+0x300/0x388
[   86.216070]  blk_queue_exit+0xe0/0x1b0
[   86.219822]  blk_mq_submit_bio+0x250/0xa08
[   86.223922]  submit_bio_noacct+0x468/0x518
[   86.228022]  submit_bio+0x4c/0x230
[   86.231429]  submit_bh_wbc+0x17c/0x218
[   86.235182]  __block_write_full_page+0x210/0x648
[   86.239805]  block_write_full_page+0x8c/0x150
[   86.244167]  blkdev_writepage+0x30/0x40
[   86.248008]  __writepage+0x38/0xd8
[   86.251412]  write_cache_pages+0x1fc/0x590
[   86.255513]  generic_writepages+0x64/0xa0
[   86.259526]  blkdev_writepages+0x28/0x38
[   86.263452]  do_writepages+0x6c/0x138
[   86.267118]  __filemap_fdatawrite_range+0x10c/0x148
[   86.272001]  file_write_and_wait_range+0x6c/0xd0
[   86.276623]  blkdev_fsync+0x3c/0x68
[   86.280113]  vfs_fsync_range+0x4c/0x90
[   86.283864]  do_fsync+0x48/0x78
[   86.287007]  __arm64_sys_fsync+0x24/0x38
[   86.290933]  el0_svc_common.constprop.3+0x7c/0x198
[   86.295729]  do_el0_svc+0x34/0xa0
[   86.299047]  el0_sync_handler+0x16c/0x210
[   86.303060]  el0_sync+0x140/0x180

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

Full test log link,
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.9.y/build/v5.9.12-47-g1372e1af58d4/testrun/3538037/suite/linux-log-parser/test/check-kernel-exception-2012808/log

metadata:
  git branch: linux-5.9.y
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  git commit: 1372e1af58d410676db7917cc3484ca22d471623
  git describe: v5.9.12-47-g1372e1af58d4
  make_kernelversion: 5.9.13-rc1
  kernel-config:
http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/juno/lkft/linux-stable-rc-5.9/47/config

-- 
Linaro LKFT
https://lkft.linaro.org
