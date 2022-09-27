Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9AE5EB9E2
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 07:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiI0FrG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 01:47:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiI0FrF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 01:47:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 213D58E4F6;
        Mon, 26 Sep 2022 22:47:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 402CE61599;
        Tue, 27 Sep 2022 05:47:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F1BC433D6;
        Tue, 27 Sep 2022 05:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664257621;
        bh=j4JfiaEBwNwqe+T9Byu+AGlx7Ew02BAjsWgOhX/cyPc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hut3ekNfSPm324e9zUbtILn/rdqBR5TbZCu/OQUQPJ9BroBz5sjYsSLdSDsQcBuc/
         /4vBiz1s6RFZXXEC8YNDkCIb9OWhL5Z4z0oqftkYwMNs+/Q4yWwZfx/zcIN+RsZH0x
         lRn/att8w/YPhrQWmnyFMiH4Y4ZK5o1cK8jFF9ZU=
Date:   Tue, 27 Sep 2022 07:47:34 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jiri Slaby <jirislaby@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Oliver Neukum <oneukum@suse.com>,
        Jean-Francois Le Fillatre <jflf_kernel@gmx.com>,
        stable <stable@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.19 014/207] Revert "usb: add quirks for Lenovo OneLink+
 Dock"
Message-ID: <YzKOdhT7jTXwCaG8@kroah.com>
References: <20220926100806.522017616@linuxfoundation.org>
 <20220926100807.118539823@linuxfoundation.org>
 <d9d9651b-2561-03ce-8076-5b471929ff2d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9d9651b-2561-03ce-8076-5b471929ff2d@kernel.org>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 27, 2022 at 07:23:46AM +0200, Jiri Slaby wrote:
> I wonder, does it make sense to queue the commit (as 011/207) and
> immediately its revert (the patch below) in a single release? I doubt
> that...
> 
> The same holds for 012 (patch) + 015 (revert).

Yes it does, otherwise tools will pick up "hey, you forgot this patch
that should have been applied here!" all the time.  Having the patch,
and the revert, in the tree prevents that from happening.

thanks,

greg k-h
