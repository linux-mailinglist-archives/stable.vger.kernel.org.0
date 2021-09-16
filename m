Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0FD40ED81
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 00:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235079AbhIPWtD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 18:49:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:38210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234289AbhIPWtD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 18:49:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D086611CA;
        Thu, 16 Sep 2021 22:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631832462;
        bh=e/tOVBZ2IgDrbEjaw0v9QkM1LOtgcU5zikPIdAMfJug=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=BQyxKY6iowvs1WcnsZuzWmN6exo7pf+KhiwdlL+3bLxuxGQzNqJ9rZpkPVyMWwMtF
         nZk8i1PKCb1c+4b+5i9xHXW2/I7digL16MKJ2/xZ+Rd974NDJxSgB60wrH+MT+xSug
         JQhlGqeyGo1iFTHf63La2gDxptqRzgjckd0tfau6R80V9uNbwq5Xr52u0KN9w0Ippv
         2J3OULMNgww9tXnD1eysLnlfxqS1iz0tbm9OdSjageY2x3wLXDdJglncbeIc5nGNOw
         OXvpxGlCTwlLAqp1FUpT88s6oP2UZCFbPongO9equifOvoi5Ytw9Pj9r3Dx7/WuvTI
         j7VBy3VrPC27g==
Subject: Re: [PATCH] clk: socfpga: agilex: fix duplicate s2f_user0_clk
To:     Stephen Boyd <sboyd@kernel.org>
Cc:     mturquette@baylibre.com, linux-clk@vger.kernel.org,
        stable@vger.kernel.org
References: <20210913132102.883361-1-dinguyen@kernel.org>
 <163166856812.763609.13128310400246778720@swboyd.mtv.corp.google.com>
 <163166970028.763609.7710436848359965088@swboyd.mtv.corp.google.com>
From:   Dinh Nguyen <dinguyen@kernel.org>
Message-ID: <8298ec4f-913d-e00f-0d3e-c88e141563ef@kernel.org>
Date:   Thu, 16 Sep 2021 17:47:24 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <163166970028.763609.7710436848359965088@swboyd.mtv.corp.google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/14/21 8:35 PM, Stephen Boyd wrote:
> Quoting Stephen Boyd (2021-09-14 18:16:08)
>> Quoting Dinh Nguyen (2021-09-13 06:21:02)
>>> Remove the duplicate s2f_user0_clk.
>>
>> To fix what in particular? The patch is tagged for stable so I can only
>> imagine there's some badness that would be good to fix?
>>
> 
> Ah this is the patch that was missing. Please squash the two together
> and resend with more info.
> 

Sorry about that. Will do.

Dinh
