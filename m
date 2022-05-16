Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2F8528463
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 14:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbiEPMnb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 08:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231545AbiEPMn3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 08:43:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D4FD38BD7
        for <stable@vger.kernel.org>; Mon, 16 May 2022 05:43:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1BA65B81109
        for <stable@vger.kernel.org>; Mon, 16 May 2022 12:43:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67BA0C385AA;
        Mon, 16 May 2022 12:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652705005;
        bh=PY4+jtlBhAu/UJK0+CHdTA0+ffrLuQMNiJfCAMMIMao=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qLSri2fslZfc+MnXMsS0ZzP2AzO9dnhIyfZkJeCS5DJkQj9k5sJoDFZeLOEpuUGsJ
         5jy95CEK6zw9zCx/jf0ZcSNJBtduLJlUh+g/9gTMoXQRJlYEEtAGG1X+gzb4Zguf7V
         FxMakaQ0WWoVprexQmRp1MlnHpYqeuJGpiKgU6p0=
Date:   Mon, 16 May 2022 14:43:22 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     Meena Shanmugam <meenashanmugam@google.com>,
        enrico.scholz@sigma-chemnitz.de, stable@vger.kernel.org,
        trond.myklebust@hammerspace.com,
        Dexter Rivera <riverade@google.com>
Subject: Re: [PATCH 0/4] Request to cherry-pick f00432063db1 to 5.10
Message-ID: <YoJG6nZrfKFb3Exr@kroah.com>
References: <Yn82ZO/Ysxq0v/0/@kroah.com>
 <20220514053453.3277330-1-meenashanmugam@google.com>
 <Yn9sqjJsnsLznmoq@debian.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yn9sqjJsnsLznmoq@debian.me>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 14, 2022 at 03:47:38PM +0700, Bagas Sanjaya wrote:
> On Sat, May 14, 2022 at 05:34:49AM +0000, Meena Shanmugam wrote:
> > The commit f00432063db1a0db484e85193eccc6845435b80e upstream (SUNRPC:
> > Ensure we flush any closed sockets before xs_xprt_free()) fixes
> > CVE-2022-28893, hence good candidate for stable trees.
> > The above commit depends on 3be232f(SUNRPC: Prevent immediate
> > close+reconnect)  and  89f4249(SUNRPC: Don't call connect() more than
> > once on a TCP socket). Commit 3be232f depends on commit
> > e26d9972720e(SUNRPC: Clean up scheduling of autoclose).
> > 
> > Commits e26d9972720e, 3be232f, f00432063db1 apply cleanly on 5.10
> > kernel. commit 89f4249 didn't apply cleanly. This patch series includes
> > all the commits required for back porting f00432063db1.
> > 
> 
> Hi Meena,
> 
> I can't speaking about the code (as I'm not subject-expert here), but I
> would like to give you suggestions:
> 
>   - When sending backported patch series, always prefix the subject with
>     "[PATCH x.y]", where x.y is the stable version the backport is made
>     against.
>   - Abbreviated commit hash should be at least 12 (or my favorite, 14) characters long.
>   - Commit identifier should be in format "%h (\"%s\")".
>   - As always, DON'T DO top-posting, DO interleaved reply and reply
>     below the quoted original message.

Yes, that would have been better, but I figured it out from this series,
it wasn't that hard.

Now all queued up, thanks!

greg k-h
