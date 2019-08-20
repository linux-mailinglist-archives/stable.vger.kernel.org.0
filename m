Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4E2496B84
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 23:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730515AbfHTVf0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 17:35:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:51440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730430AbfHTVfZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 17:35:25 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9F34206DD;
        Tue, 20 Aug 2019 21:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566336925;
        bh=5ikUXGuNr55CKuUSDbmFQVG+9Qs6Yyoixxm/PXjPqgk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Hj1h0u/fsxgh7tM4YMBkJblu4+ytBbVeuNDeI2X1XWYjvAe4O05kQjo75WtBUoA0+
         r7X1qhiSZSVLagwTerKJ4hVp3jYKiPhgUXuUpyOapQROFv99fUG5scdchleZ1XDE/x
         YAGA5/mk/wR22TZFR0Gp758vWNMGelMBMz/H7HuA=
Date:   Tue, 20 Aug 2019 14:35:24 -0700
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: Please apply commit 0f0727d971f6 ("drm/amd/display: readd -msse2
 to prevent Clang from emitting libcalls to undefined SW FP routines") to
 4.19.y
Message-ID: <20190820213524.GA25049@kroah.com>
References: <CAKwvOdm0sWCF=PiNJvKWxt7CaTXSF13cZNuYPhKC=Kq8ooi1HA@mail.gmail.com>
 <20190820210716.GA31292@kroah.com>
 <20190820212539.GA1581@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820212539.GA1581@sasha-vm>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 20, 2019 at 05:25:39PM -0400, Sasha Levin wrote:
> On Tue, Aug 20, 2019 at 02:07:16PM -0700, Greg KH wrote:
> > On Tue, Aug 20, 2019 at 02:00:21PM -0700, Nick Desaulniers wrote:
> > > Please apply commit 0f0727d971f6 ("drm/amd/display: readd -msse2 to
> > > prevent Clang from emitting libcalls to undefined SW FP routines") to
> > > 4.19.y.
> > > 
> > > It will help with AMD based chromebooks for ChromeOS.
> > 
> > That commit id is not in Linus's tree, are you sure you got it correct?
> 
> That's a linux-next commit.

Great, we can wait for it to show up in Linus's tree first :)
