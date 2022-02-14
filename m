Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8224B5DAB
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 23:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbiBNWdR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 17:33:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbiBNWdQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 17:33:16 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7280313C27B
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 14:33:08 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id z7so13478236ilb.6
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 14:33:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7+JpYnG7dsjXWhgCGSXoWCrPE3Z+57PO2zgwQkoqQ+g=;
        b=RcTZFftUPNZfWVrqQKgKmKRxGpEP9WYj+Z/tBPMGeOTHe8YYC7VLfegXdNuF0aDC4j
         p8RBZhO/WKYlumi5IvekhupmYVhQfpu9Oi8IUJavGppeD1uuhZyiXEw+iRGWqx+bqWnJ
         SIj6jxY7xnWKkndBZlwul6mylyr3lxUaRXRHc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7+JpYnG7dsjXWhgCGSXoWCrPE3Z+57PO2zgwQkoqQ+g=;
        b=mCwNQtCxlMJThZDvLwx1nfEKw3G5V19Pn2eQeEWGuFrvLDAd+OcjNdOin/JF94G+4a
         yNYcQf/hmaAZXB3CbyA8zezukRA14G5ec7MHXHUAfAtHv24gs98o3+fB8Udtb4J/nHDq
         nxMWu59ohu5ov05DvDsfXyFW9f2SGszaCPIdoLTnRZnb234o1c/l42ydXXzTx17sItz0
         rmFr5x2oQubVaGj5YLFQvz6wUWjY7ixbM25fpHgcAE3lQPmAN8f5fzd8szceT32JPIlL
         NcFa8ZtvhFpKMq31Qdj+Zul5YnhhID+xig78paTrj1VCFWGQeMhgc7dLQtWPex4WFlZu
         cwAw==
X-Gm-Message-State: AOAM5310jroJv+yZa/0XgORSN5gbEfeM2QxZkrimNf+EV0A7OZatfgty
        KMFDIRA2qLrjVDpAsrvNzps/6A==
X-Google-Smtp-Source: ABdhPJzS6bMoQvcJIV+gjneyVdHhXdX5CjmYOQKw/JZcaPSlnCuIxxXlem59xMPd3L+6jrVPME2s2w==
X-Received: by 2002:a05:6e02:1ca4:: with SMTP id x4mr598230ill.262.1644877987869;
        Mon, 14 Feb 2022 14:33:07 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id p5sm16590207ilq.71.2022.02.14.14.33.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Feb 2022 14:33:07 -0800 (PST)
Subject: Re: [PATCH 4.9 00/34] 4.9.302-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220214092445.946718557@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <f8909215-d7d6-456d-2243-f8b791c3e8b6@linuxfoundation.org>
Date:   Mon, 14 Feb 2022 15:33:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220214092445.946718557@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/14/22 2:25 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.302 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.302-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
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
