Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D288352118B
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 11:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239163AbiEJKBP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 06:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239375AbiEJKBN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 06:01:13 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F24F68B8
        for <stable@vger.kernel.org>; Tue, 10 May 2022 02:57:16 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id d15so19831757lfk.5
        for <stable@vger.kernel.org>; Tue, 10 May 2022 02:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=m3iAFIP4OMSq8KQP1j7SVBKWO8n8BXwTBCZYgtGpfJA=;
        b=XOD7CIe6QugAPdXy/D2qzQ5VXi+F6iYQdFliexYWfpHfAYJDAUSnbDQbscvnT4GGK6
         Re07x2ZupXs1kMpVXVwuOYHGNJpYf3Q+Jup4+CPzthqLCgX04CdkGLgduw+yf2en6zA7
         0IxxQwWRCtQa1CAz/CvK6IWdFHR1BeCzgSFFXF/DRmLF05DOp/zKnwVd8VpUi5Imvmvr
         XQMt4QLUsDI//XK7Ot/uI+9d3l3k1fIizTaUzsZ6PxjP7bU94s46R19FYs2mXWQ6auM1
         G9plVmfpa0aCToSvaQKVihswo4QH3Jd4iZnnHkI0y/rVZyzFnE2o1td4eGaA77KDeynC
         PyJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=m3iAFIP4OMSq8KQP1j7SVBKWO8n8BXwTBCZYgtGpfJA=;
        b=tJ1U3VyOetzp1rzIDWql0qiA+PAvUh7wPC1lXaNrutoRfcSA2gmF7QsYLv6c5QQ3Sb
         P5VVHTj3vXlD3qz7JYpXamZexDLu27esCoQzH7hHsOGcR5PbG+WAlQ98jvtjNxw7Uvil
         TFBsDWCjFB53AZe6tIxans80Btr+wXcVBMAy4Tum6oz4SpzNfbK9eUUXQKGpLl43xNn0
         b/IixWrURHetj4NTNOXh1WLlBraUaan8B/K0F0u2U3VUOJuvB1BkNvx7mzTrfHdyMSDm
         smvZtc9ZTTgZ3phUkyX4vBb1l2/LmEtL/Gt5zc9iQ4miOINxWumXuPXYsQVgFjbQ0BAH
         INBw==
X-Gm-Message-State: AOAM531/YN2GVA+lerehoncVkEQJy1KgKn/mVtmmvMZZPf7/z4412yGK
        m+Klv5KZ9DvK9cOPH0dIU+JtVVr1UIslqYLAjFYeDQ==
X-Google-Smtp-Source: ABdhPJxL4NKh539TGVeg+05mFm/Hb3XS/hD+s1HzPp85CNXNX/uhcWbw2ohXqvPy/MEwQ1plCcnOwdrzkrItgvgf78U=
X-Received: by 2002:ac2:4646:0:b0:472:108e:51af with SMTP id
 s6-20020ac24646000000b00472108e51afmr16072941lfo.184.1652176634708; Tue, 10
 May 2022 02:57:14 -0700 (PDT)
MIME-Version: 1.0
References: <fb7cda69c5c244dfa579229ee2f0da83@realtek.com> <CAPDyKFrYWgCbwk6-hNZjtx4mdn7Sx1NJLie+f8wEjS==_HXR5Q@mail.gmail.com>
 <add6c326a5b04525965ffa1e9e96ea41@hyperstone.com> <YnjjR8pouD4KtHtT@kroah.com>
 <050affc68f7f4861b35a1ab96e228fec@hyperstone.com>
In-Reply-To: <050affc68f7f4861b35a1ab96e228fec@hyperstone.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Tue, 10 May 2022 11:56:38 +0200
Message-ID: <CAPDyKFqh15PFKza8vQpaq7HK_DH3w4q8AvpskZv=vzNYfSdqJQ@mail.gmail.com>
Subject: Re: [PATCH] mmc: rtsx: add 74 Clocks in power on flow
To:     =?UTF-8?Q?Christian_L=C3=B6hle?= <CLoehle@hyperstone.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc:     Ricky WU <ricky_wu@realtek.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 9 May 2022 at 12:12, Christian L=C3=B6hle <CLoehle@hyperstone.com> =
wrote:
>
> >> Can we get 1f311c94aabdb419c28e3147bcc8ab89269f1a7e merged into the st=
able tree?
> >
> >Which stable branches do you want this added to?
> >
> >thanks,
> >
> >greg k-h
>
> From what I can tell the issue is present since the addition of the drive=
r in ff984e57d36e8
> So I would suggest adding them to all? Maybe Ricky and Ulf could comment?

That seems correct.

Although, it's likely that 1f311c94aabd doesn't apply to older stable
trees, but I guess we can try and see how it goes.

Perhaps an even better option is that you submit a backported patch to
Greg for those stable kernels you want it to be applied to.

Kind regards
Uffe
