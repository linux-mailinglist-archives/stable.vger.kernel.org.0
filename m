Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53F734BF197
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 06:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiBVFjl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 00:39:41 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:56386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbiBVFjh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 00:39:37 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D924695A2C;
        Mon, 21 Feb 2022 21:39:12 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id qe15so17282427pjb.3;
        Mon, 21 Feb 2022 21:39:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=xJExj9QItyQjXYiedhpMto5VC3ZQviGurxN1YckvXEE=;
        b=S3Yry2UQ8V4gtf4jjUfDPqsMuHxgi+lJruXchzRAnG3+AApsy0vtKS1cJdPJJp9Ib7
         at/zLwz7zdPw9VJ4yOS2EDsUG9yC4uGUtSW0E6JjsuwnhFVy7+ZyF88cuqoS+0PPo4Ww
         PeHKioVynDJSkb8CHiHOeWCzQGfLskY1hoYs9+IEfvq7ZGIr0gM/WVzKi6GmAwkQY5uF
         VPAa6sYZ7B/m5SVkFbdcxSbBw+dy9TVRGh0/kSP7/+LMzHWHVDmRZBwB9WhwPWiib3sG
         kt7rz2v4FS4B4yiuTrchcZ8OSiakIv4H/1L1GAdmkBXgFSssO6OXSz3lfl+Cnfvy2A84
         qmDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=xJExj9QItyQjXYiedhpMto5VC3ZQviGurxN1YckvXEE=;
        b=UZwf78U2AKiWhPSI5B5DzPiet0ZJOZxwbKFn0dpdD8mk/5RoyQ8iB0mjrFV/mwebzu
         8iv/xOe+CEe/W+gCWlCm+OKjb45dIKEAV6OIcqnxGhbY4j/aq6R45XwM2OKR1ERUEBp7
         yaesq/WfNUipICrgdQMH7vfE+QN2ig/DHrGXzI9zIrEoIyUpvBs3HQ6AR1FaLqs0PR32
         +oAcazDUU9qC/Ee8lSuQSusb0dFLCegzPDg6C8rjcE6pEWNnLgxheI7+ztn5VTpfDs1g
         dckjBpxcZ7u3yNtZixF8RrLWxDDIurLdzAykWnVjV6zfqImplBLIH7Mn7H+NhIWm0JdN
         g7rg==
X-Gm-Message-State: AOAM531il/FrafBol5l5qsajMkxRRsTgEDg8Rf7AKev4vIF9Pr0CINkL
        JyduIoUaIIe3GU+b1Y5EUPg=
X-Google-Smtp-Source: ABdhPJyS+flrC9zymhe56r57MyG7l+3zFyY6S+yCs+0NoYTTDmZ+1bTW1xRrsn3BGayn2CWivkhYoA==
X-Received: by 2002:a17:90b:3509:b0:1b8:aaea:a82e with SMTP id ls9-20020a17090b350900b001b8aaeaa82emr2398175pjb.109.1645508352019;
        Mon, 21 Feb 2022 21:39:12 -0800 (PST)
Received: from [192.168.43.80] (subs03-180-214-233-68.three.co.id. [180.214.233.68])
        by smtp.gmail.com with ESMTPSA id t16sm1067399pjo.26.2022.02.21.21.39.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 21:39:11 -0800 (PST)
Message-ID: <8069aa79-467e-9af2-d3bc-3c28aa93f0ef@gmail.com>
Date:   Tue, 22 Feb 2022 12:39:05 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
From:   Bagas Sanjaya <bagasdotme@gmail.com>
Subject: Re: [PATCH 5.15 000/196] 5.15.25-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220221084930.872957717@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
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

On 21/02/22 15.47, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.25 release.
> There are 196 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, gcc 10.2.0) and
powerpc (ps3_defconfig, gcc 11.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
