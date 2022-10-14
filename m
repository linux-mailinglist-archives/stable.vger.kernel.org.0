Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C57E5FF69A
	for <lists+stable@lfdr.de>; Sat, 15 Oct 2022 01:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiJNXHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 19:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiJNXHy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 19:07:54 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 426D9DE92;
        Fri, 14 Oct 2022 16:07:54 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id bh13so5558627pgb.4;
        Fri, 14 Oct 2022 16:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+DadiKlNKBokbxGbibf3/FwsiL9ZvUz09fZUmzHfORM=;
        b=Twj+jWtO61ewf+IArqLdgtfxZnd5oJ5f2/xBYu2lC6bOvjc81ceYHfvNwlzZ1fRPI1
         tLkFDDd3ExFelgz9A8T6iTzQUqjsSGR7acKe+s7Zuil4F8EKaMNvD9Q4HunuhZoW6X7h
         mZz/HgS+URCEu2rn5w4M6ZUVB2fRXQu2UwsXUAGIXmnbOD9paOw+GX3AgvrmoI07VtQS
         JZlYnFf4/McygeysHAS7HKR8O2TbR5gpqY+H8sl7q/KIwuEX0ySQlt5YYYjYmbWUa4I5
         olDSuP4EI39kH3jCm7iGq37e7MU3LjzcepI52KJGkch5xB+edbdlrIpld4UCenlSDH+i
         P+wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+DadiKlNKBokbxGbibf3/FwsiL9ZvUz09fZUmzHfORM=;
        b=LxXUkTwjOxpvaolWWPR0DcI7ydy+IJf4tEbV6PL/dyo/97H3UdLMSFQenyZRd8Y5T4
         C4URcN5Fl8kVmIrQ1ZFTc63TeDVz+9dXOYtquVwP/lIIC8Uj9JhRzDerl9wyMUUiwZj9
         cZOMVvmMzaqCLSYRCPxkfIGJXNXoqmcJUM3v9r9VPKmiB1E0zc8hbeCVPkJJKse2ipZS
         KWXtNGChM/oqgLIkS1aEnjfxXCwwIFnSRAFd9wMYNfHyvMeZUA2GNx4vvw2cuuN99wIJ
         S4lr0KxBHic2Z7OzchM9kGKOwXNRnxYwuZzUHUxfizyZ6CT1os4dD9djRzMGdUpf3wzo
         BR4Q==
X-Gm-Message-State: ACrzQf3vUbGpeHhlGdOBBcSAnGe0ZimROL0iKexBUB/RDZQzLtV+gegi
        110TnAwRAKLpZKwALQt4XBg=
X-Google-Smtp-Source: AMsMyM61XTfshlT0cww80b38JdKVYztcYcHNkS9LtjUYMUIWkp2SkiXQZX6Bz2V3GxUwaC9n8jPISg==
X-Received: by 2002:a63:4a53:0:b0:439:3c80:e053 with SMTP id j19-20020a634a53000000b004393c80e053mr174262pgl.3.1665788873701;
        Fri, 14 Oct 2022 16:07:53 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k6-20020aa79986000000b0056186e8b29esm2315619pfh.96.2022.10.14.16.07.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 16:07:53 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 14 Oct 2022 16:07:52 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.15 00/33] 5.15.74-rc2 review
Message-ID: <20221014230752.GC4126318@roeck-us.net>
References: <20221014082515.704103805@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221014082515.704103805@linuxfoundation.org>
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

On Fri, Oct 14, 2022 at 10:26:31AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.74 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 16 Oct 2022 08:25:00 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 486 pass: 486 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
