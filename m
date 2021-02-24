Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE2BA323E67
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhBXNff (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:35:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237155AbhBXNek (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Feb 2021 08:34:40 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA198C06121E;
        Wed, 24 Feb 2021 05:31:01 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id g3so2466075edb.11;
        Wed, 24 Feb 2021 05:31:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+D22QqFza76XYDyI5h+Kb2jRVllujtZ/ibY1WzgnNsQ=;
        b=oKUu2AHHj+H7wa2vWELhYt/uQghh+NrEpE5TV0p/V8g+CMHuLrhHdMQK3iF/td5O2y
         ZCfIflnBKDKUxlDgEXeOM3iiqKr6WNiI+jf3NsDVQ0mwyH0tEm5zPwKefwtloKLoLnel
         9OgsDv/Ekeih0VuRxPfbmo6PNM53RZ3kHc8e3FOoOZdIA+PRlS+RoazSSfVR3ZRtKOeQ
         zSh26k78uRGpMjd+rBqGN51k05uewZ+8vXJLSEaCj+QMFwrQx/JA/xwmO5vPIqSXalyO
         WcgymuW+ZnoagwIQGK9rWOWK28GmXxtjUJu2XUB4MwFK9xDNezQUvY/V74LzDcwxC6qC
         x0/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+D22QqFza76XYDyI5h+Kb2jRVllujtZ/ibY1WzgnNsQ=;
        b=Iyy05Pt5A1+BasZRrs3sh44BxOlltSthvdyndO2b7wTRnyJL5EhWUAO4ZrKZta/wPR
         w75/yoT3+8JuYDG1hGo/xRJVl4NUY2jfQ9lEHKLIExsofGOR/0dDToRuh0xBb3JqeJAz
         iP56Hn3JZ0HMbshuzdtRjKfktPJ0mInjP8bILRfkNx30Neo3MyCWTOCpzbrKJqq4zQxJ
         tqRfrk5wrTzn1hmy0YGfi6We7OMjwhQcZwew8xpuVqP40rN/w6NF4pHdbR4MOjQq3XSL
         6qSZCnd+yAvwf7/vA4KsuBIJUzQH5olew9bGS+Kx+4FPBTqF+Zic3hqRMYW9GiYkTKL6
         KEwA==
X-Gm-Message-State: AOAM531XcxYVG4erS+FDKtZkvudq+aUJrqUYsutxvhGop0av7YoJZsWc
        Ft/44yvQdaF16LGTb7srEr8=
X-Google-Smtp-Source: ABdhPJzvo7FBR6hnVwNq9QkUgUvH7CcoYZMpXtj8AeYuQWxzKHggaywlIGCY8UX52Lh47xC8QfG4gw==
X-Received: by 2002:aa7:cf16:: with SMTP id a22mr950855edy.288.1614173460533;
        Wed, 24 Feb 2021 05:31:00 -0800 (PST)
Received: from anparri (host-82-59-6-76.retail.telecomitalia.it. [82.59.6.76])
        by smtp.gmail.com with ESMTPSA id t8sm1302210ejr.71.2021.02.24.05.30.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 05:31:00 -0800 (PST)
Date:   Wed, 24 Feb 2021 14:30:52 +0100
From:   Andrea Parri <parri.andrea@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Juan Vazquez <juvazq@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, linux-hyperv@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.11 50/67] Drivers: hv: vmbus: Initialize memory
 to be sent to the host
Message-ID: <20210224133052.GA2058@anparri>
References: <20210224125026.481804-1-sashal@kernel.org>
 <20210224125026.481804-50-sashal@kernel.org>
 <20210224131457.GA1920@anparri>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224131457.GA1920@anparri>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 24, 2021 at 02:16:00PM +0100, Andrea Parri wrote:
> On Wed, Feb 24, 2021 at 07:50:08AM -0500, Sasha Levin wrote:
> > From: "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
> > 
> > [ Upstream commit e99c4afbee07e9323e9191a20b24d74dbf815bdf ]
> > 
> > __vmbus_open() and vmbus_teardown_gpadl() do not inizialite the memory
> > for the vmbus_channel_open_channel and the vmbus_channel_gpadl_teardown
> > objects they allocate respectively.  These objects contain padding bytes
> > and fields that are left uninitialized and that are later sent to the
> > host, potentially leaking guest data.  Zero initialize such fields to
> > avoid leaking sensitive information to the host.
> > 
> > Reported-by: Juan Vazquez <juvazq@microsoft.com>
> > Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> > Reviewed-by: Michael Kelley <mikelley@microsoft.com>
> > Link: https://lore.kernel.org/r/20201209070827.29335-2-parri.andrea@gmail.com
> > Signed-off-by: Wei Liu <wei.liu@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> Sasha - This patch is one of a group of patches where a Linux guest running on
> Hyper-V will start assuming that hypervisor behavior might be malicious, and
> guards against such behavior.  Because this is a new assumption, these patches
> are more properly treated as new functionality rather than as bug fixes.  So I
> would propose that we *not* bring such patches back to stable branches.

For future/similar cases: I'm wondering, is there some way to annotate a patch
with "please do not bring it back"?

Thanks,
  Andrea
