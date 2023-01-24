Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41F64679503
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 11:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232883AbjAXKSk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 05:18:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231483AbjAXKSh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 05:18:37 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9056C5272
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 02:18:36 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id f25-20020a1c6a19000000b003da221fbf48so10534581wmc.1
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 02:18:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r4TaXd25ULxGf2VZebmB9AEIpKhaLK0177ui9ayfPBQ=;
        b=LwHeTZaoDhMCvsrZ6tLpAfp7BgSOThqwgtC5PFDY3TJvWN8Ei4G48NYXwt6Jq2ljnF
         niAD0oygmqRt+msvEfO0rgYuEQyY+emyJ21CufGOjK2rMV67EzM8+lO+q8q1Reu2JxIg
         A2pHtrY612OPswNDJ5gEeDJ1ZOJdzBXeb6dB/RSvolE6Ut+4vzQRQQ5s+QIgQf7tfBe6
         V7lY1EOIVpRokj0HF5yk80F8sE1a6u1mQW4JevfpPOkQzmif6Kv5jS3NpBu0Xfly7LXy
         V59r5iGIo08SvLpesUQwkmg5IiM942X+pqXswNJxLnuPTDnnZmtPkRQ3jZPKItP9Z48V
         BFsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r4TaXd25ULxGf2VZebmB9AEIpKhaLK0177ui9ayfPBQ=;
        b=Vux0nj9M501ZSi53kSnyOxdYW3t1dcvKbtojoSmZ2Hc49200LtHgJuotmv4hegrb3S
         jjDkxXflhEIAihrwQ6uLZLSfyVA4+q8nLbBaSBgZsnAtX4Y+nRCrPOnFZqNPD0kjyvg9
         Q3fqjkwKASly8SD8K9rIaHc356jV5cLKfIW/N8w2t7ugD6owsmhCWsZgHpIVFacPZvZK
         2RW23b/q0ToieUXSQfLiuokmyWBEEGAWR3TJVZY3Js2aGIfR+J4eJVxFUPpi+bKIlRs9
         /8KK4h7riYahuOPriHKWx6iSvmBXqz74CQuknilxkrcOIG7A97OcPgxMV02Ya+u8OMDO
         OBrw==
X-Gm-Message-State: AFqh2kqOeDg0tir2YPMwtEcoJ0XUjyWzJjkhZR6xvZ13XclzWGA0IN9C
        sW8hw/sdmP5+rB30XOe7LA8tAIiU7Cu3GFWKdjFgJA==
X-Google-Smtp-Source: AMrXdXtocw9FvQQl06F1Kjomd0eSL9SilrcqLZGnbM0D3rqzvReZ39zJnQfeShc7bRB+A3Vuqna4tY8Rubb9xKbssEc=
X-Received: by 2002:a05:600c:34c3:b0:3cf:781a:4310 with SMTP id
 d3-20020a05600c34c300b003cf781a4310mr2643909wmq.150.1674555515054; Tue, 24
 Jan 2023 02:18:35 -0800 (PST)
MIME-Version: 1.0
References: <CALFERdzKUodLsm6=Ub3g2+PxpNpPtPq3bGBLbff=eZr9_S=YVA@mail.gmail.com>
 <Y89n98fRfTpLmPUg@kroah.com>
In-Reply-To: <Y89n98fRfTpLmPUg@kroah.com>
From:   Lukasz Majczak <lma@semihalf.com>
Date:   Tue, 24 Jan 2023 11:18:24 +0100
Message-ID: <CAFJ_xbqMx8LsD_Ry70jnqVmmhyGjTFpA-Gv7SpRR21v3Djr1DA@mail.gmail.com>
Subject: Re: Google Pixelbook EVE, no sound in kernel 6.1.x
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sasa Ostrouska <casaxa@gmail.com>, stable@vger.kernel.org,
        regressions@lists.linux.dev,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasa,
I've just built a vanilla kernel (v.6.1.7) with ChromeOS and audio
seems to work - at least for a while - I was able to play some music
on YouTube. Can you share a full dmesg ?

Best regards,
Lukasz

wt., 24 sty 2023 o 06:09 Greg KH <gregkh@linuxfoundation.org> napisa=C5=82(=
a):
>
> On Mon, Jan 23, 2023 at 09:44:34PM +0100, Sasa Ostrouska wrote:
> > Hi all, sorry if I put somebody in CC who is not the correct one. I
> > have a google pixelbook and using it with Fedora 37.
> > The last few kernels supplied by fedora 37, 6.1.6, 6.1.7 but also some
> > earlier have no working sound.
> > I see the last kernel for me with working sound is 6.0.18.
> > On my pixelbook this is showing in dmesg:
>
> Any chance you can use 'git bisect' to track down the offending commit?
>
> thanks,
>
> greg k-h
