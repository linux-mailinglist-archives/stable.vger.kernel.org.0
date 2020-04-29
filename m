Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80E831BE769
	for <lists+stable@lfdr.de>; Wed, 29 Apr 2020 21:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgD2Tah (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Apr 2020 15:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726423AbgD2Tag (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Apr 2020 15:30:36 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73EE1C03C1AE
        for <stable@vger.kernel.org>; Wed, 29 Apr 2020 12:30:36 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id d3so1490659pgj.6
        for <stable@vger.kernel.org>; Wed, 29 Apr 2020 12:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=+fMOxEUgmCaS6B7t4gcp8M2pv114s98FJqFlbj0FJag=;
        b=WJmbUG1xffctB3sUTG8PxNVr+42uuhG6E9ZuQalrorF6zO+KJNis1P7MDBDDFMUzpV
         0oXK+uPGmQhEXYn0Ao2QkkTewjIxKpBrS17hVCR5BXUiVH4+twSyWdcZ7RVI7MgCW/v6
         a79n+hfecFAwcgGuyy0joUAYWP8RqgD/tmIBUwodtScmNLyY52lBMMMwSNXPGfoRMuGt
         7QG594mNfnmYwnHvi1RkHiNEqqLiocQqtPGF1Aqw1cWi+sJglWWTh8zJs8XZnAvTB+SA
         aK0PRYuxyLm1X5v/coIgGwlIFm31qECso1GRxEp0nfQcheucycUiv2rvX1y6gD7h0c6P
         Jt7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition:user-agent;
        bh=+fMOxEUgmCaS6B7t4gcp8M2pv114s98FJqFlbj0FJag=;
        b=sNpYRuU3Z4Ouggu1lFbH9imgWKTEIwsBA6VcNFBEX/1jubhpmQdJIvMfO8VTarWKNd
         yvpzLyWYS/cdiVTT4DAaYlRVdo860J1ycPFiFDCtryRLRX7RHmPqRLapXH4nDf+xLNAG
         o73MIuxpdvTbqQFKmUvEuxPxbpkd4Zu5TEBVKDJj9tj4+x6qpDYyIAQqEllmXVtzffei
         OjRF/JKJInb07K7hGMaw2qMqdaezjjwK9YE/iqKhZlY2lqEC1hzOAeH6JXGddgUz8dme
         TNg98vgBnPvg/BXXZaJtNqigmj4lqbLIS1t5jm6PCaaEQa/CDeh7XNeCV15RDcjBqmcw
         /73A==
X-Gm-Message-State: AGi0PuYtv2K02AdlgqfPpNzMKdeXtRN5XfU88TM4FD0MtSW5Qd7t+W1Z
        kdE/4e/cqsnvYWKlUsGIFZOtCFi9
X-Google-Smtp-Source: APiQypKHfPepUnvL0zpruuFt0MJBEKMoR+fohOMKvQBc07OUDydWs6FmT0ZzYvhuKw02MMpxPEuF0A==
X-Received: by 2002:a65:4b86:: with SMTP id t6mr15246419pgq.177.1588188635645;
        Wed, 29 Apr 2020 12:30:35 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d184sm1654006pfc.130.2020.04.29.12.30.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 29 Apr 2020 12:30:34 -0700 (PDT)
Date:   Wed, 29 Apr 2020 12:30:33 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: List of patches to apply to stable releases (4/29)
Message-ID: <20200429193033.GA83504@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Please consider applying the following patches to the listed stable releases.

The following patches were found to be missing in stable releases by the
Chrome OS missing patch robot. The patches meet the following criteria.
- The patch includes a Fixes: tag
- The patch referenced in the Fixes: tag has been applied to the listed
  stable release
- The patch has not been applied to that stable release

All patches have been applied to the listed stable releases and to at least one
Chrome OS branch. Resulting images have been build- and runtime-tested (where
applicable) on real hardware and with virtual hardware on kerneltests.org.

Thanks,
Guenter

---
Upstream commit a8dd397903a6 ("sctp: use right member as the param of list_for_each_entry")
  upstream: v4.15-rc2
    Fixes: d04adf1b3551 ("sctp: reset owner sk for data chunks on out queues when migrating a sock")
      in linux-4.4.y: 4b5bb7723da1
      in linux-4.9.y: b89fc6a5caff
      upstream: v4.14-rc7
    Affected branches:
      linux-4.4.y
      linux-4.9.y (already applied)
      linux-4.14.y (already applied)
i
Upstream commit 2d84a2d19b61 ("fuse: fix possibly missed wake-up after abort")
  upstream: v4.20-rc3
    Fixes: b8f95e5d13f5 ("fuse: umount should wait for all requests")
      in linux-4.4.y: 4d6ef17a060c
      in linux-4.9.y: 6465d7688c2d
      in linux-4.14.y: 973206923812
      upstream: v4.19-rc1
    Affected branches:
      linux-4.4.y
      linux-4.9.y
      linux-4.14.y (already applied)
      linux-4.19.y (already applied)

Upstream commit d9b8a67b3b95 ("mtd: cfi: fix deadloop in cfi_cmdset_0002.c do_write_buffer")
  upstream: v5.1-rc4
    Fixes: dfeae1073583 ("mtd: cfi_cmdset_0002: Change write buffer to check correct value")
      in linux-4.4.y: 5069cd50117a
      in linux-4.9.y: e9dc5dce0925
      in linux-4.14.y: 746c1362c434
      upstream: v4.18-rc1
    Affected branches:
      linux-4.4.y
      linux-4.9.y
      linux-4.14.y
      linux-4.19.y

Upstream commit 467d12f5c784 ("include/uapi/linux/swab.h: fix userspace breakage, use __BITS_PER_LONG for swap")
  upstream: v5.6-rc3
    Fixes: d5767057c9a7 ("uapi: rename ext2_swab() to swab() and share globally in swab.h")
      in linux-4.14.y: 4eb9d5bc7065
      in linux-4.19.y: 9af535dc019e
      in linux-5.4.y: 8b0f08036659
      in linux-5.5.y: b83fb35b0300
      upstream: v5.6-rc1
    Affected branches:
      linux-4.14.y
      linux-4.19.y
      linux-5.4.y (already applied)

Upstream commit 60d488571083 ("binder: take read mode of mmap_sem in binder_alloc_free_page()")
  upstream: v5.2-rc1
    Fixes: 5cec2d2e5839 ("binder: fix race between munmap() and direct reclaim")
      in linux-4.14.y: c2a035d7822a
      in linux-4.19.y: 9d57cfd4e9d8
      upstream: v5.1-rc3
    Affected branches:
      linux-4.14.y
      linux-4.19.y

Upstream commit e2bcb65782f9 ("ASoC: stm32: sai: fix sai probe")
  upstream: v5.7-rc3
    Fixes: 0d6defc7e0e4 ("ASoC: stm32: sai: manage rebind issue")
      in linux-5.4.y: af7dd05d7c8f
      in linux-5.5.y: 1ab75b0342d2
      upstream: v5.6-rc5
    Affected branches:
      linux-5.4.y
      linux-5.6.y
