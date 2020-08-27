Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 601982540B5
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 10:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727996AbgH0IXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Aug 2020 04:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727986AbgH0IXu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Aug 2020 04:23:50 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53F1CC061264;
        Thu, 27 Aug 2020 01:23:50 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id w13so4465591wrk.5;
        Thu, 27 Aug 2020 01:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=L4XCCnRN6fG15vCYo2bW4Pc6TLiOQjp7cLIshmu9c9U=;
        b=AFPvat03Xy0424JfFgdxZskpWCg155al8jI1hGe+5UheZKEzOKDhqy027O/CM1zTv+
         zfdalVG0lrpwTR+pRnvJLIcC/AUdTrNykqBBw3SDe2WpDGWeWaM6lx/nXNUYAjLF5tp8
         auYwaMB7NxJ0aV1Bc+4ClWDa7jm5uXtECHmCIGVTvNYVlLa10+Ulpq9Rfxvtn1ptpENV
         uLRmZZiivyg0c6afnm7TydjsXNzmqNaD74iChCObjyFkIdR4tMmrCwQyVfonXFXGIGsx
         LKeSMn0Kh2A0iu2YhCHvTGuoIZ2X1B2GHxR7RPouuBjA3HBkAKvfxxm4osLBBwmCREJG
         JlTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L4XCCnRN6fG15vCYo2bW4Pc6TLiOQjp7cLIshmu9c9U=;
        b=bt3qNqWXsbCnLlOGdK/vrrBqGZtosPT7z/swpL20NX3Fcjl00O/D6x3Ykkl/qp9XRD
         BwaLkyP7i13kdVwbSZ+XCCnHtPtK3hB2xenVFKPxYnMwwO1cuNJ8vqiAO4mKg0HSjvte
         6Icj7rfi8YyDpVDb/6OUaI9tWpLgd6pHApFQ0DnsgOMEsvS/38r5o4vahCUFYd27JsgQ
         jvK21YBvmWq0OEmPPOZZ8ggNwT1CDcT4lId5goJGwDHui3mTIx2u8dIONzlpRtNOlYqc
         L7uf3GhSvclkfQmWDElsz9Je82Na9U57UcKYzKboopPWWzzsd6Ig3pqYnYziymvPA0HI
         DE0Q==
X-Gm-Message-State: AOAM5306buJwIZ/CAGgFAqSr3rQxE5sIWUz8fBtU1lLDItjDu0oPE8Oi
        EZ2M+1UkavMzRtFmAIIt+j03taThWHC3MQ==
X-Google-Smtp-Source: ABdhPJwzK3eFiKm90v/V4n4a5o+w0AzbR7Sg2+CRdvmTmpqjt1qvB5e6vObKUp7mNhpPEzvUNfxKAQ==
X-Received: by 2002:a5d:5223:: with SMTP id i3mr16960587wra.58.1598516628776;
        Thu, 27 Aug 2020 01:23:48 -0700 (PDT)
Received: from ziggy.stardust ([213.195.119.187])
        by smtp.gmail.com with ESMTPSA id c10sm3843104wrn.24.2020.08.27.01.23.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Aug 2020 01:23:47 -0700 (PDT)
Subject: Re: [v5,2/3] arm64: dts: mt7622: add reset node for mmc device
To:     Ulf Hansson <ulf.hansson@linaro.org>,
        Wenbin Mei <wenbin.mei@mediatek.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Chaotian Jing <chaotian.jing@mediatek.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        DTML <devicetree@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        srv_heupstream <srv_heupstream@mediatek.com>,
        "# 4.0+" <stable@vger.kernel.org>
References: <20200814014346.6496-1-wenbin.mei@mediatek.com>
 <20200814014346.6496-3-wenbin.mei@mediatek.com>
 <CAPDyKFpt6-a+pkTXb2RZdx=yTONetugSCKbtSsRD2xQ3PRPhDQ@mail.gmail.com>
From:   Matthias Brugger <matthias.bgg@gmail.com>
Message-ID: <1dfc1938-f5e8-c4c8-57c7-d7b6c33dcb1d@gmail.com>
Date:   Thu, 27 Aug 2020 10:23:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CAPDyKFpt6-a+pkTXb2RZdx=yTONetugSCKbtSsRD2xQ3PRPhDQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 24/08/2020 11:50, Ulf Hansson wrote:
> On Fri, 14 Aug 2020 at 03:44, Wenbin Mei <wenbin.mei@mediatek.com> wrote:
>>
>> This commit adds reset node for mmc device.
>>
>> Cc: <stable@vger.kernel.org> # v5.4+
>> Fixes: 966580ad236e ("mmc: mediatek: add support for MT7622 SoC")
>> Signed-off-by: Wenbin Mei <wenbin.mei@mediatek.com>
>> Tested-by: Frank Wunderlich <frank-w@public-files.de>
> 
> I can pick this for my fixes branch, together with the other changes,
> however deferring that until Matthias acks it.

Acked-by: Matthias Brugger <matthias.bgg@gmail.com>

My understanding is, that this will land also in v5.9-rc[3,4], correct?

Regards,
Matthias

> 
> Kind regards
> Uffe
> 
> 
> 
>> ---
>>   arch/arm64/boot/dts/mediatek/mt7622.dtsi | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/arch/arm64/boot/dts/mediatek/mt7622.dtsi b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
>> index 1a39e0ef776b..5b9ec032ce8d 100644
>> --- a/arch/arm64/boot/dts/mediatek/mt7622.dtsi
>> +++ b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
>> @@ -686,6 +686,8 @@
>>                  clocks = <&pericfg CLK_PERI_MSDC30_0_PD>,
>>                           <&topckgen CLK_TOP_MSDC50_0_SEL>;
>>                  clock-names = "source", "hclk";
>> +               resets = <&pericfg MT7622_PERI_MSDC0_SW_RST>;
>> +               reset-names = "hrst";
>>                  status = "disabled";
>>          };
>>
>> --
>> 2.18.0
