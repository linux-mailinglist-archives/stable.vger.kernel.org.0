Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86926196A12
	for <lists+stable@lfdr.de>; Sun, 29 Mar 2020 00:40:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727199AbgC1Xk4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Mar 2020 19:40:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:40732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726604AbgC1Xk4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 28 Mar 2020 19:40:56 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C837220716;
        Sat, 28 Mar 2020 23:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585438856;
        bh=N3eznl/AcJaW64sBDt/kil5uaDl61TWkNSvXOVwRMFY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bKjvv8Y/4TkZTjGOwnVTNhwgxFhNNSF35gM911nMXGxQ0+FgM9HVH8WpWFGcaNxsM
         06i0PUe4ji7jKFkglWhk5g2WcsCkOZHauhtDCT315ts4BDIhkINj3jilvGdJCLnbEn
         2hgKwLMU6IxUMxaUyTCO24FqyRQa7Im6kpY++tIg=
Date:   Sat, 28 Mar 2020 19:40:54 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: Re: Patches for v4.4.y
Message-ID: <20200328234054.GC4189@sasha-vm>
References: <20200328041017.GA258977@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200328041017.GA258977@roeck-us.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 27, 2020 at 09:10:17PM -0700, Guenter Roeck wrote:
>Hi,
>
>Please consider applying the following patches to v4.4.y.
>
>The following patches were found to be missing in v4.4.y by the ChromeOS
>missing patches robot. The patches meet the following criteria.
>- The patch includes a Fixes: tag
>- The patch referenced in the Fixes: tag has been applied to v4.4.y
>- The patch itself has not been applied to v4.4.y

All patches queued up as described in your mail, thanks!

-- 
Thanks,
Sasha
