Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B75B9538A11
	for <lists+stable@lfdr.de>; Tue, 31 May 2022 05:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232746AbiEaDAy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 23:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243683AbiEaDAt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 23:00:49 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9303B8D6B6;
        Mon, 30 May 2022 20:00:48 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id l84so15971105oif.10;
        Mon, 30 May 2022 20:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:content-language:to
         :cc:references:from:subject:in-reply-to:content-transfer-encoding;
        bh=8BIreXk3wL1LJw946Ou89DmLJVLJs/jGntsglTvUFQg=;
        b=lkbD9Dadr9MY5HqqYtdh1FcLBc2tH21uRMxhC5aQ7D1+mWohFQVcBKPBu9ixwh4xWs
         RvXuaLexiRZ98t6R7rHlHhW3RIZ4m6MzBosTaEWqi9W3gpeq0Mf6l3G6aqPS+V5rTC6U
         JBcq/kAjhTf6err2hL0SPJWw+H87WOPF5W2HURL73c1346xgAQsnRuEXzaBaHwLxu9/T
         PBM/FPOW4Tunwn33ASZFBHMecJd0XI8XLQ/II+MNtgH7e6L9u1QDxRdu3dQMuhzLvyGb
         HdL9Vm78fKADWkCxuwNOg18fxxD3km3mqntO1pcrTx9cK2+GDVuNy+dihcmTwEe5RvFA
         +6fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=8BIreXk3wL1LJw946Ou89DmLJVLJs/jGntsglTvUFQg=;
        b=cWrSXp27kk+mRgQY9ncvU9FPsAnUP569XUwy7XErbnIUQu68nvs2uOfA5B+aCbmXLx
         aAKbX8rb7SEDuuUcfRoXUEH7BjLqfDz7H4Zwzhl34cLgSIddRO6GOOUSMQpNDEEfuJuF
         LVgVXmNVkao8Z5Hm2ebZH8q4qWK0SLqANMcNbkKW7ZTy6D9JhOl9kRTeWvJVYGql7SZn
         VofQVnG0KtHu+XpB7/P/F4oavS8PmaeLHYcqb4lP7wITnbaAuS5AH9f1nCPEf0fRxkjD
         g4UpKB/A6fhtcggwfL9oZem3siUu/CIjbl83X7QW1NaEX6MAgcR0Y040CxX3u7xnTjsM
         Ilmw==
X-Gm-Message-State: AOAM532aegsqi0iTiF7rctdbst7mvOZfuRc6MK9WCRimX9X+Qc1XmrAg
        kHG+4LkaMfxGyljgZpR04io=
X-Google-Smtp-Source: ABdhPJze+8ikEd4rEh5cdrC7HE9r0/4shG98AJcym/MoFLEV4A6NrrLYdiVFJgOT5x2K3PcTX0FuGA==
X-Received: by 2002:a05:6808:2394:b0:326:d5d6:a4ba with SMTP id bp20-20020a056808239400b00326d5d6a4bamr11184575oib.67.1653966047822;
        Mon, 30 May 2022 20:00:47 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id gc4-20020a056870678400b000f325409614sm2823192oab.13.2022.05.30.20.00.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 May 2022 20:00:46 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <927a9461-0488-7bf7-3c9f-c5cd3629f05d@roeck-us.net>
Date:   Mon, 30 May 2022 20:00:44 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Content-Language: en-US
To:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     jdelvare@suse.com, corbet@lwn.net, linux-hwmon@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20220530133133.1931716-1-sashal@kernel.org>
 <20220530133133.1931716-128-sashal@kernel.org>
 <dddc2b53-62eb-fda7-4425-afdd179a7037@roeck-us.net>
 <1344ac58-f019-03ef-fab8-6e1d910514e2@gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH AUTOSEL 5.17 128/135] hwmon: Make chip parameter for
 with_info API mandatory
In-Reply-To: <1344ac58-f019-03ef-fab8-6e1d910514e2@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/30/22 19:38, Bagas Sanjaya wrote:
> On 5/30/22 21:27, Guenter Roeck wrote:
>> On 5/30/22 06:31, Sasha Levin wrote:
>>> From: Guenter Roeck <linux@roeck-us.net>
>>>
>>> [ Upstream commit ddaefa209c4ac791c1262e97c9b2d0440c8ef1d5 ]
>>>
>>> Various attempts were made recently to "convert" the old
>>> hwmon_device_register() API to devm_hwmon_device_register_with_info()
>>> by just changing the function name without actually converting the
>>> driver. Prevent this from happening by making the 'chip' parameter of
>>> devm_hwmon_device_register_with_info() mandatory.
>>>
>>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>
>> This patch should not be backported. It is only relevant for new
>> kernel releases, and may have adverse affect if applied to older
>> kernels.
> 
> So this patch is meant to be backported to 5.18 only, right?
> 

I said "do not backport". I specifically asked not to backport
this patch. It does not include Cc: stable, and it does not
include a Fixes: tag. I even said "... may have adverse affect
if applied to older kernels".

I have no idea how that can be interpreted as "backport to 5.18".
Did I miss the explicit "do not backport to 5.18 ?" If so, my bad.

Ok, here it is a more explicit request:

Do not backport this patch to 5.18.y, 5.17.y, 5.15.y, 5.10.y, 5.4.y,
4.19.y, 4.14.y, 4.9.y, or any other stable release.

Guenter
