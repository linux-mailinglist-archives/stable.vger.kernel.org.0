Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 766EC4D50BC
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 18:39:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236827AbiCJRj5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 12:39:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238098AbiCJRj4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 12:39:56 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 511054CD62
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 09:38:55 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id j3-20020a9d7683000000b005aeed94f4e9so4565406otl.6
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 09:38:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SS7nrrNHVUaT5n6CRCXmiOuXobp29ColNc9iGvYhPoU=;
        b=W860HSrEH6X1gW4Zy3kzEe2y2LtS9ojECWxkLzo2l+t9tgStOGe7Vy2L9ba+PqRBa7
         6d8oeeU3rO1yqshfOqQ2ItFwtWlKG8ytM8pBp4wpUJLHqp+LOlT8XtChDuGY2DM1H2Sk
         iWZkNLLqo3taaaK0r8wE7mqslSO/ql/Y9sP8oQPCYTxFB/3GaCq+H6lLQOONTalkurCD
         pp+Uc0PpsDsdlIShrk1IQ50U4A586LzklHw5+pSblvQeh3GXnRnC+QpNhUFb++8S/l4/
         lARsEWhAwmyZg0x3ziyOor53HxFOcFWjicr4hoKARk29D8eyeAxj7Gj2rR7HhgKQ8yAb
         ccHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SS7nrrNHVUaT5n6CRCXmiOuXobp29ColNc9iGvYhPoU=;
        b=Pidd31x+83xm0ivpBDEJ12x8ldw+qcax5zNGsifAz4fVT3YzRlx209VAurUIttkMMA
         UEqagkkt3pQYSz6jMS6ShZzH2AXvN5QFQ7tgv3cTByVdT3lOXtsu3X6OqGxyaR+Gp/9t
         x6zsmY16NNn5akXlVrNWdhqx0t9dHjYNg6JLFPvUC1dXFk7DsFqYCrRDNjhjCb8/1kq9
         nO47TvvRWreKqKiImKWgeZR8zFYs8MKbk/TChB/zsfFLvZ7/ZTXFZq4jF6TwjjG0jyYV
         BrlpfD9lZ/RLyDN1JzCSn6EVvarJLJA3cJJPMLe4yzsd+Z1mL95XlBqMKomDUzy+7IBc
         c9Lw==
X-Gm-Message-State: AOAM531qnb43t88rab3eIpQdzOQjNOB2M96OQ/TYzzcdjupDboSnQkiZ
        a69o26PQ418k+nYc+7zZzMXHmHpnOvA=
X-Google-Smtp-Source: ABdhPJzuACpSwK3ihgkeeGfhJ+o7naVgLkXeG3LUIQ6BUeHdzcRSdSVHnUBg2vrn1gCZZQvWyhwHug==
X-Received: by 2002:a05:6830:4126:b0:5c9:2a3e:be43 with SMTP id w38-20020a056830412600b005c92a3ebe43mr1289093ott.143.1646933934624;
        Thu, 10 Mar 2022 09:38:54 -0800 (PST)
Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com. [209.85.161.41])
        by smtp.gmail.com with ESMTPSA id c30-20020a056830349e00b005b272587f47sm1903791otu.38.2022.03.10.09.38.54
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 09:38:54 -0800 (PST)
Received: by mail-oo1-f41.google.com with SMTP id j7-20020a4ad6c7000000b0031c690e4123so7570538oot.11
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 09:38:54 -0800 (PST)
X-Received: by 2002:a0d:e288:0:b0:2db:f50a:9d10 with SMTP id
 l130-20020a0de288000000b002dbf50a9d10mr5058002ywe.419.1646933605614; Thu, 10
 Mar 2022 09:33:25 -0800 (PST)
MIME-Version: 1.0
References: <20220308000146.534935-1-tadeusz.struk@linaro.org>
 <14626165dad64bbaabed58ba7d59e523@AcuMS.aculab.com> <6155b68c-161b-0745-b303-f7e037b56e28@linaro.org>
 <66463e26-8564-9f58-ce41-9a2843891d1a@kernel.org> <45522c89-a3b4-4b98-232b-9c69470124a3@linaro.org>
 <ff2e1007-5883-5178-6415-326d6ae69c34@kernel.org> <8fdab42f-171f-53d7-8e0e-b29161c0e3e2@linaro.org>
 <CA+FuTSeAL7TsdW4t7=G91n3JLuYehUCnDGH4_rHS=vjm1-Nv9Q@mail.gmail.com> <c7608cf0-fda2-1aa6-b0c1-3d4e0b5cad0e@linaro.org>
