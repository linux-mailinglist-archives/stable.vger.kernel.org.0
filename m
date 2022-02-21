Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D12164BDEA9
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381581AbiBURSa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 12:18:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236883AbiBURSS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 12:18:18 -0500
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D3EBC9;
        Mon, 21 Feb 2022 09:17:55 -0800 (PST)
Received: by mail-qk1-x72c.google.com with SMTP id q4so16179704qki.11;
        Mon, 21 Feb 2022 09:17:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4vKz5/h2niU9zQzK3cx2M4hz/axnZLon842oY6QWiLY=;
        b=oCA4aFbdm3b9DfMo92ussw+mQdp50uVWBwhiREcfWFqARRRL7D+OcpOFy1IwS2z2ot
         J/UUc9PA2dulQBLLcWmbNKV8fPIcF8LFUjby3bx+kDu3GDQSN9SXklhI9VnT/N9S20gv
         X6RzX82Z83zV/75IBYIPPD4o4ZQpKvgBBOITN2ifq+mMqWn/mOuzk/tFX/lcWgHgCpLS
         z9rtec/dgGaaBo8aObr35sHNd2PYBXROcy/GmMI1sq7aGMw4UBlf6QQipBv/baAcokFF
         t4vyPDJKifTYZh/zJ8fG9NM7WudMgMzrBxHQ3kVcYvnz99YmoMgnKPucJiaGFfn2PA+k
         Nikg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4vKz5/h2niU9zQzK3cx2M4hz/axnZLon842oY6QWiLY=;
        b=q1VRwNfMKaZYH7v1wcWjWOMoIpK1BG43Q4vsZ66fH9GpQJgkdoe0wBh4Of3iU6A7no
         2RYY7s8DCGYW0UI7j0reN97dr/kXGuH5vxizzI/s+fi5wgue6O+fYAKm77HqidTfwMCS
         lsL3TrbA8HrPnkep3ZJb8tzh8f7KpedIMFIHHkgT/sFT7tFrD4qB0D5+RZiEN/JnwP4O
         uNMz/opMa0WYHZSJU1dOPAGPS1DtTa0TkW5pL4vDvBwnoLSTc43G+3pkGfE0lc9Ob8sx
         lXvzDCd41lyL4dpaSvHx9X9BIj0LUKsU6uNu3VeWzF7IB3ac/7AYxcZFPrlzvOjzAquS
         +k7Q==
X-Gm-Message-State: AOAM533JhIVkPShZSFiSHnyEIRNTcdCyha1Vazj2jWuIC8MzN7CynAKf
        ToreO9OqOiKxtYhYy9QZ36E=
X-Google-Smtp-Source: ABdhPJw0f3cGcI6uv9O25dSk2qpQ6XHy+wghKPBj0jzo2ZtT3tSDYi34NJmt8m4Xw4TiQugQx7CNDA==
X-Received: by 2002:a37:b546:0:b0:47e:9a9f:c7c0 with SMTP id e67-20020a37b546000000b0047e9a9fc7c0mr12768505qkf.468.1645463874376;
        Mon, 21 Feb 2022 09:17:54 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b5sm3619952qkl.23.2022.02.21.09.17.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 09:17:54 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <0ceb2013-061c-700f-c386-3b180a96d59a@roeck-us.net>
Date:   Mon, 21 Feb 2022 09:17:51 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.16 000/227] 5.16.11-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220221084934.836145070@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/21/22 00:46, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.11 release.
> There are 227 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> Anything received after that time might be too late.
> 

Building mips:malta_defconfig ... failed
--------------
Error log:
net/netfilter/xt_socket.c: In function 'socket_mt_destroy':
net/netfilter/xt_socket.c:224:17: error: implicit declaration of function 'nf_defrag_ipv6_disable'; did you mean 'nf_defrag_ipv4_disable'? [

Inherited from upstream.

Guenter
