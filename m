Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC4D542909
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 10:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiFHIOR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 04:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231584AbiFHIMT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 04:12:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 900672D899A
        for <stable@vger.kernel.org>; Wed,  8 Jun 2022 00:41:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654674081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oSiZVSBm4/8vPhhFbWQ531zs5GylzxQlmBrVz2YPF7Y=;
        b=GDmk9DmlDLVNbMOmxuqiemFwc667Oj45Ht/9mjsA4bMYSmTzmO9Chc5omdjT0u2n/FkmK4
        NiSdlx6YwCruhsC2W8IcLp9zDOAi9U5cy6E7ehZvqVUaqZ6eOAzePmqNvuJZmofy2joPlC
        Vz3N33xdmIZZx1/1ACmJDtLsnihzqGQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-110-Azh2VKvvNXOuwx-mdKvhlg-1; Wed, 08 Jun 2022 03:41:20 -0400
X-MC-Unique: Azh2VKvvNXOuwx-mdKvhlg-1
Received: by mail-wr1-f70.google.com with SMTP id bv8-20020a0560001f0800b002183c5d5c26so2364180wrb.20
        for <stable@vger.kernel.org>; Wed, 08 Jun 2022 00:41:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=oSiZVSBm4/8vPhhFbWQ531zs5GylzxQlmBrVz2YPF7Y=;
        b=S88W2VQcxiL7PP6fv+Zya8UorRHo+BhFikpmMJCOqzZylQt/g8M1kmZcc3XdzyQ7az
         0nzKnXDztw122Y7CYnoYP1kBL5Zg9+BqpQRGfnJipLTEQP8/GHmb+G76SKlrN7XLnhJC
         NXaHf+KrFkRACZbffuFZVlN5CCYKWWmkk52T/i8+OVWbhu0ns2sNiSDm2SzdksesVmUF
         OLLYVdOTPOFBILT6cqyDZqE2u2Rk6rA86cyPqIugkgnB3SDGffJdZJvrpMD+BNTfau26
         rlFWL3WFMlANVowT27GmN0nxAnr13VEWpi/K5HEdcWjWLARYDKXKPPeUu59soFcTVCeg
         xY4A==
X-Gm-Message-State: AOAM530XnKv49l4P6/8QBJUbwjywindjDG0QoH+PGaX/pCG5yuxMNJfz
        alh5OqkE4Rnw/VW5OuFvHDjvFkiRmN0djQWhz2tsobLcR/TUKNlvsqcViErJeRe2hm/A4rJbQ0e
        d8TDK6ozy41TDL3gE
X-Received: by 2002:a5d:4811:0:b0:213:bab0:64f3 with SMTP id l17-20020a5d4811000000b00213bab064f3mr28052424wrq.499.1654674078439;
        Wed, 08 Jun 2022 00:41:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx832q/pWOjPR0IlTzGmSuu3ZA2zubgpH7Hx1usrp95CyJYmlqsOXJ0aoiWY5plqj0LXKYqWA==
X-Received: by 2002:a5d:4811:0:b0:213:bab0:64f3 with SMTP id l17-20020a5d4811000000b00213bab064f3mr28052402wrq.499.1654674078244;
        Wed, 08 Jun 2022 00:41:18 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:c:37e0:f4b2:2105:b039:7367? ([2a01:e0a:c:37e0:f4b2:2105:b039:7367])
        by smtp.gmail.com with ESMTPSA id h13-20020a05600c2cad00b00397623ff335sm25134006wmc.10.2022.06.08.00.41.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jun 2022 00:41:17 -0700 (PDT)
Message-ID: <2c26c0c9-7a5e-4ffa-95cf-42c6bc6ae88d@redhat.com>
Date:   Wed, 8 Jun 2022 09:41:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] drm/ast: Treat AST2600 like AST2500 in most places
Content-Language: en-US
To:     Thomas Zimmermann <tzimmermann@suse.de>, airlied@redhat.com,
        airlied@linux.ie, daniel@ffwll.ch, regressions@leemhuis.info,
        kuohsiang_chou@aspeedtech.com
