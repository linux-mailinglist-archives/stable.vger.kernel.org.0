Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1FC64BCB6
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 20:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236695AbiLMTGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 14:06:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236723AbiLMTGc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 14:06:32 -0500
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D59CAE72;
        Tue, 13 Dec 2022 11:06:31 -0800 (PST)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-1442977d77dso13773581fac.6;
        Tue, 13 Dec 2022 11:06:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=koNp7ZPutVcD4qQ3Y9JWftj3ajcM/O99x4q/w4wE8kI=;
        b=dfL2u8z4jbcIQuFsiCJwbn7x/YxX/PyFNpkuQEvQCC4ykFiOc1qFuYz2/Fn6YYTAvz
         6aeZpDK3MA8awnEJC7C4s78aqgyDPHA3pdB0l6pAOop70170o2j88lcb3ukiULw4sXgd
         gb9PZ8PlW7xYnfmvX8kQ4+OwPQ/AdvWmWa0I911JvYoEN3pWNeDl+NR1iGAQxWWnEReD
         wY4At8u+qt4L3QEzIkK+quXkkDUpjYLXI7yyymB0Vy3a6DOgdOYD3HQhtaIbLg9HR2Rl
         xhhhTVN89GzipGNu3ibt3kcqbAvjAZ3RmHKXjtxQ0wt/oQ0j2JL1SmhL04sSybfPQep3
         Oocw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=koNp7ZPutVcD4qQ3Y9JWftj3ajcM/O99x4q/w4wE8kI=;
        b=l6q9XxgD1x9pSSlT39Ju6q5jsEjybyE8cjxr52axtiSuZTmOo6SeXVW9wa7PGNR+/3
         +1MZd7RbwyRgeSfdTn+fwDYG7JLGltCddPseoghWZmszK1XB0GUwIIakdLfaHxeiZljc
         ja+X+TC8B/FClbu896WyVLHP8TxIdhB1tszC/M1FU3Y+H30OfC3Hwp4UdwLEyxDjHTaZ
         +JAy25tmjqb6WXPJKHHSHkjLl9402YWISwMJy/n1wEeotdMv9iWJgGwpNuwp37sfZVLF
         ARaL6Ar4NE7rvYkgUQGB1g/UQ85wlZdwmWGlXlL/Td/50tzNJVGoUtf2WLRmjtGlK5Kd
         34/A==
X-Gm-Message-State: ANoB5pkTW2ZcTlqn3MsqB0BWWt/qcEEJiCiyG7LHCfytMKCnGSZPeDsA
        w66IhIUB+QQsnbWKG/7N5PU=
X-Google-Smtp-Source: AA0mqf5R+M+eG9DcifGZmSIExwUM86fVy3r1jiti2wpgFFNTTQ2EREjBHpXshp77AsqyxNIIZT3JUw==
X-Received: by 2002:a05:6871:87:b0:148:592f:83d2 with SMTP id u7-20020a056871008700b00148592f83d2mr4843218oaa.6.1670958390070;
        Tue, 13 Dec 2022 11:06:30 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a36-20020a05687046a400b00144705fdd02sm1764447oap.43.2022.12.13.11.06.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 11:06:29 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 13 Dec 2022 11:06:28 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/98] 5.10.159-rc2 review
Message-ID: <20221213190628.GA3944422@roeck-us.net>
References: <20221213150409.357752716@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221213150409.357752716@linuxfoundation.org>
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

On Tue, Dec 13, 2022 at 04:05:08PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.159 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 15 Dec 2022 15:03:44 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 475 pass: 475 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
