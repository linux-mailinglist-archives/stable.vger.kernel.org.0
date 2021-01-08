Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5202D2EEDF6
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 08:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725791AbhAHHpt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 02:45:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:50194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726863AbhAHHps (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Jan 2021 02:45:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2439E233EE;
        Fri,  8 Jan 2021 07:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610091908;
        bh=2e7BI1PeI+j2CbBdjPDsks/4ODPY4K4uo5shdAzai7M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=clGTlNVCxfCBFz5HtC4ObO975PpcDk/h2QJ+N6Hi7bhAgpgLwi1dfq4TDLSiD1O28
         wstGn4O4UBJqM7VYW/lhxRAg2weNIfVzwzw6Opc+29uffGY4+v9FNvOQM9MjJQdxhT
         bEhwg4wA/cU+wTFVUDZ+iVcGyQZdjwnzIl1TiFSw=
Date:   Fri, 8 Jan 2021 08:45:03 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Michael Walle <michael@walle.cc>
Cc:     Saravana Kannan <saravanak@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        stable <stable@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] driver core: Fix device link device name collision
Message-ID: <X/gNf4A6HwZTvNTU@kroah.com>
References: <20210107234136.740371-1-saravanak@google.com>
 <b3cda25a3e3911a12a8766f141c9e300@walle.cc>
 <CAGETcx-q04E0TW6LMoyoRC64xH25Uogk7twSNEbT411ciZPfUw@mail.gmail.com>
 <CAGETcx_CJjOxim+CEptLRSgfYAKHBbP8rHW7BY+U7-X+L2eObg@mail.gmail.com>
 <A645B0D5-82C4-46CE-80AD-1EF40D26ACCA@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A645B0D5-82C4-46CE-80AD-1EF40D26ACCA@walle.cc>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 08, 2021 at 02:10:51AM +0100, Michael Walle wrote:
> Am 8. Januar 2021 02:00:32 MEZ schrieb Saravana Kannan <saravanak@google.com>:
> >On Thu, Jan 7, 2021 at 4:43 PM Saravana Kannan <saravanak@google.com>
> >wrote:
> >Nevermind, I see it now. Also, in the future, if you can dump the logs
> >in some kind of pastebin site, that'd be nice. Avoid the emails
> >becoming unwieldy and also avoids the log lines from wrapping.
> 
> I thought about a pastebin. But then decided against it because they might be deleted in the future. So if anyone looking at the mail archives he might only get dead links. So.. 
> 
> dunno how this is handled on the LKML, tbh. 

Full logs are good, you did it right, Saravana can deal with long emails :)
