Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1231E6B581A
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 04:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbjCKDkQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 22:40:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjCKDkP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 22:40:15 -0500
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA6711F624;
        Fri, 10 Mar 2023 19:40:14 -0800 (PST)
Received: by mail-oo1-xc34.google.com with SMTP id p6-20020a4ab386000000b005252182b0e0so1086052ooo.6;
        Fri, 10 Mar 2023 19:40:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678506014;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kgezN8INYSZHjuwQgUy5QlYxATMrFNIactDDwCM7oOk=;
        b=LvSXTIxAI3mq/JnRMLX7y3WgV4r9oY5xGDoqbTNJ9PHl0OsBnrIpdd7SqSPwkKfLze
         3YXHTfdEz3RmQv2zyZpRnntQ9dG0WBmnEiLM3IofEAnLIJo8zvCfGZYE676uUru5+rXL
         ONyQ8LTpAgBIsgTPA67BWBgXKE7QkOpCPkQH/1AUM2VfTJvPacoelJXGcopI7+t1hlor
         xMoeRZQQVP/tizaN1YGdPTsauYEYbf5ch+R2YX1LFqbuVrIVS+/Tuo9UrI35Ypse1jGx
         UUxtfKC91TmBJiLzZU/3LsFZyHUR3YI1D+9/RIXYlXdlaZDk8O0WhlF2RGJ7oHy+wzBU
         OR1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678506014;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kgezN8INYSZHjuwQgUy5QlYxATMrFNIactDDwCM7oOk=;
        b=SC/BUPrTUOuLcFH076pRwMlKvDsUIEX4QYLR9ICyEae46iP+S6BQsM+Bg3Dc/s1Y7N
         +wUgyVP7m23d4KByyvFOQhx/qtuHnh4iBUx2l4D54Y+bsOTK2P05dWPBmyp9khZRFHKQ
         Gseex2KzrXLfwgMyMInskGKTgRAM5W42DC25/V4pl/G8aLFXtAJHD/WPWKpgP0UY4xWT
         vpeceSCrTWlOOHZb5VWTzdW6Is3Gpa/9/tCxX6PphxOTBu32O9SnBuxlECazWXE7X22I
         cxyOUiuuP4Jj/1bW9vML76ssXaDt8c3itQt+VK4R9mr0z72JBRZLX9eFJCcsGnzs+D/v
         BGQA==
X-Gm-Message-State: AO0yUKWUVDV+gV2SHkZF1aypMK9WVWfhQDBN/E5QsgeaY7GBOLV0dPXr
        XjQtjB9ap1apusw8WHnYCgE=
X-Google-Smtp-Source: AK7set+2kwEJsAEwkwZazC0fhwfp8PYcF1Uph/l5f+zjmp51oFzGh1I+f/zaqGlPcevTX2OxkiIkVQ==
X-Received: by 2002:a05:6820:104a:b0:517:67ba:586 with SMTP id x10-20020a056820104a00b0051767ba0586mr3225912oot.3.1678506014064;
        Fri, 10 Mar 2023 19:40:14 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x5-20020a4a9b85000000b0049fd5c02d25sm669748ooj.12.2023.03.10.19.40.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 19:40:13 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 10 Mar 2023 19:40:12 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/211] 6.2.4-rc1 review
Message-ID: <68bd3efc-1a5c-4636-bcd7-bf7defc073b0@roeck-us.net>
References: <20230310133718.689332661@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
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

On Fri, Mar 10, 2023 at 02:36:20PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.4 release.
> There are 211 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 517 pass: 517 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
