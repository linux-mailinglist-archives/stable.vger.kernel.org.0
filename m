Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3D944B0DBF
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 13:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241668AbiBJMp3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 07:45:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241647AbiBJMp2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 07:45:28 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B389DF48;
        Thu, 10 Feb 2022 04:45:29 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id e79so6989870iof.13;
        Thu, 10 Feb 2022 04:45:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vVuq9C849TyyKMYK2wDnn3xfRuL6JOz5aRbsB3LpuNc=;
        b=cp8IMLeQr9X/AxTm6gsFv75CWmjUXEH54DKaqLlVxxDL4oA16IO+tsKVUqDL7VeNUG
         rVPgS7E6iatLEGtFMc+JZd56azb/iXQ4V0C+/uLMHz/1N2MG3D4hA2MWxerFTEM3OhxN
         GLyySyRL+weNAFklvBcpnxxZbuSkikuqvCV4Gmk7JjyoP6CpeavWNnoAmWrlUQv66BMx
         lRNXfZqX4SDXSM2AQwT2TDMSpvmv47nkr6+IuFsxmAFScssuYigE6i5lyU1LHKCyxvbi
         irJb+kEWxyZ0VhreQqs1jaBh9plGMEgqomDT/0PG4Ru8dFT1NPJxrZRMxm4/knG6X+w1
         8IWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vVuq9C849TyyKMYK2wDnn3xfRuL6JOz5aRbsB3LpuNc=;
        b=rGgnBF9gxYKzBl4OfVQDZ8yfrvryw5bkbVC3+a5oQvZUmWSsOgLFJiwthAwZDgtTGx
         ts1zSk0H5sK9nSaXw+8rmcW3QSMRfDmxp885UeKmDUrxw3LUmhwcfDwIEZasmFFSCCER
         4CXnMLtaQV4GCnVI/oVhVsynvU89PHFo9YKBL0t9//dA17J0uJP5kL8oiv2jGEUrN6by
         KL6OXf14Wj3i268n0lfOuu65m1qw5u6BWuHMmIZdCIbtJfNKWrFVWRpFUhbXgjFdio+B
         Dzm4SXiqPH9hXlR/0beCI7ImU4FfLNSzK9tR7Ia4K3rLLk9TadTM00HICK1+eK6LWlO4
         ft7Q==
X-Gm-Message-State: AOAM530a2MBpSBv/bm0vaAQiTDeqbgR7jzX/sfAjacQImbzVQt+nxuas
        +iiMi/qG5R3HcFz04PcrsJs=
X-Google-Smtp-Source: ABdhPJx2DDXig5S0TiboxeSABKBKhomhskJYokb8Bl3S83jLtI18u3oNdhoul/kpbbvJzSKjyYC60A==
X-Received: by 2002:a5d:9d8f:: with SMTP id ay15mr3749339iob.142.1644497129144;
        Thu, 10 Feb 2022 04:45:29 -0800 (PST)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id u26sm11205447ior.52.2022.02.10.04.45.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 04:45:27 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailauth.nyi.internal (Postfix) with ESMTP id 31A6F27C005A;
        Thu, 10 Feb 2022 07:45:26 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Thu, 10 Feb 2022 07:45:26 -0500
X-ME-Sender: <xms:5QgFYtS9O5yQkV5F2PfeRRjVntUU5um-kPiO6q2H36PiMqIs1R9Hvw>
    <xme:5QgFYmxnYlHARrvEjRhxc531VTJ6SQEZ9QGse7b6dzaYCoK8HOkXpWXeUK349NDBl
    98FmMNiv3M_PjFtaw>
X-ME-Received: <xmr:5QgFYi1pwQaUknl2WKjVYsiKAMVsQhITrail-aJEaGi9Rv9TfdeEmx6oZFY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddriedugdegvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesghdtreertddtvdenucfhrhhomhepuehoqhhunhcu
    hfgvnhhguceosghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmqeenucggtffrrghtth
    gvrhhnpeehfedujeeuffejleektdegleellefgfffhhfdvhedtkeevheejiedvjeeguddu
    geenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsoh
    hquhhnodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdeiledvgeehtdeigedq
    udejjeekheehhedvqdgsohhquhhnrdhfvghngheppehgmhgrihhlrdgtohhmsehfihigmh
    gvrdhnrghmvg
X-ME-Proxy: <xmx:5QgFYlCiN-WaVf_C8JvbdgqmiahEasIixI17J2wl8Pu9mKDcD89oDw>
    <xmx:5QgFYmjAh9LOQd-Z53-hFKSjZdKHiYU2ZcbnyUHGSVrs4Umu0J6XNA>
    <xmx:5QgFYpr4cKvRLgZqXiAxiQw_xBn60au8lkfqp1uQ1eN02iMf-gjp8w>
    <xmx:5ggFYtQqIzV_226tX4fI54iKd8bJu78WvqhyIoSeZ_7tuKW6-uNM9UBRvE0>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 10 Feb 2022 07:45:24 -0500 (EST)
