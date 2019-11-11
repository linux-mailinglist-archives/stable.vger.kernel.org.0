Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0544BF7791
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 16:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbfKKPW6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 10:22:58 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:6056 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726811AbfKKPW6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 10:22:58 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dc97c990001>; Mon, 11 Nov 2019 07:22:01 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Mon, 11 Nov 2019 07:22:57 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Mon, 11 Nov 2019 07:22:57 -0800
Received: from [10.25.73.138] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 11 Nov
 2019 15:22:54 +0000
Subject: Re: stable request: PCI: tegra: Enable Relaxed Ordering only for
 Tegra20 & Tegra30
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, Jon Hunter <jonathanh@nvidia.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "Manikanta Maddireddy" <mmaddireddy@nvidia.com>,
        Krishna Thota <kthota@nvidia.com>
References: <11251eb0-5675-9d3d-d15f-c346781e2bff@nvidia.com>
 <20191111130908.GA448544@kroah.com>
X-Nvconfidentiality: public
From:   Vidya Sagar <vidyas@nvidia.com>
Message-ID: <9d7871e7-f8aa-1ed5-dc2e-37ba6f218a2f@nvidia.com>
Date:   Mon, 11 Nov 2019 20:52:52 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191111130908.GA448544@kroah.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1573485721; bh=Q0hJxpT8ME+2ChVEvdoL+0cMYVU3SOtTXqeea8xAa/c=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=nKAMj4XIv9Ta6fIncEUC9THgFumb/LEtxhKiwfO2+mOxMos49B83Hcwf/ZXVAygkD
         wU+9RVBkZXqnWVZ11KIGtqM+ChN5DDo8TxJsjILOt5tbCwJc+G4rztFAVhHtDIhmj/
         LC9Fw7Gp5CNDA9X5fAiRtozBW1KDs5J1PtQhhR00Y/EhLmc5FwgaDSyAjnWlhzIXGp
         AOkCEmsyqryH29MJj135km2ELsxeedRaL2Q1bL2W/DpY+HZvX+W9nC1mwk+tfNNeTk
         Ob360vIFbcQdX8vKE0HBerh+UY2cEGGmPn71LisjK5gGrlEtc4EUouqYNvM286hKmb
         ohej/WDo+se+w==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/11/2019 6:39 PM, Greg Kroah-Hartman wrote:
> On Mon, Nov 11, 2019 at 06:24:53PM +0530, Vidya Sagar wrote:
>> Hi Greg,
>> We noticed that the Tegra PCIe host controller driver enabled
>> "Relaxed Ordering" bit in the PCIe configuration space for "all"
>> devices erroneously. We pushed a fix for this through the
>> commit: 7be142caabc4780b13a522c485abc806de5c4114 and it has been
>> soaking in main line for the last four months.
>> Based on the discussion we had @ http://patchwork.ozlabs.org/patch/1127604/
>> we would now like to push it to the following stable kernels
>> 4.19                  : Applies cleanly
>> 3.16, 4.4, 4.9 & 4.14 : Following equivalent patch needs to be used as the
>>                          file was at drivers/pci/host/pci-tegra.c earlier
>>                          (and moved to drivers/pci/controller/pci-tegra.c starting 4.19)
> 
> All now queued up (except for 3.16, that's Ben's tree, he will get to it
> soon.)
> 
> thanks,
> 
> greg k-h
> 

Thanks a lot Greg.

- Vidya Sagar
