Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1693E4D4113
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 07:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233255AbiCJGXl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 01:23:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234293AbiCJGXh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 01:23:37 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E507ECFC;
        Wed,  9 Mar 2022 22:22:36 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id s8so4248340pfk.12;
        Wed, 09 Mar 2022 22:22:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=1QvrxHVnbuN951iuLJ5i5Z8epnWXoTEiu0JfRkCwdNc=;
        b=pauh/m4aXdFskskvW2uqn4VO4FEdiv275dFzvGGgPZj1M+B2jiaawooUxtFCYorgLW
         M4r9zycfjJgFk+EIEnCsxwQaz+OzY4Dp/l5BggCR0X66VWff2dcuGEj1RYb6DHCkXR10
         mR+LPzascD4moLvPknZn9ObjSp7fJAaaV7kcM0VKIU9ncsClRYsRsLrgWE7yA7T/HgzS
         jfYa6o/wpPwczaWqNE1NeXWRJpivcuYr/y2Tr4v2nnlOFv/7Buls2dM1/pkLzaE3PTlM
         95LXQ8jyEg3Js6rAaeZZEjLRuy7Ku6PzsZf86eIk6IuEc1Skmn+oUtItGnTVS0sqCn3v
         zzXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1QvrxHVnbuN951iuLJ5i5Z8epnWXoTEiu0JfRkCwdNc=;
        b=f+xqBPy2c2JphOSxtCpIXVfn4kXfcIf7arbx3/G3Q5uNN10PpxHvEuqWLzm9oRNjTk
         NRTMJokHrGd0c9xivb1vo/qs1DoArKB5DNxkgMf3e5lIElqGRwWN42zPKahFSdCb7fjZ
         PsCGBXREb4yVQvCm7/82LUI2044ZkCitM3idQsborEy4LoAt1ULUk6kq+dUzoksDvdCG
         3GCIP93HFrmruk/NodSAST2Imo82GatmwJbdmStRNpmgTXGKRVAI5Zor6HaBExChsq4x
         bV9kcgsyPLRDX9PUJpZWwL0cLrBp3bvmxUCd0O2db/AaFisEP/3z8UF6TbHPfBasVp7P
         h//w==
X-Gm-Message-State: AOAM5333vSYVrAqKAlFrX+eFXLf3GnNQblFSXgY1T+ZPxY7ctMLDubWH
        ezw+9bUYbknkUGkip0EWNbg=
X-Google-Smtp-Source: ABdhPJyCvUa8NQpFHlM0rAOEJiMBlBi0dQ8fZLU0+6GrXUQ3ahIwxnK2e2aNk3bpNWYnUNVmwue1Pw==
X-Received: by 2002:a65:6201:0:b0:369:4a47:aff1 with SMTP id d1-20020a656201000000b003694a47aff1mr2838506pgv.238.1646893356508;
        Wed, 09 Mar 2022 22:22:36 -0800 (PST)
Received: from [192.168.43.80] (subs03-180-214-233-29.three.co.id. [180.214.233.29])
        by smtp.gmail.com with ESMTPSA id i187-20020a626dc4000000b004f6e0f346e7sm5315733pfc.39.2022.03.09.22.22.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 22:22:35 -0800 (PST)
Message-ID: <49ee6347-1e2f-8894-627f-f90bc8356f84@gmail.com>
Date:   Thu, 10 Mar 2022 13:22:30 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH 5.10 00/43] 5.10.105-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220309155859.239810747@linuxfoundation.org>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220309155859.239810747@linuxfoundation.org>
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

On 09/03/22 22.59, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.105 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, gcc 10.2.0) and
powerpc (ps3_defconfig, gcc 11.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
