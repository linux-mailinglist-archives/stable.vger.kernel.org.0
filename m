Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 904C7647DA3
	for <lists+stable@lfdr.de>; Fri,  9 Dec 2022 07:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbiLIGPk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Dec 2022 01:15:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbiLIGPh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Dec 2022 01:15:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F05C0944D9
        for <stable@vger.kernel.org>; Thu,  8 Dec 2022 22:14:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670566479;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oa54uyNCuc6sqK0yQg3scWubqpM185gDaVlb7eqVoYA=;
        b=X5+4o7bvqczkJWnnhGQzH1fA58MM2l8ax9fB+xvXbiMtkKY8SBfjS7nKfpOav/Fr42I3j/
        n7e8+lKabYGFQdG7pnhwxAdU8z/Mhuuppsfdgc5BKVbt87tRIamo/cQ6ReR648zOPerUit
        zt0utnJ2ec2ztK5zdtaW7BNmMRrmONU=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-551-klaesrl-P7OttnWng0FgHg-1; Fri, 09 Dec 2022 01:14:37 -0500
X-MC-Unique: klaesrl-P7OttnWng0FgHg-1
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-3b4eb124be5so39491477b3.19
        for <stable@vger.kernel.org>; Thu, 08 Dec 2022 22:14:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oa54uyNCuc6sqK0yQg3scWubqpM185gDaVlb7eqVoYA=;
        b=t8tpUD0kT91SNKnNz1dmN5OZx9XVIBGhrZCMLXJbcrbr2X8VOrKIIQJ+4bMvJgr4W1
         lys/53ytOEOrVswCKa+5mGuf7zAEYVvllDkXYGTT8aLa7idkN2qzxBvNlD/n7qCeL+TV
         sHuoaUTcfxdO5ifADKsGdEJjQQyz7HGucfYN55xdYxi1uoYlX46zV6ztAoCuionE39zM
         XE4uSnfVrfcVPdYAoBrzXE8XftK0gWOjZI9XsbjLLsWZZgbXz5r6RVbiPZWyK0N3EKL5
         LUx/umm0LAd8mQ7rQqVxf51lokQMXrttgWDxsbOkq22gUR8wf20umirDYV8+ri98R4hp
         eCFA==
X-Gm-Message-State: ANoB5pmZBlJwARHU2w0/LuyJPN7GNCXswm3Pv4dNYaWrm2zlZMdP9+OZ
        M91Qd5JLRJH/Jo/LyTPnKAyrPSLLhzcKR79xoxMEOp0zPfvkTDZhesd8NFE27nE6HjhvihHf6bs
        0MzXmhHGZXFIUQLLNp8LDN0TLQFUFxIcs
X-Received: by 2002:a81:8383:0:b0:370:4b5e:cb52 with SMTP id t125-20020a818383000000b003704b5ecb52mr25123373ywf.157.1670566477180;
        Thu, 08 Dec 2022 22:14:37 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7tT2HZno8R7zSHtkyQuUh85wtOcuAiQFhwx2XTVM+Gib57L5SIIohFqWYMUoIRTUKld137J/QpWKFiSfhxO4s=
X-Received: by 2002:a81:8383:0:b0:370:4b5e:cb52 with SMTP id
 t125-20020a818383000000b003704b5ecb52mr25123366ywf.157.1670566476861; Thu, 08
 Dec 2022 22:14:36 -0800 (PST)
MIME-Version: 1.0
References: <20221206125915.37404-1-xiubli@redhat.com> <CAOi1vP8hkXZ7w9D5LnMViyjqVCmsKo3H2dg1QpzgHCPuNfvACQ@mail.gmail.com>
 <baa681e9-4472-bcfb-601f-132dc6658888@redhat.com> <ac1e95e6-f8fa-e243-97bd-a280b8e0fa66@redhat.com>
 <CAOi1vP_=2wOSYmrzfdm3k__dVONjXspjV15gbZ+Yq247xmpnXQ@mail.gmail.com> <d8a35b3a-e0b9-8ee8-9b0e-dc77ddc9c312@redhat.com>
