Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2334055239E
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 20:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243565AbiFTSNB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 14:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238101AbiFTSM7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 14:12:59 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B0B11144;
        Mon, 20 Jun 2022 11:12:57 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d5so10408934plo.12;
        Mon, 20 Jun 2022 11:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=CSA1neGl1yWAqzoVOGSuwz9l3taXUFKutaljg0W34Zw=;
        b=cnZyhFbX3iADt+U3YBT893xE9wsNVxuzzyEsAV5fxbptGPFTkmU5bCy78EuQTrfylQ
         izissxtwsjVFYUtN7ELeUjhqTo8svG4VMh7xYv31WBGtwokT4iQ7M80NofqVE/s07CuB
         UOZgVnwuKpER2NIAckbBMFx40PmPAPgD5x7Eo0cNJc8FLQ+AqTFoF82T/Hg7I286sx0T
         xxKSrWE4AwkfabPu/QrgqAraLyr4fBsVHHfYD6ucgwKup/HajMqQB6PzpZil5Zs1XV1/
         dgflHEfd7voSyP4bhvdJxrFzZ8UtmEaqZ90eq+Cz4Wg8Qp10LHSC0DVZcT4uVty6wHRp
         OE/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=CSA1neGl1yWAqzoVOGSuwz9l3taXUFKutaljg0W34Zw=;
        b=LpE5ule7Rt+ovBlnughP/gb39ziiGj50wfRjxoB5AAHTQjnAC+/GdhK7DbizCAR5z3
         +fNgXUvM5cXgLPyJY2p/mdGVPfsBegiDhRXXgcpCGwgA6fpSEDl/XqPkiew2xGHYahvO
         3IEVVUiDTNnt5e0PgeCwaRaqtd0jZ+oy/n0c6dqd1cJ3o1bNvY8ZtoAr0vtzrasB2FY2
         5iiyLj31nsEskVl6UrNh0fS0ZhnZ959Kz60IhpBB3xAV2DJpJ6dzyOWjNW0ErV9E78A6
         G+0PNEZtBcfI5DZGrdLQTbVHII1Q3Bid6TsavGw26AYlBUlDNW4Mb5I08V1vV35v4SqB
         p+cA==
X-Gm-Message-State: AJIora/UoeorJ5QELDXwqHaYHmaIpmpK9mZg0IDBLFIHTvTka/vdimXf
        JOKDsI5GplMDKGDUxQpqsjs=
X-Google-Smtp-Source: AGRyM1sAqIpUgblQZh2HnbkD4nzFe/8dTkr78CKUcc44nMPmxZmwpfGfvpEU2lWNfbbPbOyE2Kegbg==
X-Received: by 2002:a17:902:8691:b0:16a:17c6:3602 with SMTP id g17-20020a170902869100b0016a17c63602mr10619871plo.24.1655748777265;
        Mon, 20 Jun 2022 11:12:57 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id q3-20020a170902edc300b0016370e1af6bsm9036050plk.128.2022.06.20.11.12.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jun 2022 11:12:56 -0700 (PDT)
Message-ID: <6c979b21-b523-7d92-a869-a2103eb2f586@gmail.com>
Date:   Mon, 20 Jun 2022 11:12:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.18 000/141] 5.18.6-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220620124729.509745706@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
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

On 6/20/22 05:48, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.6 release.
> There are 141 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Jun 2022 12:47:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
