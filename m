Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEDA14836E4
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 19:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235695AbiACSe5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 13:34:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235681AbiACSez (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 13:34:55 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB33C061761;
        Mon,  3 Jan 2022 10:34:55 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id g2so30687072pgo.9;
        Mon, 03 Jan 2022 10:34:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=PdKT33UwUCzy7PrWIw5LDS/jLSQXJ7UbI+tPlHdEnTc=;
        b=qhwpIQNyNdOsaRnpwOuktBsG66Dpdus+uJ/91T1PyipaTJmlb4/TMdPdho8l/gb26Q
         D5cQiefvHHpwAU7tfB7j5rkLno3LODbuPcOqB79K0OscDR/dZS9EySj1PUK+hT8CtENt
         HkhwOvrdAC1qSSQo6TnHlaXOd67jEL5K+4xPgOPAYz6Q4+a49ny+5p6So93FSZ8c908x
         7nd5KTJ9MzHK6bhUpL1+5TTp9KuPqQfo1P9Xhup7Usiva6+qUc4q6hNEgbCM1/H7NJGu
         ylkaocax0S3RG2hl+jXlytU2uDteCHYwjeTcHhi5W4lG7mfJmT2eP9WYiFbX5XherMLX
         ZsMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PdKT33UwUCzy7PrWIw5LDS/jLSQXJ7UbI+tPlHdEnTc=;
        b=yrAqHeVz4g11DFr5mauTAChahFqicHwYw4s4+7dGbIibd9r9iCijb9kB4jx9+dSNut
         vyYj3ZcllPOhZE0fRsM69C+XIDv8obnvQ1D/FBPAQJI/MVAHUKhHIfIopWOpT+vfF7/J
         rHitlYzCMHmOETXfQUM5kC9o+t549G4/kd7XOXEmrqKrrOJSlN8t6O3O4CeF/W3ag260
         4FPq0BYbqWR0cnIhA21WEfd3BctEhF4pA1tmKF12JzHsiI1uj7oNCFjnGLeXfRYjEgfI
         CdGmijqJlMn3D9zCadjwb+HHLQyd8BAyAvFBfzNeoNUHNO9qhf2CDVxqzKtaJOV2u85+
         2wRg==
X-Gm-Message-State: AOAM532HdviEz12GA5s2M/ScCInvThqMI/psimjtthmcc3dhU1X+4I8v
        advdL4aH4GkBTrbjxgFwSDKB1HGd9/I=
X-Google-Smtp-Source: ABdhPJwQkP1F9g59ayqzl57SP8Q9M0rIRh5kGGL6GNi75Db+rqt0zHEmVKOrBxqVVop6v0brfS7e0A==
X-Received: by 2002:a62:1507:0:b0:4ba:7078:2477 with SMTP id 7-20020a621507000000b004ba70782477mr47431754pfv.56.1641234894731;
        Mon, 03 Jan 2022 10:34:54 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id g5sm41786465pfj.143.2022.01.03.10.34.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jan 2022 10:34:54 -0800 (PST)
Message-ID: <800ce698-c657-b512-33c3-722f6f22c49b@gmail.com>
Date:   Mon, 3 Jan 2022 10:34:53 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH 5.4 14/37] net: phy: fixed_phy: Fix NULL vs IS_ERR()
 checking in __fixed_phy_register
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
References: <20220103142051.883166998@linuxfoundation.org>
 <20220103142052.316070279@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220103142052.316070279@linuxfoundation.org>
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

This patch prevents systems using fixed PHY devices from successfully 
registering, especially when those systems have a fixed PHY that does 
not use a GPIO:

[    5.971952] brcm-systemport 9300000.ethernet: failed to register 
fixed PHY
[    5.978854] brcm-systemport: probe of 9300000.ethernet failed with 
error -22
[    5.986047] brcm-systemport 9400000.ethernet: failed to register 
fixed PHY
[    5.992947] brcm-systemport: probe of 9400000.ethernet failed with 
error -22

Please drop it for now until it can be investigated. Thanks!
-- 
Florian
