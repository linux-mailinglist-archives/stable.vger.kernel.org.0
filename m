Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8904944F2
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 01:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345163AbiATAny (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 19:43:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232101AbiATAny (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jan 2022 19:43:54 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B55C061574;
        Wed, 19 Jan 2022 16:43:54 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id q13-20020a9d4b0d000000b0059b1209d708so5534630otf.10;
        Wed, 19 Jan 2022 16:43:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0vDFGtvgQ0cOlTOwzsfrayqRltraxPOqDAEaipa39HM=;
        b=TrcpDwvzuGsbxf38E/8OEH+q74M8sG/9X5ip8Y9NVc1sg4MCd61oAIqNTfwAaqCX4k
         r0uJac6iPDk9UmhTGP8FxSdImAVUUgHMY/y01HXdb+5yBotksPS7Syo9LoarhFTIL4aS
         VROaThvUcup4aZTkP+UXE+vCf+RXREN62K953Clt8ayERvH3v18l5A1anyUvzAKUbNik
         bPZ3XDc3/HsDZtgiZv2fWaSCaJCkLc+nB/2mLb1K1dHsxUkREQUjWMcaZSMGtGj7c5Fw
         RCUZgWrU9XyqTux8sALG57hh0mx9tLTkJU3qteF+gTtPYq8sZjnkrMG7XgmPgBOAq9eN
         lBhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=0vDFGtvgQ0cOlTOwzsfrayqRltraxPOqDAEaipa39HM=;
        b=akkr4YhsNjwXrgaGw3+qlZa9YGVYcGxwplwAFW+8AC5nPwEMORDMKkja0fM5xHwJyB
         k26nQhwU2sWlsbjPQd+qTiL2ae4ef/hm3aGIUogUEFGIuHGepIlzasXHTEuC5VTjMMcI
         qSLOIsenO0pPyzXZE2oEwZKG9HEvKcG63isUemtqEZZHYpgX73tSihHuWP08woGLJD9W
         DpTQm9lL+z3YlFzFnFu3gv1dOdN6LFHX+3Nv9rfNl7CwEGGbIpo3I4/b2ldVfBCcXM+k
         qY1SF9GUKPvJiJQa76wsPOBK3JzCmnyKzWBWFJtbor9Hveuf8Z9tFiSOtbAo6KSamG3D
         WydQ==
X-Gm-Message-State: AOAM531sISIgpwYuYpJSAgt1I1u8ltCZ/iuoNFT9YyVhEB8FXSVYbaFy
        yJYBpHYP2B+aJs29oln4mH0=
X-Google-Smtp-Source: ABdhPJxOE3JaH/e8XsRnFK8bwye/Fl9xi0XvhCXpTs3acYalPdvyYcSCcdVy43LXF9SruPdEqK1GDg==
X-Received: by 2002:a9d:72d6:: with SMTP id d22mr21015482otk.261.1642639433713;
        Wed, 19 Jan 2022 16:43:53 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o7sm660844otj.5.2022.01.19.16.43.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 16:43:53 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 19 Jan 2022 16:43:51 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/23] 5.10.93-rc1 review
Message-ID: <20220120004351.GB3474033@roeck-us.net>
References: <20220118160451.233828401@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220118160451.233828401@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 18, 2022 at 05:05:40PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.93 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Jan 2022 16:04:42 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 474 pass: 474 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
