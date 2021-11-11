Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4272444D554
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 11:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232318AbhKKKzZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 05:55:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbhKKKzZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Nov 2021 05:55:25 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ADA7C061766;
        Thu, 11 Nov 2021 02:52:36 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id u25so8417389ljo.12;
        Thu, 11 Nov 2021 02:52:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iEKA4VskprioZ3wq/U9m+wCXLZ4G97pCcQBnvlOh4Uo=;
        b=btLkorl9c8K853xVrxR1ADIOhdX23K66lM173VTISdcLAui9Uwt/y1wOtf64uYH2kZ
         Dfqh0Mnz01q/fHVPSAumedyawbY8zGsiN/ohklkbofF6iyOEsGIEtbyeA5Gwq8kyPC7K
         3Ie4wEUiPPjhiE+nr7bjZnLKswnBoKEO1ecaoOyktehx1CpwAgxDIP5AuT0iu0FoAmCw
         0BnmH6TUueo4T4bI2DbIHmxBLl0f/0vwYnYNvzJWPCF0LoxzJkAGFcnpBi5OQ/WDEBtA
         jbKlgVKxeFZlbzmDYcKMQsrlZ+pnWXSFveJITJ2PsdwpND/o6akXMvq+h+syJTulliUn
         B5SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iEKA4VskprioZ3wq/U9m+wCXLZ4G97pCcQBnvlOh4Uo=;
        b=FC/uEkKedq2HbVduSsYmnaqVQnRRJ3y1qOmaifJ4c2uySutdx2ChCDlk/ddXA1+IV6
         y1Y3xEgQUj33LTfWp4HBabxJW15tGxAVwigbQLttpLse953RCBU7lTA4zJjCW7uOKZsG
         XAWppFjuc53BJlumilM75E+WGGttmtuCXgsg0l+Y6aYhp6G35elKEGCotTxFCsfx13Tu
         wP47S1veBua8QcYhlntuBdkjIv54whbOStHSwJE9XRMOSXBENjgUp4Swm40n30GrIDLP
         Uc/ZTcYGn3GWsBSirgqOyERlWqNwPMjlJs396HUQEHTvlGdyWxX/n9zHpnMeqIVhglrn
         mjdQ==
X-Gm-Message-State: AOAM5313k33fjCfXTTXJHvROCP/ntpfcd0/TDJYjxdk3j48MFELaw8Vc
        IYABm7T19earApigsvGZ+jk=
X-Google-Smtp-Source: ABdhPJz1IYsvS04cZQ+CvSu8XzvmkMKAcCwl/+9b0JTk3164neupuBhveziHtfju1ysnhZD2DcJ+Dw==
X-Received: by 2002:a2e:83c6:: with SMTP id s6mr6345880ljh.477.1636627954556;
        Thu, 11 Nov 2021 02:52:34 -0800 (PST)
Received: from lahvuun (93-76-191-141.kha.volia.net. [93.76.191.141])
        by smtp.gmail.com with ESMTPSA id l11sm255066lfg.79.2021.11.11.02.52.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 02:52:34 -0800 (PST)
Date:   Thu, 11 Nov 2021 12:52:32 +0200
From:   Ilya Trukhanov <lahvuun@gmail.com>
To:     Javier Martinez Canillas <javierm@redhat.com>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev,
        linux-efi@vger.kernel.org, linux-pm@vger.kernel.org,
        tzimmermann@suse.de, ardb@kernel.org, rafael@kernel.org,
        len.brown@intel.com, pavel@ucw.cz,
        dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: [REGRESSION]: drivers/firmware: move x86 Generic System
 Framebuffers support
Message-ID: <20211111105232.apk2msip4ng7hgsw@lahvuun>
References: <20211110200253.rfudkt3edbd3nsyj@lahvuun>
 <627b6cd1-3446-5e55-ea38-5283a186af39@redhat.com>
 <20211111004539.vd7nl3duciq72hkf@lahvuun>
 <af0552fb-5fb5-acae-2813-86c32e008e58@redhat.com>
 <1ddb9e88-1ef8-9888-113b-fd2a2759f019@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ddb9e88-1ef8-9888-113b-fd2a2759f019@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 11, 2021 at 10:24:56AM +0100, Javier Martinez Canillas wrote:
> On 11/11/21 08:31, Javier Martinez Canillas wrote:
> 
> [snip]
> 
> >>> And for each check /proc/fb, the kernel boot log, and if Suspend-to-RAM works.
> >>>
> >>> If the explanation above is correct, then I would expect (1) and (2) to work and
> >>> (3) to also fail.
> >>>
> > 
> > Your testing confirms my assumptions. I'll check how this could be solved to
> > prevent the efifb driver to be probed if there's already a framebuffer device.
> > 
> 
> I've posted [0] which does this and also for the simplefb driver.
> 
> [0]: https://lore.kernel.org/dri-devel/20211111092053.1328304-1-javierm@redhat.com/T/#u

I applied the patch and it fixes the issue for me.
Thank you!

> 
> Best regards,
> -- 
> Javier Martinez Canillas
> Linux Engineering
> Red Hat
> 
