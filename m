Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDCC06BBC98
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 19:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbjCOSpF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 14:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232662AbjCOSo4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 14:44:56 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C2566B973
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 11:44:21 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id t13so3775755qkt.6
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 11:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678905856;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UKasjMPF2EpYy8h1gxB6mwCHBq31nxCn58HwthSdmaM=;
        b=B0BNwBYzlTJqPfwuEMtvjx0k8PNZGK/GCGpMjYiBpkt1+n0tZqtlevxb9hR4GpDkc3
         BhJUutlDM0JTBj/jDj5v0iLJvnUPc01QCK+3fwe0tRraIeo6ZIJ5faz9ZeuvTesu4IVh
         7y5gojhugKdslx60BER9EQVHNOu4ggT2k2k8xrAUOsT+c15ilNjlnANdycgSPIGZ+fgx
         p7fSbBNrNC34O4EQl2yU0wW1IyzYN6X31wRg0IH5CwxvZJDmre5E3DAUOeSxVhMHqLmp
         TBQeObVDZm+MAdibOnluNrSzcj4chCMJhZF3boPU5xXjD7Z3RuJUEzwq9u5toKSWYiLc
         jtcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678905856;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UKasjMPF2EpYy8h1gxB6mwCHBq31nxCn58HwthSdmaM=;
        b=P7eELw4mZTJlO8KVbZHgqIkHkWa/9ohUVdkaKNQ4ATXpe0GC0UQsz+Ko99xowL/CU/
         n1oSrMWpfmpBJIA59D83QK2sSHsvBnIwAeOKWapuY4HSIc9Arp+XFZJm4oumWm6FsWma
         TuHHdURIL1Eq0CyrBP+dB1HbATOD39mTFJrfYLiAbTG/DM/t4gy+KWN1z/6G+rxklN1F
         5LUXI7vtXrF89S46ySM+4IHtenHwXvPYCtE1e06I5rTsDyVEgXlOFPiQo5SPbdHuMZ35
         TA+0q9Wn4uXYfzhgrXS7mC7OVA3hCzQmNfNddTtmCBWRL0SDz1mJfCc0DVUi8HA6eNP5
         cTHQ==
X-Gm-Message-State: AO0yUKWrBjvK+ZX05putmuXlw3gCU0s1zAfXNjqzJYojTcp6eoqUz9pi
        7ofiPC9UPpUpLOGG9aeKtBwnwhuDkbdnAegumYhaFehceWuA05kU
X-Google-Smtp-Source: AK7set8Px7r19DlCNnGa1ZWYJCb5EysTV2uwmFELXR6c1LYUBTRekeIR1muQrgg2vzN2ZToAD2Uu0/Eu7jmTnOlZNgY=
X-Received: by 2002:a05:620a:b94:b0:745:c8e5:7b28 with SMTP id
 k20-20020a05620a0b9400b00745c8e57b28mr2129272qkh.2.1678905856337; Wed, 15 Mar
 2023 11:44:16 -0700 (PDT)
MIME-Version: 1.0
References: <20230315181900.2107200-1-amit.pundir@linaro.org> <ZBINX5qbdmY5CQOD@kroah.com>
In-Reply-To: <ZBINX5qbdmY5CQOD@kroah.com>
From:   Amit Pundir <amit.pundir@linaro.org>
Date:   Thu, 16 Mar 2023 00:13:40 +0530
Message-ID: <CAMi1Hd1VaEGcN6Z2v0_V4Msj+BddNLtfPggZpc2u1yKHRHueiQ@mail.gmail.com>
Subject: Re: [PATCH for-6.1.y] Revert "ASoC: codecs: lpass: register mclk
 after runtime pm"
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 15 Mar 2023 at 23:54, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Mar 15, 2023 at 11:49:00PM +0530, Amit Pundir wrote:
> > This reverts commit 7b642273438cf500d36cffde145b9739fa525c1d which is
> > commit 1dc3459009c33e335f0d62b84dd39a6bbd7fd5d2 upstream.
> >
> > This patch broke RB5 (Qualcomm SM8250) devboard. The device
> > reboots into USB crash dump mode after following error:
> >
> >     qcom_q6v5_pas 17300000.remoteproc: fatal error received: \
> >     ABT_dal.c:278:ABTimeout: AHB Bus hang is detected, \
> >     Number of bus hang detected := 2 , addr0 = 0x3370000 , addr1 = 0x0!!!
> >
> > Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
> > ---
> >  sound/soc/codecs/lpass-rx-macro.c  |  8 ++++----
> >  sound/soc/codecs/lpass-tx-macro.c  |  8 ++++----
> >  sound/soc/codecs/lpass-va-macro.c  | 20 ++++++++++----------
> >  sound/soc/codecs/lpass-wsa-macro.c |  9 +++++----
> >  4 files changed, 23 insertions(+), 22 deletions(-)
>
> Is this also reverted in Linus's tree?  If not, why not?

I couldn't reproduce this crash on Linus's tree. It was first reported
on android14-6.1 and then I could reproduce it on v6.1.19 as well,
hence this revert.

A quick search points out that this patch is a part of a 8 patch
series https://lore.kernel.org/lkml/20230209122806.18923-1-srinivas.kandagatla@linaro.org/
while only 5 of them landed on v6.1.y. May be we need the remaining
fixes on v6.1.y as well? I can give the remaining patches a quick shot
tomorrow if that helps.

Regards,
Amit Pundir

>
> thanks,
>
> greg k-h
