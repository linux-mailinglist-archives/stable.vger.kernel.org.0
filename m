Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4A68149C32
	for <lists+stable@lfdr.de>; Sun, 26 Jan 2020 19:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgAZSFb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Jan 2020 13:05:31 -0500
Received: from mx2.suse.de ([195.135.220.15]:35394 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbgAZSFb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 26 Jan 2020 13:05:31 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 27F51ABBD;
        Sun, 26 Jan 2020 18:05:29 +0000 (UTC)
Subject: Re: [PATCH v4.4] net: davinci_cpdma: use dma_addr_t for DMA address
To:     Ben Hutchings <ben@decadent.org.uk>, stable@vger.kernel.org
Cc:     Pavel Machek <pavel@denx.de>, Arnd Bergmann <arnd@arndb.de>,
        "David S . Miller" <davem@davemloft.net>
References: <20191221104948.10233-1-dwagner@suse.de>
 <d344f152a9627944a3e8e4dccd8fc9e5c6ef8a40.camel@decadent.org.uk>
From:   Daniel Wagner <dwagner@suse.de>
Message-ID: <aa5358d5-f7fa-c86e-498a-42bd67717519@suse.de>
Date:   Sun, 26 Jan 2020 19:05:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <d344f152a9627944a3e8e4dccd8fc9e5c6ef8a40.camel@decadent.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Ben,

On 26.01.20 18:36, Ben Hutchings wrote:
> On Sat, 2019-12-21 at 11:49 +0100, Daniel Wagner wrote:
>> From: Arnd Bergmann <arnd@arndb.de>
>>
>> [ Upstream commit 84092996673211f16ef3b942a191d7952e9dfea9 ]
> [...]
>> Pavel reported this fix is needed for the CIP kernel.
>>
>> Since this patch was added to v4.5, we only need to backport
>> to v4.4.
> 
> It looks like it's also applicable to 3.16, so I've queued it up for
> that.

Oh sorry, I forgot to check if 3.16 needs it. I had the impression 3.16 
was already EOL. Obviously, still alive :)

Thanks,
Daniel

