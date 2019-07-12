Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA74C675D7
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 22:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727538AbfGLUVp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 16:21:45 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40268 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727536AbfGLUVo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 16:21:44 -0400
Received: by mail-pg1-f193.google.com with SMTP id w10so5009668pgj.7;
        Fri, 12 Jul 2019 13:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=j1jW21CvKe9S7cEN+GY/9O3VCnC3tL6TnPcLPQ8iG+M=;
        b=tJWrROiPZqd2Dd0RxjzGbJ+4f7+/I2dUEH9vmXLUKt1CpRQV9p8eITtJQPski2qob+
         +cErGMYjKDw7kolfHyMb0+7VGHAnMkeYGIR15/bU14Vw0gV1g7zvSfx3jVPiF8GgcFfR
         4nxNA2VUQ02PBPJ34+8rXWGgr8hT1xgR2OYZmkiPxLoct71ntEkUyNkSTzF0r/4FhuKN
         WWu0W/e2F1vR3dHezpOBzROWyz9pWsZv7vFoi+YrRlSDSLigkvl5rEKVrSVjNG2vM8l2
         gZRKhwxkJHXuDrSwXI4OMkhLt5eGcYM98W7fcXxnP96mp70nC94mBR60f7v0NtbNoS1O
         EglA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=j1jW21CvKe9S7cEN+GY/9O3VCnC3tL6TnPcLPQ8iG+M=;
        b=bf58kANoW85Cqknc9WCtDkxM6RML7/j869cIkH1HhPYqbPZqG5CzjWdixCM4Tske9D
         kfL2m6Syj4T/myA3nec7E9KJlPzfdjMCkGBezy9czpZaDzwfTcUFMBVzpMc0xwVVrn8A
         UelHtRGc9Gd+N8CuiBamloR1ZzV3wnIw3BokgL9pSdjKlKaZmeITIAMnn60v11KbKnP/
         GZDpB1X3A8qmN2FQ+1WQXSkpLqr77V+y5JtBnb9RKmTpOwT/QSl4+2F387MwybPBhtaR
         Yrj8LrF8h0Zc4vtNbEEPtHSEGW5SBJ0Tz8xzmxxxJvZR9fb+7PUGhRFVfEHgO1l+TJfM
         Z8YQ==
X-Gm-Message-State: APjAAAUAp/1DajGVrl8Yup19EZmnf2AcpPdrzRpo+cYTRzIjbyWAKRGv
        UMGSFwq8tBdEOQpgJmJzW+M=
X-Google-Smtp-Source: APXvYqxTesmbzMMr9AhbqLbrNKnXxmn8z7a9tWSCH56DHtlY9ZsM64py+amJDMnV0fYGXN+hWMNvcQ==
X-Received: by 2002:a65:454c:: with SMTP id x12mr13135623pgr.354.1562962903938;
        Fri, 12 Jul 2019 13:21:43 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q1sm17278711pfn.178.2019.07.12.13.21.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Jul 2019 13:21:42 -0700 (PDT)
Date:   Fri, 12 Jul 2019 13:21:41 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jon Hunter <jonathanh@nvidia.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, linux-tegra <linux-tegra@vger.kernel.org>,
        j-keerthy@ti.com
Subject: Re: [PATCH 5.1 000/138] 5.1.18-stable review
Message-ID: <20190712202141.GA18698@roeck-us.net>
References: <20190712121628.731888964@linuxfoundation.org>
 <4dae64c8-046e-3647-52d6-43362e986d21@nvidia.com>
 <20190712153035.GC13940@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190712153035.GC13940@kroah.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 12, 2019 at 05:30:35PM +0200, Greg Kroah-Hartman wrote:
> On Fri, Jul 12, 2019 at 02:26:57PM +0100, Jon Hunter wrote:
> > Hi Greg,
> > 
> > On 12/07/2019 13:17, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.1.18 release.
> > > There are 138 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Sun 14 Jul 2019 12:14:36 PM UTC.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.18-rc1.gz
> > > or in the git tree and branch at:
> > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > > 
> > > -------------
> > > Pseudo-Shortlog of commits:
> > 
> Both are now dropped, thanks.  I'll push out a -rc2 with that changed.
> 

Can you push that update into the git repository ?
v5.1.17-137-gde182b90f76d still has the problem.

Also:

Building powerpc:ppc6xx_defconfig ... failed

drivers/crypto/talitos.c: In function ‘get_request_hdr’:
include/linux/kernel.h:979:51: error:
	dereferencing pointer to incomplete type ‘struct talitos_edesc’

Seen with both v4.19.58-92-gd66f8e7 and v5.1.17-137-gde182b90f76d.

This problem is caused by "crypto: talitos - fix hash on SEC1.", which will
need a proper backport - struct talitos_edesc is declared later in the
source file.

Guenter
