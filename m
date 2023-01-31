Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F37F7682292
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 04:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbjAaDLl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 22:11:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjAaDLl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 22:11:41 -0500
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C6B811B;
        Mon, 30 Jan 2023 19:11:40 -0800 (PST)
Received: by mail-oo1-xc32.google.com with SMTP id c29-20020a4ad21d000000b00517a55a78d4so262910oos.12;
        Mon, 30 Jan 2023 19:11:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tAhy3CTZnrCcAKrqL6ZpsJfMdmRkXr9FJxeCsifZi9A=;
        b=ob4X7MH6nHFOpXTxbBp2YC579tKv5s9Bs/Nkbnoj0Ko+jCdwl3xoMMNOYtFSaaEJTd
         3AhgR1iEZQ3oxJdZukpmQZQd/SK4G2AcfbSVogZOUewBTAoTjp3N7EXPKGgu1qs1dhb7
         4zAwpIOJ0WifaFbQt8q+Rm4ikR0eckZrHVfRKIKl0V7gzAaf3rByI/xGdWeDRaA8KTmv
         8MfEi0bMPlXu1mqs1JsXbDPLPzApOyoO/u3zfgi3muln8V9nYWxDr3Nvgod3bIcTbDB3
         ZlotVhzwUmMve+TIlaDyPI4V3kPBlBvGizBuqJN+Tng11PJRr+HEUJpoKIwurgR+JPSH
         G5WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tAhy3CTZnrCcAKrqL6ZpsJfMdmRkXr9FJxeCsifZi9A=;
        b=2m/35nJ6puJIl3A60sFNdIxUkkALxMy9tjmMgSXiJpgTjmNc3btg3Zg2Bm37YaHr4g
         b/LosqY7ouy63tshx+lq0D/h7DxMMOKFfQOdGJX8ykQczqOo/eDCqMgVeNcPXBYo66hx
         vrw9XNjkvLQ1OF/4zbTtND1TSVBqy8CGa0kWN0mmjbVv9DJKMCVlLxqy6DWNM+BYKoHn
         8SBCa4WmiVDva66Mzhqve1U96kvHswYata95KcTdoG7CkeBa/c9Ds2ptjj9tVJmcOYRn
         FiQ97rLeuwc4r09Nd7dhg728XOWJwEHaDRE1SORjH0izIY2JkGeWJ0fEyKU8qPeWMUP2
         TkKg==
X-Gm-Message-State: AO0yUKVxJb7rpI/R0DP/9G+QcPZBMdxUQgCfOzaObhFyO5u2bfPYhdeq
        KtF9EzRNrh8UjdxUiafvcfg=
X-Google-Smtp-Source: AK7set+DBg+e0aalCtvWuzFb5vBG7OiThncOMJ71BQdsbPmXl3IEQA/C8Gyo+qgqqDxnsTcBLmwNqw==
X-Received: by 2002:a4a:490f:0:b0:517:4123:9cf with SMTP id z15-20020a4a490f000000b00517412309cfmr5508252ooa.0.1675134699475;
        Mon, 30 Jan 2023 19:11:39 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b4-20020a4ab484000000b004fca8a11c61sm5590524ooo.3.2023.01.30.19.11.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 19:11:38 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 30 Jan 2023 19:11:37 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/143] 5.10.166-rc1 review
Message-ID: <20230131031137.GA835036@roeck-us.net>
References: <20230130134306.862721518@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
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

On Mon, Jan 30, 2023 at 02:50:57PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.166 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Feb 2023 13:42:39 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 478 pass: 478 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