Date:   Thu, 10 Feb 2022 20:45:09 +0800
From:   Boqun Feng <boqun.feng@gmail.com>
To:     Cheng Jui Wang <cheng-jui.wang@mediatek.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, stable@vger.kernel.org,
        wsd_upstream@mediatek.com,
        Eason-YH Lin <eason-yh.lin@mediatek.com>,
        Kobe-CP Wu <kobe-cp.wu@mediatek.com>,
        Jeff-CC Hsu <jeff-cc.hsu@mediatek.com>
Subject: Re: [PATCH] lockdep: Correct lock_classes index mapping
Message-ID: <YgUI1UdAm/oqNZzA@tardis>
References: <20220210105011.21712-1-cheng-jui.wang@mediatek.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mSrxgry1qLQwN7FB"
Content-Disposition: inline
In-Reply-To: <20220210105011.21712-1-cheng-jui.wang@mediatek.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--mSrxgry1qLQwN7FB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 10, 2022 at 06:50:11PM +0800, Cheng Jui Wang wrote:
> A kernel exception was hit when trying to dump /proc/lockdep_chains after
> lockdep report "BUG: MAX_LOCKDEP_CHAIN_HLOCKS too low!":
>=20
> Unable to handle kernel paging request at virtual address 00054005450e05c3
> ...
> 00054005450e05c3] address between user and kernel address ranges
> ...
> pc : [0xffffffece769b3a8] string+0x50/0x10c
> lr : [0xffffffece769ac88] vsnprintf+0x468/0x69c
> ...
>  Call trace:
>   string+0x50/0x10c
>   vsnprintf+0x468/0x69c
>   seq_printf+0x8c/0xd8
>   print_name+0x64/0xf4
>   lc_show+0xb8/0x128
>   seq_read_iter+0x3cc/0x5fc
>   proc_reg_read_iter+0xdc/0x1d4
>=20
> The cause of the problem is the function lock_chain_get_class() will
> shift lock_classes index by 1, but the index don't need to be shifted
> anymore since commit 01bb6f0af992 ("locking/lockdep: Change the range of
> class_idx in held_lock struct") already change the index to start from
> 0.
>=20
> The lock_classes[-1] located at chain_hlocks array. When printing
> lock_classes[-1] after the chain_hlocks entries are modified, the
> exception happened.
>=20
> The output of lockdep_chains are incorrect due to this problem too.
>=20
> Fixes: f611e8cf98ec ("lockdep: Take read/write status in consideration wh=
en generate chainkey")
>=20
> Signed-off-by: Cheng Jui Wang <cheng-jui.wang@mediatek.com>

Hmm.. this means that the /proc/lockdep_chains has been incorrect since
commit f611e8cf89ec..

Nice catch!

Reviewed-by: Boqun Feng <boqun.feng@gmail.com>

Regards,
Boqun

> ---
>  kernel/locking/lockdep.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
> index 4a882f83aeb9..f8a0212189ca 100644
> --- a/kernel/locking/lockdep.c
> +++ b/kernel/locking/lockdep.c
> @@ -3462,7 +3462,7 @@ struct lock_class *lock_chain_get_class(struct lock=
_chain *chain, int i)
>  	u16 chain_hlock =3D chain_hlocks[chain->base + i];
>  	unsigned int class_idx =3D chain_hlock_class_idx(chain_hlock);
> =20
> -	return lock_classes + class_idx - 1;
> +	return lock_classes + class_idx;
>  }
> =20
>  /*
> @@ -3530,7 +3530,7 @@ static void print_chain_keys_chain(struct lock_chai=
n *chain)
>  		hlock_id =3D chain_hlocks[chain->base + i];
>  		chain_key =3D print_chain_key_iteration(hlock_id, chain_key);
> =20
> -		print_lock_name(lock_classes + chain_hlock_class_idx(hlock_id) - 1);
> +		print_lock_name(lock_classes + chain_hlock_class_idx(hlock_id));
>  		printk("\n");
>  	}
>  }
> --=20
> 2.18.0
>=20

--mSrxgry1qLQwN7FB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEj5IosQTPz8XU1wRHSXnow7UH+rgFAmIFCM4ACgkQSXnow7UH
+rh8fwgAnNNIl8Mte6VygIwZ/glFXpfdsKseZW8tEGuCdJzU5DZ4/KipiEZswoui
ybBfHbUywJwyTi32kKRTyBc97xP+HuRUQv6x/kZqq2wrXg3m0fbmxyinYdnUPZD9
xQO1FqMtSqdh6gSbpjmjHsF9CerBQedxSFU+/ydHPbJrRHuHzK/i3d128vnbrO7M
REE+TgjCAs06y3T7rqGwRaQKelDrzHxhZx7aL8Z0sEa8NKdyhrgQyd+oLO68gHIh
lKCK0zHO16EVvS67AmH44wvY2GZfQ7S3qLAwIZ6s6HepEnk1R+UL+7uESlMuf5pm
MLiHYCjt6Kg088kfZyqFDcFX9CZYQg==
=vkZa
-----END PGP SIGNATURE-----

--mSrxgry1qLQwN7FB--
