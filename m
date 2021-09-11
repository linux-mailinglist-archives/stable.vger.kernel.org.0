Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D87454075F2
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 11:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235481AbhIKJkn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 05:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235473AbhIKJkk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Sep 2021 05:40:40 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF279C061574;
        Sat, 11 Sep 2021 02:39:27 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id z9-20020a7bc149000000b002e8861aff59so3189874wmi.0;
        Sat, 11 Sep 2021 02:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RhpeDqVjLaXMHu4ZIDl1daKWSTzCEUPkicrz4d8qE58=;
        b=ikIq/ug1WTOgBNkte4NHptkk+6jK0mosru9sw1Uqza9UIJ3rmNTV9t/eEedF1+MNrN
         vpBJTYzB+sXHq4fSnfaiupDArWQp0D1xvzrJFF7qbQrAAwezVGFeGOVa91xFOQsJzYKF
         qE/ocHyujZwX2isMywG+2l/AtlVanU0Yj+STrQl2Lu8DamiIq6kokzX4RhLhI9cJh+m/
         MjDFm0qc3WI2RZdhjayndhj2yAVXM0QsbGUU+DqShrorX3SmX1h935lHjoloPp7FzPts
         iXhBjowarz1gW9T1isruG713zWIpskw97djz4idS5zNG0gfHhlL1YERmDL6EnxykxNku
         37jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=RhpeDqVjLaXMHu4ZIDl1daKWSTzCEUPkicrz4d8qE58=;
        b=1JPvS/lWx49Iq9U62E2WTM3/ndlJS3ohKl5YEgRRgJtV/ehnCRiAO3aDh+Bs+jyxoG
         KEoZi8vOvt84eI2oCoXV1Ik9kF9qcIpVNWP2FX0QTxPKP/aG/L1KvpNI21R37exQfSF3
         nCy9866glOHP0Xl4xLebdcXj3+rP+L0X/u6ez747Kc9HJE+ngVjPM7/eXkW//II5AbrB
         rVoh32VfY6VsE/ZNGMja7JZKUvQk/xiP8JaAu9/ajg7K0kVJKbkp93cd6gs0QlMV9muN
         dHmyQ6LguOB45pKn+5PcqskYYUNrO2FbmitvHRz/RMBw2j0s0BuWRJAyyw8lPnDEvjrJ
         6GCQ==
X-Gm-Message-State: AOAM5332nbvKUSKKCu5cveajz9p5AvoxJ3i5K/6N4G9LF9FJ/upatqLF
        5k55HQsD96Hw9Dm9pn+XRndoEib1Xo0ONg==
X-Google-Smtp-Source: ABdhPJym+/ESfDLYNcbFYq69FSf+Uv8zxtd1vjWQXhEwbpqUQSTI+7s6aIqIvvl9Txnw/xf0dhas8Q==
X-Received: by 2002:a1c:a512:: with SMTP id o18mr1996101wme.162.1631353166448;
        Sat, 11 Sep 2021 02:39:26 -0700 (PDT)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id p17sm1177598wmi.30.2021.09.11.02.39.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Sep 2021 02:39:25 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Sat, 11 Sep 2021 11:39:25 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Florian Westphal <fw@strlen.de>, stable@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 5.10.y 0/3] netfilter: nf_tables fixes for 5.10.y
Message-ID: <YTx5TXJ+M1Khn8uH@eldamar.lan>
References: <20210909140337.29707-1-fw@strlen.de>
 <YTofmaFaPAtGLFs8@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTofmaFaPAtGLFs8@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, Sep 09, 2021 at 04:52:09PM +0200, Greg KH wrote:
> On Thu, Sep 09, 2021 at 04:03:34PM +0200, Florian Westphal wrote:
> > Hello,
> > 
> > please consider applying these nf_tables fixes to the 5.10.y tree.
> > These patches had to mangled to make them apply to 5.10.y.
> > 
> > I've done the follwoing tests in a kasan/kmemleak enabled vm:
> > 1. run upstream nft python/shell tests.
> >    Without patch 2 and 3 doing so results in kernel crash.
> >    Some tests fail but afaics those are expected to
> >    fail on 5.10 due to lack of feature being tested.
> > 2. Tested the 'conncount' feature (its affected by last patch).
> >    Worked as designed.
> > 3. ran nftables related kernel self tests.
> > 
> > No kmemleak or kasan splats were seen.
> > 
> > Eric Dumazet (1):
> >   netfilter: nftables: avoid potential overflows on 32bit arches
> > 
> > Pablo Neira Ayuso (2):
> >   netfilter: nf_tables: initialize set before expression setup
> >   netfilter: nftables: clone set element expression template
> > 
> >  net/netfilter/nf_tables_api.c | 89 ++++++++++++++++++++++-------------
> >  net/netfilter/nft_set_hash.c  | 10 ++--
> >  2 files changed, 62 insertions(+), 37 deletions(-)
> > 
> > -- 
> > 2.32.0
> > 
> 
> All now queued up, thanks!

Florian, thank you! My query originated from a bugreport in Debian
triggering the issue with the 5.10.y kernels used.

Not really needed here as Greg already queued up but:

Tested-by: Salvatore Bonaccorso <carnil@debian.org>

Regards,
Salvatore
