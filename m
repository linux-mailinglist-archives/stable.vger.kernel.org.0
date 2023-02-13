Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8431695291
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 22:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbjBMVB7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 16:01:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjBMVB6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 16:01:58 -0500
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8558D65A1;
        Mon, 13 Feb 2023 13:01:56 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 9ECC45C0050;
        Mon, 13 Feb 2023 16:01:52 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 13 Feb 2023 16:01:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        invisiblethingslab.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1676322112; x=
        1676408512; bh=lzHvNNWJAMPknrAbQ/IZzM70dgUpshuc4xhit7Lw7fE=; b=D
        clb1csrbW5n88QQeP/05NBGqeWLarDm2gvhYkgkre2d4vqI2v936TBt3/GoaDXN8
        mW/9maMz6OkNVnBiB4u9uGkHS0GmmZORwIiPveqAfTFdaiw9KDp8Dcyz9zkhVZ/V
        +NYwiYQa7iwuxi/SqP+3h8uEO7hi+ICkAhFRAtcZ+BfD2bYK6IGjdWPg5pg+lPdl
        icOswMsmd8ivODhiHMsNcb6ud+YJErwkdw2styv0aEpoWjZ5HjRerziJ2WenoiUF
        TIyDK5cIF6B/g/UBiG0FG7+zcHXeCXS6u/ukbqjX8MsXzAx8zJbK80ctNMjzprdP
        gf118/VCMvc8DdWhHFJ4Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1676322112; x=1676408512; bh=lzHvNNWJAMPknrAbQ/IZzM70dgUp
        shuc4xhit7Lw7fE=; b=ciBRmJ8Bea56AZVmMD0D+Ta4+tatkf686U7eVveufaMM
        XlXlzsTdxgXfIecD2kWxHkvkkideRnaoEtEenKIvdndsU33ao24fV3rhiqvBvt+C
        6Uqt4JqbCvtC998JWzK2XDeyA9QW+pAOx7+0N9mUwZ6gPVDdoQS5/VN2EbFVA60O
        wLqsz6R4vx6DmNauVhmDnzR0GJK8nCKtXfc3n5abDqOwpUSd3RfXcu2kKUkSPggw
        38fECmWjha79DcwgTPvbZ47EX3aIZdU3hU5FtbVDMYTMXtYrRpIedrgYNiQH3u60
        OrnRi9YIy2g0jeVr6B7XkMW2iET2EMV0jqJ88NHABQ==
X-ME-Sender: <xms:P6XqYw8F9lRXW21EeoEBI2p-4QGf-nwHPRXkF1u24iMtyVptIifFgQ>
    <xme:P6XqY4u9FSlsy4D3WWYjPoLytJniFVfNXc0q_vH7OscwFB4zYaW9aspry4MV0kav8
    KEjTbQImPhO-V8>
X-ME-Received: <xmr:P6XqY2DuEETR-tQTIbClwCuWsXKyju-nOv4UnzXkVJkHxHrG32TmWMCGCuo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudeiuddgudegtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehgtderredttdejnecuhfhrohhmpeffvghm
    ihcuofgrrhhivgcuqfgsvghnohhurhcuoeguvghmihesihhnvhhishhisghlvghthhhinh
    hgshhlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpedvjeetgeekhfetudfhgfetffeg
    fffguddvgffhffeifeeikeektdehgeetheffleenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpeguvghmihesihhnvhhishhisghlvghthhhinhhg
    shhlrggsrdgtohhm
X-ME-Proxy: <xmx:P6XqYwcrw3ayHD74m5j3b2ftHrSqLwVdtuy_Uldrkg-xqQNRLEmY2A>
    <xmx:P6XqY1NgeeIjx3ljlbWVzYyZYxoxU67PlGGEczrllAuYB0Fb34951Q>
    <xmx:P6XqY6kxo8EQlMuglDlieNAfHVLW4-2e-A5QFP4qgwY9ZUO6rE82rQ>
    <xmx:QKXqY6oP7sVeRP2KIFhLkeuzVlqjUPSSkdvA10jCGcC7joH64MWzBQ>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 13 Feb 2023 16:01:50 -0500 (EST)
Date:   Mon, 13 Feb 2023 16:01:45 -0500
From:   Demi Marie Obenour <demi@invisiblethingslab.com>
To:     Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc:     Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] xen: speed up grant-table reclaim
Message-ID: <Y+qlPYi20cP0yXnE@itl-email>
References: <20230207021033.1797-1-demi@invisiblethingslab.com>
 <5fdc17c1-4222-aea2-c1d1-be8b15b7f523@suse.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="N++tYrnEizmf3jUB"
Content-Disposition: inline
In-Reply-To: <5fdc17c1-4222-aea2-c1d1-be8b15b7f523@suse.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--N++tYrnEizmf3jUB
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Mon, 13 Feb 2023 16:01:45 -0500
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>,
	xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] xen: speed up grant-table reclaim

