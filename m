Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2AC35FAB0F
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 05:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbiJKDS4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 23:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiJKDSy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 23:18:54 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 300EE72EDE;
        Mon, 10 Oct 2022 20:18:54 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id g8-20020a17090a128800b0020c79f987ceso6959476pja.5;
        Mon, 10 Oct 2022 20:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=q7jpzO8Ke7O+Q8EQ2ck6VZGI9qoGjYzStkg/yGmX7Ug=;
        b=R8mh4ensz5GfJoIKug/4zEh1uYifTe3XlhWWIGHN4orJPXdsH7Ur7jcuGYmlNKCJna
         0dJb1q3MUeUvbRnkbw+wK1ubs66uhSm3ocX6fAjmPMCfZF78Ga5cHMWvbcJ9AHes/ouI
         1ogcarJAZcNBy5aHSHOnlRAc286i9RI5kDqXAGSGfM3bcLQsvGr5xh+w9dH4uc67aLb7
         vBjMShQzXoH5evOR4RAgbax8vMTa8tpGuMEBPgsJjHZEEweE0EVqCxOrUpw1F5s7t6F4
         3N2wrqpf+SIaTrBV0o8gXHzikz9u51gJr8+eyXCMVQq4Psgl3x7b1FSwpDe+wPsdb5s0
         UYhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q7jpzO8Ke7O+Q8EQ2ck6VZGI9qoGjYzStkg/yGmX7Ug=;
        b=oGd8eknHuiPKGZU4SNH0UGw+F6Ix9ArwGhJbEbjU9X8Zsm9S5AKCP545BTKmKuS4gS
         nZqGv5+0JdlhWJf0kowr7yqkS64kZaG+m7wUW+nJf0RsTqQ6lIE1DgkJL/Bj1SJhGi49
         djlnSSmWCwzgT/qZeGpnRNWfPVyW36BK5ObGAB9ShOxfuyrUtVCyk+RI8QYEywKp19CX
         +DOI7Zt4/gCB9cMEkGfPduaqY5GBap3fwTyL/nGrNU9Q3opqP4WGkGMa55EmJ8lFWDov
         zjimAFxEZi4X1XNVZ2uUOy3YXkRNbaCTXKvsZ7bayOAAHQktco9h9zG+QztR6a0JE0e2
         F7Aw==
X-Gm-Message-State: ACrzQf20oWbwKO6l3BMeNIVjEUvO5FL7yyC3LzUZqsHCg5keBupKyev5
        OhvRhIr6MYdyJjS7esTXTWWO6EDLPTNlCw==
X-Google-Smtp-Source: AMsMyM4d8+fgF7xwyqlkT0MuUWNph7sRO7tN/Rm2AtTXS6h66bzA9XHvfl4Z4APNlVdy9994kdcV5A==
X-Received: by 2002:a17:90b:2246:b0:205:97a5:520e with SMTP id hk6-20020a17090b224600b0020597a5520emr35686812pjb.244.1665458333691;
        Mon, 10 Oct 2022 20:18:53 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l1-20020a170902ec0100b001782a6fbcacsm7368255pld.101.2022.10.10.20.18.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Oct 2022 20:18:52 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <f519c545-b250-0196-8f26-7fc56173ceaf@roeck-us.net>
Date:   Mon, 10 Oct 2022 20:18:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 6.0 00/17] 6.0.1-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
References: <20221010070330.159911806@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20221010070330.159911806@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/10/22 00:04, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.1 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Oct 2022 07:03:19 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 149 pass: 149 fail: 0
Qemu test results:
	total: 490 pass: 490 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
