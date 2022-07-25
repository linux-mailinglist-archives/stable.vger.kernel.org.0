Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF2D457FD09
	for <lists+stable@lfdr.de>; Mon, 25 Jul 2022 12:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbiGYKJI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jul 2022 06:09:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234554AbiGYKJF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jul 2022 06:09:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 79206175BF
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 03:09:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658743743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zOdNDi4us/f1Sas6UpqCTnnTTYxPBuf2sETCHij1Xqg=;
        b=ZAiB7YnXDuRUvcuJJ5tuzkF31udAlE8ezUUEoP6sh6Vq7OQBaOWBrtne5vz3pHguzlWiyt
        piweYTg1qTeEGYf4yHhXHfPnanIQgrVLtLnIRN3ch2B3ETEjudNaelElL3UbcrBY3RZUWu
        jmqSt1qt9O/BpiLUKRmWUcF5oqPzYIk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-596-fW7uNyVtME6I0demDCKJ9w-1; Mon, 25 Jul 2022 06:09:02 -0400
X-MC-Unique: fW7uNyVtME6I0demDCKJ9w-1
Received: by mail-wm1-f72.google.com with SMTP id v67-20020a1cac46000000b003a2be9fa09cso5964827wme.3
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 03:09:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=zOdNDi4us/f1Sas6UpqCTnnTTYxPBuf2sETCHij1Xqg=;
        b=qcIXmQJZLxkHILsR7P65meWhDRbv+msTO9+9k7vLme+V3R5c1X46RCABXbnD0mDoAp
         S25TVgKGlHCNhn5L7kyaLUvkid88sTwYsqo5lnvfB3S/9TItizVhu0RMGuFh798n+O2Q
         GLJVLLOExFy7rrKYqXf4saEBderQsdgYbs8dXH7qeN5DEejR3BgCYmZ6s2GKqRVIvvJw
         nTNRke61mBJ+9g217rgjGMv+YOTSADwCXI/LbW65IIXEnordReVI+Gapg0wfC50rMirx
         5xHSFs2tFlRdEYiQyC0lKD27nc9iGFKQ7UskbQY/Z4DLuN0Ih8dlApxCqKSRA8JJP6yL
         tlPw==
X-Gm-Message-State: AJIora/p06adDU2NaBbRtsaNgaxBIgqqiH0eY4PX+MmupceM/PoQ7Dnh
        zQ4wm2Dx0KrQLnrX5Ra2fnTr+qgElIl6SJEkoBAkVk9/7BryBa1GlUALJbOSRJsfVGVEleQ89ET
        90qZLbxyWwB+43rMC
X-Received: by 2002:adf:ec02:0:b0:21e:8e67:d0f9 with SMTP id x2-20020adfec02000000b0021e8e67d0f9mr1668585wrn.114.1658743741217;
        Mon, 25 Jul 2022 03:09:01 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uhPpazF4+NLltIjfSDcACz17CKS2QpshcLz6JrwZPRfWbbvUTKy+nduUYohktC9GwVNNrh6A==
X-Received: by 2002:adf:ec02:0:b0:21e:8e67:d0f9 with SMTP id x2-20020adfec02000000b0021e8e67d0f9mr1668572wrn.114.1658743740926;
        Mon, 25 Jul 2022 03:09:00 -0700 (PDT)
Received: from vschneid.remote.csb ([185.11.37.247])
        by smtp.gmail.com with ESMTPSA id l3-20020a1c7903000000b003a320e6f011sm14764718wme.1.2022.07.25.03.08.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 03:09:00 -0700 (PDT)
From:   Valentin Schneider <vschneid@redhat.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Rui Salvaterra <rsalvaterra@gmail.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        stable <stable@vger.kernel.org>,
        Gregory Erwin <gregerwin256@gmail.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J?= =?utf-8?Q?=C3=B8rgensen?= 
        <toke@toke.dk>, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v10] ath9k: let sleep be interrupted when unregistering
 hwrng
In-Reply-To: <CAHmME9pEvr_F2C9cG4qNSCc91a7YAAquW7Jqczcgn2fr_vA4Ow@mail.gmail.com>
References: <CAHmME9qrd25vfRYYvCWtPg+wVC5joEzzJiihCN+L4rqMfTL4Rg@mail.gmail.com>
 <20220719201108.264322-1-Jason@zx2c4.com>
 <xhsmhfsisgbam.mognet@vschneid.remote.csb>
 <CAHmME9pEvr_F2C9cG4qNSCc91a7YAAquW7Jqczcgn2fr_vA4Ow@mail.gmail.com>
Date:   Mon, 25 Jul 2022 11:08:58 +0100
Message-ID: <xhsmhbktdfqrp.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hi Jason,

On 22/07/22 22:13, Jason A. Donenfeld wrote:
> Hi Valentin,
>
> On Fri, Jul 22, 2022 at 10:09 PM Valentin Schneider <vschneid@redhat.com> wrote:
>> I had initially convinced myself this would be somewhat involved, but
>> writing the above I thought maybe not... The below is applied on top of
>> your v10, would you be able to test whether it actually works?
>> It does however mean patching up any sleeping hwrng (a quick search tells
>> me there are more, e.g. npcm-rng does readb_poll_timeout())
>
> I'm not able to test this easily, no (I don't own any hardware), and
> I'm not going to put in the effort to rewrite/audit every sleeping
> hwrng. That's not a good use of time, given the numerous other
> problems the framework has (briefly discussed with Eric). Instead,
> maybe at some point I'll look into overhauling all of this so that
> none of this will be required anyway. So I think v10 is my final
> submission on this.
>

I think that's fair, I hope I didn't discourage you too much from
contributing in that area.

> But if you'd like to attempt more comprehensive changes throughout the
> tree on all the drivers and do something large, I guess you can do
> that independently (since you mentioned your thing works on top of
> v10). And this way v10 still exists to fix the actual bug that's
> currently reeking havoc. On the other hand, maybe don't bother, and we
> can look into fixing the whole rats nest properly in some months when
> I'm more motivated to jump into hwrng.
>

Just to make sure I'm on the same page as you - is your patch solely for
ath9k, or is it supposed to fix other drivers?

AFAICT your changes to hw_random/core.c work with any hwnrg driver that
does a variant of schedule_timeout() during rng_get_data(), whereas what I
suggested only works for "opted-in" drivers (just ath9k ATM), but it
doesn't break the other drivers in any way.

So if ath9k is widely used / a problem for lots of folks, we could just fix
that one and leave the others TBD. What do you think?

