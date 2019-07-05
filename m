Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 875C060523
	for <lists+stable@lfdr.de>; Fri,  5 Jul 2019 13:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727515AbfGELOH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jul 2019 07:14:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:58750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726921AbfGELOG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jul 2019 07:14:06 -0400
Received: from localhost (83-84-126-242.cable.dynamic.v4.ziggo.nl [83.84.126.242])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89811218BA;
        Fri,  5 Jul 2019 11:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562325246;
        bh=c+HM9JwYeeYTrJdt+3xQ699lq42gvOfuskv5Qph0jNE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t9udehTkLpRnvZXV2SI0PhzoO9mn315BULB5oTgwJp+Q+Sy/KICsWgCV1evVlPwqa
         CjSx7kQpHCUcR8uJVcZuSKxr/GcBh17SYn1446++Trvx0w7EWw0HuegnuiLfVBKeOp
         xNteXELIYPuO4T+1FW30UXirNmzpWBd0h95IpF9c=
Date:   Fri, 5 Jul 2019 13:14:03 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Balbir Singh <sblbir@amzn.com>
Cc:     stable@vger.kernel.org
Subject: Re: [backport to v4.14 CVE-2019-3900 0/7] Fix CVE-2019-3900 in
 stable v4.14
Message-ID: <20190705111403.GB14533@kroah.com>
References: <20190702210210.2375-1-sblbir@amzn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190702210210.2375-1-sblbir@amzn.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 02, 2019 at 09:02:03PM +0000, Balbir Singh wrote:
> These series of patches are required to fix the specified CVE in v4.14.
> I've tested these patches with a VM running vhost. Jason Wang who originally
> wrote the patches, helped identify other patches to backport and also tested
> this version and provided feedback on the patches.
> 
> Jason Wang (5):
>   vhost_net: introduce vhost_exceeds_weight()
>   vhost: introduce vhost_exceeds_weight()
>   vhost_net: fix possible infinite loop
>   vhost: vsock: add weight support
>   vhost: scsi: add weight support
> 
> Paolo Abeni (1):
>   vhost_net: use packet weight for rx handler, too
> 
> haibinzhang(张海斌) (1):
>   vhost-net: set packet weight of tx polling to 2 * vq size

All now queued up, thanks for doing the backport!

greg k-h