On Mon, Feb 13, 2023 at 10:26:11AM +0100, Juergen Gross wrote:
> On 07.02.23 03:10, Demi Marie Obenour wrote:
> > When a grant entry is still in use by the remote domain, Linux must put
> > it on a deferred list.  Normally, this list is very short, because
> > the PV network and block protocols expect the backend to unmap the grant
> > first.  However, Qubes OS's GUI protocol is subject to the constraints
> > of the X Window System, and as such winds up with the frontend unmapping
> > the window first.  As a result, the list can grow very large, resulting
> > in a massive memory leak and eventual VM freeze.
> >=20
> > Fix this problem by bumping the number of entries that the VM will
> > attempt to free at each iteration to 10000.  This is an ugly hack that
> > may well make a denial of service easier, but for Qubes OS that is less
> > bad than the problem Qubes OS users are facing today.
>=20
> > There really
> > needs to be a way for a frontend to be notified when the backend has
> > unmapped the grants.
>=20
> Please remove this sentence from the commit message, or move it below the
> "---" marker.

Will fix in v2.

> There are still some flag bits unallocated in struct grant_entry_v1 or
> struct grant_entry_header. You could suggest some patches for Xen to use
> one of the bits as a marker to get an event from the hypervisor if a
> grant with such a bit set has been unmapped.

That is indeed a good idea.  There are other problems with the grant
interface as well, but those can be dealt with later.

> I have no idea, whether such an interface would be accepted by the
> maintainers, though.
>=20
> > Additionally, a module parameter is provided to
> > allow tuning the reclaim speed.
> >=20
> > The code previously used printk(KERN_DEBUG) whenever it had to defer
> > reclaiming a page because the grant was still mapped.  This resulted in
> > a large volume of log messages that bothered users.  Use pr_debug
> > instead, which suppresses the messages by default.  Developers can
> > enable them using the dynamic debug mechanism.
> >=20
> > Fixes: QubesOS/qubes-issues#7410 (memory leak)
> > Fixes: QubesOS/qubes-issues#7359 (excessive logging)
> > Fixes: 569ca5b3f94c ("xen/gnttab: add deferred freeing logic")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Demi Marie Obenour <demi@invisiblethingslab.com>
> > ---
> > Anyone have suggestions for improving the grant mechanism?  Argo isn't
> > a good option, as in the GUI protocol there are substantial performance
> > wins to be had by using true shared memory.  Resending as I forgot the
> > Signed-off-by on the first submission.  Sorry about that.
> >=20
> >   drivers/xen/grant-table.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
> > index 5c83d41..2c2faa7 100644
> > --- a/drivers/xen/grant-table.c
> > +++ b/drivers/xen/grant-table.c
> > @@ -355,14 +355,20 @@
> >   static void gnttab_handle_deferred(struct timer_list *);
> >   static DEFINE_TIMER(deferred_timer, gnttab_handle_deferred);
> > +static atomic64_t deferred_count;
> > +static atomic64_t leaked_count;
> > +static unsigned int free_per_iteration =3D 10000;
>=20
> As you are adding a kernel parameter to change this value, please set the
> default to a value not potentially causing any DoS problems. Qubes OS can
> still use a higher value then.

Do you have any suggestions?  I don=E2=80=99t know if this is actually a DoS
concern anymore.  Shrinking the interval between iterations would be.

