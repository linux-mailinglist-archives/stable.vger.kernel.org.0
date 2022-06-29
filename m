Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16F4D55FBD6
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 11:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbiF2JZC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 05:25:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232753AbiF2JY5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 05:24:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6314C381B6
        for <stable@vger.kernel.org>; Wed, 29 Jun 2022 02:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656494695;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iG23ovZO0eLzG4/SRsROkuQDNSDK+ta3/lY8mYzX3FI=;
        b=Yh7UNdIi6mzMAoc/8RkEI0F+SsUbzC5bfvir/eNO+AOZrOfXFGSdCa3LcuZQV1vj3EaUyk
        H/mzM9zVoYVHjCA+6M662w12/1jIx3sx3sZayvAjTYUo9O0UPq4R20KfNun5TyW8qXbnQd
        /fw3hM+BiuyC67v3FzpIQhVXFUNaorI=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-641-mbVeE0aTNhK0qSWvTKATdQ-1; Wed, 29 Jun 2022 05:24:54 -0400
X-MC-Unique: mbVeE0aTNhK0qSWvTKATdQ-1
Received: by mail-ed1-f71.google.com with SMTP id o11-20020a056402438b00b0043676efd75dso11548279edc.16
        for <stable@vger.kernel.org>; Wed, 29 Jun 2022 02:24:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=iG23ovZO0eLzG4/SRsROkuQDNSDK+ta3/lY8mYzX3FI=;
        b=H0mxoGOsn+pcMhbGihTXhDXE9mOV3ZFtAwOg4+13hek4Y11lfCiqGvN70VxvzOMLKy
         shKB5u93rX2YWk3X/iMQDRseL8Ywnh4YuqAQaCGWMHMC3zR+MJiLE9WHAbGmRZxCWb/C
         gVkk6RcrWoyy6YqwdtmpZC7lD90v4UFfoJrv7PvoaCTaVzjttGFAhwmwxOtAUn7YlsOt
         xLsh80xarz/ZbpgG2kboZahT3RA2ZlocpA+CbS+bcPL2sNuVSD8j84bCM4RCseiGhDe2
         oMhIV7VbsQ3AS4AT9wief5vKuCaJjM3YCH0lh6pG2IhDLgiUycjLsy9mIykf8wxYdz3i
         71Kw==
X-Gm-Message-State: AJIora92wbahf0MZY7jG2rEQM9eCB1z31y5hxfAHuFBENbGMxHDXIFVT
        npxoDc4cb8FQl8UYy0Aam3Chv6JE8BmKE8xrA3TuiXpDDcvFzXvQLXewTz6ZISshABnC5tYJqW9
        fl38Av44PQPnPLtR/
X-Received: by 2002:a05:6402:50c7:b0:435:923b:9b23 with SMTP id h7-20020a05640250c700b00435923b9b23mr2992788edb.336.1656494692104;
        Wed, 29 Jun 2022 02:24:52 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sxcnNzShRiL5W4I0+zELqt0poF2/r+6bLNtOuYySdTm2J/rykGpz7NKw3tb0ZoKkuMd3WN7w==
X-Received: by 2002:a05:6402:50c7:b0:435:923b:9b23 with SMTP id h7-20020a05640250c700b00435923b9b23mr2992705edb.336.1656494691176;
        Wed, 29 Jun 2022 02:24:51 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id ov24-20020a170906fc1800b006f3ef214d9fsm7442267ejb.5.2022.06.29.02.24.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 02:24:50 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9C222477018; Wed, 29 Jun 2022 11:24:49 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     Gregory Erwin <gregerwin256@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Rui Salvaterra <rsalvaterra@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v7] ath9k: let sleep be interrupted when unregistering
 hwrng
In-Reply-To: <20220628151840.867592-1-Jason@zx2c4.com>
References: <20220628151840.867592-1-Jason@zx2c4.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 29 Jun 2022 11:24:49 +0200
Message-ID: <87pmirakke.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

"Jason A. Donenfeld" <Jason@zx2c4.com> writes:

