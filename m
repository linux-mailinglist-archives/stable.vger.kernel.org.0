Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88E17102793
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 16:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbfKSPEr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 10:04:47 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:17485 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727124AbfKSPEr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 10:04:47 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dd4048f0000>; Tue, 19 Nov 2019 07:04:47 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 19 Nov 2019 07:04:46 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 19 Nov 2019 07:04:46 -0800
Received: from [10.25.75.114] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 19 Nov
 2019 15:04:43 +0000
Subject: Re: stable request: PCI: tegra: Enable Relaxed Ordering only for
 Tegra20 & Tegra30
To:     Ben Hutchings <ben@decadent.org.uk>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>, Jon Hunter <jonathanh@nvidia.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Manikanta Maddireddy <mmaddireddy@nvidia.com>,
        Krishna Thota <kthota@nvidia.com>
References: <11251eb0-5675-9d3d-d15f-c346781e2bff@nvidia.com>
 <20191111130908.GA448544@kroah.com>
 <9d7871e7-f8aa-1ed5-dc2e-37ba6f218a2f@nvidia.com>
 <cd787fce-3675-a2d1-90a7-5fa0c4b3f946@nvidia.com>
 <f63d4cd6578e297ebbfbaa81842f89410d495587.camel@decadent.org.uk>
X-Nvconfidentiality: public
From:   Vidya Sagar <vidyas@nvidia.com>
Message-ID: <0cc0738a-d10f-4901-3f79-c36d50732a7d@nvidia.com>
Date:   Tue, 19 Nov 2019 20:34:40 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <f63d4cd6578e297ebbfbaa81842f89410d495587.camel@decadent.org.uk>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/19/2019 8:01 PM, Ben Hutchings wrote:
> On Mon, 2019-11-18 at 12:05 +0530, Vidya Sagar wrote:
>> On 11/11/2019 8:52 PM, Vidya Sagar wrote:
>>> On 11/11/2019 6:39 PM, Greg Kroah-Hartman wrote:
>>>> On Mon, Nov 11, 2019 at 06:24:53PM +0530, Vidya Sagar wrote:
>>>>> Hi Greg,
>>>>> We noticed that the Tegra PCIe host controller driver enabled
>>>>> "Relaxed Ordering" bit in the PCIe configuration space for "all"
>>>>> devices erroneously. We pushed a fix for this through the
>>>>> commit: 7be142caabc4780b13a522c485abc806de5c4114 and it has been
>>>>> soaking in main line for the last four months.
>>>>> Based on the discussion we had @ http://patchwork.ozlabs.org/patch/1127604/
>>>>> we would now like to push it to the following stable kernels
>>>>> 4.19                  : Applies cleanly
>>>>> 3.16, 4.4, 4.9 & 4.14 : Following equivalent patch needs to be used as the
>>>>>                           file was at drivers/pci/host/pci-tegra.c earlier
>>>>>                           (and moved to drivers/pci/controller/pci-tegra.c starting 4.19)
>>>>
>>>> All now queued up (except for 3.16, that's Ben's tree, he will get to it
>>>> soon.)
>>>>
>> Hi Ben,
>> Could you please queue this up for 3.16 as well?
> 
> OK, I've added it to my queue.
> 
> Ben.
Thanks Ben
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
	t=1574175887; bh=uXgYUHwtrZapitSGWf5JwJRJHk5Ptu14CGrFy5WPBBY=;
	h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
	 Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
	 X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
	 Content-Transfer-Encoding;
	b=BPvs5cLXDhhzLY5asc+jfjOrcDfSlyLorXJ5IgqoZzGwtoQ5I7z6XjucTqpIfjqvw
	 vygAgc9INi1iMl3JQz19LURImeo9BxUh7BSosY61mt8KGlFI0vWOiCBtdKiWMy7avG
	 V9pqAEnRT6/i4VNoqZdFLItXcW8UXe/JP8Pw5vFyQn4+XzGDefCFLqGLySYDcUH8E0
	 djZWIOywbATPq1ULSYYChrKdqoRMTbhz2C1cA4f2LTMzoOB27bFwjRJxEGuMjIAYT+
	 m1Q/FvH2fSse30bw3za+YkstE61vC8SyMV2/4sOT1vb4JNVsVI9/0GyguV2syIrmlR
	 KjiT61+BAXAkg==

- Vidya Sagar
> 

