Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E68236EB9E8
	for <lists+stable@lfdr.de>; Sat, 22 Apr 2023 17:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbjDVPMA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Apr 2023 11:12:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjDVPL6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Apr 2023 11:11:58 -0400
Received: from mx2.zhaoxin.com (mx2.zhaoxin.com [203.110.167.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 313C71BE7
        for <stable@vger.kernel.org>; Sat, 22 Apr 2023 08:11:55 -0700 (PDT)
X-ASG-Debug-ID: 1682176311-1eb14e638841370001-OJig3u
Received: from ZXSHMBX3.zhaoxin.com (ZXSHMBX3.zhaoxin.com [10.28.252.165]) by mx2.zhaoxin.com with ESMTP id ljftPdxn0Gr5sTUK (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Sat, 22 Apr 2023 23:11:51 +0800 (CST)
X-Barracuda-Envelope-From: WeitaoWang-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.165
Received: from zxbjmbx1.zhaoxin.com (10.29.252.163) by ZXSHMBX3.zhaoxin.com
 (10.28.252.165) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Sat, 22 Apr
 2023 23:11:51 +0800
Received: from [192.168.0.100] (115.171.114.112) by zxbjmbx1.zhaoxin.com
 (10.29.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Sat, 22 Apr
 2023 23:11:49 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.165
Message-ID: <235c2ebc-ca9b-8765-0914-fcd839f1e45c@zhaoxin.com>
X-Barracuda-RBL-Trusted-Forwarder: 192.168.0.100
Date:   Sun, 23 Apr 2023 07:11:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2] UHCI:adjust zhaoxin UHCI controllers OverCurrent bit
 value
Content-Language: en-US
X-ASG-Orig-Subj: Re: [PATCH v2] UHCI:adjust zhaoxin UHCI controllers OverCurrent bit
 value
To:     Alan Stern <stern@rowland.harvard.edu>
CC:     <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <tonywwang@zhaoxin.com>,
        <weitaowang@zhaoxin.com>, <stable@vger.kernel.org>
References: <20230421174142.382602-1-WeitaoWang-oc@zhaoxin.com>
 <a55aa38d-0fbf-4a95-a2b2-40821815275f@rowland.harvard.edu>
From:   "WeitaoWang-oc@zhaoxin.com" <WeitaoWang-oc@zhaoxin.com>
In-Reply-To: <a55aa38d-0fbf-4a95-a2b2-40821815275f@rowland.harvard.edu>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [115.171.114.112]
X-ClientProxiedBy: ZXSHCAS1.zhaoxin.com (10.28.252.161) To
 zxbjmbx1.zhaoxin.com (10.29.252.163)
X-Barracuda-Connect: ZXSHMBX3.zhaoxin.com[10.28.252.165]
X-Barracuda-Start-Time: 1682176311
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://10.28.252.36:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 2276
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: 1.09
X-Barracuda-Spam-Status: No, SCORE=1.09 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=DATE_IN_FUTURE_06_12, DATE_IN_FUTURE_06_12_2
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.107774
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
        0.01 DATE_IN_FUTURE_06_12   Date: is 6 to 12 hours after Received: date
        3.10 DATE_IN_FUTURE_06_12_2 DATE_IN_FUTURE_06_12_2
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2023/4/21 22:59, Alan Stern wrote:
> On Sat, Apr 22, 2023 at 01:41:42AM +0800, Weitao Wang wrote:
>> OverCurrent condition is not standardized in the UHCI spec.
>> Zhaoxin UHCI controllers report OverCurrent bit active off.
>> In order to handle OverCurrent condition correctly, the uhci-hcd
>> driver needs to be told to expect the active-off behavior.
>>
>> Suggested-by: Alan Stern <stern@rowland.harvard.edu>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Weitao Wang <WeitaoWang-oc@zhaoxin.com>
>> ---
>> v1->v2
>>   - Modify the description of this patch.
>>   - Let Zhaoxin and VIA share a common oc_low flag
>>
>>   drivers/usb/host/uhci-pci.c | 9 +++++----
>>   1 file changed, 5 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/usb/host/uhci-pci.c b/drivers/usb/host/uhci-pci.c
>> index 3592f757fe05..034586911bb5 100644
>> --- a/drivers/usb/host/uhci-pci.c
>> +++ b/drivers/usb/host/uhci-pci.c
>> @@ -119,11 +119,12 @@ static int uhci_pci_init(struct usb_hcd *hcd)
>>   
>>   	uhci->rh_numports = uhci_count_ports(hcd);
>>   
>> -	/* Intel controllers report the OverCurrent bit active on.
>> -	 * VIA controllers report it active off, so we'll adjust the
>> -	 * bit value.  (It's not standardized in the UHCI spec.)
>> +	/* Intel controllers report the OverCurrent bit active on.  VIA
>> +	 * and ZHAOXIN controllers report it active off, so we'll adjust
>> +	 * the bit value.  (It's not standardized in the UHCI spec.)
>>   	 */
> 
> The style we use now for multi-line comments is:
> 
> 	/*
> 	 * Blah blah blah
> 	 * blah blah blah
> 	 */
> 
>> -	if (to_pci_dev(uhci_dev(uhci))->vendor == PCI_VENDOR_ID_VIA)
>> +	if (to_pci_dev(uhci_dev(uhci))->vendor == PCI_VENDOR_ID_VIA ||
>> +		to_pci_dev(uhci_dev(uhci))->vendor == PCI_VENDOR_ID_ZHAOXIN)
> 
> The indentation level of the continuation line should be different from
> the indentation of the statement below.  Otherwise it looks like the
> continuation line is part of the conditional block.
> 
I see, Thanks for your careful examination. I'll change it later.

Best Regards,
Weitao

> Alan Stern
> 
>>   		uhci->oc_low = 1;
>>   
>>   	/* HP's server management chip requires a longer port reset delay. */
>> -- 
>> 2.32.0
>>
> .
