Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5DC96DBBB9
	for <lists+stable@lfdr.de>; Sat,  8 Apr 2023 17:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjDHPFz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Apr 2023 11:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjDHPFz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Apr 2023 11:05:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7860CC178
        for <stable@vger.kernel.org>; Sat,  8 Apr 2023 08:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680966313;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w9sryqDLxXFtiPfudnwB2Hm3EkTYwVipdp4/U/AgJig=;
        b=RcOPCeKgx8JjcoOFSF1luYPGl/HTMvhAhhamhjwJ6/EhPfDkniaDRvYA79NUwO8TQ/euo+
        w5dnoTijSfV1pAlXlXlrddTcrkfsQRHFGdl0NhK3cwZLEo2b/xrADofevtmCcK87qeenY1
        FXApBzQO/C2ZwMNn0weJCYJgRsnT2/M=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-454-ivSFPhLdN6aC4AY9QSxdqw-1; Sat, 08 Apr 2023 11:05:11 -0400
X-MC-Unique: ivSFPhLdN6aC4AY9QSxdqw-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-5024a72b054so1689444a12.0
        for <stable@vger.kernel.org>; Sat, 08 Apr 2023 08:05:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680966310;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w9sryqDLxXFtiPfudnwB2Hm3EkTYwVipdp4/U/AgJig=;
        b=1rr0nLPgEUMtB5VtDReGElkfkWprscUo3R/B1/Hh0GlwV4tLdq5NVqlxBXQImdh+Up
         99esLmKyWcr42ZkieH0sdwIJdBNPYa+b1bTU2NCM1sxAemGDriyIwb6MywC9cChBgpCD
         f1zMDFFocK37rg++e2Va/mq/4IpgEV3XL+8/AqITs8tfadC9VmT7qZPo7M4pwvRs0spx
         ZH1Cdra9zn6j9LJvn7gMhm00eyguyEy8ryvYPeJ0RbcdJ/SJW1zL4U3CMD3BwQb3WKVI
         ie+ByUJS2zLrnG0hp9eyHP3IvmpU04RPDtW4F62nF6gdycs9A6agM0bfU/5WiK8lcAlZ
         PV7Q==
X-Gm-Message-State: AAQBX9cH95G2L2Fpc8CXTzqwyOlMB95qETaCuzKPR56w+EasRZn3FklW
        17fqf+Ynv6AV/AzYSAX1BPWlbRGKPjNoiTVCWb9K+yNoVRvT55glNOUbHk0jaObaTRo+4ZXBy1I
        j4q9MwdeCeKbfmpktwMW5fgRtTr+/J71g
X-Received: by 2002:aa7:d590:0:b0:4fd:2675:3785 with SMTP id r16-20020aa7d590000000b004fd26753785mr1389715edq.22.1680966310625;
        Sat, 08 Apr 2023 08:05:10 -0700 (PDT)
X-Google-Smtp-Source: AKy350YEXZM04gfrG0zUHYkHUTtzon3Nz0PuH2lQDJcHf0ICTIe5pJAzOGzTF1m/FMXP9xJ9r7stdvgILRdsVA9Ke24=
X-Received: by 2002:aa7:d590:0:b0:4fd:2675:3785 with SMTP id
 r16-20020aa7d590000000b004fd26753785mr1389692edq.22.1680966310343; Sat, 08
 Apr 2023 08:05:10 -0700 (PDT)
MIME-Version: 1.0
References: <20230408081934.54002-1-chenaotian2@163.com>
In-Reply-To: <20230408081934.54002-1-chenaotian2@163.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Sat, 8 Apr 2023 11:04:58 -0400
Message-ID: <CAK-6q+j4aDoA2KG3Qzxg2XMu6nPxUuExuBw=sQ3+VqJuB5cj0A@mail.gmail.com>
Subject: Re: [PATH wpan v2] ieee802154: hwsim: Fix possible memory leaks
To:     Chen Aotian <chenaotian2@163.com>
Cc:     alex.aring@gmail.com, stefan@datenfreihafen.org,
        miquel.raynal@bootlin.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Sat, Apr 8, 2023 at 4:22=E2=80=AFAM Chen Aotian <chenaotian2@163.com> wr=
ote:
>
> After replacing e->info, it is necessary to free the old einfo.
>
> Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
> Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
> Signed-off-by: Chen Aotian <chenaotian2@163.com>
> ---
>
> V1 -> V2:
> * Using rcu_replace_pointer() is better then rcu_dereference()
>   and rcu_assign_pointer().
>
>  drivers/net/ieee802154/mac802154_hwsim.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee8=
02154/mac802154_hwsim.c
> index 8445c2189..6ffcadb9d 100644
> --- a/drivers/net/ieee802154/mac802154_hwsim.c
> +++ b/drivers/net/ieee802154/mac802154_hwsim.c
> @@ -685,7 +685,7 @@ static int hwsim_del_edge_nl(struct sk_buff *msg, str=
uct genl_info *info)
>  static int hwsim_set_edge_lqi(struct sk_buff *msg, struct genl_info *inf=
o)
>  {
>         struct nlattr *edge_attrs[MAC802154_HWSIM_EDGE_ATTR_MAX + 1];
> -       struct hwsim_edge_info *einfo;
> +       struct hwsim_edge_info *einfo, *einfo_old;
>         struct hwsim_phy *phy_v0;
>         struct hwsim_edge *e;
>         u32 v0, v1;
> @@ -723,8 +723,10 @@ static int hwsim_set_edge_lqi(struct sk_buff *msg, s=
truct genl_info *info)
>         list_for_each_entry_rcu(e, &phy_v0->edges, list) {
>                 if (e->endpoint->idx =3D=3D v1) {
>                         einfo->lqi =3D lqi;
> -                       rcu_assign_pointer(e->info, einfo);
> +                       einfo_old =3D rcu_replace_pointer(e->info, einfo,
> +                                                       lock_is_held(&hws=
im_phys_lock));

I think lockdep_is_held() should be correct here.

- Alex

