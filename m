Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B73BE1AFEF0
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 01:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725949AbgDSXmB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Apr 2020 19:42:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:47090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725834AbgDSXmB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 19 Apr 2020 19:42:01 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1522B20771;
        Sun, 19 Apr 2020 23:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587339721;
        bh=amUfnJsqe6Ww3IhLRtOlQK1EsGtj0r1QEWPBzDY/KdA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zc1ml5Y4LdP/1lT+MLmP9t5unwR95VnIdjxUXZF/s1uHeFStj6dTTx2niPNIgh5ry
         6d5bfgZ8zZcYf6KwVGBQ42Ma2Q292yP+bO9GZkA36DRgTWZIzuYFKk4fpUayPIxtXh
         c+0PUR7wutUrwkzvGjaAKgn/gvq7nZ3vh94ylsRU=
Date:   Sun, 19 Apr 2020 19:42:00 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [stable] dm flakey: check for null arg_name in parse_features()
Message-ID: <20200419234200.GG1809@sasha-vm>
References: <bfae889d03f1890e00abf29a184ba1e955cb150b.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <bfae889d03f1890e00abf29a184ba1e955cb150b.camel@decadent.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Apr 19, 2020 at 08:10:03PM +0100, Ben Hutchings wrote:
>Please pick this fix for 4.4, 4.9, and 4.14 stable branches:
>
>commit 7690e25302dc7d0cd42b349e746fe44b44a94f2b
>Author: Goldwyn Rodrigues <rgoldwyn@suse.com>
>Date:   Sun Dec 3 21:14:12 2017 -0600
>
>    dm flakey: check for null arg_name in parse_features()

Queued up, thanks!

-- 
Thanks,
Sasha
