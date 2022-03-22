Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38BEA4E3C57
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 11:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232882AbiCVKVb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Mar 2022 06:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232884AbiCVKV1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Mar 2022 06:21:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1AEF480202
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 03:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647944399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=m4GF+9cHV53cr1b1xAXRydH38vqCGfAi4QbQEVblHtE=;
        b=ITZFY3lDdiLwM3qGqCHHqFTZAC2yNu1BNFlZpNa6bIQoVXc/xzGT5ZsAtAYKwErHsh+3KF
        qM3QjBaRPkOJp9BUAVb3bfvfHBRealMaBLoITe/uAoxgFL6xDJe149HhRe4mt0jJfm5BcS
        SGNPQu/jb2eb/AfzWIZ/IMAX8sqTNXQ=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-199-0aq0bigJNWmT-6x51T7SCg-1; Tue, 22 Mar 2022 06:19:58 -0400
X-MC-Unique: 0aq0bigJNWmT-6x51T7SCg-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-2e689dfe112so652487b3.20
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 03:19:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m4GF+9cHV53cr1b1xAXRydH38vqCGfAi4QbQEVblHtE=;
        b=CsJEJ26tlmr2Z9ipp+OmMnFrXsWnmwP2wDHH2Z83BwcU7XZUas6pc7OMloxo9CzDQH
         dS38JBqB5sEQfOnmP5NUa3HoawborxoOa/5V/41ZqbyGYFjG0xjK1XD1toye+9tpAL2f
         PhfzlGXhePsZE+munq32chmmV852XgF5CVijvGLuBJtyNPBzq6oApFcI90OpuFiBeW55
         q0RjgAuzRpoeJ1lELghH1FYFzWw6XKxzlmL7HD7ey1NKkkRbQ85/2lRJS6F5R8skDeHh
         JztlDX27ogjbreTzr3ppECJZsLXOo9KXa4cEH3eQvBoUd788IR6kBM5wAIW7pu3as410
         0vvA==
X-Gm-Message-State: AOAM531hZMrLBWtnfxQKybO5e2saURekfc3nfS85P5ufAWqaWlIRgYbL
        42A8x1fkxznA5yAeZGPlpgvW58hDi6AGAI8euhCUCu6Q5g9l2z0FWXC3Euyc3jScPzAGDGT9GVb
        +Wy8aC43Vq0XkvknDj4mu1gVfz8sBJ8Ja
X-Received: by 2002:a81:79d5:0:b0:2e5:9d33:82ab with SMTP id u204-20020a8179d5000000b002e59d3382abmr28322738ywc.460.1647944398074;
        Tue, 22 Mar 2022 03:19:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx1s+XqKJwWIkv18BmjfiRSu7eZCg2W9vokwL7Up2nCK/iOM0QMoUFKZUpNL1cAHqgyWIPdVSoun3BcuCKTC8A=
X-Received: by 2002:a81:79d5:0:b0:2e5:9d33:82ab with SMTP id
 u204-20020a8179d5000000b002e59d3382abmr28322720ywc.460.1647944397874; Tue, 22
 Mar 2022 03:19:57 -0700 (PDT)
MIME-Version: 1.0
References: <CAE4VaGDZr_4wzRn2___eDYRtmdPaGGJdzu_LCSkJYuY9BEO3cw@mail.gmail.com>
 <CAE4VaGDKXnQJKdayeNsAD5RcqsKu5XG2UeweLvgZoFO-pn-t9Q@mail.gmail.com> <Yjl26QqwU1L2XWoh@kroah.com>
In-Reply-To: <Yjl26QqwU1L2XWoh@kroah.com>
From:   Jirka Hladky <jhladky@redhat.com>
Date:   Tue, 22 Mar 2022 11:19:46 +0100
Message-ID: <CAE4VaGBRcwPEO3JZtSesvE0bFTQ_P62mC7MmZ5Rc9VQey+=L_w@mail.gmail.com>
Subject: Re: PANIC: "Oops: 0000 [#1] PREEMPT SMP PTI" starting from 5.17 on
 dual socket Intel Xeon Gold servers
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        regressions@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Can you use 'git bisect' to track down the kernel commit that caused
> this problem?

Yes, I will try that and report the back the findings.

On Tue, Mar 22, 2022 at 8:15 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Mar 22, 2022 at 12:37:37AM +0100, Jirka Hladky wrote:
> > Cc: regressions@lists.linux.dev stable@vger.kernel.org
> >
> > On Tue, Mar 22, 2022 at 12:29 AM Jirka Hladky <jhladky@redhat.com> wrote:
> > >
> > > Starting from kernel 5.17 (tested with rc2, rc4, rc7, rc8) we
> > > experience kernel oops on Intel Xeon Gold dual-socket servers (2x Xeon
> > > Gold 6126 CPU)
> > >
> > > Bellow is a backtrace and the dmesg log.
> > >
> > > I have trouble creating a simple reproducer - it happens at random
> > > places when preparing the NAS benchmark to be run. The script creates
> > > a bunch of directories, compiles the benchmark a start trial runs.
> > >
> > > Could you please help to narrow down the problem?
>
> Can you use 'git bisect' to track down the kernel commit that caused
> this problem?
>
> thanks,
>
> greg k-h
>


-- 
-Jirka

