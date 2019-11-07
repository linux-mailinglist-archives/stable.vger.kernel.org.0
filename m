Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6F85F2DB3
	for <lists+stable@lfdr.de>; Thu,  7 Nov 2019 12:48:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbfKGLst (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Nov 2019 06:48:49 -0500
Received: from mx2.suse.de ([195.135.220.15]:54304 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727178AbfKGLst (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Nov 2019 06:48:49 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A4989AD0B;
        Thu,  7 Nov 2019 11:48:47 +0000 (UTC)
Message-ID: <1573126365.3024.4.camel@suse.com>
Subject: Re: [PATCH 4.19 114/149] UAS: Revert commit 3ae62a42090f ("UAS: fix
 alignment of scatter/gather segments")
From:   Oliver Neukum <oneukum@suse.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alan Stern <stern@rowland.harvard.edu>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Date:   Thu, 07 Nov 2019 12:32:45 +0100
In-Reply-To: <20191105163805.GB2760793@kroah.com>
References: <Pine.LNX.4.44L0.1911051007140.1678-100000@iolanthe.rowland.org>
         <1572968467.2921.27.camel@suse.com> <20191105163805.GB2760793@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am Dienstag, den 05.11.2019, 17:38 +0100 schrieb Greg Kroah-Hartman:
> > > Given this information, perhaps you will decide that the revert is 
> > > worthwhile.
> > 
> > Damned if I do, damned if I do not.
> > Check for usbip and special case it?
> 
> We should be able to do that in the host controller driver for usbip,
> right?  What is the symptom if you use a UAS device with usbip and this
> commit?

Yes, that patch should then also be applied. Then it will work.
Without it, commands will fail, as transfers will end prematurely.

	Regards
		Oliver

