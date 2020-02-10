Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBF7E158516
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 22:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727411AbgBJVlT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 16:41:19 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42120 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727003AbgBJVlT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Feb 2020 16:41:19 -0500
Received: by mail-pg1-f193.google.com with SMTP id w21so4576216pgl.9;
        Mon, 10 Feb 2020 13:41:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hUU4apL/ggQqxF/gkPhPNka9XrGkrgj3I+8jZ6t2/AI=;
        b=XGOXXvt7CPjnkqbur5P3bfStFKRmUShJucoU/Ct9fTqyn+3DqZx2W5tUaOG+MmCrX8
         093Qc1Au9TZYgjDC3qjxdSGcj8LODn1/2nKoQML4EL7WfpN4i9+m/JiG/0QkfWFX5UaG
         wViuAwJgn0vJ8gCDe/mUBQ7BG8j5dArO+ymUM3bg1rM4kiateCfZOt6KieCc5oSeSgQ4
         rSy70eG3EgpoZ159Q7WqxE1oj1irlfeSazoCcrVnzKj59duEm7zJc7gI+D3BK3wwXtRM
         QnoMzO6Nc9bGBKj1TQjDmzPuBzmxKNE6giufH1w8PC9mNghp/L2HNWfK8BaWN8Bd3YUt
         FLrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=hUU4apL/ggQqxF/gkPhPNka9XrGkrgj3I+8jZ6t2/AI=;
        b=RqOKgLSt49WO/F9FzwNKjE0usqRxU6GlEZoh+yg7Km7ErExhMOSoQpd3usWlbGEdXa
         JNkWSz5WjQ9GnslG1iHYiaOzfia60dNYS+D6i5vpyr1pAavKsoWgWpdG7xSgtDPCvBm/
         IKvF/APb4ixOQ8DzJ9/efxH4NAZ6vXBO07CQg2Am1PXGef/NiXORtVf7WmgWpl2Jtp09
         J3Rv+x/aV20YXWZ7JEa9ia5BRyI1JOSl5EM6wWrtSlI5zfhysiP33DHAwPJsBJbs8S3A
         YFx85/TP3e/+H7km2o+xCCclu428H0HR3+ROEzQYfT0YdWrtTg1pieDf0vL3DP+roovc
         GE7Q==
X-Gm-Message-State: APjAAAUnCaasdRObQdFVzdasRabQCJreFrTKgs4akFhnMzX9GZhjsTB6
        U75lf8n8FFj2P6UEpMDM/B886LS3
X-Google-Smtp-Source: APXvYqxOlKRLGkldKcab9daqm+uYcNlvM+U4+F/tqIbwXjWg5HbZr7GUz4/24co02tOZYw+2D5vEVg==
X-Received: by 2002:a63:f744:: with SMTP id f4mr3722532pgk.345.1581370877131;
        Mon, 10 Feb 2020 13:41:17 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b130sm1083438pga.4.2020.02.10.13.41.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 10 Feb 2020 13:41:16 -0800 (PST)
Date:   Mon, 10 Feb 2020 13:41:15 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/195] 4.19.103-stable review
Message-ID: <20200210214115.GA26242@roeck-us.net>
References: <20200210122305.731206734@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 10, 2020 at 04:30:58AM -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.103 release.
> There are 195 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Feb 2020 12:18:57 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 388 pass: 388 fail: 0

Guenter
