Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 033645BCCF1
	for <lists+stable@lfdr.de>; Mon, 19 Sep 2022 15:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbiISNVr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Sep 2022 09:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbiISNVo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Sep 2022 09:21:44 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FEC1627C;
        Mon, 19 Sep 2022 06:21:43 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id 63so1129266ybq.4;
        Mon, 19 Sep 2022 06:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=tJpygNNITh1u9xwDloalaLqoI943iAIGZRlKPJgD6wg=;
        b=kGGvh/SYDsBXwkl6lSURIQLZGlSOt0GHhCqLyg4u1r9ESHPVrpeREAYQKQaqfyxwsp
         SENXSEEXtvneR4LyFu9XmJPbKobhEqen4JZg1AAhcwO/tyRifCPombZNAY+tk2kSG/PW
         2AvBe7L/oPMAEkVgdN4FR66C6Zo9oius3GRGhZngonhKp+N5GkYt2GA+EyEHlkC/9IwK
         dJUiIi+2+5zP6i7PCku8B4eNmA3xTFfNFb15vnSvlmyjwPobQ1GZjjQUvlaQe9wPTdjh
         Tk22gmaHt1jiqSEcXq9aeg6nERq+Gw6EmMsHRvWeai+zAbeNYv98o7kIa85Y+1a46kcn
         ULDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=tJpygNNITh1u9xwDloalaLqoI943iAIGZRlKPJgD6wg=;
        b=KBM9wUT7uduQzlbbIKCk8Z89qtSw7q04o0RmC5rrSLI0P9NoVLwKvKMG3IvMrSPD9y
         GniAB/k3r4nS2L1lK6LBumOBniJdbdEJ62WfZjXcViNRZN0G5wLG/OTmCYWKBn8flOfw
         g6eSgIzjxBoO7Gtmk5X3ITceyES7PU1PKp8jWDbfmj51+0WTqbSPcTFQwRYkXa1RyL1C
         db8YpW9fCtuHlxwMeOvyzi6u58T3GnDiRGIso+BfngxVyImbjvFEYlzOtmVRP6QsFQQx
         c/Eh3PUSWnD0nmMqkLiKJTgemn66MrGmjD9lG6U2RGkCbs12jSii6M9Wrr5dpYxF29kL
         xyBw==
X-Gm-Message-State: ACrzQf3/uZqRL1GEWT6YQKnDWUVT2mBAVs2Qe9xIzPqNbV6G4u/2+RGO
        TVIxA6JYokkSMLMt35gAyddncqUzQELaanc5F8SqnzGyRGIjCIVR
X-Google-Smtp-Source: AMsMyM7ENjsS5zZnwpYJ3GPZ60XtTgPR5p7psFM5Qt9zGWHmTD5bTHfREaUIVMWUwfPXfBNijNSdvic3m+UjX5eVs/o=
X-Received: by 2002:a25:6611:0:b0:67b:e0c2:3239 with SMTP id
 a17-20020a256611000000b0067be0c23239mr13869436ybc.18.1663593702518; Mon, 19
 Sep 2022 06:21:42 -0700 (PDT)
MIME-Version: 1.0
References: <ab879545-d4b2-0cd8-3ae2-65f9f2baf2fe@gmail.com>
 <YyCLm0ws8qsiEcaJ@kroah.com> <CAOH5QeAUGBshLQdRCWLg9-Q3JvrqROLYW6uWr8a4TBKxwAOPaw@mail.gmail.com>
 <CGME20220916094017epcas1p1deed4041f897d2bf0e0486554d79b3af@epcms1p4>
 <YyREk5hHs2F0eWiE@kroah.com> <1891546521.01663549682346.JavaMail.epsvc@epcpadp4>
In-Reply-To: <1891546521.01663549682346.JavaMail.epsvc@epcpadp4>
From:   yong w <yongw.pur@gmail.com>
Date:   Mon, 19 Sep 2022 21:21:16 +0800
Message-ID: <CAOH5QeCF2HfGTJHue4GM6r7K3cec4xfReifVOuB_H4Fi6nXupg@mail.gmail.com>
Subject: Re: [PATCH v4] page_alloc: consider highatomic reserve in watermark fast
To:     jaewon31.kim@samsung.com
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        "mhocko@kernel.org" <mhocko@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "wang.yong12@zte.com.cn" <wang.yong12@zte.com.cn>,
        YongTaek Lee <ytk.lee@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Jaewon Kim <jaewon31.kim@samsung.com> =E4=BA=8E2022=E5=B9=B49=E6=9C=8819=E6=
=97=A5=E5=91=A8=E4=B8=80 09:08=E5=86=99=E9=81=93=EF=BC=9A
>
> >On Wed, Sep 14, 2022 at 08:46:15AM +0800, yong w wrote:
> >> Greg KH <gregkh@linuxfoundation.org> =E4=BA=8E2022=E5=B9=B49=E6=9C=881=
3=E6=97=A5=E5=91=A8=E4=BA=8C 21:54?=E9=81=93=EF=BC=9A
> >>
> >> >
> >> > On Tue, Sep 13, 2022 at 09:09:47PM +0800, yong wrote:
> >> > > Hello,
> >> > > This patch is required to be patched in linux-5.4.y and linux-4.19=
.y.
> >> >
> >> > What is "this patch"?  There is no context here :(
> >> >
> >> Sorry, I forgot to quote the original patch. the patch is as follows
> >>
> >>     f27ce0e page_alloc: consider highatomic reserve in watermark fast
> >>
> >> > > In addition to that, the following two patches are somewhat relate=
d:
> >> > >
> >> > >       3334a45 mm/page_alloc: use ac->high_zoneidx for classzone_id=
x
> >> > >       9282012 page_alloc: fix invalid watermark check on a negativ=
e value
> >> >
> >> > In what way?  What should be done here by us?
> >> >
> >>
> >> I think these two patches should also be merged.
> >>
> >>     The classzone_idx  parameter is used in the zone_watermark_fast
> >> functionzone, and 3334a45 use ac->high_zoneidx for classzone_idx.
> >>     "9282012 page_alloc: fix invalid watermark check on a negative
> >> value"  fix f27ce0e introduced issues
> >
> >Ok, I need an ack by all the developers involved in those commits, as
> >well as the subsystem maintainer so that I know it's ok to take them.
> >
> >Can you provide a series of backported and tested patches so that they
> >are easy to review?
> >
> >thanks,
> >
> >greg k-h
>
> Hello I didn't know my Act is needed to merge it.
>
> Acked-by: Jaewon Kim <jaewon31.kim@samsung.com>
>
> I don't understand well why the commit f27ce0e has dependency on 3334a45,=
 though.
>
Hello, the classzone_idx is used in the zone_watermark_fast function, and
there will be conflicts when f27ce0e is merged.

Looking back, the following two patches adjust the classzone_idx parameter.
     3334a45 mm/page_alloc: use ac->high_zoneidx for classzone_idx
     97a225e mm/page_alloc: integrate classzone_idx and high_zoneidx
and 3334a45 is the key modification.

Actually, I think 3334a45 can be merged or not.

Thanks.
