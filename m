Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07A9856CE9C
	for <lists+stable@lfdr.de>; Sun, 10 Jul 2022 12:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbiGJKoj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jul 2022 06:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiGJKoi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Jul 2022 06:44:38 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8711B1033
        for <stable@vger.kernel.org>; Sun, 10 Jul 2022 03:44:37 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id b11so4422468eju.10
        for <stable@vger.kernel.org>; Sun, 10 Jul 2022 03:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=jNCgTHmLDrFQgl5hYEL9Z2XVMzJeLHgxaL3J8l7LRi4=;
        b=dVonWPqI0uUe+ldwP6CygYf9KDbhOe8B6Ua26MUE9MxAjrXVhxzBa8KIQPEXyS0ttg
         /6gBEVs2Ug3V8jsT5x/KfOHOX8C8LxU/2N+2t1mKqtXRVl7MSOy+xlKTiP7svx8lQgGI
         wEa6paTdNcMC3DnaHnNTj6O7oQNijiOx5lDWXDh+RdDPiLzHD8x/Gjl8gYaAXnKQgZde
         YffL7BAx0ZNO2rVo6kEq1GZcbasC6esaxBwovrPHkPqApKUXmZHa5jnVgy5qFoPjLjBD
         aTotFRDL6G/b1qxLaHwTs93pp4pXTfBvv998vU2GZxONhuA7mIlLjKcgc03nXrQF0lTb
         CfWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jNCgTHmLDrFQgl5hYEL9Z2XVMzJeLHgxaL3J8l7LRi4=;
        b=ZTWYaGiDW0X1UtL7CHs8bx857IrnPJtviMl1x+cH8GwkdoEKSZnWrljRc3Euq4JEBc
         edoP5N4/DiBOHePa4KSb39LlZlzLGbsZZ8NXcOcgs9afRRCdOKQWSvRq41JFUJ6oY8tq
         rBQYE/BiPQ2VbHGvyt5ENCPMj1FSPeNTrS9YoJ5x6Bg5yMGwwKs35XXfWVe8mmsKp2sJ
         2wioUqePUGXSLj0WYjPcDMzShifQyFv2OCtAeIAR85fBmLiMIqwgN78VmkLOZDUdC0JP
         SIhmwVg05dpG3yDzJEUiVnBHmAMLu+nUjFDcnzLRHa63/rf0sfkk884hJqKhpdAc5Mh8
         bmNw==
X-Gm-Message-State: AJIora+qLMd2zO8rv8ouHhHTexIzPxXydb/DKFDfSifJWe/XJd4SSpYW
        eUKLa1Oa6iDyksyqcpjS2kAV3kDfiwo8oA==
X-Google-Smtp-Source: AGRyM1uhBGsHLNoC60486n0HpMhCtGLJZyntKMIzDj2+bdgxAHYrVW6oDq6cU2TOSk4j3yB1T156ng==
X-Received: by 2002:a17:906:8a71:b0:72b:11d6:29fc with SMTP id hy17-20020a1709068a7100b0072b11d629fcmr12576009ejc.494.1657449875856;
        Sun, 10 Jul 2022 03:44:35 -0700 (PDT)
Received: from ?IPV6:2003:f6:af42:a000:bd65:5b56:da6a:a3d? (p200300f6af42a000bd655b56da6a0a3d.dip0.t-ipconnect.de. [2003:f6:af42:a000:bd65:5b56:da6a:a3d])
        by smtp.gmail.com with ESMTPSA id ce14-20020a170906b24e00b0071cbc7487e0sm1474687ejb.71.2022.07.10.03.44.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Jul 2022 03:44:35 -0700 (PDT)
Message-ID: <81f96354-cbed-26e4-9f3f-5287095ccece@gmail.com>
Date:   Sun, 10 Jul 2022 12:44:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [GIT 4.9] LSM,security,selinux,smack: Backport of LSM changes
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, theflamefire89@gmail.com
References: <4230dd79-b64f-14e6-3614-02e4acb3f284@gmail.com>
 <YslxiluWV9YnPPAY@kroah.com>
From:   Alexander Grund <theflamefire89@gmail.com>
In-Reply-To: <YslxiluWV9YnPPAY@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Please just send them to us in patch form like all other stable
> submissions.

Sorry I'm new to this kernel list. I'll send 1 patch of this series in a new mail (as a test).
Please bear with me if there are any mistakes, the next ones will then be better.

>> for you to fetch changes up to 911aa0e49633be52c7a2de8c99de87b6bf3a7604:
>>
>>    LSM: Initialize security_hook_heads upon registration. (2022-07-09 12:51:42 +0200)
>>
>> All commits are cherry-picks/backports from mainline.
>> The intend was to apply the last commit ("LSM: Initialize security_hook_heads upon registration.") with as few changes as possible.
> 
> Why?

The conflicts come from added/removed/changed hooks. As noted below those changes seem to be valuable.
It is possible to apply the above commit first, but then every of the other commits will need conflict resolution.
Hence first I backported the changes to the Hooks and eventually apply that initialization change which also allows to check for
differences in the hooks between mainline and 4.9.y.

>> This revealed added/removed/changed hooks and related changes which seem valuable to have in 4.9 and via the CIP in 4.4 SLTS.
> 
> What is "CIP"?

The Civil Infrastructure Platform (CIP) e.g. maintains LTS kernel trees which are now End of Life but still used.
They call that SLTS ("Super Long Term Support") and there is e.g. a 4.4.y branch with backports from the 4.9.y LTS branch.
That kernel is e.g. used in many Android phones.
So in summary I'd like to backport changes to the security system from mainline to 4.9 from where they will be backported to 4.4 (by CIP) and from there included in Android builds still using the kernel.

>> For additional Context: I initially backported those directly to CIPs v4.4-st14 and tested those on an ARM64 Android device from SONY. [1]
> 
> I have no context or understand this, sorry :(

My bad, I forgot to include the link.
It is [2] which describes a bit more details of why I wanted the changes in a kernel tree I maintain for a SONY device.
Summary: The fix for CVE-2021-39686 benefits from the last commit (LSM: Initialize security_hook_heads upon registration) while the others enhance the security.

Thanks for your patience,
Alex

[1] https://wiki.linuxfoundation.org/civilinfrastructureplatform/start
[2] https://github.com/Flamefire/android_kernel_sony_msm8998/pull/24
