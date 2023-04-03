Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B21E06D54F6
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 00:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233735AbjDCWyS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 18:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233707AbjDCWyR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 18:54:17 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 649F3128
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 15:54:16 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id e9e14a558f8ab-3261b76b17aso954165ab.0
        for <stable@vger.kernel.org>; Mon, 03 Apr 2023 15:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1680562456;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jIhDiEHT8vBLSgJz/+XNr8eL1bJEUN3iw88C4GMTz0s=;
        b=PQ0p8wS6Nwk3xHbBmtH666NkDSW30LA/F74tXJP718sClo8O+dpTw5sA7pe39zRXeT
         HNnsA94K1luPRe9TU4iwJU1aBpa34TcXeFCHNt0fJvqKZd5upArksnlA8WLML6Ahqmgc
         5t9LAxdafiqRkje4EJVduu7x9oB7JRscEAQuU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680562456;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jIhDiEHT8vBLSgJz/+XNr8eL1bJEUN3iw88C4GMTz0s=;
        b=HBw9lobccK+KpOfhWsp4LdcQHHbE7EJGMlxUn0QP1ewZLtUCG6T5Dsndd6pBwlQsjh
         sOGJHJmWynkcgr5GjNRIqXduGosGhz2WxI1XmIEO7T9Iw7rj+Z49Ir/NILAfPX5v2r2m
         lL1qYagEEmCvr9fBmogUieoIUj7sh+vAZw5gwgfH6Lq7YQel0kpUx6szC7rBLvIe9nvQ
         zAI/EGFtdxrvYYKb4XUpGlvC/BPDLNKDsOBBbYc/A15jY0/aEOeavSahj2kir1MMe/MO
         vjvmHJ+wFfBqz4z+eqmm3ffMRJdntpy+3AK/o6NDn+CYVhoskcOeF+ReEFm21ru1Z9IV
         1KWg==
X-Gm-Message-State: AAQBX9c63pxfk/xoWwhXz+2CQSNjgg282M1dr81OE3Fn24lPSdvDC1vP
        JBg0O+PoLjS2xOHmM5zIwn7/nA==
X-Google-Smtp-Source: AKy350bN5LBonI+2ny5eXAvaT9NhmbNkQHrd4vj6avV+5ATh7QMcNLJTf74jOSVFOB4+8D+u+QbRtQ==
X-Received: by 2002:a92:a80b:0:b0:326:3b2e:95b1 with SMTP id o11-20020a92a80b000000b003263b2e95b1mr411645ilh.2.1680562455741;
        Mon, 03 Apr 2023 15:54:15 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id a7-20020a056e02120700b00315785bfabfsm2946187ilq.47.2023.04.03.15.54.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Apr 2023 15:54:15 -0700 (PDT)
Message-ID: <ad4520ec-6791-630a-7884-67f723266714@linuxfoundation.org>
Date:   Mon, 3 Apr 2023 16:54:14 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 6.1 000/181] 6.1.23-rc1 review
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
References: <20230403140415.090615502@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/3/23 08:07, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.23 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.23-rc1.gz
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
