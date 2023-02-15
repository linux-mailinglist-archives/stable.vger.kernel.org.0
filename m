Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77F75697A8F
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 12:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232544AbjBOLUo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 06:20:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233136AbjBOLUh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 06:20:37 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C511A37F04
        for <stable@vger.kernel.org>; Wed, 15 Feb 2023 03:20:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1676460034; x=1707996034;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=uXynvbW2CVApjkzjxNlJI6Vd2Zh2nQdtz8jd3YUCg70=;
  b=Y16MUAmFO79I7PcABVs6vtKxcCKauucyvQxHl8R0THTnmtxdk361w0KF
   4tU+uzSY61+g+Q2nke5b9DLUvvLqve91ng5tmIy2v86VrPwchG/KjLwvf
   qwqfWi7Sw6D/LcypDPL2ZtDgLO6QuTguh6KYLy90T4DQtasB4E4lENuLm
   COpNNXUtaBoqdP5n4WbdYMnOz9ki8XgLmBQoGYUTO4hKxIL3MbZKoutxX
   WB30p9CvzKHumgmXolwgHrBQB/LdGMbGA5578gLQFhAOW3VpNAaoL29dd
   bJeNu0mjcZkdvQoMsu5UWeDIS003k0ZJ6M/Ni1ao2jkK77nfjEn6iQmIZ
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,299,1669046400"; 
   d="scan'208";a="327660721"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 15 Feb 2023 19:20:27 +0800
IronPort-SDR: aufk3usvpQWKTnUpFxj5YYbWM11+6EBSBnTWqhzYztW9XuJOKkWV+azkeSN3Owm7/JBfCFZm0D
 XindklUnmcguPtfcoRM+IB7NQt77B8sUqXJj5HcRBo466CUP24pkj433BJVynX7AyfNnqV67jU
 97vMPGWfisJuhtvAqIzGuaFWlPaHT1erE4j8e5+PPMGaev0NuEhivOo5uEemGGurRSCx+dSl9f
 YJZEXMeIYWnFGmujPXeof3HfORa6N5nFMRgnX3T+VxFLoH0qtSrqK83r3Fq/T563PXnz7OYCk5
 R4Y=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 15 Feb 2023 02:37:33 -0800
IronPort-SDR: zT1QucOk70KRYCpWRmmL2BXx63JzNoftaKuYdW/CAzKCLR2qC/jDz6xi7icUver7+45YXJWTps
 nYudzFBDbdXAHQMTmoh1AUAIC1YEHZ9hyHi39bREfTD00IqjK6HEJpgpJPUgJi+uxVfAoWre3C
 qXydR4Seed8UVazluq2GgVN9vn/O1l4REpGmJXPZ46dmgYFNG/duIFUMD9OtLP8psKaN6EnpI2
 D6zBlplQowpa0KRm/rBS9O+pjCVCd/4kBlo3zfFMpK4wrfWPVl+IqaqJiW3+T2VUPYr4j6naoh
 quI=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 15 Feb 2023 03:20:26 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4PGwbv16Lzz1RwtC
        for <stable@vger.kernel.org>; Wed, 15 Feb 2023 03:20:27 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1676460026; x=1679052027; bh=uXynvbW2CVApjkzjxNlJI6Vd2Zh2nQdtz8j
        d3YUCg70=; b=YsQJsFnRknhw1UjbgFmyevXoS1siroXsQ1HDEzL7PzZXvV42q4k
        q759vT5XecRlqWrP90Eum4ip585Eq3Sv0EqO/isEkSOPER53j2438XBHKb5cdjbO
        i54Gzu5adJeoWqKplpiqgFNNTAnT8FpDfwEWIarg3IGQUvzd/3S8fHfGLuGd7ihD
        RYRoZu/w2L4+Avs6g3wfQobq08rraPQogmtH9A4SrybgtkoFHM3pCsKIDiZ4Kt/9
        YFY300f54qovmUWpfXREDC9cx9/EgNadhAXD5tj7lnhVpa7h9JPghuRehxr5VYqa
        m7uIOAawXluTHnHhug5loNPdv7nLULBKLow==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 7xonO3l-OoWa for <stable@vger.kernel.org>;
        Wed, 15 Feb 2023 03:20:26 -0800 (PST)
