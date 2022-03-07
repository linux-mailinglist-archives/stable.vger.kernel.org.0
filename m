Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2B684CF3C8
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 09:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbiCGIjj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 03:39:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230349AbiCGIji (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 03:39:38 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F06192B1
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 00:38:44 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id t11so21967291wrm.5
        for <stable@vger.kernel.org>; Mon, 07 Mar 2022 00:38:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=zSk/nCl6TFShqGWoq2qqfHAEfnDoTYHWiBVsHmiHIig=;
        b=dbwJXHMxwep7nHzyPkxQmHJG0KdeAnPzgc8CQITPn4OEddKsrUHnd04EAuxHmMOwTz
         Z9r9jYdx3kIpkBLGp9xU6X8EI0IqIk4JhNn4X2RU6bkya0N8KSreJ9OSNVG5YVLIKeuD
         VuhDAeQAI4jNU52tOQj9NwMkadxYHfzbbw3hwpWBmA+3KsidiztTlfvTEWJFhFNEqWPk
         bb1ylBXxmt6KWnQbSPHnm6IcPfsvvtuFR6YT2vfvuA5HE8H/Irk2uUjdCKuzMbDiv48z
         e3Mb6aYMdFK00BUXjB+jhl4jc6tIOQm7AuN0EyC5ZaAdBz/xMwKXdpcz6022KB8SxQUR
         fnbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=zSk/nCl6TFShqGWoq2qqfHAEfnDoTYHWiBVsHmiHIig=;
        b=BQ/123sUylPYhPgE10ICZ9aMv/VKuxXN2tPquEVMFP0rk0HeWPwOXblnKvmKz1Ysxi
         C52DFUGeLt1//hnNme27Fe9BNrLAosVPbdw3+4zNCVGAK1sNPWx+JZDDUvMsW7RWUFFu
         dBWMjregRhgWT8WmZoRCDLCC7jHuhHnYIMDKIdVYzYw8mfZEQrgONYCL0gcHoStefDVG
         8f7s9Sd5EUnMrUVYgf5Pw8WM6RkAhy+6qQlTbY6pvLrWj6jvJiRHbIF19o36NYvSaAPo
         f40OVBbbkrUb5mZW9fOIKRumrNagMk4Kph8m+dC1P8KsAIH87mdLrqbzovLPnlNMCkQ/
         hUgQ==
X-Gm-Message-State: AOAM530To7HNrG4ZMcmfDfCV8VahLw8hYnKYbsxrshQhuDPXcTXDm/Nt
        Mh1FrBVSe5NyY9Alhaup6UKAaDVio2otvw==
X-Google-Smtp-Source: ABdhPJytNOIbJuPj89Z/UPhjzJgmkJrJ6BMU67o4AIuMkjXk3J12JM4LhTS5f924pdzklwliHqiYGg==
X-Received: by 2002:a5d:6d87:0:b0:1f1:f828:3ee1 with SMTP id l7-20020a5d6d87000000b001f1f8283ee1mr2907062wrs.221.1646642323057;
        Mon, 07 Mar 2022 00:38:43 -0800 (PST)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id p12-20020a056000018c00b001f079518150sm7452396wrx.93.2022.03.07.00.38.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 00:38:42 -0800 (PST)
Date:   Mon, 7 Mar 2022 08:38:40 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] bpf: Fix toctou on read-only map's
 constant scalar tracking" failed to apply to 5.4-stable tree
Message-ID: <YiXEkEC/hzcJ5VIq@google.com>
References: <163757721744154@kroah.com>
 <Yg5wY5FKj0ikiq+A@google.com>
 <Yg51IuzfMnU8Uo6v@kroah.com>
 <Yg6AbfbFgDqbhq0e@google.com>
 <YhNg4uM1gIN89B7U@google.com>
 <YhNoZy415MYPH+GR@kroah.com>
 <YhNtE/sIdv5OkBQT@google.com>
 <f01b6557-ed8f-1385-c5f6-95f73b940b7f@iogearbox.net>
 <577A5957-B1ED-41D8-A17C-227E15C23925@gmail.com>
 <YiNqtoeFno9LxaRF@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YiNqtoeFno9LxaRF@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 05 Mar 2022, Greg KH wrote:

> On Tue, Mar 01, 2022 at 07:04:40PM -0300, Rafael David Tinoco wrote:
> > 
> > >> The bad-commit mentioned in "the Fixes tag":
> > >> Fixes: a23740ec43ba ("bpf: Track contents of read-only maps as scalars")
> > >> Which as you say, could well have been fixing another issue.
> > >> In fact, yes it was:
> > >> https://lore.kernel.org/stable/20210821203108.215937-2-rafaeldtinoco@gmail.com/
> > >> Daniel, what do you suggest please?
> > > 
> > > Hm, okay, so a23740ec43ba ("bpf: Track contents of read-only maps as scalars") was
> > > backported to 5.4.144 given Rafael needed it to fix a failing regression test [0].
> > > 
> > > Normally, I would have said that we should just revert a23740ec43ba given it was
> > > not a 'fix' in the first place, but then we are getting into a situation where it
> > > would break Rafael's now functioning test case again on 5.4.144+ released kernels.
> > > 
> > 
> > IIRC, Without this patch, eBPF programs with extern variables, either from ksyms
> > or kconfig relocations, done by libbpf, used as branch conditions, won't work in
> > <= 5.4.144.
> > 
> > Something like:
> > 
> > extern u32 CONFIG_ARCH_HAS_SYSCALL_WRAPPER __kconfig;
> > ...
> > if (CONFIG_ARCH_HAS_SYSCALL_WRAPPER) {
> >    valid BTF type declared/used
> > } else {
> >    <dead code>: invalid BTF type declared/used
> > }
> > ...
> > 
> > The dead code is always evaluated and object load does not pass the verifier.
> > 
> > The workaround to mitigate this is to always rely in type/field existence checks
> > for the branch conditions, instead of relying in kconfig/ksyms relocations.
> > 
> > We've been doing this to support same CO-RE BPF obj in kernels < 5.4 so I guess
> > we could continue doing this for 5.4 as well (allowing you to drop this "fix").
> > 
> > Sorry for the burden (about having to introduce another fix, needed because of
> > that patch). I hope nobody else is relying on it and, if they are, there is a
> > mitigation described above.
> > 
> > So, feel free to drop it if it's easier for 5.4 maintenance, I'll mitigate
> > code on our side.

Thanks Rafael.  I really appreciate it.

> Thanks for the info.
> 
> Lee, can you make up a revert patch for 5.4 with the above information
> in it so that I can queue it up?

Sure, I'll add it to my TODO.

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
