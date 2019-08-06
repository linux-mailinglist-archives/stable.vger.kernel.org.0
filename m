Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0928359A
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 17:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728836AbfHFPs6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 11:48:58 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:37252 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728582AbfHFPs6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Aug 2019 11:48:58 -0400
Received: by mail-pl1-f195.google.com with SMTP id b3so38065791plr.4;
        Tue, 06 Aug 2019 08:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZPSCVpajlof03gZfDiU14WfcdldH6Wl7wE+QAHDIdw0=;
        b=kx1nhGFR5nSKxtKBm/qEM86awxqKyznowIdWpV9mhEPn5+65f+no6W5czdTPWGBo7x
         Tfqr6z+rzM3hwHn5qFeT9R14SS5SWAmkm6pViULwGHoEX2dnIsJFchAcfz/AtK0zHKEK
         Kgj1r4amJMNThJkWFVuHqCgkYnSmqfa+OW30qgoYYdKHENvbkSzBC5XnGvS5KycKk025
         P6rzJqTqGPM5Ppp3Axljt4GtNaVcnnQyF8Kf/j+zn8u39s0Y+ewb79XbALrFjajmY8gd
         fV0IKOr6W6cC7xFfGFBOaKtvJY8Vxtv9H3+jcymRM6Qy/FvYgjM1iBYp8MXKEFGQ/aZn
         WgMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZPSCVpajlof03gZfDiU14WfcdldH6Wl7wE+QAHDIdw0=;
        b=NEI3UZ8VEiZpRquUH2xCKey9JPTlxnIAGiWc+U/1NR29MTThoX/YSEgP7mPtmedfH5
         pslb0+Jg8XIrODDeGdxpZ+8T93kO4O5dykyhXpf7VYSz+t3pOQiQXd/lvLTrSXhMmKf1
         2I2/mrL5zhbbp7qJbzuTF+X7KhEKSxcGp8Il4EMhwbgEyBrb6VXgYC6UK0MrNOmOC9qj
         TKfR1OVxqETCQyiYAXsoq8GatLQ/OAhuzlrtYlPcM0TASM/ot5m7TaYdiSiGXLK8SDne
         W78/wBNaENgEVu2SxN/j9INjcxky0Oevy6zHvfTj1hc+YaFrLeB6xWbwKbOfO+RA1ZyG
         NNuw==
X-Gm-Message-State: APjAAAX4hoUCvauBhzPO6kg1Pjcny5z7VkJwgf13sZ0utqsQJ+Kl8g9Z
        2j5B+/44m3+kfTGB12yqhbI=
X-Google-Smtp-Source: APXvYqwqs1ztN3R0VuflUXTKVjBf2XmHLR0F7IpaQ/mgY+cknym+LaDOhgZNCfD0lGbfF86qxKuISg==
X-Received: by 2002:a17:902:20c8:: with SMTP id v8mr3858617plg.284.1565106537701;
        Tue, 06 Aug 2019 08:48:57 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o128sm94096967pfb.42.2019.08.06.08.48.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Aug 2019 08:48:56 -0700 (PDT)
Date:   Tue, 6 Aug 2019 08:48:55 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/22] 4.4.188-stable review
Message-ID: <20190806154855.GA12156@roeck-us.net>
References: <20190805124918.070468681@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805124918.070468681@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 05, 2019 at 03:02:37PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.188 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 07 Aug 2019 12:47:58 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 170 pass: 170 fail: 0
Qemu test results:
	total: 301 pass: 301 fail: 0

Guenter
