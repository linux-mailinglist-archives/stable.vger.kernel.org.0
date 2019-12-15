Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC39811FABD
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 20:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbfLOTYy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 14:24:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:37062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbfLOTYx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Dec 2019 14:24:53 -0500
Received: from localhost (unknown [73.61.17.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03B722053B;
        Sun, 15 Dec 2019 19:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576437893;
        bh=jlI68SyiidEi+/zZiwB+JmNx7CjJGQdKOYgNUVblV/M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oynQCPcQzOWeppLM90A9+KffmsLhaaUmUUPkT9oCSRFUlcHzN578rD0PCMWOvXPvX
         hSFgGRI05MOKtfZc9NsvwQLIftV3UMxEHEN6yY1oK4w+mm9YYPOU2NLZU4wF1lkJkK
         Eqq1rOYWbwZr5hLAIbRV72Rev7RgL/tADaqQOBMQ=
Date:   Sun, 15 Dec 2019 14:24:51 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        tony@atomide.com, ulf.hansson@linaro.org
Subject: Re: FAILED: patch "[PATCH] omap: pdata-quirks: remove openpandora
 quirks for mmc3 and" failed to apply to 4.14-stable tree
Message-ID: <20191215192451.GT18043@sasha-vm>
References: <157641677913676@kroah.com>
 <B77B52F8-BD0E-41D1-ACEF-6440E9C59CED@goldelico.com>
 <20191215174935.GA856758@kroah.com>
 <20E4BE11-9846-4A94-9437-5C722D1E2B8E@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20E4BE11-9846-4A94-9437-5C722D1E2B8E@goldelico.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 15, 2019 at 08:09:34PM +0100, H. Nikolaus Schaller wrote:
>
>> Am 15.12.2019 um 18:49 schrieb Greg KH <gregkh@linuxfoundation.org>:
>>
>> On Sun, Dec 15, 2019 at 06:37:34PM +0100, H. Nikolaus Schaller wrote:
>>> Please apply this before: https://patchwork.kernel.org/patch/11232473/
>>
>> Links are fun :(
>
>Sorry.
>
>>
>> What is the git commit id of the patch in Linus's tree to apply first?
>> That I can work with.
>
>4e8fad98171b omap: pdata-quirks: revert pandora specific gpiod additions

Already got it in, thanks!

-- 
Thanks,
Sasha
