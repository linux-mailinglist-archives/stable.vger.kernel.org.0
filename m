Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68E3A6BDC1D
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 23:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbjCPW4X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 18:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbjCPW4W (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 18:56:22 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E39E733B0;
        Thu, 16 Mar 2023 15:56:21 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id o12so1523523iow.6;
        Thu, 16 Mar 2023 15:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679007380;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hDpvgOSsuY/2GnvL/uSSjTeWF7CAJklQR5a+KBFCNTI=;
        b=QD22eGZryUhuG4K1SoTWJhSPfIAPYfd5MN5wUXGLN/bvvYXaTXxRc0wic0WufIMQUe
         MEMlo3nwDdQru6suSN/dGoIzjgJCuzAlRIN4496F6z4gPztmf8F2o5i6BtSPOoc4EUcK
         h3UXlNo93LXy44W++3vWTQk8Xs9YpFo3iFdZpBex5h3ECxdO86Jw53Qvo9F6h1fiQjj+
         pZNDRP/AKXyu8DUJH0MSc6oAzEen7TNlKWgShGXXqCUCvU61iP+yDAuURDZMzsu4q4OB
         C+jJT6HylY4MbdxI4unqMxxP7zOYRZqtvbgWjF0hOHYUs2/UwHXwtSeci9QmEowQ1GLp
         jOGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679007380;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hDpvgOSsuY/2GnvL/uSSjTeWF7CAJklQR5a+KBFCNTI=;
        b=UpHS7CXiMWIP1vwgydGI3cvWDxnJF8SFi/iKDbq+YpGfwL8Qthq7uudBOmdg+cB/fF
         uVXPAYqgI5t3brzM7JNXJC7lgtxZBxHI/YUdHwozQtiV3qW3Uncv67xDSl985IfIvaxr
         ZDsSVKP6KV0+QtWdSIa2JgcgyiPvGNcrK6VgQg5TTl9yeZ46NYsaVSUusVfiJaVhEWYs
         4JqvOQDHuYGbWVwU4tR8ShsRnpZpNF+23fkVCwq63eNbqwVUmxApJWBstLPc5VpBJ8h9
         o3RzRCAIZb6CsU+/LYGuXl15jdnynK6dkOT6mU21LXfPfWSYUV77IYnVpkpHmqs1Z1O8
         OqsQ==
X-Gm-Message-State: AO0yUKXfyh6/wlB/782wBoR9f68wWlotO6PviA2yoSpB/d5twqBIUI+e
        qebEwkSlvK7lEzKy60jRz/E=
X-Google-Smtp-Source: AK7set9fD0y7OrdiUScFu4QM2EH4sAHIFApZTwL2GhUsunS2ZJer7jFcnd2Zj66IWbvq05SLtcEHcQ==
X-Received: by 2002:a5e:a80b:0:b0:753:26e4:4e43 with SMTP id c11-20020a5ea80b000000b0075326e44e43mr427059ioa.2.1679007380358;
        Thu, 16 Mar 2023 15:56:20 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id dl9-20020a056638278900b004051a7ef7f3sm167847jab.71.2023.03.16.15.56.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 15:56:20 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 16 Mar 2023 15:56:18 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/91] 5.10.175-rc2 review
Message-ID: <30638d38-cdfb-48cc-828d-c2b257db8fba@roeck-us.net>
References: <20230316083430.973448646@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316083430.973448646@linuxfoundation.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 16, 2023 at 09:50:03AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.175 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 485 pass: 485 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
