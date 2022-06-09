Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26DDC54446F
	for <lists+stable@lfdr.de>; Thu,  9 Jun 2022 09:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232315AbiFIHGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jun 2022 03:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbiFIHGj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jun 2022 03:06:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2CF631CF167
        for <stable@vger.kernel.org>; Thu,  9 Jun 2022 00:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654758393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ejJ+Ng78DSXpeboh/1Se2ZSB8MGGkShzLxeIkWVzXd4=;
        b=DBr1cYDo+X7iK+G6FSLlGMjRB0VVJOWZRbYjvTqrbwxqn0jO0scN+T2C+N4QSfU9bQMB7O
        104/WF2pTRPN4bCfLK/pIfktvdrgHyWWdy1gnTiV/p3CjezFiywSw1Q0a/hSJdx3/T4Gkx
        LdCEwLn2JaXZnu/clELSaHzqNkOZ8uw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-284-HjnysvaPOHmSu19T4gD15Q-1; Thu, 09 Jun 2022 03:06:32 -0400
X-MC-Unique: HjnysvaPOHmSu19T4gD15Q-1
Received: by mail-wr1-f72.google.com with SMTP id d9-20020adfe849000000b00213375a746aso4737595wrn.18
        for <stable@vger.kernel.org>; Thu, 09 Jun 2022 00:06:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ejJ+Ng78DSXpeboh/1Se2ZSB8MGGkShzLxeIkWVzXd4=;
        b=S4JJ+tvYxkMmGLqoE+V2EHuRAIwwWAj5hAso4mx6lmebXOKpt9uJiC9Sqo9/FfuCcM
         nZs7oSsIS9TTohr+I5+BrMfNxsa8lln6swlNl77pF6iI4hNAUIKljk2SE1dlXhLHOouk
         Yxtprvqy8xpKA+gPlhLFKpX5y2+GHxsEmi9TpK7cnTjeimBxI9zXeRMTv9MqLUQtF56E
         dsmc0qaqGi71PVT4zWtL2CdTGHMGQ7QdQN497+EWi+vLcv8Dk9uEGXbmTqILRWdgKTP3
         Cw0ArYQgdTOzvdxZxCw8Jj3Q+FkB+pfsjAU/JmXmZj67KENBn8Z2aiFKBYYIHxXCKH0A
         KvOg==
X-Gm-Message-State: AOAM530eTUfJIyjt5YBsyxr1sNelPRt+A3Bbl5WtwQwpL3xm4GXOTiah
        gr9PodmEc0537AAbKqCuMo0R4EjmDTSzsewPth3us7VwDu1BqalEGIhOgtqmfZ+ZgR2AcFGoJmn
        fK/9yxX/X1d4anZ2r
X-Received: by 2002:a7b:cd83:0:b0:39c:46d2:6ebb with SMTP id y3-20020a7bcd83000000b0039c46d26ebbmr1796667wmj.187.1654758390071;
        Thu, 09 Jun 2022 00:06:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzURfxSxbfQDUMi5WFVw7d975uJim2i12ha4ko3FuWfeZb9SYb/AKLdPPfeU/USfSlh7RiJSQ==
X-Received: by 2002:a7b:cd83:0:b0:39c:46d2:6ebb with SMTP id y3-20020a7bcd83000000b0039c46d26ebbmr1796634wmj.187.1654758389800;
        Thu, 09 Jun 2022 00:06:29 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:c:37e0:f4b2:2105:b039:7367? ([2a01:e0a:c:37e0:f4b2:2105:b039:7367])
        by smtp.gmail.com with ESMTPSA id m8-20020a05600c4f4800b003942a244f51sm34189442wmq.42.2022.06.09.00.06.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jun 2022 00:06:29 -0700 (PDT)
Message-ID: <91519070-5c5b-1337-3dab-10decb1b258d@redhat.com>
Date:   Thu, 9 Jun 2022 09:06:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] drm/ast: Treat AST2600 like AST2500 in most places
Content-Language: en-US
To:     Kuo-Hsiang Chou <kuohsiang_chou@aspeedtech.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        "airlied@redhat.com" <airlied@redhat.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "daniel@ffwll.ch" <daniel@ffwll.ch>,
        "regressions@leemhuis.info" <regressions@leemhuis.info>
