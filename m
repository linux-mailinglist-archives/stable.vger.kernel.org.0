Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C17928E6E8
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 21:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730409AbgJNTJo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 15:09:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgJNTJn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Oct 2020 15:09:43 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA9EC061755;
        Wed, 14 Oct 2020 12:09:43 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id w17so543332ilg.8;
        Wed, 14 Oct 2020 12:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vJ1nHXm544IufxzpS6W1OHKpFLa6HHKFKEYPJk1K/jI=;
        b=ZtI7mQbOFJ1QO8SGwtWjKh1Hlrg/2l/t2Mmr+Mwgq5uUMaqt3a0p5gfmuJsOBDLakD
         MYJesXxpgX2UbumN1VBpedBsGCG+mSeOigAqr1vgpY1fSmYcxf1lzbsqCvckKEeshyzt
         SWw6kB4a3QHfnRyywZaP0KaAdFLZpx2m5YIs9FfnRjWd86Rw3CODEpFtxGelDul8LLcS
         C1yi3OEt7/q1qrpHxjdylK07RRGd6VtenLaaku0Jz8H1pMLokJ5Cn7sAMUAAgqvETiUS
         0mU6ZHGghPUXRXNHFROqkQlBx/n9CsalDYj5iQis9T/nNZRn+vwSC3xiLdrypzHEqb4M
         x9Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vJ1nHXm544IufxzpS6W1OHKpFLa6HHKFKEYPJk1K/jI=;
        b=sB7LJg0hs2dn2gYrD9n6mlMOWImwcdAGYkpgx6KoEzBuY1BUJ5MzGWL8TFeWnAC+At
         jbjq0ccpXXicqMYZbyyA/I8Lbx6Ch3pHLOWySaB1sYHR57xWrvuDh2Abcc5aTytRSfG1
         czOTSZlNpKQGj5PezkjHScSJejgP2q/4C27Y5Ht3DSiCVKE7QOvIvH/pK9VYzu6dEM7W
         wo2wCQDwJB5hKaN4SO/vok0pl1+7d44WQK9u7gnne4IOBRIK1Wwo9QM+nwq4ljvqg8ks
         6YVcvAt0c1g9vNeFq3uQmqakEOtuBu6IKNjeU0Ik3LRwJQMcDBsXKkvfbijHClj0UrIL
         VzbA==
X-Gm-Message-State: AOAM530w3INjS6G9BwuWflfiKU//BCSrWCv1C/vby8uFTE7c4qZW6iVh
        aNBjao7bPxqxMCIKPZBSQVhBLSXVsDETU35DNLU1usRsuvvyNA==
X-Google-Smtp-Source: ABdhPJy7WRMfB+1jjmRcweTCJ2aiDFHUwa+aAdI5T6ctQftI4CddTIVgSDtZ59PeWQtt7GXHJrpfC0dlVyGJwmVX/V8=
X-Received: by 2002:a92:99cb:: with SMTP id t72mr550757ilk.172.1602702582726;
 Wed, 14 Oct 2020 12:09:42 -0700 (PDT)
