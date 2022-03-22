Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 343654E3CB5
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 11:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbiCVKnv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Mar 2022 06:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233206AbiCVKnt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Mar 2022 06:43:49 -0400
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 056F5811BE
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 03:42:21 -0700 (PDT)
Received: by mail-ej1-f45.google.com with SMTP id qx21so35181105ejb.13
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 03:42:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:content-language:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=0E3tJPIZtH/HWyq/5vw9LDr/vbXSilYNbBMDfeilPcs=;
        b=MEnHCY5ejkNMHnhA6NP8AOSWEci0oidfcxTFdW/FbGP47nT7F7UxDExKZYuWAVyMiF
         X9p3PnIGhE0RZP/Fc85sB46sdxb4ZnMHgw9u9KVZAqc52R0XOiw2F47+sdLFIAkmF7/8
         NdUcp1Zw4ix3sYlIJDT/Kma16s0fdBuMlXJThOUwes+iZVd+mYHxHP6qK+bAk00bsNAQ
         HWwleoHCNeVa7Ju1dO7nclfCZLHR8bPkXCputfD6gNYPBkf0CVnYq9dPriL/ovxxaTUh
         Ue/psf3WRvw0I7KzYurupKarbtBOb4Z3vN7aQr7pwWqgofrEHOVVsmx9aWlAAd5XSj+Y
         AkEQ==
X-Gm-Message-State: AOAM533SZutCLCuYIi/Xtf6hxXYCwrTa34zuVqr+kzcRgSq/vz4LgWk9
        0P5yNsfevXBAeONeWLgd+YWeSLPuCFQ=
X-Google-Smtp-Source: ABdhPJzDFU5VnyoDKg16oiJ6uDjLQusSaoLeyeTzwkXTG2HKQ0XFMAOT/8k5s0Ji34POhvcoFseEww==
X-Received: by 2002:a17:906:6a13:b0:6db:ab28:9f00 with SMTP id qw19-20020a1709066a1300b006dbab289f00mr24920356ejc.296.1647945739355;
        Tue, 22 Mar 2022 03:42:19 -0700 (PDT)
Received: from [192.168.0.17] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.googlemail.com with ESMTPSA id o17-20020a056402439100b0041938757232sm3073520edc.17.2022.03.22.03.42.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Mar 2022 03:42:18 -0700 (PDT)
Message-ID: <c845b899-61ac-ef17-1643-72387273b419@kernel.org>
Date:   Tue, 22 Mar 2022 11:42:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
From:   Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH stable-5.15] MAINTAINERS: update Krzysztof Kozlowski's
 email
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>
References: <20220321144743.17896-1-krzk@kernel.org>
 <Yjif3B1NQBr6z4c+@kroah.com>
 <6ffd085b-dea9-1e52-0268-8de851193225@kernel.org>
 <YjmknD4C/WyJgiae@kroah.com>
In-Reply-To: <YjmknD4C/WyJgiae@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22/03/2022 11:27, Greg KH wrote:
>> Hi Greg,
>>
>> No, it's not different, but people work on backports for stables on a
>> stable branch. Then they send such patch from within the stable tree,
>> because it's easier, I guess. Without the .mailmap all these backports
>> will go to wrong email address - my @canonical.com will start bouncing
>> in two days.
>>
>> In the same time I am not sure which mailmap is being followed by your
>> and other stable-folks tools, when notifying with backport queue
>> ("5.16.17-rc1 review" etc.).
> 
> I don't use any tools that uses the mailmap file at all.  So updating it
> isn't going to affect the stable patch review process, sorry.
> 
>> Plus people actually might have some questions about some my backported
>> commit. They might respond to the email shown in git log, which will be
>> wrong without mailmap file.
> 
> People change email addresses all the time, this isn't anything new.  I
> really don't want to get into the habit of having to keep this file up
> to date with Linus's tree for 6 years, sorry.
> 

Understood, no problem, thanks for the explanation!


Best regards,
Krzysztof
