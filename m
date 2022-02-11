Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89BEE4B2D06
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 19:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352711AbiBKSfi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 13:35:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240176AbiBKSfi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 13:35:38 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E39B894
        for <stable@vger.kernel.org>; Fri, 11 Feb 2022 10:35:33 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id y84so12566456iof.0
        for <stable@vger.kernel.org>; Fri, 11 Feb 2022 10:35:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=YG2mtDCQAmHKIGQN1Eu7bQuJAuyZkXd1RbbixtMnArE=;
        b=KOwmSeAWLyMDR7YExr/Dy/eKVXJTND6Ojnfwm5cx9XKmCBbkZ0Nj1/71HLaREhxAyn
         wtIg72FetE4ch+dq3mG7O+H0c4VieC6iAejR3rP3um78qF/zuZeE7nkdZK9lVy05TNqU
         lkJ/T2n4vo58bZ8zGjF6Aw/3DtoB1Pe16Fty0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YG2mtDCQAmHKIGQN1Eu7bQuJAuyZkXd1RbbixtMnArE=;
        b=tqZgAAAP9I/28qZHo0BzgWfsqS/SWFs3PKFcmy84+NU5AnDYi9UOLZDEkYH3jb+OcU
         5b4LP4pl74XmYcU2Oz/aOU396M9joAqK6PItEE6VJCf95JiOP6zc3e+NhtUcvrPBnUUN
         1sTIIUSAJTM1rBtS+5aGveBhFDA+V3Xn6BE2CieUU6MVW5DFnVJ85bLHGtTPz+txkMYk
         xAjpowMC6PsZUoNUmNAFrAPVACbQcLvsV1ChTlOXw2+bEN4cf0GdNCyfkBw0reOMpkqN
         CqCLSxisf5XSOgSAvv4NpaIMf7YntDzfMC/9ilwMwgx97amSG8SzETgTJMV09clCJlGi
         RXcQ==
X-Gm-Message-State: AOAM533aNkX4DTBNERJ/7QxzxhHnW0oaKQPENqfkdQl3NneeAMin6IoV
        lbInMjVnSBboA12sXYqtsUNuGA==
X-Google-Smtp-Source: ABdhPJxo8568LcN9ktIC1erRyIfVyA5h5BZiiPFtUEu5vEdqDW6uP7K/u9v2gkw0Pw07hNEs2PaDVg==
X-Received: by 2002:a05:6602:2a4b:: with SMTP id k11mr1527598iov.136.1644604533363;
        Fri, 11 Feb 2022 10:35:33 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id s18sm14450622iov.5.2022.02.11.10.35.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Feb 2022 10:35:33 -0800 (PST)
Subject: Re: + selftests-exec-add-non-regular-to-test_gen_progs.patch added to
 -mm tree
To:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        keescook@chromium.org, ebiederm@xmission.com, bot@kernelci.org,
        usama.anjum@collabora.com, Shuah Khan <skhan@linuxfoundation.org>
References: <20220211182612.B562CC340ED@smtp.kernel.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <9130ef69-02eb-1a46-970c-0ce6fa6a68ad@linuxfoundation.org>
Date:   Fri, 11 Feb 2022 11:35:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220211182612.B562CC340ED@smtp.kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/11/22 11:26 AM, Andrew Morton wrote:
> The patch titled
>       Subject: selftests/exec: add non-regular to TEST_GEN_PROGS
> has been added to the -mm tree.  Its filename is
>       selftests-exec-add-non-regular-to-test_gen_progs.patch
> 
> This patch should soon appear at
>      https://ozlabs.org/~akpm/mmots/broken-out/selftests-exec-add-non-regular-to-test_gen_progs.patch
> and later at
>      https://ozlabs.org/~akpm/mmotm/broken-out/selftests-exec-add-non-regular-to-test_gen_progs.patch
> 
> Before you just go and hit "reply", please:
>     a) Consider who else should be cc'ed
>     b) Prefer to cc a suitable mailing list as well
>     c) Ideally: find the original patch on the mailing list and do a
>        reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
> 
> ------------------------------------------------------
> From: Muhammad Usama Anjum <usama.anjum@collabora.com>
> Subject: selftests/exec: add non-regular to TEST_GEN_PROGS
> 
> non-regular file needs to be compiled and then copied to the output
> directory.  Remove it from TEST_PROGS and add it to TEST_GEN_PROGS.  This
> removes error thrown by rsync when non-regular object isn't found:
> 

Andrew,

I pushed this to linux-kselftest fixes for rc5. I can go drop it now,
and you can take this through yours.

thanks,
-- Shuah

