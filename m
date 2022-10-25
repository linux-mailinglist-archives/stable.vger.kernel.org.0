Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 120E760C281
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 06:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbiJYEMy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 00:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbiJYEMx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 00:12:53 -0400
Received: from 001.mia.mailroute.net (001.mia.mailroute.net [199.89.3.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68844130D4D
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 21:12:49 -0700 (PDT)
Received: from localhost (001.mia.mailroute.net [127.0.0.1])
        by 001.mia.mailroute.net (Postfix) with ESMTP id 4MxJSc2zpqz2KYJR
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 04:12:48 +0000 (UTC)
X-Virus-Scanned: by MailRoute
Received: from 001.mia.mailroute.net ([199.89.3.4])
        by localhost (001.mia [127.0.0.1]) (mroute_mailscanner, port 10026)
        with LMTP id yzuDkZ-aNIuS for <stable@vger.kernel.org>;
        Tue, 25 Oct 2022 04:12:46 +0000 (UTC)
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by 001.mia.mailroute.net (Postfix) with ESMTPS id 4MxJSZ4VDXz2KY9r
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 04:12:46 +0000 (UTC)
Received: by mail-qk1-f197.google.com with SMTP id h8-20020a05620a284800b006b5c98f09fbso10729238qkp.21
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 21:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eRZeax8ZK3CS3LfPjBqPBNDHjw2kJt26ab1K5VUm8bA=;
        b=nREHJ5Tq+t172QmoJBFfosI6flBmUyEHHBG2mFDgFfJvZRFrcFivR25ipqmllRoT5C
         LRS1lW+2UJvLbJjtaLpbj0w+vJr2tGQv0Vm1CZ1uOFU6tnZ38r295dSwbVVvmQetJD6S
         nakgxCi76EvVI92IRS653GoR+EwKEEDwImqL7Sx3yTWl2dW4SOn8arwItJuJVJ/S0nGO
         35npwzYloDjS15Ja80RwrHPd9GoJeUWA1Qj0Jh9VveGgtXBB50GNK+dHt/EZjuWGleov
         VI7EqIl3IQvpvN/kUZQ+TXoErk2cuU7NwqO5qdOcFxlHSlKeUX3Woc70WYYiBQh8Qf52
         NMsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eRZeax8ZK3CS3LfPjBqPBNDHjw2kJt26ab1K5VUm8bA=;
        b=jifq3oK3HuYJfdRoy8jsytVHsZ9XZaDD3zy27a9ogUeiMcfJkw6774gd5Dli42wE0j
         aw6AVleaoDptNU/ws8IMsgkc9nMs6VDWqLMKGN+bBd5X5zBUntrfWIaKo9wjhAYNNH4V
         SYmR/A9lAhMzHNiOBEDXsF+uuv2qa4HUNAYqqDY9X0qf8mbMQX//lmaJ3Z6hClX5eW++
         5wKa8/TK5wDEx+zQ9EUpYG1cbm/HA5UVvagNaJAwwNKHRddWx84DNhPyITiBJhmofTpO
         tYGumf1SF2BZ/zNC9iXrpxmGyQzJ771KTR50aB6m02n1aJ6dS1YVlNR1yZhCd9+4QAHm
         OIpA==
X-Gm-Message-State: ACrzQf1vQDzMAmbNr/va2DXPCPt22X6bQDlg6taDa953wR2IyBUrG4fS
        JSyofS0dsRgDvLJd6BtWn9vqvF+L/Lb73A75OJOkk8lwPgtEqiLdcC8qNN04JLjk+jE3Q3fxXUF
        U/PiGfYZqgy3vZEpce0vX5r7Kbf9ytkY=
X-Received: by 2002:a05:620a:2947:b0:6ee:88c9:bcdc with SMTP id n7-20020a05620a294700b006ee88c9bcdcmr25981204qkp.143.1666671165244;
        Mon, 24 Oct 2022 21:12:45 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6ekGR/WqLv3RSc7wYas2t4wRYPXMGljMeYPoCmQ7VvtBVwVo608L81PV4ys7w7WMkk/jXijA==
X-Received: by 2002:a05:620a:2947:b0:6ee:88c9:bcdc with SMTP id n7-20020a05620a294700b006ee88c9bcdcmr25981195qkp.143.1666671165031;
        Mon, 24 Oct 2022 21:12:45 -0700 (PDT)
Received: from [192.168.1.39] (pool-108-4-135-94.albyny.fios.verizon.net. [108.4.135.94])
        by smtp.gmail.com with ESMTPSA id dt47-20020a05620a47af00b006ee96d82188sm1384931qkb.1.2022.10.24.21.12.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Oct 2022 21:12:44 -0700 (PDT)
Message-ID: <b190538b-3b82-d3e7-664b-550318a61e66@sladewatkins.net>
Date:   Tue, 25 Oct 2022 00:12:43 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 5.15 000/530] 5.15.75-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com
References: <20221024113044.976326639@linuxfoundation.org>
From:   Slade Watkins <srw@sladewatkins.net>
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/24/22 7:25 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.75 release.
> There are 530 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Oct 2022 11:29:24 +0000.
> Anything received after that time might be too late.

5.15.75-rc1 compiled and booted on my x86_64 test system. No errors or
regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

All the best,

-srw