Received: from [10.225.163.116] (unknown [10.225.163.116])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4PGwbn61f9z1RvLy;
        Wed, 15 Feb 2023 03:20:21 -0800 (PST)
Message-ID: <b9f9a3de-614e-3306-4ffb-e99f0dce86f4@opensource.wdc.com>
Date:   Wed, 15 Feb 2023 20:20:20 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2 8/9] PCI: rockchip: Use u32 variable to access 32-bit
 registers
Content-Language: en-US
To:     David Laight <David.Laight@ACULAB.COM>,
        Rick Wertenbroek <rick.wertenbroek@gmail.com>,
        "alberto.dassatti@heig-vd.ch" <alberto.dassatti@heig-vd.ch>
Cc:     "xxm@rock-chips.com" <xxm@rock-chips.com>,
        "rick.wertenbroek@heig-vd.ch" <rick.wertenbroek@heig-vd.ch>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        =?UTF-8?Q?Krzysztof_Wilczy=c5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Mikko Kovanen <mikko.kovanen@aavamobile.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-rockchip@lists.infradead.org" 
        <linux-rockchip@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
References: <20230214140858.1133292-1-rick.wertenbroek@gmail.com>
 <20230214140858.1133292-9-rick.wertenbroek@gmail.com>
 <0fa5cef4-7096-7f59-422a-98011d01437c@opensource.wdc.com>
 <2a80c4e1f1ad42c6849521d1e644b003@AcuMS.aculab.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <2a80c4e1f1ad42c6849521d1e644b003@AcuMS.aculab.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/15/23 19:46, David Laight wrote:
> From: Damien Le Moal
>> Sent: 15 February 2023 01:34
>>
>> On 2/14/23 23:08, Rick Wertenbroek wrote:
>>> Previously u16 variables were used to access 32-bit registers, this
>>> resulted in not all of the data being read from the registers. Also
>>> the left shift of more than 16-bits would result in moving data out
>>> of the variable. Use u32 variables to access 32-bit registers
>>>
>>> Fixes: cf590b078391 ("PCI: rockchip: Add EP driver for Rockchip PCIe controller")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Rick Wertenbroek <rick.wertenbroek@gmail.com>
>>> ---
>>>  drivers/pci/controller/pcie-rockchip-ep.c | 10 +++++-----
>>>  drivers/pci/controller/pcie-rockchip.h    |  1 +
>>>  2 files changed, 6 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/drivers/pci/controller/pcie-rockchip-ep.c b/drivers/pci/controller/pcie-rockchip-ep.c
>>> index ca5b363ba..b7865a94e 100644
>>> --- a/drivers/pci/controller/pcie-rockchip-ep.c
>>> +++ b/drivers/pci/controller/pcie-rockchip-ep.c
>>> @@ -292,15 +292,15 @@ static int rockchip_pcie_ep_set_msi(struct pci_epc *epc, u8 fn, u8 vfn,
>>>  {
>>>  	struct rockchip_pcie_ep *ep = epc_get_drvdata(epc);
>>>  	struct rockchip_pcie *rockchip = &ep->rockchip;
>>> -	u16 flags;
>>> +	u32 flags;
>>>
>>>  	flags = rockchip_pcie_read(rockchip,
>>>  				   ROCKCHIP_PCIE_EP_FUNC_BASE(fn) +
>>>  				   ROCKCHIP_PCIE_EP_MSI_CTRL_REG);
>>>  	flags &= ~ROCKCHIP_PCIE_EP_MSI_CTRL_MMC_MASK;
>>>  	flags |=
>>> -	   ((multi_msg_cap << 1) <<  ROCKCHIP_PCIE_EP_MSI_CTRL_MMC_OFFSET) |
>>> -	   PCI_MSI_FLAGS_64BIT;
>>> +	   (multi_msg_cap << ROCKCHIP_PCIE_EP_MSI_CTRL_MMC_OFFSET) |
>>
>> ROCKCHIP_PCIE_EP_MSI_CTRL_MMC_OFFSET is 17 and multi_msg_cap is a u8...
>> Not nice.
> 
> It really doesn't matter.
> As soon as you do any arithmetic char and short are promoted to int.

OK. Thanks.


-- 
Damien Le Moal
Western Digital Research

