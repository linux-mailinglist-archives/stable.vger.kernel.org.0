Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4A018258D
	for <lists+stable@lfdr.de>; Thu, 12 Mar 2020 00:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731412AbgCKXG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 19:06:56 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44312 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbgCKXG4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Mar 2020 19:06:56 -0400
Received: by mail-pl1-f193.google.com with SMTP id d9so1802863plo.11;
        Wed, 11 Mar 2020 16:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zrjFFfnQxfxf+b411Ohc8jC4fvp22dOgtxuNGSOhOrI=;
        b=N8ImzmaRC9iFGIOX2idaUyKFljIkNfgUjxj6FGbYhY+gCf6cT+RiJ6nv0j21pnFj5b
         p9agH41ezIMVcnMf+itV0kl6yB5rtWXZVsyz2a5dh1SdgqU3y/z8cQ/nQDlGxe0DQp3j
         nbh0vJYdShdA1U9aBplC8G6Fln6ryNqb0+NnaZ+/0VZImXOgpXpVXNSInz62gtUGJ+Mo
         qzfczRcjANv9EdeSB423u87fJ4YmUIEOsyIyQliI4MCYnmZsUiObLgdieQNwZMS1U9L1
         D57yCauadybOKoiyd0+ZJ0Kk0QcbTshgYoqg8CnVq/UIc0FCQrxAwVfQwH86x6tQ3mL3
         fifA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=zrjFFfnQxfxf+b411Ohc8jC4fvp22dOgtxuNGSOhOrI=;
        b=GvmN6LxzR/4naqTjN6HU+Mgu0jLkzKTnRGgccn9I5pLOcnAmwi+6/AS6wnEZso7ACJ
         OKVy0b8FcYcGHw4ERIzgEdv8JmoP+vPXRbfcZdBQmfrqeMQmvlxe8/ry0sEgn5tPA3pS
         hJj0w1WlgaqLK1PkU5sZhQfZ50BX4KBrBaHr6Vx5f4Lazy17AMhWThBljsF4eh3v3UqJ
         1EgDKRa6MLi9HZ/oZMCLcaAZf72hFMjf/1WPqHkDDyFbFNuo30XEvc7BYfswso/+Zpoe
         0C+kAeNvskidEQs3SWnt0vX5TlHi6QhOzRN5kyM0ym2eNFe0CPL4B/a5u0fbfeo4MzO4
         w7rg==
X-Gm-Message-State: ANhLgQ38icci8MdOl0ekdrQqXYlDuxcNAn5f0Jhg0RQp8ujEiIdzXpWm
        B+/C7WAOzOQmpYQauJ6aQiM=
X-Google-Smtp-Source: ADFU+vtYeBPyfkjBN5fyB7mvQHLbpXJ94GZdO0hU/S0YDuTyWyywz+4tpcdPcNMeOJ29M7KFkv7h4Q==
X-Received: by 2002:a17:90a:d593:: with SMTP id v19mr962093pju.177.1583968015672;
        Wed, 11 Mar 2020 16:06:55 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id e10sm10141664pfm.121.2020.03.11.16.06.54
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 11 Mar 2020 16:06:54 -0700 (PDT)
Date:   Wed, 11 Mar 2020 16:06:53 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/169] 5.4.25-rc4 review
Message-ID: <20200311230653.GA25697@roeck-us.net>
References: <20200311204002.240698596@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200311204002.240698596@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 11, 2020 at 09:41:16PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.25 release.
> There are 169 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 13 Mar 2020 20:39:27 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 158 pass: 146 fail: 12
Failed builds:
	alpha:allmodconfig
	arm:allmodconfig
	arm64:allmodconfig
	m68k:allmodconfig
	mips:allmodconfig
	nds32:allmodconfig
	parisc:allmodconfig
	powerpc:allmodconfig
	riscv:defconfig
	s390:allmodconfig
	sparc64:allmodconfig
	xtensa:allmodconfig
Qemu test results:
	total: 422 pass: 405 fail: 17
Failed tests:
	<all riscv>

As already reported, the failure is:

drivers/gpu/drm/virtio/virtgpu_object.c:31:67: error: expected ')' before 'int'
   31 | module_param_named(virglhack, virtio_gpu_virglrenderer_workaround, int, 0400);

Guenter