In-Reply-To: <d8a35b3a-e0b9-8ee8-9b0e-dc77ddc9c312@redhat.com>
From:   Venky Shankar <vshankar@redhat.com>
Date:   Fri, 9 Dec 2022 11:44:00 +0530
Message-ID: <CACPzV1k=L0GyhK5c0Jgce=s02wqxa20qMuTzHhZvJB6cgnSQcw@mail.gmail.com>
Subject: Re: [PATCH v3] ceph: blocklist the kclient when receiving corrupted
 snap trace
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        jlayton@kernel.org, mchangir@redhat.com, atomlin@atomlin.com,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 8, 2022 at 6:10 AM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 07/12/2022 22:20, Ilya Dryomov wrote:
> > On Wed, Dec 7, 2022 at 2:31 PM Xiubo Li <xiubli@redhat.com> wrote:
> >>
> >> On 07/12/2022 21:19, Xiubo Li wrote:
> >>> On 07/12/2022 18:59, Ilya Dryomov wrote:
> >>>> On Tue, Dec 6, 2022 at 1:59 PM <xiubli@redhat.com> wrote:
> >>>>> From: Xiubo Li <xiubli@redhat.com>
> >>>>>
> >>>>> When received corrupted snap trace we don't know what exactly has
> >>>>> happened in MDS side. And we shouldn't continue writing to OSD,
> >>>>> which may corrupt the snapshot contents.
> >>>>>
> >>>>> Just try to blocklist this client and If fails we need to crash the
> >>>>> client instead of leaving it writeable to OSDs.
> >>>>>
> >>>>> Cc: stable@vger.kernel.org
> >>>>> URL: https://tracker.ceph.com/issues/57686
> >>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> >>>>> ---
> >>>>>
> >>>>> Thanks Aaron's feedback.
> >>>>>
> >>>>> V3:
> >>>>> - Fixed ERROR: spaces required around that ':' (ctx:VxW)
> >>>>>
> >>>>> V2:
> >>>>> - Switched to WARN() to taint the Linux kernel.
> >>>>>
> >>>>>    fs/ceph/mds_client.c |  3 ++-
> >>>>>    fs/ceph/mds_client.h |  1 +
> >>>>>    fs/ceph/snap.c       | 25 +++++++++++++++++++++++++
> >>>>>    3 files changed, 28 insertions(+), 1 deletion(-)
> >>>>>
> >>>>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> >>>>> index cbbaf334b6b8..59094944af28 100644
> >>>>> --- a/fs/ceph/mds_client.c
> >>>>> +++ b/fs/ceph/mds_client.c
> >>>>> @@ -5648,7 +5648,8 @@ static void mds_peer_reset(struct
> >>>>> ceph_connection *con)
> >>>>>           struct ceph_mds_client *mdsc = s->s_mdsc;
> >>>>>
> >>>>>           pr_warn("mds%d closed our session\n", s->s_mds);
> >>>>> -       send_mds_reconnect(mdsc, s);
> >>>>> +       if (!mdsc->no_reconnect)
> >>>>> +               send_mds_reconnect(mdsc, s);
> >>>>>    }
> >>>>>
> >>>>>    static void mds_dispatch(struct ceph_connection *con, struct
> >>>>> ceph_msg *msg)
> >>>>> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> >>>>> index 728b7d72bf76..8e8f0447c0ad 100644
> >>>>> --- a/fs/ceph/mds_client.h
> >>>>> +++ b/fs/ceph/mds_client.h
> >>>>> @@ -413,6 +413,7 @@ struct ceph_mds_client {
> >>>>>           atomic_t                num_sessions;
> >>>>>           int                     max_sessions;  /* len of sessions
> >>>>> array */
> >>>>>           int                     stopping;      /* true if shutting
> >>>>> down */
> >>>>> +       int                     no_reconnect;  /* true if snap trace
> >>>>> is corrupted */
> >>>>>
> >>>>>           atomic64_t              quotarealms_count; /* # realms with
> >>>>> quota */
> >>>>>           /*
> >>>>> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> >>>>> index c1c452afa84d..023852b7c527 100644
> >>>>> --- a/fs/ceph/snap.c
> >>>>> +++ b/fs/ceph/snap.c
> >>>>> @@ -767,8 +767,10 @@ int ceph_update_snap_trace(struct
> >>>>> ceph_mds_client *mdsc,
> >>>>>           struct ceph_snap_realm *realm;
> >>>>>           struct ceph_snap_realm *first_realm = NULL;
> >>>>>           struct ceph_snap_realm *realm_to_rebuild = NULL;
> >>>>> +       struct ceph_client *client = mdsc->fsc->client;
> >>>>>           int rebuild_snapcs;
> >>>>>           int err = -ENOMEM;
> >>>>> +       int ret;
> >>>>>           LIST_HEAD(dirty_realms);
> >>>>>
> >>>>>           lockdep_assert_held_write(&mdsc->snap_rwsem);
> >>>>> @@ -885,6 +887,29 @@ int ceph_update_snap_trace(struct
> >>>>> ceph_mds_client *mdsc,
> >>>>>           if (first_realm)
> >>>>>                   ceph_put_snap_realm(mdsc, first_realm);
> >>>>>           pr_err("%s error %d\n", __func__, err);
> >>>>> +
> >>>>> +       /*
> >>>>> +        * When receiving a corrupted snap trace we don't know what
> >>>>> +        * exactly has happened in MDS side. And we shouldn't continue
> >>>>> +        * writing to OSD, which may corrupt the snapshot contents.
> >>>>> +        *
> >>>>> +        * Just try to blocklist this kclient and if it fails we need
> >>>>> +        * to crash the kclient instead of leaving it writeable.
> >>>> Hi Xiubo,
> >>>>
> >>>> I'm not sure I understand this "let's blocklist ourselves" concept.
> >>>> If the kernel client shouldn't continue writing to OSDs in this case,
> >>>> why not just stop issuing writes -- perhaps initiating some equivalent
> >>>> of a read-only remount like many local filesystems would do on I/O
> >>>> errors (e.g. errors=remount-ro mode)?
> >>> The following patch seems working. Let me do more test to make sure
> >>> there is not further crash.
> >>>
> >>> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> >>> index c1c452afa84d..cd487f8a4cb5 100644
> >>> --- a/fs/ceph/snap.c
> >>> +++ b/fs/ceph/snap.c
> >>> @@ -767,6 +767,7 @@ int ceph_update_snap_trace(struct ceph_mds_client
> >>> *mdsc,
> >>>          struct ceph_snap_realm *realm;
> >>>          struct ceph_snap_realm *first_realm = NULL;
> >>>          struct ceph_snap_realm *realm_to_rebuild = NULL;
> >>> +       struct super_block *sb = mdsc->fsc->sb;
> >>>          int rebuild_snapcs;
> >>>          int err = -ENOMEM;
> >>>          LIST_HEAD(dirty_realms);
> >>> @@ -885,6 +886,9 @@ int ceph_update_snap_trace(struct ceph_mds_client
> >>> *mdsc,
> >>>          if (first_realm)
> >>>                  ceph_put_snap_realm(mdsc, first_realm);
> >>>          pr_err("%s error %d\n", __func__, err);
> >>> +       pr_err("Remounting filesystem read-only\n");
> >>> +       sb->s_flags |= SB_RDONLY;
> >>> +
> >>>          return err;
> >>>   }
> >>>
> >>>
> >> For readonly approach is also my first thought it should be, but I was
> >> just not very sure whether it would be the best approach.
> >>
> >> Because by evicting the kclient we could prevent the buffer to be wrote
> >> to OSDs. But the readonly one seems won't ?
> > The read-only setting is more for the VFS and the user.  Technically,
> > the kernel client could just stop issuing writes (i.e. OSD requests
> > containing a write op) and not set SB_RDONLY.  That should cover any
> > buffered data as well.
>
>  From reading the local exit4 and other fs, they all doing it this way
> and the VFS will help stop further writing. Tested the above patch and
> it worked as expected.
>
> I think to stop the following OSD requests we can just check the
> SB_RDONLY flag to prevent the buffer writeback.
>
> > By employing self-blocklisting, you are shifting the responsibility
> > of rejecting OSD requests to the OSDs.  I'm saying that not issuing
> > OSD requests from a potentially busted client in the first place is
> > probably a better idea.  At the very least you wouldn't need to BUG
> > on ceph_monc_blocklist_add() errors.
>
> I found an issue for the read-only approach:
>
> In read-only mode it still can access to the MDSs and OSDs, which will
> continue trying to update the snap realms with the corrupted snap trace
> as before when reading. What if users try to read or backup the
> snapshots by using the corrupted snap realms ?
>
> Isn't that a problem ?

Yeh - this might end up in more problems in various places than what
this change is supposed to handle.

Maybe we could track affected realms (although, not that granular) and
disallow reads to them (and its children), but I think it might not be
worth putting in the effort.

>
> Thanks
>
> - Xiubo
>
> > Thanks,
> >
> >                  Ilya
> >
>


-- 
Cheers,
Venky

