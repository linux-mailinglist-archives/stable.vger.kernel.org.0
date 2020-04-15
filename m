Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E07AF1A8FBB
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 02:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732628AbgDOAb6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 20:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731654AbgDOAbx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 20:31:53 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD5D3C061A0C
        for <stable@vger.kernel.org>; Tue, 14 Apr 2020 17:31:51 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id q16so4525899pje.1
        for <stable@vger.kernel.org>; Tue, 14 Apr 2020 17:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=c7L4evoH+84wKdfKsq0u3L1umXPsOw0RP0RzoOtVcqw=;
        b=Aq1mvL5gX1+NrR31kzcSFR03+M6AZwMatOi67RXMYzSBU8r8cY4Rde+/OcJq/SHGUt
         5KWnmrJilZ/IIuHZX6j3LQl2Ju+UEO+jPhO311hNOk4nwaoMi5pEoRXOnhuJWlnKh4ET
         etx47IntHY5UiXuoeGMc/FE0SpMRVdixny7NA6DSlZbAnWN6uv893txTHS2S/a9wSD2F
         +IxGaIjJvgbNinqQ+PrVaZw8o7eI92z9DT5Ahh95KMgBmkz1GbTsyLnRCIvfM+YJHvWN
         vTMCEREZHLeYwrNoEwY3HY8+u4LT3Twto5N+SLZTZaLs4xKBaAHxiinPFONraHDZXjCg
         a6Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition:user-agent;
        bh=c7L4evoH+84wKdfKsq0u3L1umXPsOw0RP0RzoOtVcqw=;
        b=naHdWjYC5/64y8L8tgXdFJTTd5OQUNrsN1rpwWidQYLmZX8qF0GDW/6Oj1xs2z1ckO
         Z7X5rhGJzhlRop7+ptDF7UA17/7YUbgN0xkrRcMb1aowZpA/AWKsWtFyANxHn95TC8B9
         s/pLs8xhc2ZWYPKspJ1DlfrsMfbylQMTys4gK2zXN/wZ1Hp0GW/vRlAo1Yo21+xIsGBY
         xQ34SGDKhjox8GJ9zH0cVSG2LjFspuJ83g8RVZLIwm3/Hw7rV4sB50z5j5L832UrhP2e
         agNk5PySoVtpFUAk2vhQCnmaw1RDCwmoPlMLSJWoGwtYXyWqdwOSRgnKFTNND4BzLAIO
         HZsQ==
X-Gm-Message-State: AGi0PuZJu4Jy6RvTC6eowFhymp5wEaWGEAgEummpOJlemoMXFW/ywSh7
        lLEOrLi3memV+9xuppd/87BrAKt9
X-Google-Smtp-Source: APiQypILR0RuWYdw1GeHRzS2d11corh1YCINEl2oC41k7XhwPlIDLcs9NmO2GzTCQoF4pvcR7yRn9A==
X-Received: by 2002:a17:90b:3747:: with SMTP id ne7mr2935049pjb.181.1586910710943;
        Tue, 14 Apr 2020 17:31:50 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 135sm12542031pfu.207.2020.04.14.17.31.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 Apr 2020 17:31:49 -0700 (PDT)
Date:   Tue, 14 Apr 2020 17:31:48 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Patches to apply to stable releases
Message-ID: <20200415003148.GA114493@roeck-us.net>
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
  stable release(s)
- The patch has not been applied to the listed stable release(s)

All patches have been applied to the respective stable release(s) and to at
least one Chrome OS branch. Resulting images have been build- and runtime-
tested (where applicable) on real hardware and with virtual hardware on
kerneltests.org.

Thanks,
Guenter

---
Upstream commit e78c38f6bdd9 ("futex: futex_wake_op, do not fail on invalid op")
    Fixes: 30d6e0a4190d ("futex: Remove duplicated code and fix undefined behaviour")
    in linux-4.4.y: 177a981885cf
    Applies to:
        v4.4.y

