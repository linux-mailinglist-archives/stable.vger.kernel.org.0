Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E919575110
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 16:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239502AbiGNOtI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 10:49:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239476AbiGNOtI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 10:49:08 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77DE32B263;
        Thu, 14 Jul 2022 07:49:07 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id 5so612040plk.9;
        Thu, 14 Jul 2022 07:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4LaGbaJVsjDK875ROJlQkqLwxiwHL8FFPuMo5UJiGRo=;
        b=nwxrohJRbuWLo7rbq8G71gYJKrcs3csMxEK8TSspkuSAIAZsnBxi/Kri2wHl0/Ef1+
         hfl4z/jmMBLVqpooh82fRhFzCTBJ5LAcU1gPdRLv8j8KpW7nlL1CRB1MVBHkdIgccDBN
         4/l3js9MiLsw0J14BaZztnndGFhpRxBRYi51WjbqVOSZiTrSrE1bpPZ5tSwM9AneKOcP
         uqzopgrry7LjSJigGnPB2PCZsJdfxxBHlBWnSb0+iviIrgXU6fSQDiZ1iku0LY8cP96F
         HHIzMc14dZsJBEBJEMStJNU0cvY2iOtfccVYG6NrFXvPxjqWQBWBr49D671RDOTBqbgz
         715A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4LaGbaJVsjDK875ROJlQkqLwxiwHL8FFPuMo5UJiGRo=;
        b=cW1+bCdEtcjFKkTVgxPVkhynN/tgPSPXm9yaQghjXWeu7r6dhV7PpiEyexrZVrGWqI
         xGbWGcGsCHkb+tL3qQBEjgFeDpJ1ZOIcqEG70QI0olEsTZjdIapzQmYtuMg3h87WdrCv
         ++7B18YK0TZF6eCQ4cOTYzXqoTGiNdFqyE4IxmPCwfer0AxI81HzTpd188YhFFRTynvm
         PklARwtmmKzvRA0aMcZJYlVw1SUH1Nr5uW469/CyOLkZHe3VWUgRUr/nsMsGLfjf4aUU
         LB9GCc/ZlGymrhrBNWacJEHgLDOkWtmOxx7a/3bNdW7JXxYha4x3R5qBQYlr13qFSPUz
         9oxA==
X-Gm-Message-State: AJIora/ok1vC2IAoTQeU99nMH5meSm4I3Lql34LfLdABAzGoRmvs7Ogi
        ciNPglenSMt9hYl3NrytmlA=
X-Google-Smtp-Source: AGRyM1t0xwbozxagNxKzqGJogi//moFDBGxBtU+JPlLrYjTSKW2bWk1THI9Q68EMmHoDpxBR7ibhjg==
X-Received: by 2002:a17:90b:4acb:b0:1f0:62ab:2956 with SMTP id mh11-20020a17090b4acb00b001f062ab2956mr10032905pjb.178.1657810146968;
        Thu, 14 Jul 2022 07:49:06 -0700 (PDT)
Received: from localhost ([2406:7400:63:cb1d:811:33e9:9bc2:d40])
        by smtp.gmail.com with ESMTPSA id d8-20020a170902654800b0016bd5da20casm1552333pln.134.2022.07.14.07.49.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 07:49:06 -0700 (PDT)
Date:   Thu, 14 Jul 2022 20:19:02 +0530
From:   Ritesh Harjani <ritesh.list@gmail.com>
To:     Jan Kara <jack@suse.cz>
Cc:     Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 01/10] mbcache: Don't reclaim used entries
Message-ID: <20220714144902.vptbdgmbkd5nxara@riteshh-domain>
References: <20220712104519.29887-1-jack@suse.cz>
 <20220712105436.32204-1-jack@suse.cz>
 <20220714114702.wwd4o3zjdujd34kz@riteshh-domain>
 <20220714143612.oa2u6opi6feqkrvy@quack3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220714143612.oa2u6opi6feqkrvy@quack3>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22/07/14 04:36PM, Jan Kara wrote:
> On Thu 14-07-22 17:17:02, Ritesh Harjani wrote:
> > On 22/07/12 12:54PM, Jan Kara wrote:
> > > Do not reclaim entries that are currently used by somebody from a
> > > shrinker. Firstly, these entries are likely useful. Secondly, we will
> > > need to keep such entries to protect pending increment of xattr block
> > > refcount.
> > >
> > > CC: stable@vger.kernel.org
> > > Fixes: 82939d7999df ("ext4: convert to mbcache2")
> > > Signed-off-by: Jan Kara <jack@suse.cz>
> > > ---
> > >  fs/mbcache.c | 10 +++++++++-
> > >  1 file changed, 9 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/fs/mbcache.c b/fs/mbcache.c
> > > index 97c54d3a2227..cfc28129fb6f 100644
> > > --- a/fs/mbcache.c
> > > +++ b/fs/mbcache.c
> > > @@ -288,7 +288,7 @@ static unsigned long mb_cache_shrink(struct mb_cache *cache,
> > >  	while (nr_to_scan-- && !list_empty(&cache->c_list)) {
> > >  		entry = list_first_entry(&cache->c_list,
> > >  					 struct mb_cache_entry, e_list);
> > > -		if (entry->e_referenced) {
> > > +		if (entry->e_referenced || atomic_read(&entry->e_refcnt) > 2) {
> > >  			entry->e_referenced = 0;
> > >  			list_move_tail(&entry->e_list, &cache->c_list);
> > >  			continue;
> > > @@ -302,6 +302,14 @@ static unsigned long mb_cache_shrink(struct mb_cache *cache,
> > >  		spin_unlock(&cache->c_list_lock);
> > >  		head = mb_cache_entry_head(cache, entry->e_key);
> > >  		hlist_bl_lock(head);
> > > +		/* Now a reliable check if the entry didn't get used... */
> > > +		if (atomic_read(&entry->e_refcnt) > 2) {
> >
> > On taking a look at this patchset again. I think if we move this "if" condition
> > of checking refcnt to above i.e. before we delete the entry from c_list.
> > Then we can avoid =>
> > removing of the entry -> checking it's refcnt under lock -> adding it back
> > if the refcnt is elevated.
> >
> > Thoughts?
>
> Well, but synchronization would get more complicated because we don't want
> to acquire hlist_bl_lock() under c_list_lock (technically we could at this
Ok, yes. I tried implementing it and it becomes lock()/unlock() mess.

> point in the series but it would make life harder for the last patch in the
> series). And we need c_list_lock to remove entry from the LRU list. It
> could be all done but I don't think what you suggest is really that simpler
> and this code will go away later in the patchset anyway...

I agree. Thanks for re-checking it.

-ritesh
