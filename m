Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47C36696ABF
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 18:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbjBNREu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 12:04:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbjBNREt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 12:04:49 -0500
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 089272CC71;
        Tue, 14 Feb 2023 09:04:12 -0800 (PST)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-1442977d77dso19830367fac.6;
        Tue, 14 Feb 2023 09:04:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=drKO7idz8bniLU0+VGX8stsZ83xhPx1+n6mCtJ3J9lg=;
        b=Dp++Qy93JEem3uE1Pm6TIbd/dOGt62NimziMjkxuvubeWRWW4Fv2lIaiX0e6yM7yst
         dqOcWk1qDMryUzJr4GWbLPxJeon4FvGg3X+JMgepL1Z1invh8HDEAk+t7+Dj7SF7LHf5
         +NzE5phsyJW3U6uuOYovmTu4zJQW4vDMWLfP7JMcDdsfbD0dEcRTTaFk+Il2f9MzQVJx
         zG3iz1Jbso1NGQ7XecaDCfJL3t9nZjkjLr9vkd5e4SFrm66MSxvVXWbKTwN8JLqn+GvL
         SmES3K0SK/r8X/u5VFLGv5ot0RwFu1CB68XdjVXspMlkP+teBWZ0b7d4BAF0fa9krxDg
         SJVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=drKO7idz8bniLU0+VGX8stsZ83xhPx1+n6mCtJ3J9lg=;
        b=aTVHU6BEyB/v3u4Fqv9fEG+JsxTjJOBJeWOOYpO6BJeoe9KZCy33qYY3hdt/bmoMX9
         ZN7HzD3B47+ACRXVBTLkHzG6mpADqMHa2uUq887NinqGVNjJCmXRDAasQXjG3K3RQLL9
         4tN/FEWqeRKv9ESBOcS3erJYWq8LiO6WtOf+jwhp42a55WKAhrf4mV31cNHCxsK719ir
         Q9MXe1y7d0i/47O/OE27VznemvKU3WOgZGt6VcuhNJWeBKyCAf/dpRHXO7gD07MLm3Ys
         hkNpahDkFSHfiRIW9wtJkP4e9XC8eUu9+2n2XEraPtorextPWjwIHHriZlEXN/bkRUmu
         yvBA==
X-Gm-Message-State: AO0yUKULAEwfFJGuxS6SS2cBejJ0bCU0s2yJO/IS64DbevFYqlknvMsW
        ZnYsb1nDExHxia66xTAvwgc=
X-Google-Smtp-Source: AK7set8H552uknuiozheWOs5ix1vqMmOfTiBiJSx4JpmFJ7lcKyF3b9y4uGTNscTAKvbHaSPFuUwSA==
X-Received: by 2002:a05:6870:80d1:b0:16e:223b:1922 with SMTP id r17-20020a05687080d100b0016e223b1922mr1455479oab.15.1676394248976;
        Tue, 14 Feb 2023 09:04:08 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q1-20020a056870e60100b00163b85ef1bfsm6038319oag.35.2023.02.14.09.04.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Feb 2023 09:04:08 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <7106f107-061d-231d-fb09-bf4832e2a5a0@roeck-us.net>
Date:   Tue, 14 Feb 2023 09:04:05 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 000/139] 5.10.168-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20230213144745.696901179@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/13/23 06:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.168 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Feb 2023 14:46:51 +0000.
> Anything received after that time might be too late.
> 

We don't know the reason/cause yet, but Chromebooks with arm64 CPU
no longer boot with this merge applied to chromeos-5.10. We'll revert
the nvmem patches and try again. If that doesn't help we'll need
to bisect which will take some time.

Guenter

