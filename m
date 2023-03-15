Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA856BAAF0
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 09:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231608AbjCOIjn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 04:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjCOIjm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 04:39:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D8366A43E
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 01:39:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BDFE61C1A
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 08:39:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42BBDC433EF;
        Wed, 15 Mar 2023 08:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678869577;
        bh=eApRwcnTw1tmITADOYm3cgjlgI6/gka75IcGlyRVxU8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xDlS5TZAI8A2pISmF0WOigjSY4PtQgZYvk7FKKe02T+0HtPa6xhep4iE7GEysh+hG
         DRdAujOk5SVlq8wD+tZpJItbdYAeXMZ8vT5mpo6pRTheFsRHZQkFfkfsXcSX+E8YZo
         ywVG8g1IjYex8nbZxJy8HjTYu9ZoKtq6Z+tR45wg=
Date:   Wed, 15 Mar 2023 09:39:35 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tom Saeger <tom.saeger@oracle.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        "H.J. Lu" <hjl.tools@gmail.com>, Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 5.4 v3 1/6] x86, vmlinux.lds: Add RUNTIME_DISCARD_EXIT to
 generic DISCARDS
Message-ID: <ZBGER4HqDnvotSNg@kroah.com>
References: <20230210-tsaeger-upstream-linux-stable-5-4-v3-0-122fc5440d4c@oracle.com>
 <20230210-tsaeger-upstream-linux-stable-5-4-v3-1-122fc5440d4c@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210-tsaeger-upstream-linux-stable-5-4-v3-1-122fc5440d4c@oracle.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 01, 2023 at 07:06:59PM -0700, Tom Saeger wrote:
> From: "H.J. Lu" <hjl.tools@gmail.com>
> 
> commit 84d5f77fc2ee4e010c2c037750e32f06e55224b0 upstream.
> 
> In the x86 kernel, .exit.text and .exit.data sections are discarded at
> runtime, not by the linker. Add RUNTIME_DISCARD_EXIT to generic DISCARDS
> and define it in the x86 kernel linker script to keep them.
> 
> The sections are added before the DISCARD directive so document here
> only the situation explicitly as this change doesn't have any effect on
> the generated kernel. Also, other architectures like ARM64 will use it
> too so generalize the approach with the RUNTIME_DISCARD_EXIT define.
> 
>  [ bp: Massage and extend commit message. ]
> 
> Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Link: https://lkml.kernel.org/r/20200326193021.255002-1-hjl.tools@gmail.com
> Signed-off-by: Tom Saeger <tom.saeger@oracle.com>

The encoding of this email was very odd, with dos line-ends?  Something
was odd on your side, all the others were fine.  I've fixed it up...

strange,

greg k-h
