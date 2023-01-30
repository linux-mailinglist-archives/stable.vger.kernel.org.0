Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7713D68169A
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 17:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbjA3Ql5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 11:41:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236017AbjA3Ql5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 11:41:57 -0500
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67B1240C4;
        Mon, 30 Jan 2023 08:41:53 -0800 (PST)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-15ff0a1f735so15737289fac.5;
        Mon, 30 Jan 2023 08:41:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=lQykz+ho0dzn//pid42h0j3Zw5664RNaB/N6NIgAdVA=;
        b=bzWlcPkEN7DoXeuoghAZy74wsaFYn7VDW7/q7bKZWkq+zGnrn2Nc+/esC+BZmoiS/Y
         h+4s2I8+v4tMJqebI5+Dt4MO/YfJAQMm/zaTl03ZOyBBeDchbL9ABiPfJ4KFQOQoTlR3
         IRPDzgIGjYNtQFRSxx60YYHJR7sW1mUewibsyHoxU2P4/SBNFfR3zTSEyYyuyE0YgJYa
         6eLhjR7Rb5Q08jSom9cCRobFRYrp55bHfePJTWkU2A/WK1TY95vugAAHCmbO36nalY7W
         nJIwtpfOfznzwgDbN61OnKzT/5sJR+ozx0wbTzI1zfrJMJWa+ZZb2X0IaIRGhz9fZS39
         tttw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lQykz+ho0dzn//pid42h0j3Zw5664RNaB/N6NIgAdVA=;
        b=x+6RZum3s3GKc6TJyFVgIwKzmiqixjFCTpQw9CT6CTiWGGMax7KFP6qteJBvLC+VuN
         jtyL/PpIvkgldyAhPeXKRY2RNrFGpqQGo9YMG9UQbI0+vZMtRkfNF5e70YONe0MYzSsa
         9QN5KShtMELjwjjG55UxaM0vtLSbatIHtDA+ywj8HYs/FA+BAHhxQ16D6yFQbGFQEON0
         60H+E/gP6sB91IeLdlcrXFsNMgp2wzNW3xr2eGMRdruYmas4OBbHYHuFD+CE8fCsHWZz
         /d3Epq2oVHQQZXFaxK5KJZgHkwKwC/7fw5qEkzTLKTCQxKUFLajFQSH1jZ+qPypeUPwz
         TDew==
X-Gm-Message-State: AFqh2koGnZHSQgPxyPaG+Pl40KHwuxBOwFrrcThzxWKfwPItWRrn33xO
        v9FT17fi2nfHiEBSCP7Zcgc=
X-Google-Smtp-Source: AMrXdXsHgi6SKqNcCm2Dwbkqgbbdu22MQPHCna+uJLvYJPCswiqpDAky5tWakbPzK4li+s81xKv+4A==
X-Received: by 2002:a05:6870:b30f:b0:160:3545:d167 with SMTP id a15-20020a056870b30f00b001603545d167mr15539104oao.36.1675096912582;
        Mon, 30 Jan 2023 08:41:52 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n19-20020a9d64d3000000b006884924ca4bsm5551478otl.5.2023.01.30.08.41.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jan 2023 08:41:51 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <01cb274a-1adb-1a46-0260-fbaee94feb8a@roeck-us.net>
Date:   Mon, 30 Jan 2023 08:41:48 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.1 000/313] 6.1.9-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20230130134336.532886729@linuxfoundation.org>
Content-Language: en-US
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/30/23 05:47, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.9 release.
> There are 313 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Feb 2023 13:42:39 +0000.
> Anything received after that time might be too late.
> 

Building csky:allmodconfig ... failed
--------------
Error log:
drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm.c: In function 'amdgpu_dm_atomic_check':
drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm.c:9397:43: error: unused variable 'mst_state' [-Werror=unused-variable]
  9397 |         struct drm_dp_mst_topology_state *mst_state;
       |                                           ^~~~~~~~~
drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm.c:9396:41: error: unused variable 'mgr' [-Werror=unused-variable]
  9396 |         struct drm_dp_mst_topology_mgr *mgr;
       |                                         ^~~

and other similar errors.

AFAICS it is missing upstream commit f439a959dcfb ("amdgpu: fix build on
non-DCN platforms.").

Guenter

