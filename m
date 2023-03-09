Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 697D26B2DF6
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 20:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbjCITws (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Mar 2023 14:52:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbjCITwr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Mar 2023 14:52:47 -0500
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCBE8F7EE3;
        Thu,  9 Mar 2023 11:52:46 -0800 (PST)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-176e43eb199so3484966fac.7;
        Thu, 09 Mar 2023 11:52:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678391566;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XWQCnh1x5+krXU93i8HgoSaF1uKg4BYDXFBKy+L74+8=;
        b=Ry+xObfcK1uOH3V2pspxGgO5Skos+sB2LZ8Z+7up+KxfpdewG9Z0Y9TGciBDSjWGUA
         7+dBGoCwGGGNpJhUDGQYUMuJhpGlSDyYbT5vnkNlHYFMF4zMSMJaZ6zBXNSz3glBcAjD
         uQZENBkA8T9WpK+DG3Qta2j9to+s25mGiw26Xo7UvTjhfesH+X4JdOHvn17N/MlUzrJ4
         VnSMx8TAK2rxKeg/m9upDFPqqBxDl96XExNhHwCbd01rYg6d7YWF5pcp0eBA8Z0ydGfv
         b1lI2XtTry7Nge/Ugf5jVTZmihi6Y59NNjnqwNAuEAAC7GsE72U8uZari6tNWgSWx22Q
         osvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678391566;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XWQCnh1x5+krXU93i8HgoSaF1uKg4BYDXFBKy+L74+8=;
        b=YV8t1dpiTMaDH5D/M78YjPjuTMDO/CFUlCplVtaEe8jEDLkA7rwsJ9hoOp99dIiTNy
         d/ZSV7Tns8QpuGsNhcew4fL58ja9+JP9xWiX1ifaGs93bZX98mwWQHy5DohBFxpjsY3j
         Pqd0QpRa20+ueBZ04MxkUvYJU9E8JD6IugYzWwa4td9by3/ltWamsEHmH6RZC0djbD3F
         hzQgJYLhCdkFvCq5GfX/BL+VX/MY8StuIOCpiogn8eCOe8GLLaTOn0mAEr3DhtiiAo3h
         K7zmx+7nJfV2jD417WnHH5qRJS/iK6xWZMljx0okS1bDwiUwKa3sWmnHNPcPEMl+5bcY
         +8zw==
X-Gm-Message-State: AO0yUKXcE3/7R+aVx9chK8hkZX7k+lSTampYJG2C9BP6bRNYCHEbi/2b
        a+v84on75c2+DcAX0mPFS6E=
X-Google-Smtp-Source: AK7set+8qJ0xreXKo6gMhxrSUyU+a/gaVme2i0vyc7OYJ4R0Ki6IE+sJkLywCeoiVpW8ec0CgzH/KQ==
X-Received: by 2002:a05:6871:5c8:b0:172:289b:93c5 with SMTP id v8-20020a05687105c800b00172289b93c5mr14269520oan.0.1678391565922;
        Thu, 09 Mar 2023 11:52:45 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k19-20020a4a3113000000b0051fdb2cba97sm60206ooa.7.2023.03.09.11.52.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:52:45 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 9 Mar 2023 11:52:43 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/570] 5.15.99-rc2 review
Message-ID: <81a8e51c-153d-4f11-a222-240e9a532639@roeck-us.net>
References: <20230308091759.112425121@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230308091759.112425121@linuxfoundation.org>
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

On Wed, Mar 08, 2023 at 10:29:40AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.99 release.
> There are 570 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 10 Mar 2023 09:16:12 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 499 pass: 499 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
