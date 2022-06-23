Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 084145589CA
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 22:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231643AbiFWUC2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 16:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231653AbiFWUCN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 16:02:13 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B82F0393DB;
        Thu, 23 Jun 2022 13:01:56 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id t21so612350pfq.1;
        Thu, 23 Jun 2022 13:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Y4tznLyjxyRj5zk1E6PeHZzqPO/sNCMAtjchxumNe1Y=;
        b=BbH1MBpDHaRkpF8Z8rM+CP6ibTKJj/tDxSpSDho1WXB85DfucOOvrwRPzhTS8WbS3/
         KpOySyJu6KYTIUWRChDyDOoadYGrYinyqhJtJ5Nxz/MwvVD+WlDWeBU9ipTDlpBORUHh
         qF8DpqJKrvZJetTc1LsdSYmziMyQhpfJS8ZW8lK94FAqlMieRSH9kfB8yq/wx3Jptco8
         UjF1DIEAXTSy/f0YxJ+MgdT1AB0Hj15pKb+QK/EAmIcJzWXg/I/ryKKFhWElP43g9RrQ
         YXiAHih4MbYHWZB/8N2GbW07eETiKjFGydG3UAGPJvoMp7BnxB2RIg8QwA6vGQDNPMCQ
         KBAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Y4tznLyjxyRj5zk1E6PeHZzqPO/sNCMAtjchxumNe1Y=;
        b=yHbU7DxqlPr9LvR7YdLJJlGtC1f6k0ES3MwBVxv63sZmwPTK5pAy7wD7I3JuF5stvZ
         U8//7x7+X12qWYDyAEnvu1xGZdqVGv4Mi1bQTwq678AW1ZsnIpwqBKXaXjQFspkIPLsX
         7wsj+T1cBDvO3fUI9RODTjiRRo6ircPyLE494Aasg28iNd3Hi43idJ5Ba3z7KLg6FF06
         9lgxOXBwK6qVLiiffUu4x9XE4udUKYv4OzNnZEM78xGpLH9sT9OTUCSAii5sw3fWvBYZ
         8StjaJPt89CzFQeuW6K5YY2q+EBfOCY9MjFfORkD43+i9ncda2drQxiQWnLt1ycjn3wK
         P+hA==
X-Gm-Message-State: AJIora/zuf7ObiMqCu1656HsGHFsoRJsEajQiqxnIB2GyRbPD2hKTKNC
        KpHOakJGTs+mxZGVJ/YLxlQ=
X-Google-Smtp-Source: AGRyM1s7G2i9gt13ZWjCE4JOzq+uUMd+xtg+Gm/E+cpPpenShkKjT6y+zC3VaFW7G2/NL4NOtQA+EA==
X-Received: by 2002:a05:6a00:ad2:b0:4f1:2734:a3d9 with SMTP id c18-20020a056a000ad200b004f12734a3d9mr42367101pfl.61.1656014516174;
        Thu, 23 Jun 2022 13:01:56 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d4-20020a170902f14400b0015e8d4eb2d1sm169042plb.283.2022.06.23.13.01.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jun 2022 13:01:55 -0700 (PDT)
Message-ID: <2638a5f5-3f4d-d23a-4ebb-827eaae89844@gmail.com>
Date:   Thu, 23 Jun 2022 13:01:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.15 0/9] 5.15.50-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220623164322.288837280@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220623164322.288837280@linuxfoundation.org>
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

On 6/23/22 09:44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.50 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Jun 2022 16:43:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.50-rc1.gz
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
