Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83BB95109EF
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 22:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbiDZUP0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 16:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354710AbiDZUPK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 16:15:10 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4919C186BCC;
        Tue, 26 Apr 2022 13:11:50 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id u17-20020a9d4d91000000b00605a73abac1so5817584otk.7;
        Tue, 26 Apr 2022 13:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DL7c1k2fleMIYo3k5VSixmo9EwBrNBVjTunwBTsu3Rk=;
        b=T4Q9XUhIKAZlcJcwYoGdPkBC7OPTbYi8hN+6bC6CU0AXOrSpUgAooLvWcxonY7nk+Y
         +/poFDj1CISTDPlfSp7CzgtF/4YbP/FhNeJ1K+S0a811gXxn8LzldrURu5DxeU/d49a9
         MwT+V7+S6EBI9noJWL2zoriVxi+SPXrUwC/5J3JfzIZK7lIOr7UpVJlFPwTBn3AKsOZx
         os/3lj9R4gn5K8H6SZcTjbW4Ydg0ly7H8ohZh65Z84x6lYyTn1wH1myejuCypsMNmHX6
         iexnLox/JTlkH48TC5pEtxd9Gf/qOHosKHstzaD3NWFCDVf/rFPJ8CQOLoF8KT2XXIYx
         su+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=DL7c1k2fleMIYo3k5VSixmo9EwBrNBVjTunwBTsu3Rk=;
        b=r0jIpj0DrnpRdOp85brxVWuz9GDdhBUF4y51sAHnYmHtOJrlToDs3og239E2KsN/qD
         XtKDd8acoCX0a9DrT0UeaIti+gvJH+FYFDr0MUzHIuCBbFKSq+DU+5GzMmejWBdZbtPo
         5+xCyDuIAHbfGSq4pxpjVUF2gzPLNJcKdR+1WzWzYyXXhvdIWTzVQtmaaO+1ehr7BWSo
         avkjz96PQVsPYPcq0gNnL+qh/W/ICcRea52Lqr+hoxnVPcEOsDiaoIgIl0J/oUtO+aHm
         wowbiJyjVqwzdS/EM+Ivfe5b2nL9jlkDFFpI2TdW6XovF4LVupbIWmOhrlA6q2UN0ClC
         N6tA==
X-Gm-Message-State: AOAM532VYgvEGaiZcOz/Uxr+iFpIJLtlnnStUMAXPeDWhLhJ2tU1KbFm
        L4VInVtGxlbw2EThgdKBlV4Op9fwBtI=
X-Google-Smtp-Source: ABdhPJwSvjsijz0MM1C8WJ1WE6qeR5OsHfsxaqj+pIN4FxbONZBFBJK3x8I/Lkxwk26xhRGGmUp1ww==
X-Received: by 2002:a9d:6283:0:b0:605:4ee4:6d56 with SMTP id x3-20020a9d6283000000b006054ee46d56mr8908832otk.89.1651003909061;
        Tue, 26 Apr 2022 13:11:49 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i26-20020a4a929a000000b0033a29c8d564sm5979224ooh.3.2022.04.26.13.11.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 13:11:48 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 26 Apr 2022 13:11:47 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.14 00/43] 4.14.277-rc1 review
Message-ID: <20220426201147.GB4093517@roeck-us.net>
References: <20220426081734.509314186@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426081734.509314186@linuxfoundation.org>
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

On Tue, Apr 26, 2022 at 10:20:42AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.277 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 Apr 2022 08:17:22 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 424 pass: 424 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
