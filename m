Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 831341606D2
	for <lists+stable@lfdr.de>; Sun, 16 Feb 2020 22:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbgBPVtn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Feb 2020 16:49:43 -0500
Received: from hostingweb31-40.netsons.net ([89.40.174.40]:40391 "EHLO
        hostingweb31-40.netsons.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726020AbgBPVtm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Feb 2020 16:49:42 -0500
Received: from [78.134.119.80] (port=47944 helo=[192.168.77.51])
        by hostingweb31.netsons.net with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92)
        (envelope-from <luca@lucaceresoli.net>)
        id 1j3RnH-00HafO-Va; Sun, 16 Feb 2020 22:49:40 +0100
Subject: Re: [PATCH AUTOSEL 5.5 495/542] docs: i2c: writing-clients: properly
 name the stop condition
To:     Jean Delvare <jdelvare@suse.de>, Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org
References: <20200214154854.6746-1-sashal@kernel.org>
 <20200214154854.6746-495-sashal@kernel.org>
 <20200215071402.027c9120@endymion>
From:   Luca Ceresoli <luca@lucaceresoli.net>
Message-ID: <dfb3d313-ad9e-8f53-a7f6-d3bfe655d493@lucaceresoli.net>
Date:   Sun, 16 Feb 2020 22:49:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200215071402.027c9120@endymion>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - hostingweb31.netsons.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - lucaceresoli.net
X-Get-Message-Sender-Via: hostingweb31.netsons.net: authenticated_id: luca@lucaceresoli.net
X-Authenticated-Sender: hostingweb31.netsons.net: luca@lucaceresoli.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 15/02/20 07:14, Jean Delvare wrote:
> On Fri, 14 Feb 2020 10:48:07 -0500, Sasha Levin wrote:
>> From: Luca Ceresoli <luca@lucaceresoli.net>
>>
>> [ Upstream commit 4fcb445ec688a62da9c864ab05a4bd39b0307cdc ]
>>
>> In I2C there is no such thing as a "stop bit". Use the proper naming: "stop
>> condition".
>>
>> Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
>> Reported-by: Jean Delvare <jdelvare@suse.de>
>> Reviewed-by: Jean Delvare <jdelvare@suse.de>
>> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  Documentation/i2c/writing-clients.rst | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/i2c/writing-clients.rst b/Documentation/i2c/writing-clients.rst
>> index ced309b5e0cc8..3869efdf84cae 100644
>> --- a/Documentation/i2c/writing-clients.rst
>> +++ b/Documentation/i2c/writing-clients.rst
>> @@ -357,9 +357,9 @@ read/written.
>>  
>>  This sends a series of messages. Each message can be a read or write,
>>  and they can be mixed in any way. The transactions are combined: no
>> -stop bit is sent between transaction. The i2c_msg structure contains
>> -for each message the client address, the number of bytes of the message
>> -and the message data itself.
>> +stop condition is issued between transaction. The i2c_msg structure
>> +contains for each message the client address, the number of bytes of the
>> +message and the message data itself.
>>  
>>  You can read the file ``i2c-protocol`` for more information about the
>>  actual I2C protocol.
> 
> I wouldn't bother backporting this documentation patch to stable and
> longterm trees. That's a minor vocabulary thing really, it does not
> qualify.

I also feel no need to have it in stable branches. Hovever it would not
hurt, so whatever is fine for who's maintaining that branch will be fine
for me as well.

-- 
Luca
