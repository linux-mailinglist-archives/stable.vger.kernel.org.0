Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5E995459ED
	for <lists+stable@lfdr.de>; Fri, 10 Jun 2022 04:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240263AbiFJCI7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jun 2022 22:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233048AbiFJCI4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jun 2022 22:08:56 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5D8822C89B
        for <stable@vger.kernel.org>; Thu,  9 Jun 2022 19:08:54 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id y69so20243325oia.7
        for <stable@vger.kernel.org>; Thu, 09 Jun 2022 19:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mVEvxZacoKOUwcjBpEJp4kvyqgXvwWIaeRjUlT1XbrM=;
        b=DOXRB4oDWO7ViICERCAGqZkdzU8zuyWIl+bctXJ2NN7cUvT5fhdYYkBPi0myCzgtZQ
         8c2okqeG0PI5UBoNu6oWnSoUV+eKepEwB3grVYMdvDWvVAw/Egs0iK/SAfRMUrdAyWbj
         iGFPA1IR3JrZzG0PImIEz06QvXO+UK0JIV28FczY1eX8CiE/udfLbcP/WD5FGAtYy0MB
         PE1Q6jsa/paodegh1YSBskm751DLXgm7KM+pib9wZh6ISoPlFaPj4e3DTZ6nxJS1x1mZ
         nrsyuxhvdsMHOK/ny46unDJwtg5uoC+JcG8khm5Atxvr5NxmB1EaKKkaFfyuwlmYfCsE
         B8Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mVEvxZacoKOUwcjBpEJp4kvyqgXvwWIaeRjUlT1XbrM=;
        b=7wTfbXDhVwS4jqZeFS95WY+KnVRynDseSqayu3nO+wUzS7oEgaYsW/wy1wi3Jtj+7Y
         CX4URxJZ1dHAw7QTvvzzCEya7r+qEe5rAiNeJ4V6l2zCbloGUKblF7w02F2ffY7d2yLy
         LTGe78OrwleLgzdO3tAhTqZv/aOLsQKb5r64j+qLIV1IebAQN79eyWcNFe+llPJ/qfuG
         wWGkCYb4u/ibkd39Kh1ACBrFx/g1/64uEYy8Wycu1R4Vmt74fMM1EoRJn8+VfIJCCmyf
         nUEApf0QrGAREt3BJi/l4alJjiVuJ4D4dsHHaURReG9wb8q8+UEbyi/AUg6AuMi3QlFH
         Qobw==
X-Gm-Message-State: AOAM533yKNJmHSyaFnJ6Y5kkZ/OK82hZRXib0/rkw1WwBwOobO+Rf29A
        kmKOPuR0r+MOyvl69s9HLkjT7wlllnU=
X-Google-Smtp-Source: ABdhPJzP7Ep0uUm+amOjLnvvBC29loTbqPe4q/AivrOzJagUug2g2q/2TtpBlcR9f6xCd9pMQbRbrw==
X-Received: by 2002:a05:6808:10c2:b0:32b:77fd:6168 with SMTP id s2-20020a05680810c200b0032b77fd6168mr3467537ois.162.1654826934260;
        Thu, 09 Jun 2022 19:08:54 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bf1-20020a056808190100b0032af3cffac7sm14491708oib.2.2022.06.09.19.08.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jun 2022 19:08:53 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <c1544e9a-d492-00dc-9482-7d7346869303@roeck-us.net>
Date:   Thu, 9 Jun 2022 19:08:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: Boot stalls in v4.9.y to v5.4.y stable queues
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     linux-stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
References: <20220610000555.GA2492906@roeck-us.net>
 <CANn89iKZqfKQrJLZbjnngHjSx_AoyUHMmOwK5aek4jDVNyj77g@mail.gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <CANn89iKZqfKQrJLZbjnngHjSx_AoyUHMmOwK5aek4jDVNyj77g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/9/22 18:59, Eric Dumazet wrote:
> On Thu, Jun 9, 2022 at 5:05 PM Guenter Roeck <linux@roeck-us.net> wrote:
>>
>> Hi,
>>
>> all stable release queues from v4.9.y up to v5.4.y have boot stall
>> problems. The culprit is the backport of commit d7ea0d9df2a6 ("net:
>> remove two BUG() from skb_checksum_help()"), specifically the following
>> code.
>>
> 
> Not sure why this patch has been backported.
> 
> It had no Fixes: tag, and was not a stable candidate.
> 

Happens with lots of patches. Never ending discussion.

Guenter

>> While that works fine in the upstream kernel since ret is subsequently
>> always overwritten, that is not the case in older kernels. In those,
>> the function now always returns -EINVAL.

