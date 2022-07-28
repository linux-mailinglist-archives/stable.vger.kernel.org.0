Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8432D5835D7
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 02:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233037AbiG1ACb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 20:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232834AbiG1ACa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 20:02:30 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18C1818345;
        Wed, 27 Jul 2022 17:02:29 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id ha11so490062pjb.2;
        Wed, 27 Jul 2022 17:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=5f8IoG6sGlHPscn1UbjAGOabACLzRqwoDg7QWMu4BQc=;
        b=A9yH6cKVVd2fkMr1M4QzDODZN8DR01SPOXG88EjVD5mWcXwQQ5AIXq4LPLs2LtXqaa
         j5ISHHLSBCphqBmgt9Zs2Wb9ZdqKU3WgAJGCLmyh1FNyyCy6Co7S7rm/pYDiW3A1Pm/f
         mtZ5/2EdFhPnlt3F3rLXqKdYMV1iiGA+435DG83c3EaUKqckMDbDnU2vj23n24Plclwx
         2NBrS33O6GW8ZoGlD4OUHOIMDm48Fv6vowRPhcZNnd6TNsFdnFne2JwmRIspYzpmGr2I
         NvG6VnSQTzen3zTzDdQwOWWiG6tgqr3k5S8kMFgvoxHFi/irtKiYO1frWqacEuOTHQye
         ckhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=5f8IoG6sGlHPscn1UbjAGOabACLzRqwoDg7QWMu4BQc=;
        b=MbJpkDyHocmzVcdTeV6Vr6Zkpri/cX2TQ/mVQyk3387/NRl7zixmX/AtiZisXNwy0N
         aSTWieSPmH8mb68RQOK+VCQPJl+/KqjjUaeViktvfNTZQd+acqqZv8TfjpKit0b3cw5v
         gjH20WDE+4nmvICFUL2P00UwBdhC7kk34FafoYqBD6/Z7g2Bif9wHkvHLbzlEg0fXxcd
         FuB4QSEFBJMYhgloWgteEh1Hh8hvj2RKbhcRq+JInEdd1LpRrRh//pAgcfLyzdwsduSc
         s/KC5i7X8NhoqaDZlEraVfJXbf/sYVSqha5DQ2T5oqyKWqzDUlZtL7I7rp7dNZN0Iuou
         BDhw==
X-Gm-Message-State: AJIora/x9AQKba79goOFwtEEP6mjx+k9/panXfz9Hgo5nzUAxwUKuIM/
        gcREKfGftVTnZMafnevrfW8=
X-Google-Smtp-Source: AGRyM1uDkSsvQfFFg5Le8P14DjyhSYOh7iqPZWpWN9Y8DHAqW954IXboZeVKO7fKHTqtvEtP5Lutxw==
X-Received: by 2002:a17:902:f609:b0:168:dcbe:7c4d with SMTP id n9-20020a170902f60900b00168dcbe7c4dmr23651260plg.169.1658966548461;
        Wed, 27 Jul 2022 17:02:28 -0700 (PDT)
Received: from [192.168.1.102] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id o3-20020a1709026b0300b0016b953872a7sm14265664plk.201.2022.07.27.17.02.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jul 2022 17:02:27 -0700 (PDT)
Message-ID: <d57329c9-0600-3930-3f24-f1ceae735b20@gmail.com>
Date:   Wed, 27 Jul 2022 17:02:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.3
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.10 000/105] 5.10.134-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220727161012.056867467@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20220727161012.056867467@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/27/22 09:09, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.134 release.
> There are 105 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 29 Jul 2022 16:09:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.134-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels and build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
