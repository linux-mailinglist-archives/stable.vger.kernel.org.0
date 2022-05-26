Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F12E45353DD
	for <lists+stable@lfdr.de>; Thu, 26 May 2022 21:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231350AbiEZTYH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 May 2022 15:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbiEZTYG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 May 2022 15:24:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39BAFDFF5E;
        Thu, 26 May 2022 12:24:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1707617C2;
        Thu, 26 May 2022 19:24:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41411C385A9;
        Thu, 26 May 2022 19:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653593043;
        bh=QZazBL6rV7kcxX5N/5B78I0qFy4pS5M7Czf9Q4IcTJQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zKj8m9RTgmF64ru6GB9xTZmUpJw8NcPMEey6qXIk0ckYgZB27nEP3Ta6ZNBGnlM4K
         SzQl5FQ9ndqSlISqeAa9iTPnoqFRD7zmvuEh4PIzhBJTJklyZx3jId4DRpKQ5WVZuj
         g4ploHHTurDQUqiOVtvBS/0M6g/vY8dWarnKxFVk=
Date:   Thu, 26 May 2022 21:24:00 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Patch for stable
Message-ID: <Yo/T0LPar9q8LROO@kroah.com>
References: <Yo+t8QAgVTi2E6B4@yury-laptop>
 <Yo+vidb+a9Ctqyih@kroah.com>
 <Yo+9KLc6VG8CKeH+@yury-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yo+9KLc6VG8CKeH+@yury-laptop>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 26, 2022 at 10:47:20AM -0700, Yury Norov wrote:
> + Vitaly Kuznetsov <vkuznets@redhat.com>
> + Paolo Bonzini <pbonzini@redhat.com>
> 
> On Thu, May 26, 2022 at 06:49:13PM +0200, Greg Kroah-Hartman wrote:
> > On Thu, May 26, 2022 at 09:42:25AM -0700, Yury Norov wrote:
> > > Hi Greg,
> > > 
> > > Can you please consider taking the patch "KVM: x86: hyper-v: fix type
> > > of valid_bank_mask" into stable?
> > > 
> > > Commit ea8c66fe8d8f4f93df941e52120a3512d7bf5128 upstream.
> > 
> > For what kernel tree(s) should thie be backported?
> 
> For me, Ubuntu LTS is important (4.15 and 5.4). I believe, Vitaly
> and Paolo may know better for Red Hat, and in general.

Did you test this on any of these older kernels?  Please do so and
provide the backported kernels.  Also you can not skip a kernel version
(i.e. it needs to be in all stable kernels back to 5.4 if you want it
there.)

And note that 4.15 is not a supported kernel by us, please work with
Canonical if you want a patch applied to their random kernel tree.

thanks,

greg k-h
