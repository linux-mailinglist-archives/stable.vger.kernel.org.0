Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E20332F812
	for <lists+stable@lfdr.de>; Sat,  6 Mar 2021 04:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbhCFDXe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 22:23:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhCFDX2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 22:23:28 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34BA7C06175F;
        Fri,  5 Mar 2021 19:23:28 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id h10so3841508otm.1;
        Fri, 05 Mar 2021 19:23:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MNQ33rZ4GBcBaggdigVuJFHayW3vfXoyz4Pdik7VQx4=;
        b=iP2IeWLBkAgFvnMqYIaLQsauZiScgLYQortpuoZgpIp7GjAlSkYSEi0ftqFQWBX7Uk
         YHeH5wUd09q8xznf0w2HCsYxR1y/pczwREmsqX604asAox4f5rXk/FNYrEqCHxMSmmVX
         03Qdo4y11QNvb4LZ83Lk6COBr8owD6i/b4PiVv0Fkh1Gh5ZMhZFjzkY5EbXXAaNibrKk
         sBve8y7tsSe/o/44bsXjKqFK/p9RhwxF73gaCoEE6ZRDyNAjoOJKKKDIOr/3Jty1TN5W
         Fb2OmEEJqDwto/ECIKEVgj/iSgMdSDnXmKddHDJjd7DlCy3hyyI+iS+LdpAalS1RalyM
         K+mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=MNQ33rZ4GBcBaggdigVuJFHayW3vfXoyz4Pdik7VQx4=;
        b=QFjKzUjFfAJgtK+CtUfE3tjtgDXellINeUPkrsSukOE8T5uelticJlubq5JLS/r98k
         o2lEgsudJ9C0a3BfG18PO8mFAxK9mD8LL3fBSOXhS6aKFSjflGm3DDE2qygdphB48lBg
         MvjfUUrhjl5hOB2lmRbETZyPbNBc6FGMrSUuorDq4vUSSx6uYs+ON1ZxqShHkMkgG15Z
         p5UbeP/3HTQNJslHXc0jT7jGjqQoZXbVfWCO4uu5zCMUvOPc2wfeEYVwvHyW69N6QFBT
         e/bMHoY/vk/eXZC5q01bDii9XAuV8CVh53D+825fwl3IfxM3lcuCNS5hj1bZGjhavnTP
         c28w==
X-Gm-Message-State: AOAM533JsRGpDS4aPSK2dfJjhsknNEQqM7gUQ85AxDGimbRm1Nuo/Sgt
        SCAq8T8MFelHjL792Pp0noY=
X-Google-Smtp-Source: ABdhPJyrUnv38ptsKNK/g0h73SRYE9+ID1C1x0gpeO4Ew0U7iVUUce/s+LbVP8Wn8TQjlpUsoaosDA==
X-Received: by 2002:a9d:4d17:: with SMTP id n23mr10376280otf.330.1615001007613;
        Fri, 05 Mar 2021 19:23:27 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u8sm973425oot.24.2021.03.05.19.23.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 05 Mar 2021 19:23:26 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 5 Mar 2021 19:23:25 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/72] 5.4.103-rc1 review
Message-ID: <20210306032325.GA193012@roeck-us.net>
References: <20210305120857.341630346@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305120857.341630346@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 05, 2021 at 01:21:02PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.103 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 07 Mar 2021 12:08:39 +0000.
> Anything received after that time might be too late.
> 

Building arm:realview-pb-a8:realview_defconfig:realview_pb:mem512:arm-realview-pba8:initrd ... failed
------------
Error log:
kernel/rcu/tree.c:617:2: error: implicit declaration of function 'IRQ_WORK_INIT'; did you mean 'IRQ_WORK_BUSY'? [-Werror=implicit-function-declaration]
  617 |  IRQ_WORK_INIT(late_wakeup_func);
      |  ^~~~~~~~~~~~~
      |  IRQ_WORK_BUSY

Guenter