Cc:     "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Luke Chen <luke_chen@aspeedtech.com>,
        Hungju Huang <hungju_huang@aspeedtech.com>,
        Charles Kuan <charles_kuan@aspeedtech.com>
References: <20220607120248.31716-1-tzimmermann@suse.de>
 <PSAPR06MB4805B23B053F80C0F23A8C6C8CA49@PSAPR06MB4805.apcprd06.prod.outlook.com>
 <c99f305f-ac4d-628b-b092-920af767a2e4@redhat.com>
 <PSAPR06MB48051E6CA20163561BAD80298CA79@PSAPR06MB4805.apcprd06.prod.outlook.com>
From:   Jocelyn Falempe <jfalempe@redhat.com>
In-Reply-To: <PSAPR06MB48051E6CA20163561BAD80298CA79@PSAPR06MB4805.apcprd06.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 09/06/2022 04:32, Kuo-Hsiang Chou wrote:
> Hi Jocelyn Falempe,
> 
> -----Original Message-----
> From: Jocelyn Falempe [mailto:jfalempe@redhat.com]
> Sent: Wednesday, June 08, 2022 9:17 PM
> To: Kuo-Hsiang Chou <kuohsiang_chou@aspeedtech.com>; Thomas Zimmermann <tzimmermann@suse.de>; airlied@redhat.com; airlied@linux.ie; daniel@ffwll.ch; regressions@leemhuis.info
> Cc: dri-devel@lists.freedesktop.org; stable@vger.kernel.org; Luke Chen <luke_chen@aspeedtech.com>; Hungju Huang <hungju_huang@aspeedtech.com>; Charles Kuan <charles_kuan@aspeedtech.com>
> Subject: Re: [PATCH] drm/ast: Treat AST2600 like AST2500 in most places
> 
> On 08/06/2022 10:09, Kuo-Hsiang Chou wrote:
>> Hi Thomas
>>
>> Thanks for your suggestions!
>>
>> I answer each revision inline that followed by [KH]:.
> 
> Thanks for reviewing this.
>>
>> Regards,
>>
>>           Kuo-Hsiang Chou
>>
>> -----Original Message-----
>>
>> From: Thomas Zimmermann [mailto:tzimmermann@suse.de]
>>
>> Sent: Tuesday, June 07, 2022 8:03 PM
>>
>> To: airlied@redhat.com; airlied@linux.ie; daniel@ffwll.ch;
>> jfalempe@redhat.com; regressions@leemhuis.info; Kuo-Hsiang Chou
>> <kuohsiang_chou@aspeedtech.com>
>>
>> Subject: [PATCH] drm/ast: Treat AST2600 like AST2500 in most places
>>
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
>> [KH]: Based on CVE_2019_6260 item3, P2A is disallowed anymore.
>>
>> P2A (PCIe to AMBA) is a bridge that is able to revise any BMC registers.
>>
>> Yes, P2A is dangerous on security issue, because Host open a backdoor
>> and someone malicious SW/APP will be easy to take control of BMC.
>>
>> Therefore, P2A is disabled forever.
>>
>> Now, return to this patch, there is no need to add AST2600 condition
>> on the P2A flow.
>>
> 
> [snip]
>>
>> [KH]: Yes, the patch is "drm/ast: Create threshold values for AST2600"
>> that is the root cause of whites lines on AST2600
>>
>> commit
>>
>>
>> bcc77411e8a65929655cef7b63a36000724cdc4b
>> <https://cgit.freedesktop.org/drm/drm/commit/?id=bcc77411e8a65929655ce
>> f7b63a36000724cdc4b> (patch
>> <https://cgit.freedesktop.org/drm/drm/patch/?id=bcc77411e8a65929655cef
>> 7b63a36000724cdc4b>)
>>
> 
> 
> So basically this commit should be enough to fix the white lines  and flickering with VGA output on AST2600 ?
> [KH]: Yes.
> 	You are welcome to tell me something if you consider there is other strange issue.
> 	Thanks for your efforts on drm/ast project!
> Regards,
> 	Kuo-Hsiang Chou

I've got confirmation that this commit is enough to fix the issue 
introduced with f9bd00e0ea9d.

So let's drop this patch, and submit bcc77411e8a6 "drm/ast: Create 
threshold values for AST2600" to stable kernel instead.

Thanks,

> 
> I will try to have it tested, and if it's good, we may want to have it on stable kernel.
> 
> Best regards,
> 

