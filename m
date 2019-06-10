Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6F043BF70
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 00:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389473AbfFJWXJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 18:23:09 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:44379 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388842AbfFJWXJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jun 2019 18:23:09 -0400
Received: by mail-lj1-f195.google.com with SMTP id k18so9502539ljc.11;
        Mon, 10 Jun 2019 15:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=senz/+n1pdIJGDBZ6seAzl1eLg60yrspw4TyLUY055Q=;
        b=g1o/iekjlTLzNYvLjKUODEDGebnF1JgJb1+0u3N9ZqHHvaZUgXV89QPn/sLGRfV+59
         HYhuAyMXvBoUq2dksqh0Umm8XJhKY/S/oAxW+b+2TwFh2oORW+kv6w5YbCdU6+8UQ69a
         QsEvNvLjzUjU/eQ4hfl+2EH/LWmTJCJxuDtCzIrzFRINVoMBkP0QCcH1m0iKCxeHynE6
         K4ROwh6k58Jh3ybLfBeDJBMUhwwXkguB1mCLqHjbUFsNyg/0taXG3j47qWkpP96yTbK0
         fyByoXW4eLHKXTWyH0CgTqQoQxPlaSELbMn1cjeVukePbOgFaFg61b/rYnOxP3V343n0
         CGMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=senz/+n1pdIJGDBZ6seAzl1eLg60yrspw4TyLUY055Q=;
        b=G3Mboz7c9ncAgu+V4ndhi7xKIPVDgtlxul11VIHeqHwYFUDvbCr9Wkg9l9pQWlImhc
         LrVIyakScVaEz05YYU7PGHJBwllALi3LCmCWzDUKli4ivai+YbHam0/GyGLRIE5varGO
         9N2AmsFq944S1qdjpR2wy1ackHHpqRVT87ctvBpyacNnw7iJ0vdFrqv50J+AMPKPIF63
         zPaKS0+F4y2KpqwwECrTvLWm2J0JBeLp9tION4XIAR5+wzjwcl/cB6uJ7uzmGGVi5zfQ
         qy+zz5aq7uS1wYBVp/F41VwOzN0NlzIPBm2kxMecodyni2iRvZG3Ty8L/6c6/JpBkWff
         acWA==
X-Gm-Message-State: APjAAAUkmGyop+iiLn5M744B56u2mJMC+sfikTIaRrECVi1mKC2qv2tr
        E4he6npaPLr9Qtnnch+b2wShN7SyB+OH30fcSw==
X-Google-Smtp-Source: APXvYqzYrd53pIEat2s2sfu4AQe45oH3bavA7N0NOCKrvFxQocw18oSO2GflXrhwZGcYih1oltm0x9XX1uNLOMgIYWM=
X-Received: by 2002:a2e:9cc3:: with SMTP id g3mr22189795ljj.117.1560205386195;
 Mon, 10 Jun 2019 15:23:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190605003838.13101-1-lsahlber@redhat.com> <CAKywueRYC2dm83zWCgrOVJc7J5s+UdMh-5NnF0sUOJ69NQ3qvQ@mail.gmail.com>
 <CAH2r5mtgUQz5A3xmVMWr=1O5aerzSFSOL05Ay0y1U711OzdeVw@mail.gmail.com>
In-Reply-To: <CAH2r5mtgUQz5A3xmVMWr=1O5aerzSFSOL05Ay0y1U711OzdeVw@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 10 Jun 2019 15:22:55 -0700
Message-ID: <CAKywueRakAtz8v51Uqqw7z0oxovprBbqiUEczS-tJ_92xkj0QA@mail.gmail.com>
Subject: Re: [PATCH] cifs: add spinlock for the openFileList to cifsInodeInfo
To:     Steve French <smfrench@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Looks good, thanks!

--
Best regards,
Pavel Shilovsky

