Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF91A3FB6C5
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 15:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234032AbhH3NNf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 09:13:35 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:58768 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231536AbhH3NNe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Aug 2021 09:13:34 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 179FB220BB;
        Mon, 30 Aug 2021 13:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1630329160;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RFMi9iJq0kl8EsgiYEM1G2uxCpBi954jJf/Rxm/Vue8=;
        b=RwqdZFJqbXuU3IBhta86BoVMz43iXBcGVHgj+CoI2yFgcFxNGgAJLhcvBrXcKj6XtGo/9n
        CWHmaogswby8pJcVWcpofC+Vlyq39qxEtDMWWvS8IMY+TnI7MOPW7W01GACPSmV0H5ikb5
        E7YMMVrKE58L9l7m9TyoJrLx75gOJLc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1630329160;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RFMi9iJq0kl8EsgiYEM1G2uxCpBi954jJf/Rxm/Vue8=;
        b=YJD7Wjw8V7/hyubitweryYscqPCoNSDhcjNjepYgLM8mf83B7NksjjjP1rEsG+IvRGFslJ
        vtGsrtN9Mf6cnACw==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id EEF24A3B9F;
        Mon, 30 Aug 2021 13:12:39 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id BA5AADA733; Mon, 30 Aug 2021 15:09:49 +0200 (CEST)
Date:   Mon, 30 Aug 2021 15:09:49 +0200
From:   David Sterba <dsterba@suse.cz>
To:     gregkh@linuxfoundation.org
Cc:     wqu@suse.com, ce3g8jdj@umail.furryterror.org, dsterba@suse.com,
        stable@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] Revert "btrfs: compression: don't try to
 compress if we don't" failed to apply to 5.4-stable tree
Message-ID: <20210830130949.GB3379@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, gregkh@linuxfoundation.org, wqu@suse.com,
        ce3g8jdj@umail.furryterror.org, dsterba@suse.com,
        stable@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <16302200512317@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16302200512317@kroah.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 29, 2021 at 08:54:11AM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

The code in versions from 5.4 to 4.4 is the same and the merge conflict
can be resolved from that (eg. from file
stable.git/releases/./5.4.136/btrfs-compression-don-t-try-to-compress-if-we-don-t-have-enough-pages.patch)
