Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0AF540CF6
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346879AbiFGSnU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352486AbiFGSls (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:41:48 -0400
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com [129.46.98.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B24F186BAE;
        Tue,  7 Jun 2022 10:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1654624734; x=1686160734;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mGYYhOXel+Cq15MHJ4ZaKZNkzLTSV7FVCLzTBPcMLrE=;
  b=qQNUAXzM1JJIGdvlYzpVz3xWr7T7sXj3R2bIp2ijmC6JIe6SEV3K+Ui4
   5jYIGAaylEp8f2+fTw6MW4lSDIbHZAMVZZ0eUwNPut03yJJ3rwPYAhTYt
   IIKCGUKbl0qnIWU7PXWP035mE7az1XIi253FxwcGR1PEl/V174stwRwnz
   w=;
Received: from ironmsg09-lv.qualcomm.com ([10.47.202.153])
  by alexa-out.qualcomm.com with ESMTP; 07 Jun 2022 10:58:53 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg09-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2022 10:58:53 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 7 Jun 2022 10:58:52 -0700
Received: from [10.226.59.182] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 7 Jun 2022
 10:58:51 -0700
Message-ID: <704f95a0-6846-7b60-9dd3-b5ba59c8be09@quicinc.com>
Date:   Tue, 7 Jun 2022 11:58:51 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: Patch "PCI: hv: Fix multi-MSI to allow more than one MSI vector"
 has been added to the 5.18-stable tree
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, Dexuan Cui <decui@microsoft.com>
CC:     "stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "Stephen Hemminger" <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "Lorenzo Pieralisi" <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        =?UTF-8?Q?Krzysztof_Wilczy=c5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>
References: <20220606110755.135215-1-sashal@kernel.org>
 <BYAPR21MB1270ADDD7775284F1187E823BFA29@BYAPR21MB1270.namprd21.prod.outlook.com>
 <Yp8w3tEtNVx8s37C@sashalap>
From:   Jeffrey Hugo <quic_jhugo@quicinc.com>
In-Reply-To: <Yp8w3tEtNVx8s37C@sashalap>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/7/2022 5:05 AM, Sasha Levin wrote:
> On Mon, Jun 06, 2022 at 05:02:41PM +0000, Dexuan Cui wrote:
>>> From: Sasha Levin <sashal@kernel.org>
>>> Sent: Monday, June 6, 2022 4:08 AM
>>> To: stable-commits@vger.kernel.org; quic_jhugo@quicinc.com
>>> Cc: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
>>> <haiyangz@microsoft.com>; Stephen Hemminger <sthemmin@microsoft.com>;
>>> Wei Liu <wei.liu@kernel.org>; Dexuan Cui <decui@microsoft.com>; Lorenzo
>>> Pieralisi <lorenzo.pieralisi@arm.com>; Rob Herring <robh@kernel.org>;
>>> Krzysztof Wilczyński <kw@linux.com>; Bjorn Helgaas <bhelgaas@google.com>
>>> Subject: Patch "PCI: hv: Fix multi-MSI to allow more than one MSI 
>>> vector" has
>>> been added to the 5.18-stable tree
>>>
>>> This is a note to let you know that I've just added the patch titled
>>>
>>>     PCI: hv: Fix multi-MSI to allow more than one MSI vector
>>
>> (+ stable@vger.kernel.org)
>>
>> Hi Sasha and stable kernel maintainers,
>> If we want to support multi-MSI in the pci-hyperv driver, we need all 
>> of the
>> 4 patches:
>>
>> 08e61e861a0e ("PCI: hv: Fix multi-MSI to allow more than one MSI vector")
>> 455880dfe292 ("PCI: hv: Fix hv_arch_irq_unmask() for multi-MSI")
>> b4b77778ecc5 ("PCI: hv: Reuse existing IRTE allocation in 
>> compose_msi_msg()")
>> a2bad844a67b ("PCI: hv: Fix interrupt mapping for multi-MSI")
>>
>> Multi-MSI can't work properly if we only pick up the first patch.
>>
>> We need to either pick up all the 4 patches to 5.18/5.17/etc. or pick 
>> up nothing.
>> I suggest we pick up all the 4 patches.
>> The patch author Jeffrey may want to chime in.
> 
> Hey Dexuan,
> 
> I wasn't trying to enable multi-MSI, I was just picking something that
> looked like a fix. I'll go ahead and drop it, thanks!
> 

IMO it is a fix to an existing feature - not adding a new one.  The 
driver enables Multi-MSI, advertises the support, but it doesn't work. 
The changes fix the driver so it actually works.

It would be my preference for these to be backported.  Ideally the 
distros would then pick them up, and it would make support easier.
