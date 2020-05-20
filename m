Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFDE1DBAFC
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 19:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgETRRu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 13:17:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:34508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726545AbgETRRt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 May 2020 13:17:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29EE62070A;
        Wed, 20 May 2020 17:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589995069;
        bh=fR8Yhf2uoEujFn3uRwBb7J4spGHzQYDKsKBO0eaRn9M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rxE7CtAcAurlZ0om8B2Yyx/avJDINIWJCvr9bsQUWedN7kOi9UM5FLVqOaIju7Fr+
         JwCc4NyD32gwY4N5SUmraX80Ez8XbweGFRfcnEEoyupdwW1jWtX+qvuSfYqnCHZst2
         rxvqx385Tka9x5yG60bpo5DQ/Onggv/AhsztM2sU=
Date:   Wed, 20 May 2020 19:17:47 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: Re: Please apply commit 629823b872402 ("igb: use
 igb_adapter->io_addr instead of e1000_hw->hw_addr") to v4.4.y/v4.9.y
Message-ID: <20200520171747.GB112902@kroah.com>
References: <20200519185322.GA67531@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200519185322.GA67531@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 19, 2020 at 11:53:22AM -0700, Guenter Roeck wrote:
> Hi,
> 
> please apply upstream commit 629823b87240 ("igb: use igb_adapter->io_addr
> instead of e1000_hw->hw_addr") to v4.4.y and to v4.9.y. The problem solved
> with this commit has been observed in chromeos-4.4.

Now queued up,t hanks.

greg k-h
