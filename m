Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 196DA69B86F
	for <lists+stable@lfdr.de>; Sat, 18 Feb 2023 08:06:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbjBRHGp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Feb 2023 02:06:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBRHGo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Feb 2023 02:06:44 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 056652ED49;
        Fri, 17 Feb 2023 23:06:44 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id s22-20020a17090a075600b0023127b2d602so286434pje.2;
        Fri, 17 Feb 2023 23:06:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1676704003;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Zu/L/qFW2YMAP/T4TNpZ/aNTexuKeQzinnX/WzLrKY=;
        b=myEcCwdZQCrRrK7cRbM9HuEbaRxBSzQfJRQb8x0TKTYGcsdverRlhApp+QmYwVbuQK
         Pybb9OotF9j4mqoY0rIYNLtAJtV9ZN33/Z2R5Le2nDeF8rjvSk5fRe+Wrombh/7RvT8/
         VaxiZ44x9hody/KkkrFZ7lJvPjPjPxoNMrABrhHrUi83CpScBPUMuQNd3BISV1+o0YEF
         6+uzN0lCBQAp9CmG/flB36CNWSbCRIIXKa3PtFqR+DG13YwiDsFCRj+AtYDTZxfK/7Y8
         cSAlk5CvWQtf2rIAPqDB6nBxPk8O4VnhIPZZfmZqr+uBAnA9POUr9oTBOYuaeAiSrS2t
         KWMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676704003;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0Zu/L/qFW2YMAP/T4TNpZ/aNTexuKeQzinnX/WzLrKY=;
        b=PEedKnyse3ce1L4WIEnslObaOIyClEXW+QGR95OrjwDuLkSPbVjPl5l0LfxlYe6DU1
         LwtqqewR6YVmho8shY2Nc9UR3MnJho3JeEtU6WutZ0Logu1a5vZJu6Ut3/PPSh++DP4e
         NfBMDFh77QH9U/aOQJHCU8fxMG/wrFbWvNDG9mbK/Wjju/qX3JTQWDMluFiYAz8btVjO
         dwDju88s9SPwsrh2mTW29bVAf2pCEwjSFr+KKPo9JSBqTimMqs2NKMmkcGCTcbGVLHA7
         IyHuph/qaSNg3X611pdVv94AlfWxnkK7Qj7H9AoVmC3FC3YFYdGtgII4EwZdupjMTRfo
         xmXQ==
X-Gm-Message-State: AO0yUKVaobtHNt99Nsvj9+JWZkp0UCJg68YIVHYKpR15pUVuUMVXJvB2
        rR3qRvtbWWtBjADq3QDdNSGxDKbvEkvYx1L8Rzc=
X-Google-Smtp-Source: AK7set9h/GGYpV6FzuwELuMlHlrpHCjTz2XcBnt3fDlkxWdrMSkC1l8eZiuNz9Uyb3jRLumuFBexYW3JT8x3Wtiq5D4=
X-Received: by 2002:a17:903:48b:b0:19b:e2e:462 with SMTP id
 jj11-20020a170903048b00b0019b0e2e0462mr997799plb.1.1676704003456; Fri, 17 Feb
 2023 23:06:43 -0800 (PST)
MIME-Version: 1.0
References: <20230217100901.707245-1-zyytlz.wz@163.com> <62507028-c27d-82b8-2db2-5642e2388e3e@ewheeler.net>
In-Reply-To: <62507028-c27d-82b8-2db2-5642e2388e3e@ewheeler.net>
From:   Zheng Hacker <hackerzheng666@gmail.com>
Date:   Sat, 18 Feb 2023 15:06:32 +0800
Message-ID: <CAJedcCwhtqNTmQ1_P3EDZ+11WiNLOpBdv-k9oP=u4m3-FY-5fQ@mail.gmail.com>
Subject: Re: [RESEBD PATCH v3] bcache: Remove some unnecessary NULL point
 check for the return value of __bch_btree_node_alloc-related pointer
To:     Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     Zheng Wang <zyytlz.wz@163.com>, colyli@suse.de,
        kent.overstreet@gmail.com, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, alex000young@gmail.com,
        stable@vger.kernel.org
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

Eric Wheeler <bcache@lists.ewheeler.net> =E4=BA=8E2023=E5=B9=B42=E6=9C=8818=
=E6=97=A5=E5=91=A8=E5=85=AD 05:57=E5=86=99=E9=81=93=EF=BC=9A
>
> On Fri, 17 Feb 2023, Zheng Wang wrote:
>
> > Due to the previously fix of __bch_btree_node_alloc, the return value w=
ill
> > never be a NULL pointer. So IS_ERR is enough to handle the failure
> >  situation. Fix it by replacing IS_ERR_OR_NULL check to IS_ERR check.
> >
> > Fixes: cafe56359144 ("bcache: A block layer cache")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
> > ---
> > v3:
> > - Add Cc: stable@vger.kernel.org suggested by Eric
>
> Make sure that the commit
>         bcache: Fix __bch_btree_node_alloc to make the failure behavior c=
onsistent
> is committed _before_ this "Remove some unnecessary NULL point check..."
> patch.

Oh, sorry for my mistake. I forgot to commit the first patch. I'll try
to commit it first.

>
> It would be a good idea to add "this patch depends on `bcache: Fix
> __bch_btree_node_alloc to make the failure behavior consistent`" to the
> commit message so the stable maintainers know.

Yes, I will append that msg in the next version.

Best regargds,
Zheng
