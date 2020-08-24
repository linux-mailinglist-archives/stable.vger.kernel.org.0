Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 183FF24F32B
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 09:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbgHXHhr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 03:37:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:53082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbgHXHhq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 03:37:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 061C02075B;
        Mon, 24 Aug 2020 07:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598254666;
        bh=8qtKKnienXtYIO531f7Nd9oeL7cSMo+tERCj6M2m33I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lft/Nc6daFw2AHD8MXW9506lSyyOBvQXgEpuqBpl3JP52gvrX82rzVEDAGq32yoCU
         kuDN5aLFWhWKNePTQ6D6cOpTqE4qz1mUaCuPTm/U5UnDwrv8N9ykh6s+FdjsXp9RZf
         q4I+BnDasg2QcVcn6zrP4xEFps07aHZzYP9vc5kE=
Date:   Mon, 24 Aug 2020 09:38:04 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Daniel Axtens <dja@axtens.net>
Cc:     stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Tom Lane <tgl@sss.pgh.pa.us>
Subject: Re: [PATCH v4.9] powerpc: Allow 4224 bytes of stack expansion for
 the signal frame
Message-ID: <20200824073804.GA3983120@kroah.com>
References: <20200824042851.139162-1-dja@axtens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824042851.139162-1-dja@axtens.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 24, 2020 at 02:28:51PM +1000, Daniel Axtens wrote:
> From: Michael Ellerman <mpe@ellerman.id.au>
> 
> commit 63dee5df43a31f3844efabc58972f0a206ca4534 upstream.

<snip>

This, and the 4.4 backport, now queued up, thanks!

greg k-h
