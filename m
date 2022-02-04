Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4688B4AA193
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 22:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233239AbiBDVIG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 16:08:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbiBDVIF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 16:08:05 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE143C061714;
        Fri,  4 Feb 2022 13:08:04 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id y23so9902657oia.13;
        Fri, 04 Feb 2022 13:08:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6HCkHnGVEE80sPEgQNlAw3h/6N84BPRUC6GEhJX7Uvo=;
        b=MEfrGnObwVCXdYp8fs3TGHH2bRFp51bQn2bDJ6HPwIOV8EitYOjcsOJbcWI6kFGhLs
         6YFFTt2gMWgwl8cIKXb7bK7zUhwqmYJvUmqeUNrV0Xcffd71DmQIJN6MtODA0iWFtLbe
         9ppLf8XsPKg6228Fir7PjMElKBz9ciSOm34tfYbmMXff1Nr1dwP1an5A4fgp4JZFtT+2
         aYkDvEx1jyI+9zIUVntouCP+Fx5IZEsh8u4NotxnLQWnbfaySKY3/XcVxxbV8pjPtFSF
         UehDBxnJCwDNeiGjEhhKnaIUu2N62qINH5QkoQ+EdfACIwsSXCFZDhWj3HEmiGNhkmOG
         NcCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=6HCkHnGVEE80sPEgQNlAw3h/6N84BPRUC6GEhJX7Uvo=;
        b=7U9KofKSEfgGOggbj/KvSkQbCmLWt2pKQJU6H5AqQTCaV81sglEqPsdP/IzRNrN00u
         sz9lphdYXG77NVr1bSCWH0USx4+kdY4YDqpKcBHndpPKutceZgRXgVJH2sfXmnxDFKNv
         9OCeKfW8bee+wX/l63ksQPlZ3LGaqSyExEvmRX4N+p8+ms6n3gHUCyQBmU33fO8h8+fy
         qNxUyz2xY5gH2RzFsI2M7CbKqTK29BZ9tk7rrYahxMveYPNDC5CmutUJxTczYrQfalf7
         KJ3L55TIiCmmYHTvaJ78nukeuBgo8eMjEcFc2rFnZgKUWS2/XPmiTtKjF3sHboOJsESf
         1M8Q==
X-Gm-Message-State: AOAM530vvlbhzdGWQXTx3XaNoZLgZqf5/4HZAcZ99b7PRQGotHKazYJh
        xhYJcUgxKLjZyc74mq6uMso=
X-Google-Smtp-Source: ABdhPJzyJV58bC5mJE18mW8Rmr5kEP/jCc/fBQc/Q0YNts75hRAsNEIGjrQlWOQTZnXwEKLaKNSSCQ==
X-Received: by 2002:a05:6808:3081:: with SMTP id bl1mr2328243oib.105.1644008884398;
        Fri, 04 Feb 2022 13:08:04 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h27sm1168082ote.57.2022.02.04.13.08.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 13:08:03 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 4 Feb 2022 13:08:01 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/10] 5.4.177-rc1 review
Message-ID: <20220204210801.GA685902@roeck-us.net>
References: <20220204091912.329106021@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204091912.329106021@linuxfoundation.org>
X-Spam-Status: No, score=0.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 04, 2022 at 10:20:13AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.177 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 06 Feb 2022 09:19:05 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 449 pass: 449 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
