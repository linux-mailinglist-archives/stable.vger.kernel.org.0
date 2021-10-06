Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFD142435C
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 18:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237359AbhJFQwI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 12:52:08 -0400
Received: from cmyk.emenem.pl ([217.79.154.63]:34220 "EHLO smtp.emenem.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231528AbhJFQwI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Oct 2021 12:52:08 -0400
X-Greylist: delayed 1833 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Oct 2021 12:52:05 EDT
X-Virus-Scanned: amavisd-new at emenem.pl
Received: from [192.168.1.10] (50-78-106-33-static.hfc.comcastbusiness.net [50.78.106.33])
        (authenticated bits=0)
        by cmyk.emenem.pl (8.17.1/8.17.1) with ESMTPSA id 196GJB1C031570
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Wed, 6 Oct 2021 18:19:12 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ans.pl; s=20190507;
        t=1633537155; bh=WYQZhngjheLOerpt927ZqOulyEfbN/mrKTbizSN6I8k=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To;
        b=BF5sU1EOAEnUg8cXqc1mHIgThzF3gpzDGSK9OUb2w83UPURuk44NzWk0LUmKRE1Yc
         6rj9isZTrrtEY8y51misdqb5XyfYqm+X0qSaE6o/FiD38fA0R6CIS9RrzKE4tesnxH
         CkrCbmWo9MoAxtEECYBENP6/oHp39noT7a93aEnM=
Subject: Re: Can we add both Samsung NCQ fixes
 (7a8526a5cd51cf5f070310c6c37dd7293334ac49 and
 8a6430ab9c9c87cb64c512e505e8690bbaee190b) to the -stable trees
From:   =?UTF-8?Q?Krzysztof_Ol=c4=99dzki?= <ole@ans.pl>
To:     stable@vger.kernel.org
Cc:     Kate Hsuan <hpa@redhat.com>, Hans de Goede <hdegoede@redhat.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <d8f08d3f-ffd8-3389-9199-feccc493b483@ans.pl>
 <567a9e2a-6096-6a6a-42b4-df7d3a39beb2@ans.pl>
 <cff65e13-4669-a1c9-b216-13f1d357fe55@ans.pl>
Message-ID: <72130d6c-00dc-9405-1b6f-bb4d508a60b4@ans.pl>
Date:   Wed, 6 Oct 2021 09:19:09 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <cff65e13-4669-a1c9-b216-13f1d357fe55@ans.pl>
Content-Type: text/plain; charset=utf-8
Content-Language: pl
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Third Time's the Charm, now with the proper stable@ address. ;)

On 2021-09-26 at 21:10, Krzysztof Olędzki wrote:
> (fixed Greg's e-mail)
> 
> Hi,
> 
> On 2021-09-20 at 19:32, Krzysztof Olędzki wrote:
>> Hi Greg, Sasha,
>>
>> On 2021-09-14 at 19:58, Krzysztof Olędzki wrote:
>>> Hi,
>>>
>>> Would it be possible to add both:
>>>  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=7a8526a5cd51cf5f070310c6c37dd7293334ac49
>>>  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8a6430ab9c9c87cb64c512e505e8690bbaee190b
>>> into the -stable trees?
>>>
>>> Right now only the second patch (8a6430ab9c9c87cb64c512e505e8690bbaee190b) is tagged with "Cc: stable@vger.kernel.org", but has not been include into 5.4.146-rc1 and is also not in stable-queue.git.
>>>
>>> If it helps, I have tested both of them on 5.4.145 and they apply cleanly.
>>
>>
>> Looks like 8a6430ab9c9c87cb64c512e505e8690bbaee190b - "libata: add ATA_HORKAGE_NO_NCQ_TRIM for Samsung 860 and 870 SSDs" has been included into the most recent wave of -stable kernels.
>>
>> Can we include 7a8526a5cd51cf5f070310c6c37dd7293334ac49 - "libata: Add ATA_HORKAGE_NO_NCQ_ON_ATI for Samsung 860 and 870 SSD." in the next releases, pretty please?
> 
> With the new set of -stable kernel just released, is this a good moment to re-ask for 7a8526a5cd51cf5f070310c6c37dd7293334ac49?
> 
> Thanks,
>  Krzysztof
> 

