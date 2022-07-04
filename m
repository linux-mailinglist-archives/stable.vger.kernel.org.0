Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFA9B5658F1
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 16:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234301AbiGDOwl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 10:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234294AbiGDOwk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 10:52:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD500FF7
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 07:52:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83249B81091
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 14:52:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1E2FC341C7;
        Mon,  4 Jul 2022 14:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656946357;
        bh=LIYr9+dvUPXHdqT57p+QLfFXRhEoMDsFddMZtxJOwQw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TEj+veg8Ns/HOQMd5827fiNjKDfi9hkTTGO+KliDeinMA9axI/rLwZgxqAwFDBIwX
         GE655zV5svDtt4tKZuyOkfFmOQNUp2JhGId6qJIusWuDmzyBZDQ2RQf6cvvM4h0+L8
         t02R5wSQ+YrYkgTLPyprkSqU2eN8UCHCfqNKs6Z0=
Date:   Mon, 4 Jul 2022 16:52:34 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Juergen Gross <jgross@suse.com>
Cc:     Demi Marie Obenour <demi@invisiblethingslab.com>,
        stable@vger.kernel.org,
        Xen developer discussion <xen-devel@lists.xenproject.org>
Subject: Re: Hopefully correct backports for gntdev deadlock
Message-ID: <YsL+sntDIAtkruRb@kroah.com>
References: <20220701000951.5072-1-demi@invisiblethingslab.com>
 <a66f85f9-6182-ea1e-bb9b-18ac04d0ecea@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a66f85f9-6182-ea1e-bb9b-18ac04d0ecea@suse.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 04, 2022 at 03:46:12PM +0200, Juergen Gross wrote:
> On 01.07.22 02:09, Demi Marie Obenour wrote:
> > This backports "xen/gntdev: Avoid blocking in unmap_grant_pages()" to
> > the various stable trees, hopefully correctly.
> > 
> 
> I have reviewed all backports and they seem correct to me.
> 
> Greg, I'm fine with you adding the backports to the related stable
> branches.

Thanks, now queued up.

greg k-h
