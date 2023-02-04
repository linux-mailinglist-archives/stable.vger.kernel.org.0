Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0291068AD50
	for <lists+stable@lfdr.de>; Sun,  5 Feb 2023 00:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbjBDXC2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Feb 2023 18:02:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232223AbjBDXC1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Feb 2023 18:02:27 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ABBD27489;
        Sat,  4 Feb 2023 15:02:26 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id p185so7102529oif.2;
        Sat, 04 Feb 2023 15:02:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=betPigtvs2CftGKC3oH75tPcRVvUo4f0Uyn1lOaWnOg=;
        b=IlXLvQMVn4AOTbU5ovzM2/MAoGF9P+HeEM0OaM6RVFTyfE6FyPEDHGe/ved1peaqp3
         rGsgTl//BsrqnZ2Yvcx1+ci5VAt4M8KQ1jqsiylLVDoHnTd3rJit9PA3PZAUk8/zm/6H
         4F9LSUVo0EG39x7d0aGKIrw1uEc5Ki8bIaPNrRApTvV8H92y34eRkgE6eKT9TN6N5k+Y
         aA7aa+0fyTzJVkZmFQzoJ9wBpZNnYudBFYDT0ltusb5ck9m/Q5/geX2BQ6y19t9qD2vf
         ia6h2eh7/yR/IQFjy8IU+N1upKJ++bio41hdRfa0jbQ+0cY2BgKUOYCFvN1/SLUZ2V0Z
         0nVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=betPigtvs2CftGKC3oH75tPcRVvUo4f0Uyn1lOaWnOg=;
        b=UxZD2puBhRhXKxzKl2s7emVIuRfcCEmzURLRQ+nevVwK9uLF9Sl1L3jYHOIONAojHu
         m8UtuimuLGknY35UuXE7nUkzxOBScSS/9/i0Y+23abk4IYBW4o+QusIt8utc6nSIFoYv
         HP2Igorq+UjCcbg4O5pZ/9QyWSgGspj0wsxIUzFBBq3V5bf9VU6oKoc6T372F1IUC2+E
         458khl5mOPuwMMFGRGx1hhI36ZGFsgFqOlmK1A1tvKvwgKoqQ21+dDlxn4ZYI43TYEZY
         kumYJkwv6/LIHHGHvAS0CklnbbDXZVd8MfQoNr3pUixxQu7GbZXnjN1tMQdWBtzC7lof
         kzbQ==
X-Gm-Message-State: AO0yUKXIosdumaKuKplgrwoAMeNehW1NCFPKw3IGMqNrR1sPflRfAOoH
        4Jj/ne8+sg4JIidQZceXGjo=
X-Google-Smtp-Source: AK7set9sJwaprCWNM5uLONHt7RZHVazqUTZRb0cVnYDOGb0lwv01QycBB0A63d3vN7vbeR6LwtQfmQ==
X-Received: by 2002:a05:6808:f86:b0:378:9c80:7da0 with SMTP id o6-20020a0568080f8600b003789c807da0mr5439038oiw.19.1675551745569;
        Sat, 04 Feb 2023 15:02:25 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s26-20020a056808209a00b0035aa617156bsm2281829oiw.17.2023.02.04.15.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Feb 2023 15:02:25 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 4 Feb 2023 15:02:24 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 000/134] 5.4.231-rc2 review
Message-ID: <20230204230224.GC114073@roeck-us.net>
References: <20230204143608.813973353@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230204143608.813973353@linuxfoundation.org>
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

On Sat, Feb 04, 2023 at 03:42:39PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.231 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 06 Feb 2023 14:35:41 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 450 pass: 450 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
