Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE46E11AA8B
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 13:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729110AbfLKMPt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 07:15:49 -0500
Received: from first.geanix.com ([116.203.34.67]:55190 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727365AbfLKMPt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 07:15:49 -0500
Received: from [192.168.100.11] (unknown [95.138.208.137])
        by first.geanix.com (Postfix) with ESMTPSA id 2231E3BE;
        Wed, 11 Dec 2019 12:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1576066519; bh=UQ3SaAYjpkv/q9ch8l8ZoyrL6Mg8t+VAZqOIKtNJdD0=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=Ff7B9P4HgkKp6eUh9XjAWPia3knW/7Y9c0zB+El+Zw6qoJ5lQo+q6ZEfyBqY5O/wF
         AxzqCno8xrolMu/G6zSsx7uQV3WM74NgObwvNZIAR1Z4rggd3LB7ZeNxsV3ilf+K6L
         w+m4bjsW8dT/kCtrxOp/rXsaLufZbNgrSxt9Q1Bdo5ycQyCv2vVA6XfHYoufBTcBw8
         XCAtPqplUFaZSdfCvEZ+Brldh6Nur8kH7RGU0nqzGSUsCQaaZh6rQ5Ry5Yyu7bewf1
         cFn3Mri6+t9sLnleuJw3XQdEU4NVygZsrR8NBvIIHW3AdEJPCkzFxDNftwhbCfOlgb
         /5AUOHV0dECAQ==
Subject: Re: [PATCH v3 1/2] can: m_can: tcan4x5x: put the device out of
 standby before register access
To:     Marc Kleine-Budde <mkl@pengutronix.de>, dmurphy@ti.com,
        linux-can@vger.kernel.org
Cc:     martin@geanix.com, stable@vger.kernel.org
References: <20191211064208.84656-1-sean@geanix.com>
 <8b1682ad-c291-252e-c768-63a7a4801aff@pengutronix.de>
 <bc0014ec-7302-97f4-5d71-8d029b0fb1fb@geanix.com>
 <41d13619-fab8-ca19-c340-c80cd80d117e@pengutronix.de>
 <ae996f9a-e50d-8f31-7457-c7fb461f5c9e@geanix.com>
 <614104a2-b667-62aa-4e1d-abcef89a257e@pengutronix.de>
From:   Sean Nyekjaer <sean@geanix.com>
Message-ID: <56a20412-088c-de3e-0238-9648ed2a44c7@geanix.com>
Date:   Wed, 11 Dec 2019 13:15:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <614104a2-b667-62aa-4e1d-abcef89a257e@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on 8b5b6f358cc9
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 11/12/2019 13.10, Marc Kleine-Budde wrote:
> On 12/11/19 12:28 PM, Sean Nyekjaer wrote:
>> On 11/12/2019 10.44, Marc Kleine-Budde wrote:
>>> On 12/11/19 10:13 AM, Sean Nyekjaer wrote:
>>>>>> When the tcan device comes out of reset it comes out in standby mode.
>>>>>> The m_can driver tries to access the control register but fails due to
>>>>>> the device is in standby mode.
>>>>>> So this patch will put the tcan device in normal mode before the m_can
>>>>>> driver does the initialization.
>>>>>>
>>>>>> Fixes: a229abeed7f7 ("can: tcan4x5x: Turn on the power before parsing the config")
>>>>>> Cc: stable@vger.kernel.org
>>>>>> Signed-off-by: Sean Nyekjaer <sean@geanix.com>
>>>>>
>>>>> Applied both to linux-can.
>>>>
>>>> Oh, the commit id for "can: tcan4x5x: Turn on the power before parsing
>>>> the config" have changed, since this morning :)
>>>
>>> Ahh, I see.
>>>
>>> Until there is a pull request (including a tag) the testing branch is
>>> subject to rebase. Meaning, when there is a patch, that needs update I'm
>>> happy to squash things into it.
>>>
>>> I'm squashing there two commits into one:
>>
>> It's two different authors :-)
> 
> No problem with me. I don't want to have a known broken patch in one
> pull request that gets fixed by another patch in that pull request.

No problem with me, either.
But it's not exactly the same problem they are fixing. They can exist 
separately.

Just do a you find best...

/Sean
