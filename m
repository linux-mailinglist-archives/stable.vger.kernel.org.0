Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9C3C6AA09F
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 21:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbjCCUa6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 15:30:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231493AbjCCUa6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 15:30:58 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21AC559E62
        for <stable@vger.kernel.org>; Fri,  3 Mar 2023 12:30:55 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id fm20-20020a05600c0c1400b003ead37e6588so4701245wmb.5
        for <stable@vger.kernel.org>; Fri, 03 Mar 2023 12:30:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677875453;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g3yvMwjt6xFYaMq/afOnMv1J07K4v3G6XTO2evlZ7mY=;
        b=KBK7hG35eJ18DWv2F0xdxjcpt+QT9cF+RvIaR4O0T1Ystw4isvSs199DJOmeju7gp8
         +aveiV0I/5gSqZL2FWPZloEb47Zbo86hrwg06JPhS/9H9IIA12JTXd2F00BIjpvNH3Uw
         mfNCyu1fPJ8KNcloLT7d43gxvl6CO1N/0THEOwWOeA3gY4FhZdJK9TptUQT6Q2vl582b
         EFBfjFaJFredisuFhKhSRj0RBXc4yGTJA+NvRrs5FCCgjskMtDwS7svk+ZsUI1MtTVlD
         tZA8Qhm+17o2lg2byGcceZOeXE+vbSW+BsUGl6DbXyGPG3NOqQME8wHewDZNWBLFtF06
         ADBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677875453;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g3yvMwjt6xFYaMq/afOnMv1J07K4v3G6XTO2evlZ7mY=;
        b=MMSOxRqqQiNrmyxYOz6/8j5P+znXpTnlDkaf2+YOy1XLp1ImyZ7K+qmjHpN//uR1Cm
         aWSrU+n7tRHp8UjOGLj8N4lIfrtusBPQ2gkKRC7nR3W/iPjeFZJmQzVaXXtysw/1k0Tm
         M7jcUGDbjXSYe1RYZYWKwKqB6cn79KUOd5raK4DDx5rj3qVmoGLTWWj48Qqc5HfvbfUF
         d+BBDdcdsPwklMNttMB9jnUX0B0VZqBvryPyDEovQCvhf7Qmx86Nq+YDZQTsLDFl0zi/
         wu6jvy3bGYyggjnT+U7vO11dHwjP6t0DXZJZXRXj44+hYA5uftoWWO8GGEbi3NkgZdCr
         qkgA==
X-Gm-Message-State: AO0yUKUe6sE2GT9GU5zS052dLQgCNlevlAB5YV+3C+jidGtm/l12EqFI
        iryOJFBo74yHz6b3EtqjCcOcj8W5PAp/YvbhpSzM/g==
X-Google-Smtp-Source: AK7set+Q58mXwFqpdfGGoGb/9qe4TgdagAF/hR0+0hLQuUSfyK2f2DVusn5lzPjtI3t227/kvK5CSZ02qTHImLt3K3c=
X-Received: by 2002:a7b:c2a2:0:b0:3e1:787:d706 with SMTP id
 c2-20020a7bc2a2000000b003e10787d706mr680695wmk.2.1677875453543; Fri, 03 Mar
 2023 12:30:53 -0800 (PST)
MIME-Version: 1.0
References: <20230303071959.144604-1-ebiggers@kernel.org> <20230303071959.144604-3-ebiggers@kernel.org>
 <CAJkfWY7KNcJwLKST6TefRZ6TyFNd6C1LXo_tD2yWGdVMjmsOtA@mail.gmail.com> <ZAJPcMibOQ9DARmp@gmail.com>
In-Reply-To: <ZAJPcMibOQ9DARmp@gmail.com>
From:   Nathan Huckleberry <nhuck@google.com>
Date:   Fri, 3 Mar 2023 12:30:42 -0800
Message-ID: <CAJkfWY6BGT-++LjcAs=JELOn_54-TRquJfjz0bx-yw30g0mt-A@mail.gmail.com>
Subject: Re: [PATCH 2/3] blk-crypto: make blk_crypto_evict_key() more robust
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-fscrypt@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

You're right. Nevermind.

Reviewed-by: Nathan Huckleberry <nhuck@google.com>

On Fri, Mar 3, 2023 at 11:50=E2=80=AFAM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> On Fri, Mar 03, 2023 at 11:45:00AM -0800, Nathan Huckleberry wrote:
> > >  int __blk_crypto_evict_key(struct blk_crypto_profile *profile,
> > >                            const struct blk_crypto_key *key)
> > > @@ -389,22 +377,22 @@ int __blk_crypto_evict_key(struct blk_crypto_pr=
ofile *profile,
> > >
> > >         blk_crypto_hw_enter(profile);
> > >         slot =3D blk_crypto_find_keyslot(profile, key);
> > > -       if (!slot)
> > > -               goto out_unlock;
> > > -
> > > -       if (WARN_ON_ONCE(atomic_read(&slot->slot_refs) !=3D 0)) {
> > > -               err =3D -EBUSY;
> > > -               goto out_unlock;
> > > +       if (slot) {
> > > +               if (WARN_ON_ONCE(atomic_read(&slot->slot_refs) !=3D 0=
)) {
> > > +                       /* BUG: key is still in use by I/O */
> > > +                       err =3D -EBUSY;
> > > +               } else {
> > > +                       err =3D profile->ll_ops.keyslot_evict(
> > > +                                       profile, key,
> > > +                                       blk_crypto_keyslot_index(slot=
));
> > > +               }
> > > +               /*
> > > +                * Callers may free the key even on error, so unlink =
the key
> > > +                * from the hash table and clear slot->key even on er=
ror.
> > > +                */
> > > +               hlist_del(&slot->hash_node);
> > > +               slot->key =3D NULL;
> > >         }
> >
> > The !slot case still needs to be handled. If profile->num_slots !=3D 0
> > and !slot, we'll get an invalid index from blk_crypto_keyslot_index.
> >
> > With that change,
> > Reviewed-by: Nathan Huckleberry <nhuck@google.com>
> >
> > Thanks,
> > Huck
> >
> > > -       err =3D profile->ll_ops.keyslot_evict(profile, key,
> > > -                                           blk_crypto_keyslot_index(=
slot));
> > > -       if (err)
> > > -               goto out_unlock;
> > > -
> > > -       hlist_del(&slot->hash_node);
> > > -       slot->key =3D NULL;
> > > -       err =3D 0;
> > > -out_unlock:
> > >         blk_crypto_hw_exit(profile);
> > >         return err;
> > >  }
>
> I'm not sure what you're referring to.  The !slot case is handled correct=
ly, and
> it's the same as before.
>
> - Eric
