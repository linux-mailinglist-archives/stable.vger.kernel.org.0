Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42D094D4035
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 05:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239360AbiCJEUX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 23:20:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234834AbiCJEUV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 23:20:21 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE4C93A70A;
        Wed,  9 Mar 2022 20:19:21 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id e3so4016257pjm.5;
        Wed, 09 Mar 2022 20:19:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=CLW7Cmsp9AO02nYhc7psjKRG3rDi0YIcKLCQA4Dz/NA=;
        b=E9HIhmZhzD1C/Oc7+g2fnWP48OKFuIjZV0GbABVj4ihwW5yKiYVKer45+cSHu6evfF
         CDmn/e54dOwe7En2q3vPEGENdoRuPBc3o8t2jY/G3r6Omvs+IMgL+MwJ6tX9pQLnCM48
         BwkMqLnSUhPzXIRzWLZg6AJ9DN+xr55cKMng6g2TwE47ynIvs5MQwCsn157cwrC9OfG9
         G03c7YtSdWRQredHjWXwT277i/kwpxwo7Fuob2rCD/1YQGDtG5slc1tWhqmEiBdcg0kH
         bYf178bgd6VPq2wqr1Fnj2BtASJv0sKtNZRGNp3Ty4sy7yxUFQZmdJLWrL226tLWgW+N
         Pt9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=CLW7Cmsp9AO02nYhc7psjKRG3rDi0YIcKLCQA4Dz/NA=;
        b=u67zq7nNqbPEw5kMwE1C8G68Qd0DRcZVlqRrLnyhC+lqTVr5qlnvD0mm1zsOZM5sMY
         sPKt3P84bYcERAchcHsOD3m3pClMu/9SzMA1rd4nY0LkiSfYb58naq3NaOm5fmLEQ6Le
         wH2C9wUMFTILs/drNhMHrysjNlCWImUImcDdTCstCLmfBGXQP/0VHS0O7IRtrI2Hf1EY
         JtTTKclzkB029+DUp9Vh+HrWf6PEe85KNeAoa3Mnji830EqPSmosE0xz5K2DJiOuvupr
         E7DhBUGZlXiV5oXBNiyIfGrPCTZro1oVHZ/C/LKY3DealCzNXhOb7N0i6xk7oBognI0F
         DD9Q==
X-Gm-Message-State: AOAM530cP/2mR9ynOyVM8TA8sNhgM5+h5YYgHxTimG38zt+1QFzCYYrq
        sIZPvmMJ5IkGS/5lxxiW6KI=
X-Google-Smtp-Source: ABdhPJz/TWfkKhlhLP8rPyN1to/Spw6SlYjaZU05jEyZtqUEyHnfywp21GyM3fsASd4PDGZlpVhatQ==
X-Received: by 2002:a17:902:cecc:b0:151:eadc:998d with SMTP id d12-20020a170902cecc00b00151eadc998dmr3203679plg.62.1646885961045;
        Wed, 09 Mar 2022 20:19:21 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id g13-20020a056a000b8d00b004f75395b2b4sm4867479pfj.55.2022.03.09.20.19.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 20:19:20 -0800 (PST)
Message-ID: <7b53a0f7-0cb7-13a2-078d-dd1662654be3@gmail.com>
Date:   Wed, 9 Mar 2022 20:19:18 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH 5.10 00/43] 5.10.105-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220309155859.239810747@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220309155859.239810747@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/9/2022 7:59 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.105 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Mar 2022 15:58:48 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.105-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
