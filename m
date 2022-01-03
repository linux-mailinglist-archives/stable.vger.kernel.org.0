Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 546F2483752
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 20:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235955AbiACTCp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 14:02:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235930AbiACTCp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 14:02:45 -0500
Received: from mail-ua1-x92b.google.com (mail-ua1-x92b.google.com [IPv6:2607:f8b0:4864:20::92b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ED3DC061761;
        Mon,  3 Jan 2022 11:02:45 -0800 (PST)
Received: by mail-ua1-x92b.google.com with SMTP id v14so41659233uau.2;
        Mon, 03 Jan 2022 11:02:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=RbNZlzrnhKqHYr5Mt3qlqSHzuKKh6/EtvdirpgsoZCM=;
        b=i3iw5jfqVnyB3VpNSNpYujQnac6UP5PodhzkCt97Pg1JMOzSDe6OOSwkvg5/Mv7+w9
         BiVTCTq7Ld+0BULFlLGz0/14jBQJWhIxMJycJ3KmjVpol/UUYNGl+tDWiBKuaD9x9DRi
         mpHlpet8Qy3hnRXoN261LZqK+nU/27CPTXqmj3HK8ZdOxdqMQe9revLee8qFFUIZHeaK
         TwsJT0eXr++34OcdCLabCkyaCPPnMU/QZ13DKelTR/fLE992ukqSPEADRpVhP/+416Vy
         DctpryccIGjPgPBi2ZrLWGve5IGEEhqXC6P+sudaSRlejTipHbpycHXLgpJZMEiJShcf
         RmEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RbNZlzrnhKqHYr5Mt3qlqSHzuKKh6/EtvdirpgsoZCM=;
        b=g684Ep5M2ZwdKBfSytzN6/o4CtjBsLs6RaZrkkOrkjBF72WUlZoLS9U29hT27yWYu5
         WquXSL7zVIISb1HLEs0tjYuqsJU8u6gbBKpAY2PdAujOtrj2GUFRdTjDeDPsyQGPaQXI
         NlNZUpIEkorT5PmP6yfwn8u9BvQsfLD3rOnimd6yeehKcJ/AX7ligjO3TX7tYp5vvtN2
         6K4epP11F+T55yw23OcdgEcTK64I6uC1cRJH6aj8ufRX2fL4DnxcxA0bIIrqXSrY2X6F
         +XvrSI7A76J8MvMo69dm4kiHII+sk8UE7HBXh1xppNlvAGVEkGOZ9vQx8kkSsFMDT+rr
         rp2w==
X-Gm-Message-State: AOAM531H23Sx1PQN38d5NCnOxpuIS6N4KB8G0tqaCm3Nyhk4KwZeNa9W
        gMhZj4A3P7HvYVNX2XXBYQg=
X-Google-Smtp-Source: ABdhPJwfKVuw5pSdIIGJ6zEcMaVOi4GLeeFUvfEyiFwDWYLuRqacBGQX1Kgof+Ee8H9DkrFG+ToHbw==
X-Received: by 2002:a9f:3649:: with SMTP id s9mr14326037uad.123.1641236564270;
        Mon, 03 Jan 2022 11:02:44 -0800 (PST)
Received: from [10.230.2.158] ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id f1sm4169877uae.5.2022.01.03.11.02.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jan 2022 11:02:43 -0800 (PST)
Message-ID: <f1795d01-6289-7c99-ac7e-3a2a987a99eb@gmail.com>
Date:   Mon, 3 Jan 2022 11:02:41 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH 5.10 16/48] net: phy: fixed_phy: Fix NULL vs IS_ERR()
 checking in __fixed_phy_register
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
References: <20220103142053.466768714@linuxfoundation.org>
 <20220103142054.022601930@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220103142054.022601930@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/3/2022 6:23 AM, Greg Kroah-Hartman wrote:
> From: Miaoqian Lin <linmq006@gmail.com>
> 
> [ Upstream commit b45396afa4177f2b1ddfeff7185da733fade1dc3 ]
> 
> The fixed_phy_get_gpiod function() returns NULL, it doesn't return error
> pointers, using NULL checking to fix this.i
> 
> Fixes: 5468e82f7034 ("net: phy: fixed-phy: Drop GPIO from fixed_phy_add()")
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
> Link: https://lore.kernel.org/r/20211224021500.10362-1-linmq006@gmail.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Same regression as with 5.4, this breaks any platform using fixed PHYs 
without a GPIO, which is the vast majority of them.
-- 
Florian
