Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A59AF32D9EF
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 20:04:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbhCDTET (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 14:04:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236228AbhCDTDs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 14:03:48 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF18C061756
        for <stable@vger.kernel.org>; Thu,  4 Mar 2021 11:03:08 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id e9so7184995pjs.2
        for <stable@vger.kernel.org>; Thu, 04 Mar 2021 11:03:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nr3oLy5jzTpCoPyMzNAFUIGWjnIOXTpiZRPNu9wkg8c=;
        b=ugyHbENBovmu5bPIfLTS6wp8JGniwptBk+ZSBktpbP6V2Rey1reNgisrAhRokpLbj6
         eQ2d/zhE0jlP5+2qW34DNNgmYyIsmf4uP8pxqFEVi77P5oIwmEoero4MAaSVQu1goSE7
         eXtbYFCNDKbj7lmlVbvJFU+Nyy8ggCei2pLn2XlTTLVhjgfavy8B5djaE4lQ3z/yozkg
         U0pg6/KoT0xuFNKEw/L4u//1Ej3g/H5T2uyuBGIJTEYUgOmZyZ4zR0J0JLWPvGE6DJCQ
         cVm/mzQdcFjvUr8W8sHIBh03/R3QopU7TGFbd1zIJuhfIybo2/Ujkdwq8ZOTW10XmESV
         DSAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=nr3oLy5jzTpCoPyMzNAFUIGWjnIOXTpiZRPNu9wkg8c=;
        b=ahkJmGj78yt5TkyHLjFBAcCOfUk44a/u/MyJuEgu+f5OEc4wF7/m6/1ZVMf5gHTg7w
         QUoJxPaVkYVRYoiGOKaBiVxRnWEB5rVNnz4Owkxd3e/WLXf31ZkhTYdnv8j8hXi4it7N
         TamqDatnTYwcXh/CDlnNrC6bMXJpFoClW1qC2ZJU+tSEFGXNrrfSzFXSWClDhY7YsL18
         4Ns3wuuQ5odJN8syAqsyUVPovPPqdXI26hUpS/wn++kZ7I2bR7Jd9adOH4+Aqvsnd5Li
         wRdNwrrI+2W3Iuy+OeP1rHPJbkySwnADvGDfj8pjZ9S0AKMeqQY4z+AqIrutOQtpjMX8
         mD2A==
X-Gm-Message-State: AOAM532i8IwTVlQ+QkyClORFlRgabKknxxRjKk4ZWrRsm+Ntp+XcGjd0
        ELkxo6SgWoWdywYsuILXAb4=
X-Google-Smtp-Source: ABdhPJyajExM9c24IeoavBPj8X1u2vXI/LMuXvzvjGWJBkp4g2//Q99kmkX/ZSd+EX2YvXdphRIwLg==
X-Received: by 2002:a17:902:e5ce:b029:e5:dc8a:7490 with SMTP id u14-20020a170902e5ceb02900e5dc8a7490mr3789967plf.37.1614884587634;
        Thu, 04 Mar 2021 11:03:07 -0800 (PST)
Received: from google.com ([2620:15c:211:201:edb1:8010:5c27:a8cc])
        by smtp.gmail.com with ESMTPSA id gt22sm33048pjb.35.2021.03.04.11.03.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 11:03:06 -0800 (PST)
Sender: Minchan Kim <minchan.kim@gmail.com>
Date:   Thu, 4 Mar 2021 11:03:04 -0800
From:   Minchan Kim <minchan@kernel.org>
To:     gregkh@linuxfoundation.org, wu-yan@tcl.com
Cc:     akpm@linux-foundation.org, sergey.senozhatsky@gmail.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: FAILED: patch "[PATCH] zsmalloc: account the number of compacted
 pages correctly" failed to apply to 5.10-stable tree
Message-ID: <YEEu6AlLN7ISJnsN@google.com>
References: <1614520624144188@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1614520624144188@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 28, 2021 at 02:57:04PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,

Hi Rokudo,

Do you mind sending backport patches aginst tree failed to apply?
Thank you.
