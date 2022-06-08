Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 672AE543130
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 15:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240045AbiFHNRN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 09:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240054AbiFHNRL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 09:17:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 10CBD22BF2
        for <stable@vger.kernel.org>; Wed,  8 Jun 2022 06:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654694223;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=35IFJYFxAzFnBmyN6TQCYl3GgLH/bjCkWr2t2lYzin8=;
        b=UlsMkEluEMHkrZ5LIXqFMRsdLhnI7eQdNmnYJ/vTU/1Vy1pPe+rsarb63I56zzpAbF+HHF
        pDprs6hluy+tcr8RCC6oVSbpa66vYWhxl4njo+MBCnU+pDVMeVDNv+naZgGHukY5hox0AR
        +nr5BQ/Oz0zelmO/vFZzdkq2yyw5tXk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-375-_H57Ri45POW5L1qBTVs4IA-1; Wed, 08 Jun 2022 09:17:02 -0400
X-MC-Unique: _H57Ri45POW5L1qBTVs4IA-1
Received: by mail-wm1-f69.google.com with SMTP id p18-20020a05600c23d200b0039c40c05687so3841624wmb.2
        for <stable@vger.kernel.org>; Wed, 08 Jun 2022 06:17:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=35IFJYFxAzFnBmyN6TQCYl3GgLH/bjCkWr2t2lYzin8=;
        b=wXS0g7rkWHf9hQ+f8btmJ2uPkcj+Y+JYPrI10Ua436zXMuaM00+rwiv2a8ZXzMQ9om
         pP+Kvl3I76veFFGiP7Nhfl2gN1NRVslESa2u873rst+LCSV1QnuuTDDNAYSnF0kZv1xk
         Qf+mHsPyvNrROAt4KT0LT7VGPBedGKCqcHVbo/0qlo4QzpPG7E2BRVDoWG7pSEkCYFXk
         JMeCP/3kXLcZQ8UfXLuft9PZniIbcTcZCql8iqNqa/byvQq8639fypHtbu25bs9AlYS4
         saLBNocZp5jVjOt142osaeF1GP0VYFXBuh8TToWMeQqUnySvf237BaorRL37UzItb3TF
         jIkQ==
X-Gm-Message-State: AOAM5304sZgQGAhpFm2Q3z+5veh3/Err/fuzOMub/GAdWmBRHCp8KLZr
        NCGcBIkKrpzQns2xVJeMIgu5Lb60CvsNgdKhG3hsy+vSLweGuo868mOCpIkZZBMnbzgWPtk0KS9
        XSKkiWiPNMYyFpalh
X-Received: by 2002:a5d:6786:0:b0:215:3cb5:b16c with SMTP id v6-20020a5d6786000000b002153cb5b16cmr26148264wru.6.1654694220527;
        Wed, 08 Jun 2022 06:17:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzb0xlaZX8diXj5CVPBq20XL/dK0cPt+ajXfdFa+Plm9ZItKdQioKLmDwJrsL0wIlM7Gr4S0g==
X-Received: by 2002:a5d:6786:0:b0:215:3cb5:b16c with SMTP id v6-20020a5d6786000000b002153cb5b16cmr26148250wru.6.1654694220293;
        Wed, 08 Jun 2022 06:17:00 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:c:37e0:f4b2:2105:b039:7367? ([2a01:e0a:c:37e0:f4b2:2105:b039:7367])
        by smtp.gmail.com with ESMTPSA id w7-20020adfee47000000b002185631adf0sm3927529wro.23.2022.06.08.06.16.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jun 2022 06:16:59 -0700 (PDT)
Message-ID: <c99f305f-ac4d-628b-b092-920af767a2e4@redhat.com>
Date:   Wed, 8 Jun 2022 15:16:58 +0200
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
From:   Jocelyn Falempe <jfalempe@redhat.com>
In-Reply-To: <PSAPR06MB4805B23B053F80C0F23A8C6C8CA49@PSAPR06MB4805.apcprd06.prod.outlook.com>
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

On 08/06/2022 10:09, Kuo-Hsiang Chou wrote:
> Hi Thomas
> 
> Thanks for your suggestions!
> 
> I answer each revision inline that followed by [KH]:.

Thanks for reviewing this.
> 
> Regards,
> 
>          Kuo-Hsiang Chou
> 
> -----Original Message-----
> 
> From: Thomas Zimmermann [mailto:tzimmermann@suse.de]
> 
> Sent: Tuesday, June 07, 2022 8:03 PM
> 
> To: airlied@redhat.com; airlied@linux.ie; daniel@ffwll.ch; 
> jfalempe@redhat.com; regressions@leemhuis.info; Kuo-Hsiang Chou 
> <kuohsiang_chou@aspeedtech.com>
> 
> Subject: [PATCH] drm/ast: Treat AST2600 like AST2500 in most places
> 
> Include AST2600 in most of the branches for AST2500. Thereby revert most 
> effects of commit f9bd00e0ea9d ("drm/ast: Create chip AST2600").
> 
> The AST2600 used to be treated like an AST2500, which at least gave 
> usable display output. After introducing AST2600 in the driver without 
> further updates, lots of functions take the wrong branches.
> 
> Handling AST2600 in the AST2500 branches reverts back to the original 
> settings. The exception are cases where AST2600 meanwhile got its own 
> branch.
> 
> [KH]: Based on CVE_2019_6260 item3, P2A is disallowed anymore.
> 
> P2A (PCIe to AMBA) is a bridge that is able to revise any BMC registers.
> 
> Yes, P2A is dangerous on security issue, because Host open a backdoor 
> and someone malicious SW/APP will be easy to take control of BMC.
> 
> Therefore, P2A is disabled forever.
> 
> Now, return to this patch, there is no need to add AST2600 condition on 
> the P2A flow.
> 

[snip]
> 
> [KH]: Yes, the patch is "drm/ast: Create threshold values for AST2600" 
> that is the root cause of whites lines on AST2600
> 
> commit
> 
> 
> bcc77411e8a65929655cef7b63a36000724cdc4b 
> <https://cgit.freedesktop.org/drm/drm/commit/?id=bcc77411e8a65929655cef7b63a36000724cdc4b> (patch 
> <https://cgit.freedesktop.org/drm/drm/patch/?id=bcc77411e8a65929655cef7b63a36000724cdc4b>)
> 


So basically this commit should be enough to fix the white lines  and 
flickering with VGA output on AST2600 ?
I will try to have it tested, and if it's good, we may want to have it 
on stable kernel.

Best regards,

-- 

Jocelyn

