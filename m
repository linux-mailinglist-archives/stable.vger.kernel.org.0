Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C069533C86F
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 22:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232169AbhCOVaJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 17:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232117AbhCOV3i (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 17:29:38 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 985C2C06174A;
        Mon, 15 Mar 2021 14:29:37 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id x135so31479313oia.9;
        Mon, 15 Mar 2021 14:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mUjjZaZN8dp6QkWg+sH/gGpHygd99Fojms2NHh6bufg=;
        b=Sn26WRyQYNMbAiaJLVjn3MhjedpqPr/KITCeEjl5+AAFdqhfRcO4bPA3JjvXeqxNz4
         W0WswACpmhcH65tM8vdgry8iuXPMw4tMA9RbVCjdMXqo9NsYbseMKPGI4kZaICu+pdWB
         XWOLuM/MPJZfLbSU11rZIfCyQk/OszS2GsF7Exgc61NZU2BzIBCY/vwEQL8vSNMV7+uE
         Cw/AGWT7cgLJoE6swvTDR912v75m2pvOtzz51aOh+yhAQwQJyk3dIgrFGLUdzLEHhyxD
         MlRAkBQVzEaOpYes0o/kKrMLP4icOdjr7eHN6hFiUFOn9o3FsJ7SOYZhmX224tmkDN3Z
         /vSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=mUjjZaZN8dp6QkWg+sH/gGpHygd99Fojms2NHh6bufg=;
        b=jOmsowGbS5gy7eACwgRPBhPLyb+cOsvPxV9zhUp5gSSeONUPwOd5pumzCgiGxqG+Bh
         GuDQa4loRaba6lh7VCe0z08eLVb4CDq9gMgJXoAZ3rXBF7KRqWQ91tcfTurwatMKBa4S
         pBk9K8mWn4HstFkP34a2aRjSerzZja52IT/4RPZ6sZ6WsQQfO3AnTTL+ix+j0qZ/AQZx
         Z7/ofE4jhlevy9ev8FkYyiuVNkBhWFynl+kuIHCdG268iFQG4/rMvU8bxhmG9oK+wd9X
         m6IDzLA2Ln12wFI7rvvVd72jh9rD5TvnADUvwENbv3qp86rUvKZzQC7C5+Gn52N9qWQT
         tIxw==
X-Gm-Message-State: AOAM532ijfsh0BuOwAp7UfUoXy2Lk3kT7X19IEmKHwJspBreoBWB4iaR
        zz3EdEETATT+Usu6pK04ueHMSz5GSlE=
X-Google-Smtp-Source: ABdhPJzvfHelkp1Io+/bBfD0WMXs+M8lURT1J/eTWSH7n3maO/fhepMnCDGQLY4g+yh16RcFg+mx7Q==
X-Received: by 2002:aca:5fc2:: with SMTP id t185mr890092oib.64.1615843777129;
        Mon, 15 Mar 2021 14:29:37 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q10sm2744527ooo.34.2021.03.15.14.29.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 15 Mar 2021 14:29:36 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 15 Mar 2021 14:29:35 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/78] 4.9.262-rc1 review
Message-ID: <20210315212935.GB69496@roeck-us.net>
References: <20210315135212.060847074@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315135212.060847074@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 15, 2021 at 02:51:23PM +0100, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 4.9.262 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 Mar 2021 13:51:58 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 382 pass: 382 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
