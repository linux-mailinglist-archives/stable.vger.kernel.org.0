Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECF41AAB92
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 17:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393194AbgDOPOB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 11:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726083AbgDOPOA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 11:14:00 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06EAAC061A0C
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 08:14:00 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id u9so84128pfm.10
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 08:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Edk8pWdhZTKzQGkSqvfRoCx3gEm9RNCeqFp1/44j8ss=;
        b=HQVlolQ/Zg2tGXNiPjlNwiZ8B+eTy9yQnLaISNVbTBT1JeztoXAdIxzQ8tJE5nvMoW
         4I2tPCGFvSjqJCbMYlOsPf5+g5/UHT3ZXDM0xvjV36evESQrdIfCZjHVWprRLqEydYK1
         WT8U4PKiXPWcBvol2Of1VoVHWoZiXzWiAqrZfPWzD+V6cKylMsGbuBPPQF1ANwn//zHe
         CAwgtXmcjocTffxkYLdQkv+HCHhksQ30TS1268fen3UlSXS01B3xf82kA5dRot3NILfF
         /5s1PCz+CdhIkqKcu1p6WcO2J1WHqdJFg7ll6I19H0ahmVevppm3QGVPBSNjv7QGgEBW
         ihOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Edk8pWdhZTKzQGkSqvfRoCx3gEm9RNCeqFp1/44j8ss=;
        b=QFQRtOwQdW2DHgVfee4hPUs8UQG1hVxKsmaBRWdUcIB0Tkcd0uEWX+FomKYS82QyWi
         eb2D/Lx7YkoslsDCj8bGom/wkGfplydIrFReanj1xsOHBkNUfdBgn4pX21P1ih1IhnJs
         rxlphgJ2gB+tJ4zbOnk6oghVKrMMwPjlRa9ZRKuysXb8MlANxBBLlsPVaXQpNKZTl9Ah
         lX7t93Odx/RMhN3paHbwsTZKOGWqBXT7XT+31ImFII5isvJhpeRheuK2/2Gkj5Ed1afZ
         VrQe93kSmUsCxt5j8AmY75BJxGq5GIpAfllpde9te6NKnh7PeQzYk3cg5T/w9IuRKt8O
         bDCg==
X-Gm-Message-State: AGi0PuaLx7RhGqv/6dCD6Tfw7msclK+/rtmfiJf0NsobQIVDrJ7klLNC
        dr13DHewFXSgKuonvHep1pw58Uf2
X-Google-Smtp-Source: APiQypIxtIeoe9Vju7qkwib3cq6nkQyGP0hIFaQO9MrC2mYjDW4CnxdV9QM+Lguhlh82/NksQUNG8A==
X-Received: by 2002:aa7:919a:: with SMTP id x26mr27961277pfa.39.1586963639299;
        Wed, 15 Apr 2020 08:13:59 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z6sm12839943pgg.39.2020.04.15.08.13.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 15 Apr 2020 08:13:57 -0700 (PDT)
Date:   Wed, 15 Apr 2020 08:13:56 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: Re: Patches to apply to stable releases
Message-ID: <20200415151356.GA260479@roeck-us.net>
References: <20200415003148.GA114493@roeck-us.net>
 <20200415101542.GD2568572@kroah.com>
 <6d358d6a-3b7b-25c6-7990-5b36dd4c2d0b@roeck-us.net>
 <20200415144919.GA3646864@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200415144919.GA3646864@kroah.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 15, 2020 at 04:49:19PM +0200, Greg Kroah-Hartman wrote:
