Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1514765C24D
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 15:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233459AbjACOwN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 09:52:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238026AbjACOwB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 09:52:01 -0500
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7186CEE06;
        Tue,  3 Jan 2023 06:52:00 -0800 (PST)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-150debe2b7cso1215943fac.0;
        Tue, 03 Jan 2023 06:52:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jnflFZNe0pA/ZYIPDzYWn3fRyrXDaT7T1O70Kantkxo=;
        b=TEDrMUd9RqBtm4eSy6MmGo/oCcTE4Z+FJhmg2mTXBmzQN0OPOJVtyX5G2LS46k3lcP
         unaUK2ln0mnXgAld+D4g2gRCGHYZhIC9w40gXvI0wqFIdgZnh7mu4jSN1rjxcJwv2qdp
         o4YPvcrTlO9ti3tHs5fkLO1R1J6l21pxZRdhPbgTJ74JrIaXbN5yGeDOAkjHemow26Xp
         /365dOB36MY3+jNdtIOlbmgB9gOa3SBjZPvuiaBuzrbqkNzTHjiWTqYowvQSGu3ek+vo
         FCJBUOQslBfMUQXQQJztqZ88w7U6nH06NlTG1yzaSFjATY4xKOdkC+3wuXKwaooJi0Uu
         mPPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jnflFZNe0pA/ZYIPDzYWn3fRyrXDaT7T1O70Kantkxo=;
        b=0oDsO0mhjRvnnVZZDZE19K1WA/YfGu7nAGN9OFNRXNqxaes9DKpSNOlhU5dj4D2A9m
         Y2/F3chjF0e7XQDZPcuGC6dHiu567WdeY8zJZCfw5yUbq7GXybc4ncw33L0524PtabvY
         T65UWxBGK1IicDMLFySRLwjzJqQ9dR4HGWUCshUlE+WfDQSenQktd0Km1sIZnnIOr9K2
         LF/eQXglTvsFEFcsq5oESNHAODi5mwKdxdxH9Ag0GdpY8g8+EAFtv2NI+DSkPJgJVVi7
         BYDYRZ/fnH3b1kP3q9t8Pb2xr+1RnGW/CT7kH6ywxPFeRo8DwXmdT1y0ii/Ljhg8Szdi
         AOWA==
X-Gm-Message-State: AFqh2krzd0xZMVXhHGCdfiz+0cNOYjWgSJh5v1vCpWvGInR+hzSpNDgW
        XjEqwcNOS75Vzw/Xh7ITjlkUsVxnUko=
X-Google-Smtp-Source: AMrXdXs6MYI9m3GkQ9ZQCPw1EwIxc+QZ3vKMSFuwc2q4U1HHyfemHaKsF1oIptKevWas5Xc5JHHcCg==
X-Received: by 2002:a05:6871:468b:b0:144:d64e:d6e1 with SMTP id ni11-20020a056871468b00b00144d64ed6e1mr19836087oab.44.1672757519804;
        Tue, 03 Jan 2023 06:51:59 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f13-20020a4ab64d000000b004ce5d00de73sm10555926ooo.46.2023.01.03.06.51.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 06:51:59 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 3 Jan 2023 06:51:57 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/63] 5.10.162-rc1 review
Message-ID: <20230103145157.GA197592@roeck-us.net>
References: <20230103081308.548338576@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230103081308.548338576@linuxfoundation.org>
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

On Tue, Jan 03, 2023 at 09:13:30AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.162 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 05 Jan 2023 08:12:47 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 475 pass: 475 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
