Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A761E6E87D4
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 04:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232798AbjDTCIM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 22:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbjDTCIL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 22:08:11 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E16AE170A;
        Wed, 19 Apr 2023 19:08:10 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id 98e67ed59e1d1-2478485fd76so291355a91.2;
        Wed, 19 Apr 2023 19:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681956490; x=1684548490;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zdSEkI73DrLdrtlsakWea3Yq7SYKQaz8Y6NGT/rNLsk=;
        b=NEVs9Zp7ARFZpb9Q6bhVwoKiXi7tbqwOdSZSgIL1e0vfDgtKo90tG0FQCw6+wB31Hi
         tL3W/DHuE6wc3fh+kXVrT+x6D4wVbie+iQUpOa7LNaE4pUB2ZarvN/kWFvsMqbmuinYO
         5viF+yyI0DhgODcP5zskygUaRm9KaJpfHNorCw++IGeptEm2F2O/8Ek2P9peust7y/KB
         6NC4+nvRLoSYMCAvuMoYkM318HO+CgTf9C60GIq5WtJGn39EvgkFcSZe+143D8DMCcHr
         pSbLUW9YGkxsx8J4FNJQU0LsgcdNZ6luki9O3T7tHwKMdtKwfM5uz7Daq0YbIfXFgcot
         2HAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681956490; x=1684548490;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zdSEkI73DrLdrtlsakWea3Yq7SYKQaz8Y6NGT/rNLsk=;
        b=Ytbkw6z946gqKcoGjQDmsRr4WAXbJ5S/s4IFm5tyS62s9rXEOeMY0L81HGuTCFn6V5
         08r95LWn1MQpExVe6GnPY9aew7UGDooXpm39aqkYIMEUGlHQagsL9g4XkgxryCnO+m4c
         23ft6tBdVvVpzJFPYiJFZID9oP0Yh3W7Bj2diuWMvX3F8IgxcYcX9thuLWX2TGvE/wO1
         G/9xIkBFpXO1qgpY4FynTS+dwSKYWm4OwdpFbWxG2AxxYHhzJf8QrcbWgRvcoN3y1l8W
         isQcolKvi8DiYKFXVkK5LPZbIkT0o9oYMNwjaPWIEzhvvAhWbWybF4Rr6DYNCn2e/3xO
         9Pvw==
X-Gm-Message-State: AAQBX9eU2e0sOewxH34vQ3PaMOIyMLS8DA5UQWK0Kj++18b6DqkyV4Mf
        emLZV1FZXwi/1/6dePn2/xU=
X-Google-Smtp-Source: AKy350YN0P6CUplxZRzI8tOI6GMBzSW9Q9TBpgT4bNdkqpcogxe5AUfINrZdvoWj4WklggIyUKSpyg==
X-Received: by 2002:a17:90a:5081:b0:244:99f4:2f07 with SMTP id s1-20020a17090a508100b0024499f42f07mr15423pjh.30.1681956490209;
        Wed, 19 Apr 2023 19:08:10 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p21-20020a1709028a9500b001a2b4c79f34sm93096plo.252.2023.04.19.19.08.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 19:08:09 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 19 Apr 2023 19:08:07 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/84] 5.15.108-rc4 review
Message-ID: <9d2445fd-3b28-4788-aeed-3aa30786a3f4@roeck-us.net>
References: <20230419132034.475843587@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419132034.475843587@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 19, 2023 at 03:22:09PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.108 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Apr 2023 13:20:15 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 499 pass: 499 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
