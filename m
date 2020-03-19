Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF5D118C2FA
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 23:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725787AbgCSW2J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 18:28:09 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:46600 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727345AbgCSW2I (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Mar 2020 18:28:08 -0400
Received: by mail-lj1-f194.google.com with SMTP id d23so4329726ljg.13
        for <stable@vger.kernel.org>; Thu, 19 Mar 2020 15:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cPY4yGqsVmjSkC4+Qbn00vPfMkEqDvIIRfhbCdPDITY=;
        b=QoHbF8n+l3rljrBdRj0dazA6824Cz9+VSZknbiL+/2NpUNn690cGYbD7S+o3C1e8aE
         vBP2xhwoSg58MlOtwVLxDh0YWkhMAcFG8rP/BYCzP1LN9hHsfrbol4hp3EyknXU5dVwv
         +odiVUrsoezd/JzIfZCRo6ZuEVZ0QEdd4tVp+Jz3KbjF0Ip2jnZDiHqNWCLQv5ayFpC4
         +Vdwm3wEGXBJtd3Ynh0bWhZVcclkjNHwyBSeZoP6drr94bcDXViEixPNN4nV2gpIKTcB
         9olUrxUWP0QkC69sjbGZLqnO+ZxhnkuTU5hXFfQyZntqH2kTbEiZRUCDZ7otDUcgYcR/
         Pjpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cPY4yGqsVmjSkC4+Qbn00vPfMkEqDvIIRfhbCdPDITY=;
        b=XVdKj2GerwqpEruY4kOWIkWjuf6DZpQkM2jEUeP3mDPi6EM+2oXZOloiSd7HNiYm3l
         B9AwSGUnFwDh86tDr5mG/ZQaImCA5QO/GXTguMEwD4ae/4zKcTVldjYVcENFWLukiMwt
         7AMS1euPYOq2VmnyGyWPulVvLtAAYeF0LKy+o/p01XhqFCFCKjD3UA28gDUUzFAcb2Zg
         QWuQJbT9FDNg3aQyJXmQC1Y9o3ESbzEhtFzTVqqQvhY7qm9yxOY7dRhF2oxv74cOwEAC
         Ms7Sh5T3UDZeIcgBn6U6eKUs2VQEIUicjmNjU+MebFi7i9aNxy/VwCMfBwHCdoNUU1Os
         zS1w==
X-Gm-Message-State: ANhLgQ1WxKZcmvkkMLR7KLNPYEAoUj2o7e5TqrLJV5shXRMSY+s/tJtG
        t5bvAjH71lDNjy/KcmW1S71Nv9Cx+eH8zirGPXa97g==
X-Google-Smtp-Source: ADFU+vvOtD5TXrE6/8549mbEx43NTzKslm4CnrZBFrIbNGPMBdllKCIDvnPzK7abXAKB9AL0q2OIRRVoGn2ouVBUiL0=
X-Received: by 2002:a2e:9a90:: with SMTP id p16mr3552497lji.277.1584656886019;
 Thu, 19 Mar 2020 15:28:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200319123926.466988514@linuxfoundation.org> <20200319123926.902914624@linuxfoundation.org>
 <20200319133355.GB711692@pek-khao-d2.corp.ad.wrs.com> <20200319134710.GA4092809@kroah.com>
 <20200319144753.GD711692@pek-khao-d2.corp.ad.wrs.com>
In-Reply-To: <20200319144753.GD711692@pek-khao-d2.corp.ad.wrs.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 19 Mar 2020 23:27:53 +0100
Message-ID: <CACRpkdZcAR-XeJ34MSBqebAGB+ycHZN7i=KE9LHExW6zH2XMLA@mail.gmail.com>
Subject: Re: [PATCH 5.5 01/65] gpiolib: Add support for the irqdomain which
 doesnt use irq_fwspec as arg
To:     Kevin Hao <haokexin@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 19, 2020 at 3:48 PM Kevin Hao <haokexin@gmail.com> wrote:

> Yes, this commit does change the context of commit f98371476f36 ("pinctrl: qcom:
> ssbi-gpio: Fix fwspec parsing bug"). So I am fine to keep this in order to apply
> f98371476f36 cleanly. But there is no really logical dependency between these two
> commits, so another option is that we can adjust the commit f98371476f36 a bit in order
> to apply to v5.5.x cleanly without this commit, something like below. IMHO, it is more
> suitable for the stable kernel.

Thanks for fixing that so quickly Kevin! Much appreciated.

Yours,
Linus Walleij
