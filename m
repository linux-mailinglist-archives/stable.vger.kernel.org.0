Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0210529D4FE
	for <lists+stable@lfdr.de>; Wed, 28 Oct 2020 22:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728553AbgJ1V4G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 17:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728480AbgJ1V4F (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Oct 2020 17:56:05 -0400
Received: from mail-oo1-xc42.google.com (mail-oo1-xc42.google.com [IPv6:2607:f8b0:4864:20::c42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB26C0613CF;
        Wed, 28 Oct 2020 14:56:05 -0700 (PDT)
Received: by mail-oo1-xc42.google.com with SMTP id f1so256322oov.1;
        Wed, 28 Oct 2020 14:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=j8/CVlMS0+Jct26CsRsjIDk4CnqibE10v8u/RGYN2Q0=;
        b=vgxNYdxcHzdX4RmeV5JjhqApgHSP5HZU6V4PA9CTby4tlFi7OxFwJ2vg8AsQPV6ahq
         BHMD+JDibkwAd/sxzQSRwKjUjJ1FCbWSX6sx/Mdv7gmQdydJOyWHBir64xCp0AQkdAlU
         pTO9mBHGpDGOU51QFHoWUj812cJPqySwHOkW/ZN+vwMMzmF2v1CbnRt4xQ4AjPNHqkg1
         qTlWY2ZYiUOR4Izl7JT+4rTSg6D2t3DprxYyVg0H7l3pxwxbFzDmdsYQ3FMzphZtxRn9
         veoFuIVzFcPsW0uYD8lyqtqSF+I8FuyDec57rdylTIRc6yd91vwhVzHwWwdUvMbednTp
         bxHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=j8/CVlMS0+Jct26CsRsjIDk4CnqibE10v8u/RGYN2Q0=;
        b=GZUmqyP6eRoW8khEiBjBuDt3xRTbeoBceya6DfWmQAxVqSWBOwn8EwQh54g6m14Kmt
         yG5OpIGvEAXdeefWKqx3rjYtKQmsUYJ8JqQ3X06oW1F39msn+LgUtPc0WVkzNIxQHs0r
         UCtzQvQtFDhBBzVOcA4+af/1BMbgDTbohz26FO/+cTbUiJ5wzBhUZ3o6jWSts7Hlbs8y
         FEpcd3t9oy197wP/lFvYnofJxkd1JrLDDuqC1ZUDaHUhzlaFJ2hMJ3octZ3GSsldoF3t
         gjeQBaNj8cSpJzglFsGOXqF/Lu6tZaxfPZOUb7MWb0R3dlN2ZeqPh62XOz+i0oybvP2a
         W3YA==
X-Gm-Message-State: AOAM532SUmElMtSxgdPGzzZUShlAexm1g+7ZaIzHeEMgwSQHLR01fWoU
        ZtTvIqfo2UvkrhjUFBm3NNnvejvJM/4=
X-Google-Smtp-Source: ABdhPJwtPmqsb+noSCAl0PeCCP0ZJ2qHKjTmNKfqQfBpRdwVXgxnMV34RDEi8IDq7Tzn+ECsi6zcyw==
X-Received: by 2002:a9d:7985:: with SMTP id h5mr627008otm.221.1603914998553;
        Wed, 28 Oct 2020 12:56:38 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f142sm119673oib.10.2020.10.28.12.56.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 28 Oct 2020 12:56:38 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 28 Oct 2020 12:56:37 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.8 000/633] 5.8.17-rc1 review
Message-ID: <20201028195637.GE124982@roeck-us.net>
References: <20201027135522.655719020@linuxfoundation.org>
 <20201028171138.GF118534@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028171138.GF118534@roeck-us.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Retry

On Wed, Oct 28, 2020 at 10:11:38AM -0700, Guenter Roeck wrote:
> On Tue, Oct 27, 2020 at 02:45:43PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.8.17 release.
> > There are 633 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 29 Oct 2020 13:53:43 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 154 pass: 154 fail: 0
> Qemu test results:
> 	total: 426 pass: 426 fail: 0
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>
> 
> Guenter
