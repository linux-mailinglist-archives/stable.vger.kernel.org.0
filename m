Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD8A63B42
	for <lists+stable@lfdr.de>; Tue,  9 Jul 2019 20:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729191AbfGISlP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jul 2019 14:41:15 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33512 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728675AbfGISlP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jul 2019 14:41:15 -0400
Received: by mail-pf1-f194.google.com with SMTP id g2so4932597pfq.0;
        Tue, 09 Jul 2019 11:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=q4p/aB+jJ8Lml597l9nonv8Or/rUmgnzsnpC6/B+Pmw=;
        b=garwvlFaPPbuuJcg8PXKd/TRcnt7etr7RYid4IGlHLGaBE+5NFFuUsz1oY1WhSHcNy
         NO07gkYn5x1T9+dilPbAUDI9GoLPigmsMKVeokaG3V0bZu7C+K6K/qJQDwYqA2fnEN4e
         2nGNwHmIvS94eBUrfxHm5iC9AJUIQ8VT/jBy48vBKgKji7W7idMLOpuv8+hz13HFbq9G
         IyN1vFjyim2psKZE9rMJYgEmtgF61RiG3pS2tyvHYzHAv00Yhj3oNaS8zXQ5W7UlFAiu
         gUIURLI/x0tb6GRtQ5gB661l/p5BzUnvlhIw+RYaGmM9Mvp+5llu3H8JcPOQmFb9dcZe
         3CRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=q4p/aB+jJ8Lml597l9nonv8Or/rUmgnzsnpC6/B+Pmw=;
        b=tWWsmoKQfX1r8sEZ23B8HzDKmzllZh7/Ky0dlOI5QxnDG12veSbmoDZ+pQSYjs4aOs
         05xD+YnesqcfELuHM2eZ13jWNoefwnbGbdEwdZRra/Sj5EuJsR6my2fxgJ1RZO9h5zRx
         OpX1/AHmYHDa11+2vbX5BX1D6nnISA+PLXavDlk6eEJRbowK+ejZFcSjHynbxGTNCT9M
         KyXdFgr3GjgNEvAPstFj244ukKbdiHI5xK/LHlJE+AcIUpp2zjqHOu4pN3EbWAYSAKY0
         tWUEHfaN+pNIb5wGpgnejBNdtYnkycDAoJAeiHHc3CgS7gZIgQ7EfvSFW6MfzP9FspsK
         bSHw==
X-Gm-Message-State: APjAAAW7OtMWPOe1vWZVQDOiUapY58zEtYGmvM73QsCp0OGDcCIGIBCJ
        IjkVQHaefiwc+wbPEhyaCnE=
X-Google-Smtp-Source: APXvYqz1HOiiO4O8rZ6YelZz5Gbbei03PVDko52dlREFvM+RphpKwoF+0b0pNcoPSJ4xGtneGtYg3g==
X-Received: by 2002:a65:60cc:: with SMTP id r12mr33705770pgv.333.1562697674636;
        Tue, 09 Jul 2019 11:41:14 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i126sm22232751pfb.32.2019.07.09.11.41.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Jul 2019 11:41:14 -0700 (PDT)
Date:   Tue, 9 Jul 2019 11:41:13 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/56] 4.14.133-stable review
Message-ID: <20190709184113.GB2656@roeck-us.net>
References: <20190708150514.376317156@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708150514.376317156@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 08, 2019 at 05:12:52PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.133 release.
> There are 56 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 10 Jul 2019 03:03:52 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 346 pass: 346 fail: 0

Guenter
