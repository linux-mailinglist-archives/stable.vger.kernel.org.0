Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 499B74902FC
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 08:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237558AbiAQHiK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 02:38:10 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:46654 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233071AbiAQHiJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 02:38:09 -0500
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20GMK1XY032410;
        Mon, 17 Jan 2022 08:37:48 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=selector1;
 bh=/SNGdY3EQVSNuahotUyAeXgj55tr+Btw2r79mHMIAqs=;
 b=1n5+bzmuzkeFRtr/AHIYVezYaItONZpCk3sXbbJCAqqNMboi4El2Yq7X3PgS7AvNb3GU
 k2yOQ0w8dA1DCssdFBIxlxf0Vip4mftOdyOk5oN1h7kgZcYetaQstLa4Lmo8/+fMnUqf
 b6m1s8ceQzS9FaJBKYAxHKi7sTlznjkf6B+WCLSeRLN6vdn6vWmRIM+MJnIR+Mum5V9D
 m88IEaHa7IWtRCfykPkaP4w9Y20uB4G2ZkTtUQrxgXH/Y0333WuSh0VaNLODQzQ/gmgN
 uUrJWkBg9wtlR85nLKM0bg0abvthzetMYcs+hwU6G3nHcpuKWhJ7Y5xy7waEya6yAPDQ Tg== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com (PPS) with ESMTPS id 3dmq5g2vph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 08:37:47 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 0FED7100034;
        Mon, 17 Jan 2022 08:37:46 +0100 (CET)
Received: from Webmail-eu.st.com (sfhdag2node1.st.com [10.75.127.4])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 5E0B820DD0E;
        Mon, 17 Jan 2022 08:37:46 +0100 (CET)
Received: from lmecxl0573.lme.st.com (10.75.127.44) by SFHDAG2NODE1.st.com
 (10.75.127.4) with Microsoft SMTP Server (TLS) id 15.0.1497.26; Mon, 17 Jan
 2022 08:37:45 +0100
Subject: Re: [PATCH v2] spi: stm32-qspi: Update spi registering
To:     Lukas Wunner <lukas@wunner.de>
CC:     Mark Brown <broonie@kernel.org>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        <linux-spi@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <christophe.kerello@foss.st.com>,
        <stable@vger.kernel.org>
References: <20220112144424.5278-1-patrice.chotard@foss.st.com>
 <20220116125205.GA18267@wunner.de>
From:   Patrice CHOTARD <patrice.chotard@foss.st.com>
Message-ID: <b07ba47f-2709-6b10-2332-7a0d163401bc@foss.st.com>
Date:   Mon, 17 Jan 2022 08:37:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220116125205.GA18267@wunner.de>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.75.127.44]
X-ClientProxiedBy: SFHDAG2NODE2.st.com (10.75.127.5) To SFHDAG2NODE1.st.com
 (10.75.127.4)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-17_02,2022-01-14_01,2021-12-02_01
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Lukas

On 1/16/22 1:52 PM, Lukas Wunner wrote:
> On Wed, Jan 12, 2022 at 03:44:24PM +0100, patrice.chotard@foss.st.com wrote:
>> diff --git a/drivers/spi/spi-stm32-qspi.c b/drivers/spi/spi-stm32-qspi.c
>> index 514337c86d2c..09839a3dbb26 100644
>> --- a/drivers/spi/spi-stm32-qspi.c
>> +++ b/drivers/spi/spi-stm32-qspi.c
>> @@ -688,7 +688,7 @@ static int stm32_qspi_probe(struct platform_device *pdev)
>>  	struct resource *res;
>>  	int ret, irq;
>>  
>> -	ctrl = spi_alloc_master(dev, sizeof(*qspi));
>> +	ctrl = devm_spi_alloc_master(dev, sizeof(*qspi));
>>  	if (!ctrl)
>>  		return -ENOMEM;
>>  
>> @@ -784,7 +784,7 @@ static int stm32_qspi_probe(struct platform_device *pdev)
>>  	pm_runtime_enable(dev);
>>  	pm_runtime_get_noresume(dev);
>>  
>> -	ret = devm_spi_register_master(dev, ctrl);
>> +	ret = spi_register_master(ctrl);
>>  	if (ret)
>>  		goto err_pm_runtime_free;
>>
> 
> Unfortunately this patch is still not correct:  It introduces a
> double free in the probe error path.

Argh yes, my bad.

> 
> You need to remove this...
> 
> err_master_put:
> 	spi_master_put(qspi->ctrl);
> 
> ...and replace all the gotos in stm32_qspi_probe() which jump
> to the err_master_put label with a return statement.
> 
> Thanks,
> 
> Lukas
> 
Thanks 
Patrice
