Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4915F4E6FCE
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 10:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354111AbiCYJMP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 05:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiCYJMP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 05:12:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF7104BFCB
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 02:10:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58269B81D87
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 09:10:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C90C6C340E9;
        Fri, 25 Mar 2022 09:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648199439;
        bh=FBTXn2ZcGAt5w/YWh5x/rYDh/V5JGe0msCAQL9gYgl4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gFYHP5EXWn5PJKHvdC5I3+5hAOXcluTdzYp2nwZAoYAi3q6WVEHscPXDfaqNp2Vg3
         DL+jMNDhuC0RTT5wEXBFJOWn9h12Cxh5pX2OlAHC9Ft9dA7m/l0WvU/3zrl8Upegx+
         iUlQpisozWOBxkjTYJyIdCbIYkNZkkrQt0iFI2zM=
Date:   Fri, 25 Mar 2022 10:10:36 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     chuansheng.liu@intel.com, rafael.j.wysocki@intel.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] thermal: int340x: fix memory leak in
 int3400_notify()" failed to apply to 4.14-stable tree
Message-ID: <Yj2HDJcn1CP2cKKc@kroah.com>
References: <16460317043746@kroah.com>
 <YjuVmAij+cN6ZhzD@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjuVmAij+cN6ZhzD@debian>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 23, 2022 at 09:48:08PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Mon, Feb 28, 2022 at 08:01:44AM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.14-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport.

All 3 now queued up, thanks.

greg k-h
