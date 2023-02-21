Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3E7A69EB6F
	for <lists+stable@lfdr.de>; Wed, 22 Feb 2023 00:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbjBUXuP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 18:50:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBUXuF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 18:50:05 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA2302E0CF
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 15:50:04 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id b14so2843272ior.1
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 15:50:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1677023404;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1SE3WgBQxvjkYymj/NUhgZ+JAGp+aqj6czJmw/PWko8=;
        b=FP7UZEXoeBE38eoP64poH/FonAGE3ltAyTyFfn1BCoBDuUfkCOWop440HPxadz7Olq
         c46Bkj2hO6cM6aIOKiV/pDIZUGt8qfJrJDHyf5nBgEU5DhzeCc02Qd8ICcTAkMIYiHtu
         Gf4GPidJZPt6eJBSL8JAdSuiLV8312nQlshuI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677023404;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1SE3WgBQxvjkYymj/NUhgZ+JAGp+aqj6czJmw/PWko8=;
        b=j8sgrA2tt5nLcBqB1cdPGr01d+KeedIvVGoIs7Dls378tbiiNWCRIU7yiYkkpbd89S
         qv6bMepMo6yxUeF/X1X5VvkpkwPMfjk9AcJq/7UZkviO9MV0SCZB605lWf9TEeJGZsK5
         iDYZ0PBLL18lvYHgO4RjX0TG3Sn8Nx4N3wRm7ndFgGmMHqI7/6WfpOYUY73Z07WbHSlk
         17y/+3Fh/Ew6/pD4sDK1AwsoSTD4sJc8xepf50UKxwWf8AzPfH59UgvYZwyEWWay3tbL
         avKEeUJzxq5DTBfgOSdMpDEa8Jy0NwCOqVUuOBVpXtJV0Bp8cVQNoFiEclILPZu6d+wW
         f7sA==
X-Gm-Message-State: AO0yUKVdxeIRSKFUguP3eZup9rQvhxooW29Ag3cEvcRANEvKE2KVJ3oT
        KwHdLj+WBCwAGJV63Wf2HIuuzw==
X-Google-Smtp-Source: AK7set9S1jt4zayqTgvWH1NpNpz27f+tc7rbAcPsF0lPV1c4riwA5ed662R9oRRFUaqWS0Yqb4L6aw==
X-Received: by 2002:a5d:9d81:0:b0:719:6a2:99d8 with SMTP id ay1-20020a5d9d81000000b0071906a299d8mr5560871iob.0.1677023404114;
        Tue, 21 Feb 2023 15:50:04 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id e13-20020a5d8acd000000b0074564031d75sm518581iot.2.2023.02.21.15.50.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Feb 2023 15:50:03 -0800 (PST)
Message-ID: <95e2761d-9bd9-836f-36b4-f519d218618d@linuxfoundation.org>
Date:   Tue, 21 Feb 2023 16:50:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.10 00/57] 5.10.169-rc1 review
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
References: <20230220133549.360169435@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230220133549.360169435@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/20/23 06:36, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.169 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.169-rc1.gz
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
