Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 056FC53F30C
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 02:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233647AbiFGAoY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 20:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232814AbiFGAoX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 20:44:23 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67396A0D25
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 17:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1654562661; x=1686098661;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=3xO1OjIrIFBT7N9VBDpjewtzKV2dqjN7tvfny/85z8U=;
  b=ZSAOTsfiTK83LPPZVWktQVM7rHeE+2gnPPCuBcupo8dLThsPfJ4zu0vZ
   dz40RnEf266bx8H5vMCJou0TmBTrS+t6IsLRkR2nRXt/OENltQFmC5mrr
   okzftyOxpC6hEvLHrs9pTmY4sYDvnWkuISQsK/5SqdToP6FjLLjQW2dV2
   lbtHb4ls9yheW+zoTCmQWRxTtmj/gaZz4eHF9/3wuiUmrmMmUrLKLx/Yz
   QXoY83IM3D+JUJgDiiM+T1+w5yerrsaPpxYB9KKXh8SHFBsb/D0hNeyjt
   4aERtSpEl+hC3wdWYjaMKf8dkYzCQ+k1MawZv/XWAAbX5qk63Zaz4lOVX
   g==;
X-IronPort-AV: E=Sophos;i="5.91,282,1647273600"; 
   d="scan'208";a="207281010"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jun 2022 08:44:19 +0800
IronPort-SDR: fQ+WgPimsRn46l7HBfQ6fO9ChhLLu1vTk+xKsadN/Dt573JsR4QanSJNuJKIpo/RByyp6jArfn
 00wY4vre+VDlmdFM40/52tWz38G8PD8IRASX9/ObeRfXcKqbVur4jYgzkSxVpIWlY3Ma5y7S1o
 k5ZtKEDYMKVq5rLc4O6pvS+AMAEVjVsv22DBjdgd1wCTJzl906v0OldJlUOWHY621cEmTPk6+i
 BSa9wLxaydibVJl2RwlhXKpC0sfeOX/EDJMRy83QZ27MRAGcaLAvq2lJ0tWqgS+NOo8RaFbozI
 X5mVgm8iL0Z/ZfEdbvb188GN
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Jun 2022 17:07:40 -0700
IronPort-SDR: 3o4Ma7ePTzrLJM5lwIvKkDC+kJjGj/i7iEU5WuFqSJicNvt1wf+ZgJhpytjKrjZrMqROg6Q+xS
 cDgsNEmCxFLcQ2OuoOdeOGMQDBnPs07RpqIxJlIY7ugLoOkP26/xsxOUJ5OYGbm62N7yKFV3g2
 6cwO6p2olbGlfW09uKg4rTq5rkAgVCWI2QkldghtK+fBx5BsNZrH9US6rRBy6uUkjnrolB4l9N
 EMFdNELswBKIdROSZ3OBw+rhBL627rXsOCYO1+HyYjpzC5BuW2FV39m4QQw+nXs1gFwfzz3lG5
 YPs=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Jun 2022 17:44:20 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LHBSg1Tthz1SVp1
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 17:44:19 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:references:to:from:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1654562658; x=1657154659; bh=3xO1OjIrIFBT7N9VBDpjewtzKV2dqjN7tvf
        ny/85z8U=; b=KK4h883YsA1HQI3+GwPSkK30qlkK00m5GwjyTXQvKRKqsVu5gNx
        V+mWPcYt2dBSgiaxI6Pb2FPngaXdR21Knl7bNK61UskCAJ3YT66Il0k7PM2k0T8o
        vldY44gyTelnI9PJz5mxlD1zpJIJzcl2G7MxEDuXmzbsgWMygEusU1W5B3Jlq9Fy
        8glpsXJxAfH9M7Ha21tJFpAU0nlHnFL+HFcmpmOJadPcydnzaW160PtVSYMRepC4
        kzHJjE5lNlotir4RGE5oJ6Py2zILhVJG9pB6n3bsfHuAHgpoETH2N7pAjLB3e9HL
        j9/pD7PC7inBTSl/YVcaJUYr37jC/I4Bqbw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ZNlUz7gzg5yg for <stable@vger.kernel.org>;
        Mon,  6 Jun 2022 17:44:18 -0700 (PDT)
Received: from [10.89.82.246] (c02drav6md6t.dhcp.fujisawa.hgst.com [10.89.82.246])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LHBSd3M3Xz1Rvlc;
        Mon,  6 Jun 2022 17:44:17 -0700 (PDT)
Message-ID: <95d7a149-3c16-0aa6-db4b-a8d84fd125aa@opensource.wdc.com>
Date:   Tue, 7 Jun 2022 09:44:16 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH v2 3/3] scsi: sd: Fix interpretation of VPD B9h length
Content-Language: en-US
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     Tyler Erickson <tyler.erickson@seagate.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        muhammad.ahmad@seagate.com, stable@vger.kernel.org
References: <20220602225113.10218-1-tyler.erickson@seagate.com>
 <20220602225113.10218-4-tyler.erickson@seagate.com>
 <fcef5536-a4aa-f6f2-5e9a-c39708a74a50@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <fcef5536-a4aa-f6f2-5e9a-c39708a74a50@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/06/03 10:30, Damien Le Moal wrote:
> On 6/3/22 07:51, Tyler Erickson wrote:
>> Fixing the interpretation of the length of the B9h VPD page
>> (concurrent positioning ranges). Adding 4 is necessary as
>> the first 4 bytes of the page is the header with page number
>> and length information. Adding 3 was likely a misinterpretation
>> of the SBC-5 specification which sets all offsets starting at zero.
>>
>> This fixes the error in dmesg:
>> [ 9.014456] sd 1:0:0:0: [sda] Invalid Concurrent Positioning Ranges VPD page
>>
>> Cc: stable@vger.kernel.org
>> Fixes: e815d36548f0 ("scsi: sd: add concurrent positioning ranges support")
>> Signed-off-by: Tyler Erickson <tyler.erickson@seagate.com>
>> Reviewed-by: Muhammad Ahmad <muhammad.ahmad@seagate.com>
>> Tested-by: Michael English <michael.english@seagate.com>
>> ---
>>  drivers/scsi/sd.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index 749316462075..f25b0cc5dd21 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -3072,7 +3072,7 @@ static void sd_read_cpr(struct scsi_disk *sdkp)
>>  		goto out;
>>  
>>  	/* We must have at least a 64B header and one 32B range descriptor */
>> -	vpd_len = get_unaligned_be16(&buffer[2]) + 3;
>> +	vpd_len = get_unaligned_be16(&buffer[2]) + 4;
>>  	if (vpd_len > buf_len || vpd_len < 64 + 32 || (vpd_len & 31)) {
>>  		sd_printk(KERN_ERR, sdkp,
>>  			  "Invalid Concurrent Positioning Ranges VPD page\n");
> 
> Martin,
> 
> If you take this one:
> 
> Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> 

Martin,

Ping ?
How do you want to handle this one ? I can take it if you want (need your
acked-by) or you can take it through the scsi tree.

Thanks !

-- 
Damien Le Moal
Western Digital Research
