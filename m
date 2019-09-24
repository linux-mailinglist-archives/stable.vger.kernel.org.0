Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8313BCC65
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 18:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441456AbfIXQZ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:25:29 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:44449 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725963AbfIXQZ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Sep 2019 12:25:28 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 9366052D;
        Tue, 24 Sep 2019 12:25:27 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 24 Sep 2019 12:25:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=6qqrID0O1UemIFj3no7x8G/XgOH
        ncrLHa/bLupLvoSA=; b=cjbc9evmKqxSwvmsiFb82T13g8jgZsb1sp2VRq3z4TZ
        8GXu9JHiZvPGCsxnD3HQccZ+F3/T2WMLV6IdRDsRiOy4d2/7nhllItC2lDyQ2pLc
        keyZC6/HZiZotFAt688k4hL16xjDjp3Pp5c/jNDSGNWfR4i2TppzMd0VWByQ9pJY
        q0LJcRVR1OHpZ3zg7BwEZIrZ+1YeKks2AENV6xQHS9MMBoNiRPemK9vFJO57rs6T
        EMURPNrDvAE7YnKOy+0puqezTOrVWl1mlcYkKNveJqEIdDpMTMdR2B0ee83areEP
        zwb3J7I3pF9HIZckmNNAQZ8iMur37XiEASk2ER0nFTA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=6qqrID
        0O1UemIFj3no7x8G/XgOHncrLHa/bLupLvoSA=; b=mrraf13GYOS6WZYuf+zi8s
        Dw1nWcPfTE98SgrIZUiPnKLx49BLjRVxGv2n2ZIvXspUJWzIu87rwDw2kkui4stA
        zS3ydl9ao2C12jNn8b7X3oTDfS3EtzdlIKstP7Tv02epAbayb+VLpPDgIK5kLbKh
        cBt85n57s5issdY1UAW98pK8S0UEUacf3MK5fn6xwFeJuvQ/kXa7aaDvXD6Adhxp
        f0piL4vUd85TSAeUD6AyrhXfzKMwuiHGVsrfmSViRxiLG/noKwc1jUSmP+FHB+rm
        rg8SjpMTbqrTmPv2ekqRPvPt7N7P2PxYttV8iZ/s/RKOdEk7KI2S8vce5lunDG/Q
        ==
X-ME-Sender: <xms:d0OKXVigPnq7W9E3jsdQhBCi-W02533tlwCHR_kwIIuAi2Ic7-35SQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrfedtgdellecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjfgesthdtre
    dttdervdenucfhrhhomhepifhrvghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheq
    necuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrddutd
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:d0OKXW4q9_h0Ks_oQm61r_bf6O6_r2vANnHb9mSQQ4wQ6tppO67P9Q>
    <xmx:d0OKXU2aUKBuC5DGmAg9F7DQN3E-0CaLRltQbwhns96sqnvRu4yQ3w>
    <xmx:d0OKXZsQbzMXQb1c1Twu1k1GoUSCsuE3nh8XolG9mc_jRAy31lWo7Q>
    <xmx:d0OKXdwrWSsBalKS0fKeQ-5Xb7R2Sy1HfM8nMazZ40YmzMTnU0jwhw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B3FA6D6005B;
        Tue, 24 Sep 2019 12:25:26 -0400 (EDT)
Date:   Tue, 24 Sep 2019 18:25:23 +0200
From:   Greg KH <greg@kroah.com>
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Stable <stable@vger.kernel.org>
Subject: Re: [PATCH] CIFS: fix deadlock in cached root handling
Message-ID: <20190924162523.GB793386@kroah.com>
References: <20190920210803.4405-1-pshilov@microsoft.com>
 <CAKywueSieSuPBkSbaLkzFq7i=BDCjQidz9i09NeY5WmGRa9Q=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKywueSieSuPBkSbaLkzFq7i=BDCjQidz9i09NeY5WmGRa9Q=g@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 20, 2019 at 02:23:00PM -0700, Pavel Shilovsky wrote:
