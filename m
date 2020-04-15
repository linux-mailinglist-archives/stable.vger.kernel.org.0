Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 186C01A99B5
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 11:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405625AbgDOJ4u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 05:56:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:50368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729231AbgDOJ4t (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 05:56:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95304206D9;
        Wed, 15 Apr 2020 09:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586944609;
        bh=OXAdCGfvHxVdszOJg94g/Cvhk/sUX72O+MmfF4sP+ps=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W0rgbDKGDmhjgD5RmEOp8V9XSimJJQOoLG+3kg2UV5qhowlS27cC3aDkzeBa2jYhn
         9idEDN3scfRHGhJj/Pjwx+4bSOSdJSlS28AUwIQ5NoawgJKAK2VQ1Ygp6eEccoVZyA
         Axlfj5KJ3NdTNi/GtX5ccy+VlpDaINgjIkUg1D44=
Date:   Wed, 15 Apr 2020 11:56:46 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: Re: Patches to apply to stable releases
Message-ID: <20200415095646.GA2568572@kroah.com>
References: <20200415003148.GA114493@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200415003148.GA114493@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 14, 2020 at 05:31:48PM -0700, Guenter Roeck wrote:
> Upstream commit 93f0750dcdae ("Revert "[media] videobuf2-v4l2: Verify planes array in buffer dequeueing"")
>     Fixes: 2c1f6951a8a8 ("videobuf2-v4l2: Verify planes array in buffer dequeueing")
>     in linux-4.4.y: 19a4e46b4513
>     Applies to:
>         v4.4.y

That commit is already in 4.4.11, are you sure you want it applied
again?

Ugh, it came back, as commit 83934b75c368 ("[media] videobuf2-v4l2:
Verify planes array in buffer dequeueing")  Nothing like different git
commit ids for the same patch to cause confusions...

nevermind...

greg k-h
