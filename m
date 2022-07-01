Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3771E562F51
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 11:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233881AbiGAJAY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jul 2022 05:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233919AbiGAJAX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jul 2022 05:00:23 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E240193C8;
        Fri,  1 Jul 2022 02:00:22 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id o18so1804712plg.2;
        Fri, 01 Jul 2022 02:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=EOxeOoaI0bvRSLPnvd9ma7w66QWe8s3HEhHKfKpxGGo=;
        b=QGVh+hbqXf+WTexnx2BxPuueF1A/E/4CLbo4my3mAQswwZrRVzPK1jqcLcw6vWOXtl
         abuf758gguO7Wiw5rmFWU0h/u/u1S/aHNISYkXmwjAPVAxKhd20TP+VyTFH/9ryMpDF7
         4N3biMYnOJDLkep16ujWfbwXsFKkIrs1YwOKAb9PA6Jj2drYj91QYHA41rozndRHYaNt
         48qJySQezKNETHAotnIr/woGzrGJzKp5+MUeRsjuWFc8RC+QBsvGIsBlAXZjKoDLiHtW
         YLlI7JOWbYSQvOqcyuB6O6DCdftgrW4Ep5fZyHCeE/HLb098boWaZd747y0rbwxpo4q4
         +DAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=EOxeOoaI0bvRSLPnvd9ma7w66QWe8s3HEhHKfKpxGGo=;
        b=Je35hE7+U4LjuVojaDW6GpQUDsRUX6Bcrv9sqsTXDHd3YFm5FH3chZ6gFS/xvDO61x
         y7IFRRCBjfqn0yIdxMnIjd335Cv+nzkuNm2Y03mCxhtLR3L8Bw5pjy+CCeEbCVp9COn8
         tVrkbJvB7Gun5Jcqrr/1Ak+qXpC7IXUmVrRen4MOPa/8zeW39q22nmqNC6PZ4Q+c23ZZ
         HkLWMUkZNZhoVv3q4yRuJnLHU46pVtlLyqdv4LP2JHs0YrGxGzcyRwWdseIylutehrwJ
         jUCAokzzPO91/pnhbiyamwNtiAmkhnaCmZBBFA0/New0QVKgVqv6jR2sFTB1lzzXSt1w
         IgSA==
X-Gm-Message-State: AJIora8a/jSt0GH7n2bEtBIM2Pi/+pmk2NTOUe3UTDwT6IWpzi7S2nyi
        9wsalaQzu9d7w01dbNieEaw=
X-Google-Smtp-Source: AGRyM1unfDhl7UU6ufOPfkHBBzRbJU5eWsaVnzHk0tvTfsApvegSC+Rbq0M6TdztrmlcfF3msAAeKA==
X-Received: by 2002:a17:90a:a44:b0:1ec:70f9:630 with SMTP id o62-20020a17090a0a4400b001ec70f90630mr15120031pjo.91.1656666022102;
        Fri, 01 Jul 2022 02:00:22 -0700 (PDT)
Received: from [192.168.43.80] (subs03-180-214-233-29.three.co.id. [180.214.233.29])
        by smtp.gmail.com with ESMTPSA id v23-20020a62a517000000b00525b61fc3f8sm9983009pfm.40.2022.07.01.02.00.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Jul 2022 02:00:21 -0700 (PDT)
Message-ID: <e3fcc525-2f6f-3df5-508d-1ce7c35162d1@gmail.com>
Date:   Fri, 1 Jul 2022 16:00:15 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.18 0/6] 5.18.9-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Paulo Alcantara <pc@cjr.nz>,
        Enzo Matsumiya <ematsumiya@suse.de>,
        Steve French <stfrench@microsoft.com>
References: <20220630133230.239507521@linuxfoundation.org>
 <Yr6pTvc0Zka7qVfc@debian.me> <Yr6vKgOmqF562oc+@kroah.com>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <Yr6vKgOmqF562oc+@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/1/22 15:24, Greg Kroah-Hartman wrote:
> Again, gcc-12 is going to have problems with stable releases until
> Linus's tree is fixed up entirely.  Once that happens, then I will take
> backports to stable kernels to get them to build properly.
> 

OK.

I also tried building the mainline (with ppc64_defconfig), no warnings
reported.

Thanks.

-- 
An old man doll... just what I always wanted! - Clara
