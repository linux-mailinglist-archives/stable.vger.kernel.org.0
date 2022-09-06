Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 748FA5AE727
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 14:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234492AbiIFMDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 08:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234364AbiIFMDg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 08:03:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD86472ED8;
        Tue,  6 Sep 2022 05:03:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D52BB8188B;
        Tue,  6 Sep 2022 12:03:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D80C433D6;
        Tue,  6 Sep 2022 12:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662465813;
        bh=D6q2zVdnbW/3WWDT0MGCTg+K/78osrhcMbdDthvz3O0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gGbbCwREJv+DOvhS3ZLFMLZ34yHgH9NyN30D91EzLRGd1TBajQK3LcsMIHt/NRSHV
         WU5d7Ql7jvLzaSqErM6/vUSTtIEhLW32iGIPsonssOPrCBq5LQyO4HLohTySmjT4/a
         92H3Aq64aVlmSYPkPHfLXMsaKrZ8z6/RxYYp2h5g=
Date:   Tue, 6 Sep 2022 14:03:30 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     stable@vger.kernel.org, bpf@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Rodriguez Reboredo <yakoyoku@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: Re: [PATCH stable 5.15 0/2] kbuild: Fix compilation for latest
 pahole release
Message-ID: <Yxc3Er1sv17xrei1@kroah.com>
References: <20220904131901.13025-1-jolsa@kernel.org>
 <YxSxwZWkYMmtcsmA@kroah.com>
 <YxWfaoImsdcvkbce@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxWfaoImsdcvkbce@krava>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 05, 2022 at 09:04:10AM +0200, Jiri Olsa wrote:
> On Sun, Sep 04, 2022 at 04:10:09PM +0200, Greg KH wrote:
> > On Sun, Sep 04, 2022 at 03:18:59PM +0200, Jiri Olsa wrote:
> > > hi,
> > > new version of pahole (1.24) is causing compilation fail for 5.15
> > > stable kernel, discussed in here [1][2]. Sending fix for that plus
> > > one dependency patch.
> > > 
> > > Note for patch 1:
> > > there was one extra line change in scripts/pahole-flags.sh file in
> > > its linux tree merge commit:
> > > 
> > >   fc02cb2b37fe Merge tag 'net-next-for-5.16' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next
> > > 
> > > not sure how/if to track that, I squashed the change in.
> > 
> > Squashing is fine, thanks.
> > 
> > And do we also need this for kernels older than 5.15?  Like 5.10 and 5.4?
> 
> yes, 5.10 needs similar patchset, but this for 5.15 won't apply there,
> so I'll send it separately
> 
> 5.4 passes compilation, but I don't think it will boot properly, still
> need to check on that
> 
> in any case, more patches are coming ;-)

Ok, these two are now queued up, feel free to send the rest when you
have them ready.

thanks,

greg k-h
