Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2833652CE2
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 07:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232975AbiLUGeL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 01:34:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiLUGeJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 01:34:09 -0500
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE3ED1D65F;
        Tue, 20 Dec 2022 22:34:07 -0800 (PST)
Received: by mail-ej1-f50.google.com with SMTP id ud5so34527506ejc.4;
        Tue, 20 Dec 2022 22:34:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qHXdqGVAp6xwcwrdhEP2uqQblBxftTVuobuaAuqc5J4=;
        b=ocJxvoWl7iCQ8ULNtSwDIZHlWhWscS0m87qWmBGbzxTMUakApt/Zo+SiLr3ghA0AzE
         jnkJrffPVb4f/W1wszpQh8174sFosnwNPv3IBfwgJhroozanSmiYXrvDbdgtLc63ba5/
         eAf7AfgLsMw69/0XuaF/iJXWWshw4X4apm8jWTWuoC21TqLKZflUYyQ14Dmti7ahAqld
         vvajfdaUjGCbZ8XhCNaCK5up4w2uqIu/VIKqdwOOlEfqD3F7g2xF/Gso3h1IQGcXV8dY
         hUFF6sJD2YkM5IaLBufuAkxskbuTn73/lOsWgZXlxXJ/ADytLro55sCgIU0lzZHNjvrI
         1KTg==
X-Gm-Message-State: AFqh2kqz7TP8lWcP4/QlDoZXP4cWDTfB3a/zZxAh9hYfRkjIxCzXjSLC
        Uo9ZdxDOBCZqYo9Nd4dwYs8=
X-Google-Smtp-Source: AMrXdXt4KIa1qLy1tC2/3HRqqjwlebCZpmw7B+2nMiJLXSta5SN0tW51yIKwSwGM4G5nhc39kAGofg==
X-Received: by 2002:a17:906:bcd5:b0:7c0:a49a:1 with SMTP id lw21-20020a170906bcd500b007c0a49a0001mr313872ejb.71.1671604446425;
        Tue, 20 Dec 2022 22:34:06 -0800 (PST)
Received: from [192.168.1.49] (185-219-167-24-static.vivo.cz. [185.219.167.24])
        by smtp.gmail.com with ESMTPSA id b11-20020a1709064d4b00b007c500ac66b2sm6549395ejv.64.2022.12.20.22.34.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Dec 2022 22:34:05 -0800 (PST)
Message-ID: <e3b06c93-1985-a958-871a-bfd73646c38a@kernel.org>
Date:   Wed, 21 Dec 2022 07:34:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 6.1 00/25] 6.1.1-rc1 review
Content-Language: en-US
To:     Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20221219182943.395169070@linuxfoundation.org>
 <20221220150049.GE3748047@roeck-us.net> <Y6HQfwEnw75iajYr@kroah.com>
 <20221220161135.GA1983195@roeck-us.net>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20221220161135.GA1983195@roeck-us.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 20. 12. 22, 17:11, Guenter Roeck wrote:
> You probably didn't see any reports on mainline because I didn't report
> the issue there yet. There are so many failures in mainline that it is
> a bit difficult to keep up.

Just heads up, these are breakages in 6.1 known to me:

an io_uring 32bit test crashes the kernel:
https://lore.kernel.org/all/c80c1e3f-800b-dc49-f2f5-acc8ceb34d51@gmail.com/

Fixed in io_uring tree.


bind() of previously bound port no longer fails:
https://lore.kernel.org/all/6b971a4e-c7d8-411e-1f92-fda29b5b2fb9@kernel.org/

No fix available and revert close to impossible.



And most important, mremap() is broken in 6.1, so mostly everything 
fails in some random way:
https://lore.kernel.org/all/20221216163227.24648-1-vbabka@suse.cz/T/#u

Fixed in -mm.

maybe it can help...

-- 
js
suse labs

