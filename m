Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADD5A2A4EE4
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 19:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728471AbgKCSae (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 13:30:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:46854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728621AbgKCSae (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 13:30:34 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BEC52071A;
        Tue,  3 Nov 2020 18:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604428232;
        bh=IdXnvLatM+w76Ko0oso5Y1l2VaxbjxPaI2sXBzUA9CM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U4Z7OfOoBPoVfb9aCHe14LwPjgkBnOYEGKA7EUOp9wJuTYNqgIDTu5dbpnEZJumqf
         qc0OESP5reWCAhrcy64F2PkeueTlGPtraz2DfS5gCklfor5XuLoN9+5ba72DOpPucg
         fGp0Y9Mx0FdFJSHyqP/ytKcxKsY3s0ewanm0P3J4=
Date:   Tue, 3 Nov 2020 19:30:28 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Costa Sapuntzakis <costa@purestorage.com>
Cc:     stable@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: Re: Fwd: remove ext4-fix-superblock-checksum-calculation-race.patch ?
Message-ID: <20201103183028.GB83845@kroah.com>
References: <CAABuPhZKJncNoVb3-um8WTdyvffvcYqPKDUA_AcpmEZQrMshTg@mail.gmail.com>
 <CAABuPhZZG13uxa-NpiH1k1HbNYx2QDLEOLURsVnBmu8ynZcaig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAABuPhZZG13uxa-NpiH1k1HbNYx2QDLEOLURsVnBmu8ynZcaig@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 03, 2020 at 09:24:57AM -0800, Costa Sapuntzakis wrote:
> syzbot found https://syzkaller.appspot.com/bug?extid=7a4ba6a239b91a126c28
> which shows we can try to sleep under a spinlock in an error path.

Do you have a patch for this?

confused,

greg k-h
