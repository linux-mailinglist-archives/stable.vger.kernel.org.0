Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42FB56A8EB6
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 02:29:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbjCCB3F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 20:29:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjCCB3E (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 20:29:04 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B243544A8;
        Thu,  2 Mar 2023 17:29:03 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id g6so387182iov.13;
        Thu, 02 Mar 2023 17:29:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677806943;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HkH3s+ZPeSK2ETwzaKsgHIZ992yhpPipIE8vUYZJw2Y=;
        b=RtfAOKC+mJNSD/uhNtJYRRI9TVyniOecmxhygUNLsTlaAFt8o75McIkhfCuG1rW9yF
         Uu49DVgmOaXWXV/+FlLrzwcn+yZPcBszhAv0xhhDB+EQbaK/zMwZd4XiFl0bwtT/a/jI
         MbePKAf+imN1TZs67X2OA6iyc9exqnkUcNIj9GCCrkZZk6+u+Bx7qWzmeqdORb4KMcs2
         2lUCc01qYCOA6TF+FYbI+mWbxjkX++ywaACupJufsXDZWQDkdt08weZ+tDECOlH5LTO0
         DaBiqXEIau/+OlaWhKbLBlhlCI8KanEkkiBJ/xQkal7I8hbWWLmCyCdD17Y6ImpqXJCr
         CTFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677806943;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HkH3s+ZPeSK2ETwzaKsgHIZ992yhpPipIE8vUYZJw2Y=;
        b=bfFOnLCrI0dYgX1k1Atp5eKNMxDSgLDpmDPVbwKBL26ZHtIaTCUP9BZBcLOsIHgK9G
         VkOVD1ysXfDvTzFRqkz7FnqDts+cqupu46YG0oe+d37+Rd88eHZ+W2C4BvK9R7pz/SQn
         kqauAog9+I9UZxgdKVfI+2DoI8j0D1blqT7DdOuvDyx6inAQIHQ64v2TRT1GsxYisKVR
         kM83+hLavwj00ceMm/AnFgCN6mp9X2IaCV7YlliInnlSUeZXA+KRZm8pGQze1EliGXze
         RwVU4mCH/xKlSbDU3uduMtkUaFJujkY71ZFOe8J8Jxk7fQtTTOFDisU+1Etf4z/3mKCE
         um1A==
X-Gm-Message-State: AO0yUKXINW+0tL3o2l5oDCdML1hip0//LOV0quF7uX2v/JRVXAlra1HW
        dkeHvNZ/9KEo++A2F1CS9lM=
X-Google-Smtp-Source: AK7set+8vJqsimfDBLj2Ki24EIQx+jOP3oQ1Vr3i5u/Tlq52h7zM7Ku53IbNYgTBunG8ag8NOxaCbg==
X-Received: by 2002:a6b:e415:0:b0:74c:bf8f:4c88 with SMTP id u21-20020a6be415000000b0074cbf8f4c88mr8409207iog.14.1677806943078;
        Thu, 02 Mar 2023 17:29:03 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m10-20020a6b7c0a000000b007456ab7c670sm293056iok.41.2023.03.02.17.29.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 17:29:02 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 2 Mar 2023 17:29:00 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 0/9] 4.19.275-rc1 review
Message-ID: <2ac79950-8503-4e7b-addd-dc1e31abbc5e@roeck-us.net>
References: <20230301180650.395562988@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301180650.395562988@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 01, 2023 at 07:07:16PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.275 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 426 pass: 426 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
