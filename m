Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 382FA47A046
	for <lists+stable@lfdr.de>; Sun, 19 Dec 2021 12:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233179AbhLSLAR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Dec 2021 06:00:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbhLSLAR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Dec 2021 06:00:17 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C543C061574;
        Sun, 19 Dec 2021 03:00:16 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id v15so11140708ljc.0;
        Sun, 19 Dec 2021 03:00:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=28WUq9Jt90oxX2or2ReiiYs2kHyyTZ89Ut+mmcfXAPQ=;
        b=MvA2FRT3P60D5yjezwKIFYMSfSHRZp5IRVxMk0BdJWl2zzxHNVkQuwPx184OZ/VIL4
         inJUvjLQNSa9mu40ePpg2Af/dAMNsQ2LYQ5kgf036j3CgQw65Bd3hBhudnTrSx/xr1AX
         7heIbvMCVnuesRNta2lfAUhZP80ZRAcoH7wvnixxNPaOOE47xOw5d0pYM3K8RKb5hHJW
         Q6JdH2vvV6T4bHIJQiGlGqlukSiOlhjDwiLY6TS0SxgIBoE6gIjsB9LMrTerZ0c6yjIG
         5IWDPvcwnqizBNACYxB67R81bv+3MusJOwhmbciukFs/ZqAwpA3Vo2TibijgUG1fKfgK
         oj2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=28WUq9Jt90oxX2or2ReiiYs2kHyyTZ89Ut+mmcfXAPQ=;
        b=si8MFF8rYo9RdD97yi/a9wSAJ+a9xwLGp25WQqUTxe4lmcWdodhrIExEjnfWlSnjP6
         axHTvGgtuuZfYQJlR77Y2t40jYJpcuEU6EPRpooUH7KKL6+ABV12FlDNtWO2JIpf1JI0
         fYzRwZ5zRKAdsDizJDA8JzGQuzP9yExxN+JWSkrHyxHp4YOnuDI4fZZ5OnMDo8XcLESc
         kE/GaeVKAc+Ixnn97wCAPE5bTsgx8U0hm2jYEHJU3if/hoyoxBiM4remcAemPKW2mXvM
         zUXIzEpE/yPcdorvtDPUFs23v6TCcvoDJnAFr+v/SOPLdH+Q8FvZO0MsAZhymsTbqJ+f
         4SEQ==
X-Gm-Message-State: AOAM532R64gKIrIM+Csr0HcQFWxi7g3JC1PbtTgwySpcYA27HSurKIhw
        WXRDhUj0EWQjwmInROUM7e82Uj7mNd4=
X-Google-Smtp-Source: ABdhPJy4q1W3IfUk3iv7+OV74YqxVPB6VWyBubwKM1rhmCigLlyhq+AHZfeU8BKn2WNBeKFGCEbnBw==
X-Received: by 2002:a2e:5c86:: with SMTP id q128mr9866205ljb.245.1639911613992;
        Sun, 19 Dec 2021 03:00:13 -0800 (PST)
Received: from [192.168.1.100] ([31.173.85.16])
        by smtp.gmail.com with ESMTPSA id z28sm2223309ljn.77.2021.12.19.03.00.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Dec 2021 03:00:13 -0800 (PST)
Message-ID: <9c5417f7-3cd9-472d-5b04-f831135ffd78@gmail.com>
Date:   Sun, 19 Dec 2021 14:00:09 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 3/4] usb: mtu3: fix list_head check warning
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eddie Hung <eddie.hung@mediatek.com>, stable@vger.kernel.org,
        Yuwen Ng <yuwen.ng@mediatek.com>
References: <20211218095749.6250-1-chunfeng.yun@mediatek.com>
 <20211218095749.6250-3-chunfeng.yun@mediatek.com>
 <64b9453a-84c5-8d41-26d5-698d1ae9d473@gmail.com> <Yb8MM2zL2Ecfzv1/@kroah.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Organization: Brain-dead Software
In-Reply-To: <Yb8MM2zL2Ecfzv1/@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 19.12.2021 13:40, Greg Kroah-Hartman wrote:
[...]

>>> This is caused by uninitialization of list_head.
>>
>>     Again, there's no such word as "uninitialization" (even if it existed, it
>> wouldn't mean what you wanted to say); please replace by "not initializing".
> 
> We are not English language scholars, most of us do not have English as
> their native language.  We all can understand what is being said here,
> there's no need for any change, please do not be so critical.

    OK, noted...
    I was just somewhat upset that my 1st comment was ignored. :-/

> thanks,
> 
> greg k-h

MBR, Sergey
