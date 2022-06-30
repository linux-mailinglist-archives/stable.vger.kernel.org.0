Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8E565626FD
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 01:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232741AbiF3XUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 19:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232345AbiF3XUI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 19:20:08 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 017165A2D4
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 16:19:43 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id h20so348960ilj.13
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 16:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/HzZbEds0mt2ywwYDR/+hVE8OwI8yDRJqbVj3xtnZaw=;
        b=Y04EtYhYBrXOpp/2Ofyuk82PjisL8G6IB4eo2g661vr05t+2uSrdnF9FDXc1OWbCB/
         fZFSZiWfJwffsOffvtNLQhJIeeagx2D8T0KD1pkImkfYb9YHYHW5b5WoWAANAeWD1/wR
         ZXjucAlAu6YrU0/LfTy6K/bNrLm2F/ieX+kg4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/HzZbEds0mt2ywwYDR/+hVE8OwI8yDRJqbVj3xtnZaw=;
        b=DuJfTgq7o0N5OhUX1QqxGJB/113AXTXmOZCbUPZLSxwncAj/eFIujOrKLt8XwKJse7
         xkiIfbgJeRtQDOiT/6ipUPp4pECx9TuaJB2rCnxGHITOn3zG7HqUn1RRbOTRqZDWHr1W
         pxXmqyLpRIK++7vgHL0vRiu1uZf7lMAcHOmo8zXK78kTkjuVvtrVMqHmef/N5OQTgJtU
         9bAiPiLtczky7CgTLv5aw59XeAbf8ITccG69Nrpo3RbpKpyYUJCaNHLPItXqdlGZ5H/M
         ym2+mwXlWJKjF57ene3o3wdJIU05Mtie0+8spkW+GauQEcqheUD8kHyhARvGu9hR7dOV
         4HqA==
X-Gm-Message-State: AJIora+2J1gBW5nuERVsjs/VWlf6KlK1mQvJ3qqBK/MMnI0Tl2QVUIln
        ipdT9J42WgXWFfu7YMHzqjN80Q==
X-Google-Smtp-Source: AGRyM1tshibblbV2b1WM9XJxUaxipxM1fXR7m1OemCnUBvM5UheRPSanELDMPXxLD6CyM9W20F699A==
X-Received: by 2002:a92:1908:0:b0:2d9:2beb:bc61 with SMTP id 8-20020a921908000000b002d92bebbc61mr6705817ilz.245.1656631182328;
        Thu, 30 Jun 2022 16:19:42 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id o18-20020a02cc32000000b00339df371fb4sm1892990jap.123.2022.06.30.16.19.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 16:19:41 -0700 (PDT)
Subject: Re: [PATCH 5.18 0/6] 5.18.9-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220630133230.239507521@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <e937900b-a030-86de-0d09-ddce61a1661c@linuxfoundation.org>
Date:   Thu, 30 Jun 2022 17:19:41 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220630133230.239507521@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/30/22 7:47 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.9 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Jul 2022 13:32:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
