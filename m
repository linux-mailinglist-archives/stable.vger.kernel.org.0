Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 265A56DDE6B
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 16:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbjDKOrs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 10:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjDKOrr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 10:47:47 -0400
X-Greylist: delayed 602 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 11 Apr 2023 07:47:40 PDT
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [81.169.146.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C8110B
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 07:47:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1681224459; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=ACbkL4iKA+IZonDlf57Ig7wAirzrPAcBUNbR9G3YzPiydpRAaarSYxnzb637gWXtj2
    VZTBlpLptnkR/EsRjLjgWA9CXJa5iGXfZW1MqZQRcGS60GqYhFjFkhSP8vX4XIYGolZw
    1ASNALyeVHyEGtycPqpHm4CvMowFxofHqPbrC2wf5IsIX7LFv9PX/tOBXHOGgFVevtOz
    lgW6yVoINqxNsh/Hqfwk8+anXHqbmvPTFZWE7EKUYJoVW7of0WneMXR7pq8YZyInYF0Q
    /0RJoQrpZ0rdoawn6nquqyZE6QDYXkSgPekMSRTU+WNdQmsW9aCpZCdi3ighWNXjxsGL
    zwgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1681224459;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=cWebtmwBV+Ofynm/+9IMx/2hHoN6hbGYqs+fEywDDBE=;
    b=E8aGMOJpRQFmScpJ6Q1Ir38pq7W8dnFde867bXjW8qFqwMY7x7k9FJT1kA/dxREevM
    bqGRM1RxeSsmOX0c9VGymd4edPrJepSqPVqixfrCfKCxaCMdbh3zXSMUPAGW0cYjRe49
    UjwsBUYVyopu4E8HRjr0HaZegF6wBj0cxS+FYrLhISqxHVLX+eHKU4J79eAA+6lEQUuc
    bKjP78N8C87JFxpduUQPjdxPnexQBKmO07z2ZN3nEPVn4B8QiL6nF7cUxcR7wYECsrkv
    2fdLfuhnW1gFs+W2TP5mjnP2sDOe3dQIvpECDEnKhCtmc48TCgRHMGVr5iADbgtYKGw5
    reOA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1681224459;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=cWebtmwBV+Ofynm/+9IMx/2hHoN6hbGYqs+fEywDDBE=;
    b=CNf8VHJs7Zer2XPWmdNInv3HdK8xJ2gtMKozk9sT8i1hEZORNlQnA7PF0sOBGB9SlM
    crzr6Ps1xvtbR3pHtnTBZ6hzA+1wgtkxY5yTkOZeX8DQii9FSSEumbkPBvr4lqxEIM+x
    /N8ytImphmfnI3HE96btP1wEdSlwevPGM44vGxwuvIRHIBzkcftvbPRmXUTshlH2x/aG
    qtJzeH6JMJBTHBC4y4QtjWoFcrMDQXKwXbhm6PJyMv/qgpgMAXHQely/pz/XIrjyw8PK
    jL7wDWy0pVl7gOSlf/EXcaQSbBaEMfNxapVDhlLvznHh+AgGFe2n6otb/pDTl1gube2/
    HErQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1681224459;
    s=strato-dkim-0003; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=cWebtmwBV+Ofynm/+9IMx/2hHoN6hbGYqs+fEywDDBE=;
    b=AwwoZS+h1+Rs258G7iCZiYdBlkwIulIJdrwDVbuvSf10GETQjUrZYhk5kq6QEMh9/E
    qHO9I3hXDJ4s2FUVbBBg==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1q3fUdVyJvGL+KpQ/ths="
Received: from [192.168.44.111]
    by smtp.strato.de (RZmta 49.4.0 AUTH)
    with ESMTPSA id x06214z3BElbH1f
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 11 Apr 2023 16:47:37 +0200 (CEST)
Message-ID: <6e8d5542-2173-3bf7-4022-636d5ee4c461@hartkopp.net>
Date:   Tue, 11 Apr 2023 16:47:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: FAILED: patch "[PATCH] can: isotp: isotp_recvmsg(): use
 sock_recv_cmsgs() to get" failed to apply to 5.10-stable tree
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     mkl@pengutronix.de, stable@vger.kernel.org
References: <2023041107-basically-gas-eb2c@gregkh>
 <9dadb8ab-f8d5-7ce3-c110-7bcae1bfb00e@hartkopp.net>
 <2023041146-reveler-scooter-ecc6@gregkh>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <2023041146-reveler-scooter-ecc6@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/11/23 16:40, Greg KH wrote:
> On Tue, Apr 11, 2023 at 04:34:25PM +0200, Oliver Hartkopp wrote:
>> Hi Greg,
>>
>> this must be a false positive for 5.10 and 5.15.
>>
>> I can apply the commit 0145462fc802cd447ef5d029758043c7f15b4b1e on 5.10.y
>> and 5.15.y without problems as the code around
>>
>>      sock_recv_timestamp(msg, sk, skb);
>>
>> did not change from 5.10 to 6.3-rc
>>
>> But 'git am' tells the offset is about ~80 lines.
>> Could this be the reason for the failure?
> 
> No, the failure is:
> 
>> On 4/11/23 13:36, gregkh@linuxfoundation.org wrote:
>>>
>>> The patch below does not apply to the 5.10-stable tree.
>>> If someone wants it applied there, or to any other stable or longterm
>>> tree, then please email the backport, including the original git commit
>>> id to <stable@vger.kernel.org>.
>>>
>>> To reproduce the conflict and resubmit, you may use the following commands:
>>>
>>> git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.10.y
>>> git checkout FETCH_HEAD
>>> git cherry-pick -x 0145462fc802cd447ef5d029758043c7f15b4b1e
>>> # <resolve conflicts, build, test, etc.>
>>> git commit -s
>>> git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023041107-basically-gas-eb2c@gregkh' --subject-prefix 'PATCH 5.10.y' HEAD^..
>>>
>>> Possible dependencies:
>>>
>>> 0145462fc802 ("can: isotp: isotp_recvmsg(): use sock_recv_cmsgs() to get SOCK_RXQ_OVFL infos")
>>>
>>> thanks,
>>>
>>> greg k-h
>>>
>>> ------------------ original commit in Linus's tree ------------------
>>>
>>>   From 0145462fc802cd447ef5d029758043c7f15b4b1e Mon Sep 17 00:00:00 2001
>>> From: Oliver Hartkopp <socketcan@hartkopp.net>
>>> Date: Thu, 30 Mar 2023 19:02:48 +0200
>>> Subject: [PATCH] can: isotp: isotp_recvmsg(): use sock_recv_cmsgs() to get
>>>    SOCK_RXQ_OVFL infos
>>>
>>> isotp.c was still using sock_recv_timestamp() which does not provide
>>> control messages to detect dropped PDUs in the receive path.
>>>
>>> Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
>>> Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
>>> Link: https://lore.kernel.org/all/20230330170248.62342-1-socketcan@hartkopp.net
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
>>>
>>> diff --git a/net/can/isotp.c b/net/can/isotp.c
>>> index 9bc344851704..47c2ebad10ed 100644
>>> --- a/net/can/isotp.c
>>> +++ b/net/can/isotp.c
>>> @@ -1120,7 +1120,7 @@ static int isotp_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
>>>    	if (ret < 0)
>>>    		goto out_err;
>>> -	sock_recv_timestamp(msg, sk, skb);
>>> +	sock_recv_cmsgs(msg, sk, skb);
> 
> This function is not in the 5.15.y or 5.10.y tree, so it breaks the
> build.

Ah, that's the point! Thanks!

Then this patch can indeed not be applied and you simply skip them and I 
do not have any requirement to send a 'backported' patch.

Good.

Many thanks,
Oliver
