Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07F5E336AF7
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 05:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbhCKEIa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 23:08:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbhCKEIR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 23:08:17 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92BF5C061574;
        Wed, 10 Mar 2021 20:08:17 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id e7so17722830ile.7;
        Wed, 10 Mar 2021 20:08:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=KFr6ZhqF+jELupEMrcrngtc8blBqoTYxZwtrg01N3b8=;
        b=j+n1TxPbMPhpK2gQQJ4OEXtlfNrajqWnjhOhj7DAzsWbydnZIqUEyLQMdpwj4mSf4J
         WUPDID2GxwyjseRzVIzJ7m3jOLIVZy/owWxM0BF9GvF9eypZga2dF7gDI/JXgNGTUQW9
         2RtnrU4SbeBJxBARZ0SkbsNx1d98626jlNyLhzBUzBFqVmtk8VXQ4YRjUBzEivWuj4Pp
         Uoy8M4al2kYNE8pGyBPF7aC57cMqADFLx0bIalUt71q7WWXCe4y2UuMr669uWTVtL1fa
         yryaEkC1q2ceTqj3jYFnQNcu1tIikSQzCNwEx7DZsH8CzQDSk3AnFMREjyJcy/VUn0M+
         WLGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KFr6ZhqF+jELupEMrcrngtc8blBqoTYxZwtrg01N3b8=;
        b=iGxHVGxuFsC9E63viyRpqX8s//DZYMHelkAq1fR2ihhD9bVOHX/gNj3Bpf4YVSN9w3
         XrF/HBLBdIkl6gBOzwWj+jNOXOOWgfL9bgMQ2uF/fmCQ34Y6VGQoGw7WLudRnEpZyLwP
         cTVwJJhDGbPkxn2txsrSbTrjxxjWZZfvsAOUBi2t7xq6N7Rcx3nwftxfJMUK1bf0zrKN
         sAkmTtzwRqMLbm1dhbBQu6d5Lr6a+7wYD/8IstBLTbz3tihCmbvTFtLt2rHwau6qiMMm
         J2DMh+kc+px/ChSqNVnxhuyZRFFwdh2B9oMMnxvHYzqaMc0WrEL102sxpRABwDfAPNUV
         fkGA==
X-Gm-Message-State: AOAM533pjt9W/Gv1lYAcELsUIEsOTB2l28geJertjgQEOwQojgvtZ23w
        zv+aE2sOLj8N1VxQTySUPtE=
X-Google-Smtp-Source: ABdhPJwrJLXigrh6/ZwEvebB7Q821NrCBOTp/8IXqyM8cLZ6r1XLT559mAst/wy/4zluwF7Wf6fflQ==
X-Received: by 2002:a92:444e:: with SMTP id a14mr5330158ilm.215.1615435697163;
        Wed, 10 Mar 2021 20:08:17 -0800 (PST)
Received: from book ([2601:445:8200:6c90::4210])
        by smtp.gmail.com with ESMTPSA id t14sm739188ilq.13.2021.03.10.20.08.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 20:08:16 -0800 (PST)
Date:   Wed, 10 Mar 2021 22:08:14 -0600
From:   Ross Schmidt <ross.schm.dev@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/47] 5.10.23-rc2 review
Message-ID: <20210311040814.GC7061@book>
References: <20210310182834.696191666@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310182834.696191666@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 10, 2021 at 07:29:23PM +0100, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 5.10.23 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>

Compiled and booted with no regressions on x86_64.

Tested-by: Ross Schmidt <ross.schm.dev@gmail.com>


thanks,

Ross
