Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4894294D8
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 18:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231745AbhJKQ4S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 12:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbhJKQ4S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Oct 2021 12:56:18 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9EEEC061570;
        Mon, 11 Oct 2021 09:54:17 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id lk8-20020a17090b33c800b001a0a284fcc2so1339051pjb.2;
        Mon, 11 Oct 2021 09:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ar6jS9mgPduriNQ+Mw3T/3tllHHOETh5zZmd7CTTh8g=;
        b=CnD7f7PfOCPYM6mx8VpDO/FqvCEsnAKWb93FFiplG0aVGgg9Xy4NrhyK2Xj8NrJD8G
         Mh5gOhEc6y0lVbnLAvJOt4EwXgrBIJybNm3bk1icLG9k3BfN+BdB90WfQcUli6Cpf/cv
         c12FS4OftsP7MCn7xGnm8oX6NH0zqE4ag/+uaRgXE3T0WBX5cu/k8d2+rG9BIboJh3FK
         oR0hWILjGOiA0B6aZoXNAsUeNy7XJukC1Et/NKqrz+EoKmwNkviGINRXBrFoi6zQeRkk
         WOAf1RlzDM3ga4giUvTZVMwfi2sg6HPRxDjac1Lvk638LdCYtT3K/BAf0Vxv7D9+QShk
         nVTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=ar6jS9mgPduriNQ+Mw3T/3tllHHOETh5zZmd7CTTh8g=;
        b=vYf5Rg4KFH9bAh4Z9ye5xVWWgkG4CYgQfVXuLbSMSLmYkxmzN2we6q5SIUEbAKSSrh
         Br2ZJWaD52jq6K+dhRr1wEydppD+jfBUOtHXp3wW/w4GbJ5mZDPw+FZnu2YXrxbpbcYY
         MljdF//jMAzwdmn4jyhRtd5j8W3Gh+4bKLBLM3ulGc+dbebhnnV+s35IVDLu2eQYXrK0
         6CT3C9yOzJ9asGLm4UaYveRmjxT6NW+RRlI/q25i2IEKF3+RfnwDPHFAl12kQMHhxf7P
         hcxcuvdoMiBKabKaroBZHlrpmZhUYy8tA4RpJD1d5gEzz0xq4maIsetZnmrq3xAXJerY
         ypWg==
X-Gm-Message-State: AOAM531LeB8zjEvbw5lIWn330RNhfVwTIXZog1Zd8idpxgC9Pm8BpoIe
        rem5UUu15jj6sze08zccnWc=
X-Google-Smtp-Source: ABdhPJzlB+qjbNZ3WdqfeVzSkr3Xz0ShISJfyW+O1HxWp05tfRR2PGnqS7YA+YJCiHo8Fq/D42bLjw==
X-Received: by 2002:a17:90b:4b4c:: with SMTP id mi12mr79600pjb.57.1633971257200;
        Mon, 11 Oct 2021 09:54:17 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-e24f-43ff-fee6-449f.res6.spectrum.com. [2603:800c:1a02:1bae:e24f:43ff:fee6:449f])
        by smtp.gmail.com with ESMTPSA id f33sm28195pjk.42.2021.10.11.09.54.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 09:54:16 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Mon, 11 Oct 2021 06:54:15 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Ogness <john.ogness@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fabio Estevam <festevam@denx.de>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] workqueue: fix state-dump console deadlock
Message-ID: <YWRsN6klE26izr9Q@slm.duckdns.org>
References: <20211006115852.16986-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211006115852.16986-1-johan@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 06, 2021 at 01:58:52PM +0200, Johan Hovold wrote:
> Console drivers often queue work while holding locks also taken in their
> console write paths, something which can lead to deadlocks on SMP when
> dumping workqueue state (e.g. sysrq-t or on suspend failures).
> 
> For serial console drivers this could look like:
> 
> 	CPU0				CPU1
> 	----				----
> 
> 	show_workqueue_state();
> 	  lock(&pool->lock);		<IRQ>
> 	  				  lock(&port->lock);
> 					  schedule_work();
> 					    lock(&pool->lock);
> 	  printk();
> 	    lock(console_owner);
> 	    lock(&port->lock);
> 
> where workqueues are, for example, used to push data to the line
> discipline, process break signals and handle modem-status changes. Line
> disciplines and serdev drivers can also queue work on write-wakeup
> notifications, etc.
> 
> Reworking every console driver to avoid queuing work while holding locks
> also taken in their write paths would complicate drivers and is neither
> desirable or feasible.
> 
> Instead use the deferred-printk mechanism to avoid printing while
> holding pool locks when dumping workqueue state.
> 
> Note that there are a few WARN_ON() assertions in the workqueue code
> which could potentially also trigger a deadlock. Hopefully the ongoing
> printk rework will provide a general solution for this eventually.
> 
> This was originally reported after a lockdep splat when executing
> sysrq-t with the imx serial driver.
> 
> Fixes: 3494fc30846d ("workqueue: dump workqueues on sysrq-t")
> Cc: stable@vger.kernel.org	# 4.0
> Reported-by: Fabio Estevam <festevam@denx.de>
> Tested-by: Fabio Estevam <festevam@denx.de>
> Signed-off-by: Johan Hovold <johan@kernel.org>

Applied to wq/for-5.15-fixes.

Thanks.

-- 
tejun
