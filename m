Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70D9F5F5A9A
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 21:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231322AbiJET3d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 15:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiJET3E (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 15:29:04 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4020C4F19E;
        Wed,  5 Oct 2022 12:29:04 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id l4so858975plb.8;
        Wed, 05 Oct 2022 12:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date;
        bh=6U3AgOxHHf+2TW8ywgTT4zpypvR1+mMBjFxrfLL8OCM=;
        b=k3Z2eJ01DVOSiCEoRWACrkYP9sLUuDZJytRynLJEv81vw1/8mdifNuSCbnDnFRAwgA
         C1JUQsSuy+kxtLxxWI82fGyG9pbsgmWiYLi5VXDWsqHqCJPqwhtqfd48l6YJLRc9KSJf
         oo0kLFGWgA5QiOGBw6PMQIiKTzYuiiWYe0cacaG3muuyG/kML3FhknKq8RxTiSDxCMgW
         HMLbbRNELrTSZjk9d5/AzXSeXTJ9Hlu3LLVZHymjC9JxeXPv7sw9svvOgTo9jlJdDSCZ
         dHE7tsFOYqPD4CZUcmoCJRteS8sqg2MscCOinOxwvWOsa3jJcpA/t/pH4Iqdv33p1IFq
         KVNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date;
        bh=6U3AgOxHHf+2TW8ywgTT4zpypvR1+mMBjFxrfLL8OCM=;
        b=eOWPoniadHIdRQLUG0AoKTtnd2QmVT+W2pTqsFiVS0DLaGIugE5kQse9SfQXsYC2SW
         57LnqnUwSssArhls8tQ28nKmpaTXgjBAzqdrbvBw2KXhlBqfS6KTz07la9OHfd2vGGpf
         ohrT4qhIaTVyFUfM3cvcjAM9lpf1HzBZgCw+/nJGByrlNbNE3uVh9WFpwNCrsl6NJkaT
         q+B7/14NcgmvIESBCCvotjxFunP1TnvKV2bqr24mVYMyzWSjl2sIs5+0MDfrqN9dAbC4
         EedSlSkQ7ne8fs4fhnyiCbXwamRN5ZerGN2srXceV+h1vaW4pr6ggo/1lzU9i7qdHB6i
         owtg==
X-Gm-Message-State: ACrzQf0EEzdS2rDKkMbIqXYVomBYZr34/Y5hElLULelp5RH4duOBt72K
        q6krmURNq9aYBSOsyr5/vYY=
X-Google-Smtp-Source: AMsMyM6bMSK9cj4dUcwMrQDOSFsV9UHJMlqfqnqyjVqteCDobxW2rrdMwl/d5u1sYOlTTcb8iQwfsA==
X-Received: by 2002:a17:90b:38d2:b0:20a:92f0:867c with SMTP id nn18-20020a17090b38d200b0020a92f0867cmr1285634pjb.163.1664998143796;
        Wed, 05 Oct 2022 12:29:03 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d11-20020a631d0b000000b0043a1c0a0ab1sm90029pgd.83.2022.10.05.12.29.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Oct 2022 12:29:02 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <93434072-6195-829b-a0b1-9ed27dcf1e61@roeck-us.net>
Date:   Wed, 5 Oct 2022 12:29:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.4 00/51] 5.4.217-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
References: <20221005113210.255710920@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20221005113210.255710920@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/5/22 04:31, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.217 release.
> There are 51 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 Oct 2022 11:31:56 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 161 pass: 161 fail: 0
Qemu test results:
	total: 447 pass: 447 fail: 0

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

Guenter
