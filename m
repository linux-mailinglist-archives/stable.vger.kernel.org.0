Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1883438294C
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 12:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231840AbhEQKDa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 06:03:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:53294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236393AbhEQKDM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 06:03:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DE2661029;
        Mon, 17 May 2021 10:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621245713;
        bh=K4yEuz9FYYQvrGIGVmWYP2UnG2JLIdaG5G9xrIkdLyw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jBvzocVD/obZ4/grmy2Lwx+NZsOw0gPOoGjeFYD75LUqnVzJbnTakoHiTI1GLGy0o
         Py3KIddhHHhiz9NkaegMUYfIyhvsoBoWw3Ej6spki/TMjY9TNS5Iuv8IpzuomK8tx7
         jABWfFhoQOSa1yBXF7sIzbqIiRzhcHC3hl4Yekck=
Date:   Mon, 17 May 2021 12:01:51 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
Cc:     stable@vger.kernel.org
Subject: Re: 5.10.37 won't boot on my system, but 5.10.36 with same config
 does
Message-ID: <YKI/D64ODBUEHO9M@kroah.com>
References: <e0e9ecf4-cfd7-b31a-29b0-ead4a6c0ee40@charleswright.co>
 <1621180418@msgid.manchmal.in-ulm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1621180418@msgid.manchmal.in-ulm.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 16, 2021 at 06:00:14PM +0200, Christoph Biedl wrote:
> Charles Wright wrote...
> 
> > I see a couple of other posts with same issue.
> 
> Count me in. It's not a global issue, though, various machine rebooted
> without any problems. Only failing device so far was an old x200
> Thinkpad - stalls before console gets intialized, so I have no idea at
> all what went wrong there. And I'm sorry, I don't have the time for
> bisecting at the moment.

Hopefully now fixed in the stable queue, I'll push out new -rc releases
today for people to test.

thanks,

greg k-h
