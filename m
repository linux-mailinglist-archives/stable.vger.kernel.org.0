Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42AB0616F10
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 21:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbiKBUqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 16:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231218AbiKBUqe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 16:46:34 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B71969FD3;
        Wed,  2 Nov 2022 13:46:33 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-13c2cfd1126so21611539fac.10;
        Wed, 02 Nov 2022 13:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1iyjE6WDAbekX6e3y9HLJeDLn7vVbZJppc4i/AAHGEE=;
        b=DplGn1y0YD9umK2stnXyO4LvAEXPlNUS0ACG5cIUkiVwW2ksxzcv81XolVe9gPq5do
         bi2bhXeW9YEP+8pguqzq2Fq+og67oLoxlmdcLLEedIn0dtGQoflbov/wFmykuoEYSde7
         Amd2qRYsUrl/E2+ibIIkLTvrn7wMY1r9CfraSYaIstfx2WLIDhJrlTBbjcVHTKJ9WLfb
         XIuYdtXYYGfhza9HUA0WK0bCQtbma927eE3RPKBHf3UnJt2CqVNpPRtaqecDeY/BbMRv
         a/oEQ0r2dsnQ6YebAp3gLW7RrXNRTQCq8zNQfge4ayjhMNgLbsa1RBrNOuaxGOxxahi3
         +i4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1iyjE6WDAbekX6e3y9HLJeDLn7vVbZJppc4i/AAHGEE=;
        b=l7ZtI30GPjjsmkxMNxo0qO5Z1weJiySvEZqe+GkHoxaIi6JiQk1OdQ/SRgVa6js9Xt
         GD4kB6bqJcM+XSbskBxyWbTbYaUF53mRzLsO5OeXqqfLl0Xkdvz644h29u5wJnfvDvqD
         sjRWkkNjjBwmhjuGUa6t8cEnwA07zFsnZA+0Sh39J9VgAjd4/xrw2Z5ZLx3v7+YrgBu/
         XppSdvwOoHG20KOOLnpcl2LaDiO8XFXSn9+eZwX0uUPvuMkiJpP1nWYQ2ercOekmBjWr
         EsnzD7bz5VfG12bnkHK5Fct27ZTe3m0emSUIkwD7aAz8GnXCBgHX1HvZOVnoP3tkZChv
         bGHA==
X-Gm-Message-State: ACrzQf0/T8ZWuM+rsszOpE8rXtVuGfgmkbBZCZ9HUngLuw4D8lBniowz
        3OuF7bol/rYYyU5g+OTNleg=
X-Google-Smtp-Source: AMsMyM5xNWlVOlwbbFKTebSgdpXXHqnAiBdz6fB3CewAL5qdNNnPv2T5x0wfV/AjH7kfauW9JCxw3g==
X-Received: by 2002:a05:6870:51f:b0:130:fee6:8295 with SMTP id j31-20020a056870051f00b00130fee68295mr15972296oao.49.1667421993088;
        Wed, 02 Nov 2022 13:46:33 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n63-20020acabd42000000b003458d346a60sm4878370oif.25.2022.11.02.13.46.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 13:46:32 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 2 Nov 2022 13:46:31 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.4 00/64] 5.4.223-rc1 review
Message-ID: <20221102204631.GE2089083@roeck-us.net>
References: <20221102022051.821538553@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102022051.821538553@linuxfoundation.org>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 02, 2022 at 03:33:26AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.223 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 161 pass: 161 fail: 0
Qemu test results:
	total: 447 pass: 447 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
