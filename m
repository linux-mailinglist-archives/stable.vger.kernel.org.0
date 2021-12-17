Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB9347834A
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 03:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbhLQCmk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 21:42:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:32741 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229471AbhLQCmj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Dec 2021 21:42:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639708959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FOlIaf01qqe55xvpS9zikZhnPJBU1QgpA4JvGB5Jis0=;
        b=M+xKRqUM3fuJ7vd7RVKpyUgo4STkkMgByaOZzESYmeI0jsLAHZ5iRDol4Hqf/nPUQUhMMW
        n5Hgepf7VhFOYRO55ri68v3NPvlWyvRZFE+YpkdOh7YYEk/tMUiy2o1u3/9Tosuitd2W1Q
        JW+/kl7vUlmmg6X8Y/CDpJPk1mkNoaU=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-605-jnPvYvcvO3yPIzX-66tncQ-1; Thu, 16 Dec 2021 21:42:38 -0500
X-MC-Unique: jnPvYvcvO3yPIzX-66tncQ-1
Received: by mail-il1-f199.google.com with SMTP id w1-20020a056e021a6100b0029f42663adcso585711ilv.0
        for <stable@vger.kernel.org>; Thu, 16 Dec 2021 18:42:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FOlIaf01qqe55xvpS9zikZhnPJBU1QgpA4JvGB5Jis0=;
        b=vgfWN8lCN1+aMSbo9X7rkIimlpA0OwIPIluQ6orKxrTcPB4Sm9I6oz+wX8GG/74QtZ
         uD6q/IDXvpSg7Q+GGAnqwVGJqx81ONCUGacCfAeCGy28/KqZ1CYJM6BT6HXLo3n9qbpn
         l9uCrFGHFRR58EW3p3w41AyU48gNeMHZoitRUEreUsSbfpbRdmbE08fvdIRAlORHevRL
         iggv+lMjm/cIf+JsKWwFof+OO5jsaYzWlOXGTAy5xOTsMAapAZrY8tARKw7KQ7EwMILY
         qg/GrcJ/HhmcSzS6d/EnGiDgyL2L3EKWXeLr3qIcd3YoC5hSoiJ3sAJHaUkiTlO8GSK1
         WbVw==
X-Gm-Message-State: AOAM531IF2wAfBTH1DytEQ5jq84/Zqe0Gf10hlX4YQk2IIKQCUpMPgY6
        WH6hSBUG0+X4pz/71k5Yuj4NF8YaW3+kuVhSuZ6aVrFstZz8k1NbYJU6enDAbGuZ7pWtKEgsX5/
        rgHiiBTBNws43T5X24PfFIlXiq6EsqF16
X-Received: by 2002:a05:6e02:2163:: with SMTP id s3mr514520ilv.70.1639708957537;
        Thu, 16 Dec 2021 18:42:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzkrEJoiZcRyVztGxx0CxqM8hwwf9wprhC12PIKkVDB/eKJpYtdydVNAFCdGYO8FYr25elP1DafZ4W5kzOOBp0=
X-Received: by 2002:a05:6e02:2163:: with SMTP id s3mr514514ilv.70.1639708957369;
 Thu, 16 Dec 2021 18:42:37 -0800 (PST)
MIME-Version: 1.0
References: <1639314690415@kroah.com> <Ybub/RYZeQkEBGcI@eldamar.lan>
In-Reply-To: <Ybub/RYZeQkEBGcI@eldamar.lan>
From:   Bruce Fields <bfields@redhat.com>
Date:   Thu, 16 Dec 2021 21:42:26 -0500
Message-ID: <CAPL3RVHXmJrnkcUK1YYv4XD3JvE6su5tuH4kyVCnZ+ukGF+rUg@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] nfsd: fix use-after-free due to delegation
 race" failed to apply to 4.19-stable tree
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 16, 2021 at 3:05 PM Salvatore Bonaccorso <carnil@debian.org> wrote:
> On Sun, Dec 12, 2021 at 02:11:30PM +0100, gregkh@linuxfoundation.org wrote:
> > The patch below does not apply to the 4.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
>
> Unless I'm completely wrong this only does not apply to the older
> series because in 5.6-rc1 we had 20b7d86f29d3 ("nfsd: use boottime for
> lease expiry calculation") soe there is a minor context change in one
> hunk.
>
> Attached is a patch accounting for that, Bruce is this okay?

Yes, this looks fine to me.  Thank you!

--b.

> This would apply as well back on top of v4.9.293.
>
> Regards,
> Salvatore
>
> From eeeaf376a2efabdad46ce03516552f4290949834 Mon Sep 17 00:00:00 2001
> From: "J. Bruce Fields" <bfields@redhat.com>
> Date: Mon, 29 Nov 2021 15:08:00 -0500
> Subject: [PATCH] nfsd: fix use-after-free due to delegation race
>
> commit 548ec0805c399c65ed66c6641be467f717833ab5 upstream.
>
> A delegation break could arrive as soon as we've called vfs_setlease.  A
> delegation break runs a callback which immediately (in
> nfsd4_cb_recall_prepare) adds the delegation to del_recall_lru.  If we
> then exit nfs4_set_delegation without hashing the delegation, it will be
> freed as soon as the callback is done with it, without ever being
> removed from del_recall_lru.
>
> Symptoms show up later as use-after-free or list corruption warnings,
> usually in the laundromat thread.
>
> I suspect aba2072f4523 "nfsd: grant read delegations to clients holding
> writes" made this bug easier to hit, but I looked as far back as v3.0
> and it looks to me it already had the same problem.  So I'm not sure
> where the bug was introduced; it may have been there from the beginning.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: J. Bruce Fields <bfields@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> [Salvatore Bonaccorso: Backport for context changes to versions which do
> not have 20b7d86f29d3 ("nfsd: use boottime for lease expiry
> calculation")]
> Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
> ---
>  fs/nfsd/nfs4state.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
> index 655079ae1dd1..dfb2a790efc1 100644
> --- a/fs/nfsd/nfs4state.c
> +++ b/fs/nfsd/nfs4state.c
> @@ -975,6 +975,11 @@ hash_delegation_locked(struct nfs4_delegation *dp, struct nfs4_file *fp)
>         return 0;
>  }
>
> +static bool delegation_hashed(struct nfs4_delegation *dp)
> +{
> +       return !(list_empty(&dp->dl_perfile));
> +}
> +
>  static bool
>  unhash_delegation_locked(struct nfs4_delegation *dp)
>  {
> @@ -982,7 +987,7 @@ unhash_delegation_locked(struct nfs4_delegation *dp)
>
>         lockdep_assert_held(&state_lock);
>
> -       if (list_empty(&dp->dl_perfile))
> +       if (!delegation_hashed(dp))
>                 return false;
>
>         dp->dl_stid.sc_type = NFS4_CLOSED_DELEG_STID;
> @@ -3912,7 +3917,7 @@ static void nfsd4_cb_recall_prepare(struct nfsd4_callback *cb)
>          * queued for a lease break. Don't queue it again.
>          */
>         spin_lock(&state_lock);
> -       if (dp->dl_time == 0) {
> +       if (delegation_hashed(dp) && dp->dl_time == 0) {
>                 dp->dl_time = get_seconds();
>                 list_add_tail(&dp->dl_recall_lru, &nn->del_recall_lru);
>         }
> --
> 2.34.1
>

