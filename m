Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF916D7D06
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 14:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238051AbjDEM5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 08:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237976AbjDEM4z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 08:56:55 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B72785592;
        Wed,  5 Apr 2023 05:56:54 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id iw3so34318557plb.6;
        Wed, 05 Apr 2023 05:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680699414; x=1683291414;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=udx9X2lCjzzCQSzA8XrrGEAIdcnTSdsgiQjtx2xR2Fw=;
        b=ovV/7dcXowDzEHyzLv8kBeXAQIuwPo6hYla3+48211R3GHIWym2AcnLzPDFV27XA6O
         6YIi70xwop3UeC5cz8w3zhaTxGIxfXj1zArLZwulXV9zXl8wk/kDF1eGzzeypX9oRUgr
         MQ1C8rjxTAlcaoqbKWcrs+vfHmWKCL9UKerlSJ/CPGVirFdcVhu2kKhSKNmPT2Im9RSk
         qeNbpHpx5u0/LcFQ+Da+Ji1q+PYOsgJv7VN2wo6UrNh31pmhGSQtWPfqv7sqmtI+s4/G
         uIi2OQipue4ad/FFGmQX5pK58FrL8KM4d+m12PZhILmgBiAfjYINshfRTmU2PWKNGSfL
         UxGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680699414; x=1683291414;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=udx9X2lCjzzCQSzA8XrrGEAIdcnTSdsgiQjtx2xR2Fw=;
        b=Qms30ceh8pwvN0zvWJq01jAGMh2LFIphmhIgc9afH9r1liB4I2OvHeePbLM5HuMklO
         TMD5/0wNNcNB1LsR5wFjcsYK5UrLa4iwJ+UvdIsuqfQ9/rYCNk+dPSKj34jTIxcaEa3q
         agW6QaEV493Dd8pF7Cf4gOAvj1XVsSvmya/fDU9YIIXM2Gua79kh9nEgNfApURKZJ6vg
         V+O+ybL2QxVXfT84kwUZBuw70mptuUFEplnL/DdzpLofd9Opim9dKeZSASd8dmV73oci
         iTO2y9EwWZz8IhmME6Y9GXcBNAMrSt/tQiAXJDA7ladtOOYq/ORQwAwFGoWW+HYxWOmQ
         NUYw==
X-Gm-Message-State: AAQBX9cq7qX40s2bNthEJeFeflHdw2wVjWwugvHqbVZyZ4bRRT8OeXtD
        rlDBdhzwM4qqwmK9DecXmJI=
X-Google-Smtp-Source: AKy350Y1jyiBFRQpHqT6r35EVxnVjzvfrX8JJvsTYRG9P7lqkNmW/jfcxB16JrNjfdslZTmJwCWX/A==
X-Received: by 2002:a05:6a20:49a4:b0:d5:e2cb:6100 with SMTP id fs36-20020a056a2049a400b000d5e2cb6100mr5243530pzb.49.1680699414008;
        Wed, 05 Apr 2023 05:56:54 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id b24-20020a630c18000000b005023496e339sm8950041pgl.63.2023.04.05.05.56.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Apr 2023 05:56:53 -0700 (PDT)
Message-ID: <c1ea92e1-8d5d-ec2c-71d9-1f386884a31d@gmail.com>
Date:   Wed, 5 Apr 2023 05:56:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH 6.1 000/177] 6.1.23-rc3 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230405100302.540890806@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230405100302.540890806@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/5/2023 3:03 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.23 release.
> There are 177 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 Apr 2023 10:02:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.23-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
