Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E122B44DF6D
	for <lists+stable@lfdr.de>; Fri, 12 Nov 2021 01:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234581AbhKLBA1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 20:00:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234146AbhKLBA0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Nov 2021 20:00:26 -0500
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3969AC061766;
        Thu, 11 Nov 2021 16:57:37 -0800 (PST)
Received: by mail-oo1-xc35.google.com with SMTP id v30-20020a4a315e000000b002c52d555875so1419288oog.12;
        Thu, 11 Nov 2021 16:57:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Z8qnaA0oFxL5YBvCO4WYTqVv1vIHy9nDwzGB7l2bG1Q=;
        b=j3IE4rPjXRDEjiEGwFRiYR5mWbFgsVDEqsVBYtnSXEUbwGdNt2hEnD0jJ7TXuxkYTd
         Bf5qiFBhN+IwwuE+gdckkF/B7pnknhFYmYpW5Muq80dF6FMkjgL4WHuuUVJ5lNLlFf/7
         XbypmccWkuESoHEbrjKCg1ehj9prXDIcVsfEMTSYEns5A8cAzqHzpblvyfiKDjCWlmEI
         3z9ALIOtYz+GDX29n+vch4Fyf5iHn+p6u+dHD0VHIWYqU85dO19yz3PaMnAtAoAZVjzx
         YUatk4B4Yg/eiQ81W2nCH5pjEYMYnPgruqMCIYZKs1CINqNMcSszZKezOjtScPySOVX6
         nvSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Z8qnaA0oFxL5YBvCO4WYTqVv1vIHy9nDwzGB7l2bG1Q=;
        b=D524R9AEoZq4dTi8ePZPPlCeIrSSEdcebkhzGv2R0r3vD0WiVHX9xmF0vwGiQXc40O
         ddmX+3pzF0QMPgqkmx7AaEqs9Q6pKGX0uyA12QoV4dfiYH5zfPUEYO+xRNoqaTaikpD0
         bZ8Vp6p9AYZsRAR8w8bsMysIZoMnLZPZKr+PXIuzAL0V2oZntLA9TsHK/IMrNLAuVUqW
         2RYZFVcb28H4hZbv5FixlbLGAXwwvmk1HhDXBS4Q3ArmdInfJsTa/3HRavQ4Q+WRxtQg
         dzmq2eKR+x4MNtf+ooUS82p2LQOz4Mz+U9FsyTCk2cvsXWYQ5MMXm565jNH6aGhNLpLd
         1gZw==
X-Gm-Message-State: AOAM530OBl6n8x8SKip+ME+6CX9YGxK8zlSathKD3WfWghhE89KUXpHH
        ErwB/Ph6AufWqwLW7ZteFHM=
X-Google-Smtp-Source: ABdhPJy/Izq9L4KM9pjykqkabZ6/m7mCDJY6ICulqcUxcvrFP54MZm0TM43FIN3zalIlEqoMtAxKOA==
X-Received: by 2002:a4a:eb08:: with SMTP id f8mr6484056ooj.43.1636678656646;
        Thu, 11 Nov 2021 16:57:36 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o26sm935062otj.14.2021.11.11.16.57.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 16:57:36 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 11 Nov 2021 16:57:34 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/19] 4.4.292-rc1 review
Message-ID: <20211112005734.GA2453414@roeck-us.net>
References: <20211110182001.257350381@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211110182001.257350381@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 10, 2021 at 07:43:02PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.292 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 341 pass: 341 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
