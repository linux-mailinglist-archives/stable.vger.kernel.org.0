Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D141E668BCA
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 06:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238702AbjAMFwg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 00:52:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238205AbjAMFvV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 00:51:21 -0500
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B73E718E0F;
        Thu, 12 Jan 2023 21:51:20 -0800 (PST)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-12c8312131fso21316472fac.4;
        Thu, 12 Jan 2023 21:51:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CvBJpZ2esT0FmkASmHPZMvs7Y3g+wYM+U5bBTY9tAAc=;
        b=khEvHw1xMe/EqZcAgehElSc8ADo3B1oWY3EQ3T5ZbLt4zOiIXaM16/0vkjuOMzaizH
         ZGoFlqPrErJOay+32GDOr9NzLH+3KYokVWWDzIi5nptSZ/rbbeDAS6k//csQ0vhqoerm
         DYU8snGZyuF99TGUqmlpg70hWP2Q7R7c2NV87HBPtDIvemKViAqMCyRZSFIXPY/HpwLJ
         pV9fnIj0QOFqZMhaHJp9RBhq0yU0oFxs3OJoyfd60PUlRpZVwPM6iCnJDyP3Ek/0pVh7
         rB/tzfT39ICvD0pVsx2pDBa/XV704aGT+gmsHOsX9n2jcZFbyv03nK6ejhioXpPR0a3H
         q2qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CvBJpZ2esT0FmkASmHPZMvs7Y3g+wYM+U5bBTY9tAAc=;
        b=C4rfPYYBGGf3wPVhnjmS4EIBdMd5kjAVTy4ckq8Qwb91HzFeOC1tCCHTddmc4v/oe1
         y5SnaxhfMofo/4+e4AD+mr9tbmjtIgop5AaRkkD5T+4VBeuPeOijWZ4Gz9U6uEO02CMS
         Rb+MlopeVGRr2DmZC1ZoiII5hSBb/IMlQRdMjLVk6woqhn7FWjbTnOfhr6UuCCZzZbgu
         TspToJJkyKIhR44VCN6hGpadkFn1WvAVFLL1G9PfOOuGDWRjtuO2oR7dRJ+VY5VcgMtB
         DmUj745X2vRlkP09hEnH3Tv7oMXbM8AHO7z9cseMYJSn3x52+C/bcMNJAR4fzlbyo7P/
         Y1BA==
X-Gm-Message-State: AFqh2krr2o0/4gg8oA+4tgKxAgO7snjtNzpYiOrlz5Dft0HOR/Ej7Z1j
        4BIsTb8CCayp6o1WXn3MZW4=
X-Google-Smtp-Source: AMrXdXvjdjw/+si6oySaj2v8NTYyDAYodIRdCRZxQUSRf6D2QAui4shSHjlRJ8WvsDZhxZvmZgbrGQ==
X-Received: by 2002:a05:6870:818e:b0:144:4f04:5a8f with SMTP id k14-20020a056870818e00b001444f045a8fmr45091624oae.3.1673589080083;
        Thu, 12 Jan 2023 21:51:20 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b10-20020a056870390a00b001435fe636f2sm9952329oap.53.2023.01.12.21.51.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 21:51:19 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 12 Jan 2023 21:51:18 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/10] 6.1.6-rc1 review
Message-ID: <20230113055118.GC1591011@roeck-us.net>
References: <20230112135326.981869724@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230112135326.981869724@linuxfoundation.org>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 12, 2023 at 02:56:21PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.6 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 14 Jan 2023 13:53:18 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 500 pass: 500 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
