Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 285273D7B67
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 18:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbhG0Qvm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 12:51:42 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:43280 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229494AbhG0Qvl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 12:51:41 -0400
Received: from dispatch1-us1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 56AB82297C7
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 16:44:44 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.67.133])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 3343A2006D;
        Tue, 27 Jul 2021 16:44:43 +0000 (UTC)
Received: from mail3.candelatech.com (mail2.candelatech.com [208.74.158.173])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 06CFEB0005F;
        Tue, 27 Jul 2021 16:44:42 +0000 (UTC)
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 7D18913C2B1;
        Tue, 27 Jul 2021 09:44:42 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 7D18913C2B1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1627404282;
        bh=vgn+6tMoaX5JVIESNmOHkA57EICYghzHMKHHevNkyNU=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=OQGACFj6RMQyG9ATuX/gHoEFooLQZTI5F8MMwJqO+Cl0cVBO2jVGuMC4qxgI9dUnp
         Ga1qixyo7U1iMmHH2fZFgcYtUSUBDZkiYeVVMyZzu/MqusslOgIkLGnWuh+QCEdrIC
         HuZBegsGa6lB4UwgO8dwICCdXAdyed0SgzVzJVVc=
Subject: Re: very long boot times in 5.13 stable.
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <aeac0ff3-6606-3752-db6c-306a9c643f8f@candelatech.com>
 <YQA3qULTdCvWuVCo@kroah.com>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <7cfc9904-386d-2fcf-e4ee-fd88389ac761@candelatech.com>
Date:   Tue, 27 Jul 2021 09:44:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <YQA3qULTdCvWuVCo@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-MDID: 1627404283-g3BVaaLErMot
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/27/21 9:43 AM, Greg KH wrote:
> On Tue, Jul 27, 2021 at 09:10:11AM -0700, Ben Greear wrote:
>> Hello,
>>
>> My system was stable with 5.13.0, though there was a KASAN warning.
>> So, I upgrade to 5.13.5, and now it takes a very long time to fully boot to
>> login prompt, and I see this splat in the logs.
>>
>> I'm working on bisecting, but if someone has a clue, please let me know.
>>
>> [ 2187.021338] irq 4: nobody cared (try booting with the "irqpoll" option)
> 
> Have you tried booting with that option?

No, I figured I wanted to find root cause before enabling any work-around.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

