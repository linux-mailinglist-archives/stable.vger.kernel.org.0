Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4078551F70E
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 10:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237638AbiEIIqq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 04:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237232AbiEIIgO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 04:36:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAA0B7892F
        for <stable@vger.kernel.org>; Mon,  9 May 2022 01:32:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45A0A614AD
        for <stable@vger.kernel.org>; Mon,  9 May 2022 08:32:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11EBCC385A8;
        Mon,  9 May 2022 08:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652085139;
        bh=96Tn4v/Ig3hiVPDhy4/b1A9631RctSnB5Z6FKJI65UE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Em3J27ugKUvEy+6SWBO4zKzw9iCVTrBg6izmtzTZubWxlD9I+AqbxYDGw+a2fqUcv
         KC3fG1GjUpO/FCX+tDAtRVwh3TnV6qugo/NSB1SNRh7z83jF3aN8aFC49T6Znvv/JU
         Jepy8CVOedGS+OtYcSDYLn3cwXS9LUDPnz/j31rw=
Date:   Mon, 9 May 2022 10:32:16 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Trond Myklebust <trondmy@hammerspace.com>
Cc:     "sashal@kernel.org" <sashal@kernel.org>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: Please do not apply 892de36fd4a9 ("SUNRPC: Ensure gss-proxy
 connects on setup")
Message-ID: <YnjRkOsRqKiwOlMz@kroah.com>
References: <ac5fa5c1d6eb33628bb528d1e67dc5a45fd7151c.camel@hammerspace.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac5fa5c1d6eb33628bb528d1e67dc5a45fd7151c.camel@hammerspace.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 08, 2022 at 02:56:54PM +0000, Trond Myklebust wrote:
> Hi Greg and Sasha,
> 
> 
> Just a heads up that Bruce Fields found a problem with one of the
> patches in this week's NFS client pull that was marked for stable patch
> inclusion.
> The patch in question is commit 892de36fd4a9 ("SUNRPC: Ensure gss-proxy
> connects on setup"). I'm planning on reverting it in Linus' tree and I
> have a different fix that is queued up and that will replace this one.
> 
> Hope this catches you before you've gone to the trouble of queuing it
> up...

Now dropped, thanks for letting us know.

greg k-h
