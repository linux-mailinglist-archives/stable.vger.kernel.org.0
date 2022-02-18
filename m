Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB09D4BC252
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 22:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239732AbiBRVwG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 16:52:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237945AbiBRVwF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 16:52:05 -0500
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E12D25CA
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 13:51:48 -0800 (PST)
Received: by mail-oo1-xc36.google.com with SMTP id e19-20020a4ab993000000b0031a98fe3a9dso5156030oop.6
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 13:51:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:from:user-agent:date:message-id
         :subject:to:cc;
        bh=qF5EIclI3V2fMBOum9cT4Iu+DN033w14IGZaixJ6S2I=;
        b=D/ac7YcklAy8WatxbEMxcHETIGsukHXmQHfUEcFN5D+idnTM0uYCsob53ay654m+4m
         J+2buoPoRRUAtO2xfJOzs5AXDEvurjh6GIOojekxy3OrEtxFzKrMcf9kIdiVMHI9Jim2
         11UWcpqbgb85g0pSLzxncGQCLms3ya+GpfxM8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:in-reply-to:references:from
         :user-agent:date:message-id:subject:to:cc;
        bh=qF5EIclI3V2fMBOum9cT4Iu+DN033w14IGZaixJ6S2I=;
        b=U8/UEJaC7/60q4piqQATGTSLX9u4v/Xuw7rLecTKCDn/Ej3KvQefWR5fNBoGZOTjhn
         Kb7cNYsdKpWsMH+TDe6Kn4KIFRA4ctVDG1WzStIrr5/O76scvK3Q05uQW2QxMjw2NbJV
         BSzQqLQnbZmBVH044k+GUnxzT27Nmzm19O7YARyHODJdw9Hbo62q5TNgByWzFRAYb+fF
         XDJe3IY+wYq6HvxM7sUzcQvvBpFCpdFGrDJt+ad+1sjF7BMMjatfG9UcfIayRbbwrcee
         lNmR/mwRkoLOIJz1aCdmT3flZ06liYqxmQNuYIVgW5UUWOZBDdFY7VsAZNyY3mmGq3DP
         MoSQ==
X-Gm-Message-State: AOAM533DK0OfdgNVgBUVm1lgZoh0vOZej6aDUOSBlWsHi59QlFj9kmD3
        RCDXRRW+NCliGO2KVUOOTwbnwJG+vCiC+auRj8wc2w==
X-Google-Smtp-Source: ABdhPJwMxCI/Z7dmS05M1Aj9+bqiCKtnfj3IiodUzQOzI794MKxZH+WD6u1uQUtH/sudiUaqYp3Gsod9SKiJ7ZzKzfY=
X-Received: by 2002:a05:6870:631a:b0:d1:7d97:806 with SMTP id
 s26-20020a056870631a00b000d17d970806mr3498642oao.8.1645221107620; Fri, 18 Feb
 2022 13:51:47 -0800 (PST)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 18 Feb 2022 13:51:47 -0800
MIME-Version: 1.0
In-Reply-To: <Yg9gb4qXyPVyE60W@kroah.com>
References: <CAE-0n53cOFJFOOV-YOc0MzbiLr9FvaJw=ucs2SNNGOeznYzVLw@mail.gmail.com>
 <Yg9gb4qXyPVyE60W@kroah.com>
From:   Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date:   Fri, 18 Feb 2022 13:51:46 -0800
Message-ID: <CAE-0n510j3=h16Xp98dsBj8MkkP+cfpaEz+_WBuPTxyWxyWZvQ@mail.gmail.com>
Subject: Re: arm64 ftrace fixes for v5.4.y
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Greg KH (2022-02-18 01:01:35)
> On Thu, Feb 17, 2022 at 05:27:33PM -0800, Stephen Boyd wrote:
> > Hi stable maintainers,
> >
> > I recently ran into an issue where trying to load a module with jump
> > table entries crashes the system when function tracing is enabled. The
> > crash happens because ftrace is modifying the code and then marking it
> > as read-only too early. ftrace_make_call() calls module_enable_ro(mod,
> > true) before module init is over because ftrace_module_enable() calls
> > __ftrace_replace_code() which does FTRACE_UPDATE_MAKE_CALL. All this
> > code is gone now upstream but is still present on v5.4 stable kernels. I
> > picked this set of patches to v5.4 and it fixed it for me.
> >
> > fbf6c73c5b26 ftrace: add ftrace_init_nop()
> > a1326b17ac03 module/ftrace: handle patchable-function-entry
> > bd8b21d3dd66 arm64: module: rework special section handling
> > f1a54ae9af0d arm64: module/ftrace: intialize PLT at load time
>
> These all apply just fine, thanks.

Cool, thanks!

>
> > after doing that I ran into another issue because I'm using clang. Would
> > it be possible to pick two more patches to the stable tree to silence
> > this module warning from sysfs complaining about
> > /module/<modname>/sections/__patchable_function_entries being
> > duplicated?
> >
> > dd2776222abb kbuild: lto: merge module sections
> > 6a3193cdd5e5 kbuild: lto: Merge module sections if and only if
> > CONFIG_LTO_CLANG is enabled
>
> These two do not apply to the 5.4.y branch, as the file they touch is
> not present in 5.4.y.  They do apply to 5.10.y, so I've queued them up
> there, but I think you need to provide a working backport please.

Ok. Good news! They're not necessary. I looked further and found that I
had originally picked the entire arm64 series, including commit
3b23e4991fb6 ("arm64: implement ftrace with regs"). Then I ran into the
problem where __patchable_function_entries wasn't being combined by the
linker script. I picked those extra lto patches and it fixed it. Then I
peeled away the new ftrace with regs feature because they were big and
scary and not necessary. Now I've narrowed it down to only needing the
one line from the first lto patch:

  __patchable_function_entries : { *(__patchable_function_entries) }

in combination with the ftrace with regs support.

Long story short, they aren't needed unless commit 3b23e4991fb6 ("arm64:
implement ftrace with regs") is picked, which isn't needed because we
don't need that feature, just the part where we initialize PLT at load
time and stop patching the code up too early, mistakenly enabling RO
protection before the module is done being formed.
