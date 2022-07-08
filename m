Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF6C56C104
	for <lists+stable@lfdr.de>; Fri,  8 Jul 2022 20:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234824AbiGHSiH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jul 2022 14:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236808AbiGHSiG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jul 2022 14:38:06 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7E2C1A384;
        Fri,  8 Jul 2022 11:38:05 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id y141so24173040pfb.7;
        Fri, 08 Jul 2022 11:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CIgYJJQkA/J/rKPGntZ74Ui+SaGHF5L8lzs2R9RO6kg=;
        b=LgKdgMggkrqFxZ/xapJS5oqPKMLExiphWbrLLlup8g5PxhGgp9FMUAogAKKkUUe0MO
         3yR9AF5261xUmG47wu1pDf96sLouo0jEFmNeI1+xum94agFR2AbD5SJ4sBRGn51qf2Ni
         WTNaKchMFJ7p9IpJVEKkbvPgXpIx6n59HRS56AeA4/gRRIXuHzFzLPnPEE2pyXgcL2vR
         RE0eHLvCtduQP9h6fsB6lf2rXoPVo+wHoCj1X3gNOtftlxQuNFeOg5TBPyqdNf1fYSYX
         avZKTf7UJPiboW06vX2xhLsHe6BaxgFLLR+BQmLPgTO2YjwQpdaEdEh3E+k8hLzbcw0n
         n+kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CIgYJJQkA/J/rKPGntZ74Ui+SaGHF5L8lzs2R9RO6kg=;
        b=VXtpB3TwndA2KTQ3E0z4A9/AUscDQkaejFk0gKeUncUNyqX/tv1pbsrZkj3pW5qoY/
         f5U6JRwrghgujiznmwKeFrSMs6hk3HYYULSpEbwdi4LVV6VyTKVRBvMQmYn0nV4AIzsQ
         OKeSD9kPH4nv8/ahdCJJZyH5zMVpZrmkBxPUFCmQACOhgZUORV/iMNVUdclKMHgptOyh
         aUx0FcX76FDeF11tE8OgNXQ/hJq8P5Dg5BrRJtVSlyjY1iBMGGOhGtwHyyCVJNavkDiP
         MTQ32F4KxMmbGLATGx5UEczQBGuT76KRJrXTyLEcooWR4htE012H8dRfOBWApINitZEc
         aDDg==
X-Gm-Message-State: AJIora9crvObCbDbY/TN9L/f3nBAyVv9GcVV1WeV5uBULVjQLu6CKgs2
        uqari9BVRidPD7P7oSb/eQE=
X-Google-Smtp-Source: AGRyM1sm4ylT7N1qtCBlDXPhNvohT7v7jQBSVGh2ia8cJwaYgBIghnHkroQ1yJPNKFY2YntjOiX4Bg==
X-Received: by 2002:a63:ee0a:0:b0:40d:2773:16d2 with SMTP id e10-20020a63ee0a000000b0040d277316d2mr4507448pgi.95.1657305485016;
        Fri, 08 Jul 2022 11:38:05 -0700 (PDT)
Received: from google.com ([2601:647:4701:18d0:5af3:d449:ddaf:9156])
        by smtp.gmail.com with ESMTPSA id t17-20020a170902e85100b00162529828aesm30669103plg.109.2022.07.08.11.38.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 11:38:04 -0700 (PDT)
Date:   Fri, 8 Jul 2022 11:38:02 -0700
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Kuniyuki Iwashima <kuniyu@amazon.com>, stable@vger.kernel.org,
        linux-xfs@vger.kernel.org, Ke Xu <kkexu@amazon.com>,
        Ayushman Dutta <ayudutta@amazon.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH stable 5.15] xfs: remove incorrect ASSERT in xfs_rename
Message-ID: <Ysh5inAXa/ox9nO0@google.com>
References: <20220707225835.32094-1-kuniyu@amazon.com>
 <YshTJZVNkXpbGKsv@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YshTJZVNkXpbGKsv@magnolia>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 08, 2022 at 08:54:13AM -0700, Darrick J. Wong wrote:
> On Thu, Jul 07, 2022 at 03:58:35PM -0700, Kuniyuki Iwashima wrote:
> > From: Eric Sandeen <sandeen@redhat.com>
> > 
> > commit e445976537ad139162980bee015b7364e5b64fff upstream.
> > 
> > Ayushman Dutta reported our 5.10 kernel hit the warning.  It was because
> > the original commit misses a Fixes tag and was not backported to the stable
> > tree.  The fix is merged in 5.16, so please backport it to 5.15 first.
> > 
> > This ASSERT in xfs_rename is a) incorrect, because
> > (RENAME_WHITEOUT|RENAME_NOREPLACE) is a valid combination, and
> > b) unnecessary, because actual invalid flag combinations are already
> > handled at the vfs level in do_renameat2() before we get called.
> > So, remove it.
> > 
> > Reported-by: Paolo Bonzini <pbonzini@redhat.com>
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Fixes: 7dcf5c3e4527 ("xfs: add RENAME_WHITEOUT support")
> > Reported-by: Ayushman Dutta <ayudutta@amazon.com>
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> 
> Looks good to me, but you really ought to send 5.10 patches to the 5.10
> XFS maintainer (Amir, now cc'd).  (Yes, this is a recent change.) ;)
> 
> Acked-by: Darrick J. Wong <djwong@kernel.org>
> 
> --D

This patch is actually part of the next set of 10 patches being testing
for the 5.15 branch :) It would have been going out in the next week or
two, but since this is such a minor change, we can just go ahead with it.

- Leah
> 
> > ---
> > I will send another patch for 4.9 - 5.4 because of a conflict with idmapped
> > mount changes.
> > ---
> >  fs/xfs/xfs_inode.c | 1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 2477e301fa82..c19f3ca605af 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -3128,7 +3128,6 @@ xfs_rename(
> >  	 * appropriately.
> >  	 */
> >  	if (flags & RENAME_WHITEOUT) {
> > -		ASSERT(!(flags & (RENAME_NOREPLACE | RENAME_EXCHANGE)));
> >  		error = xfs_rename_alloc_whiteout(mnt_userns, target_dp, &wip);
> >  		if (error)
> >  			return error;
> > -- 
> > 2.30.2
> > 
