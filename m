Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDE2A6A0507
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 10:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233424AbjBWJhi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 04:37:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233897AbjBWJhe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 04:37:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF4F4AFC5
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 01:37:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D0136163B
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 09:37:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54C8FC4339B;
        Thu, 23 Feb 2023 09:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677145021;
        bh=FsDdPdeADa/dqaCNSu1qjCoNHhQZNiX3ppkzoDbvnJE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RrkBLG8y7KMkhQ+Nxmhf/FcXU+EXupfApBITy8tpc74l86kTRURNcUYa8iALdC0JD
         iaUeJTtcyTLK2/owReFEPMqAqP+zNTbxhRozrAdecd8k2LSpQ4ZlLEpE09J3IforMJ
         HAwN3Xsq96csGQHG8aeS4zjtSqitxFuP8Q4QiKS0=
Date:   Thu, 23 Feb 2023 10:36:59 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lee Jones <lee@kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 0/5] binder: Apply 4 missing stable fixes into v5.15.y
Message-ID: <Y/czu9EA+kFyyAtJ@kroah.com>
References: <20230222121208.898198-1-lee@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230222121208.898198-1-lee@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 22, 2023 at 12:12:03PM +0000, Lee Jones wrote:
> These patches are present in all other Stable versions.
> 
> Alessandro Astone (2):
>   binder: Address corner cases in deferred copy and fixup
>   binder: Gracefully handle BINDER_TYPE_FDA objects with num_fds=0
> 
> Arnd Bergmann (1):
>   binder: fix pointer cast warning
> 
> Todd Kjos (2):
>   binder: read pre-translated fds from sender buffer
>   binder: defer copies of pre-patched txn data
> 
>  drivers/android/binder.c | 343 +++++++++++++++++++++++++++++++++++----
>  1 file changed, 313 insertions(+), 30 deletions(-)
> 
> -- 
> 2.39.2.637.g21b0678d19-goog
> 

Now queued up, thanks.

greg k-h
