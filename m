Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 293646083D4
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 05:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiJVD2C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Oct 2022 23:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiJVD1y (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Oct 2022 23:27:54 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E55AD280EED;
        Fri, 21 Oct 2022 20:27:52 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id i3so4321660pfk.9;
        Fri, 21 Oct 2022 20:27:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=evDyrZvW0IfCxc1+01iWdtPlpzJLnkrTY0s2L4OXBJA=;
        b=AJDEn76aswgcPWRKPmzeERLpZ6DM+GCj4tC9CiE46gecf7aHdF6h88bfTL0/ZVENIB
         3dfksj1YN4vMDT2eW6K4bsVby57GZkSqYlr4FjQdmF5ivO2OfcfguHoD97w0bnKuQ6ds
         4MfT7BRR4b6nWxrIRgeE8rHU1E9TJaD5CPYpDXrDKHwDvBZXzogzjRIumnn4ibO8XS2u
         oFrqohRRPxyIJZCnPwCjty/r1PcAZWCJ7MF9PtXK0NRwU31C+MJ3oIIr5cAQ8mReFR8x
         tjsvOQhBI0qsE9IcF7LpnUZYvAaywuBvmaOTYqf+dFJglcR1cOTBVaQgUBXWUp8hzgiu
         7ngg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=evDyrZvW0IfCxc1+01iWdtPlpzJLnkrTY0s2L4OXBJA=;
        b=VSxAjQCZc+QrONqpiaqG5YVdsm10DDnMe0+vbvzX4BpfzPDHp/sv0y9chBsL+xn+Bk
         C3DbWthLV0wsX7uVxySUiinIHO577laU+KifK72gp4CQbwlPis7hjM4/ZJLiE6Of0X01
         THCDYnXySDe5eOXcnvh7JQyfNLz0pPFrysPD3+pAovhFECbAeLxNbohPcNqF4NHMAwnE
         qphTElmZURXBytnvtuuyzY6ugdI77JIgj6/bntM7A/ByA8lOtv1YbRZKlwOO3cqSA7pf
         66+LQQE9VxSTrh/2yXaXMCvCZkqdA6KECSK70+1zB+5M6VPR9r86tzUAT9r2izuKYyNO
         nk3g==
X-Gm-Message-State: ACrzQf3hD8X5723xCKj+5p+AuqSscLW173zgPKCye8uqEmUvXFis4NnE
        2OAwN85aWiNVnUOHjyOT9Pk=
X-Google-Smtp-Source: AMsMyM4DUiDp7gRKhpmyoG1aOqzHCbB/wgVcFTWOYnC2NSZI1sdOIt5ZCYLIe3krXF22iP1xLyXNTw==
X-Received: by 2002:a63:540b:0:b0:43c:8ce9:2800 with SMTP id i11-20020a63540b000000b0043c8ce92800mr18614299pgb.481.1666409272419;
        Fri, 21 Oct 2022 20:27:52 -0700 (PDT)
Received: from [192.168.43.80] (subs02-180-214-232-74.three.co.id. [180.214.232.74])
        by smtp.gmail.com with ESMTPSA id r26-20020aa7989a000000b00565d35cd658sm15727108pfl.217.2022.10.21.20.27.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Oct 2022 20:27:51 -0700 (PDT)
Message-ID: <ce764f98-52ae-60b5-79f6-55d107eeef9a@gmail.com>
Date:   Sat, 22 Oct 2022 10:27:48 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v2] Documentation: process: replace outdated LTS table w/
 link
To:     Jonathan Corbet <corbet@lwn.net>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Sasha Levin <sashal@kernel.org>, Tyler Hicks <code@tyhicks.com>
References: <Y0mSVQCQer7fEKgu@kroah.com>
 <20221014171040.849726-1-ndesaulniers@google.com>
 <87sfjkdcyc.fsf@meer.lwn.net>
Content-Language: en-US
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <87sfjkdcyc.fsf@meer.lwn.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/19/22 04:44, Jonathan Corbet wrote:
> Nick Desaulniers <ndesaulniers@google.com> writes:
> 
>> The existing table was a bit outdated.
>>
>> 3.16 was EOL in 2020.
>> 4.4 was EOL in 2022.
>>
>> 5.10 is new in 2020.
>> 5.15 is new in 2021.
>>
>> We'll see if 6.1 becomes LTS in 2022.
>>
>> Rather than keep this table updated, it does duplicate information from
>> multiple kernel.org pages. Make one less duplication site that needs to
>> be updated and simply refer to the kernel.org page on releases.
>>
>> Suggested-by: Tyler Hicks <code@tyhicks.com>
>> Suggested-by: Bagas Sanjaya <bagasdotme@gmail.com>
>> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Applied, thanks.
> 
> jon

Hi jon,

I noticed extraneous Rule: tag (as carried from kernel test robot [1])
in the applied patch:

commit 394df0afde11fa77c27e671ea91f74cb6440f86e
Author: Nick Desaulniers <ndesaulniers@google.com>
Date:   Fri Oct 14 10:10:40 2022 -0700

    Documentation: process: replace outdated LTS table w/ link
    
    The existing table was a bit outdated.
    
    3.16 was EOL in 2020.
    4.4 was EOL in 2022.
    
    5.10 is new in 2020.
    5.15 is new in 2021.
    
    We'll see if 6.1 becomes LTS in 2022.
    
    Rather than keep this table updated, it does duplicate information from
    multiple kernel.org pages. Make one less duplication site that needs to
    be updated and simply refer to the kernel.org page on releases.
    
    Suggested-by: Tyler Hicks <code@tyhicks.com>
    Suggested-by: Bagas Sanjaya <bagasdotme@gmail.com>
    Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
    Link: https://lore.kernel.org/stable/20221014171040.849726-1-ndesaulniers%40google.com
    Reviewed-by: Tyler Hicks (Microsoft) <code@tyhicks.com>
    Link: https://lore.kernel.org/r/20221014171040.849726-1-ndesaulniers@google.com
    Signed-off-by: Jonathan Corbet <corbet@lwn.net>

The tag doesn't have any purposes, so please drop it.

Thanks.

[1]: https://lore.kernel.org/stable/Y0y8IqEr0SIxHNvl@cbc4ca7ce717/

-- 
An old man doll... just what I always wanted! - Clara

