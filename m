Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 880325297AC
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 05:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233900AbiEQDKJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 23:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233378AbiEQDKH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 23:10:07 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 101893F8B8;
        Mon, 16 May 2022 20:10:00 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id w17-20020a17090a529100b001db302efed6so1088612pjh.4;
        Mon, 16 May 2022 20:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=s3BfoCmzlYJbVbnoYPvn7W4JOPGlpoRRGe5oEF2MKlI=;
        b=fca/G8iRyPxZXxaTOCqo8mlARNy/dyX7En2OQr5DMx5U06P++8K1q2ujtPTHrdKGjF
         hbo5hBmtnUOyXH/D+Qd82OCmqYQDIIcSRxoeWQhpINBbXTuZhvgOV0U+pmUmnH4T77tP
         ZZf2CprOww3GCrfJYjcncc94gyGcafT11EQk7IO9Rtsa7T2S7DiURr4rmLRNHjtbaV4F
         n8AptnNY98+inoulGD3XTGSTWLP0xTKTL4wUGmFFUp4QQZ8cXt62kBoC8RQjRctZ+ehs
         kOuD7k1PSN2LkE0x3UlomqaGiR0U7zR3LVCazS8vf/4h5bFsydv51X0kPe0I/Uz9sD7k
         Z2TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=s3BfoCmzlYJbVbnoYPvn7W4JOPGlpoRRGe5oEF2MKlI=;
        b=aCiNWqHEV4WBMjo88XohDe82vPWYGpFdBMasCtXXnvz2/cha8Wz8fCpNPTFmbet9KT
         ZqESGy0tbVCj64j/fGNToqhhK+jeZkedCxHR+OMbTK3j4uV3uZjpo2fSvgJRbIQ+1uOa
         rOs7DG27gcImLu4TDHWuOBXAI7x+YAR+BO8oUvgV/cr5ncslvZP60E1bvfmJEK9iNcKd
         74B3n7jPRX4h1OqhYb1Gn6zH5FAUR50FL5cZmhg0DhfG7UQkDWyCXHGvw7AhilpJVer4
         mMRF/0wOn1MDPhZpEUZyzyaXV86H1w3gNri7u0njiTg0A9k26hZ6PBJuKJ5qBWVh53Zs
         LblQ==
X-Gm-Message-State: AOAM531Gfk5FiTx9NBbny3dr4FZ5bXinjirOs/lo/i8l+/uitzgD3kTw
        Wx21W/RZQ68IRbJcS4rn1Bc=
X-Google-Smtp-Source: ABdhPJy1oCJo7wKKHDtiQuZSm+YTK/v/j6S1RNZCfHjSqo9tuDaOkQwgF+L0staQJlSePoa3ZQXlOw==
X-Received: by 2002:a17:90b:4a4a:b0:1dc:4731:31a4 with SMTP id lb10-20020a17090b4a4a00b001dc473131a4mr22906755pjb.19.1652756999502;
        Mon, 16 May 2022 20:09:59 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id j18-20020a170903029200b0015e8d4eb2c3sm7706519plr.269.2022.05.16.20.09.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 May 2022 20:09:59 -0700 (PDT)
Message-ID: <8e266600-4ae6-b64c-55b2-05d7a72a4c73@gmail.com>
Date:   Mon, 16 May 2022 20:09:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 4.9 00/19] 4.9.315-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220516193613.497233635@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220516193613.497233635@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/16/2022 12:36 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.315 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 May 2022 19:36:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.315-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
