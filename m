Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64C794A8932
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 18:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352464AbiBCRBv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 12:01:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiBCRBu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 12:01:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB49C061714
        for <stable@vger.kernel.org>; Thu,  3 Feb 2022 09:01:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E32FB834DA
        for <stable@vger.kernel.org>; Thu,  3 Feb 2022 17:01:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8815C340E8;
        Thu,  3 Feb 2022 17:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643907708;
        bh=Upi5TETxVB9wO5ODwOYkWSYO/FR7f09V5VY4r8oVEGk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CCZNS4+/kEdf7RqRlCI0JEuuriWfNkJ0CMjbcJfyNPIPBOKuxDGIVOxrvnR42HVVF
         jCcjGWIFg2vcgQ9ix7LLf2afT8bfm0ocEZE8LsJM00IkhDIP0QDB82JG1wecoI2tmY
         VbwuhZCY08qees/Mtz/bOInXLuspapK61YbLl4vs=
Date:   Thu, 3 Feb 2022 18:01:40 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     "# 3.19.x" <stable@vger.kernel.org>
Subject: Re: False-positive Bluetooth messages fix in stable kernels
Message-ID: <YfwKdIPaJn7mSRxO@kroah.com>
References: <6ce8dff1-5dcf-b560-5169-47acef139422@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ce8dff1-5dcf-b560-5169-47acef139422@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 02, 2022 at 12:13:19PM +0300, Pavel Skripkin wrote:
> Dear Greg and Sasha,
> 
> can you, please, cherry-pick following commit from Linus' tree:
> commit 899663be5e75dc0174dc8bda0b5e6826edf0b29a with subject line
> "Bluetooth: refactor malicious adv data check".
> 
> There is missing Fixes: tag inside commit log, which causes this patch to
> not go to stable trees, but it actually fixes false-positive messages in
> dmesg.
> 
> I've seen 2 reports and I've asked reporters to test this patch and they
> have reported, that this patch actually fixes the problem [1] (second report
> was private, so I can't refer it there)
> 
> 
> 
> [1] https://lore.kernel.org/linux-bluetooth/CAC2ZOYuXg4btk9PaE3whmP7JnntsixEvDuBNvv7GL1pvU1nepQ@mail.gmail.com/T/#t
> 
> 

This is already in the last round of stable releases, thanks!

greg k-h
