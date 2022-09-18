Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E03A5BC055
	for <lists+stable@lfdr.de>; Mon, 19 Sep 2022 00:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbiIRWOs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Sep 2022 18:14:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiIRWOr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Sep 2022 18:14:47 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE59636C;
        Sun, 18 Sep 2022 15:14:44 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id go34so60596879ejc.2;
        Sun, 18 Sep 2022 15:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date;
        bh=kbFSMhiL8A86s0CsON/rdR0Gz4dPoVS/1Hb74JYxBe0=;
        b=qN7F4qLWDb/treWv4SofmpVJ1tf6axhjm68wXDbUP4ws6tWJSqFmTGSfjgQXR4N/ij
         +3oNkf1i4fxSuDQvW7lcrMxVX5QIp8/sLz9daRG4ZX+3rFeOuPgGubfx13jWI4kkS7ES
         MSuSeJtFAjDQ8ZFKQLMuuMG/dCvTaSeBzx+u6Ak/HQB2F8zBuZtGH4JE9eKRqgqwpg5l
         6tcKm3FjCIpOTXMJxodj3RYcU33o8P3VVcjpVTFPkvVHihKekq07mp4xmOC8/SFL/QSc
         QNmfeCDNth0vz7i7HZHqpQL29LThSbhitU6yTRnUlGRMeV3j5RwQxi+4l15kB6+2jeJy
         gXsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date;
        bh=kbFSMhiL8A86s0CsON/rdR0Gz4dPoVS/1Hb74JYxBe0=;
        b=Dk/cOEAQu24ZZMW8TGdDi3+tbU1IoY2NxLZEhhIGEjUAJTUE8DWQeCFYalxN6wPnWG
         x8taicjk/oPdgOpdNyFmxEgvN9/+VPaasrS1GlQAduVey5QJatkrbZXs5NlozQMPKbiC
         sKck/KthqEMxg+XGP8ZJ2/9usn0mdMNSuS+TX0IUHjORZCGnZhva2WRyJmIHzgvzdXht
         fLUTOxRTUx9NFDNq1cO1kYZYr29CKIdvdFXqetEjU9iQbfJsKb7uIuzzKxjFSDr3xRtq
         cFIQUJKN9uWtnq9UGyen1zI2PzlgzQtwWsomPpNvcbL9q04JL24SCXBe7MKB3WtvpgWB
         byfQ==
X-Gm-Message-State: ACrzQf03syRldnWWIvOPgBbsPinY8PdtDZAADMooEYS2KFsse0W6zQCC
        fG19zyfQQIuMtrorqnD/jUo=
X-Google-Smtp-Source: AMsMyM73ksJk5qUmITb9v+gtvMEIARvdQ89ffmHDN/PQxwjdGuOeYkz0xweZ0fR1OZQhjaznuy/Jkw==
X-Received: by 2002:a17:906:cc14:b0:779:8ae0:eece with SMTP id ml20-20020a170906cc1400b007798ae0eecemr10580874ejb.418.1663539282790;
        Sun, 18 Sep 2022 15:14:42 -0700 (PDT)
Received: from krava ([83.240.61.0])
        by smtp.gmail.com with ESMTPSA id pw17-20020a17090720b100b00780348931e7sm7757760ejb.75.2022.09.18.15.14.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Sep 2022 15:14:42 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Mon, 19 Sep 2022 00:14:40 +0200
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Jiri Olsa <olsajiri@gmail.com>, stable@vger.kernel.org,
        bpf@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Rodriguez Reboredo <yakoyoku@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: Re: [PATCH stable 5.15 0/2] kbuild: Fix compilation for latest
 pahole release
Message-ID: <YyeYUEHyR/nHM8NT@krava>
References: <20220904131901.13025-1-jolsa@kernel.org>
 <YxSxwZWkYMmtcsmA@kroah.com>
 <YxWfaoImsdcvkbce@krava>
 <Yxc3Er1sv17xrei1@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yxc3Er1sv17xrei1@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 06, 2022 at 02:03:30PM +0200, Greg KH wrote:
> On Mon, Sep 05, 2022 at 09:04:10AM +0200, Jiri Olsa wrote:
> > On Sun, Sep 04, 2022 at 04:10:09PM +0200, Greg KH wrote:
> > > On Sun, Sep 04, 2022 at 03:18:59PM +0200, Jiri Olsa wrote:
> > > > hi,
> > > > new version of pahole (1.24) is causing compilation fail for 5.15
> > > > stable kernel, discussed in here [1][2]. Sending fix for that plus
> > > > one dependency patch.
> > > > 
> > > > Note for patch 1:
> > > > there was one extra line change in scripts/pahole-flags.sh file in
> > > > its linux tree merge commit:
> > > > 
> > > >   fc02cb2b37fe Merge tag 'net-next-for-5.16' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next
> > > > 
> > > > not sure how/if to track that, I squashed the change in.
> > > 
> > > Squashing is fine, thanks.
> > > 
> > > And do we also need this for kernels older than 5.15?  Like 5.10 and 5.4?
> > 
> > yes, 5.10 needs similar patchset, but this for 5.15 won't apply there,
> > so I'll send it separately
> > 
> > 5.4 passes compilation, but I don't think it will boot properly, still
> > need to check on that
> > 
> > in any case, more patches are coming ;-)
> 
> Ok, these two are now queued up, feel free to send the rest when you
> have them ready.

hi,
as for 5.10 changes, I have them ready, pushed in here:
  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git pahole_fix_5_10

but it looks like CONFIG_DEBUG_INFO_BTF is not being used in 5.10,
because I had to backport other similar option, that would break
the build even earlier (--skip_encoding_btf_vars), or people use
just old pahole ;-)

I suggest we wait with this change until somebody actually wants
this fixed, AFAICS there's no report of broken 5.10 build yet

thanks,
jirka
