Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA27D54E03
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 13:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbfFYL4F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 07:56:05 -0400
Received: from smtp2207-205.mail.aliyun.com ([121.197.207.205]:51166 "EHLO
        smtp2207-205.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726871AbfFYL4F (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jun 2019 07:56:05 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.08232059|-1;CH=green;DM=CONTINUE|CONTINUE|true|0.0138277-0.00107238-0.9851;FP=0|0|0|0|0|-1|-1|-1;HT=e02c03276;MF=liaoweixiong@allwinnertech.com;NM=1;PH=DS;RN=13;RT=13;SR=0;TI=SMTPD_---.Epy0fp2_1561463760;
Received: from 172.16.10.102(mailfrom:liaoweixiong@allwinnertech.com fp:SMTPD_---.Epy0fp2_1561463760)
          by smtp.aliyun-inc.com(10.147.41.158);
          Tue, 25 Jun 2019 19:56:01 +0800
Subject: Re: [RESEND PATCH v2] mtd: spinand: read return badly if the last
 page has bitflips
To:     Schrempf Frieder <frieder.schrempf@kontron.de>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuanhong Guo <gch981213@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
References: <1561424549-784-1-git-send-email-liaoweixiong@allwinnertech.com>
 <20190625030807.GA11074@kroah.com>
 <97adf58f-4771-90f1-bdaf-5a9d00eef768@kontron.de>
From:   liaoweixiong <liaoweixiong@allwinnertech.com>
Message-ID: <814a343e-e4c4-3ef2-29e2-d6c56f3d5bbb@allwinnertech.com>
Date:   Tue, 25 Jun 2019 19:56:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <97adf58f-4771-90f1-bdaf-5a9d00eef768@kontron.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Oh, i am sorry that i had misunderstanded your letter.
Thank you for your document and guidance.

On 2019/6/25 PM 3:04, Schrempf Frieder wrote:
> Hi liaoweixiong,
> 
> On 25.06.19 05:08, Greg KH wrote:
>> On Tue, Jun 25, 2019 at 09:02:29AM +0800, liaoweixiong wrote:
>>> In case of the last page containing bitflips (ret > 0),
>>> spinand_mtd_read() will return that number of bitflips for the last
>>> page. But to me it looks like it should instead return max_bitflips like
>>> it does when the last page read returns with 0.
>>>
>>> Signed-off-by: liaoweixiong <liaoweixiong@allwinnertech.com>
>>> Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
>>> Reviewed-by: Frieder Schrempf <frieder.schrempf@kontron.de>
>>> Fixes: 7529df465248 ("mtd: nand: Add core infrastructure to support SPI NANDs")
>>> ---
>>>   drivers/mtd/nand/spi/core.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> <formletter>
>>
>> This is not the correct way to submit patches for inclusion in the
>> stable kernel tree.  Please read:
>>      https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
>> for how to do this properly.
>>
>> </formletter>
> 
> FYI, you should not send the patch to stable@vger.kernel.org, but 
> instead, as I said in my other reply, add the tag "Cc: 
> stable@vger.kernel.org". See "Option 1" in the document Greg referred to.
> 
> Thanks,
> Frieder
> 

-- 
liaoweixiong
