Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7432EF0D
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732099AbfE3DwZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:52:25 -0400
Received: from forward104p.mail.yandex.net ([77.88.28.107]:51058 "EHLO
        forward104p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731592AbfE3DwZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 May 2019 23:52:25 -0400
X-Greylist: delayed 458 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 May 2019 23:52:23 EDT
Received: from mxback16o.mail.yandex.net (mxback16o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::67])
        by forward104p.mail.yandex.net (Yandex) with ESMTP id 7F8524B0084E;
        Thu, 30 May 2019 06:44:42 +0300 (MSK)
Received: from smtp1p.mail.yandex.net (smtp1p.mail.yandex.net [2a02:6b8:0:1472:2741:0:8b6:6])
        by mxback16o.mail.yandex.net (nwsmtp/Yandex) with ESMTP id afNZxUkwuj-ifV0M5IL;
        Thu, 30 May 2019 06:44:42 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; s=mail; t=1559187882;
        bh=uTiauWk+XYWE565kWUj5NC/rBBElfwZJFXgji7/aHWo=;
        h=In-Reply-To:From:To:Subject:Cc:Date:References:Message-ID;
        b=gv397FPYmnqiJCJJixLuSpaDgVu/v6K6UeZB78RK8Vwqg9Ms6AoSXnS6GmgPSRtse
         k86g8QoACUSiehTJDoAAOrZkAUo8OutZ824O5BtNz+xLqSMRCn2rINFZ2NlA83vS3W
         HGYY43NobaSwtYaahqFvPhQ55DkT47zRAz16P7W0=
Authentication-Results: mxback16o.mail.yandex.net; dkim=pass header.i=@flygoat.com
Received: by smtp1p.mail.yandex.net (nwsmtp/Yandex) with ESMTPSA id QghGvszqTS-ibxOwBIs;
        Thu, 30 May 2019 06:44:40 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: [PATCH v2] MIPS: Treat Loongson Extensions as ASEs
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        linux-mips@vger.kernel.org
Cc:     paul.burton@mips.com, Huacai Chen <chenhc@lemote.com>,
        Yunqiang Su <ysu@wavecomp.com>, stable@vger.kernel.org
References: <20190529084259.8511-1-jiaxun.yang@flygoat.com>
 <c247ff0a-45f6-4c1f-4aa8-38c7d9a0a78b@amsat.org>
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
Message-ID: <3b4b0bfc-f758-fdf8-e716-e32403735e88@flygoat.com>
Date:   Thu, 30 May 2019 11:44:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <c247ff0a-45f6-4c1f-4aa8-38c7d9a0a78b@amsat.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2019/5/29 下午10:27, Philippe Mathieu-Daudé wrote:
> Hi Jiaxun,
>
> On 5/29/19 10:42 AM, Jiaxun Yang wrote:
>>   
>> @@ -1950,6 +1954,8 @@ static inline void cpu_probe_loongson(struct cpuinfo_mips *c, unsigned int cpu)
>>   		decode_configs(c);
>>   		c->options |= MIPS_CPU_FTLB | MIPS_CPU_TLBINV | MIPS_CPU_LDPTE;
>>   		c->writecombine = _CACHE_UNCACHED_ACCELERATED;
>> +		c->ases |= (MIPS_ASE_LOONGSON_MMI | MIPS_ASE_LOONGSON_CAM |
>> +			MIPS_ASE_LOONGSON_EXT | MIPS_ASE_LOONGSON_EXT2);
> You announce the Loongson 2E/2F as supporting the EXTensions R2 ASE, are
> you sure this is correct?
Hi Phil

Only Loongson 3A R2/R3 support EXT2. In this case, cpu_probe_loongson() 
only set the cap for Loongson 3A R2/R3, since Loongson-2E/F have legacy 
format of PRID and it's handeld by cpu_probe_legacy().

Thanks.

---

Jiaxun Yang

