Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 301654B01F9
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 02:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbiBJBXH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 20:23:07 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:42854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231721AbiBJBXH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 20:23:07 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D46BE765B
        for <stable@vger.kernel.org>; Wed,  9 Feb 2022 17:23:09 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id y5so7478761pfe.4
        for <stable@vger.kernel.org>; Wed, 09 Feb 2022 17:23:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=c2lmvwsE/1j9LC0xH4Ggvv5+MmVn4wXWfeCKMOUehEg=;
        b=NOfTGj6rOKPxHW41PFz28IuY2R3J9m+p9xbES58UR7k0vSzGjA+loqObxYCjY/3yMB
         liFq0h4WfE6d5UTQuihwh2tAFSZa4OTDvO3IMwdHBQMvqaJaUq0I6gFeRl4GGRx8JGYf
         1ldtOlhsyeSaoB77CaAS3cclDME0gC7ms4ue4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c2lmvwsE/1j9LC0xH4Ggvv5+MmVn4wXWfeCKMOUehEg=;
        b=hEAC8nDFOq5BmkX/8EopQepxzM1OmhMWRNxtMo7FzcPgF7mW0SHGpeND/kANLTPD3W
         PQWWDJ9BqmYYJqtkCtSEz4+Hr/c7dOQZIFPZYu34myqMztziWvewAgPt6R+rTkgvF+xW
         EGpSCrsqYKClRCcRnU8RNAEM/S4qIdc8wNKZqEIqjogHB/cR2uwwsaYAw9PyPFljbXDx
         DTQa0Gkk1/7T5f3yyU0h+2s570pG37EHpKadxlUgVUPkcfR4oAhA+M2Dv+PeyoXFf7tp
         S7j83Q2ZWjZLWKAtS9RovpqnSp8MY0sv7TxAPhL7hJHThQCYklS/9PQ4kWrFKCiSOBaq
         fJNQ==
X-Gm-Message-State: AOAM533YMNEtSNA3UhAuOGnKEgcmg2ooRHGlFWe/tyqASbRbXDmGGmC/
        q7vHb7KH2uUzWv4cKLRorb9Ovdm+8YFSBg==
X-Google-Smtp-Source: ABdhPJx9mL2Iuod/IDSEPKulMSxpevKrZcxY8Fyu0OaAkF1WYnlQcQVBbGdEiDlDMfEThNluI3J+xg==
X-Received: by 2002:a05:6602:2d95:: with SMTP id k21mr2586781iow.48.1644454774628;
        Wed, 09 Feb 2022 16:59:34 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id e11sm10339982ioq.41.2022.02.09.16.59.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Feb 2022 16:59:34 -0800 (PST)
Subject: Re: [PATCH 4.19 0/2] 4.19.229-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220209191248.596319706@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <75c46eb1-2496-415d-bc6c-d7d4a6b46c59@linuxfoundation.org>
Date:   Wed, 9 Feb 2022 17:59:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220209191248.596319706@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/9/22 12:14 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.229 release.
> There are 2 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Feb 2022 19:12:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.229-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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
