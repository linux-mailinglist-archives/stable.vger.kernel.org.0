Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6275AF743
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 23:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbiIFVtq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 17:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiIFVto (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 17:49:44 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14E191127
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 14:49:41 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id b142so10032551iof.10
        for <stable@vger.kernel.org>; Tue, 06 Sep 2022 14:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=v4peSi0J5F8e7RsAi9ZhH5Oiu5gg/v6leFkLgqq6ry8=;
        b=DgKDqE2C2wjy5RDiFJn7/bBPhBF6/iODrWdcJ+fRblweEPzyXE6x9SebUrivMor7oT
         MqfQUzVSAZcMgRfIxnVyz0mVmu3XSBXu7CeqnMr2AddCXoLhrQxETWFXst4IPQCHD4Rj
         gm2oSIjDyIYNJJCY/CQ/jPMGheXGmYee4QMx8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=v4peSi0J5F8e7RsAi9ZhH5Oiu5gg/v6leFkLgqq6ry8=;
        b=Ug6IV8J4nz90fpEvdlLZ/FpbVp0eXDBW9Pp/HDcDmZB8ZxzDVp8HFaiRQ1UauIAjj+
         i5yxlOGI9HScFgxHochwDhAy79pzOwrwjAJbVSuf6oy+mRX/iTnwYJFw2KhA/hz7dIOj
         cxBjCOSJ2K6wjSNdserlIucmGnXnVwLcF4p8buMWNMg9Xk43PWeRqzJjHlR6lw+C49u0
         p4fQdTM2RIqte24U6m7wGuSS1yeIhajn6hlNd0+xA4HCFlVCyiG63LyYaJcsMB62f58n
         sQBs/kTvW+/fAbC/D2Y9HKQgSWrHYXeNxOxeHzjiC3I0GxGEvYs5IDJtni2e9R2jLeEu
         3tlQ==
X-Gm-Message-State: ACgBeo1a3BCElDkCtl0POfuDS1oZd0wXGsE0NPNFCvnofo+aWz4fG3wU
        Aj5bT7rXdWRyNIbyd3vIh3sUMg==
X-Google-Smtp-Source: AA6agR7jOno1u5vYNA7iEEVOFQ1tl0BTwM3k78QrwIGSKNG8sez621c5Yjcc5qq1ZY47M0ZmRRkJ5A==
X-Received: by 2002:a05:6638:2042:b0:34c:f22:25b3 with SMTP id t2-20020a056638204200b0034c0f2225b3mr373281jaj.75.1662500980882;
        Tue, 06 Sep 2022 14:49:40 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id o3-20020a0566022e0300b006814fd71117sm6451785iow.12.2022.09.06.14.49.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Sep 2022 14:49:40 -0700 (PDT)
Message-ID: <7933c735-3070-6196-263e-7f14e2e2da27@linuxfoundation.org>
Date:   Tue, 6 Sep 2022 15:49:39 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.10 00/80] 5.10.142-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220906132816.936069583@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20220906132816.936069583@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/6/22 07:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.142 release.
> There are 80 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Sep 2022 13:27:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.142-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
