Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2695F5320
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 13:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbiJELF5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 07:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbiJELFz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 07:05:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A4876756
        for <stable@vger.kernel.org>; Wed,  5 Oct 2022 04:05:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06074615FE
        for <stable@vger.kernel.org>; Wed,  5 Oct 2022 11:05:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 137B2C433D6;
        Wed,  5 Oct 2022 11:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664967950;
        bh=ST3O7InNIYnJDn9CjMj0wyBDDpCSw40CXOEvyieD8Y4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PbKidC22UjojlpFJ6b0nLAx1jaCWETMB6l2disKA6lqUZctv+Ig7goP/abUQRO83m
         2UTZJJ8K66C0BksSNVSAl2nOG4V50wQU69rfrD/D3E9HVOGxp3/+ZMQdUwQQ1GLlqO
         5EqopnQwrFytlexXfaQ5JVVP+rqZY/EFBp/CLa3c=
Date:   Wed, 5 Oct 2022 13:05:47 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Borislav Petkov <bp@suse.de>
Cc:     ssengar@linux.microsoft.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/cacheinfo: Add a
 cpu_llc_shared_mask() UP variant" failed to apply to 5.15-stable tree
Message-ID: <Yz1lC0ol1lhhnIn+@kroah.com>
References: <166477802792157@kroah.com>
 <Yz1gP2FLEbjLIL9y@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yz1gP2FLEbjLIL9y@zn.tnic>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 05, 2022 at 12:45:19PM +0200, Borislav Petkov wrote:
> On Mon, Oct 03, 2022 at 08:20:27AM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.15-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > Possible dependencies:
> > 
> > df5b035b5683 ("x86/cacheinfo: Add a cpu_llc_shared_mask() UP variant")
> > 66558b730f25 ("sched: Add cluster scheduler level for x86")
> 
> This is a fix for CONFIG_SMP=n kernels which was caught by testing this
> explicitly by disabling SMP. IOW, I don't think anyone would be running
> SMP=n kernels and thus maybe should not backport those...?

Yeah, I agree, this doesn't look like a valid thing to backport, if
people had this issue in 5.15.y they would have already reported by now.

thanks,

greg k-h
