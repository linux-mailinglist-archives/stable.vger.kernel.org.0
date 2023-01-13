Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7A2668860
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 01:27:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231962AbjAMA1l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 19:27:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231718AbjAMA1j (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 19:27:39 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBC15140D2
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 16:27:37 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id i70so637322ioa.12
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 16:27:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1GucQ7IC2vs1Pp3LSSYYnizzJcFER36SWu2dsnAe2xY=;
        b=cWrv22mkJqX9J+d6nUQvIN2mIMf7UmYwe3PoTKLngPDf0qrBbZrDjBSakwNv3I/vYi
         tGRhtbFPVt4CBD3IQhffOemqgdqIXbsDHoDroZgEfiad3o3tkSTH5iTyCKpaZEE/rsSd
         NbmB6AwzmBgEzzt7eDVxU4vCK7+xK++zca/0U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1GucQ7IC2vs1Pp3LSSYYnizzJcFER36SWu2dsnAe2xY=;
        b=kbhfaU/rXfnr+W2iVcobydNOusCHl8ZXrTuzjGPyEPk5IlrnSHK9osjG4ma/6fbug+
         2An1fue6+pa17GzvkRUvRL2B3rIeoCWeEUFMNsfO2gjTHvrUn9gHldcbK6yqpNDFzKhJ
         HkeoYfwOF4nOgjDBCZq9OApDHj6qjBifp1hCVsk3TqmrtzSVFgtCbW2OWfSye/1sNr58
         jeHXO+ZSY6Pr/Za6jjrvSeemh/aTrnHacd5dcPpTJklIQ1XTy+w+t655aKy4bZI3h6+C
         DKf6jN54E6dr/s9vNMpaUXTqP7Dgmcf25SnK5NeaAkFM/y2/3DFUJX0rIVe8CV4NihZw
         1R6g==
X-Gm-Message-State: AFqh2koQd9J9H3dNWL2yRcsVy6ukTy9LL0OZnwSd8u5t8FaGKijYJbdg
        zZvnCMkzrZpF2qaJBfkzGywu7O8vFQlTV0jJ
X-Google-Smtp-Source: AMrXdXuTDGOoGzU+R8vDvplB1NUrFuoEe6O3G5AkuuM2MqJbjqKDZhBsODiegGWmtuOcoWAYGsPn1Q==
X-Received: by 2002:a05:6602:1cf:b0:6ed:95f:92e7 with SMTP id w15-20020a05660201cf00b006ed095f92e7mr9233757iot.0.1673569657202;
        Thu, 12 Jan 2023 16:27:37 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id c15-20020a02330f000000b0038a6ae38ceasm5997415jae.26.2023.01.12.16.27.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jan 2023 16:27:36 -0800 (PST)
Message-ID: <ae0e974d-1ea8-ddd1-85a2-10e9679854c4@linuxfoundation.org>
Date:   Thu, 12 Jan 2023 17:27:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.1 00/10] 6.1.6-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20230112135326.981869724@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230112135326.981869724@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/12/23 06:56, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.6 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 14 Jan 2023 13:53:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
