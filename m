Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2075F7458
	for <lists+stable@lfdr.de>; Fri,  7 Oct 2022 08:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiJGGro (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Oct 2022 02:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiJGGrm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Oct 2022 02:47:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D2C8C4C3D
        for <stable@vger.kernel.org>; Thu,  6 Oct 2022 23:47:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9547D61BBE
        for <stable@vger.kernel.org>; Fri,  7 Oct 2022 06:47:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A209C433D6;
        Fri,  7 Oct 2022 06:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665125260;
        bh=NYz5+wSDVI3ikli96akItOAeh7q7ohHBrBjheUObjWU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qwuFY7nDsJ98G0qfVxoCbqsRo5V7S1afMoyV6L6jvd9F5iDz9mYNlSRUHU/DTYNYq
         XBpGjRBvDmxcypLW3Ziho5ODalZM58e+IrGw8WyQWfyU5AK59aPxQ18VEdHSkuWOST
         1K0k+Yxgio+p6eJSH72Fk9RJirnFu+ZXArc7D+hY=
Date:   Fri, 7 Oct 2022 08:48:20 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jalal Mostafa <jalal.a.mostapha@gmail.com>
Cc:     stable@vger.kernel.org, magnus.karlsson@intel.com, bjorn@kernel.org
Subject: Re: Merge into stable: xsk: inherit need_wakeup flag for shared
 sockets
Message-ID: <Yz/LtDBimKCykoki@kroah.com>
References: <CAFLwmnvU8Z7N=nckqwuXOsFBTJn-aJJUJ9aLR6eTQ-z+4JFzbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFLwmnvU8Z7N=nckqwuXOsFBTJn-aJJUJ9aLR6eTQ-z+4JFzbQ@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 06, 2022 at 02:31:14PM +0200, Jalal Mostafa wrote:
> Hi,
> 
> The following patch should be backported to the stable kernel versions
> starting from 5.10
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=60240bc26114
> 
> The patch fixes inheriting the need_wakeup flag for AF_XDP sockets.
> Sockets with XDP_SHARED_UMEM cannot have good performance because they
> do not get this flag from the first socket.
> 
> Fixes: b5aea28dca134 ("xsk: Add shared umem support between queue ids")
> Commit ID: 60240bc26114 ("xsk: Inherit need_wakeup flag for shared sockets")
> Kernels: 5.10 - 5.15 - 5.19 - 6.0

Now queued up, thanks.

greg k-h
