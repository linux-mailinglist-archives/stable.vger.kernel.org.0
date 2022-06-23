Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 068C45589DB
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 22:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbiFWUN5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 16:13:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiFWUN4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 16:13:56 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E411B5253D;
        Thu, 23 Jun 2022 13:13:55 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id q18so174234pld.13;
        Thu, 23 Jun 2022 13:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=/8L+loe/q0oKT/VSQkC4sJ2q8bSMJVMgNJ3tpE0MVRw=;
        b=bgNDjsJHhD7Jt7jSeJqq+BbE1CRzryJmICngF6BWjMfhac5B/vvzMT0Jdt8gviLAnG
         Nz+J1CvUibpAlrlugHykIQTscNxyq/0oTxKWDTN7uFkDUHbOLr68IyY39ag4rk28GNBn
         +wUsNHq9se3djiYmxxjhWx6x29CblN4kfK5Q2byhWXOK2cYSAjlv1mJFTQgvuXdh+WqZ
         xIfDAhr0lW5VOvEYlvO5FRTk5Doj32zwjnRAuacmxpuD2lvd+SvcO75GTBG7FC+Itwdx
         9QEPa7sZcjqGZmLgY6qE7OykDSGPrvbMkxZQYxWCs4QR9dgxPNpDi7noXVQgGeNKfVxx
         TKKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/8L+loe/q0oKT/VSQkC4sJ2q8bSMJVMgNJ3tpE0MVRw=;
        b=lyzurWNBxEF5JrWDfrjgcxHfLR6tzXts9/bt91gdqdxLWNIfL0Pb0P3sbC9IwodiiK
         mBjRqMsy4pQ424skJttg31pfxUoptCwoWtDLq/N6cjbIzlPwxbVch8jNiE/NWedTWIRb
         mnGGu9vltigHUigBUeOyc9K5ZWjDWfIHKUmV3TrJ5/cy84bYWTfqwQVeiXFYDEW07Iuu
         JQJ/+7HkKPKwfp0f5n6H2CIA+O6kVZqb0wUGvVSi5YW7ADe5UPMGSICF17PjlKYCbndB
         blqQSL51kMsN1h0wZaDInIYWtBQ7UyW8TwhEj1WXoo0jNYX3AL1qCm90mOG4jm6N1VBv
         HxFA==
X-Gm-Message-State: AJIora83736cqg6iFYrejhjj5dr4LAr+0qFu7C95MPiR6XdqzRA7R4X0
        eg5lz8FDVQFRNi67Nd65eQCHloLOzqw=
X-Google-Smtp-Source: AGRyM1vxqmSRQEHmnQQ+B2pzLKb5nEpaqUCziy/6ajxNlaCb5rSokxISfhbY19OchkSxdU6Q7+awQQ==
X-Received: by 2002:a17:902:c2ca:b0:168:db72:16a with SMTP id c10-20020a170902c2ca00b00168db72016amr41334471pla.171.1656015235402;
        Thu, 23 Jun 2022 13:13:55 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ez7-20020a17090ae14700b001ec8d191db4sm147380pjb.17.2022.06.23.13.13.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jun 2022 13:13:54 -0700 (PDT)
Message-ID: <831bb649-fa74-8e54-f3f2-499a843d9e88@gmail.com>
Date:   Thu, 23 Jun 2022 13:13:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.10 00/11] 5.10.125-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220623164322.296526800@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220623164322.296526800@linuxfoundation.org>
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

On 6/23/22 09:44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.125 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Jun 2022 16:43:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.125-rc1.gz
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
