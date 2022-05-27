Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 099B45366A5
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 19:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354325AbiE0Rjf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 13:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242147AbiE0Rje (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 13:39:34 -0400
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3002033E8A;
        Fri, 27 May 2022 10:39:33 -0700 (PDT)
Received: by mail-oo1-xc35.google.com with SMTP id a16-20020a4ad1d0000000b0040edb942aa2so538834oos.2;
        Fri, 27 May 2022 10:39:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:content-language
         :from:to:cc:references:subject:in-reply-to:content-transfer-encoding;
        bh=I6HOGFSxNQDDGOTWhVn8r5BpIvXIWSlvbbgfCYlyHAc=;
        b=D/UUNN27irIC1QvXVRm4qc4lbh1rJeaKLmBPGlJCJGZmMVcnuoiawav3cxN48R5PK4
         4vH6ORADg8S/fk+GF1qeO3UN621N80mbTo9hvNgNiovzly/v1LARumlMe0zn2p1akkLc
         49cmK4xD+s90Kc123F8iVAGqdY3zF/0zoYmY0t3BjeAaiySQ7U298kNY9KS/inm3e1jm
         uKMaT/21K5ni5ImEJJHNZnpk0Lm2gsxVV23AHSLqPiXJamOXJ9OWqS+0OaJ2A8iSu/fR
         QqZ3Xo6Ni/x7Yi4rMnlAYx8zIVVsCepvKII7GEmDMgoIrVAI3cPqk9/2hAyjppLr9dCo
         pQ+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :content-language:from:to:cc:references:subject:in-reply-to
         :content-transfer-encoding;
        bh=I6HOGFSxNQDDGOTWhVn8r5BpIvXIWSlvbbgfCYlyHAc=;
        b=S2uAEDM9DLYjX/RElXWX7QvyzCViy9/RBKg3v6iY5EuW/dpRfH+dKkW6JHGhwbwJmm
         nODJWkvzwIa5PLn0EZ6OVg12wey9o9oLsnyxsQz3+aRk1xoIS4jp6/Z5Vw6CpwVU+U6n
         DBl64Ogkp/oHhVVetq2I1kC0Nn+AMqXm4OdKG0Y5+KQkEeEFLq3e6WjmLV7aK7IkFOVY
         8SFLV3XhfJziAgv4Hpp1/PT5862PkSusALb0pgVZWiDmMvRsTrzVoIPY8S5wuBwIO4tk
         Er/EcZPEQSp5cH8pAxmORV0AdRuKRc00QoTX6c/b1Mf6ZMMvH57KaCgrI4vBQy86gu9p
         8AGQ==
X-Gm-Message-State: AOAM530/j9qpq1eq5L49St/s1XYN8FN4l71G16/YKOuWpUqGzZkEi24u
        23MjPQdOBQJnTh0nzZ+Whgo=
X-Google-Smtp-Source: ABdhPJyTQ5diirtYkSAvoXK7Cge8tAKUpNH7YKn7qniiepJSrki3vby74BCc4IEH0rRk408/iTJOQA==
X-Received: by 2002:a05:6820:180d:b0:40e:ae98:5986 with SMTP id bn13-20020a056820180d00b0040eae985986mr6720256oob.77.1653673172274;
        Fri, 27 May 2022 10:39:32 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h5-20020aca1805000000b00325cda1ffb9sm1881056oih.56.2022.05.27.10.39.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 May 2022 10:39:31 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <80d40405-7105-4427-c2e8-5b63e45878d3@roeck-us.net>
Date:   Fri, 27 May 2022 10:39:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Content-Language: en-US
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@denx.de>
Cc:     Chris.Paterson2@renesas.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220527084828.156494029@linuxfoundation.org>
 <20220527141421.GA13810@duo.ucw.cz> <YpD0CVWSiEqiM+8b@kroah.com>
 <6aed0c5c-bb99-0593-1609-87371db26f44@roeck-us.net>
Subject: Re: [PATCH 5.10 000/163] 5.10.119-rc1 review
In-Reply-To: <6aed0c5c-bb99-0593-1609-87371db26f44@roeck-us.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/27/22 09:59, Guenter Roeck wrote:
> On 5/27/22 08:53, Greg Kroah-Hartman wrote:
>> On Fri, May 27, 2022 at 04:14:21PM +0200, Pavel Machek wrote:
>>> Hi!
>>>
>>>> This is the start of the stable review cycle for the 5.10.119 release.
>>>> There are 163 patches in this series, all will be posted as a response
>>>> to this one.  If anyone has any issues with these being applied, please
>>>> let me know.
>>>
>>> Is there some kind of back-story why we are doing massive changes to
>>> /dev/random? 5.19-rc1 is not even out, so third of those changes did
>>> not get much testing.
>>
>> Did you miss the posting on the stable list that described all of this:
>>     https://lore.kernel.org/all/YouECCoUA6eZEwKf@zx2c4.com/
>>
> 
> That describes _what_ is done, but not _why_ the patches needed to be
> backported to older kernels. Normally I would see those as enhancements,
> not as bug fixes. Given that we (ChromeOS) have been hit by rng related
> issues before (specifically boot stalls on some hardware), I am quite
> concerned about the possible impact of this series for stable releases.
> 

Here is the missing information: This is required by NIST SP800-90B [1].
Without this set of changes, Linux distributions are expected to fail
FIPS validation in the future.

Guenter

---
[1] https://csrc.nist.gov/publications/detail/sp/800-90b/final
