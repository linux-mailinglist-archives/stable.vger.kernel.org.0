Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05FDB38F084
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 18:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236224AbhEXQDm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 12:03:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:49562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235733AbhEXQCd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 12:02:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AE8761132;
        Mon, 24 May 2021 15:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621871325;
        bh=1SrPgq51dpyfQzCaKi1uATzzyUf57yp13AzwnjzrPNw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YsyzZJgHXUdih2l31yIetxCEABfFGyPoUdngyzR9mvLRk5xZyQUJykd0uoD0aWBpg
         ivDFWJIhq6U0Vey/GVMVD8FI9HK8+TG9y64hn/Isd6ggJVHTdD0t6UKkccvFLpeVUx
         R2J0rX01lzg+l71AnlS2IVMV414jEOY+9zIp0w3U=
Date:   Mon, 24 May 2021 17:46:15 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: revert series of umn.edu commits
Message-ID: <YKvKR2rKU1DnaW00@kroah.com>
References: <YICidTdSYPut4oVa@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YICidTdSYPut4oVa@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 21, 2021 at 11:08:53PM +0100, Sudip Mukherjee wrote:
> Hi Greg,
> 
> This is based on the 190 commits that you posted for mainline. Out of
> that 24 patches had a reply mail asking not to revert. So, the attached
> series for stable is based on the remaining 166 commits. I have borrowed
> the commit message from your series.

Thanks for doing these, but now that the "real" reverts and fixes are in
Linus's tree, we don't need these series anymore.

thanks for the help,

greg k-h
