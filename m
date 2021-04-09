Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A94E63599C7
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 11:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbhDIJsa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 05:48:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:40624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231402AbhDIJs3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 05:48:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F38016115B;
        Fri,  9 Apr 2021 09:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617961696;
        bh=pJyMqHtDG6weXmvIamRFqqUhZaa+/8JCxxjwYQWQFpI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qk48kYtpedzKUWIYoxbX3rxrQmbIEH0lLAw0Q0SOVuhFuhjH1Di07EQZtk1Vg8URY
         DOXyrC0xDA/N7mc++LqyQ8Bm1pb5aHJJ4sGpDWKVhz4jTDjmbUPjNAUqpte42bRSO9
         FB/NZh3GND8gNFnTzTmfgx7Fyq8gYQ//25JcYddc=
Date:   Fri, 9 Apr 2021 11:48:14 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     sashal@kernel.org, stable@vger.kernel.org
Subject: Re: missing commits for 4.4-stable
Message-ID: <YHAi3j7hf7DylQz0@kroah.com>
References: <YGzQoA2GfkKiNUYG@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YGzQoA2GfkKiNUYG@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 06, 2021 at 10:20:32PM +0100, Sudip Mukherjee wrote:
> Hi Greg, Sasha,
> 
> These were missing in 4.4-stable. One of them is needed in 4.9-stable too.
> Please apply to your queues.
> 
> 
> --
> Regards
> Sudip




Now queued up, thanks.

greg k-h