In-Reply-To: <c7608cf0-fda2-1aa6-b0c1-3d4e0b5cad0e@linaro.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 10 Mar 2022 12:32:49 -0500
X-Gmail-Original-Message-ID: <CA+FuTScPUVpyK6WYXrePTg_533VF2wfPww4MOJYa17v0xbLeGQ@mail.gmail.com>
Message-ID: <CA+FuTScPUVpyK6WYXrePTg_533VF2wfPww4MOJYa17v0xbLeGQ@mail.gmail.com>
Subject: Re: [PATCH] net: ipv6: fix invalid alloclen in __ip6_append_data
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        David Laight <David.Laight@aculab.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "syzbot+e223cf47ec8ae183f2a0@syzkaller.appspotmail.com" 
        <syzbot+e223cf47ec8ae183f2a0@syzkaller.appspotmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 10, 2022 at 11:06 AM Tadeusz Struk <tadeusz.struk@linaro.org> wrote:
>
> On 3/10/22 06:39, Willem de Bruijn wrote:
> > On Wed, Mar 9, 2022 at 4:37 PM Tadeusz Struk <tadeusz.struk@linaro.org> wrote:
> >>
> >> On 3/8/22 21:01, David Ahern wrote:
> >>> On 3/8/22 12:46 PM, Tadeusz Struk wrote:
> >>>> That fails in the same way:
> >>>>
> >>>> skbuff: skb_over_panic: text:ffffffff83e7b48b len:65575 put:65575
> >>>> head:ffff888101f8a000 data:ffff888101f8a088 tail:0x100af end:0x6c0
> >>>> dev:<NULL>
> >>>> ------------[ cut here ]------------
> >>>> kernel BUG at net/core/skbuff.c:113!
> >>>> invalid opcode: 0000 [#1] PREEMPT SMP KASAN
> >>>> CPU: 0 PID: 1852 Comm: repro Not tainted
> >>>> 5.17.0-rc7-00020-gea4424be1688-dirty #19
> >>>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1.fc35
> >>>> RIP: 0010:skb_panic+0x173/0x175
> >>>>
> >>>> I'm not sure how it supposed to help since it doesn't change the
> >>>> alloclen at all.
> >>>
> >>> alloclen is a function of fraglen and fraglen is a function of datalen.
> >>
> >> Ok, but in this case it doesn't affect the alloclen and it still fails.
> >
> > This is some kind of non-standard packet that is being constructed. Do
> > we understand how it is different?
> >
> > The .syz reproducer is generally a bit more readable than the .c
> > equivalent. Though not as much as an strace of the binary, if you
> > can share that.
> >
> > r0 = socket$inet6_icmp_raw(0xa, 0x3, 0x3a)
> > connect$inet6(r0, &(0x7f0000000040)={0xa, 0x0, 0x0, @dev, 0x6}, 0x1c)
> > setsockopt$inet6_IPV6_HOPOPTS(r0, 0x29, 0x36,
> > &(0x7f0000000100)=ANY=[@ANYBLOB="52b3"], 0x5a0)
> > sendmmsg$inet(r0, &(0x7f00000002c0)=[{{0x0, 0x0,
> > &(0x7f0000000000)=[{&(0x7f00000000c0)="1d2d", 0xfa5f}], 0x1}}], 0x1,
> > 0xfe80)
>
> Here it is:
> https://termbin.com/krtr
> It won't be of much help, I'm afraid, as the offending sendmmsg()
> call isn't fully printed.

Thanks. It does offer some hints on the other two syscalls:

[pid   644] connect(3, {sa_family=AF_INET6, sin6_port=htons(0),
sin6_flowinfo=htonl(0), inet_pton(AF_INET6, "fe80::", &sin6_addr),
sin6_scope_id=if_nametoindex("tunl0")}, 28) = 0
[pid   644] setsockopt(3, SOL_IPV6, IPV6_HOPOPTS,
"R\263\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
1440) = 0

IPV6_HOPOPTS is ns_capable CAP_NET_RAW.

So this adds 1440 bytes to opt_nflen, which is included in
fragheaderlen, causing that to be exactly mtu. This means that the
payload can never be sent, as each fragment header eats up the entire
mtu? This is without any transport headers that would only be part of
the first fragment (which go into opt_flen).

If you can maybe catch the error before the skb_put and just return
EINVAL, we might see whether sendmmsg is relevant or a simple send
would be equivalent. (not super important, that appears unrelated.)
