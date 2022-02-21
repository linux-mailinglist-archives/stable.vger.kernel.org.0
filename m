Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFFA54BEAF9
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 20:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbiBUS1B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 13:27:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232462AbiBUSYf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 13:24:35 -0500
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C650764C;
        Mon, 21 Feb 2022 10:17:10 -0800 (PST)
Received: by mail-qk1-x72a.google.com with SMTP id z66so12042661qke.10;
        Mon, 21 Feb 2022 10:17:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:content-language:to
         :cc:references:from:subject:in-reply-to:content-transfer-encoding;
        bh=+6WNmmFYbJpblRf4ebgcnmUOGfCcohgKelAtqTglXiI=;
        b=gXX8qGPgeWVTyIuIU/gzzSDs3Ny9HOZqbMc3B85PEyNP4Tw5riadydixZtGF0BxjPK
         r8Jinbdn+wSuKJNjHs5CO/CEWu2ijk/RvGDmvxlxdikI6ZUM6E5nFhiGgNnrQst5LAuE
         S95xnhzXJ1tilZd4xZNKlcEWiuXG4l5k4LtPgKAzeoqGwXW4bLsyuAsoOPIDN9661xwo
         YpPOpvh32kpw8Apflfoky7vFvk8j4fczmLFxSoOH6gAFkUBMzlUU6N5gGdiDT+0ji0fr
         jVAP1efNHjQmfP0IGK0gkQesBINHpLTARcUgVxdafdliDSq2uHN9xC5QdM+IBZoRJAQo
         GGfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=+6WNmmFYbJpblRf4ebgcnmUOGfCcohgKelAtqTglXiI=;
        b=FnNzxTo1sZWs4FfwUBkd3jM9hGlD7vyOeoIjmv9LbgndZzDuUt7hqfzpGC/jEfTi0B
         zFfI6C+mJVf2nOIIWIH0Wdi6oDZ9wX7ql8GSpiYrngE5426FRHyJ9elGrDPeYyXc8Bh7
         RKf6BDRNbkkcvpHcR+VNm90dz3vKICHFLips76Uujza2SDAwIlEftAPvIWcXaJxGmNtz
         yoImryHLn21p6QwnSWGT7AMCvEyI8N22Qlc+58BtIVF2tpC9W0aFmlf8HBlRMy8aeH3u
         LNqKaafKaLbhif6QNy7dfpBY7T5U3d1kMfuBDRZb7Fz84cCBF5YcQZLOnBBA6mHKT1JO
         NMEA==
X-Gm-Message-State: AOAM530EVi0B1fXtQfnXkR/ltxqBGQV5O0Z9hq7P/FmSh8ABqXfAEkbo
        Be8VPETJ0WzwchHH/25uCa8=
X-Google-Smtp-Source: ABdhPJww08+Oo0QuZczfCmmn6UwTWRG006Bnt5o6ILYM2wfGZyVsufWg3NZKQzkEb0hjygDAhvRLJQ==
X-Received: by 2002:a05:620a:122c:b0:47d:875d:fffe with SMTP id v12-20020a05620a122c00b0047d875dfffemr12742218qkj.528.1645467429193;
        Mon, 21 Feb 2022 10:17:09 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k6sm5666402qko.43.2022.02.21.10.17.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 10:17:08 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <6c099f84-ed6c-8608-df8f-74fbf2de7151@roeck-us.net>
Date:   Mon, 21 Feb 2022 10:17:06 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220221084934.836145070@linuxfoundation.org>
 <0ceb2013-061c-700f-c386-3b180a96d59a@roeck-us.net>
 <YhPSX1/DbOcFPjnQ@kroah.com>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.16 000/227] 5.16.11-rc1 review
In-Reply-To: <YhPSX1/DbOcFPjnQ@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/21/22 09:56, Greg Kroah-Hartman wrote:
> On Mon, Feb 21, 2022 at 09:17:51AM -0800, Guenter Roeck wrote:
>> On 2/21/22 00:46, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 5.16.11 release.
>>> There are 227 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
>>> Anything received after that time might be too late.
>>>
>>
>> Building mips:malta_defconfig ... failed
>> --------------
>> Error log:
>> net/netfilter/xt_socket.c: In function 'socket_mt_destroy':
>> net/netfilter/xt_socket.c:224:17: error: implicit declaration of function 'nf_defrag_ipv6_disable'; did you mean 'nf_defrag_ipv4_disable'? [
>>
>> Inherited from upstream.
> 
> Ah, fun :(
> 
> I'll leave this for now, it's "just" a Kconfig dependancy issue.  Does
> upstream know about it?
> 

Yes. And, no, it is not just a Kconfig dependency issue.
NETFILTER_XT_MATCH_SOCKET does not historically and should
not depend on IPV6. There is a missing #ifdef in
net/netfilter/xt_socket.c.

Guenter
