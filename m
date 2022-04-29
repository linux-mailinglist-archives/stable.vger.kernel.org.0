Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9C6515922
	for <lists+stable@lfdr.de>; Sat, 30 Apr 2022 01:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381729AbiD2XvJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 19:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381759AbiD2XvI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 19:51:08 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BDAD9AE6F;
        Fri, 29 Apr 2022 16:47:49 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id 31-20020a9d0822000000b00605f1807664so3057834oty.3;
        Fri, 29 Apr 2022 16:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rMmV0UYRR+3tQE/v4LynXj+aky0kOs9qIEgTQSHMYnY=;
        b=noIsPhFn8jespl0yRpO8QYLlhQJ18fnFxzq/T3RjRYATSi8fIJ3Nlt0ISdwWOm5pxR
         Gcp1xdDc+h+qcXXvLTqb2YZWuiAdbBSwbgsLH9FoKwxc6vl5B1u1z8M65D8PYvIaq8eR
         ueFA+nBfPy6LeLtgwb/UP9nuGccBYVVotMoq6mZMqg9HD6HvHmeLHOT0D3y0dyERMCoG
         DECAoeytTXiV/bR1Li6e/CGyd6ZnPLb1tbgOlgDXTsz/97gIR+cn1ZdwjC5SPUlDugKp
         xmX/Vlaxb4syqPy9Y6kdjTF0cSce6i3R3dFmguvtP5xNWt1tPNeFhZAmS7wr25TULFK1
         6vcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=rMmV0UYRR+3tQE/v4LynXj+aky0kOs9qIEgTQSHMYnY=;
        b=C6sIdihmoWY3apbd3WcS7FUABShBGso+aFp2ADQpk1P1tSPXZldeJhTiuK/N+PiT6z
         kNTO1p3rAFZlfCD5Arfuy3sRggkexF5tgAuvOL+1kTXnwsULWNJkxA9czjigx/+OpAo1
         j7hKcs6kXFPc10hsrxdLSVJqodgF8+EqMRrokUAUSATSVfIvlkLb522G9HBUD1EP0+cI
         XK4ccQ5YFzeBJRbwx95rtWMX4IhBfKEvCeKhjyNjgRk/X2VgWh0mxIRlTC8Bu/Xna6XR
         0nXeQXpRrDgyuj+5w9RUMzAn+qBkba4fWXLj4CFmrNa8IJR+qakM6taHkCRqD4UOC4uh
         ggiw==
X-Gm-Message-State: AOAM5317AuaVg4kiYdEZn4Q/27DINBdhz0U+jJAxPNH1YShvdCslwNO9
        rAHSmfdVf5K7lc+Wogu7QTo=
X-Google-Smtp-Source: ABdhPJyfzadPVJUEJKBMwovj3SFkjyJC59qB0VywcsA/pdGH7kz6zOVG69isMwPCTZrU8raIP/UyvQ==
X-Received: by 2002:a05:6830:1553:b0:601:cc74:23a4 with SMTP id l19-20020a056830155300b00601cc7423a4mr661414otp.203.1651276068228;
        Fri, 29 Apr 2022 16:47:48 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w23-20020a4aca17000000b0035eb4e5a6b6sm1288616ooq.12.2022.04.29.16.47.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 16:47:47 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 29 Apr 2022 16:47:45 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/33] 5.15.37-rc1 review
Message-ID: <20220429234745.GA2444503@roeck-us.net>
References: <20220429104052.345760505@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220429104052.345760505@linuxfoundation.org>
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

On Fri, Apr 29, 2022 at 12:41:47PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.37 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 01 May 2022 10:40:41 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