> There are two deadlock scenarios that need addressing, which cause
> problems when the computer goes to sleep, the interface is set down, and
> hwrng_unregister() is called. When the deadlock is hit, sleep is delayed
> for tens of seconds, causing it to fail. These scenarios are:
>
> 1) The hwrng kthread can't be stopped while it's sleeping, because it
>    uses msleep_interruptible() instead of schedule_timeout_interruptible(=
).
>    The fix is a simple moving to the correct function. At the same time,
>    we should cleanup a common and useless dmesg splat in the same area.
>
> 2) A normal user thread can't be interrupted by hwrng_unregister() while
>    it's sleeping, because hwrng_unregister() is called from elsewhere.
>    The solution here is to keep track of which thread is currently
>    reading, and asleep, and signal that thread when it's time to
>    unregister. There's a bit of book keeping required to prevent
>    lifetime issues on current.
>
> Reported-by: Gregory Erwin <gregerwin256@gmail.com>
> Cc: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Cc: Kalle Valo <kvalo@kernel.org>
> Cc: Rui Salvaterra <rsalvaterra@gmail.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: stable@vger.kernel.org
> Fixes: fcd09c90c3c5 ("ath9k: use hw_random API instead of directly dumpin=
g into random.c")
> Link: https://lore.kernel.org/all/CAO+Okf6ZJC5-nTE_EJUGQtd8JiCkiEHytGgDsF=
GTEjs0c00giw@mail.gmail.com/
> Link: https://lore.kernel.org/lkml/CAO+Okf5k+C+SE6pMVfPf-d8MfVPVq4PO7EY8H=
ys_DVXtent3HA@mail.gmail.com/
> Link: https://bugs.archlinux.org/task/75138
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  drivers/char/hw_random/core.c        | 30 ++++++++++++++++++++++++----
>  drivers/net/wireless/ath/ath9k/rng.c | 19 +++++++-----------
>  2 files changed, 33 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> index 16f227b995e8..df45c265878e 100644
> --- a/drivers/char/hw_random/core.c
> +++ b/drivers/char/hw_random/core.c
> @@ -38,6 +38,8 @@ static LIST_HEAD(rng_list);
>  static DEFINE_MUTEX(rng_mutex);
>  /* Protects rng read functions, data_avail, rng_buffer and rng_fillbuf */
>  static DEFINE_MUTEX(reading_mutex);
> +/* Keeps track of whoever is wait-reading it currently while holding rea=
ding_mutex. */
> +static struct task_struct *current_waiting_reader;
>  static int data_avail;
>  static u8 *rng_buffer, *rng_fillbuf;
>  static unsigned short current_quality;
> @@ -208,6 +210,7 @@ static ssize_t rng_dev_read(struct file *filp, char _=
_user *buf,
>  	int err =3D 0;
>  	int bytes_read, len;
>  	struct hwrng *rng;
> +	bool wait;
>=20=20
>  	while (size) {
>  		rng =3D get_current_rng();
> @@ -225,9 +228,15 @@ static ssize_t rng_dev_read(struct file *filp, char =
__user *buf,
>  			goto out_put;
>  		}
>  		if (!data_avail) {
> +			wait =3D !(filp->f_flags & O_NONBLOCK);
> +			if (wait && cmpxchg(&current_waiting_reader, NULL, current) !=3D NULL=
) {
> +				err =3D -EINTR;
> +				goto out_unlock_reading;
> +			}
>  			bytes_read =3D rng_get_data(rng, rng_buffer,
> -				rng_buffer_size(),
> -				!(filp->f_flags & O_NONBLOCK));
> +				rng_buffer_size(), wait);
> +			if (wait && cmpxchg(&current_waiting_reader, current, NULL) !=3D curr=
ent)
> +				synchronize_rcu();

So this synchronize_rcu() is to ensure the hwrng_unregister() thread has
exited the rcu_read_lock() section below? Isn't that a bit... creative...
use of RCU? :)

Also, synchronize_rcu() can potentially take a while on a busy system,
is it OK to call it while holding the mutex?

-Toke

