Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28FB5953BD
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 03:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728786AbfHTBuq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Aug 2019 21:50:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728777AbfHTBuq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Aug 2019 21:50:46 -0400
Received: from localhost (unknown [12.236.144.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5A7922CE8;
        Tue, 20 Aug 2019 01:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566265845;
        bh=OIx7ocnlk+ck/RJG3+f+VPjADSHHVpCdY305m10G+TI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LaAMt2xUACDMLvPii7JMdd7BJDqcfUyud4jEGDqygnQpmn3HxTeZshFOeSqpcmilv
         m5KeJosn+Qi3/oXrakBtL024bMB8eZEPbl+65FmFz0noyBbyEd3Lez07CS+XL/QhT1
         gao19SwvPpjmb2hoq/dfMzOHBWbYBm7Ah4MaiJkA=
Date:   Mon, 19 Aug 2019 21:50:43 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: gcc 9.0 support in v4.4.y
Message-ID: <20190820015043.GG30205@sasha-vm>
References: <20190819233809.GA13230@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190819233809.GA13230@roeck-us.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 19, 2019 at 04:38:09PM -0700, Guenter Roeck wrote:
>Hi,
>
>please consider applying the following two patches from v4.9.y to v4.4.y.
>
>fe5844365ec6 ("Backport minimal compiler_attributes.h to support GCC 9")
>2c34c215c102 ("include/linux/module.h: copy __init/__exit attrs to init/cleanup_module")
>	(upstream commit a6e60d84989f)
>
>... to enable compiling v4.4.y with gcc 9.x.
>
>This already works for the most part, but alpha:allmodconfig and
>arm:allmodconfig fail to compile. The above two patches fix the problem.

Queued up, thanks!

--
Thanks,
Sasha
