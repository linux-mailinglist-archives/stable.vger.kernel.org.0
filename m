Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8975F601B40
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 23:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbiJQV1R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 17:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiJQV1P (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 17:27:15 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 364D07C328;
        Mon, 17 Oct 2022 14:27:13 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id o20-20020a05600c4fd400b003b4a516c479so10958591wmq.1;
        Mon, 17 Oct 2022 14:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qwRCHBhzC1ePrA2xVuOaElAyg+tHeXh5G7LrteKRkTc=;
        b=pGHz4EYxfYH31RHH5LqlpE1DpFNjmTuWCN+gjpeZrklwM5BZU9qlJb1AJxIOYL7msi
         AyFDW6BV8TagNN3OCsMK9clmCMVyARkDrfD8LginpytP2UuwzEF446/bZqiwqjRRuwSx
         wRbgQngb0ZkUnIuGjv5PQMTTpL5CDocb/OfM0K+QucYe5gp68XRADEahJtcYIWuQwUsQ
         EQXiAUOT7Wun8q436ccYaKM/dCAnP7VJoqliuoU76lrM7DcrjnzhOfFFFNNX5S0hOg25
         gd5MEr6VEu/hloGW7EFHp4Ag+9IRXUppoOwIAsr6XJR82IBTZVI44Pl6gg0ArSERgZU0
         H0VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qwRCHBhzC1ePrA2xVuOaElAyg+tHeXh5G7LrteKRkTc=;
        b=mzd/Hi/cy0/rRpq+FBGH2eq5MbmLT8Ac4b/sQC7GThbJ04K9WRX8quTuAVkroVtek/
         0losMiaYEqKcIMPvZVqSicSQg2HHtMq2Izq9Mbx74ccPv97bATliw51Fr2wihPQ7DCjX
         jKFbm9JVIPpvDzJcelUizasBvz/M91uC9wECezY9uIgMkMkbiZDstePcALh8Sw5pkUYi
         KB/Mpp5LeqPDkNhqKdPqcCLySuJOET+a5PDnexlTZdfVLwk9ycSb2nNwf7H/bLTxLDLB
         L3a3vg2JAY+eCceshberkhS/c9+li2R6zGRPjSRax5ktZ6o8p7ebW0woylfERLRQvRLy
         073A==
X-Gm-Message-State: ACrzQf0lqcUn5aa8dfA7jGx8kuHeAtX9vTfXp0h0rgLmGeUn2J+140eC
        l2Ct86RgQg43C0sApZd67UFw5VMMHkQ=
X-Google-Smtp-Source: AMsMyM7P2hieFmHMHkJ9hOldCmaPirxtVZZ+ZMRcOIwSNhwIVq9OvbQFgJl0JWgNoBxf++QAilLFdQ==
X-Received: by 2002:a05:600c:314f:b0:3c6:f27d:fa52 with SMTP id h15-20020a05600c314f00b003c6f27dfa52mr7572805wmo.20.1666042031593;
        Mon, 17 Oct 2022 14:27:11 -0700 (PDT)
Received: from krava ([83.240.63.167])
        by smtp.gmail.com with ESMTPSA id c188-20020a1c35c5000000b003b4a68645e9sm16643876wma.34.2022.10.17.14.27.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 14:27:11 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Mon, 17 Oct 2022 23:27:07 +0200
To:     Nathan Chancellor <nathan@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     Jiri Olsa <olsajiri@gmail.com>, stable@vger.kernel.org,
        bpf@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Rodriguez Reboredo <yakoyoku@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: Re: [PATCH stable 5.15 0/2] kbuild: Fix compilation for latest
 pahole release
Message-ID: <Y03Iq2GiS7XfhOxL@krava>
References: <20220904131901.13025-1-jolsa@kernel.org>
 <YxSxwZWkYMmtcsmA@kroah.com>
 <YxWfaoImsdcvkbce@krava>
 <Yxc3Er1sv17xrei1@kroah.com>
 <YyeYUEHyR/nHM8NT@krava>
 <Y02Yv/ubuCtVhtZk@dev-arch.thelio-3990X>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y02Yv/ubuCtVhtZk@dev-arch.thelio-3990X>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 17, 2022 at 11:02:39AM -0700, Nathan Chancellor wrote:
> On Mon, Sep 19, 2022 at 12:14:40AM +0200, Jiri Olsa wrote:
> > On Tue, Sep 06, 2022 at 02:03:30PM +0200, Greg KH wrote:
> > > On Mon, Sep 05, 2022 at 09:04:10AM +0200, Jiri Olsa wrote:
> > > > On Sun, Sep 04, 2022 at 04:10:09PM +0200, Greg KH wrote:
> > > > > On Sun, Sep 04, 2022 at 03:18:59PM +0200, Jiri Olsa wrote:
> > > > > > hi,
> > > > > > new version of pahole (1.24) is causing compilation fail for 5.15
> > > > > > stable kernel, discussed in here [1][2]. Sending fix for that plus
> > > > > > one dependency patch.
> > > > > > 
> > > > > > Note for patch 1:
> > > > > > there was one extra line change in scripts/pahole-flags.sh file in
> > > > > > its linux tree merge commit:
> > > > > > 
> > > > > >   fc02cb2b37fe Merge tag 'net-next-for-5.16' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next
> > > > > > 
> > > > > > not sure how/if to track that, I squashed the change in.
> > > > > 
> > > > > Squashing is fine, thanks.
> > > > > 
> > > > > And do we also need this for kernels older than 5.15?  Like 5.10 and 5.4?
> > > > 
> > > > yes, 5.10 needs similar patchset, but this for 5.15 won't apply there,
> > > > so I'll send it separately
> > > > 
> > > > 5.4 passes compilation, but I don't think it will boot properly, still
> > > > need to check on that
> > > > 
> > > > in any case, more patches are coming ;-)
> > > 
> > > Ok, these two are now queued up, feel free to send the rest when you
> > > have them ready.
> > 
> > hi,
> > as for 5.10 changes, I have them ready, pushed in here:
> >   git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git pahole_fix_5_10
> > 
> > but it looks like CONFIG_DEBUG_INFO_BTF is not being used in 5.10,
> > because I had to backport other similar option, that would break
> > the build even earlier (--skip_encoding_btf_vars), or people use
> > just old pahole ;-)
> > 
> > I suggest we wait with this change until somebody actually wants
> > this fixed, AFAICS there's no report of broken 5.10 build yet
> 
> Consider this your first report :)

va bene ;-)

> 
> My build containers include the latest pahole, as I have noticed more
> issues with older pahole in newer kernels than newer pahole in older
> kernels, as least until now. I have tripped over this issue on both 5.19
> and 5.10, as the stable-only commit b775fbf532dc ("kbuild: Add
> skip_encoding_btf_enum64 option to pahole") was only applied to 5.15,
> even though it is needed in all kernels prior to 6.0.
> 
> Please consider explicitly sending the 5.10 series to stable and

sure I'll rebase and post it

> requesting b775fbf532dc to be applied to 5.19.

hm, it was already posted for 5.19:
https://lore.kernel.org/bpf/20220916171234.841556-1-yakoyoku@gmail.com/

Greg,
is there something missing for it to be taken?

thanks,
jirka
