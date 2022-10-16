Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0422C600335
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 22:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiJPUJQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 16:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbiJPUJP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 16:09:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7225332B94
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 13:09:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03B2560E00
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 20:09:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E641C433D6;
        Sun, 16 Oct 2022 20:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665950953;
        bh=ERoGyM1JiuBB6gQ6vrf/Rx8TjzKPFv/uEXh/sjCTs40=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ygkoIGkg53vKqo2B8/zAc6nyrms1Kjqhft1cLVdvKgKzI2gEoFXUUv2aYHdQLdPHQ
         qLI3Vv+y5P6++03AktXPTeo6W/GAy5ovL50JfIfvN6Jb68DY4u9+0BwXo4B0oXU3Bn
         4KRTeZonj98yVfjqsa1aWKxrvhGNc3cPEMwBw7lk=
Date:   Sun, 16 Oct 2022 22:09:59 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Waiman Long <longman@redhat.com>
Cc:     boqun.feng@gmail.com, mingo@redhat.com, peterz@infradead.org,
        rostedt@goodmis.org, will@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] tracing: Disable interrupt or preemption
 before acquiring" failed to apply to 5.4-stable tree
Message-ID: <Y0xlFxm7iJgaNFG7@kroah.com>
References: <166593467012288@kroah.com>
 <778aaa49-9595-00b2-f054-717d871d4e08@redhat.com>
 <Y0wyv/wyQoS+J6JZ@kroah.com>
 <bc62af00-8f3b-31fe-0ff7-afd9473c0d0f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc62af00-8f3b-31fe-0ff7-afd9473c0d0f@redhat.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 16, 2022 at 04:02:29PM -0400, Waiman Long wrote:
> On 10/16/22 12:35, Greg KH wrote:
> > On Sun, Oct 16, 2022 at 12:26:22PM -0400, Waiman Long wrote:
> > > On 10/16/22 11:37, gregkh@linuxfoundation.org wrote:
> > > > The patch below does not apply to the 5.4-stable tree.
> > > > If someone wants it applied there, or to any other stable or longterm
> > > > tree, then please email the backport, including the original git commit
> > > > id to <stable@vger.kernel.org>.
> > > > 
> > > > Possible dependencies:
> > > > 
> > > > c0a581d7126c ("tracing: Disable interrupt or preemption before acquiring arch_spinlock_t")
> > > > 
> > > > thanks,
> > > > 
> > > > greg k-h
> > > You just have to remove the lockdep_assert_preemption_disabled() line as
> > > this macro isn't defined in v5.4. It is a debug statement and its removal
> > > won't have any functional impact.
> > Wonderful, can you please submit a fixed up version like this so that I
> > can apply it?
> > 
> > thanks,
> > 
> > greg k-h
> 
> Sure. See the attached patch.

Thanks, now queued up!

greg k-h
