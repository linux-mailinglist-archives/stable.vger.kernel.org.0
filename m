Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEED8610203
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 21:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236727AbiJ0Tye (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 15:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236723AbiJ0Tyd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 15:54:33 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE742195;
        Thu, 27 Oct 2022 12:54:28 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id b25so1911395qkk.7;
        Thu, 27 Oct 2022 12:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=L3SZEZa2CJV4SjO0lun68s17zx0qUNNwhmx2jM0d8fw=;
        b=a1VqFrUx5ufOx8Ndmi3Yz7UYzK6rz5jSxFqxr/oHJ2tuKPgqrAhVQCwrgLoNpzKVtX
         YFp+toDsrkIuZ/5EgBc2BIbnUWSdvtuFuM36lLr69oxtcAUaGtZADkKwhwE0ztyoH1Nx
         gn3sTwmG4/5Ok8FkKv16ljzU+cpR1jnrKKBJPAil9dZ3WSSyCC8H/BVbbCs30/olP4Xq
         Fhnbj0v9zW6CXkjtK4kVkw2NH63PcPtaW5Lqd8QY9bqTetHMmFp/r0U2PfgMUOJqXARu
         ZMlzWU2yFBagwIge8BUQZJrZvbH5GNCjdEHGsQtgoEjGEFw+tvSov5L+XM4JuIP1roHi
         V+lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L3SZEZa2CJV4SjO0lun68s17zx0qUNNwhmx2jM0d8fw=;
        b=S4m9HljjP9HGm2tDxRBJcN7XIZt0CLlRHtIykP1sDdSLsfPBcPXVhbsqW8Tfy7zx6T
         vJKpaOkzzoxKk9PKPBKbjctFSJX2QmRzAnglh+IBKyr2fAUOl3yyYt+xizEaEjbXcMe+
         5vAqG2wxyKR9ulmwLl8paMfH5Z6D7gSdaA8sedNvG8SH2UNBWaVgt8EOyS0y3z6pz5vF
         TqcworcY8YPtsS5ZYNkTxhVqYbBdF8BeQ47Pe0efGsmHKjZSWO6Rg1UwUv2P5LIQ+lOg
         5zk1Q2Yq6rMu6McMQ1P5faGMPSh96dm3X7O4F5qIcqtEpujxR3F14tmgjW1DHzlMycxZ
         Gz/A==
X-Gm-Message-State: ACrzQf1+KQg8nY1gDlL6NeXEuc2g/9RAoaR1jrSdnUOewiq+WJFGZv5S
        eRkuZSFZdCrVGyhEjPUhZp0=
X-Google-Smtp-Source: AMsMyM5/3x/owzdlPKOOgN+JTLlnKbleEwOi3n4bsdz4hUh6J+BRXMMFedFYhMIGh9R+YX+bhp1C4Q==
X-Received: by 2002:a05:620a:440e:b0:6f6:2a11:c497 with SMTP id v14-20020a05620a440e00b006f62a11c497mr14149909qkp.213.1666900467381;
        Thu, 27 Oct 2022 12:54:27 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id h24-20020ac85498000000b00399b73d06f0sm1357418qtq.38.2022.10.27.12.54.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Oct 2022 12:54:26 -0700 (PDT)
Message-ID: <d1a46ccc-cb07-fa51-f722-c48d6c84bf9d@gmail.com>
Date:   Thu, 27 Oct 2022 12:54:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 5.10 00/79] 5.10.151-rc1 review
Content-Language: en-US
To:     Guenter Roeck <linux@roeck-us.net>, Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
References: <20221027165054.270676357@linuxfoundation.org>
 <8617f970-2a72-799b-530d-3a5bb07822a6@roeck-us.net>
 <Y1rbQqkdeliRrQPF@kroah.com> <20221027192744.GC11819@duo.ucw.cz>
 <ffeb2d7f-cfc6-887a-5751-d58545171526@roeck-us.net>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <ffeb2d7f-cfc6-887a-5751-d58545171526@roeck-us.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/27/22 12:39, Guenter Roeck wrote:
> On 10/27/22 12:27, Pavel Machek wrote:
>> On Thu 2022-10-27 21:25:54, Greg Kroah-Hartman wrote:
>>> On Thu, Oct 27, 2022 at 11:10:18AM -0700, Guenter Roeck wrote:
>>>> On 10/27/22 09:55, Greg Kroah-Hartman wrote:
>>>>> This is the start of the stable review cycle for the 5.10.151 release.
>>>>> There are 79 patches in this series, all will be posted as a response
>>>>> to this one.  If anyone has any issues with these being applied, 
>>>>> please
>>>>> let me know.
>>>>>
>>>>> Responses should be made by Sat, 29 Oct 2022 16:50:35 +0000.
>>>>> Anything received after that time might be too late.
>>>>>
>>>>
>>>> Building arm64:allmodconfig ... failed
>>>> --------------
>>>> Error log:
>>>> /bin/sh: scripts/pahole-flags.sh: Permission denied
>>>>
>>>> Indeed:
>>>>
>>>> $ ls -l scripts/pahole-flags.sh
>>>> -rw-rw-r-- 1 groeck groeck 530 Oct 27 11:08 scripts/pahole-flags.sh
>>>>
>>>> Compared to upstream:
>>>>
>>>> -rwxrwxr-x 1 groeck groeck 585 Oct 20 11:31 scripts/pahole-flags.sh
>>>
>>> Yeah, this is going to be an odd one.  I have to do this by hand as
>>> quilt and git quilt-import doesn't like setting the mode bit.
>>>
>>> I wonder if I should just make a single-commit release with this file in
>>> it, set to the proper permission, to get past this hurdle.  I'll think
>>> about it in the morning...
>>
>> Alternatively you can modify the caller to do /bin/sh /scripts/... so
>> it does not need a +x bit...
>>
> 
> That should be done in mainline, though.

This is the second time this is reported unfortunately, so while we 
could change things in mainline to avoid being dependent upon the file 
permissions stored in git, this really seems to be a workflow issue 
involving quilt.

Any chance you can run a fixup while you apply a patch Greg?
-- 
Florian

