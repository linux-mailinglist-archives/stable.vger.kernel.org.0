Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6CD4BDCE3
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381516AbiBURQj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 12:16:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381547AbiBURQW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 12:16:22 -0500
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3390C2611C;
        Mon, 21 Feb 2022 09:15:56 -0800 (PST)
Received: by mail-qv1-xf34.google.com with SMTP id h9so33673592qvm.0;
        Mon, 21 Feb 2022 09:15:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mPnjdyNON3aH29N07yqnS0p2tUTlWMjKBlxLndY90Uw=;
        b=pnubFZhWYa+7pa/CD1MCaaFadpQ9qJ1esPvEyYSfrMFOP4bAAyX4jq5ivI70LjyL+K
         1F2HP2VUyuL4pvcU19cJXh0Xy4SMDREYyveCjoPz/MAUyQyNnCBw2LegFGAIT1aA7Sbd
         /VwiwQ0wT1K0J6nHAgo/5S7e1GIVjlUnrTgqf91LXsng9FTvLoFs9RfdZesWdBLcPBoJ
         ngVc5ZMd1/wEZHdny0LpRXX8ll5JoAfjyDtQAMyHqX/AIr3k6qKTLhTHO5n5MkocCiYm
         e02xHjdRUXh3XAbcgt+NSdQGVWBKG12bN6lPCnQkuir5W0WSXxKE34l3A6E6LrXjZER/
         EDkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mPnjdyNON3aH29N07yqnS0p2tUTlWMjKBlxLndY90Uw=;
        b=2QvxewRLE/ZIBBJwrSykQeNHgecN4aMvY2vuFQu+iRx+ldyqCgF3wAmZDvL5lQHpFK
         2hvZ2v5QZJ3Z0pr6PycwmlE9fGNpfkjSuak/uJZHuEDgDX86/5HgA7proiCvFUgxowWq
         UuSbWtONgfPV71piR40QdN2bcA8B0nVjUkNstUaItB9rjvE00V/bTlgVXO9G2Z4uTQja
         ba2PokMUysY6KQSc+92dFSyxtciEU+IxAC8rBAPI+YEe6keLkKofK+GJ90hbRcNmHs3r
         SKi2bmGXOY84ekaB+QfPdwyKO+rIQLofh+VJ7e654E/CUwHaylnZW9yujSlG7LbIuc7z
         2/rQ==
X-Gm-Message-State: AOAM533hoa9VSPoyrNO6wZaXoXAa+Xh3Wb+4TLkR3lHOYF2KJrWnWBwU
        Qb1UP7ak9169ZP0Cawy0Xz+A5shbR/tmQQ==
X-Google-Smtp-Source: ABdhPJxp8xSKsm1MOriQlH3tNMN0ToGRMd/UQq7FwVhY02J7fGvlM1U3ZrmqOFQVbegJbTrVv7omHw==
X-Received: by 2002:a05:622a:308:b0:2dc:8b37:5dda with SMTP id q8-20020a05622a030800b002dc8b375ddamr18158512qtw.492.1645463755364;
        Mon, 21 Feb 2022 09:15:55 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j9sm4230294qta.83.2022.02.21.09.15.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 09:15:54 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <d72c8af1-e93d-44ae-15e0-737302523961@roeck-us.net>
Date:   Mon, 21 Feb 2022 09:15:52 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.15 000/196] 5.15.25-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220221084930.872957717@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
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

On 2/21/22 00:47, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.25 release.
> There are 196 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> Anything received after that time might be too late.
> 


Building arm:allmodconfig ... failed
Building arm64:allmodconfig ... failed
--------------
Error log:
drivers/tee/optee/core.c: In function 'optee_probe':
drivers/tee/optee/core.c:726:20: error: operation on 'rc' may be undefined

Building mips:nlm_xlp_defconfig ... failed
--------------
Error log:
net/netfilter/xt_socket.c: In function 'socket_mt_destroy':
net/netfilter/xt_socket.c:224:17: error: implicit declaration of function 'nf_defrag_ipv6_disable'; did you mean 'nf_defrag_ipv4_disable'?

