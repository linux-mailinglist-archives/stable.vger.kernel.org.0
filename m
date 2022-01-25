Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78A5A49B692
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 15:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1579798AbiAYOjZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 09:39:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237434AbiAYOeR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 09:34:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D49B9C061747;
        Tue, 25 Jan 2022 06:34:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95FB8B81810;
        Tue, 25 Jan 2022 14:34:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E95F7C340E0;
        Tue, 25 Jan 2022 14:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643121252;
        bh=d8VDBh4A7aHxWjRMBX25G1hDZ6OaKc2/U1a3PD1bYKs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n/HxYVR0YVUH6wwMl/WoyoeV8igIEZildvImd/jY4TGPDyiXvszoYlF1uKfGJAJ08
         nS6ZFMjvAzpGXAA5LQq/qUCMx4C/3MJgCvjSAoE4HhDqOIgjSU88UPTNmbR5qBLvh9
         Y81G2jYQvnaPcqKqrkzfo9RUXnfGT/XNfhlNJ9Q4=
Date:   Tue, 25 Jan 2022 15:34:09 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
Cc:     lkml <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: review for  5.16.3-rc2
Message-ID: <YfAKYWOMdGJ0NxjE@kroah.com>
References: <0af17d6952b3677dcd413fefa74b086d5ffb474b.camel@rajagiritech.edu.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0af17d6952b3677dcd413fefa74b086d5ffb474b.camel@rajagiritech.edu.in>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 25, 2022 at 06:15:46PM +0530, Jeffrin Jose T wrote:
> hello greg,
> 
> compile failed for  5.16.3-rc2 related.
> a relevent file attached.
> 
> Tested-by : Jeffrin Jose T <jeffrin@rajagiritech.edu.in>

But it failed for you, how did you test it?

> 
> 
> -- 
> software engineer
> rajagiri school of engineering and technology - autonomous
> 
> 

> 	char *                     typetab;              /*    24     8 */
> 
> 	/* size: 32, cachelines: 1, members: 4 */
> 	/* sum members: 28, holes: 1, sum holes: 4 */
> 	/* last cacheline: 32 bytes */
> };
> struct klp_modinfo {
> 	Elf64_Ehdr                 hdr;                  /*     0    64 */
> 	/* --- cacheline 1 boundary (64 bytes) --- */
> 	Elf64_Shdr *               sechdrs;              /*    64     8 */
> 	char *                     secstrings;           /*    72     8 */
> 	unsigned int               symndx;               /*    80     4 */
> 
> 	/* size: 88, cachelines: 2, members: 4 */
> 	/* padding: 4 */
> 	/* last cacheline: 24 bytes */
> };
> Segmentation fault

What "faulted"?  Look higher up in the log please.

thanks,

greg k-h
