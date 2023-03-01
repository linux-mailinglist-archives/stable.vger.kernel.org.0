Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5075A6A6542
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 03:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbjCACFY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Feb 2023 21:05:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjCACFX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Feb 2023 21:05:23 -0500
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F25992F7A7
        for <stable@vger.kernel.org>; Tue, 28 Feb 2023 18:05:19 -0800 (PST)
Received: by mail-qt1-x831.google.com with SMTP id l18so11743246qtp.1
        for <stable@vger.kernel.org>; Tue, 28 Feb 2023 18:05:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TRjVj/Q9CuAHhxFzkvoIbUrL5/4PqItnxLip/wdIyLY=;
        b=QKy1Pi9vufh5kuJhj7chiF0r1VdnM9l0V9AnDDv8maynJSleXR94/5jeKdGIHhZZFM
         gdNZQtxggcXF0+wDO0TEJDY9922HjGRavvwZw/UtA8O+ox3rPsg8o0NnjZQVu6WLZ+6N
         Y5e7iEhkrPPNu069+Z0G7sItZ7r5ROgIUuh0nG/zSHYW4vvBZXJM18pCgbdZwkajpu18
         tudaothi8YpweyE/g/lpNa4z1CoheOtrrkh5g+hQVVZA1yDLhVuapLepe1LsqL0CAkQe
         l4/QQ7SN87jYBMqWpygUZeLV3QmKfZXQ5OMZ0nrrmFPzMxuP0hwnsmT2wZQS2gBuC4Bp
         m9ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TRjVj/Q9CuAHhxFzkvoIbUrL5/4PqItnxLip/wdIyLY=;
        b=5hSnBhG07lvXzlZK5suMUjoIJ0fydufJr0aS74ZDGDCq6stZ/INBqXyUwds2TO3C3/
         +4y3bwDAtvsXREGnHNWC83S4aaE6gi/jax5kSeurbHN/3EhTIZ7XOpMEJ8f7O61qIBzo
         XA9E0wH5d2sjqKaUX+dzxQmrzNYJJX1IaJpyN3tWOO/uw4PGRSXkAgdGMQIBsb5R8mOR
         u1aW6h0MFLsFiRrAPiIEcVgRcKw++pOoUIgkE0Yc3EgK910wmEw48OFCqdi2+Zk4KinH
         EZDDkvH742e0tcdOSLmR7dGsmgJoithWcOJ8/n7sFvAR5Up56sNOhsewGXw2NFAB9PPt
         CsXA==
X-Gm-Message-State: AO0yUKWVoKCrv1nI56yyBxV562QOydEXSKeN+pzz/BkZyHZy+1DaemYg
        hRPtVsI0PCbk6s/Z878WK6xjmw==
X-Google-Smtp-Source: AK7set8kJFy9c93zY5Ha1M3Gbk6fwg1oP7ZowNJCK3vHB0c3OxBT2OVt/2LkxQb3R2xFpnpV7d2dhw==
X-Received: by 2002:ac8:5f94:0:b0:3bf:d1c6:d375 with SMTP id j20-20020ac85f94000000b003bfd1c6d375mr8623747qta.36.1677636318964;
        Tue, 28 Feb 2023 18:05:18 -0800 (PST)
Received: from ghost.leviathan.sladewatkins.net (pool-108-44-32-49.albyny.fios.verizon.net. [108.44.32.49])
        by smtp.gmail.com with ESMTPSA id a2-20020ac80002000000b003b9bca1e093sm7438872qtg.27.2023.02.28.18.05.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Feb 2023 18:05:18 -0800 (PST)
Message-ID: <8caf1c23-54e7-6357-29b0-4f7ddf8f16d2@sladewatkins.net>
Date:   Tue, 28 Feb 2023 21:05:16 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: AUTOSEL process
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
References: <Y/y70zJj4kjOVfXa@sashalap> <Y/zswi91axMN8OsA@sol.localdomain>
 <Y/zxKOBTLXFjSVyI@sol.localdomain> <Y/0U8tpNkgePu00M@sashalap>
 <Y/0i5pGYjrVw59Kk@gmail.com> <Y/0wMiOwoeLcFefc@sashalap>
 <Y/1LlA5WogOAPBNv@gmail.com> <Y/1em4ygHgSjIYau@sashalap>
 <Y/136zpJSWx96YEe@sol.localdomain>
 <CAOQ4uxietbePiWgw8aOZiZ+YT=5vYVdPH=ChnBkU_KCaHGv+1w@mail.gmail.com>
 <Y/3lV0P9h+FxmjyF@kroah.com>
From:   Slade Watkins <srw@sladewatkins.net>
In-Reply-To: <Y/3lV0P9h+FxmjyF@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/28/23 06:28, Greg KH wrote:
>> But just so you know, as a maintainer, you have the option to request that
>> patches to your subsystem will not be selected by AUTOSEL and run your
>> own process to select, test and submit fixes to stable trees.
> 
> Yes, and simply put, that's the answer for any subsystem or maintainer
> that does not want their patches picked using the AUTOSEL tool.
> 
> The problem that the AUTOSEL tool is solving is real, we have whole
> major subsystems where no patches are ever marked as "for stable" and so
> real bugfixes are never backported properly.

Yeah, I agree.

And I'm throwing this out here [after having time to think about it due to an
internet outage], but, would Cc'ing the patch's relevant subsystems on AUTOSEL
emails help? This was sort of mentioned in this email[1] from Eric, and I
think it _could_ help? I don't know, just something that crossed my mind earlier.

> 
> In an ideal world, all maintainers would properly mark their patches for
> stable backporting (as documented for the past 15+ years, with a cc:
> stable tag, NOT a Fixes: tag), but we do not live in that world, and
> hence, the need for the AUTOSEL work.

(I wish we did... Oh well.)

[1] https://lore.kernel.org/stable/Y%2Fzswi91axMN8OsA@sol.localdomain/

-- Slade
