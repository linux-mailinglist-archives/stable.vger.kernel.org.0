Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6306B68AD4E
	for <lists+stable@lfdr.de>; Sun,  5 Feb 2023 00:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbjBDXCI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Feb 2023 18:02:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231448AbjBDXCH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Feb 2023 18:02:07 -0500
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AD1B2748A;
        Sat,  4 Feb 2023 15:02:02 -0800 (PST)
Received: by mail-oo1-xc35.google.com with SMTP id y13-20020a4ae7cd000000b0051a750e2ebdso129585oov.5;
        Sat, 04 Feb 2023 15:02:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aJ0+krcbY3WL7q08WP1cx/1zC6fiLkizNntUPLraJrI=;
        b=evSkKOLksPSEKuNHR58hNmgSVknBlpAokZ7kZmbqDhG8WFaWyp+uqz4PEt2lplKt6W
         s9huChIaJN0lBFVBsRjmGEUBpMAQt/6TIywcL8FYsX8BYOH1pQsI8FoyzCH//T7S20dN
         11J4HmtwZGYpCNI1rYt2E0fQo9hgIth37ShMRmIuGfSgCQOzyLEQDD12Oof2atqdc5MB
         6ktaYnl9EBdtGlGQm8gsdfVABHFGTuM6a4op6y4VQRh1pKEc7LzTc3mwwHFyjeln/lYg
         Cise3LWurI9mXcPsth/qKdKIOt7B8ltboBkxAIwGhtWg9jR9ZKIdf95Y9/RmrdslRrrv
         agng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aJ0+krcbY3WL7q08WP1cx/1zC6fiLkizNntUPLraJrI=;
        b=dMWOYkICFRD9YjIMnnmx3O0RYq1IU+MVi3jME8z+rR24iXJ5tKAzIvZ+F9jIwn54q5
         8xNdTBxRInTzln4PKkhJin3JIb3/LZjWKK//zoFYZuBPeEf7/lEJBLXlrfyIZikyaC/M
         JdRcbPnYDgRFRj5vPzdF/bYm03BY5zNw83L6qb56jh8jk+OjAeWuHKLR8wvRGIl36aXs
         2kUTAD3ju3YuVh3hJTuQcpUhWDwkgvzaG6FoYPTA3RF1+sZr9fVioTMgCCPRjzB7h9sW
         RzPZr78/OxNtQsZ22143NaECWo3i1CkN7tSTBTip+a6MHaquZ/pW8rMl3XEVdnPgMNti
         W7PA==
X-Gm-Message-State: AO0yUKWm9Ecq502nrJlavGzwO0Ua7rD0gBl9do+u3IP2WQNR/QLKmx9k
        DCDt31E/SMMTQovO93EJXG0=
X-Google-Smtp-Source: AK7set/nmffb/dPq1BcM/yMms9PqlmgcT2wD0f9xcCr2vVd41PrHN9FImLFt/+T8/XnJ05YLq89CTg==
X-Received: by 2002:a4a:83c1:0:b0:4fb:cef6:5c9d with SMTP id r1-20020a4a83c1000000b004fbcef65c9dmr7933037oog.9.1675551721574;
        Sat, 04 Feb 2023 15:02:01 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c17-20020a4ae251000000b004f9cd1e42d3sm2536820oot.26.2023.02.04.15.02.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Feb 2023 15:02:01 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 4 Feb 2023 15:02:00 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/79] 4.19.272-rc3 review
Message-ID: <20230204230200.GB114073@roeck-us.net>
References: <20230204143559.734584366@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230204143559.734584366@linuxfoundation.org>
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

On Sat, Feb 04, 2023 at 03:42:31PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.272 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 06 Feb 2023 14:35:41 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 426 pass: 426 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