Cc:     dri-devel@lists.freedesktop.org, stable@vger.kernel.org
References: <20220607120248.31716-1-tzimmermann@suse.de>
 <3528fa40-987f-2467-35a5-93397d968ee8@suse.de>
From:   Jocelyn Falempe <jfalempe@redhat.com>
In-Reply-To: <3528fa40-987f-2467-35a5-93397d968ee8@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 07/06/2022 14:07, Thomas Zimmermann wrote:
> Jocelyn, do you have a way of getting this patch tested?

Thanks for sending this patch.
I'm sorry I'm not able to test it directly.
It's a bit complex to try an upstream kernel on the machine we found the 
regression, I will do my best to get it tested, but no promise.

Also be careful when backporting to stable kernel, as the patch may 
apply, but some other "if (AST2500)" logic might be missing the AST2600 
check.

> 
> Am 07.06.22 um 14:02 schrieb Thomas Zimmermann:
>> Include AST2600 in most of the branches for AST2500. Thereby revert
>> most effects of commit f9bd00e0ea9d ("drm/ast: Create chip AST2600").
>>
>> The AST2600 used to be treated like an AST2500, which at least gave
>> usable display output. After introducing AST2600 in the driver without
>> further updates, lots of functions take the wrong branches.
>>
>> Handling AST2600 in the AST2500 branches reverts back to the original
>> settings. The exception are cases where AST2600 meanwhile got its own
>> branch.
>>
>> Reported-by: Jocelyn Falempe <jfalempe@redhat.com>
>> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
>> Suggested-by: Jocelyn Falempe <jfalempe@redhat.com>
>> Fixes: f9bd00e0ea9d ("drm/ast: Create chip AST2600")
>> Cc: KuoHsiang Chou <kuohsiang_chou@aspeedtech.com>
>> Cc: Dave Airlie <airlied@redhat.com>
>> Cc: dri-devel@lists.freedesktop.org
>> Cc: <stable@vger.kernel.org> # v5.11+
>> ---
>>   drivers/gpu/drm/ast/ast_main.c | 4 ++--
>>   drivers/gpu/drm/ast/ast_mode.c | 6 +++---
>>   drivers/gpu/drm/ast/ast_post.c | 6 +++---
>>   3 files changed, 8 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/ast/ast_main.c 
>> b/drivers/gpu/drm/ast/ast_main.c
>> index d770d5a23c1a..56b2ac138375 100644
>> --- a/drivers/gpu/drm/ast/ast_main.c
>> +++ b/drivers/gpu/drm/ast/ast_main.c
>> @@ -307,7 +307,7 @@ static int ast_get_dram_info(struct drm_device *dev)
>>       default:
>>           ast->dram_bus_width = 16;
>>           ast->dram_type = AST_DRAM_1Gx16;
>> -        if (ast->chip == AST2500)
>> +        if ((ast->chip == AST2500) || (ast->chip == AST2600))
>>               ast->mclk = 800;
>>           else
>>               ast->mclk = 396;
>> @@ -319,7 +319,7 @@ static int ast_get_dram_info(struct drm_device *dev)
>>       else
>>           ast->dram_bus_width = 32;
>> -    if (ast->chip == AST2500) {
>> +    if ((ast->chip == AST2600) || (ast->chip == AST2500)) {
>>           switch (mcr_cfg & 0x03) {
>>           case 0:
>>               ast->dram_type = AST_DRAM_1Gx16;
>> diff --git a/drivers/gpu/drm/ast/ast_mode.c 
>> b/drivers/gpu/drm/ast/ast_mode.c
>> index 323af2746aa9..1dde30b98317 100644
>> --- a/drivers/gpu/drm/ast/ast_mode.c
>> +++ b/drivers/gpu/drm/ast/ast_mode.c
>> @@ -310,7 +310,7 @@ static void ast_set_crtc_reg(struct ast_private *ast,
>>       u8 jreg05 = 0, jreg07 = 0, jreg09 = 0, jregAC = 0, jregAD = 0, 
>> jregAE = 0;
>>       u16 temp, precache = 0;
>> -    if ((ast->chip == AST2500) &&
>> +    if (((ast->chip == AST2600) || (ast->chip == AST2500)) &&
>>           (vbios_mode->enh_table->flags & AST2500PreCatchCRT))
>>           precache = 40;
>> @@ -428,7 +428,7 @@ static void ast_set_dclk_reg(struct ast_private *ast,
>>   {
>>       const struct ast_vbios_dclk_info *clk_info;
>> -    if (ast->chip == AST2500)
>> +    if ((ast->chip == AST2600) || (ast->chip == AST2500))
>>           clk_info = 
>> &dclk_table_ast2500[vbios_mode->enh_table->dclk_index];
>>       else
>>           clk_info = &dclk_table[vbios_mode->enh_table->dclk_index];
>> @@ -476,7 +476,7 @@ static void ast_set_crtthd_reg(struct ast_private 
>> *ast)
>>           ast_set_index_reg(ast, AST_IO_CRTC_PORT, 0xa7, 0xe0);
>>           ast_set_index_reg(ast, AST_IO_CRTC_PORT, 0xa6, 0xa0);
>>       } else if (ast->chip == AST2300 || ast->chip == AST2400 ||
>> -        ast->chip == AST2500) {
>> +           ast->chip == AST2500 || ast->chip == AST2600) {
>>           ast_set_index_reg(ast, AST_IO_CRTC_PORT, 0xa7, 0x78);
>>           ast_set_index_reg(ast, AST_IO_CRTC_PORT, 0xa6, 0x60);
>>       } else if (ast->chip == AST2100 ||
>> diff --git a/drivers/gpu/drm/ast/ast_post.c 
>> b/drivers/gpu/drm/ast/ast_post.c
>> index 0aa9cf0fb5c3..eb1ff9084034 100644
>> --- a/drivers/gpu/drm/ast/ast_post.c
>> +++ b/drivers/gpu/drm/ast/ast_post.c
>> @@ -80,7 +80,7 @@ ast_set_def_ext_reg(struct drm_device *dev)
>>           ast_set_index_reg(ast, AST_IO_CRTC_PORT, i, 0x00);
>>       if (ast->chip == AST2300 || ast->chip == AST2400 ||
>> -        ast->chip == AST2500) {
>> +        ast->chip == AST2500 || ast->chip == AST2600) {
>>           if (pdev->revision >= 0x20)
>>               ext_reg_info = extreginfo_ast2300;
>>           else
>> @@ -105,7 +105,7 @@ ast_set_def_ext_reg(struct drm_device *dev)
>>       /* Enable RAMDAC for A1 */
>>       reg = 0x04;
>>       if (ast->chip == AST2300 || ast->chip == AST2400 ||
>> -        ast->chip == AST2500)
>> +        ast->chip == AST2500 || ast->chip == AST2600)
>>           reg |= 0x20;
>>       ast_set_index_reg_mask(ast, AST_IO_CRTC_PORT, 0xb6, 0xff, reg);
>>   }
>> @@ -382,7 +382,7 @@ void ast_post_gpu(struct drm_device *dev)
>>       if (ast->chip == AST2600) {
>>           ast_dp_launch(dev, 1);
>>       } else if (ast->config_mode == ast_use_p2a) {
>> -        if (ast->chip == AST2500)
>> +        if (ast->chip == AST2500 || ast->chip == AST2600)
>>               ast_post_chip_2500(dev);
>>           else if (ast->chip == AST2300 || ast->chip == AST2400)
>>               ast_post_chip_2300(dev);
> 

