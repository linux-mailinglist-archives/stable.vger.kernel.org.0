Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C426D92ED
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 15:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388037AbfJPNub (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 09:50:31 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:38780 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728263AbfJPNub (ORCPT
        <rfc822;Stable@vger.kernel.org>); Wed, 16 Oct 2019 09:50:31 -0400
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9GDjjCn029579;
        Wed, 16 Oct 2019 15:50:11 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=STMicroelectronics;
 bh=527ltYT6YERatRv34AkQbvrPh47k6K/dkBC5Vs1/wNE=;
 b=zjZ7u3cSKtyj2F/lskr1y/lfTxRCoiKrMgtAYAPJOIHJd8NOx2NVqx6on40ldW1v/oK1
 jaCFSpNtqXpwuEbDC5eg8LNFEHEk2loiY0cJRQp16i9kuhPb2x6uZqPXqnNkdZNUl3eC
 MCIKO+GplcwcRt+bs0Rc0yupTNuV75wyBsHf7M0oRlwP5rohqEPyR68zIm3ynqsHXwDV
 VsJzbAU+bURxTRsIZLWp1zP4G6YsSRaA5LJ2UY1+HSAOYzCZlbYRbHbRHWy83mqF7Kxj
 bpS7zB5xYzARCljDCk7uXgqYqDp22NR+aP69Al27MuANCzkA2eNPF4pvO1NMO5mv+6b3 8A== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx08-00178001.pphosted.com with ESMTP id 2vk5qjej2p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Oct 2019 15:50:10 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 7E16F100034;
        Wed, 16 Oct 2019 15:50:10 +0200 (CEST)
Received: from Webmail-eu.st.com (Safex1hubcas21.st.com [10.75.90.44])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 6CBD021CA74;
        Wed, 16 Oct 2019 15:50:10 +0200 (CEST)
Received: from SAFEX1HUBCAS23.st.com (10.75.90.46) by SAFEX1HUBCAS21.st.com
 (10.75.90.44) with Microsoft SMTP Server (TLS) id 14.3.439.0; Wed, 16 Oct
 2019 15:50:10 +0200
Received: from [10.48.0.192] (10.48.0.192) by webmail-ga.st.com (10.75.90.48)
 with Microsoft SMTP Server (TLS) id 14.3.439.0; Wed, 16 Oct 2019 15:50:08
 +0200
Subject: Re: FAILED: patch "[PATCH] iio: adc: stm32-adc: fix a race when using
 several adcs with" failed to apply to 4.19-stable tree
To:     Sasha Levin <sashal@kernel.org>
CC:     <gregkh@linuxfoundation.org>, <Jonathan.Cameron@huawei.com>,
        <Stable@vger.kernel.org>
References: <15710686967202@kroah.com> <20191015025516.GI31224@sasha-vm>
From:   Fabrice Gasnier <fabrice.gasnier@st.com>
Message-ID: <2e053a33-5225-79dd-0dc8-69e388c80894@st.com>
Date:   Wed, 16 Oct 2019 15:50:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191015025516.GI31224@sasha-vm>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.48.0.192]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-16_06:2019-10-16,2019-10-16 signatures=0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/15/19 4:55 AM, Sasha Levin wrote:
> On Mon, Oct 14, 2019 at 05:58:16PM +0200, gregkh@linuxfoundation.org wrote:
>>
>> The patch below does not apply to the 4.19-stable tree.
>> If someone wants it applied there, or to any other stable or longterm
>> tree, then please email the backport, including the original git commit
>> id to <stable@vger.kernel.org>.
>>
>> thanks,
>>
>> greg k-h
>>
>> ------------------ original commit in Linus's tree ------------------
>>
>> From dcb10920179ab74caf88a6f2afadecfc2743b910 Mon Sep 17 00:00:00 2001
>> From: Fabrice Gasnier <fabrice.gasnier@st.com>
>> Date: Tue, 17 Sep 2019 14:38:16 +0200
>> Subject: [PATCH] iio: adc: stm32-adc: fix a race when using several
>> adcs with
>> dma and irq
>>
>> End of conversion may be handled by using IRQ or DMA. There may be a
>> race when two conversions complete at the same time on several ADCs.
>> EOC can be read as 'set' for several ADCs, with:
>> - an ADC configured to use IRQs. EOCIE bit is set. The handler is
>> normally
>>  called in this case.
>> - an ADC configured to use DMA. EOCIE bit isn't set. EOC triggers the DMA
>>  request instead. It's then automatically cleared by DMA read. But the
>>  handler gets called due to status bit is temporarily set (IRQ triggered
>>  by the other ADC).
>> So both EOC status bit in CSR and EOCIE control bit must be checked
>> before invoking the interrupt handler (e.g. call ISR only for
>> IRQ-enabled ADCs).
>>
>> Fixes: 2763ea0585c9 ("iio: adc: stm32: add optional dma support")
>>
>> Signed-off-by: Fabrice Gasnier <fabrice.gasnier@st.com>
>> Cc: <Stable@vger.kernel.org>
>> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> 
> It would be nice if a stable patch wouldn't depend on a massive code
> movement patch...
> 
> Anyway, I ported both to 4.19 as it was just a minor missing dependency,
> but 4.14 requires more work I'll leave to someone who knows that code
> better than me.
> 

Hi Sasha,

Many thanks for the effort to port it on 4.19. I just sent a port for
these patches on 4.14 to stable@vger.kernel.org. Please let me know if
this is correct.

Best Regards,
Fabrice