> On Wed, Apr 15, 2020 at 07:21:44AM -0700, Guenter Roeck wrote:
> > >> Upstream commit cc41f11a21a5 ("scsi: mpt3sas: Fix kernel panic observed on soft HBA unplug")
> > >>     Fixes: c666d3be99c0 ("scsi: mpt3sas: wait for and flush running commands on shutdown/unload")
> > >>     in linux-4.14.y: 3748694f1b91
> > >>     Applies to:
> > >>         v4.14.y
> > > 
> > > This also belongs to 4.19.y, 5.4.y, 5.5.y, and 5.6.y as it is cc:
> > > stable.  But it doesn't backport cleanly to all, so I need a working
> > > backport in order to be able to take it...
> > > 
> > I tracked this one down. The offending patch (c666d3be99c0) was applied
> > to v4.16 and to v4.14.y. The script takes that as clue to request a backport;
> > it assumes that the normal stable processs (whatever you and Sasha run to
> > identify patches to apply) takes care of more recent releases, and doesn't
> > look into those. This is intentional. We can change it, but I don't really
> > want to duplicate your and Sasha's work.
> > 
> > Oops, and I completely forgot about 5.5 and 5.6. The script doesn't tell
> > me (and neither about 4.9) because there is no such Chrome OS release,
> > so I have to check those manually.
> > 
> > Either case, the patch applies cleanly to 4.19.y and later for me.
> > Did you see conflicts, or build problems, when trying to apply it ?
> 
> When trying to patch 4.19.y:
> 	checking file drivers/scsi/mpt3sas/mpt3sas_scsih.c
> 	Hunk #1 succeeded at 9919 (offset 11 lines).
> 	Hunk #2 FAILED at 9992.
> 	1 out of 2 hunks FAILED
> 

Interesting. Both "git cherry-pick" and "git am" (I don't even need
"git am -3") on top of v4.19.115 work fine for me. But, yes, trying
to apply the patch using the patch command does indeed fail with this
error. Wonder what git does differently when running "git am".

