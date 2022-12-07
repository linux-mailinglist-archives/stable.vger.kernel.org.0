Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7D8464541D
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 07:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiLGGlf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 01:41:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiLGGle (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 01:41:34 -0500
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC68140E6;
        Tue,  6 Dec 2022 22:41:28 -0800 (PST)
Received: by mail-ed1-f52.google.com with SMTP id r26so23496679edc.10;
        Tue, 06 Dec 2022 22:41:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IePjtWP2tMTHBzV3E6H1Y47w4fEwMOQQSgYywHsQv04=;
        b=Z/kmI8ustk6m9rIrM5arKAe9fp7hskOYKE5g1eeis7TOvZ2YnQwhUuFn8ZtNW0R6Ha
         diadYaB4F/Ge97MDYwKd2fIXnxjpwSneL3GXJUBcNAblsXO7rn60qU2B2w4/OKXt8wgp
         g9CE1zl311d/X9Aaz89rXIkr5WXZw+vn/Uuoj+O7NdsIHre8LqyIAnW63962M4Rj3HOh
         pUWADQoQYFA6zhFAA3hYTJohf0x0/du+UZLepgOvlF2GoL0ZkMSphlTFdTRV4yWDYDJd
         33kFBkNwDyOSgVULS9CzbjrX66efaPBR/l7/f1xKGJDLcM0MdDh4D9IG8g197aeWCSZ8
         SnOA==
X-Gm-Message-State: ANoB5pnKL1ZQfc0jfTM6QAIdut4ajbXWkoJYpRFvJpeAT6l9W6YNizYE
        QklITUPZqUDWacapMPpGHNA=
X-Google-Smtp-Source: AA0mqf4IXMnt0lrYtJhfrJDTgjQzk/muy8A+JGD3CARfXorv8VdXUNsqd+Rme0JfEjzv/Z3aGn0iAQ==
X-Received: by 2002:a05:6402:c88:b0:46c:aa8b:da52 with SMTP id cm8-20020a0564020c8800b0046caa8bda52mr12085387edb.262.1670395287208;
        Tue, 06 Dec 2022 22:41:27 -0800 (PST)
Received: from ?IPV6:2a0b:e7c0:0:107::aaaa:49? ([2a0b:e7c0:0:107::aaaa:49])
        by smtp.gmail.com with ESMTPSA id q26-20020a170906389a00b007bdc2de90e6sm8156980ejd.42.2022.12.06.22.41.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Dec 2022 22:41:26 -0800 (PST)
Message-ID: <3beac08e-ffba-8c3b-a5b1-1a34e125b3a7@kernel.org>
Date:   Wed, 7 Dec 2022 07:41:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] [v2] ata: ahci: fix enum constants for gcc-13
Content-Language: en-US
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Arnd Bergmann <arnd@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Luis Machado <luis.machado@arm.com>, linux-ide@vger.kernel.org,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
References: <20221203105425.180641-1-arnd@kernel.org>
 <95785bc5-ac4b-9c44-74ea-6b3afb11cf14@opensource.wdc.com>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <95785bc5-ac4b-9c44-74ea-6b3afb11cf14@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Arnd,

I just noticed this on stable@. Do you have more of the gcc-13-enum 
patches? I sent some (this one incl.), but didn't have time for v2 of 
some of them. So should I respin the rest or have you fixed them all yet?

 > [PATCH] ath11k (gcc13): synchronize 
ath11k_mac_he_gi_to_nl80211_he_gi()'s return type - "Jiri Slaby (SUSE)" 
<jirislaby@kernel.org> - 2022-10-31 1243.eml:Message-Id: 
<20221031114341.10377-1-jirislaby@kernel.org>
 > [PATCH] block_blk-iocost (gcc13): cast enum members to int in prints 
- "Jiri Slaby (SUSE)" <jirislaby@kernel.org> - 2022-10-31 
1245.eml:Message-Id: <20221031114520.10518-1-jirislaby@kernel.org>
 > [PATCH] bonding (gcc13): synchronize bond_{a,t}lb_xmit() types - 
"Jiri Slaby (SUSE)" <jirislaby@kernel.org> - 2022-10-31 
1244.eml:Message-Id: <20221031114409.10417-1-jirislaby@kernel.org>
 > [PATCH] drm_amd_display (gcc13): fix enum mismatch - "Jiri Slaby 
(SUSE)" <jirislaby@kernel.org> - 2022-10-31 1242.eml:Message-Id: 
<20221031114247.10309-1-jirislaby@kernel.org>
 > [PATCH] drm_nouveau_kms_nv50- (gcc13): fix nv50_wndw_new_ prototype - 
