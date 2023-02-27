Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA07B6A4720
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 17:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbjB0Qij (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 11:38:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjB0Qii (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 11:38:38 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D663D9EFB
        for <stable@vger.kernel.org>; Mon, 27 Feb 2023 08:38:36 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id l1so3839804wry.12
        for <stable@vger.kernel.org>; Mon, 27 Feb 2023 08:38:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UdlgcB/Y9MWIyQdrrEyftem3TGdOyYMADGKRIrz+XL4=;
        b=KhaR/5PFYBZ4e0/PRC2atbQksjLPyXgLZJVUNc/QdjF0faE1bUZtR3FTBZbZimbu4I
         0sv2dFi4dPI3UntSAqkpLk954/7hl7pigQbGVhwGvDnhXFWUVujxRBQ1ZojobtjUyAYC
         4dfLvyWXnNFKBC/W2ntFo+IiTI+8lIJB0hwG59RF1xx00Z+c1b85fWAXfh6BzR8OsPOA
         vuFuV77k2jO+uZQUecWr9IiNFbJekfOf0uYASJJVhMUQ0T4nQdNplY08nFqTEaKAYZtg
         lYlKplNS/6qzuFpkRKmYp3qJQyw/dzF9sH50E7T4yG5tD102EsCiRdfmngXOdKUZ2Al+
         Xy3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UdlgcB/Y9MWIyQdrrEyftem3TGdOyYMADGKRIrz+XL4=;
        b=6stuLVcx1KouHM1QrNMe6oYyoB5Z1CyDXbwkEeT5yBmQEY2bNLTxBG9joXRwFqiJsH
         VJwF+g0z56v5L/NbPBbhbxmkpXfvYd15qrDbRyANftVDg+UNv37cK8gt66/HGM/hX+M5
         V7UwM/CKXe48BmTdWp+MMMvCX4UR8VRivtrVCODkcIJ4Ls0RTbY/Er33A3Ll32WF606S
         NBt8x1lJltsQdR6marbqE7onUH0D3eEWu0WocGF7cPWsldTLJkzN42woVe5UyFig9VyJ
         SpUi3OhpPuOvm9/wMjLs2RDLZnmEfraEeuHQvwYC3N3tbEdAe/3ow7neEQnnhKk/34IB
         gPIA==
X-Gm-Message-State: AO0yUKXfGejjDdw/gx4qdgVeyjGRvmcAYqyqU/nhumqbCxHwPxssWa2J
        kWbW7vFsE/LsVTQlU+Hma1+ggA==
X-Google-Smtp-Source: AK7set83TuZ0j8uIK5yzlvtwSbF2UceAh+Q/YkwHcVaUWm3uThlwlmN/wPeuy1AW2ayn9bdQwarG7w==
X-Received: by 2002:adf:f0cd:0:b0:2c7:d75:373a with SMTP id x13-20020adff0cd000000b002c70d75373amr15215774wro.1.1677515915389;
        Mon, 27 Feb 2023 08:38:35 -0800 (PST)
Received: from [192.168.1.20] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id t3-20020a5d6903000000b002c56af32e8csm7691119wru.35.2023.02.27.08.38.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Feb 2023 08:38:35 -0800 (PST)
Message-ID: <7d52af12-0ff8-4bea-22da-596e5bac02e3@linaro.org>
Date:   Mon, 27 Feb 2023 17:38:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH AUTOSEL 4.19 2/3] ARM: dts: exynos: Use Exynos5420
 compatible for the MIPI video phy
Content-Language: en-US
To:     Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Markuss Broks <markuss.broks@gmail.com>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
References: <20230226034424.776084-1-sashal@kernel.org>
 <20230226034424.776084-2-sashal@kernel.org> <Y/zZ/UcWyT2EWAiL@duo.ucw.cz>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <Y/zZ/UcWyT2EWAiL@duo.ucw.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 27/02/2023 17:27, Pavel Machek wrote:
> Hi!
> 
>> From: Markuss Broks <markuss.broks@gmail.com>
>>
>> [ Upstream commit 5d5aa219a790d61cad2c38e1aa32058f16ad2f0b ]
>>
>> For some reason, the driver adding support for Exynos5420 MIPI phy
>> back in 2016 wasn't used on Exynos5420, which caused a kernel panic.
>> Add the proper compatible for it.
> 
> This is likely bad idea for 4.14, as that compatible is still in use:

I don't understand this. What does it mean? That compatible was used and
still is used somewhere... Just because incorrect compatible is used
somewhere is not really related whether it should be (or not) replaced
with correct compatible.

BTW you mentioned v4.14 but AUTOSEL is for v4.19.

> 
> drivers/phy/samsung/phy-exynos-mipi-video.c:		.compatible = "samsung,s5pv210-mipi-video-phy",
> arch/arm/boot/dts/exynos5420.dtsi:			compatible = "samsung,s5pv210-mipi-video-phy";
> arch/arm/boot/dts/exynos3250.dtsi:			compatible = "samsung,s5pv210-mipi-video-phy";
> arch/arm/boot/dts/exynos4.dtsi:		compatible = "samsung,s5pv210-mipi-video-phy";
> 
> phy-exynos-mipi-video.c lists other compatibles, too, but with
> different data.


Best regards,
Krzysztof

