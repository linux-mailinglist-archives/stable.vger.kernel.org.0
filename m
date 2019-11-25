Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0292B108EF4
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 14:34:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727506AbfKYNeJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 08:34:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:54086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727497AbfKYNeJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Nov 2019 08:34:09 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 809622068F;
        Mon, 25 Nov 2019 13:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574688848;
        bh=vc2HnUN34cH0J0AqFhxWNVNhyi9ExSD5+ivRH89Arpo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yO88N+sz6lODVPYx5QnehECfOwBRTvGmhOU9CreyH5IJHKrSOmBmc4UBgqzlQGylY
         OAq8bOL4p5JnOJj2zqogrmFlHVZqDLi6PPyLC2ff2lPJcI4aNiBbiWKVJlqZwoqgqR
         ZM7+NVewlOXu31Vtu1wesNw1ruV3fGULGE2CaI5w=
Date:   Mon, 25 Nov 2019 08:34:07 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Lyude Paul <lyude@redhat.com>, linux-input@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.14 21/21] Input: synaptics - enable RMI mode
 for X1 Extreme 2nd Generation
Message-ID: <20191125133407.GB12367@sasha-vm>
References: <20191122194931.24732-1-sashal@kernel.org>
 <20191122194931.24732-21-sashal@kernel.org>
 <20191122195602.GC248138@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191122195602.GC248138@dtor-ws>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 22, 2019 at 11:56:02AM -0800, Dmitry Torokhov wrote:
>On Fri, Nov 22, 2019 at 02:49:31PM -0500, Sasha Levin wrote:
>> From: Lyude Paul <lyude@redhat.com>
>>
>> [ Upstream commit 768ea88bcb235ac3a92754bf82afcd3f12200bcc ]
>>
>> Just got one of these for debugging some unrelated issues, and noticed
>> that Lenovo seems to have gone back to using RMI4 over smbus with
>> Synaptics touchpads on some of their new systems, particularly this one.
>> So, let's enable RMI mode for the X1 Extreme 2nd Generation.
>>
>> Signed-off-by: Lyude Paul <lyude@redhat.com>
>> Link: https://lore.kernel.org/r/20191115221814.31903-1-lyude@redhat.com
>> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>This will be reverted, do not pick up for stable.

I'll drop it, thanks!

-- 
Thanks,
Sasha
