Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6DB5ACC01
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 12:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbfIHKTt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 06:19:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:38888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727945AbfIHKTt (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 06:19:49 -0400
Received: from localhost (unknown [80.251.162.164])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61D16207FC;
        Sun,  8 Sep 2019 10:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567937988;
        bh=6RGr8PQOWyIaRgGxUQE2vaEpQ+DEkWmYACF+abzXrlY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=z21jSOBc7GcRT7upD69/SoJVXAzLu+gFubq/+1gt0mGjPmIgDuwHqITBFp9FO6dxu
         H6pe8exAT6zC28KhfuWK9yv3SFsdXSO4gJh+r4hwdBoVw7r8pNFIKRyFwonFg6pS3C
         9w8d6Ck/ePoM9RR6R2qzt4bMWDmNoHNIwDBCoYjg=
Date:   Sun, 8 Sep 2019 11:19:44 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nadav Amit <namit@vmware.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Francois Rigault <rigault.francois@gmail.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Adit Ranadive <aditr@vmware.com>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] VMCI: Release resource if the work is already queued
Message-ID: <20190908101944.GA16596@kroah.com>
References: <20190820202638.49003-1-namit@vmware.com>
 <20190907184711.GA30206@kroah.com>
 <00CA348F-5ACC-4A17-A5F6-9B36C92A95E7@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00CA348F-5ACC-4A17-A5F6-9B36C92A95E7@vmware.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 08, 2019 at 04:04:39AM +0000, Nadav Amit wrote:
> > On Sep 7, 2019, at 9:47 PM, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > 
> > On Tue, Aug 20, 2019 at 01:26:38PM -0700, Nadav Amit wrote:
> >> Francois reported that VMware balloon gets stuck after a balloon reset,
> >> when the VMCI doorbell is removed. A similar error can occur when the
> >> balloon driver is removed with the following splat:
> > 
> > <snip>
> > 
> > Note, google thinks your email is spam as you are not sending this from
> > a valid vmware.com email server.  Please fix this up if you want to make
> > sure your patches actually make it through...
> 
> I used gmail servers since I get complaints (mainly from Linus) that our
> email servers use DMARC, and this causes mailing list postings to be
> rejected.

Well the email servers might not reject it now, but gmail itself sure
does as you are lying about what your domain is :(

> I will check again if our open source people got to a solution, or I
> would just send it using my gmail identity, while keeping the vmware
> authorship.

Please do, this is not a viable workflow.

thanks,

greg k-h
