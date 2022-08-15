Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C88B1592DFA
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 13:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbiHOLQY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 07:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiHOLQY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 07:16:24 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4253D1054A;
        Mon, 15 Aug 2022 04:16:23 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id m3-20020a05600c3b0300b003a5e0557150so1206189wms.0;
        Mon, 15 Aug 2022 04:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=F0dnHKYenUjScO0kkTeRtnGleMrVXt0Z0uMEQ9MJy4c=;
        b=UxoMQ/kg6tX53RXH/AzON8eRe8REAeZ1gCePmJWlome+TzjV1lZAG1o2CDWOqpcp14
         WteqEYSIWMB8tNIir8o5zN402NF00unkisr9STroDDXQACmSD6q8i+ZmBsPcYBL8ISXx
         Cv7YY+PgVFFB2Lvjy9R8WDb/K+lMIBtFy4JXnw5Nuf/i1h7ngGXkj4WKu8obL+K6CRFc
         GtY3KtckAcLekSGAc1rC2ktfGpT/5fb8P4hx0MsRdUaz1+WZhTUinxml0kwICvQhHKbO
         6jSNGlVVdoLZ0tsMudAeQlNyVrtswBrT5LTRWaJ81tjiECC8QnyF0R54+hopzFHna3qL
         gCiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=F0dnHKYenUjScO0kkTeRtnGleMrVXt0Z0uMEQ9MJy4c=;
        b=0y66V7mi1w79DaG9yR+s1Fh1kX71GgFZuNKnf2SGZvIVCgn9h6ukWWHJXaaExdvkSp
         buuYc1NogBLEu/zHYtn6qT7yRe72qkUGRuH/WZStWSnIcUboHn0vFE+wAYW0ucDly06u
         ViUDm3lQC9XfBftiVsO5gWHArOn3FhGSmNzBdYpqTnJtCXzW///GSsp+lT/dcVsrTde4
         Z7taO2roIKS3znbypSLIDwtu7hxG1+txd4AQemHs3GWLYK329HPxBFYv01aWCYXmTU3s
         sbrQXHMfA9rFWucj7hL9/LQ3S5aNv3EB71g+/Z70OQANC9WNky1CTh9JpThYkNiHXttp
         3mkw==
X-Gm-Message-State: ACgBeo055FsSVYLQEY1EpPBhr87boDvgj9j8QipvhWDb7YpAW6h+EqRD
        mAW65qdDv4LywGPQ4Dw/XDPSq+OsODVh75XfaaI=
X-Google-Smtp-Source: AA6agR7PenWqKD/K2C6wqlDoY2FBRy46Bu4zFul42kcY2ePYyXtqmn2pfn40RhYY7pXy5EaJrD0U575Lqa0/Bv7kpE0=
X-Received: by 2002:a05:600c:1f08:b0:3a5:e8d6:ddd2 with SMTP id
 bd8-20020a05600c1f0800b003a5e8d6ddd2mr4549938wmb.57.1660562181790; Mon, 15
 Aug 2022 04:16:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220814135256.5247-1-linkinjeon@kernel.org>
In-Reply-To: <20220814135256.5247-1-linkinjeon@kernel.org>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Mon, 15 Aug 2022 20:16:10 +0900
Message-ID: <CANFS6bZGdXf19im4qmVi1YUC7TYH8T-oTnrxDekrozAEvU6WHg@mail.gmail.com>
Subject: Re: [PATCH v3] ksmbd: don't remove dos attribute xattr on O_TRUNC open
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        senozhatsky@chromium.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

2022=EB=85=84 8=EC=9B=94 14=EC=9D=BC (=EC=9D=BC) =EC=98=A4=ED=9B=84 10:53, =
Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> When smb client open file in ksmbd share with O_TRUNC, dos attribute
> xattr is removed as well as data in file. This cause the FSCTL_SET_SPARSE
> request from the client fails because ksmbd can't update the dos attribut=
e
> after setting ATTR_SPARSE_FILE. And this patch fix xfstests generic/469
> test also.
>
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Cc: stable@vger.kernel.org
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>

Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>

> ---
>  v2:
>    - don't remove other xattr class also.
>    - add fixes and stable tags.
>  v3:
>    - Change to more simpler check.
>
>  fs/ksmbd/smb2pdu.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index a136d5e4943b..19412ac701a6 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -2330,15 +2330,15 @@ static int smb2_remove_smb_xattrs(struct path *pa=
th)
>                         name +=3D strlen(name) + 1) {
>                 ksmbd_debug(SMB, "%s, len %zd\n", name, strlen(name));
>
> -               if (strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LE=
N) &&
> -                   strncmp(&name[XATTR_USER_PREFIX_LEN], DOS_ATTRIBUTE_P=
REFIX,
> -                           DOS_ATTRIBUTE_PREFIX_LEN) &&
> -                   strncmp(&name[XATTR_USER_PREFIX_LEN], STREAM_PREFIX, =
STREAM_PREFIX_LEN))
> -                       continue;
> -
> -               err =3D ksmbd_vfs_remove_xattr(user_ns, path->dentry, nam=
e);
> -               if (err)
> -                       ksmbd_debug(SMB, "remove xattr failed : %s\n", na=
me);
> +               if (!strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_L=
EN) &&
> +                   !strncmp(&name[XATTR_USER_PREFIX_LEN], STREAM_PREFIX,
> +                            STREAM_PREFIX_LEN)) {
> +                       err =3D ksmbd_vfs_remove_xattr(user_ns, path->den=
try,
> +                                                    name);
> +                       if (err)
> +                               ksmbd_debug(SMB, "remove xattr failed : %=
s\n",
> +                                           name);
> +               }
>         }
>  out:
>         kvfree(xattr_list);
> --
> 2.25.1
>


--=20
Thanks,
Hyunchul