Upstream commit 93f0750dcdae ("Revert "[media] videobuf2-v4l2: Verify planes array in buffer dequeueing"")
    Fixes: 2c1f6951a8a8 ("videobuf2-v4l2: Verify planes array in buffer dequeueing")
    in linux-4.4.y: 19a4e46b4513
    Applies to:
        v4.4.y

Upstream commit 2e356101e72a ("KEYS: reaching the keys quotas correctly")
    Fixes: a08bf91ce28e ("KEYS: allow reaching the keys quotas exactly")
    in linux-4.4.y: 1e73c0aeb3ee
    in linux-4.9.y: 6704b9d8a075
    in linux-4.14.y: fe303ba7ab93
    in linux-4.19.y: f812bec554d0
    Applies to:
        v4.4.y, v4.9.y, v4.14.y, v4.19.y

Upstream commit 538d92912d31 ("xen-netfront: Rework the fix for Rx stall during OOM and network stress")
    Fixes: 90c311b0eeea ("xen-netfront: Fix Rx stall during network stress and OOM")
    in linux-4.4.y: 230fe9c7d814
    Applies to:
        v4.4.y

Upstream commit 183ab39eb0ea ("ALSA: hda: Initialize power_state field properly")
    Fixes: 98081ca62cba ("ALSA: hda - Record the current power state before suspend/resume calls")
    in linux-4.4.y: 2569eed24d93
    in linux-4.9.y: 5ee86945565e
    in linux-4.14.y: 886e8316b599
    Applies to:
        v4.4.y, v4.9.y, v4.14.y

Upstream commit 24e52b11e0ca ("Btrfs: incremental send, fix invalid memory access")
    Fixes: e1cbfd7bf6da ("Btrfs: send, fix file hole not being preserved due to inline extent")
    in linux-4.4.y: 266bbc907c3f
    Applies to:
        v4.4.y

Upstream commit 1f80bd6a6cc8 ("IB/ipoib: Fix lockdep issue found on ipoib_ib_dev_heavy_flush")
    Fixes: b4b678b06f6e ("IB/ipoib: Grab rtnl lock on heavy flush when calling ndo_open/stop")
    in linux-4.4.y: 26c66554d7bf
    Applies to:
        v4.4.y

Upstream commit 56a49d704870 ("net: rtnl_configure_link: fix dev flags changes arg to __dev_notify_flags")
    Fixes: 5025f7f7d506 ("rtnetlink: add rtnl_link_state check in rtnl_configure_link")
    in linux-4.14.y: 23557c5d34b9
    Applies to:
        v4.14.y

Upstream commit 11dd34f3eae5 ("powerpc/pseries: Drop pointless static qualifier in vpa_debugfs_init()")
    Fixes: c6c26fb55e8e ("powerpc/pseries: Export raw per-CPU VPA data via debugfs")
    in linux-4.14.y: 27b1ef75f579
    in linux-4.19.y: ee35e01b0f08
    Applies to:
        v4.14.y, v4.19.y

Upstream commit 34d66caf251d ("x86/speculation: Remove redundant arch_smt_update() invocation")
    Fixes: a74cfffb03b7 ("x86/speculation: Rework SMT state change")
    in linux-4.14.y: 36a4c5fc9285
    in linux-4.19.y: f55e301ec4d5
    Applies to:
        v4.14.y, v4.19.y

Upstream commit cc41f11a21a5 ("scsi: mpt3sas: Fix kernel panic observed on soft HBA unplug")
    Fixes: c666d3be99c0 ("scsi: mpt3sas: wait for and flush running commands on shutdown/unload")
    in linux-4.14.y: 3748694f1b91
    Applies to:
        v4.14.y

Upstream commit 82f04bfe2aff ("tools: gpio: Fix out-of-tree build regression")
    Fixes: 0161a94e2d1c ("tools: gpio: Correctly add make dependencies for gpio_utils")
    in linux-4.14.y: f71e52cb3270
    in linux-4.19.y: 036588ec6888
    Applies to:
        v4.14.y, v4.19.y