> Fri, Sep 20, 2019 at 14:08, Pavel Shilovsky <piastryyy@gmail.com>:
> >
> > From: Aurelien Aptel <aaptel@suse.com>
> >
> > Commit 7e5a70ad88b1 ("CIFS: fix deadlock in cached root handling") upstream.
> >
> > Prevent deadlock between open_shroot() and
> > cifs_mark_open_files_invalid() by releasing the lock before entering
> > SMB2_open, taking it again after and checking if we still need to use
> > the result.
> >
> > CC: <stable@vger.kernel.org> # v4.19+
> > Link: https://lore.kernel.org/linux-cifs/684ed01c-cbca-2716-bc28-b0a59a0f8521@prodrive-technologies.com/T/#u
> > Fixes: 3d4ef9a15343 ("smb3: fix redundant opens on root")
> > Signed-off-by: Aurelien Aptel <aaptel@suse.com>
> > Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
> > ---
> >  fs/cifs/smb2ops.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 44 insertions(+)
> >
> > diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> > index cc9e846a3865..094be406cde4 100644
> > --- a/fs/cifs/smb2ops.c
> > +++ b/fs/cifs/smb2ops.c
> > @@ -553,7 +553,50 @@ int open_shroot(unsigned int xid, struct cifs_tcon *tcon, struct cifs_fid *pfid)
> >         oparams.fid = pfid;
> >         oparams.reconnect = false;
> >
> > +       /*
> > +        * We do not hold the lock for the open because in case
> > +        * SMB2_open needs to reconnect, it will end up calling
> > +        * cifs_mark_open_files_invalid() which takes the lock again
> > +        * thus causing a deadlock
> > +        */
> > +       mutex_unlock(&tcon->crfid.fid_mutex);
> >         rc = SMB2_open(xid, &oparams, &srch_path, &oplock, NULL, NULL, NULL);
> > +       mutex_lock(&tcon->crfid.fid_mutex);
> > +
> > +       /*
> > +        * Now we need to check again as the cached root might have
> > +        * been successfully re-opened from a concurrent process
> > +        */
> > +
> > +       if (tcon->crfid.is_valid) {
> > +               /* work was already done */
> > +
> > +               /* stash fids for close() later */
> > +               struct cifs_fid fid = {
> > +                       .persistent_fid = pfid->persistent_fid,
> > +                       .volatile_fid = pfid->volatile_fid,
> > +               };
> > +
> > +               /*
> > +                * Caller expects this func to set pfid to a valid
> > +                * cached root, so we copy the existing one and get a
> > +                * reference
> > +                */
> > +               memcpy(pfid, tcon->crfid.fid, sizeof(*pfid));
> > +               kref_get(&tcon->crfid.refcount);
> > +
> > +               mutex_unlock(&tcon->crfid.fid_mutex);
> > +
> > +               if (rc == 0) {
> > +                       /* close extra handle outside of critical section */
> > +                       SMB2_close(xid, tcon, fid.persistent_fid,
> > +                                  fid.volatile_fid);
> > +               }
> > +               return 0;
> > +       }
> > +
> > +       /* Cached root is still invalid, continue normaly */
> > +
> >         if (rc == 0) {
> >                 memcpy(tcon->crfid.fid, pfid, sizeof(struct cifs_fid));
> >                 tcon->crfid.tcon = tcon;
> > @@ -561,6 +604,7 @@ int open_shroot(unsigned int xid, struct cifs_tcon *tcon, struct cifs_fid *pfid)
> >                 kref_init(&tcon->crfid.refcount);
> >                 kref_get(&tcon->crfid.refcount);
> >         }
> > +
> >         mutex_unlock(&tcon->crfid.fid_mutex);
> >         return rc;
> >  }
> > --
> > 2.17.1
> >
> 
> Forgot to mention that kernels 5.1.y and above already have the
> appropriate patch. This is a backport for 4.19.

Now queued up, thanks!

greg k-h
