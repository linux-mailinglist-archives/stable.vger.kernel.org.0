Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B51ED688D3A
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 03:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbjBCCsM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 21:48:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231760AbjBCCsL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 21:48:11 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 677201F5DA;
        Thu,  2 Feb 2023 18:48:09 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id r18so2737092pgr.12;
        Thu, 02 Feb 2023 18:48:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0faUbw6LnzQA7XGt69XVe4ZogRagpYIaVwTuvYvPQyI=;
        b=m09FuMlBEqBFPXKhDMFK6cbqhJC3JuEn8n+5NKJc2tFKVQUQdcBaWuOdmJoTtakEpb
         tTmlD5XpDFTDQLnpZ4ttSfaec7UBdnvghQLtoqtYhSgGpGM5b7VwEWlFStfKkwAp6Y7v
         7vp4ASEG2cv4SKlmGgytA3P7ddrKHIklauJFjNzBNq3+/EEupXH6XeTlwmOoeUp2Uz0e
         89TtxmA1CxvxEigsKSk36bSqE0oWVFI8KcIdUltgc35zMd256Bae6Pmazf1nQ0bwjUS2
         hGCA6uDNzfD2AHWDoM5g2cYOCE291QzoApo5LH+/nESl1iBJ0A1BOMb1bvRq45Lfdsj4
         6gNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0faUbw6LnzQA7XGt69XVe4ZogRagpYIaVwTuvYvPQyI=;
        b=mCz2R43F8kWl6/CAOZOh7FNm6DscKkCBEX4aHCJHa30Vd+2MW43rdHEMAbFWrVZQVA
         lq9d6sEqLim6boxpH6vA2TqSzMZ4f3PtqieGXcadACA1QSl4n9RY977mEpFNALfwUxlx
         qEBhffM5LdCq3Le3xii6oU5Xwd42x+R66EHWHyX/BBxU+IrAwCyJ9i+aLhSU1OeH13we
         pQT+xGCFEABkjXPOg96hct11ZIW7BRX5Flgll4Ckb5VZ9mROPKWtpkJ/MaZXJOfByB8V
         4BA4L0lsYdCYpLRTa2b2egZJQqkPEbApO6mMw7k5akoRDkyFWWeJH6U5ATuArk/L987C
         /WlQ==
X-Gm-Message-State: AO0yUKWdTN5jrJ2behY/KPARusFE3rulExXslaA4dpMzHLqllJ9LRelK
        MZbm3nNSPbH/ByphcUSzI5RkAb2nBbiS8aEFYSg=
X-Google-Smtp-Source: AK7set8/YftVLDeR/YHidKkbc+TLZZdddbfM/4ysCYVxQV4XOkrOsj1gG0yJr2xyqaJQSYoetcOQQKwdNAbPimJrx54=
X-Received: by 2002:a63:5150:0:b0:4d0:370b:5027 with SMTP id
 r16-20020a635150000000b004d0370b5027mr1472468pgl.8.1675392488872; Thu, 02 Feb
 2023 18:48:08 -0800 (PST)
MIME-Version: 1.0
References: <20230203022759.576832-1-zyytlz.wz@163.com> <CAJedcCzNB+1byPEzEgQ6ELjeoRQcZ=GnZg+1J4+FZvfnoK0H2Q@mail.gmail.com>
 <1A4D30F2-5FCB-4498-9571-12B320F4E1A1@suse.de>
In-Reply-To: <1A4D30F2-5FCB-4498-9571-12B320F4E1A1@suse.de>
From:   Zheng Hacker <hackerzheng666@gmail.com>
Date:   Fri, 3 Feb 2023 10:47:55 +0800
Message-ID: <CAJedcCxQdqqmKqN9a8-oiot8FKocGNaaCub0r+aE4ndj24L0Yw@mail.gmail.com>
Subject: Re: [PATCH] bcache: Remove some unnecessary NULL point check for the
 return value of __bch_btree_node_alloc-related pointer
To:     Coly Li <colyli@suse.de>
Cc:     Zheng Wang <zyytlz.wz@163.com>, stable@vger.kernel.org,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
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

Coly Li <colyli@suse.de> =E4=BA=8E2023=E5=B9=B42=E6=9C=883=E6=97=A5=E5=91=
=A8=E4=BA=94 10:46=E5=86=99=E9=81=93=EF=BC=9A
>
>
>
> > 2023=E5=B9=B42=E6=9C=883=E6=97=A5 10:43=EF=BC=8CZheng Hacker <hackerzhe=
ng666@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
> >
> > Hello,
> >
> > After writing the patch, I found there may be more places to replace
> > IS_ERR_OR_NULL to IS_ERR.
> > If the alloc of node will never be NULL, the additional NULL check of
> > nodes after allocation may also
> > be useless. This patch just fixes the check around the alloc. I'm not
> > sure about other places for my
> > limited understanding of the code in bcache.
>
> This was why I suggested you to post an extra cleanup patch like this.
>
> You may just add more changes as you mentioned into this patch and post a=
nother updated version.
>

Get it. Will do right now.

Thanks,
Zheng Wang