=D0=BF=D0=BD, 10 =D0=B8=D1=8E=D0=BD. 2019 =D0=B3. =D0=B2 15:20, Steve Frenc=
h <smfrench@gmail.com>:
>
> Adding a comment as requested and also mention of the new spinlock in
> the list of locks and their purpose in cifsglob.h (then squashed that
> change into Ronnie's commit and added your Reviewed-by - see attached)
>
> On Mon, Jun 10, 2019 at 4:36 PM Pavel Shilovsky <piastryyy@gmail.com> wro=
te:
> >
> > =D0=B2=D1=82, 4 =D0=B8=D1=8E=D0=BD. 2019 =D0=B3. =D0=B2 17:42, Ronnie S=
ahlberg <lsahlber@redhat.com>:
> > >
> > > We can not depend on the tcon->open_file_lock here since in multiuser=
 mode
> > > we may have the same file/inode open via multiple different tcons.
> > >
> > > The current code is race prone and will crash if one user deletes a f=
ile
> > > at the same time a different user opens/create the file.
> > >
> > > To avoid this we need to have a spinlock attached to the inode and no=
t the tcon.
> > >
> > > RHBZ:  1580165
> > >
> > > CC: Stable <stable@vger.kernel.org>
> > > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > > ---
> > >  fs/cifs/cifsfs.c   | 1 +
> > >  fs/cifs/cifsglob.h | 1 +
> > >  fs/cifs/file.c     | 8 ++++++--
> > >  3 files changed, 8 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> > > index f5fcd6360056..65d9771e49f9 100644
> > > --- a/fs/cifs/cifsfs.c
> > > +++ b/fs/cifs/cifsfs.c
> > > @@ -303,6 +303,7 @@ cifs_alloc_inode(struct super_block *sb)
> > >         cifs_inode->uniqueid =3D 0;
> > >         cifs_inode->createtime =3D 0;
> > >         cifs_inode->epoch =3D 0;
> > > +       spin_lock_init(&cifs_inode->open_file_lock);
> > >         generate_random_uuid(cifs_inode->lease_key);
> > >
> > >         /*
> > > diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> > > index 334ff5f9c3f3..733ddd5fd480 100644
> > > --- a/fs/cifs/cifsglob.h
> > > +++ b/fs/cifs/cifsglob.h
> > > @@ -1377,6 +1377,7 @@ struct cifsInodeInfo {
> > >         struct rw_semaphore lock_sem;   /* protect the fields above *=
/
> > >         /* BB add in lists for dirty pages i.e. write caching info fo=
r oplock */
> > >         struct list_head openFileList;
> > > +       spinlock_t      open_file_lock; /* protects openFileList */
> > >         __u32 cifsAttrs; /* e.g. DOS archive bit, sparse, compressed,=
 system */
> > >         unsigned int oplock;            /* oplock/lease level we have=
 */
> > >         unsigned int epoch;             /* used to track lease state =
changes */
> > > diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> > > index 06e27ac6d82c..97090693d182 100644
> > > --- a/fs/cifs/file.c
> > > +++ b/fs/cifs/file.c
> > > @@ -338,10 +338,12 @@ cifs_new_fileinfo(struct cifs_fid *fid, struct =
file *file,
> > >         atomic_inc(&tcon->num_local_opens);
> > >
> > >         /* if readable file instance put first in list*/
> > > +       spin_lock(&cinode->open_file_lock);
> > >         if (file->f_mode & FMODE_READ)
> > >                 list_add(&cfile->flist, &cinode->openFileList);
> > >         else
> > >                 list_add_tail(&cfile->flist, &cinode->openFileList);
> > > +       spin_unlock(&cinode->open_file_lock);
> > >         spin_unlock(&tcon->open_file_lock);
> > >
> > >         if (fid->purge_cache)
> > > @@ -413,7 +415,9 @@ void _cifsFileInfo_put(struct cifsFileInfo *cifs_=
file, bool wait_oplock_handler)
> > >         cifs_add_pending_open_locked(&fid, cifs_file->tlink, &open);
> > >
> > >         /* remove it from the lists */
> > > +       spin_lock(&cifsi->open_file_lock);
> > >         list_del(&cifs_file->flist);
> > > +       spin_unlock(&cifsi->open_file_lock);
> > >         list_del(&cifs_file->tlist);
> > >         atomic_dec(&tcon->num_local_opens);
> > >
> > > @@ -1950,9 +1954,9 @@ cifs_get_writable_file(struct cifsInodeInfo *ci=
fs_inode, bool fsuid_only,
> > >                         return 0;
> > >                 }
> > >
> > > -               spin_lock(&tcon->open_file_lock);
> > > +               spin_lock(&cifs_inode->open_file_lock);
> > >                 list_move_tail(&inv_file->flist, &cifs_inode->openFil=
eList);
> > > -               spin_unlock(&tcon->open_file_lock);
> > > +               spin_unlock(&cifs_inode->open_file_lock);
> > >                 cifsFileInfo_put(inv_file);
> > >                 ++refind;
> > >                 inv_file =3D NULL;
> > > --
> > > 2.13.6
> > >
> >
> > Thanks for the patch. Looks good to me.
> >
> > Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
> >
> > I would only add a comment telling what an order of the locks should
> > be: cifs_tcon.open_file_lock and then cifsInodeInfo.open_file_lock.
> >
> > --
> > Best regards,
> > Pavel Shilovsky
>
>
>
> --
> Thanks,
>
> Steve
