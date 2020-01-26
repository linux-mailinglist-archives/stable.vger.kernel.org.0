Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54FF7149AE2
	for <lists+stable@lfdr.de>; Sun, 26 Jan 2020 14:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbgAZNwf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Jan 2020 08:52:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:33546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726323AbgAZNwf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 26 Jan 2020 08:52:35 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85E522071A;
        Sun, 26 Jan 2020 13:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580046754;
        bh=+7LKB1xL8oCsZCEnDQxyC4XBT9XlYBFD/1pH5kvY/2o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1OyoJ/48HDBvyH8HqK3G5yNufElw7F1LISzDUCUPJZoRf/OyRtVexeMJla7Pta6EU
         TeIgsn4q7dodhiL9elZqfEKIl4+ZaZiFYjCzxayZnk0qOdj2IeUr2kFmmu5ybj2NjT
         lXPrP/nvVa/LlYSeN6rVrfozD9op6BHubKMnJvA0=
Date:   Sun, 26 Jan 2020 08:52:33 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jeremy Linton <jeremy.linton@arm.com>, stable@vger.kernel.org,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: Request to backport "Documentation: Document arm64 kpti control"
Message-ID: <20200126135233.GB11467@sasha-vm>
References: <520fee3a-4d14-9a78-e542-cce98acae9f6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <520fee3a-4d14-9a78-e542-cce98acae9f6@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 25, 2020 at 08:03:25PM -0800, Florian Fainelli wrote:
>Hi Greg, Sasha,
>
>Could you backport upstream commit
>de19055564c8f8f9d366f8db3395836da0b2176c ("Documentation: Document arm64
>kpti control") to the stable 4.9, 4.14 and 4.19 kernels since they all
>support the command line parameter.

Hey Florian,

We don't normally take documentation patches into stable trees.

-- 
Thanks,
Sasha
