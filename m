Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45F4F3DB396
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 08:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237205AbhG3G2v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 02:28:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:50552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230203AbhG3G2v (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Jul 2021 02:28:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AA8E60F94;
        Fri, 30 Jul 2021 06:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627626525;
        bh=mgmofoyWOM4qFQckZNYBEi9RID14QH2NHm5Szsxdb5w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ge+oFyusv5GBW4XsjEnneZV89yagGZQ/BTLci+3hqlZZ5jP5j2HZVBJvepTLXjXiy
         c5aAYf2tpagInC+s3cTagqDU9uVIRmT2MEPt+bVoe3swckz0PcqEk8KpzFwejtFPKr
         MxGH6xFjAwSleyLaQEDsKyGHlIemuQzr1D9Srzik=
Date:   Fri, 30 Jul 2021 08:28:43 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     stable@vger.kernel.org, sashal@kernel.org
Subject: Re: [RFC/PATCH 0/2] Backports CVE-2021-21781 for 4.4 and 4.9
Message-ID: <YQOcG1DD7iIIaufr@kroah.com>
References: <20210730060805.342577-1-nobuhiro1.iwamatsu@toshiba.co.jp>
 <YQObyFN/7K1bJ43Z@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQObyFN/7K1bJ43Z@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 30, 2021 at 08:27:20AM +0200, Greg KH wrote:
> On Fri, Jul 30, 2021 at 03:08:03PM +0900, Nobuhiro Iwamatsu wrote:
> > Hi,
> > 
> > This is a patch series to CVE-2021-21781.
> 
> Given that this looks to be a "private" CVE at this point in time:
> 	https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-21781
> you are going to have to provide a bit more information here :(

Ah, nevermind, patch 2 explains things, this is fine, thanks for the
backports.

greg k-h
