Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DEAD54ACFC
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 11:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351069AbiFNJKu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 05:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353832AbiFNJKt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 05:10:49 -0400
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E659942A38;
        Tue, 14 Jun 2022 02:10:45 -0700 (PDT)
Received: by mail-wr1-f44.google.com with SMTP id c21so10364250wrb.1;
        Tue, 14 Jun 2022 02:10:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=oqq//sNQTRKFksgXq8/+ru1bUeOh2rtemmad4D/w0ow=;
        b=A3OvpXPt47T3UXdjehTEAqNaT/jsOgFwnaS+OBlPB0BqxaUJkr0GmuiBDRvGoJhDK1
         UtKbYMmpHspmOz6pS1L+sExzkygQgQPnRji0moPyJMjNI/hZQg0yLEFQWIJ+h9pw7Xmc
         x6behffJ0qRF/V0p2fBIHjQ7ChIgJTTsm55FQpE1iXTydN5RRQh7CjBOGyXzz7wsycLk
         lJ9yZOXYo7YjlQGXODO1/n6/QYATP2/mnHWOePlCiH7P/ahwjSYTm6RucYRifiHG5XJk
         XzUptef4SdSNMNEPwFRwAJglp3/9of/c7AvgRUVmMoVpebeCG1KuJFlTR7mO5MdOAGh7
         D7Kg==
X-Gm-Message-State: AJIora8wvvGtd+9U1ZXXGeHS3YSszy+xDXlmHkWDpm1hEBDyBeshl1+/
        qlBEOxd3JEbG2TTl06itSo4=
X-Google-Smtp-Source: AGRyM1vosJxqNeMBdLNP5fYIzkmDB3QHTeVR30D+2ItJMhmRH1aJiWiu/eC15R49D38cStWlTE8Mrg==
X-Received: by 2002:a5d:6daf:0:b0:218:4f53:5810 with SMTP id u15-20020a5d6daf000000b002184f535810mr3875109wrs.43.1655197844334;
        Tue, 14 Jun 2022 02:10:44 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id g7-20020a5d4887000000b002184a3a3641sm11042522wrq.100.2022.06.14.02.10.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 02:10:43 -0700 (PDT)
Message-ID: <db8b5375-1f09-2000-cb83-d939e2018d0f@kernel.org>
Date:   Tue, 14 Jun 2022 11:10:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 5.18 000/343] 5.18.4-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220613181233.078148768@linuxfoundation.org>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20220613181233.078148768@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 13. 06. 22, 20:18, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.4 release.
> There are 343 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Jun 2022 18:11:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.4-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.

openSUSE configs¹⁾ all green.

Tested-by: Jiri Slaby <jirislaby@kernel.org>

¹⁾ armv6hl armv7hl arm64 i386 ppc64 ppc64le riscv64 s390x x86_64

-- 
js
suse labs
