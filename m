Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1092EEFCB
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 10:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbhAHJlO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 04:41:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727762AbhAHJlN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jan 2021 04:41:13 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84EE8C0612F4;
        Fri,  8 Jan 2021 01:40:27 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id i7so7324508pgc.8;
        Fri, 08 Jan 2021 01:40:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UIMWNThMlb8quIZqiuEB9j3wA4qlDG0Qv9DWb7+v2mg=;
        b=rM/0CSYSV/d+qd8imNdoEixIqJLgfyDqZ7gLL1tNlWGJLfLlz7RMee5uFvDKkEaWbc
         O6Q79MizkB+gdhvcDH3uHUlDiDiyzRaPn4I/ZAt4yZjhqoFgYz1078KCohANjUIscoko
         pdDcRYgi5kNGRpHWtt23USorGxWR+SvwxEw40HtZfel32CFLxZmN4ESWepiK1+G7HI9E
         ymLW6sPRUHvo3ILuZ8/BrfzzW6kzkAVZV3Ax2jIgk6ZFbPzjzN0UHawijF3AF7N/+ZCp
         uwshOCGSdyIeuTIhAd/o7xuK1jND12IcMcd9XwED7p8dFkLdb++UEMmM4CfjrU6AbX9l
         vcCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=UIMWNThMlb8quIZqiuEB9j3wA4qlDG0Qv9DWb7+v2mg=;
        b=CAiwbEB1mUy+E6HyguVpLEY3OmAri2V/FPpid6mrm9wOg3wlhGoKmDWPLeYwkYXnCL
         KCweZCGcESyzk7J77ojb/qnDrpLmxG9NN/kG9BzBw+JTsvZ+2UH6S7ePSqsPDVdjnFGF
         2IwwBHvCsxfd+5wP6rp6ZKSuTw1wd58+rhxYP7BQ3AgzNqECbCgRP7zff24PlbIxwnaQ
         HHF37R9spSB7rCN/uUDNZa8oN5UdRNhEPBlBZTMqZ1bcAt7Z2qaNh2KupRQ6olZAILki
         cyHURUdba9BEL3Ish6rkK9qXDaam4i+dINqEXneWXiXuxVPJwRKeuDr2rmFGbVeSiIaU
         ooLQ==
X-Gm-Message-State: AOAM532ujw3j1jrOx+TMhQq7OaP9S+tdyhJrVfdlQ7zixn4Hx+bZ6Gk5
        DcSUQafM8SFkVgtdP1OGqXg=
X-Google-Smtp-Source: ABdhPJzY9j3GBFIGUnHKx/qtTLAdiLq3NA007Pxtpm6t421urUpmoDTlnIiKA/E496vt+h5nNPoZeA==
X-Received: by 2002:a63:c84a:: with SMTP id l10mr6310502pgi.159.1610098827099;
        Fri, 08 Jan 2021 01:40:27 -0800 (PST)
Received: from b29397-desktop ([84.17.34.154])
        by smtp.gmail.com with ESMTPSA id b2sm8208602pff.79.2021.01.08.01.40.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Jan 2021 01:40:25 -0800 (PST)
Date:   Fri, 8 Jan 2021 17:40:16 +0800
From:   Peter Chen <hzpeterchen@gmail.com>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        John Youn <John.Youn@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 0/2] usb: dwc3: gadget: Check for multiple start/stop
Message-ID: <20210108094016.GA13606@b29397-desktop>
References: <cover.1609865348.git.Thinh.Nguyen@synopsys.com>
 <20210108023646.GB4672@b29397-desktop>
 <93173de2-4ba0-52ab-1453-da5535c70ace@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93173de2-4ba0-52ab-1453-da5535c70ace@synopsys.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21-01-08 02:40:55, Thinh Nguyen wrote:
> Hi Peter,
> 
> Peter Chen wrote:
> > On 21-01-05 08:56:28, Thinh Nguyen wrote:
> >> Add some checks to avoid going through the start/stop sequence if the gadget
> >> had already started/stopped. This series base-commit is Greg's usb-linus
> >> branch.
> >>
> > Hi Thinh,
> >
> > What's the sequence your could reproduce it?
> >
> > Peter
> 
> You can test as follow:
> 
> # echo connect > /sys/class/udc/<UDC>/soft_connect
> # echo connect > /sys/class/udc/<UDC>/soft_connect
> 
> and
> 
> # echo disconnect > /sys/class/udc/<UDC>/soft_connect
> # echo disconnect > /sys/class/udc/<UDC>/soft_connect
> 
> Thinh
> 

Thanks, now I reproduce the issue. Another improvement you
might consider adding is checking return value for usb_gadget_udc_start
at soft_connect_store.

-- 

Thanks,
Peter Chen

