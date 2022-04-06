Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4A9F4F61EF
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 16:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234808AbiDFOY0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 10:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234915AbiDFOYS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 10:24:18 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E88AE21A889;
        Tue,  5 Apr 2022 21:00:13 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id i7so1213426oie.7;
        Tue, 05 Apr 2022 21:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RNgdmhlHV2YaSa/8H1LqQR7tgjnE4yKMr+9iZaYLTy0=;
        b=CNXSfdN0vlC+dcxnEiGotzlyZ3nX8n5QmGM4NQ1xPcl+h6NXek2ZH1Iz7i/G/wcHTg
         DKcedZk24zwH4K2CpZDUhNCVAfNtnML3GDWIeRuzZHhk7fTC5LHms+MYfmaLFZt3GSiO
         zw6In0OYiewjcP6bE5VGN1rQA4U2jE9Tm2tCmG80P65W59aNvXXpCIRa3UPHmTFQ6qxt
         wrcpwI+Z7P3PKYWeVCWPXG+ABXiVTIxU1IRL0tkxKIMK/eA57xnhhtUODrU90TIybiHQ
         kffSrPedlRQHjTBfbIEkc1RNpvrSNQgPzqMbi+LZ2ju46ijSxEFnDiJbBG0H1k9Z1UhP
         7y6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RNgdmhlHV2YaSa/8H1LqQR7tgjnE4yKMr+9iZaYLTy0=;
        b=OPStaCFapyNlQCD11hq3ANJJiWJb7n7uJS/VIH+CcxsqTxu8EKCyb6Kugemh7ifGxU
         QFXCTU+oKcF2jeElZ+YBlx3m0dkvcyIKhsRih7NZof5SpGdRwJzdTTx2oUPvpjdzV8r5
         1b2do2EC35uNrZaeXhbY7R1SB76Ee/DgXCWkH1QJFi0ybOeTAE2JTlzTUbTiAAfaEyyo
         a0haQqn4Rw0yDiZHuw76orXlyRV32WTdxvt1JbnhV56myHHhdVJ2WeWb06UC44U+XshZ
         Fya9LEVnCepCAi56FJwnWewFYpylDiBOh8zCLcgfe2oZVZJVU3rEcDz659xJAZAm3S9r
         b84g==
X-Gm-Message-State: AOAM533MqO/BuGHjmTcwSDSRph/3VN4lw/QX7JrrPv9sbtyul8p4GoIQ
        PdCrYNeD/AAu46SdvKica10=
X-Google-Smtp-Source: ABdhPJwBP63iKmYCkyaS8cxnP7aItx5dZ69nnJCiisBuK5RtmB5pZuoUHTSPJMwn0czM4ZAFOlGMZg==
X-Received: by 2002:a05:6808:ab1:b0:2ec:a6fa:7251 with SMTP id r17-20020a0568080ab100b002eca6fa7251mr2709381oij.180.1649217613364;
        Tue, 05 Apr 2022 21:00:13 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w22-20020acaad16000000b002d9c98e551bsm5926097oie.36.2022.04.05.21.00.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 21:00:12 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <074eef95-05b5-1e29-32ed-c2fe13d88c1d@roeck-us.net>
Date:   Tue, 5 Apr 2022 21:00:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.10 000/599] 5.10.110-rc1 review
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Sasha Levin <sashal@kernel.org>
References: <20220405070258.802373272@linuxfoundation.org>
 <20220406010749.GA1133386@roeck-us.net>
 <20220406023025.GA1926389@roeck-us.net>
 <20220405225212.061852f9@gandalf.local.home>
 <20220405230812.2feca4ed@gandalf.local.home>
 <20220405232413.6b38e966@gandalf.local.home>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20220405232413.6b38e966@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/5/22 20:24, Steven Rostedt wrote:
> On Tue, 5 Apr 2022 23:08:12 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
>> Here's a thought, if you decide to backport a patch to stable, and you see
>> that there's another commit with a "Fixes" tag to the automatically
>> selected commit. DO NOT BACKPORT IF THE FIXES PATCH FAILS TO GO BACK TOO!
> 
> Seriously. This should be the case for *all* backported patches, not just
> the AUTOSEL ones.
> 
> Otherwise you are backporting a commit to "stable" that is KNOWN TO BE
> BROKEN!
> 

Agreed.

Guenter
