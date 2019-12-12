Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D01411C82E
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 09:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbfLLI1m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 03:27:42 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45642 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727949AbfLLI1m (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Dec 2019 03:27:42 -0500
Received: by mail-pf1-f196.google.com with SMTP id 2so349459pfg.12
        for <stable@vger.kernel.org>; Thu, 12 Dec 2019 00:27:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dNWOBA5YwzD3g4C2lwDOuDcI1Q0TYRPb9GI/Gzl2Jr8=;
        b=x2FnOlHQRZ7INIj6O8+MnWCeuiBYNLqdiOswnaoZ864UO6WAQA0twmxYmsxNsOSSnC
         Ly2ePlLH8p6iDtGIDroA3OJfk3onQ1aAi6kOs1Vv3KZnPsyQ+ZCKvfm8W0y5Io2aTcdz
         VH/iUSMpZbosWLX5kkWHuNjQ8dFo9lKDfbBTTqS3KKKKOCA+/a3ksx+H2d9O/ans7WNx
         020CaCgf58fo16lOvDb94CwsHbwZ8t+RvoC7x+ouG8mmKxVK63YWUmPbswnA2ptBbmuC
         LiOB60aqKZRsoIZEgcmHbJhH15rTh/w+KVSG460Ep745jP/deByOZvgklH6GlWkCZBVK
         C+yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dNWOBA5YwzD3g4C2lwDOuDcI1Q0TYRPb9GI/Gzl2Jr8=;
        b=kEr/g5pL28Ybx2DbJAiJ8+YplJv9WI1/SJbeyfWaTI5eVVtOHKxC73VJHKkNAozuED
         kHDflwnjvUCL32B51hwQuSAmHgJ49R4fdpj0VurWMVUmCschAhJ0m9S74wFPTBMe7eyq
         qxWk5EJkPOhO9/uP/pur3nFvgNFtNoxuW+erGZCuoYy2sheZTX6QX23rRRlZuRsSsG4p
         07GWpsp5EhI6EAjVHTHwP4oXAtoe/8OIdOou2FXH1H40IKYCv1WtNlEe6xjOHyT1UPNf
         /GoScSFnmAUq0YaRYPKOGNTJ5YpwmMg6E0lH1OZ9HqXp6yQicFN2TT36EJuRZIgd3gkM
         qzOg==
X-Gm-Message-State: APjAAAVHvbMgPEouT6lQ6Qy5hyS059VojWzxiuKp1sAS92GwXfoOwy3f
        W4snlY7uow2WGbUs/Kyi/35Drg==
X-Google-Smtp-Source: APXvYqxBBy+O8IUr//c8wJuqru1jWzqjv78xdvkaJ7eDXK/yp7162K1YVGhRaKCcqhiNQoRjFc6OKw==
X-Received: by 2002:a63:d108:: with SMTP id k8mr9032354pgg.434.1576139261361;
        Thu, 12 Dec 2019 00:27:41 -0800 (PST)
Received: from debian ([122.174.90.102])
        by smtp.gmail.com with ESMTPSA id hg11sm4897908pjb.14.2019.12.12.00.27.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 00:27:40 -0800 (PST)
Date:   Thu, 12 Dec 2019 13:57:29 +0530
From:   Jeffrin Jose <jeffrin@rajagiritech.edu.in>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        jeffrin@rajagiritech.edu.in
Subject: Re: [PATCH 5.4 00/92] 5.4.3-stable review
Message-ID: <20191212082729.GA3268@debian>
References: <20191211150221.977775294@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211150221.977775294@linuxfoundation.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 11, 2019 at 04:04:51PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.3 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 13 Dec 2019 14:56:06 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.

No new errors from "sudo dmesg -l err".

--
software engineer
rajagiri school of engineering and technology


