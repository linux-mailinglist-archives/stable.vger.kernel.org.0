Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69048570A08
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 20:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiGKShU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 14:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbiGKShT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 14:37:19 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B84E16051B;
        Mon, 11 Jul 2022 11:37:18 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id 70so5499824pfx.1;
        Mon, 11 Jul 2022 11:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=dj4sgnLOADa7La7ienMnuisrBDA16QIFZgOwzPR6cyU=;
        b=OSbTTRMuaxhQ5OUW37We2xvF2IQf0Qz/XewJ1Diq7tqN7r0GDCteQjxX/c1vfZBOpc
         5OfKjnnLsFoWS4CznU7gJXbWDcaHNNedyv8aDQSEAjPMjx+Uj0qXJIfpucFipPK1T2L/
         3SelQHdIzSXXrLenhYzJOvNVtFfRu9WEf1ib9f6tx9DUSCKBQbUwcCtIL46c100dIAoJ
         JJCGn9ONZyQK+vX1k87FF4QL/Bn2b6loL+hHZq89iwhZxADlZcqiQdzchr2rhGMIjdKq
         9N6XzdITzjbUH61qDE49Zw3XC+JbMFuYt4eeJP1x7rkuDi+el4JNTJ1pGRv1Z5Jv26sq
         sYBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dj4sgnLOADa7La7ienMnuisrBDA16QIFZgOwzPR6cyU=;
        b=Lw+gY0VJESs2mjkpgQkOSVpdPXjUsaeSDnZSuQPce+7qAcIS6/YFEwoS90sx9Yv+qv
         B1YWW6vVdSX9h/bDHNvhGTVZwBYHpZWNc0R+HFlKVTIksGbaLHn9XBqaSainn85Yx7dc
         L8Q4w8Id0HM2LQeTattFRWL4ZTDXk48OYudodn3VKSo3vfxN2wFzk4QcmfdrUI8BuGaH
         oMijGgRkwc1P5wMXZa4awZaIkjgQyKzm4FAa28LUIxRPUTskXiZ1tMx1BJsEeDk5qJlj
         imfeGtDZue4Crk2PO2GBdyx31JeFDZ6ADLz6Qpsa4bY5sbdKj7GGQqYEgRIe1JO8R9Lt
         MUow==
X-Gm-Message-State: AJIora+Wn5WSIliUrlXnDrnZU48NvgC2qsP8LRZ5YsWnQoHEtIrrBXc2
        Lqb9ylvKio54oAW87kNPNQk=
X-Google-Smtp-Source: AGRyM1sGjDMRRoKkaYJh0NvJ5IJUiRdnUnxCd7Zsj6apJulns+mFe+KKMBSgKPfXcbRTozS2xZll8A==
X-Received: by 2002:a65:560d:0:b0:415:f189:2392 with SMTP id l13-20020a65560d000000b00415f1892392mr7469441pgs.557.1657564638141;
        Mon, 11 Jul 2022 11:37:18 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id mw1-20020a17090b4d0100b001df264610c4sm18335423pjb.0.2022.07.11.11.37.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jul 2022 11:37:17 -0700 (PDT)
Message-ID: <f8481b23-9cd3-1127-1abb-835fb32c78fb@gmail.com>
Date:   Mon, 11 Jul 2022 11:37:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.15 000/229] 5.15.54-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220711145306.494277196@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220711145306.494277196@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/11/22 07:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.54 release.
> There are 229 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Jul 2022 14:51:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.54-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
