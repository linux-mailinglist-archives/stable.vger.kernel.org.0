Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B11FE4567AE
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 02:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234011AbhKSB6S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 20:58:18 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:21683 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234009AbhKSB6Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 20:58:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637286916; x=1668822916;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=aG5LqWTsRucrm11BXz0YXxnhDV4aHDGwps3zTPHMqJE=;
  b=jsv+Zr4t1WMqTvP1jFLhEnstXqikNMqoDz4rbjyuvsh9Q2eZZQGNNtN/
   6LvuCu25O1dWgOwKs2oeDlvX3NuibiZbtRjnRc6KSBhL8nPa4Z/L45/AV
   O2ncJ5VCKGFko6CWbkuNoD++re9LkkU/OAtMjbzwemHAO/N2jG638Fgz8
   eGTM99f+jbaIbZm2znvAS3fSCKoCJA9AKbqH1Rpc3kgTEjctw4m2CcLiY
   wf6ML85oKk2ZwroaZ22WvcosG/dqTbxj6WRT7pyEFu7NwYoifc+9o4spq
   lUb3s+eYesniZgAbPKqvY8yIk09D4qLhTD0BvOLdvVpaSesjvJZhLG22A
   g==;
X-IronPort-AV: E=Sophos;i="5.87,246,1631548800"; 
   d="scan'208";a="185023355"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 19 Nov 2021 09:55:13 +0800
IronPort-SDR: G3Z4Sn36FHmhB9T5WPOk9R3tHyfXWJJDgmrEDKZIppXh3I/ZIJoo1qloICTDTeQgzn2FGxYQuW
 7ID+3IXOtb7x6nyCuEmS1l5JC0rvaSAA9Xj2mQLqnqPPG1pvNgPqu1E2uxuaH13Tql0i4Ggsc/
 q6GxCsx8B5uwLoHwqRZX9JcbCXupIcpaTtIzbKY0ouTn+eS5YeV8MWzwuLMv0BqO7MMjg6erCs
 uS/OeusRXg+inqcP3nheDMSXKKNOI3ZMmBSuFkBOitj40ggxtHaGUYJ3SjJtzZUNtR/PZTT7Hx
 D+Zk+PriMP6rGIOJBFleAO6P
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2021 17:30:13 -0800
IronPort-SDR: IA5Qt6KNJOzzs1ihFeWuLGfVaO2SSykYCfum2K+44y5Xr3ylKR6WUPeOPsxf6RBrcMW4NxgKj1
 enRuL6ud9L4QjatXtltgI9X+HbY4ykMpsoRjTiRMhB2ky39Ih+t9bQa6N9UbVAEHY90TOVndjC
 c4L+hFK0RxI8LxDJQn70URtCKWD0Svkor+vpkCTTJnNijECGAH4QciQ941RiinAdN95Oy3+Lmz
 ISf7/RTEzb72LfPhItJ2btMHIeO+wJKf2OEO/pcOcTNaOPUXReZVPAGEVnqLkx/wpjK5+pWJf/
 U5w=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2021 17:55:13 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4HwKVn172Hz1RtVn
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 17:55:13 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1637286911; x=1639878912; bh=aG5LqWTsRucrm11BXz0YXxnhDV4aHDGwps3
        zTPHMqJE=; b=VpQNF3zKxOX2dSZG2/BE4JWXNTW1W8qVMBK7MSAE3T8EE0w2411
        4y+8PyG8xkTPPzwX47/PIwGnteq5/IAsGQGjFrlJ1RICr1JMaw0gRAAmi9anFVqN
        5fcD1EozGlszJ9b0xp5i4SHEk8jkRG5Lzq77b6FnKvmsn/bqBlMcSzVVWiDOsitN
        gwv+BmTpUwAbC6Mnom3v6VQrenA1Z7yi/qOzTeatMgmEfGxVBFKcwSmRlOH37msm
        naV775kTDj4nySbJ3K0R8sZ5zAMiMgDJO1EDYCMJ+123gSDAjKiGu+h2eCneVzw+
        dGgCQv3Ox6d3FoHjOefDxyOdMcwQzBUuJIQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 1oHQHghmnkgW for <stable@vger.kernel.org>;
        Thu, 18 Nov 2021 17:55:11 -0800 (PST)
Received: from [10.225.54.48] (unknown [10.225.54.48])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4HwKVk4Pkyz1RtVl;
        Thu, 18 Nov 2021 17:55:10 -0800 (PST)
Message-ID: <df37d57e-86e1-56dd-54b7-f3d7b96ffd56@opensource.wdc.com>
Date:   Fri, 19 Nov 2021 10:55:08 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [PATCH 5.15] block: Add a helper to validate the block size
Content-Language: en-US
To:     Tadeusz Struk <tadeusz.struk@linaro.org>, stable@vger.kernel.org
Cc:     axboe@kernel.dk, hch@lst.de, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+662448179365dddc1880@syzkaller.appspotmail.com,
        xieyongji@bytedance.com
References: <7e6c4c23-f071-f33b-7bd4-da11980d34c6@linaro.org>
 <20211118235738.1128085-1-tadeusz.struk@linaro.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital
In-Reply-To: <20211118235738.1128085-1-tadeusz.struk@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021/11/19 8:57, Tadeusz Struk wrote:
> From: Xie Yongji <xieyongji@bytedance.com>
> 
> From: Xie Yongji <xieyongji@bytedance.com>
> 
> There are some duplicated codes to validate the block
> size in block drivers. This limitation actually comes
> from block layer, so this patch tries to add a new block
> layer helper for that.
> 
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> Link: https://lore.kernel.org/r/20211026144015.188-2-xieyongji@bytedance.com
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
> ---
>  include/linux/blkdev.h | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 683aee365420..5b03795ae33b 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -54,6 +54,14 @@ struct blk_keyslot_manager;
>   */
>  #define BLKCG_MAX_POLS		6
>  
> +static inline int blk_validate_block_size(unsigned int bsize)
> +{
> +	if (bsize < 512 || bsize > PAGE_SIZE || !is_power_of_2(bsize))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
>  typedef void (rq_end_io_fn)(struct request *, blk_status_t);
>  
>  /*
> 

But where is this used in 5.15 ? I do not see any callers for this.
So why backport it ?

-- 
Damien Le Moal
Western Digital Research
