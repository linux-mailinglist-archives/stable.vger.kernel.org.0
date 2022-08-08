Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C22BE58C4C2
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 10:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242105AbiHHIMm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Aug 2022 04:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235829AbiHHIMl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Aug 2022 04:12:41 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C95BF10FE0
        for <stable@vger.kernel.org>; Mon,  8 Aug 2022 01:12:40 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id pm17so8097064pjb.3
        for <stable@vger.kernel.org>; Mon, 08 Aug 2022 01:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=lGKwiwfrwHrkUcQYFoOe43Noq8FLID7y0rswJFSe/QA=;
        b=SForydozoD+SDVuJyTfK2dGcXcRTV6VatMNcK04qKXbTrddVlUCKebQXdMBsgFDUnK
         nLi2RkwLgi23cgP8ShfooYQaPKfOM2pDuJGwe8WvxjoYw+jwgm0Jef7wbabVBDj3xKxu
         IJiq+celH2+MFOjJRjQsGNuYwa1Pap03DAvZialV4msNtTXyeIVLDxzLZnMqcF454kv6
         gxdsIUV1oOH88nuqy962yRLaUOB+Czs/qM3/tMtu2htNEPyS5glyRsy732tDGmYxJNPJ
         gwrMEKvXwJhfWnwIHKNe9OrMYwM7lN4vp0ZJpViUHx7hEhSGbnR3Dluty4zpxt0ZNlP3
         oTpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=lGKwiwfrwHrkUcQYFoOe43Noq8FLID7y0rswJFSe/QA=;
        b=A4U28icSgfVJb/tuvO5UktJ8WGQuYI84ngVv99NO667Od6/fuNeCe3KTsq8JsDIhBA
         BPRe0qm1rqR3ChyE/GLeGHnppeJUm/1N/gxOIiBX/MCrmIG4In5riBhX7ZQTSsBkpZGY
         WzITyygVXpUMLEEDk+oYVs5fTLNbXj70I8ZZ84ebzhsJxwbRWLyTdPAFj5JBG+J70f2a
         yUev/NFsaarsAF4P5rczSVOWGsGvehmE5+IxSwzyFnDGLJvw/CL9g0g2dAbsijIB8HZg
         gpUBnKNOfQN6VgiP4Cv8BSHndsG+j41IJFfXmMg1AXemxlnW11L7G0e6ZKMuDkIjCrFt
         yQlg==
X-Gm-Message-State: ACgBeo18CVp+5fOKo9B3rktOJLNjLVQWzDUArvnWom4Syzhxs9Eo8lCl
        UxNuPHqaMG8k/yqSI9yJQJk=
X-Google-Smtp-Source: AA6agR4kcCCEJ67QBHrUwo0n6EEcVXjLI2EBqbvXYjHJ7OADILfAGieBCrX1AC4eJZxW4ziPVP/EvQ==
X-Received: by 2002:a17:902:e846:b0:170:84c5:ae21 with SMTP id t6-20020a170902e84600b0017084c5ae21mr11479700plg.19.1659946360230;
        Mon, 08 Aug 2022 01:12:40 -0700 (PDT)
Received: from [192.168.43.80] (subs32-116-206-28-17.three.co.id. [116.206.28.17])
        by smtp.gmail.com with ESMTPSA id mi17-20020a17090b4b5100b001f334aa9170sm9883242pjb.48.2022.08.08.01.12.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Aug 2022 01:12:39 -0700 (PDT)
Message-ID: <7d749ba8-e1e7-6614-a5f6-abaeebd2691d@gmail.com>
Date:   Mon, 8 Aug 2022 15:12:36 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: Fwd: warning: stable kernel rule is not satisfied
Content-Language: en-US
To:     kernel test robot <rong.a.chen@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, lkp <lkp@intel.com>
References: <2364552d-9b18-875a-484a-d54ee8b9b9ee@intel.com>
 <baf4e189-2302-ea9c-e905-4ebc33c1e937@intel.com>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <baf4e189-2302-ea9c-e905-4ebc33c1e937@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/8/22 09:51, kernel test robot wrote:
> -------- Forwarded Message --------
> Subject: warning: stable kernel rule is not satisfied
> <snip>
> 
> Hi,
> 
> Thanks for your patch.
> 
> FYI: kernel test robot notices the stable kernel rule is not satisfied.
> 
> Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
> Subject: [PATCH 5.10] block: fix null-deref in percpu_ref_put
> Link: https://lore.kernel.org/stable/20220729065243.1786222-1-zhangwensheng%40huaweicloud.com
> 
> The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> 

Sasha uses "[ Upstream commit <sha1> ]", so his syntax should be
accepted, too.

-- 
An old man doll... just what I always wanted! - Clara
