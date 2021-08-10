Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD49E3E5E68
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 16:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239783AbhHJOxK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 10:53:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:57786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234881AbhHJOxK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 10:53:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7429160F25;
        Tue, 10 Aug 2021 14:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628607167;
        bh=PmxhJh8wjqlZdEP0DhkKndXOmvjmEN0TwdkBhbS9saM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zB0jyjNvdEcCslvqWH3i+of12twGyXOUrq/z4dK7lhMu1M7yj6p24dczo+NM0/VOi
         AnkYsMtkqHtre2q4C9vi/akJP3ZVhPo9Xw//LMVg5QNE6WwLVO9TqG6MjUxjY/z6FR
         7MbVgEXMfYgLhhOwKLrlkb8XeZZ5JyLS/cVScViQ=
Date:   Tue, 10 Aug 2021 16:52:43 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sam Protsenko <semen.protsenko@linaro.org>
Cc:     stable@vger.kernel.org, Wesley Cheng <wcheng@codeaurora.org>
Subject: Re: Add "usb: dwc3: Stop active transfers before halting the
 controller" to 5.4-stable
Message-ID: <YRKSuxwJk6N05Iv6@kroah.com>
References: <CAPLW+4nyWAp99CTVy+wJ0rnbs9JpDvNaQaVityJi=sVPTkyDSA@mail.gmail.com>
 <YRDs8YYl1uEycsQl@kroah.com>
 <CAPLW+4kOfTMyfwzfBFdXYLqk-75rtp_ihFLsAYtb6h79LfRWjg@mail.gmail.com>
 <YRIqUe9KBd2+6pAd@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRIqUe9KBd2+6pAd@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 10, 2021 at 09:27:13AM +0200, Greg Kroah-Hartman wrote:
> On Mon, Aug 09, 2021 at 07:58:24PM +0300, Sam Protsenko wrote:
> > On Mon, 9 Aug 2021 at 11:53, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Fri, Aug 06, 2021 at 04:25:17PM +0300, Sam Protsenko wrote:
> > > > Hi Greg,
> > > >
> > > > Suggest including next patch (available in linux-mainline) to
> > > > 5.4-stable branch: commit ae7e86108b12 ("usb: dwc3: Stop active
> > > > transfers before halting the controller"). It's also already present
> > > > in 5.10 stable. Some fixes exist in 5.10-stable for that patch too.
> > >
> > > Can you provide a list of the fixes that also need to be backported?  I
> > > do not want to take one patch and not all of the relevant ones.
> > >
> > 
> > Sure. Here is the whole list:
> > 
> > [PATCH 01/04]
> > usb: dwc3: Stop active transfers before halting the controller
> > UPSTREAM: ae7e86108b12351028fa7e8796a59f9b2d9e1774
> > 
> > [PATCH 02/04]
> > usb: dwc3: gadget: Restart DWC3 gadget when enabling pullup
> > UPSTREAM: a1383b3537a7bea1c213baa7878ccc4ecf4413b5
> > 5.10-stable: dd8363fbca508616811f8a94006b09c66c094107
> > 
> > [PATCH 03/04]
> > usb: dwc3: gadget: Prevent EP queuing while stopping transfers
> > UPSTREAM: f09ddcfcb8c569675066337adac2ac205113471f
> > 5.10-stable: c7bb96a37dd2095fcd6c65a59689004e63e4b872
> 
> This patch did not apply cleanly :(
> 
> Can you send a working set of backported patches so that I know to get
> this all fixed up correctly?

Ok, I think I got this myself...
