Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0626211201F
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:17:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbfLCXRf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 18:17:35 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38087 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727240AbfLCXRf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Dec 2019 18:17:35 -0500
Received: by mail-wm1-f65.google.com with SMTP id p17so5747767wmi.3
        for <stable@vger.kernel.org>; Tue, 03 Dec 2019 15:17:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SS5+8rwkLwqLJi6xH1RZebMbkXc7Vuqf7UknLD2SdHg=;
        b=mTp5Vub4vQIvQpUeiW3qDPgB1sr8T8a61dmF4OGF4Qq6QnTMkm3P9TtW3Ar+gWDGVC
         EH9VMT0/6j0WoIC3PcwJCtm6/zOQnDHrIOVoKy9TuMfaHOxA+LrWMHAW7cv5cgmgrVhw
         GupRwv/9/rwKbPoxdkeZbB8qOUdpVo+DH3Capi5ZtPesKE8Rmqqx7HoryPcwgm7wyapX
         YDRJQWphmd+ldyj2RcTypj2c8zhdUPTfaMEvRBHMqlpmC/immd8mvfP+IQVoTossYOHQ
         AavOVMg4U5ebvrSkVAK03pS2qGF/McrFeM/UwPWt58O+JjLsJGl1Hgb1Pwkuz6Os6Y9C
         K8tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SS5+8rwkLwqLJi6xH1RZebMbkXc7Vuqf7UknLD2SdHg=;
        b=eXWYOysvyZ5mZUN+fE8tLsk2YwxXLEvua/FjR46SNCJd+5cqo5GZq7ItdGrWJ8EN8j
         dqyp5AWtdJBtyf/7G/00qE5x5NHwYlZinALAOzd4BY/vJsD+dgxmd64PLybYIkSjakNQ
         qm4QC3XJG/uh9nA3+/xsADSKc1ewhLSemKvkjU00f5vc9meRnYUAso2fywTOW//LPBjw
         wpqyfJKeWiaHdKCSHxClbbYUCodEigh1JXLnUgmH9rgHm+asJpZ4Cz5oOyf/oXPNv0cn
         MTFXN2UJRSqhnn2D29t254PzQpH5PEPMbCsFMyGlANZxJL22Ygtt5qhyu8q5y3BWOnlr
         USiQ==
X-Gm-Message-State: APjAAAUV8n7FhBMNIicA9gaN1j+7ERjTcJvhQy7Ez1UYf4qDC+q3cq0R
        tF1pR3INC+drJeNfNkTV5sN5U4igDBNm2S73OLSJ5J8808w=
X-Google-Smtp-Source: APXvYqxAnCgFYQDDhuTgRvBPrWxxSdFyWAfacChdQEzT0Aawjc5z62GOanvpeAI1PhnbEMACRiqdm6qfVULHBChwx2w=
X-Received: by 2002:a7b:cd83:: with SMTP id y3mr39095260wmj.168.1575415051248;
 Tue, 03 Dec 2019 15:17:31 -0800 (PST)
MIME-Version: 1.0
References: <CAPtwhKrmvw8wm1u_36YEoLgQ8pGe=v5xaV2RN4W6jVw3zOgeQQ@mail.gmail.com>
 <20191203230944.GA3495297@kroah.com>
In-Reply-To: <20191203230944.GA3495297@kroah.com>
From:   Xuewei Zhang <xueweiz@google.com>
Date:   Tue, 3 Dec 2019 15:17:20 -0800
Message-ID: <CAPtwhKpZCequxTMzAcVcJ34EW4AFqNDcWuoud-D3nywpYxzx5Q@mail.gmail.com>
Subject: Re: Request to backport 4929a4e6faa0 to stable tree
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 3, 2019 at 3:09 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Dec 03, 2019 at 02:54:57PM -0800, Xuewei Zhang wrote:
> > Hi Stable kernel maintainers,
> >
> > I want to backport below patch to stable tree:
> > 4929a4e6faa0 sched/fair: Scale bandwidth quota and period without
> > losing quota/period ratio precision
>
> What tree(s) do you want it backported to?
>
> It's already been backported to 5.3.9 and 5.4, is that not sufficient?

We should backport this into all supported stable versions, as the bug
is affecting all of them:
4.19, 4.14, 4.9, 4.4, 3.16.

>
> If so, can you provide working backports to any older stable kernels
> that you wish to see it merged into?

Happy to do that! I will send them in a few Emails following this
thread to provide the backports.
Please let me know if this is not the correct way to send patches.

Thanks!
Xuewei

>
> thanks,
>
> greg k-h
