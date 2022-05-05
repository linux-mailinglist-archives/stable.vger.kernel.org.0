Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7C751B6AA
	for <lists+stable@lfdr.de>; Thu,  5 May 2022 05:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbiEEDth (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 23:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241620AbiEEDtg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 23:49:36 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C937E49CB8;
        Wed,  4 May 2022 20:45:58 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d17so3282563plg.0;
        Wed, 04 May 2022 20:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Qic8oMjOrjzRLrqJlBdJ2u5vDHaqd8LZdxwAJMD+7VA=;
        b=iE5pgSeupeatC4unGTZAXz/7RJk7V0vYUOxNs9XFt1irM8YKNFFbAqNlfZuO68NtMZ
         7d8nvQawEPiiJEQQGNqPHV/5JUsv+eS7ls2AWopM5O3SnSYgylMDIQmSxzqusV2l9QF2
         3076Z2hcEAzckILh+/9Ad7wFCy5/vkFXKxlcO905d2fmzJd09fcbu75N4Nd7tk818i8/
         4U8L6lQ/ibIYe9AA9XI4Rfw3gkNeAVChrNuFvCb+n33ibZ1/HGcsnbJRy1zGrtE0z3h+
         on5UC0cPvSN/J/qdtLKd/XDvSEDyQaWHzbHMQ5yVl/rrFBshjfgqZ3vRDyCblDR4rYyI
         HDgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Qic8oMjOrjzRLrqJlBdJ2u5vDHaqd8LZdxwAJMD+7VA=;
        b=V5+Bhu27Zdc29I5stziC4zak17K4kD1kq7KIvcBYR3wFbx1qE9bg9TR4FdhJHpceqv
         aEjIlVWCrZKN4xlnYtJsm2lR+O9C94TMuiVdSLujoHsxb+HKqKigvcJSIWhg/UapvOOB
         BaEVsjNRkiVsdIrYXOMpjNSbpqyVH/8Z/Vaj76SJVpfQf9pN5BViMeK+Uv1mIy+ZlmI1
         VoY1T3pGP5Wg1MsfyRQEUHkcA/ZSa+eiNeDE3jrv3uXafFVT35D+NWmNiT+4t4voltns
         TXRdo+j5JR93V8QOgI8g9v3f6lh5IpP17cyHbnW6yK6E+ZawRnAmdH0bGQw8Ex6ftOWg
         Ariw==
X-Gm-Message-State: AOAM532mi1F24H6QyVb1pyB4ubGx/S9t2eG3F6dD5m+C1y/hZDlPCfxR
        JBvA19f1PnecmvJydRBPbK0=
X-Google-Smtp-Source: ABdhPJyg6TghmW5px/DF9TSN8s0bgHM1kbEdVtqeqR/cFzjwg1OmaO1kJXofb/O2LxDE/5D+HpsN3g==
X-Received: by 2002:a17:902:ea53:b0:15b:1bb8:ac9e with SMTP id r19-20020a170902ea5300b0015b1bb8ac9emr24559491plg.45.1651722358277;
        Wed, 04 May 2022 20:45:58 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id x23-20020aa79417000000b0050dc76281c1sm170006pfo.155.2022.05.04.20.45.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 May 2022 20:45:57 -0700 (PDT)
Message-ID: <37a037be-2673-1a4a-fc9e-fc95774c0b48@gmail.com>
Date:   Wed, 4 May 2022 20:45:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 5.17 000/225] 5.17.6-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220504153110.096069935@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/4/2022 9:43 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.6 release.
> There are 225 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 May 2022 15:25:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
