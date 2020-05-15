Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8964E1D4F46
	for <lists+stable@lfdr.de>; Fri, 15 May 2020 15:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbgEONbb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 May 2020 09:31:31 -0400
Received: from thoth.sbs.de ([192.35.17.2]:50252 "EHLO thoth.sbs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726160AbgEONbb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 May 2020 09:31:31 -0400
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 May 2020 09:31:29 EDT
Received: from mail1.sbs.de (mail1.sbs.de [192.129.41.35])
        by thoth.sbs.de (8.15.2/8.15.2) with ESMTPS id 04FDNxTX011198
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 May 2020 15:23:59 +0200
Received: from md1za8fc.ad001.siemens.net ([167.87.8.125])
        by mail1.sbs.de (8.15.2/8.15.2) with ESMTP id 04FDNwUK026690;
        Fri, 15 May 2020 15:23:58 +0200
Date:   Fri, 15 May 2020 15:23:57 +0200
From:   Henning Schild <henning.schild@siemens.com>
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: Re: backport of cifs patch to 4.4.x and 4.9.x
Message-ID: <20200515152357.18df3fd3@md1za8fc.ad001.siemens.net>
In-Reply-To: <20200515125748.GA1936050@kroah.com>
References: <20200515134420.50480bb7@md1za8fc.ad001.siemens.net>
        <20200515125748.GA1936050@kroah.com>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am Fri, 15 May 2020 14:57:48 +0200
schrieb Greg KH <greg@kroah.com>:

> On Fri, May 15, 2020 at 01:44:20PM +0200, Henning Schild wrote:
> > Hi,
> > 
> > please backport the following path to 4.4.x and 4.9.x
> > 
> > subject: cifs: Fix a race condition with cifs_echo_request
> > hash: f2caf901c1b7ce65f9e6aef4217e3241039db768  
> 
> It does not apply cleanly, can you provide a working backport so that
> we can queue it up properly?

Sure, just did that. The 4.4 one has been runtime-tested since a few
days, but the bug is hard to trigger. The 4.9 has only been
compile-time tested.

They are backports, and Pavel already confirmed that this should be
done. That was in a personal email though ...

Henning

> thanks,
> 
> greg k-h

