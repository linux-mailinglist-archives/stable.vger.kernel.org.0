Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64AC8688907
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 22:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232868AbjBBVat (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 16:30:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231819AbjBBVas (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 16:30:48 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA262712;
        Thu,  2 Feb 2023 13:30:45 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id n13so3236702plf.11;
        Thu, 02 Feb 2023 13:30:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Nrz3TSmcgrSpTyZCmW79h4FBugW4tEaSs53yJ16o+LY=;
        b=EEWpC85Vt6Nu9fYfzP562UwxgqEfKGDl+Svi44sV6+yCnSHoJaS5NtrLqfIY5P3Mta
         xzu7914vju2do7ooaEpdLyCJFOPe1YtRoXLOhvrSWoTw/XqN+Pakt0t7I1nsWreEZgif
         5L0/iFVQnExE645NHL6Nz6upvotE/mY94j1kjr/To9E80Yzxuac8JGv6w05Iy0Ozx1ev
         iNwrsUJ12hpCriwk28MItcJtsvVib34zGVBLKQT6dQl3MXbsHw19dJrjarP+3DErMzVN
         sTvfSBLMm1JhY4jnyRwr/iiGBO9Kn0TJMrDkTUrkeEhH5Q+LkJ3Oy/Xl7fsQhIpbbylX
         /0cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nrz3TSmcgrSpTyZCmW79h4FBugW4tEaSs53yJ16o+LY=;
        b=LD8fkexDwUmJE68ye5+2evTj7U2wkGQ1pBYfUJcbWhbrVW+tsw/LiexDrMu0BKej/f
         eyWqKL5xt36Z739xKjmUXubGCbscqomrsFaCFE/mNB3R7+QWR/ezh6n6dmGM1SKTS133
         TLBkZTGEdcRSj6aqrwbxhmz+o35k39rOa98c0K08/8WZYSvz6IsYu38LsqF/XXDMxWaY
         HaD8nBTPFo6nX927u1Tx43uxlOVkLs8hMmKxDae2yq/YRN2vKQLPV9ky99SR1rWpJ7DZ
         /0B0btP2i1aC24DeeKT7Y3KwTUnNfBIefXlGqR5CCYIXIvsXbq5b/+8dfIkYueVRuMGY
         JUBw==
X-Gm-Message-State: AO0yUKXa00USBlFYB1sPK2cGHPJpM4rYCE+rqvJPBrWuXr5CW+gbY+tI
        02NW+Fe51LePUCFcxPPFAkfkE10i5tg=
X-Google-Smtp-Source: AK7set8xILWDeKLdsoPmaeC+WBsqixXUKuHo6IuDnFV/HVdfnKuGG0DTdtoKhq33sbxB8mVxSURO+Q==
X-Received: by 2002:a17:903:30c9:b0:191:24d1:8af6 with SMTP id s9-20020a17090330c900b0019124d18af6mr6517030plc.42.1675373444647;
        Thu, 02 Feb 2023 13:30:44 -0800 (PST)
Received: from localhost ([2620:10d:c090:400::5:48a9])
        by smtp.gmail.com with ESMTPSA id a21-20020a170902b59500b00186748fe6ccsm118158pls.214.2023.02.02.13.30.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 13:30:44 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Thu, 2 Feb 2023 11:30:42 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Matthew Wilcox <willy@infradead.org>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        stable@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH] fscrypt: Copy the memcg information to the ciphertext
 page
Message-ID: <Y9wrglzrfzTiCjh8@slm.duckdns.org>
References: <20230129121851.2248378-1-willy@infradead.org>
 <Y9a2m8uvmXmCVYvE@sol.localdomain>
 <Y9bkoasmAmtQ2nSV@casper.infradead.org>
 <Y9mH0PCcZoGPryXw@slm.duckdns.org>
 <Y9oHQ6MfRbfwmFyK@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9oHQ6MfRbfwmFyK@sol.localdomain>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

On Tue, Jan 31, 2023 at 10:31:31PM -0800, Eric Biggers wrote:
> > These can usually be handled by explicitly associating the bio's to the
> > desired cgroups using one of bio_associate_blkg*() or
> > bio_clone_blkg_association().
> 
> Here that already happens in wbc_init_bio(), called from io_submit_init_bio() in
> fs/ext4/page-io.c.

Yeah, without bouncing, that's usually how writeback IOs are associated with
their cgroups.

> > It is possible to go through memcg ownership
> > too using set_active_memcg() so that the page is owned by the target cgroup;
> > however, the page ownership doesn't directly map to IO ownership as the
> > relationship depends on the type of the page (e.g. IO ownership for
> > pagecache writeback is determined per-inode, not per-page). If the in-flight
> > pages are limited, it probably is better to set bio association directly.
> 
> ext4 also calls wbc_account_cgroup_owner() for each pagecache page that's
> written out.  It seems this is for a different purpose -- it looks like the
> fs-writeback code is trying to figure out which cgroup "owns" the inode based on
> which cgroup "owns" most of the pagecache pages?

Yeah, there's a difference between how memory and IO track cgroup ownership.
Memory ownership is per-page but IO ownership is per-inode. This is because
splitting writeback IOs of the same inode can perform really badly, so we
try to find the majority dirty page owner cgroup of a given inode and
associate the whole inode to that cgroup.

So, something like md / dm, which gets a bio from filesystem and then
bounces it to another bio, would use either bio_clone_blkg_association() to
copy the association of the original bio (which probably is set through
wbc_init_bio()) or determine the cgroup the bio should belong to somehow and
set it explicitly with bio_associate_blkg(). However, here, as the
filesystem is the one bouncing I guess it can be simpler.

> The bug we're discussing here is that when ext4 writes out a pagecache page in
> an encrypted file, it first encrypts the data into a bounce page, then passes
> the bounce page (which don't have a memcg) to wbc_account_cgroup_owner().  Maybe
> the proper fix is to just pass the pagecache page to wbc_account_cgroup_owner()
> instead?  See below for ext4 (a separate patch would be needed for f2fs):

Yeah, this makes sense to me and is the right thing to do no matter what.
wbc_account_cgroup_owner() should be fed the origin page so that the IO can
be blamed on the owner of that page.

Thanks.

-- 
tejun
