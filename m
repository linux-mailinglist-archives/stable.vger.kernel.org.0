Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2AE28FA05
	for <lists+stable@lfdr.de>; Thu, 15 Oct 2020 22:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392193AbgJOUQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Oct 2020 16:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392167AbgJOUPw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Oct 2020 16:15:52 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCDA2C061755;
        Thu, 15 Oct 2020 13:15:51 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id d20so450794iop.10;
        Thu, 15 Oct 2020 13:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dfyv69/hE2Mzt7o+bG8wZqqFOxEL2IQN8/eu8px0Ojo=;
        b=UnU7z8zN8I7e/PcBmEUGsJdUzM/RU/5QTOMTic0lvYx3Y2IeJX7YpMsjavwUnIIZ5Y
         i+oJ5V50TasqbC9+6tLEDFv7bAAH21xIiuc4EAPIlbrydiqOIPaksnoQzUs/gdW7RLur
         ssLdMCWevJStzWRFU31HCFgwC2CLkmWRCYnj1T4MP+j1nevW0AbmVkpOAORS4qC7cMOh
         twztkOChWdT1OE8ZGI08KHqCjlVdLsy0xknAMeovFeZND5bFFdmGOXRC0kVtoIv0GzkA
         m8SC7NSYHlHNwYF+lYHbAnEp+byOqydbXmhjmoV/cjfG4Is2EkPZPxSkb6zLTnNpMRcI
         XINw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dfyv69/hE2Mzt7o+bG8wZqqFOxEL2IQN8/eu8px0Ojo=;
        b=R2MPevaC+U44RgNs71BYKLyxzmDji8K/u09i/H7LbMbRhwknlRQNxxEKW/b/daCs97
         0N2oh/LYU81kcMLgHy8ZkqgkAbVJv/pRubhlK5A78RDV5mIUHNPjhePXExXY5G9IpjL2
         tIgkt+L5EabLZYLdE6P9H5HbYH+SjF4Ws23Z4S+ce+d5dNA5CuJGnRg8MMNa1y4zvM80
         HgVrb3az5IFFZqi+kEsrt2TllJPHxAJDj9WzPU9jOCTmeYSGDRNv18Wu9vdcoOXa/gNe
         wQvDjtJ8FlN9WlOl3GXXoC8pjb+w4P1ae5uV9XaC83GneuqRT80D2dKblx5qgOb2WroS
         Js1Q==
X-Gm-Message-State: AOAM531SNch/oVTSU7DB87clXp1nwejM6BSnLijU64d02ABCl7QZvuSE
        IP479EJWZuJJwtVw4LtBCwHU0EzySDCAOD66IxtGlaVF2ec=
X-Google-Smtp-Source: ABdhPJyrEWlqJ+9vVf7Tix+AU8fXggw6isDMRnw0pm7nM6ZVPfw60OH6FozxsPWpW9y+IFr+1dXCVNnS44P1yG20w7w=
X-Received: by 2002:a05:6638:dcc:: with SMTP id m12mr110957jaj.30.1602792950874;
 Thu, 15 Oct 2020 13:15:50 -0700 (PDT)
MIME-Version: 1.0
References: <20201006151456.20875-1-ashishsangwan2@gmail.com>
 <2d1ff3421a88ece2f1b7708cdbc9d34b00ad3e81.camel@hammerspace.com>
 <CAOiN93mh-ssTDuN1fAptECqc5JpUHtK=1V56jY_0MtWEcT=U2Q@mail.gmail.com>
 <622f03cd08acd861a5155a181191e9ce399bbb37.camel@hammerspace.com>
 <D4D63EB4-DA04-4AAA-8A39-91987AF90E9C@oracle.com> <a998d760a52f5a86343d608e34802c41977442f7.camel@hammerspace.com>
 <C0A500CC-E132-4E77-822C-60AE13504289@oracle.com>
