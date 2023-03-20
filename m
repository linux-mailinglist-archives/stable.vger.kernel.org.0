Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 774F46C12DA
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 14:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbjCTNNL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 09:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231508AbjCTNNF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 09:13:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3036559C9
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 06:13:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E001BB80D5D
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 13:13:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 542EEC433EF;
        Mon, 20 Mar 2023 13:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679317981;
        bh=nrbWlCxJvFS1/77q21NViPL/FvUhle05+wOwcoU6+K4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sX2RtMZEl43o5ETbXaKhpMRT+gPgOP9osZkghZzBwX5Lpzwuya9EkEbytfWLRH5XW
         WTwUmvpRoXPQTntO5zkZiz5VSXSDexLpqDX+mGagSEqcQ8TCLVDtLRqHhCKXO9FWyp
         Ka+oH7WJu7ZA3SZvEsrGxR/9CN6oBOLTtNxe2vZA=
Date:   Mon, 20 Mar 2023 14:12:59 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     "Borislav Petkov (AMD)" <bp@alien8.de>, patches@lists.linux.dev,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH 4.19 161/252] x86/microcode/amd: Remove
 load_microcode_amd()s bsp parameter
Message-ID: <ZBhb21/xkOC1dyIH@kroah.com>
References: <20230310133718.803482157@linuxfoundation.org>
 <20230310133723.713256658@linuxfoundation.org>
 <e2af9b33fb0f6e22146388a186cf0152abbac629.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2af9b33fb0f6e22146388a186cf0152abbac629.camel@decadent.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 18, 2023 at 02:49:53AM +0100, Ben Hutchings wrote:
> On Fri, 2023-03-10 at 14:38 +0100, Greg Kroah-Hartman wrote:
> > From: Borislav Petkov (AMD) <bp@alien8.de>
> > 
> > commit 2355370cd941cbb20882cc3f34460f9f2b8f9a18 upstream.
> > 
> > It is always the BSP.
> > 
> > No functional changes.
> > 
> 
> Does this not depend on commit 2071c0aeda22 "x86/microcode: Simplify
> init path even more"?  That hasn't been backported to any stable
> branches.

It didn't seem to need it to at least build properly.  And it doesn't
apply to the stable branches, so are you sure it's needed?

thanks,

greg k-h
