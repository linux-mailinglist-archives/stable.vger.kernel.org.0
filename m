Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 719B24D0C3C
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 00:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343962AbiCGXtZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 18:49:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343968AbiCGXtX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 18:49:23 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E54C65F92
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 15:48:28 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id b16so4733262ioz.3
        for <stable@vger.kernel.org>; Mon, 07 Mar 2022 15:48:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ERXt6CUpm+UfWK+k5jw+y0nLa6vZNQvwT3UDhqHsVRw=;
        b=C8UZoDU7n26V1ijNLN6u+qg3qcbKVFqnqlOa/ecWxyZ+CkaIB/vPoZbVYd/8JuNbcg
         neNR6fEW1AMvTMiPbxB3gUJtQZGwyEDnPIk+1OlnGDRzJoWPDSrd/2TFtLZ40+Cp2MZu
         XRPmnqGi1gy08PmoaV8WZvaXOn3da4sj8iR5o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ERXt6CUpm+UfWK+k5jw+y0nLa6vZNQvwT3UDhqHsVRw=;
        b=DZuO98arNFN1NvppAZVEMlWnjOydDaNdyzIFgPzpybyYpYyoNJDXDqlw69l2b/hnrb
         XRXaOJQeNZEVmMQ2/poGKKoqpm3ZE7/k1DGaxay8uMX+TxsiZDlUo7SV8skb8H1mpNXY
         qGRz6zv2WMNFoQLGg3fh8tl8336siEQUflyUepO+/8QGV6N57uMDwFcpLGjNaGxUZp2U
         pNPgfzpvDu7hYJ1WVvzgB4h5R7QuvDPKVZ6ViGsgSeKKNDkgwLpPVBNo+NGhbIFJPG5W
         Sx25uaF8N9B1QyTLJlb4HbUXXIy2jf3O0I6QL3brxXxS8Ti11bNDlQpazmkguYXHrYUp
         5APQ==
X-Gm-Message-State: AOAM531//SnuZC/YetqLF+LKA4fHf/isWGuj24J/OlDefxKEEOsKDvq1
        NyOM97bNLKfiB1MgE70htH+HgQ==
X-Google-Smtp-Source: ABdhPJwg5UauQYGLy2p5t+kDAr3ODZdL/eT7yKpoa40T4JtRFXJv0qKGq5A0mCHWYD0+jQN5Lc7IxQ==
X-Received: by 2002:a02:cf90:0:b0:314:8eca:9f8a with SMTP id w16-20020a02cf90000000b003148eca9f8amr13636052jar.302.1646696908289;
        Mon, 07 Mar 2022 15:48:28 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id h28-20020a056e021d9c00b002c64c557eaasm1477437ila.12.2022.03.07.15.48.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Mar 2022 15:48:27 -0800 (PST)
Subject: Re: [PATCH 5.10 000/104] 5.10.104-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220307162142.066663718@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <a5872f74-431c-e48c-ecc6-7e4f5060b2db@linuxfoundation.org>
Date:   Mon, 7 Mar 2022 16:48:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220307162142.066663718@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/7/22 9:28 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.104 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Mar 2022 16:21:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.104-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
