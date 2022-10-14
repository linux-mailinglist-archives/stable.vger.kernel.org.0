Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7E25FE6F1
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 04:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiJNCYU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 22:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiJNCYT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 22:24:19 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFFB5EA692;
        Thu, 13 Oct 2022 19:24:18 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id i3so3606166pfc.11;
        Thu, 13 Oct 2022 19:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fd5dEtIK9gdlQcJsAgxFpuieDtoEahg2tk3oqJXbQag=;
        b=WIlLjg2g+T2t/iFbG7REjo2RVCkfETFGJS9zZzGYEQYZvWkNU++yKB4wvZM6pUIqHe
         Tllwv32p4i1zrvaJmUoUB73pgi8Sh1aMswRdtQ5RTIqMfgKzlPnI05oCH/NKfpK/aDQy
         n2oVNfc8uGiYkX1VKwag/ifT2IXimaQI6VF4DuA9AlUWZeLJp30EH708knLvckreylKJ
         nCjA+J5c/aH161e7l84Zm9hhPuDjDGij3fNLPjGIGjrzbkYmMlqQe37Rmr8kPE82+ffS
         FAc954D/2VGJeNc5lFfmdmENoub3v2bUjJN9hX+ETafBVgR89WvltCcehVxiKou9wp2M
         3NGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fd5dEtIK9gdlQcJsAgxFpuieDtoEahg2tk3oqJXbQag=;
        b=nKD1MXge6CWGpwLT0yf0f2QAnkEB4LE6NRGjpJ17G+iv62YTGhpF1/U4a34T4VgThA
         O/X32Yq9oxhvoyv0qYi/3fwic8qJUcfDvks5Gx/Z9TmZo15Cd7avx9EPJXMR2oEwFTjc
         mLfaKeViRcjUgsnxXXifJpZ+iACAsVo8T5rM0ZAWszFU1zvanJF2ZotodpfTShlmfsaU
         JwprXJr8O9Ud1AfIHEm1wMW8M8rm7PEV+/KQwGn2rfBf4szXuZc2cVGw7Phr8kWtDRrW
         XY1038UvyL93r2496bY6YdIJNU1GzlvmwFW4vGKlH0KzUPWfQtpmoLx6kbC8t2sn3fDi
         kwkQ==
X-Gm-Message-State: ACrzQf0HU3AicFuxuDUJbFMin9ITQ4PUihOC2CuHGJGvYUiYXuO7WwEi
        uYNifa3RyfnWkhZJjyX4hr0=
X-Google-Smtp-Source: AMsMyM5iggzZUwiUbEL1aA7rw8qgc2VshWkNw+YcVrWsP4hiPc3fe2X4Wl09lqKaloIkLEzBalK9Rg==
X-Received: by 2002:a05:6a00:cce:b0:565:cbe0:16c6 with SMTP id b14-20020a056a000cce00b00565cbe016c6mr2637694pfv.56.1665714258307;
        Thu, 13 Oct 2022 19:24:18 -0700 (PDT)
Received: from [192.168.43.80] (subs03-180-214-233-5.three.co.id. [180.214.233.5])
        by smtp.gmail.com with ESMTPSA id o125-20020a62cd83000000b00561c179e17dsm384483pfg.76.2022.10.13.19.24.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Oct 2022 19:24:17 -0700 (PDT)
Message-ID: <130adb69-ff37-51fd-26a2-674ab78ff044@gmail.com>
Date:   Fri, 14 Oct 2022 09:24:11 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH] Documentation: process: update the list of current LTS
To:     Nick Desaulniers <ndesaulniers@google.com>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Sasha Levin <sashal@kernel.org>
References: <20221013183414.667316-1-ndesaulniers@google.com>
Content-Language: en-US
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20221013183414.667316-1-ndesaulniers@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/14/22 01:34, Nick Desaulniers wrote:
> 3.16 was EOL in 2020.
> 4.4 was EOL in 2022.
> 
> 5.10 is new in 2020.
> 5.15 is new in 2021.
> 
> We'll see if 6.1 becomes LTS in 2022.
> 

I think the table should be keep updated whenever new LTS is announced
and oldest LTS become EOL, to be on par with kernel.org homepage.

-- 
An old man doll... just what I always wanted! - Clara

