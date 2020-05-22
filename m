Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4E71DE5F6
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 13:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728495AbgEVL6F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 May 2020 07:58:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:48370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728413AbgEVL6E (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 May 2020 07:58:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7061206B6;
        Fri, 22 May 2020 11:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590148683;
        bh=i73lIcu8dbreoO8obOxlyGP8aRtVvKMSUrIAxBKQ5sE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HxDa1xFahyEe06z1Ou+CNgPH9HX4eD62wMLeUU9BMpbjQPALTjvGznv84gDb3ABRX
         5RRFuKTyPUZ65qrhpd5rPHGrNAwVd0xLEZgLkuKR8iMY+IwjumgCy3TxNoj9e5XtY6
         qB54WbrTNgRD2a4B1HtzL9ZwBqP3MHlcub3AakdI=
Date:   Fri, 22 May 2020 13:58:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     stable@vger.kernel.org, Oliver O'Halloran <oohall@gmail.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Christoph Hellwig <hch@lst.de>, Jeff Moyer <jmoyer@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        linux-nvdimm@lists.01.org
Subject: Re: [5.4-stable PATCH 0/7] libnvdimm: Cross-arch compatible
 namespace alignment
Message-ID: <20200522115800.GA1451824@kroah.com>
References: <159010426294.1062454.8853083370975871627.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159010426294.1062454.8853083370975871627.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 21, 2020 at 04:37:43PM -0700, Dan Williams wrote:
> Hello stable team,
> 
> These patches have been shipping in mainline since v5.7-rc1 with no
> reported issues. They address long standing problems in libnvdimm's
> handling of namespace provisioning relative to alignment constraints
> including crashes trying to even load the driver on some PowerPC
> configurations.
> 
> I did fold one build fix [1] into "libnvdimm/region: Introduce an 'align'
> attribute" so as to not convey the bisection breakage to -stable.
> 
> Please consider them for v5.4-stable. They do pass the latest
> version of the ndctl unit tests.

What about 5.6.y?  Any user upgrading from 5.4-stable to 5.6-stable
would hit a regression, right?

So can we get a series backported to 5.6.y as well?  I need that before
I can take this series.

thanks,

greg k-h
