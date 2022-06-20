Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C69D3551828
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 14:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235801AbiFTMFn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 08:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242123AbiFTMFV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 08:05:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC0B8BC0
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 05:04:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BFCC61328
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 12:04:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40DCBC3411C;
        Mon, 20 Jun 2022 12:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655726696;
        bh=YbE88ewD63qAcY1my92eCGPfSiLWb1PPVEqvlW5rsXM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1ChKh3zXWhJtyVhW4T7cye/J3kpEVho5yx8ZcTygS0Qy/fAiXDNB4V4VEKf97MQYX
         MsvNf5RUCCRsjLVu9KI69b3qO7JYs4xsG7QnLC4KEPVpySTw9KLBQjCqIGr9Ef3N7u
         vjybW8xr5WJCYynAFxe1l5npn/LnICd1LEjEYBEg=
Date:   Mon, 20 Jun 2022 14:04:53 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: backport of d51f86cfd8e3 ("powerpc/mm: Switch obsolete dssall to
 .long")
Message-ID: <YrBiZdtCimCLc6HD@kroah.com>
References: <Yqelvu3VN/Y53YIq@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yqelvu3VN/Y53YIq@debian>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 13, 2022 at 10:01:50PM +0100, Sudip Mukherjee wrote:
> Hi Greg,
> 
> The stable branches 4.19-stable and 5.4-stable will also need
> d51f86cfd8e3 ("powerpc/mm: Switch obsolete dssall to .long") for powerpc
> allmodconfig failure.
> 
> The backport for both is in the attached mbox.

Now queued up, thanks.

greg k-h
