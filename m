Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0750D57C4CE
	for <lists+stable@lfdr.de>; Thu, 21 Jul 2022 08:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiGUG6x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jul 2022 02:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbiGUG6w (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jul 2022 02:58:52 -0400
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C4A785BE;
        Wed, 20 Jul 2022 23:58:51 -0700 (PDT)
Received: by mail-ej1-f41.google.com with SMTP id bp15so1544901ejb.6;
        Wed, 20 Jul 2022 23:58:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=9tlGTK9i++dWJiBJl2NtyWwbbZeViBOzFzVVS3j9kv8=;
        b=BiYznXWQ0EKwcoWpAOWR9OdYvp3uR6/dA2/ojd4+YWOceKRk/LoTLf2R7kn0jEuoeW
         lazG0TIkiAj6yVJaJK1XHzO5amEC8lby/gc7QtRI0kFzozIx+uWVT0XIUTc1rRxU59u0
         FzJo0vBUIbffR6ShUGs/CgT18z7aA4yJqEk7NhMrPV52gIVHXiLCdlvTq493YnUJYmOV
         +WbwcBekezqGHbAc1jraLPHj18nfb9yhbEVuyiXe+3ciAXY97UWsnx/o/Osze3isTFGQ
         sHiKxuTDMXhj7faCqxuX1bEV0d4mSxgLsYTHq+MaIhVKow6jqOny/a/yTZQO7VshOO7x
         SdzA==
X-Gm-Message-State: AJIora/jULdTFZz1cmEc0Lx+hHMzZkk0Q3fiMpP5f0R6ae6bAu+4NyCx
        fKwIkhzcUXicD8KDcyWOPA0eyRXkFJveMA==
X-Google-Smtp-Source: AGRyM1tdIj+Bgw8P/l4EN6+8EHSWf8wtfhKjR2YTggYx5lQWhY3Sifj5FIn3jfScDEZ0DCQeMPhPiQ==
X-Received: by 2002:a17:907:1dca:b0:72b:3cb2:81f7 with SMTP id og10-20020a1709071dca00b0072b3cb281f7mr36972155ejc.567.1658386729989;
        Wed, 20 Jul 2022 23:58:49 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id t8-20020aa7db08000000b0043bba84ded6sm489560eds.92.2022.07.20.23.58.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jul 2022 23:58:48 -0700 (PDT)
Message-ID: <9d2eaa61-17f6-1c26-b4a5-e615935d1625@kernel.org>
Date:   Thu, 21 Jul 2022 08:58:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.18 000/231] 5.18.13-rc1 review
Content-Language: en-US
From:   Jiri Slaby <jirislaby@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Justin Forbes <jforbes@fedoraproject.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Slade Watkins <slade@sladewatkins.com>,
        John Harrison <John.C.Harrison@intel.com>,
        Tejas Upadhyay <tejas.upadhyay@intel.com>,
        Anusha Srivatsa <anusha.srivatsa@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
References: <20220719114714.247441733@linuxfoundation.org>
 <CA+G9fYsCL48P5zFMKUxoJ-1vwUJSWhcn17rUx=1rxOdzdw_Mmg@mail.gmail.com>
 <CAHk-=wjo-u8=yJQJQnaP41FkQw7we9A-zJH3UELx5x_1ynPDfw@mail.gmail.com>
 <YtgvLUMuz+1zpQHR@fedora64.linuxtx.org>
 <CAHk-=wiu=yk=3xzXk18o5yU6v1wn27rcrOD=vmKm_aLNz=zJ+w@mail.gmail.com>
 <6cb8a9c9-d256-5db2-e352-e8de1165950c@kernel.org>
 <bb2516b5-8dd3-3223-0bdc-809e51311347@kernel.org>
In-Reply-To: <bb2516b5-8dd3-3223-0bdc-809e51311347@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21. 07. 22, 8:05, Jiri Slaby wrote:
> Thinking about it, that's likely the reason I'm not seeing any failures 
> -- I still carry all the retbleed patches on the top of stable. So while 

Confirmed. So I assume this gets fixed once the rest of retbleed patches 
is dropped from 5.18.13-rc1.

regards,
-- 
js