Upstream commit 3e487d2e4aa4 ("PCI: pciehp: Fix indefinite wait on sysfs requests")
    Fixes: 157c1062fcd8 ("PCI: pciehp: Avoid returning prematurely from sysfs requests")
    in linux-4.19.y: 248e65f3220e
    in linux-5.4.y: 9bd9d123399b
    Applies to:
        v4.19.y, v5.4.y

Upstream commit 8644772637de ("mm: Use fixed constant in page_frag_alloc instead of size + 1")
    Fixes: 2c2ade81741c ("mm: page_alloc: fix ref bias in page_frag_alloc() for 1-byte allocs")
    in linux-4.14.y: a977209627ca
    in linux-4.19.y: 33e83ea302c0
    Applies to:
        v4.14.y, v4.19.y

Upstream commit 2abb5792387e ("net: qualcomm: rmnet: Allow configuration updates to existing devices")
    Fixes: 1dc49e9d164c ("net: rmnet: do not allow to change mux id if mux id is duplicated")
    in linux-4.19.y: 48c5bfbbcec1
    in linux-5.4.y: 835bbd892683
    Applies to:
        v4.19.y, v5.4.y

Upstream commit 36eb7dc1bd42 ("cpufreq: imx6q: Fixes unwanted cpu overclocking on i.MX6ULL")
    Fixes: 2733fb0d0699 ("cpufreq: imx6q: read OCOTP through nvmem for imx6ul/imx6ull")
    in linux-4.19.y: 4ef576e99d29
    Applies to:
        v4.19.y

Upstream commit 4c7eeb9af3e4 ("arm64: dts: allwinner: h6: Fix PMU compatible")
    Fixes: 7aa9b9eb7d6a ("arm64: dts: allwinner: H6: Add PMU mode")
    in linux-4.19.y: 8f1046b33f1b
    in linux-5.4.y: 02dfae36b03f
    Applies to:
        v4.19.y, v5.4.y

Upstream commit ae769d355664 ("ALSA: pcm: oss: Fix regression by buffer overflow fix")
    Fixes: f2ecf903ef06 ("ALSA: pcm: oss: Avoid plugin buffer overflow")
    in linux-4.14.y: 5ac3462e1921
    in linux-4.19.y: 8c5bd5520334
    in linux-5.4.y: 07ec940ceda5
    Applies to:
        v4.14.y, v4.19.y, v5.4.y

Upstream commit 82e0516ce3a1 ("sched/core: Remove duplicate assignment in sched_tick_remote()")
    Fixes: ebc0f83c78a2 ("timers/nohz: Update NOHZ load in remote tick")
    in linux-5.4.y: 166d6008fa2a
    Applies to:
        v5.4.y

Upstream commit 4ae7a3c3d7d3 ("arm64: dts: allwinner: h5: Fix PMU compatible")
    Fixes: c35a516a4618 ("arm64: dts: allwinner: H5: Add PMU node")
    in linux-5.4.y: 5a241d7bf1e6
    Applies to:
        v5.4.y

Upstream commit 9b8b17541f13 ("mm, memcg: do not high throttle allocators based on wraparound")
    Fixes: e26733e0d0ec ("mm, memcg: throttle allocators based on ancestral memory.high")
    in linux-5.4.y: 61cfbcce9e09
    Applies to:
        v5.4.y

Upstream commit 8c5c66052920 ("nvme-fc: Revert "add module to ops template to allow module references"")
    Fixes: 863fbae929c7 ("nvme_fc: add module to ops template to allow module references")
    in linux-4.14.y: a123233fc320
    in linux-4.19.y: 6c786e656cd9
    in linux-5.4.y: 6b49a5a9eb46
    Applies to:
        v4.14.y, v4.19.y, v5.4.y
