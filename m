Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB67634205
	for <lists+stable@lfdr.de>; Tue, 22 Nov 2022 17:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234370AbiKVQ7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Nov 2022 11:59:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234410AbiKVQ66 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Nov 2022 11:58:58 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C0C45A1D;
        Tue, 22 Nov 2022 08:58:57 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id t62so16438536oib.12;
        Tue, 22 Nov 2022 08:58:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=Bt8Ttpp6RbBrNJPZBjc452dc15WNtqXh5ouNAwptrR8=;
        b=IMUaGlI5ct9+fTRZFPz5w3/ewKXGBmwF/9xJ9eRKHJ6lzzRfTs4f8VfKzaQhPcxCaW
         wJoXG5N6/3PVCuU0EjvNBxboe7qXbT8RAh+HInM3no5X+7ADBJ16oFMD4MyXpCjFezBG
         CMOBNINgmES71Grrrsx+0nBIUqSc2K61GRmnQVP6U1o09f+s6g5PCiLa6J4tSC/Iuib6
         A6WZhPdGOg7JJskOTQLjfd/OOCdIVPDlCHd0YGmgDyzNFJQXx30DtO0SWO9bpyp0Xe19
         I7t4UwUC8sQS+gzaTAQhGYqFEYEqrrNd8gBQrztW5QA2/Gmrknq4/xX2bFLqVJSAo/fp
         VSoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Bt8Ttpp6RbBrNJPZBjc452dc15WNtqXh5ouNAwptrR8=;
        b=6QVTGqKbuGerBt84DTo0Ib5nxaCLwit8v0fOBgYm6LdGPAqTzhnfxm7nb9rYs15MWm
         IsFX021mlpRzMpGtpxYZ3j1S9fRJeqHAlhYQ9zWZaK7eXKJ/GgMljPsbHp5wc0I4J6Ba
         VGzw9CK7rgTqHgx8vU8cVK6mw2pRU3edHSTMdQ1nNZJoROAJSFr3kaS6rRB6/Gwn54Cw
         uwbVoKSbEB+5rfKydT0HA12Joc3JTqSxKmnfnY4WeyIOiZQg6B0bMBdGr5jBhLJt25Bi
         RdszCEgikmd/RFSoRBShEir+S/ojSihAuJ8KmayXpr9dbJjTGZvQcQPlAxF1lMTAJx4s
         sJWw==
X-Gm-Message-State: ANoB5pkjW0dSpu1zLjc+CW+0TyNrL0xLBES9tfex8eefiKtBWTTMEaM1
        sjP+ydszv7pxHTLOrL6I/I4=
X-Google-Smtp-Source: AA0mqf7I0kCnZpHhGo+5q4TZb+OVIaKeQcdzSim4jf4oSAmlCOKoBOJt7PIVYVSMiAMlDF+VNLWnuQ==
X-Received: by 2002:a05:6808:218:b0:35a:202f:1bcf with SMTP id l24-20020a056808021800b0035a202f1bcfmr3442263oie.32.1669136336404;
        Tue, 22 Nov 2022 08:58:56 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l10-20020a056871068a00b0013d7fffbc3csm7700496oao.58.2022.11.22.08.58.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Nov 2022 08:58:55 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <4edd6e3e-b37e-f5ed-8bdc-47c5b0cf2e9d@roeck-us.net>
Date:   Tue, 22 Nov 2022 08:58:52 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 4.19 00/34] 4.19.266-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20221121124150.886779344@linuxfoundation.org>
Content-Language: en-US
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20221121124150.886779344@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/21/22 04:43, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.266 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Nov 2022 12:41:40 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 423 pass: 423 fail: 0


Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter

