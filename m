Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C572355154A
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 12:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239963AbiFTKHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 06:07:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239124AbiFTKG6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 06:06:58 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D8E26152
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 03:06:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E79C3CE1157
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 10:06:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 921D0C3411B;
        Mon, 20 Jun 2022 10:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655719614;
        bh=M1WIcCRYeSR6m90jR9EegSSeXcAeHnDvI7QaMdS4P08=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vlpph6vpcosfjwVcKrx5NsbHFuNKiW4+Z6o3us1Xx8kQyZJVdalg7H/pFWN9UJIls
         OleD4zErrjZRQlONQEK9XIS4tL+WOTTGB+BI0e2ViFzCldLb9LZJW1wUX8rsgkAo9o
         Hb/s78LP302oBT7zgITZDT8bORBT/L2HwehA3h6M=
Date:   Mon, 20 Jun 2022 12:06:51 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     ashish.kalra@amd.com, pbonzini@redhat.com, pgonda@google.com,
        rientjes@google.com, theflow@google.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: SVM: Use kzalloc for sev ioctl
 interfaces to prevent" failed to apply to 5.10-stable tree
Message-ID: <YrBGuw+D2whB/iGA@kroah.com>
References: <165426931519389@kroah.com>
 <Yqzev3h3KHdBiuTB@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yqzev3h3KHdBiuTB@debian>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 17, 2022 at 09:06:23PM +0100, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Fri, Jun 03, 2022 at 05:15:15PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.10-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport along with eba04b20e486 ("KVM: x86: Account a variety
> of miscellaneous allocations") which was needed for easier backporting.

Now queued up, thanks.

greg k-h
