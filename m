Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC944F7B0D
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 11:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbiDGJMO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 05:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbiDGJMK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 05:12:10 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56CB98933F;
        Thu,  7 Apr 2022 02:10:10 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id 12so4985092oix.12;
        Thu, 07 Apr 2022 02:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wjrvvilqUAvNiut+02kLxnPb6tN545ucACCv9KgFqx0=;
        b=Ehj/uAXNKqOGzP5t2AsDVPC2JKlQPrBpbcCLEuKgf7k6cDCJxTqHQ/+kXtuLeXky2/
         ywnXE0vn81mXcI9jxqLBWQz5rF72vyDTPZ7uYuYx5N876u/RHjDGy5QkrCoqG7GBEWoH
         r9NXiSKedpTRiNo4lKXv1p+oPR7t2uiTxAsIzpTiejsUNcMZVeWKAIPPlT6GD1f6Mgx2
         6mWgvwZR8sjRQTUBLyctGM084AnPJc+m+sV7H7LFl01Twx5LnNiPkSsL0za95whfpB64
         ClToOmKLqrWjdkP+tHctPon2FyLFzuJ4BBbX8uTUFYWSzA966dP+4DecPFi2NMwg0PUw
         ASOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wjrvvilqUAvNiut+02kLxnPb6tN545ucACCv9KgFqx0=;
        b=NROb3jZtCRWuI4K8A/JBdfafP2UEqv88vkzPtGR7/gvFRxRipusfzQE4RRoG29zwWj
         b5Aj59S4X9YUmW6Irrdv1XjQFj2qt/romMyrbBXCahwLgpTJCvUp+YY5dyxgL0dd723z
         FcjpsSdIvI7G0URTCITACHxFuZewYEMgdupNFZcE1tYH4l4/USqsVwfDNaSurhhU66uC
         Fuwz9PQPUN5GkMSO6ghVmeg2qpAcF9mfl8Ei8ZY48AhL9ngzjtC5PtBpnrDa8M/PuUGO
         Rr6DUlXgAxFJpcJ1lGbNVdLUImU5psuVUWZnEWKzDAivUxRRZOqS7wSlyF8RRgaPH0pW
         C5DQ==
X-Gm-Message-State: AOAM531GJIswMQT+o7Bxtx0fO9ZghKCJjeI0ECLPmVje/gTrfPPPtaBB
        9kSyt5jMQeUqJ88YwMbkOTg=
X-Google-Smtp-Source: ABdhPJyH1O+Hpi+dQPnb4pjnyV2IzIIT8m48GE3hwHcN4Z5/RkgfQ6rMIFYwnWFpAbhfkqlPISiWlw==
X-Received: by 2002:a05:6808:238e:b0:2ec:d381:5fac with SMTP id bp14-20020a056808238e00b002ecd3815facmr5229897oib.248.1649322609663;
        Thu, 07 Apr 2022 02:10:09 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n35-20020a05687055a300b000e1e2ab91e4sm5547978oao.39.2022.04.07.02.10.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Apr 2022 02:10:08 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <fce71421-6afc-9f8c-31a2-a71fccb3259d@roeck-us.net>
Date:   Thu, 7 Apr 2022 02:10:06 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.10 000/597] 5.10.110-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220406133013.264188813@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20220406133013.264188813@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/6/22 06:43, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.110 release.
> There are 597 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 08 Apr 2022 13:27:53 +0000.
> Anything received after that time might be too late.
> 

I still see the same build error. This is with v5.10.109-600-g45fdcc9dc72a.

fs/binfmt_elf.c: In function 'fill_note_info':
fs/binfmt_elf.c:2050:45: error: 'siginfo' undeclared
fs/binfmt_elf.c:2056:53: error: 'regs' undeclared

Guenter
