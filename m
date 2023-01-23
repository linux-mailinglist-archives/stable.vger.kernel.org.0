Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8378267865A
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 20:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232730AbjAWT3K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 14:29:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232697AbjAWT3A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 14:29:00 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC6492E0C1;
        Mon, 23 Jan 2023 11:28:53 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id x4so9649064pfj.1;
        Mon, 23 Jan 2023 11:28:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LQbopvBj+BKBokjG+wslvSo4KZa52H8rN7zi6aOGZj0=;
        b=Qzcxv9BF7oi7XXqffi4hOCTIIc8Pk9ftKrcqSW8P17KC+CCaKbN4ooY4AEKs/ZEdPL
         EZLPU8CcFp5C706elzCFxKraTiTNOEZBPwGaSBNWGUb/HQTm0P8lau5RSZi86fV1bZ5P
         DK4C/3BMeUqLS5XFJyYF+jcVILUmxIbz/ex6K19sFkJAR1rf57Ys4CPzpJ63y/avMAyb
         t1V9xoQsnifh+kpFSQuSB34ec3ILdsFLwkhA7LCd77vzvnrovivJSTFjDAN9ywiIuEWH
         5oe0wYrE+h2sHWW6209VuM0bJ0JX7XuUDxDplLMpacA57vo4wKJfa33GryPTrsGvtT5T
         kqJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LQbopvBj+BKBokjG+wslvSo4KZa52H8rN7zi6aOGZj0=;
        b=TLCQmmhFWzAY0VeMG+wOlFBqAPR0AwPIq1PhvaQ6ISbYY0a16V1CdL3XyxP7BKJuwO
         8isZIlWZ94tBg7MUSN5yzztcAypBdEbbg4Wrfo+wTCM1ehX7kXrGMJnNsD793+wl2H2I
         miK7MuxKkANXPIZTUVUI2yKHDf7ue3ckIHF108Un2JhfMN7qJnbnvFFguv41PW26g+nA
         BZtDZbBA4DEz4KrwGNMcgJS8n75A1TSqRH/8AQsDATCDQbvFMKngg68KtZe2NhY+vg9E
         Xfgyjo5qc7jdyG2Bhsfca6HyWjDBgohpdsFcxphsJx+a/cXsVRl4Tkdb9HttZaSZerAv
         j4CA==
X-Gm-Message-State: AFqh2koU57G0cYrto+zZ31Ot6RUEAonQcbxmcF6ERgAVFb8w8zpABHfO
        VqgUMQ4uEE1KbGybnHwlPXs=
X-Google-Smtp-Source: AMrXdXvJNhX30buiD3QeyO+hXA5MI3vqDrLuORt9nvYl6AjUhlSTdPa0GErFbZG0rWScEYS1qLgVgA==
X-Received: by 2002:a05:6a00:1c95:b0:581:6f06:659 with SMTP id y21-20020a056a001c9500b005816f060659mr26038056pfw.6.1674502132887;
        Mon, 23 Jan 2023 11:28:52 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id r15-20020aa79ecf000000b0056c2e497b02sm16655561pfq.173.2023.01.23.11.28.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 11:28:52 -0800 (PST)
Message-ID: <18773a19-ede9-bd83-0fa7-2790556f480c@gmail.com>
Date:   Mon, 23 Jan 2023 11:28:43 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 00/98] 5.10.165-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230123094914.748265495@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230123094914.748265495@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/23/23 01:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.165 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Jan 2023 09:48:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.165-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit, build tested on BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

