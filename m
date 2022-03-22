Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC0A4E3C52
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 11:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232855AbiCVKVV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Mar 2022 06:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232539AbiCVKVU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Mar 2022 06:21:20 -0400
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6479B2459D
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 03:19:53 -0700 (PDT)
Received: by mail-wm1-f47.google.com with SMTP id h16so9662869wmd.0
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 03:19:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:content-language:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=KlT1vGryn6LPhAUb9Nqv7yAKNlYHoBDY48KDKqN80Y4=;
        b=QFwux6TjeVC5R3q2mkO3Ze8Mj4NFKNqVepLbZ83fkn6nFyzOnV0aM+pAvW828uikMh
         eVElNEyQdPUu9MdQMuW4KRIJXPknKDE5xxq05uvbpd7qtaSB0hv9qf6eMfdXVUNSBRMP
         RrYA+coxnB2I61zvmanlUtddbDiY43dX7mTBwlmgcCIszhbT08Oyp7wqekQq6DX0Dcwm
         w7l029UG6tozPLqvVGu/vkxDS/QcXJ22csSZEFuegjA/2fzo+VfUmWR8eMREvUjsVBUC
         w7pPl0E5mAlbOz1zBfK6WlIxpni2JCJfPXUsZf8VPOATH+FRwPBpzvKQQcu4bOFlilrz
         pcZQ==
X-Gm-Message-State: AOAM5327mTAoVt+Qr0qKjYQAVQ/Xg5qbbbG1i9v9FSPOlCptX74+GNic
        8HGR+bcLNwcZwDEE4RrrZmfoCUCIK1k=
X-Google-Smtp-Source: ABdhPJyUMwI1R35ioZPjjJ0DgpwPjX5sAhIBUaLHHDRQoaZRbc5H1Ihnw7o5qsw3U3rsO4yqa+cLgQ==
X-Received: by 2002:adf:fb8e:0:b0:203:bd5a:5741 with SMTP id a14-20020adffb8e000000b00203bd5a5741mr21516985wrr.65.1647944391643;
        Tue, 22 Mar 2022 03:19:51 -0700 (PDT)
Received: from [192.168.0.17] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.googlemail.com with ESMTPSA id l126-20020a1c2584000000b00387d4f35651sm1549093wml.10.2022.03.22.03.19.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Mar 2022 03:19:51 -0700 (PDT)
Message-ID: <6ffd085b-dea9-1e52-0268-8de851193225@kernel.org>
Date:   Tue, 22 Mar 2022 11:19:50 +0100
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
In-Reply-To: <Yjif3B1NQBr6z4c+@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21/03/2022 16:55, Greg KH wrote:
> On Mon, Mar 21, 2022 at 03:47:43PM +0100, Krzysztof Kozlowski wrote:
>> From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
>>
>> commit 5125091d757a251a128ec38d2397c9d160394eac upstream.
>>
>> Use Krzysztof Kozlowski's @kernel.org account in maintainer entries.
>>
>> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
>> Link: https://lore.kernel.org/r/20220307172805.156760-1-krzysztof.kozlowski@canonical.com'
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> ---
>>  .mailmap    |  1 +
>>  MAINTAINERS | 28 ++++++++++++++--------------
>>  2 files changed, 15 insertions(+), 14 deletions(-)
> 
> We do not normally do MAINTAINERS updates for older kernel trees as no
> one should be doing development against them.
> 
> Any reason why this is different?
> 

Hi Greg,

No, it's not different, but people work on backports for stables on a
stable branch. Then they send such patch from within the stable tree,
because it's easier, I guess. Without the .mailmap all these backports
will go to wrong email address - my @canonical.com will start bouncing
in two days.

In the same time I am not sure which mailmap is being followed by your
and other stable-folks tools, when notifying with backport queue
("5.16.17-rc1 review" etc.).

Plus people actually might have some questions about some my backported
commit. They might respond to the email shown in git log, which will be
wrong without mailmap file.

Best regards,
Krzysztof