"Jiri Slaby (SUSE)" <jirislaby@kernel.org> - 2022-10-31 
1242.eml:Message-Id: <20221031114229.10289-1-jirislaby@kernel.org>
 > [PATCH] init: Kconfig (gcc13): disable -Warray-bounds on gcc-13 too - 
"Jiri Slaby (SUSE)" <jirislaby@kernel.org> - 2022-10-31 
1242.eml:Message-Id: <20221031114212.10266-1-jirislaby@kernel.org>
 > [PATCH] i40e (gcc13): synchronize allocate_free functions return type 
& values - "Jiri Slaby (SUSE)" <jirislaby@kernel.org> - 2022-10-31 
1244.eml:Message-Id: <20221031114456.10482-1-jirislaby@kernel.org>
 > [PATCH] qed (gcc13): use u16 for fid to be big enough - "Jiri Slaby 
(SUSE)" <jirislaby@kernel.org> - 2022-10-31 1243.eml:Message-Id: 
<20221031114354.10398-1-jirislaby@kernel.org>
 > [PATCH] RDMA_srp (gcc13): force int types for max_send_sge and 
can_queue - "Jiri Slaby (SUSE)" <jirislaby@kernel.org> - 2022-10-31 
1245.eml:Message-Id: <20221031114506.10501-1-jirislaby@kernel.org>
 > [PATCH] sfc (gcc13): synchronize ef100_enqueue_skb()'s return type - 
"Jiri Slaby (SUSE)" <jirislaby@kernel.org> - 2022-10-31 
1244.eml:Message-Id: <20221031114440.10461-1-jirislaby@kernel.org>
 > [PATCH] thunderbolt (gcc13): synchronize tb_port_is_clx_enabled()'s 
2nd param - "Jiri Slaby (SUSE)" <jirislaby@kernel.org> - 2022-10-31 
1243.eml:Message-Id: <20221031114323.10356-1-jirislaby@kernel.org>
 > [PATCH] wireguard (gcc13): cast enum limits members to int in prints 
- "Jiri Slaby (SUSE)" <jirislaby@kernel.org> - 2022-10-31 
1244.eml:Message-Id: <20221031114424.10438-1-jirislaby@kernel.org>
 > [PATCH 1_2] ata: ahci (gcc13): use BIT() for bit definitions in enum 
- "Jiri Slaby (SUSE)" <jirislaby@kernel.org> - 2022-10-31 
1243.eml:Message-Id: <20221031114310.10337-1-jirislaby@kernel.org>
 > [PATCH 2_2] ata: ahci (gcc13): use U suffix for enum definitions - 
"Jiri Slaby (SUSE)" <jirislaby@kernel.org> - 2022-10-31 
1243.eml:Message-Id: <20221031114310.10337-2-jirislaby@kernel.org>

thanks,

On 06. 12. 22, 7:46, Damien Le Moal wrote:
> On 12/3/22 19:54, Arnd Bergmann wrote:
>> From: Arnd Bergmann <arnd@arndb.de>
>>
>> gcc-13 slightly changes the type of constant expressions that are defined
>> in an enum, which triggers a compile time sanity check in libata:
>>
>> linux/drivers/ata/libahci.c: In function 'ahci_led_store':
>> linux/include/linux/compiler_types.h:357:45: error: call to '__compiletime_assert_302' declared with attribute error: BUILD_BUG_ON failed: sizeof(_s) > sizeof(long)
>> 357 | _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>>
>> The new behavior is that sizeof() returns the same value for the
>> constant as it does for the enum type, which is generally more sensible
>> and consistent.
>>
>> The problem in libata is that it contains a single enum definition for
>> lots of unrelated constants, some of which are large positive (unsigned)
>> integers like 0xffffffff, while others like (1<<31) are interpreted as
>> negative integers, and this forces the enum type to become 64 bit wide
>> even though most constants would still fit into a signed 32-bit 'int'.
>>
>> Fix this by changing the entire enum definition to use BIT(x) in place
>> of (1<<x), which results in all values being seen as 'unsigned' and
>> fitting into an unsigned 32-bit type.
>>
>> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=107917
>> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=107405
>> Reported-by: Luis Machado <luis.machado@arm.com>
>> Cc: linux-ide@vger.kernel.org
>> Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>> Cc: stable@vger.kernel.org
>> Cc: Randy Dunlap <rdunlap@infradead.org>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> Applied to for-6.2. Thanks !
> 

-- 
js
suse labs

