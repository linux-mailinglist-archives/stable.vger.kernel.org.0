Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C563688D2A
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 03:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbjBCCnx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 21:43:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjBCCnv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 21:43:51 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E59234C8;
        Thu,  2 Feb 2023 18:43:50 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id w20so2630153pfn.4;
        Thu, 02 Feb 2023 18:43:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cJ8ju8uMCfhxp2ZJbCjKnHSEC8oaK2/2LO3gZqP5+Y0=;
        b=B3viMo8Cg5wab2Mm2+H+kwnUa+Zl/Iq3vZQZscX9GeDc+K7MnNzSBLbk2fObk0Ks6S
         lnNkqy2y61KG0NCGerwRvzr8ZtZUCAonHdHNr+3Zv/Rab1QpgvuPvc3d7/jefdrIdK6x
         LhitHffC/QT7ltkJKsDMhYzBTVpQQNNj70RSsBdA2IOtCiBfOw7VIBdgIVwS3nadYuTW
         85x3AP21p8pDtuy0P76hBxurTCtJznTsFZPDVGXR9gLWQQrjzeYx8TW9qPTn7cpdmZvg
         orD9pxaJneUViCsyI39YJCU/xeKv+YczSmeRHYEONP5EtSANJom/mDtt6GPm/S0zJRzb
         7M2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cJ8ju8uMCfhxp2ZJbCjKnHSEC8oaK2/2LO3gZqP5+Y0=;
        b=ef8yALr86cxk5NkLqDBsX1qGp2zgN8fmZX9sX/O6OWmapIL2WVFAy3uefqNbBmAgz1
         nrrgxh3VKS/JtQ9WVs2BcnsBB4mVUkO1iuLf01quhzSg1E0nLh+ux8CAerEztpOmlG7i
         nuucBsXMy3Og9t9/y7egaMG8ppSnqOcdHsCrFSGmZQdC3Ory1Nncw5ZlK81opFwK7rxN
         7GOVbO+wo5SoMTwRtI25pNQ7RWC5n894Ao6uxMuiVPZRl6veRcn0qK/9Gcz9lsEUvgGR
         t+327tSjS+4JT70BEfaKwfQkSq8eQ/w0YxIhQxFKoulOvP7Spd0xTK1UaTwLodyxoUKD
         XzuQ==
X-Gm-Message-State: AO0yUKUZ8q1OuDlYzwyzrUdjThIG7LLIrqDeFROaP72iFy4PtLahW8rW
        A8nJYZhakZE1DttF2AuxJvugqAM1Xva5mdcAOrc=
X-Google-Smtp-Source: AK7set9xHxNw5GYhe9ToeeqWZzWXxyrtANjpaTfUYU4HgrY6D2cJO1rLAJ5hKjotPjjQcfxafJmhTNlXAWs6ez8ffKU=
X-Received: by 2002:a63:1706:0:b0:4ec:366b:6460 with SMTP id
 x6-20020a631706000000b004ec366b6460mr1310280pgl.69.1675392229753; Thu, 02 Feb
 2023 18:43:49 -0800 (PST)
MIME-Version: 1.0
References: <20230203022759.576832-1-zyytlz.wz@163.com>
In-Reply-To: <20230203022759.576832-1-zyytlz.wz@163.com>
From:   Zheng Hacker <hackerzheng666@gmail.com>
Date:   Fri, 3 Feb 2023 10:43:36 +0800
Message-ID: <CAJedcCzNB+1byPEzEgQ6ELjeoRQcZ=GnZg+1J4+FZvfnoK0H2Q@mail.gmail.com>
Subject: Re: [PATCH] bcache: Remove some unnecessary NULL point check for the
 return value of __bch_btree_node_alloc-related pointer
To:     Zheng Wang <zyytlz.wz@163.com>
Cc:     colyli@suse.de, stable@vger.kernel.org, kent.overstreet@gmail.com,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        alex000young@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

After writing the patch, I found there may be more places to replace
IS_ERR_OR_NULL to IS_ERR.
If the alloc of node will never be NULL, the additional NULL check of
nodes after allocation may also
be useless. This patch just fixes the check around the alloc. I'm not
sure about other places for my
limited understanding of the code in bcache.

Thanks,
Zheng Wang

Zheng Wang <zyytlz.wz@163.com> =E4=BA=8E2023=E5=B9=B42=E6=9C=883=E6=97=A5=
=E5=91=A8=E4=BA=94 10:28=E5=86=99=E9=81=93=EF=BC=9A
>
> Due to the previously fix of __bch_btree_node_alloc, the return value wil=
l
> never be a NULL pointer. So IS_ERR is enough to handle the failure
>  situation. Fix it by replacing IS_ERR_OR_NULL check to IS_ERR check.
>
> Fixes: cafe56359144 ("bcache: A block layer cache")
> Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
> ---
>  drivers/md/bcache/btree.c | 6 +++---
>  drivers/md/bcache/super.c | 2 +-
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 147c493a989a..417cd7c436c4 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -1138,7 +1138,7 @@ static struct btree *btree_node_alloc_replacement(s=
truct btree *b,
>  {
>         struct btree *n =3D bch_btree_node_alloc(b->c, op, b->level, b->p=
arent);
>
> -       if (!IS_ERR_OR_NULL(n)) {
> +       if (!IS_ERR(n)) {
>                 mutex_lock(&n->write_lock);
>                 bch_btree_sort_into(&b->keys, &n->keys, &b->c->sort);
>                 bkey_copy_key(&n->key, &b->key);
> @@ -1352,7 +1352,7 @@ static int btree_gc_coalesce(struct btree *b, struc=
t btree_op *op,
>
>         for (i =3D 0; i < nodes; i++) {
>                 new_nodes[i] =3D btree_node_alloc_replacement(r[i].b, NUL=
L);
> -               if (IS_ERR_OR_NULL(new_nodes[i]))
> +               if (IS_ERR(new_nodes[i]))
>                         goto out_nocoalesce;
>         }
>
> @@ -1669,7 +1669,7 @@ static int bch_btree_gc_root(struct btree *b, struc=
t btree_op *op,
>         if (should_rewrite) {
>                 n =3D btree_node_alloc_replacement(b, NULL);
>
> -               if (!IS_ERR_OR_NULL(n)) {
> +               if (!IS_ERR(n)) {
>                         bch_btree_node_write_sync(n);
>
>                         bch_btree_set_root(n);
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index ba3909bb6bea..92de714fe75e 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -2088,7 +2088,7 @@ static int run_cache_set(struct cache_set *c)
>
>                 err =3D "cannot allocate new btree root";
>                 c->root =3D __bch_btree_node_alloc(c, NULL, 0, true, NULL=
);
> -               if (IS_ERR_OR_NULL(c->root))
> +               if (IS_ERR(c->root))
>                         goto err;
>
>                 mutex_lock(&c->root->write_lock);
> --
> 2.25.1
>
