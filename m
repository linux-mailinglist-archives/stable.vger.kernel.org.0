Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 499275A0FC9
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 14:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239611AbiHYMAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 08:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240886AbiHYL7x (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 07:59:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D36DF94
        for <stable@vger.kernel.org>; Thu, 25 Aug 2022 04:59:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0238161B0B
        for <stable@vger.kernel.org>; Thu, 25 Aug 2022 11:59:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F096DC433C1;
        Thu, 25 Aug 2022 11:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661428789;
        bh=Un8QnMW2xwfYHDUa3vuOblHRI1W6EfXD97D4I8mMKG0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RbHjAyygp05xLVbWlk4Zv9bxHJVeH0d7atxdq/XfODGtCl8HFJ4WGGTCEHk+KRL05
         qqVWWx6nObT5+C88q65frzELhv0R/0/Bhx63UWuFWqMNusIekMm2WYasFvuEHeEWdE
         /JtIP+P1pHdSm0eCawcVkBNFsZjiKUVdW+ulygK4=
Date:   Thu, 25 Aug 2022 13:59:46 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Juergen Gross <jgross@suse.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
Subject: Re: Backport request
Message-ID: <YwdkMkAPC4tzsoT2@kroah.com>
References: <f02f8fb3-2e68-a405-aaef-adc769754bd3@suse.com>
 <YwYVIgnHnKUnoChu@kroah.com>
 <1199e064-3311-09cd-283f-d74d5f5c48e3@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199e064-3311-09cd-283f-d74d5f5c48e3@suse.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 24, 2022 at 03:52:27PM +0200, Juergen Gross wrote:
> On 24.08.22 14:10, Greg Kroah-Hartman wrote:
> > On Wed, Aug 24, 2022 at 01:20:22PM +0200, Juergen Gross wrote:
> > > Hi Greg,
> > > 
> > > stable kernels 5.18 and 5.15 seem to be missing upstream patch
> > > c64cc2802a78 ("x86/entry: Move CLD to the start of the idtentry macro").
> > > This is a prerequisite patch for 64cbd0acb582 ("x86/entry: Don't call
> > > error_entry() for XENPV"), which is included in 5.15.y and 5.18.y.
> > > 
> > > Could you please take c64cc2802a78 for 5.15 and 5.18?
> > 
> > 5.18 is end-of-life, so that's impossible to do now :(
> > 
> > For 5.15.y, the commit does not apply cleanly, can you provide a working
> > backport?
> 
> Attached.

Thanks, now queued up.

greg k-h