MIME-Version: 1.0
References: <20201006151456.20875-1-ashishsangwan2@gmail.com> <2d1ff3421a88ece2f1b7708cdbc9d34b00ad3e81.camel@hammerspace.com>
In-Reply-To: <2d1ff3421a88ece2f1b7708cdbc9d34b00ad3e81.camel@hammerspace.com>
From:   Ashish Sangwan <ashishsangwan2@gmail.com>
Date:   Thu, 15 Oct 2020 00:39:31 +0530
Message-ID: <CAOiN93mh-ssTDuN1fAptECqc5JpUHtK=1V56jY_0MtWEcT=U2Q@mail.gmail.com>
Subject: Re: [PATCH] NFS: Fix mode bits and nlink count for v4 referral dirs
To:     Trond Myklebust <trondmy@hammerspace.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "anna.schumaker@netapp.com" <anna.schumaker@netapp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 14, 2020 at 11:47 PM Trond Myklebust
<trondmy@hammerspace.com> wrote:
>
> On Tue, 2020-10-06 at 08:14 -0700, Ashish Sangwan wrote:
> > Request for mode bits and nlink count in the nfs4_get_referral call
> > and if server returns them use them instead of hard coded values.
> >
> > CC: stable@vger.kernel.org
> > Signed-off-by: Ashish Sangwan <ashishsangwan2@gmail.com>
> > ---
> >  fs/nfs/nfs4proc.c | 20 +++++++++++++++++---
> >  1 file changed, 17 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
> > index 6e95c85fe395..efec05c5f535 100644
> > --- a/fs/nfs/nfs4proc.c
> > +++ b/fs/nfs/nfs4proc.c
> > @@ -266,7 +266,9 @@ const u32 nfs4_fs_locations_bitmap[3] = {
> >       | FATTR4_WORD0_FSID
> >       | FATTR4_WORD0_FILEID
> >       | FATTR4_WORD0_FS_LOCATIONS,
> > -     FATTR4_WORD1_OWNER
> > +     FATTR4_WORD1_MODE
> > +     | FATTR4_WORD1_NUMLINKS
> > +     | FATTR4_WORD1_OWNER
> >       | FATTR4_WORD1_OWNER_GROUP
> >       | FATTR4_WORD1_RAWDEV
> >       | FATTR4_WORD1_SPACE_USED
> > @@ -7594,16 +7596,28 @@ nfs4_listxattr_nfs4_user(struct inode *inode,
> > char *list, size_t list_len)
> >   */
> >  static void nfs_fixup_referral_attributes(struct nfs_fattr *fattr)
> >  {
> > +     bool fix_mode = true, fix_nlink = true;
> > +
> >       if (!(((fattr->valid & NFS_ATTR_FATTR_MOUNTED_ON_FILEID) ||
> >              (fattr->valid & NFS_ATTR_FATTR_FILEID)) &&
> >             (fattr->valid & NFS_ATTR_FATTR_FSID) &&
> >             (fattr->valid & NFS_ATTR_FATTR_V4_LOCATIONS)))
> >               return;
> >
> > +     if (fattr->valid & NFS_ATTR_FATTR_MODE)
> > +             fix_mode = false;
> > +     if (fattr->valid & NFS_ATTR_FATTR_NLINK)
> > +             fix_nlink = false;
> >       fattr->valid |= NFS_ATTR_FATTR_TYPE | NFS_ATTR_FATTR_MODE |
> >               NFS_ATTR_FATTR_NLINK | NFS_ATTR_FATTR_V4_REFERRAL;
> > -     fattr->mode = S_IFDIR | S_IRUGO | S_IXUGO;
> > -     fattr->nlink = 2;
> > +
> > +     if (fix_mode)
> > +             fattr->mode = S_IFDIR | S_IRUGO | S_IXUGO;
> > +     else
> > +             fattr->mode |= S_IFDIR;
> > +
> > +     if (fix_nlink)
> > +             fattr->nlink = 2;
> >  }
> >
> >  static int _nfs4_proc_fs_locations(struct rpc_clnt *client, struct
> > inode *dir,
>
> NACK to this patch. The whole point is that if the server has a
> referral, then it is not going to give us any attributes other than the
> ones we're already asking for because it may not even have a real
> directory. The client is required to fake up an inode, hence the
> existing code.

Hi Trond, thanks for reviewing the patch!
Sorry but I didn't understand the reason to NACK it. Could you please
elaborate your concern?
These are the current attributes we request from the server on a referral:
FATTR4_WORD0_CHANGE
| FATTR4_WORD0_SIZE
| FATTR4_WORD0_FSID
| FATTR4_WORD0_FILEID
| FATTR4_WORD0_FS_LOCATIONS,
FATTR4_WORD1_OWNER
| FATTR4_WORD1_OWNER_GROUP
| FATTR4_WORD1_RAWDEV
| FATTR4_WORD1_SPACE_USED
| FATTR4_WORD1_TIME_ACCESS
| FATTR4_WORD1_TIME_METADATA
| FATTR4_WORD1_TIME_MODIFY
| FATTR4_WORD1_MOUNTED_ON_FILEID,

So you are suggesting that it's ok to ask for SIZE, OWNER, OWNER
GROUP, SPACE USED, TIMESTAMPs etc but not ok to ask for mode bits and
numlinks?
Also, isn't the whole point of the server returning attribute map is
to tell the client which attribute is valid? So, in the case where the
server does not have the required information then it will not return
those attributes and we will fall back to the old behavior.
Whether the server has nlink and mode information is entirely up to
the server implementation. For example, the referral's stat
information could be maintained in a distributed database which can be
accessed from any node in the cluster.

Thanks,
Ashish
>
> --
> Trond Myklebust
> Linux NFS client maintainer, Hammerspace
> trond.myklebust@hammerspace.com
>
>
