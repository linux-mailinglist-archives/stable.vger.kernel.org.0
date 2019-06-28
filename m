Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFC959232
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 05:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbfF1DvJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jun 2019 23:51:09 -0400
Received: from smtp2207-205.mail.aliyun.com ([121.197.207.205]:57719 "EHLO
        smtp2207-205.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726748AbfF1DvJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jun 2019 23:51:09 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07491465|-1;CH=green;DM=CONTINUE|CONTINUE|true|0.348959-0.0103707-0.64067;FP=0|0|0|0|0|-1|-1|-1;HT=e02c03299;MF=liaoweixiong@allwinnertech.com;NM=1;PH=DS;RN=13;RT=13;SR=0;TI=SMTPD_---.Er3LMMF_1561693861;
Received: from 172.16.10.102(mailfrom:liaoweixiong@allwinnertech.com fp:SMTPD_---.Er3LMMF_1561693861)
          by smtp.aliyun-inc.com(10.147.42.16);
          Fri, 28 Jun 2019 11:51:02 +0800
Subject: Re: [RESEND PATCH v2] mtd: spinand: read return badly if the last
 page has bitflips
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Schrempf Frieder <frieder.schrempf@kontron.de>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuanhong Guo <gch981213@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
References: <1561424549-784-1-git-send-email-liaoweixiong@allwinnertech.com>
 <20190625030807.GA11074@kroah.com>
 <97adf58f-4771-90f1-bdaf-5a9d00eef768@kontron.de>
 <20190627190644.25aaaf31@xps13> <20190627201742.34059cdf@xps13>
From:   liaoweixiong <liaoweixiong@allwinnertech.com>
Message-ID: <26a4597e-3881-73a2-07e3-6171ddd15d51@allwinnertech.com>
Date:   Fri, 28 Jun 2019 11:51:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190627201742.34059cdf@xps13>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Miquel,

On 2019/6/28 AM2:17, Miquel Raynal wrote:
> Hi Miquel,
> 
> Miquel Raynal <miquel.raynal@bootlin.com> wrote on Thu, 27 Jun 2019
> 19:06:44 +0200:
> 
>> Hello,
>>
>> Schrempf Frieder <frieder.schrempf@kontron.de> wrote on Tue, 25 Jun
>> 2019 07:04:06 +0000:
>>
>>> Hi liaoweixiong,
>>>
>>> On 25.06.19 05:08, Greg KH wrote:  
>>>> On Tue, Jun 25, 2019 at 09:02:29AM +0800, liaoweixiong wrote:    
>>>>> In case of the last page containing bitflips (ret > 0),
>>>>> spinand_mtd_read() will return that number of bitflips for the last
>>>>> page. But to me it looks like it should instead return max_bitflips like
>>>>> it does when the last page read returns with 0.
>>>>>
>>>>> Signed-off-by: liaoweixiong <liaoweixiong@allwinnertech.com>  
>>
>> Please write your entire official first/last name(s)
>>

OK.

>>>>> Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
>>>>> Reviewed-by: Frieder Schrempf <frieder.schrempf@kontron.de>  
>>
>> I am waiting your next version with Acked-by instead of Rewieved-by
>> tags and Greg's comment addressed.
> 
> Sorry for the mistake, R-b tags are fine here, don't touch that.
> The rest needs to be fixed though.
> 

OK.

>>>>> Fixes: 7529df465248 ("mtd: nand: Add core infrastructure to support SPI NANDs")  
>>
>> Finally, when we ask you to resend a patch, it means sending a new
>> version of the patch. So in the subject, you should not use the
>> [RESEND] keyword (which means you are sending something again exactly
>> as it was before, you just got ignored, for example) but instead you
>> should increment the version number (v3) and also write a nice
>> changelog after the three dashes '---' (will be ignored by Git when
>> applying).
>>
>> I would like to queue this for the next release so if you can do it
>> ASAP, that would be great.
>>

I will do it right now.

>> Thank you,
>> Miquèl
> 
> 
> 
> 
> Thanks,
> Miquèl
> 

-- 
liaoweixiong
