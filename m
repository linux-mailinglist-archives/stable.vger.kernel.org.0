Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC3260C28E
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 06:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbiJYEUI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 00:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbiJYEUG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 00:20:06 -0400
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E074286E0
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 21:20:05 -0700 (PDT)
Received: from localhost (013.lax.mailroute.net [127.0.0.1])
        by 013.lax.mailroute.net (Postfix) with ESMTP id 4MxJd10psBz2lHwT
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 04:20:05 +0000 (UTC)
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([199.89.1.16])
        by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10026)
        with LMTP id K5q7-BXM6Nky for <stable@vger.kernel.org>;
        Tue, 25 Oct 2022 04:20:04 +0000 (UTC)
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by 013.lax.mailroute.net (Postfix) with ESMTPS id 4MxJd03SDVz2lHwK
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 04:20:04 +0000 (UTC)
Received: by mail-io1-f71.google.com with SMTP id w16-20020a6b4a10000000b006a5454c789eso7716375iob.20
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 21:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c8mS3ZClJNgqsihJ0X5F4JJv7HMLZyAYVyP+E4+4PFQ=;
        b=Bgcd3Fe9GWwD5o3guJVv+HFd7EGNj2a7NcMAuybPhotU2LA9XCINi4sy5Mx2gvkx+d
         dUqxmmnJJSH3zPebrcyGBxxRC8FCy1rW4tI7Tbn3q7rxgQTxRXjSmtghSnf+qjc++BgB
         mYnOnV9KksPEnccXrANKW9+ghvlwgrDfC2m9kzZJSNj6lXIri87abNkNcbqa9YJdBJy6
         PngCi1J5XJ4c1jfbPK5902tO6tN+RNt+maPmdB2NW2Cv9Dz51jzfEjRHib8RTeguoyvR
         emZf88e5uRB7SsXvM13uc4A16/5xqeTF16sfrtt0luyzBlqHXwRffCVbHCNDyfsWggjs
         JLzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c8mS3ZClJNgqsihJ0X5F4JJv7HMLZyAYVyP+E4+4PFQ=;
        b=pCKNoOJP4zWwoXymYm5dUMTXMfMYchGdlhI6gQ/xe2elV/Lvg2xYZlqWkmrdJ6UVMT
         bincE5/Pxzsmdjy8gQaQsNAaNjYI9YXY7hrEBOaKXW/anPD3HEqlmFP6XM7ivUWAY/xM
         lnmGMN73xNDhh9DIikXtqCM8jbs01b9jZwwUu+SuyrKOX2CWHuCKQLEveEzjb5EWlAiO
         bLe7Md+p39/cC95GElJUdDFrvQL1EFYIGT5pMrQ9FJ/mIRx5Am6qfQDlMr5XV2BlU6JO
         vnrSWR7ZQep4yHP+5liNUkFCG0F2E7oAl5UTZLjqZCwLXwXYaXbLZeSYABAebSoBM84w
         SfCQ==
X-Gm-Message-State: ACrzQf243HIbzes453YK4SG3ADHitiPOWTendMuFpzOFU4Ak8ZKlIh5X
        ae555gvqkmRjfZ0PkKBbgmgaMbzxMIjikxPjNIUUj29SGJxFVGN/18dRyxvrLEwcDf/FfJsYV9c
        WDYcyfFXj43bOERDKVMOa1kTCC8PjROk=
X-Received: by 2002:a05:6638:380f:b0:363:cb7f:4fb8 with SMTP id i15-20020a056638380f00b00363cb7f4fb8mr23338485jav.227.1666671603145;
        Mon, 24 Oct 2022 21:20:03 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6xVT20BgZkdY5nyA12mPCd2F8hd4CAbsistp3630quXgcK37atx1RNrleMQtbYgcGa3U/RIQ==
X-Received: by 2002:a05:622a:11cf:b0:39c:d63a:d79 with SMTP id n15-20020a05622a11cf00b0039cd63a0d79mr30201344qtk.260.1666671592404;
        Mon, 24 Oct 2022 21:19:52 -0700 (PDT)
Received: from [192.168.1.39] (pool-108-4-135-94.albyny.fios.verizon.net. [108.4.135.94])
        by smtp.gmail.com with ESMTPSA id a1-20020a05620a438100b006cea2984c9bsm1264662qkp.100.2022.10.24.21.19.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Oct 2022 21:19:52 -0700 (PDT)
Message-ID: <9d34e1f3-ad51-0850-c6d5-1c0550f38c58@sladewatkins.net>
Date:   Tue, 25 Oct 2022 00:19:51 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 5.4 000/255] 5.4.220-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com
References: <20221024113002.471093005@linuxfoundation.org>
From:   Slade Watkins <srw@sladewatkins.net>
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/24/22 7:28 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.220 release.
> There are 255 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Oct 2022 11:29:24 +0000.
> Anything received after that time might be too late.

5.4.220-rc1 compiled and booted on my x86_64 test system. No errors or
regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

All the best,

-srw