> > Note that we don't really care about mpt3sas; missing that patch
> > is not a problem for us. My qemu emulations test basic mpt3sas
> > operation, but not unplug situations, so I would not miss the patch
> > there either. So feel free to ignore/drop if it causes issues.
> 
> I've asked the developers for a backport, if they think it is needed.
> 
> > >> Upstream commit 82f04bfe2aff ("tools: gpio: Fix out-of-tree build regression")
> > >>     Fixes: 0161a94e2d1c ("tools: gpio: Correctly add make dependencies for gpio_utils")
> > >>     in linux-4.14.y: f71e52cb3270
> > >>     in linux-4.19.y: 036588ec6888
> > >>     Applies to:
> > >>         v4.14.y, v4.19.y
> > > 
> > > Also belongs to 4.9.y, 5.6.y, 5.5.y, and 5.4.y.  Also has a cc: stable
> > > that I hadn't gotten to yet, now applied.
> > > 
> > The offending patch (0161a94e2d1c) is in 5.4, and thus the script assumes
> > that the normal stable process would take care of it. Same situation as
> > above. And I forgot to check 4.9, sorry.
> > 
> > >> Upstream commit 3e487d2e4aa4 ("PCI: pciehp: Fix indefinite wait on sysfs requests")
> > >>     Fixes: 157c1062fcd8 ("PCI: pciehp: Avoid returning prematurely from sysfs requests")
> > >>     in linux-4.19.y: 248e65f3220e
> > >>     in linux-5.4.y: 9bd9d123399b
> > >>     Applies to:
> > >>         v4.19.y, v5.4.y
> > > 
> > > Already queued up yesterday, and to 5.5.y and 5.6.y.
> > > 
> > >> Upstream commit 8644772637de ("mm: Use fixed constant in page_frag_alloc instead of size + 1")
> > >>     Fixes: 2c2ade81741c ("mm: page_alloc: fix ref bias in page_frag_alloc() for 1-byte allocs")
> > >>     in linux-4.14.y: a977209627ca
> > >>     in linux-4.19.y: 33e83ea302c0
> > >>     Applies to:
> > >>         v4.14.y, v4.19.y
> > > 
> > > Also needed in 4.9.y, now queued up.
> > > 
> > >> Upstream commit 2abb5792387e ("net: qualcomm: rmnet: Allow configuration updates to existing devices")
> > >>     Fixes: 1dc49e9d164c ("net: rmnet: do not allow to change mux id if mux id is duplicated")
> > >>     in linux-4.19.y: 48c5bfbbcec1
> > >>     in linux-5.4.y: 835bbd892683
> > >>     Applies to:
> > >>         v4.19.y, v5.4.y
> > > 
> > > Normally I wait for DavidM to send me these as they are also applicable
> > > to 5.6.y and 5.5.y.  Now queued up.
> > > 
> > >> Upstream commit 36eb7dc1bd42 ("cpufreq: imx6q: Fixes unwanted cpu overclocking on i.MX6ULL")
> > >>     Fixes: 2733fb0d0699 ("cpufreq: imx6q: read OCOTP through nvmem for imx6ul/imx6ull")
> > >>     in linux-4.19.y: 4ef576e99d29
> > >>     Applies to:
> > >>         v4.19.y
> > > 
> > > Queued up yesterday.
> > > 
> > >> Upstream commit 4c7eeb9af3e4 ("arm64: dts: allwinner: h6: Fix PMU compatible")
> > >>     Fixes: 7aa9b9eb7d6a ("arm64: dts: allwinner: H6: Add PMU mode")
> > >>     in linux-4.19.y: 8f1046b33f1b
> > >>     in linux-5.4.y: 02dfae36b03f
> > >>     Applies to:
> > >>         v4.19.y, v5.4.y
> > > 
> > > Also needed in 5.5.y and 5.6.y.
> > > 
> > >> Upstream commit ae769d355664 ("ALSA: pcm: oss: Fix regression by buffer overflow fix")
> > >>     Fixes: f2ecf903ef06 ("ALSA: pcm: oss: Avoid plugin buffer overflow")
> > >>     in linux-4.14.y: 5ac3462e1921
> > >>     in linux-4.19.y: 8c5bd5520334
> > >>     in linux-5.4.y: 07ec940ceda5
> > >>     Applies to:
> > >>         v4.14.y, v4.19.y, v5.4.y
> > > 
> > > Already queued up yesterday all the way back to 4.4.y and 4.9.y as well
> > > because f2ecf903ef06 ("ALSA: pcm: oss: Avoid plugin buffer overflow")
> > > went that far back.  Did your scripts miss that?
> > > 
> > It was dropped from 4.4 because it causes a conflict when trying to apply
> > it to chromeos-4.4. I'll see what I can do about that.
> > 
> > >> Upstream commit 82e0516ce3a1 ("sched/core: Remove duplicate assignment in sched_tick_remote()")
> > >>     Fixes: ebc0f83c78a2 ("timers/nohz: Update NOHZ load in remote tick")
> > >>     in linux-5.4.y: 166d6008fa2a
> > >>     Applies to:
> > >>         v5.4.y
> > > 
> > > Also applied to 5.5.y and 5.6.y
> > > 
> > >> Upstream commit 4ae7a3c3d7d3 ("arm64: dts: allwinner: h5: Fix PMU compatible")
> > >>     Fixes: c35a516a4618 ("arm64: dts: allwinner: H5: Add PMU node")
> > >>     in linux-5.4.y: 5a241d7bf1e6
> > >>     Applies to:
> > >>         v5.4.y
> > > 
> > > Also applied to 5.5.y and 5.6.y
> > > 
> > >> Upstream commit 9b8b17541f13 ("mm, memcg: do not high throttle allocators based on wraparound")
> > >>     Fixes: e26733e0d0ec ("mm, memcg: throttle allocators based on ancestral memory.high")
> > >>     in linux-5.4.y: 61cfbcce9e09
> > >>     Applies to:
> > >>         v5.4.y
> > > 
> > > Hadn't gotten to it yet, also queued up for 5.5.y and 5.6.y
> > > 
> > >> Upstream commit 8c5c66052920 ("nvme-fc: Revert "add module to ops template to allow module references"")
> > >>     Fixes: 863fbae929c7 ("nvme_fc: add module to ops template to allow module references")
> > >>     in linux-4.14.y: a123233fc320
> > >>     in linux-4.19.y: 6c786e656cd9
> > >>     in linux-5.4.y: 6b49a5a9eb46
> > >>     Applies to:
> > >>         v4.14.y, v4.19.y, v5.4.y
> > > 
> > > Queued up yesterday, also for 5.5.y and 5.6.y.
> > > 
> > > Many thanks for these, I think they should now all be handled.
> > > 
> > 
> > Thanks a lot, and sorry for missing 5.5/5.6. Those really completely
> > slipped my mind.
> > 
> > So the big question is if we should report patches such as 82f04bfe2aff,
> > ie patches missing from stable releases where the offending patch was
> > not applied to a stable release but to mainline. This would overlap
> > with Sasha's script, though, so I am not sure if it would be a good
> > idea. What is your take ?
> 
> The "offending" patch in that case was applied to mainline and all the
> way back to 4.9.y (was in 4.9.204) , so yes, it is good to be notified
> of this.
> 
Ok, I'll see what I can do. I'll try to get it done in time for next
week's report.

Thanks,
Guenter
