Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 803406481AF
	for <lists+stable@lfdr.de>; Fri,  9 Dec 2022 12:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbiLIL3X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Dec 2022 06:29:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbiLIL2v (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Dec 2022 06:28:51 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 364FC75BCA;
        Fri,  9 Dec 2022 03:28:39 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id qk9so10819481ejc.3;
        Fri, 09 Dec 2022 03:28:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1H4IZQxMs75MF8aKitF4aBg/D3MV3uprR2gFWGqerLY=;
        b=lB65L1HKDFJJGy5LhRpl8Sugksc3qk86zveVtzbJvNqfqFn1qBB2J+me8uGx8dKfpd
         BvmrImcYUmrvN/6+DjVNyF/xIOnQrERdjQwZ873cuFQLlILjl1BpIhjd2bKJmZJTUekj
         i8+QK7lyYpht4iY07mTDfpmfDhIPkfWTLsyvkVU05leDT8hrezZlyO9ZPFP6l8wviLwQ
         Oeu3H/uuNhBfRRG5/k54L+rqhG6+XfzanhXoD3KZ/F6kgC0Ery5FtovguaD1DLwTMUCw
         6jHbIJwJa715Ln2hR4+dHpuKYm/gvUWkNZjQUlMI5TxplGRyhpRMekrHDOfSR1Ui3UWK
         kooQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1H4IZQxMs75MF8aKitF4aBg/D3MV3uprR2gFWGqerLY=;
        b=JjxD6vmWNL4AOpGTlNYdxThu+PpAB2GN6q8YCg3QVPrZgfP1GRT3mG2/HZkLC86IXk
         MXvICCbw2LL3aaFdLnFaUhbXs+gPtXLNrGZV7sAbxs/r3b65go4NoZWIvxegNdXIMkfu
         afDnnjfsGqCia+bNKmTep2LiqaQgeZFiQ0cF7nOBur3IOq+SueshMzIy1ibaGWeOlqi+
         f1MHSReZx1DT67SVaRPDH29UIuNNaqGwKHz29NnbE2MEPHjGlQuoIRmutV98gq+Eht9D
         pBqkj+3UNVJWr5YfBZ1KFcb6yibCYmyVawVE3o9UKnS1EcUyBoavIDyDQVelZ+QLHTRV
         ZdjQ==
X-Gm-Message-State: ANoB5plARFndyozgbJ09vAXnitOcfBqMqx+uippiGqlzk3Q3hqeGLeso
        OgBqGmMLhHEYaW7fMKGHA9qnL8wY0JD2aOwSAxweEkt4krg=
X-Google-Smtp-Source: AA0mqf5qpbr3dYc7RP9dZplQTSXizcU6RHF+0KxlwH7loUhQgl4SLjNaMWHHwbx53MIV2ww4Di5aaW0GlR2FPhZD1hc=
X-Received: by 2002:a17:906:901:b0:7ae:23c:3cb4 with SMTP id
 i1-20020a170906090100b007ae023c3cb4mr35446010ejd.599.1670585317537; Fri, 09
 Dec 2022 03:28:37 -0800 (PST)
MIME-Version: 1.0
References: <20221206125915.37404-1-xiubli@redhat.com> <CAOi1vP8hkXZ7w9D5LnMViyjqVCmsKo3H2dg1QpzgHCPuNfvACQ@mail.gmail.com>
 <897fc89b-775f-88ce-1550-90c47220dc18@redhat.com> <CAOi1vP8f_qHpPT05yx2X+dbVb28qq+hkpWP988bVcpabU=b+1Q@mail.gmail.com>
 <6d3bdd08-d091-b20b-95bd-d97c7025d75e@redhat.com>
In-Reply-To: <6d3bdd08-d091-b20b-95bd-d97c7025d75e@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 9 Dec 2022 12:28:25 +0100
Message-ID: <CAOi1vP93tvhSMLpRXmOhH9AeL=LiLZjY10N6DUNhANf6sit9wA@mail.gmail.com>
Subject: Re: [PATCH v3] ceph: blocklist the kclient when receiving corrupted
 snap trace
To:     Xiubo Li <xiubli@redhat.com>
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com, atomlin@atomlin.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 8, 2022 at 2:05 AM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 07/12/2022 22:28, Ilya Dryomov wrote:
> > On Wed, Dec 7, 2022 at 1:35 PM Xiubo Li <xiubli@redhat.com> wrote:
> >>
> >> On 07/12/2022 18:59, Ilya Dryomov wrote:
> >>> On Tue, Dec 6, 2022 at 1:59 PM <xiubli@redhat.com> wrote:
> >>>> From: Xiubo Li <xiubli@redhat.com>
> >>>>
> >>>> When received corrupted snap trace we don't know what exactly has
> >>>> happened in MDS side. And we shouldn't continue writing to OSD,
> >>>> which may corrupt the snapshot contents.
> >>>>
> >>>> Just try to blocklist this client and If fails we need to crash the
> >>>> client instead of leaving it writeable to OSDs.
> >>>>
> >>>> Cc: stable@vger.kernel.org
> >>>> URL: https://tracker.ceph.com/issues/57686
> >>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> >>>> ---
> >>>>
> >>>> Thanks Aaron's feedback.
> >>>>
> >>>> V3:
> >>>> - Fixed ERROR: spaces required around that ':' (ctx:VxW)
> >>>>
> >>>> V2:
> >>>> - Switched to WARN() to taint the Linux kernel.
> >>>>
> >>>>    fs/ceph/mds_client.c |  3 ++-
> >>>>    fs/ceph/mds_client.h |  1 +
> >>>>    fs/ceph/snap.c       | 25 +++++++++++++++++++++++++
> >>>>    3 files changed, 28 insertions(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> >>>> index cbbaf334b6b8..59094944af28 100644
> >>>> --- a/fs/ceph/mds_client.c
> >>>> +++ b/fs/ceph/mds_client.c
> >>>> @@ -5648,7 +5648,8 @@ static void mds_peer_reset(struct ceph_connection *con)
> >>>>           struct ceph_mds_client *mdsc = s->s_mdsc;
> >>>>
> >>>>           pr_warn("mds%d closed our session\n", s->s_mds);
> >>>> -       send_mds_reconnect(mdsc, s);
> >>>> +       if (!mdsc->no_reconnect)
> >>>> +               send_mds_reconnect(mdsc, s);
> >>>>    }
> >>>>
> >>>>    static void mds_dispatch(struct ceph_connection *con, struct ceph_msg *msg)
> >>>> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> >>>> index 728b7d72bf76..8e8f0447c0ad 100644
> >>>> --- a/fs/ceph/mds_client.h
> >>>> +++ b/fs/ceph/mds_client.h
> >>>> @@ -413,6 +413,7 @@ struct ceph_mds_client {
> >>>>           atomic_t                num_sessions;
> >>>>           int                     max_sessions;  /* len of sessions array */
> >>>>           int                     stopping;      /* true if shutting down */
> >>>> +       int                     no_reconnect;  /* true if snap trace is corrupted */
> >>>>
> >>>>           atomic64_t              quotarealms_count; /* # realms with quota */
> >>>>           /*
> >>>> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> >>>> index c1c452afa84d..023852b7c527 100644
> >>>> --- a/fs/ceph/snap.c
> >>>> +++ b/fs/ceph/snap.c
> >>>> @@ -767,8 +767,10 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
> >>>>           struct ceph_snap_realm *realm;
> >>>>           struct ceph_snap_realm *first_realm = NULL;
> >>>>           struct ceph_snap_realm *realm_to_rebuild = NULL;
> >>>> +       struct ceph_client *client = mdsc->fsc->client;
> >>>>           int rebuild_snapcs;
> >>>>           int err = -ENOMEM;
> >>>> +       int ret;
> >>>>           LIST_HEAD(dirty_realms);
> >>>>
> >>>>           lockdep_assert_held_write(&mdsc->snap_rwsem);
> >>>> @@ -885,6 +887,29 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
> >>>>           if (first_realm)
> >>>>                   ceph_put_snap_realm(mdsc, first_realm);
> >>>>           pr_err("%s error %d\n", __func__, err);
> >>>> +
> >>>> +       /*
> >>>> +        * When receiving a corrupted snap trace we don't know what
> >>>> +        * exactly has happened in MDS side. And we shouldn't continue
> >>>> +        * writing to OSD, which may corrupt the snapshot contents.
> >>>> +        *
> >>>> +        * Just try to blocklist this kclient and if it fails we need
> >>>> +        * to crash the kclient instead of leaving it writeable.
> >>> Hi Xiubo,
> >>>
> >>> I'm not sure I understand this "let's blocklist ourselves" concept.
> >>> If the kernel client shouldn't continue writing to OSDs in this case,
> >>> why not just stop issuing writes -- perhaps initiating some equivalent
> >>> of a read-only remount like many local filesystems would do on I/O
> >>> errors (e.g. errors=remount-ro mode)?
> >> I still haven't found how could I handle it this way from ceph layer. I
> >> saw they are just marking the inodes as EIO when this happens.
> >>
> >>> Or, perhaps, all in-memory snap contexts could somehow be invalidated
> >>> in this case, making writes fail naturally -- on the client side,
> >>> without actually being sent to OSDs just to be nixed by the blocklist
> >>> hammer.
> >>>
> >>> But further, what makes a failure to decode a snap trace special?
> >>   From the known tracker the snapid was corrupted in one inode in MDS and
> >> then when trying to build the snap trace with the corrupted snapid it
> >> will corrupt.
> >>
> >> And also there maybe other cases.
> >>
> >>> AFAIK we don't do anything close to this for any other decoding
> >>> failure.  Wouldn't "when received corrupted XYZ we don't know what
> >>> exactly has happened in MDS side" argument apply to pretty much all
> >>> decoding failures?
> >> The snap trace is different from other cases. The corrupted snap trace
> >> will affect the whole snap realm hierarchy, which will affect the whole
> >> inodes in the mount in worst case.
> >>
> >> This is why I was trying to evict the mount to prevent further IOs.
> > I suspected as much and my other suggestion was to look at somehow
> > invalidating snap contexts/realms.  Perhaps decode out-of-place and on
> > any error set a flag indicating that the snap context can't be trusted
> > anymore?  The OSD client could then check whether this flag is set
> > before admitting the snap context blob into the request message and
> > return an error, effectively rejecting the write.
>
> The snap realms are organize as tree-like hierarchy. When the snap trace
> is corruppted maybe only one of the snap realms are affected and maybe
> several or all. The problem is when decoding the corrupted snap trace we
> couldn't know exactly which realms will be affected. If one realm is
> marked as invalid all the child realms should be affected too.

I realize that ;)  My suggestion (quoted above) was to look into
invalidating all snap realms, not a particular one:

    Or, perhaps, all in-memory snap contexts could somehow be invalidated
    in this case, making writes fail naturally -- on the client side,
    without actually being sent to OSDs just to be nixed by the blocklist
    hammer.

Thanks,

                Ilya
