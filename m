Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0451B4D4A83
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 15:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245373AbiCJOrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:47:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346148AbiCJOmi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:42:38 -0500
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B64107A9F
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 06:40:29 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id bt3so4782466qtb.0
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 06:40:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ts+dK3ttiY6R8zZea2yK4md86bxaZKIr+AquYrk3oLk=;
        b=T4jwBlYZ27/C0gS7bBdNRi5VTaFy92J44Ybzk0KAMHe8N76j3PisechWpbiJ+ucg1U
         YKnlg9x+UG2ZZ1dLdlUW8DhpFGxJTwkOhTrQEzV8y3cPTMPnKFllQnH1dIzJ6Rc6WEU6
         +VabZFESxEvq3xiZZpCMMGdMqB2PsRZGzLJVuT4PH7rZCIVHuZx91YGI2dP2KpctJrqR
         TmtwU30hLrjjDkk53sxc6uSi1Zr9furEM4pVB0ypgU3xIrBI98XltJE3fua6VaLNSA3U
         PQ9cU4e1bhn9uWp7HGulZ43Pq9QYuaMPEiwP2OJVBjeGfnJKqLE9FjcWXNhWDpFB3oDU
         EVog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ts+dK3ttiY6R8zZea2yK4md86bxaZKIr+AquYrk3oLk=;
        b=wOWqWvb88fwz6GtXzJADJL9Zzev+rHG1Ia2al+fMR9S4Z7YPNV7Zza7DS61upxZd2V
         uw+RRBSjXa79AuHvDZ/Z5KdTLaKd1DTRf6Ix5OGN+N2NYRE1Bno84mGrHhvmQbk1Y86L
         /Coc4uyLs5A1Fp3sapbC+vjLexV8pOF9DKyd5WjcP/AHKW7z1+6G8ln10vVCCy5tlfT1
         aq1SaFbwq/9QiaPrw1fahM9j/4xhaIxKC8Zx18d8b4nZc77y68Q4mXkaDZnleKCCuVYA
         aVRJvLSHK5WFmehsZyTXMQsfhf9DI22/H4FXr+avIjP6sX4N1Ht6+4I8EZKVfYVHt9FC
         hRjg==
X-Gm-Message-State: AOAM533gJ8E0cbRJ/1Z5o2OYNzlYNGYxtyZE42XXyBfDOD8Vo3Pdo17K
        nE/W4PojyRCbsNwUYMMhzPCCi4I5ZVE=
X-Google-Smtp-Source: ABdhPJwcXC3U5FkeXD8QS6rbbonfDYDR4WvSeQJwqXRN/BlKpZFVVyYXNQuSUbCouordPofaRh/FDg==
X-Received: by 2002:aed:3169:0:b0:2e1:b92e:7b7 with SMTP id 96-20020aed3169000000b002e1b92e07b7mr70252qtg.211.1646923228344;
        Thu, 10 Mar 2022 06:40:28 -0800 (PST)
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com. [209.85.128.182])
        by smtp.gmail.com with ESMTPSA id w3-20020a05622a190300b002e19fd2d2bcsm3135438qtc.90.2022.03.10.06.40.26
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 06:40:27 -0800 (PST)
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-2d07ae0b1c0so60480507b3.2
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 06:40:26 -0800 (PST)
X-Received: by 2002:a81:594:0:b0:2dc:8978:1d64 with SMTP id
 142-20020a810594000000b002dc89781d64mr4126054ywf.348.1646923225818; Thu, 10
 Mar 2022 06:40:25 -0800 (PST)
MIME-Version: 1.0
References: <20220308000146.534935-1-tadeusz.struk@linaro.org>
 <14626165dad64bbaabed58ba7d59e523@AcuMS.aculab.com> <6155b68c-161b-0745-b303-f7e037b56e28@linaro.org>
 <66463e26-8564-9f58-ce41-9a2843891d1a@kernel.org> <45522c89-a3b4-4b98-232b-9c69470124a3@linaro.org>
 <ff2e1007-5883-5178-6415-326d6ae69c34@kernel.org> <8fdab42f-171f-53d7-8e0e-b29161c0e3e2@linaro.org>
In-Reply-To: <8fdab42f-171f-53d7-8e0e-b29161c0e3e2@linaro.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 10 Mar 2022 09:39:48 -0500
X-Gmail-Original-Message-ID: <CA+FuTSeAL7TsdW4t7=G91n3JLuYehUCnDGH4_rHS=vjm1-Nv9Q@mail.gmail.com>
Message-ID: <CA+FuTSeAL7TsdW4t7=G91n3JLuYehUCnDGH4_rHS=vjm1-Nv9Q@mail.gmail.com>
Subject: Re: [PATCH] net: ipv6: fix invalid alloclen in __ip6_append_data
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     David Ahern <dsahern@kernel.org>,
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

On Wed, Mar 9, 2022 at 4:37 PM Tadeusz Struk <tadeusz.struk@linaro.org> wrote:
>
> On 3/8/22 21:01, David Ahern wrote:
> > On 3/8/22 12:46 PM, Tadeusz Struk wrote:
> >> That fails in the same way:
> >>
> >> skbuff: skb_over_panic: text:ffffffff83e7b48b len:65575 put:65575
> >> head:ffff888101f8a000 data:ffff888101f8a088 tail:0x100af end:0x6c0
> >> dev:<NULL>
> >> ------------[ cut here ]------------
> >> kernel BUG at net/core/skbuff.c:113!
> >> invalid opcode: 0000 [#1] PREEMPT SMP KASAN
> >> CPU: 0 PID: 1852 Comm: repro Not tainted
> >> 5.17.0-rc7-00020-gea4424be1688-dirty #19
> >> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1.fc35
> >> RIP: 0010:skb_panic+0x173/0x175
> >>
> >> I'm not sure how it supposed to help since it doesn't change the
> >> alloclen at all.
> >
> > alloclen is a function of fraglen and fraglen is a function of datalen.
>
> Ok, but in this case it doesn't affect the alloclen and it still fails.

This is some kind of non-standard packet that is being constructed. Do
we understand how it is different?

The .syz reproducer is generally a bit more readable than the .c
equivalent. Though not as much as an strace of the binary, if you
can share that.

r0 = socket$inet6_icmp_raw(0xa, 0x3, 0x3a)
connect$inet6(r0, &(0x7f0000000040)={0xa, 0x0, 0x0, @dev, 0x6}, 0x1c)
setsockopt$inet6_IPV6_HOPOPTS(r0, 0x29, 0x36,
&(0x7f0000000100)=ANY=[@ANYBLOB="52b3"], 0x5a0)
sendmmsg$inet(r0, &(0x7f00000002c0)=[{{0x0, 0x0,
&(0x7f0000000000)=[{&(0x7f00000000c0)="1d2d", 0xfa5f}], 0x1}}], 0x1,
0xfe80)