In-Reply-To: <C0A500CC-E132-4E77-822C-60AE13504289@oracle.com>
From:   Ashish Sangwan <ashishsangwan2@gmail.com>
Date:   Fri, 16 Oct 2020 01:45:39 +0530
Message-ID: <CAOiN93kC-8S7auLpLMOoHCPXDuaoA3Uf9Lhfy7uoFi3=qurS9w@mail.gmail.com>
Subject: Re: [PATCH] NFS: Fix mode bits and nlink count for v4 referral dirs
To:     Chuck Lever <chuck.lever@oracle.com>
Cc:     Trond Myklebust <trondmy@hammerspace.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 15, 2020 at 7:38 PM Chuck Lever <chuck.lever@oracle.com> wrote:
>
>
>
> > On Oct 15, 2020, at 9:59 AM, Trond Myklebust <trondmy@hammerspace.com> wrote:
> >
> > On Thu, 2020-10-15 at 09:36 -0400, Chuck Lever wrote:
> >>> On Oct 15, 2020, at 8:06 AM, Trond Myklebust <
> >>> trondmy@hammerspace.com> wrote:
> >>>
> >>> On Thu, 2020-10-15 at 00:39 +0530, Ashish Sangwan wrote:
> >>>> On Wed, Oct 14, 2020 at 11:47 PM Trond Myklebust
> >>>> <trondmy@hammerspace.com> wrote:
> >>>>> On Tue, 2020-10-06 at 08:14 -0700, Ashish Sangwan wrote:
> >>>>>> Request for mode bits and nlink count in the
> >>>>>> nfs4_get_referral
> >>>>>> call
> >>>>>> and if server returns them use them instead of hard coded
> >>>>>> values.
> >>>>>>
> >>>>>> CC: stable@vger.kernel.org
> >>>>>> Signed-off-by: Ashish Sangwan <ashishsangwan2@gmail.com>
> >>>>>> ---
> >>>>>> fs/nfs/nfs4proc.c | 20 +++++++++++++++++---
> >>>>>> 1 file changed, 17 insertions(+), 3 deletions(-)
> >>>>>>
> >>>>>> diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
> >>>>>> index 6e95c85fe395..efec05c5f535 100644
> >>>>>> --- a/fs/nfs/nfs4proc.c
> >>>>>> +++ b/fs/nfs/nfs4proc.c
> >>>>>> @@ -266,7 +266,9 @@ const u32 nfs4_fs_locations_bitmap[3] = {
> >>>>>>     | FATTR4_WORD0_FSID
> >>>>>>     | FATTR4_WORD0_FILEID
> >>>>>>     | FATTR4_WORD0_FS_LOCATIONS,
> >>>>>> -     FATTR4_WORD1_OWNER
> >>>>>> +     FATTR4_WORD1_MODE
> >>>>>> +     | FATTR4_WORD1_NUMLINKS
> >>>>>> +     | FATTR4_WORD1_OWNER
> >>>>>>     | FATTR4_WORD1_OWNER_GROUP
> >>>>>>     | FATTR4_WORD1_RAWDEV
> >>>>>>     | FATTR4_WORD1_SPACE_USED
> >>>>>> @@ -7594,16 +7596,28 @@ nfs4_listxattr_nfs4_user(struct inode
> >>>>>> *inode,
> >>>>>> char *list, size_t list_len)
> >>>>>> */
> >>>>>> static void nfs_fixup_referral_attributes(struct nfs_fattr
> >>>>>> *fattr)
> >>>>>> {
> >>>>>> +     bool fix_mode = true, fix_nlink = true;
> >>>>>> +
> >>>>>>     if (!(((fattr->valid & NFS_ATTR_FATTR_MOUNTED_ON_FILEID)
> >>>>>> ||
> >>>>>>            (fattr->valid & NFS_ATTR_FATTR_FILEID)) &&
> >>>>>>           (fattr->valid & NFS_ATTR_FATTR_FSID) &&
> >>>>>>           (fattr->valid & NFS_ATTR_FATTR_V4_LOCATIONS)))
> >>>>>>             return;
> >>>>>>
> >>>>>> +     if (fattr->valid & NFS_ATTR_FATTR_MODE)
> >>>>>> +             fix_mode = false;
> >>>>>> +     if (fattr->valid & NFS_ATTR_FATTR_NLINK)
> >>>>>> +             fix_nlink = false;
> >>>>>>     fattr->valid |= NFS_ATTR_FATTR_TYPE |
> >>>>>> NFS_ATTR_FATTR_MODE |
> >>>>>>             NFS_ATTR_FATTR_NLINK |
> >>>>>> NFS_ATTR_FATTR_V4_REFERRAL;
> >>>>>> -     fattr->mode = S_IFDIR | S_IRUGO | S_IXUGO;
> >>>>>> -     fattr->nlink = 2;
> >>>>>> +
> >>>>>> +     if (fix_mode)
> >>>>>> +             fattr->mode = S_IFDIR | S_IRUGO | S_IXUGO;
> >>>>>> +     else
> >>>>>> +             fattr->mode |= S_IFDIR;
> >>>>>> +
> >>>>>> +     if (fix_nlink)
> >>>>>> +             fattr->nlink = 2;
> >>>>>> }
> >>>>>>
> >>>>>> static int _nfs4_proc_fs_locations(struct rpc_clnt *client,
> >>>>>> struct
> >>>>>> inode *dir,
> >>>>>
> >>>>> NACK to this patch. The whole point is that if the server has a
> >>>>> referral, then it is not going to give us any attributes other
> >>>>> than
> >>>>> the
> >>>>> ones we're already asking for because it may not even have a
> >>>>> real
> >>>>> directory. The client is required to fake up an inode, hence
> >>>>> the
> >>>>> existing code.
> >>>>
> >>>> Hi Trond, thanks for reviewing the patch!
> >>>> Sorry but I didn't understand the reason to NACK it. Could you
> >>>> please
> >>>> elaborate your concern?
> >>>> These are the current attributes we request from the server on a
> >>>> referral:
> >>>> FATTR4_WORD0_CHANGE
> >>>>> FATTR4_WORD0_SIZE
> >>>>> FATTR4_WORD0_FSID
> >>>>> FATTR4_WORD0_FILEID
> >>>>> FATTR4_WORD0_FS_LOCATIONS,
> >>>> FATTR4_WORD1_OWNER
> >>>>> FATTR4_WORD1_OWNER_GROUP
> >>>>> FATTR4_WORD1_RAWDEV
> >>>>> FATTR4_WORD1_SPACE_USED
> >>>>> FATTR4_WORD1_TIME_ACCESS
> >>>>> FATTR4_WORD1_TIME_METADATA
> >>>>> FATTR4_WORD1_TIME_MODIFY
> >>>>> FATTR4_WORD1_MOUNTED_ON_FILEID,
> >>>>
> >>>> So you are suggesting that it's ok to ask for SIZE, OWNER, OWNER
> >>>> GROUP, SPACE USED, TIMESTAMPs etc but not ok to ask for mode bits
> >>>> and
> >>>> numlinks?
> >>>
> >>> No. We shouldn't be asking for any of that information for a
> >>> referral
> >>> because the server isn't supposed to return any values for it.
> >>>
> >>> Chuck and Anna, what's the deal with commit c05cefcc7241? That
> >>> appears
> >>> to have changed the original code to speculatively assume that the
> >>> server will violate RFC5661 Section 11.3.1 and/or RFC7530 Section
> >>> 8.3.1.
> >>
> >> The commit is an attempt to address the many complaints we've had
> >> about the ugly appearance of referral anchors. The strange "special"
> >> default values made the client appear to be broken, and was confusing
> >> to some. I consider this to be a UX issue: the information displayed
> >> in this case is not meant to be factual, but rather to prevent the
> >> user concluding that something is wrong.
> >>
> >> I'm not attached to this particular solution, though. Does it make
> >> sense to perform the referral mount before returning "ls" results
> >> so that the target server has a chance to supply reasonable
> >> attribute values for the mounted-on directory object? Just spit
> >> balling here.
> >>
> >>
> >>> Specifically, the paragraph that says:
> >>>
> >>> "
> >>>  Other attributes SHOULD NOT be made available for absent file
> >>>  systems, even when it is possible to provide them.  The server
> >>> should
> >>>  not assume that more information is always better and should
> >>> avoid
> >>>  gratuitously providing additional information."
> >>>
> >>> So why is the client asking for them?
> >>
> >> This paragraph (and it's most modern incarnation in RFC 8881 Section
> >> 11.4.1) describes server behavior. The current client behavior is
> >> spec-compliant because there is no explicit prohibition in the spec
> >> language against a client requesting additional attributes in this
> >> case.
> >>
> >> Either the server can clear those bitmap flags on the GETATTR reply
> >> and not supply those attributes, and clients must be prepared for
> >> that.
> >>
> >> Or, it's also possible to read this paragraph to mean that the
> >> server can provide those attributes and the values should not
> >> reflect attributes for the absent file system, but rather something
> >> else (eg, server-manufactured defaults, or the attributes from the
> >> object on the source server).
> >>
> >> And since this is a SHOULD NOT rather than a MUST NOT, servers are
> >> still free to return information about the absent file system.
> >> Clients are not guaranteed this will be the case, however.
> >>
> >> I don't think c05cefcc7241 makes any assumption about whether the
> >> server is lying about the extra attributes. Perhaps the server has
> >> no better values for these attributes than the client's defaults
> >> were.
> >>
> >
> > SHOULD / SHOULD NOT indicates actions that the server is required to
> > take in the absence of a very good reason to do otherwise. In other
> > words, the client should expect the majority of servers to behave in a
> > certain manner.
> >
> > It doesn't matter that the client's behaviour is spec compliant. We're
> > asking for information that is not supposed to be divulged by the
> > majority of servers, Furthermore, that information is, quite frankly,
> > utterly irrelevant to the client and application running on it. Any
> > attempt to access that fake object will result in a submount of
> > something completely different on top of that object.
> >
> > IOW: the only difference here is you're asking that the server provide
> > us with a faked up object (which it is not supposed to do), whereas
> > previously, we were faking that object up ourselves. What's the big
> > deal here?
>
> Right, that boils it down nicely.
>
> The difference has been that by and large the server-provided values
> don't look broken to users. Perhaps all we need to do is select better
> defaults for these attributes on Linux clients. I haven't followed
> Ashish's requirements, so I can't speak to them.
>

The current patch only intended to fix the UX issue, it has no
practical purpose.
If it's breaking the RFC then I agree that the patch should not be included.
Thanks a lot to both of you for explaining the issue in detail!

> Here is some history.
>
> https://lore.kernel.org/linux-nfs/CAD8zhTAAvTKhp6k0vYRMnhZW5pxjstpBiDKLgoXocfpAXNjKTg@mail.gmail.com/
>
>
> --
> Chuck Lever
>
>
>
