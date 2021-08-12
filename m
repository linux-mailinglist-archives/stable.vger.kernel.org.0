Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB603EA957
	for <lists+stable@lfdr.de>; Thu, 12 Aug 2021 19:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232307AbhHLRTj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Aug 2021 13:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235486AbhHLRTi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Aug 2021 13:19:38 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B6F8C061756
        for <stable@vger.kernel.org>; Thu, 12 Aug 2021 10:19:13 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id k24so4331020vsg.9
        for <stable@vger.kernel.org>; Thu, 12 Aug 2021 10:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d/1htVpI9h7AxpYebFdcodubuyizTFeSVjOTXvhUwC8=;
        b=Gz3BENy7STbpiDxu/sR+xuHckoXiQJhV7XKfVyFK9RIun1cNt/Op2694IgETg1YnOD
         hzB7kohPyVGGt9O/SRPVLWJL59ahCUkEDLtQfo0T8VufgxDldNNdk0jiXY3RENQ6NVro
         bfNKJPv8d2FqibbU7gYrpYNBE7hT2PPA2cazS4A9vO34FT9csRx1yEVMPhOJJzFbBey6
         QYM1Swia08Q/abppl6ojaktUgjbv5k/FtdW+8UZELp9mD4f6sErX+QWJBcyhmav7hVy8
         ggpfXU29CufOOl1Z6FEB51mzYXrEqn9nHsdl7eRwAWYVrX40G5bGPkeTGc7d0gW05YAT
         ss/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d/1htVpI9h7AxpYebFdcodubuyizTFeSVjOTXvhUwC8=;
        b=dzAiSbu867BmP6qWlM8LoTacn1WCmOcluU0bHfsuNZMn5ZwshWu96MR2uM7rfIpanw
         jGUGR7rlTtYzc8IsFUjN8ZNnZg2/yTFEKZczShpTEBfUp7L6o+JGXWerCmw4AnVG/9Mh
         Phrg7DdY+UZgjup1/2EB0ZVLDsyC4v0mRaCpawlWIR+XnUbN0InDsKORq4cIqFALn0lY
         KPxJVJczqoE1W4NWxZ5Vz+kkWkvU6ewR3NJkYwptqMLvgsH5i6OhzqPZ9vT4iCcskC+1
         k40D2rVicR4Mu+JFqslmMYycu34bSUxfCPnR8MielDTeqetuZf7zbHstNYFi5yIRgrwf
         CQUw==
X-Gm-Message-State: AOAM531FqLvP260fEUy/KnYLrSfuOG/J0lJA3FN18fNncKgUx3UaEsyv
        6PMxGvBpjC6TWCc2bYdI5/p3ty5D0Rw5k0k1uSPNiJscnPYgwUi9
X-Google-Smtp-Source: ABdhPJwXl1yd9LjVVqxrwgaP/ALxgzEpdjdTPZzW5jZ+B/9nOPa961Wk2+IP4oROPBBB/9+6BUPZkrrKjxBCRI7ww58=
X-Received: by 2002:a05:6102:942:: with SMTP id a2mr4228310vsi.30.1628788752260;
 Thu, 12 Aug 2021 10:19:12 -0700 (PDT)
MIME-Version: 1.0
References: <CAPLW+4nyWAp99CTVy+wJ0rnbs9JpDvNaQaVityJi=sVPTkyDSA@mail.gmail.com>
 <YRDs8YYl1uEycsQl@kroah.com> <CAPLW+4kOfTMyfwzfBFdXYLqk-75rtp_ihFLsAYtb6h79LfRWjg@mail.gmail.com>
 <YRIqUe9KBd2+6pAd@kroah.com> <YRKSuxwJk6N05Iv6@kroah.com> <YRKUDDmz3ylrUBmd@kroah.com>
 <CAPLW+4=BngUFjt76PmWU5H-US6SL4bZ0WTFsBeeGZjnirLYh9Q@mail.gmail.com>
In-Reply-To: <CAPLW+4=BngUFjt76PmWU5H-US6SL4bZ0WTFsBeeGZjnirLYh9Q@mail.gmail.com>
From:   Sam Protsenko <semen.protsenko@linaro.org>
Date:   Thu, 12 Aug 2021 20:19:00 +0300
Message-ID: <CAPLW+4kiOHkj-b2b_TAJm8YoHbQYEyOV3VKEpziv4CY=CjeX+A@mail.gmail.com>
Subject: Re: Add "usb: dwc3: Stop active transfers before halting the
 controller" to 5.4-stable
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Wesley Cheng <wcheng@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 10 Aug 2021 at 20:55, Sam Protsenko <semen.protsenko@linaro.org> wrote:
>
> On Tue, 10 Aug 2021 at 17:58, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Aug 10, 2021 at 04:52:43PM +0200, Greg Kroah-Hartman wrote:
> > > On Tue, Aug 10, 2021 at 09:27:13AM +0200, Greg Kroah-Hartman wrote:
> > > > On Mon, Aug 09, 2021 at 07:58:24PM +0300, Sam Protsenko wrote:
> > > > > On Mon, 9 Aug 2021 at 11:53, Greg Kroah-Hartman
> > > > > <gregkh@linuxfoundation.org> wrote:
> > > > > >
> > > > > > On Fri, Aug 06, 2021 at 04:25:17PM +0300, Sam Protsenko wrote:
> > > > > > > Hi Greg,
> > > > > > >
> > > > > > > Suggest including next patch (available in linux-mainline) to
> > > > > > > 5.4-stable branch: commit ae7e86108b12 ("usb: dwc3: Stop active
> > > > > > > transfers before halting the controller"). It's also already present
> > > > > > > in 5.10 stable. Some fixes exist in 5.10-stable for that patch too.
> > > > > >
> > > > > > Can you provide a list of the fixes that also need to be backported?  I
> > > > > > do not want to take one patch and not all of the relevant ones.
> > > > > >
> > > > >
> > > > > Sure. Here is the whole list:
> > > > >
> > > > > [PATCH 01/04]
> > > > > usb: dwc3: Stop active transfers before halting the controller
> > > > > UPSTREAM: ae7e86108b12351028fa7e8796a59f9b2d9e1774
> > > > >
> > > > > [PATCH 02/04]
> > > > > usb: dwc3: gadget: Restart DWC3 gadget when enabling pullup
> > > > > UPSTREAM: a1383b3537a7bea1c213baa7878ccc4ecf4413b5
> > > > > 5.10-stable: dd8363fbca508616811f8a94006b09c66c094107
> > > > >
> > > > > [PATCH 03/04]
> > > > > usb: dwc3: gadget: Prevent EP queuing while stopping transfers
> > > > > UPSTREAM: f09ddcfcb8c569675066337adac2ac205113471f
> > > > > 5.10-stable: c7bb96a37dd2095fcd6c65a59689004e63e4b872
> > > >
> > > > This patch did not apply cleanly :(
> > > >
> > > > Can you send a working set of backported patches so that I know to get
> > > > this all fixed up correctly?
> > >
> > > Ok, I think I got this myself...
> >
> > Ick, no, the 4th patch had problems.  I need a backported series,
> > thanks!
> >
>
> Sure, will do shortly. As I remember, kdiff3 resolved those conflicts
> automagically for me (correctly).
>

Hi Greg,

Just sent those in a patch series: "[PATCH 5.4 0/7] usb: dwc3: Fix DRD
role switch". Found more fixes and dependencies, now it seems to be
complete, and applies nicely.

Thanks!

> > greg k-h