> > +
> >   static void gnttab_handle_deferred(struct timer_list *unused)
> >   {
> > -	unsigned int nr =3D 10;
> > +	unsigned int nr =3D READ_ONCE(free_per_iteration);
>=20
> I don't see why you are needing READ_ONCE() here.

free_per_iteration can be concurrently modified via sysfs.

> > +	const bool ignore_limit =3D nr =3D=3D 0;
>=20
> I don't think you need this extra variable, if you would ...
>=20
> >   	struct deferred_entry *first =3D NULL;
> >   	unsigned long flags;
> > +	size_t freed =3D 0;
> >   	spin_lock_irqsave(&gnttab_list_lock, flags);
> > -	while (nr--) {
> > +	while ((ignore_limit || nr--) && !list_empty(&deferred_list)) {
>=20
> ... change this to "while ((!nr || nr--) ...".

nr-- evaluates to the old value of nr, so "while ((!nr | nr--)) ..." is
an infinite loop.

> >   		struct deferred_entry *entry
> >   			=3D list_first_entry(&deferred_list,
> >   					   struct deferred_entry, list);
> > @@ -372,10 +378,13 @@
> >   		list_del(&entry->list);
> >   		spin_unlock_irqrestore(&gnttab_list_lock, flags);
> >   		if (_gnttab_end_foreign_access_ref(entry->ref)) {
> > +			uint64_t ret =3D atomic64_sub_return(1, &deferred_count);
>=20
> Use atomic64_dec_return()?

Will fix in v2.

> >   			put_free_entry(entry->ref);
> > -			pr_debug("freeing g.e. %#x (pfn %#lx)\n",
> > -				 entry->ref, page_to_pfn(entry->page));
> > +			pr_debug("freeing g.e. %#x (pfn %#lx), %llu remaining\n",
> > +				 entry->ref, page_to_pfn(entry->page),
> > +				 (unsigned long long)ret);
>=20
> Is each single instance of this message really needed?

I=E2=80=99m not sure.

> If not, I'd suggest to use pr_debug_ratelimited() instead.

Fair.

> >   			put_page(entry->page);
> > +			freed++;
> >   			kfree(entry);
> >   			entry =3D NULL;
> >   		} else {
> > @@ -387,14 +396,15 @@
> >   		spin_lock_irqsave(&gnttab_list_lock, flags);
> >   		if (entry)
> >   			list_add_tail(&entry->list, &deferred_list);
> > -		else if (list_empty(&deferred_list))
> > -			break;
> >   	}
> > -	if (!list_empty(&deferred_list) && !timer_pending(&deferred_timer)) {
> > +	if (list_empty(&deferred_list))
> > +		WARN_ON(atomic64_read(&deferred_count));
> > +	else if (!timer_pending(&deferred_timer)) {
> >   		deferred_timer.expires =3D jiffies + HZ;
> >   		add_timer(&deferred_timer);
> >   	}
> >   	spin_unlock_irqrestore(&gnttab_list_lock, flags);
> > +	pr_debug("Freed %zu references", freed);
> >   }
> >   static void gnttab_add_deferred(grant_ref_t ref, struct page *page)
> > @@ -402,7 +412,7 @@
> >   {
> >   	struct deferred_entry *entry;
> >   	gfp_t gfp =3D (in_atomic() || irqs_disabled()) ? GFP_ATOMIC : GFP_KE=
RNEL;
> > -	const char *what =3D KERN_WARNING "leaking";
> > +	uint64_t leaked, deferred;
> >   	entry =3D kmalloc(sizeof(*entry), gfp);
> >   	if (!page) {
> > @@ -426,12 +436,20 @@
> >   			add_timer(&deferred_timer);
> >   		}
> >   		spin_unlock_irqrestore(&gnttab_list_lock, flags);
> > -		what =3D KERN_DEBUG "deferring";
> > +		deferred =3D atomic64_add_return(1, &deferred_count);
> > +		leaked =3D atomic64_read(&leaked_count);
> > +		pr_debug("deferring g.e. %#x (pfn %#lx) (total deferred %llu, total =
leaked %llu)\n",
> > +			 ref, page ? page_to_pfn(page) : -1, deferred, leaked);
> > +	} else {
> > +		deferred =3D atomic64_read(&deferred_count);
> > +		leaked =3D atomic64_add_return(1, &leaked_count);
> > +		pr_warn("leaking g.e. %#x (pfn %#lx) (total deferred %llu, total lea=
ked %llu)\n",
> > +			ref, page ? page_to_pfn(page) : -1, deferred, leaked);
>=20
> Again, maybe use the ratelimited variants of pr_debug() and pr_warn()?

Will fix in v2 unless someone objects.

> >   	}
> > -	printk("%s g.e. %#x (pfn %#lx)\n",
> > -	       what, ref, page ? page_to_pfn(page) : -1);
> >   }
> > +module_param(free_per_iteration, uint, 0600);
>=20
> Please add the parameter to Documentation/admin-guide/kernel-parameters.t=
xt
>=20
>=20
> Juergen

Will fix in v2.
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab

--N++tYrnEizmf3jUB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEdodNnxM2uiJZBxxxsoi1X/+cIsEFAmPqpTwACgkQsoi1X/+c
IsGi/w/9FwOk5agFnZovITEblQY/gGnJFE7MAhQm8t008gzUbtwWbbl3NbrTvq4H
f15E9IDsA7o1YWcKCx7kmHayIr8inQqX1MINULBIEwer+2KC4/MDjmT03abeENVt
9eb/F+BhsswQXuGPu9fNGdUmS6Qtoe6bb8X3586QUADUoUK4kK0LgidIjTopwKys
gFmzOzZe9J2x8NIUD7fJTa5PMqJ8sErBP1RWzjB0JSJ9pV2pRFSKGeKEosc8ZOqH
bNkb9Fuaaryhe72YL5MTnVnsaKN2sJDN1pmOrIjiN28dgc/IxZ+SkauG8mry3a14
50fBXCQ/SiX/deXMN+dIJ49qkMbCdXGZvLMFQ3059ySUUSV0kGab8SkEqb6eYnN0
RjMEQVywIp6FcSr5xv+8TNyYUNNrERf67GMkraMFi4si7vN/o6ojNX4iBBvq07nf
M9IAiYhxzDEhiWZtbBWkew4W5gKlOXuelMEkNh7JyCXX3SB/3S2s8v/1uDg+N1NK
nSuIRJOa9y8UksIjXyHvWAa0xoNs4IX0+GgEk+7zaiJufX396FvP/fqkYEK1xBtl
xmHbA/Elrb3U5elvIUpJrOnEqUpUv9TrI+MylUZ6xRZPw7cUfk2a9/Hm675DnSpd
xvmzdmBZz9Q1px6Xbx+QAFQYTWHGAxE6TJIQTNJ/k4KMz9c1Vjs=
=bX8B
-----END PGP SIGNATURE-----

--N++tYrnEizmf3jUB--
