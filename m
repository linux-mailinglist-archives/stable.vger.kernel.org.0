Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBBD3D596F
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 14:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233742AbhGZLqe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 07:46:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:42286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233713AbhGZLqe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 07:46:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2C4860F44;
        Mon, 26 Jul 2021 12:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627302423;
        bh=0k1VgIyl2/dzxbsPC3FbV07oFEhQNSdr/dPC6bngNS4=;
        h=References:From:To:Cc:Subject:In-reply-to:Date:From;
        b=BCrEBc+rzPYKzjBclEWMy17v39nz7X7phpQf1yDQ9CDJYV6yPYUrIkINZMXgN88Q0
         hBV7b9PH+I4h2jis87UAO2SSXIH3rwSNx+PVL3znbELoKPuQThA9jdJLOWBjBkd1jz
         px7mjVvgIkD0EmswyDrtsFeoUvibrU9q+Wy3xCN4xoyh0vpq4OLfX82GrrjJzkR9YG
         BLcgyAdsOqQqc3MfUsPMM3eT4uegdUnwPppCiU54Q7jeOieM4HIa4RBgRG672di7c7
         kybeFhI3Di9+H+yevDlOPa/yzNqV6bv1PvcLdZocvQU0IHz0JB5OE6/zspIuaQha7R
         gJjRQX5t7+s9A==
References: <3c42fbd4599a4a3e8b065418592973d9@SVR-IES-MBX-03.mgc.mentorg.com>
 <YP6IzGT6gZNgudI6@kroah.com>
 <9eb2f4a413eb40609f91daf52436cc7b@SVR-IES-MBX-03.mgc.mentorg.com>
 <YP6LkanQfzipHdOR@kroah.com>
 <bfeab6efc5b84cf38aa1c5436d9ce18b@SVR-IES-MBX-03.mgc.mentorg.com>
User-agent: mu4e 1.4.15; emacs 27.2
From:   Felipe Balbi <balbi@kernel.org>
To:     "Schmid, Carsten" <Carsten_Schmid@mentor.com>
Cc:     "Greg KH (gregkh@linuxfoundation.org)" <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH for 4.14] xhci: add xhci_get_virt_ep() helper
In-reply-to: <bfeab6efc5b84cf38aa1c5436d9ce18b@SVR-IES-MBX-03.mgc.mentorg.com>
Date:   Mon, 26 Jul 2021 15:26:59 +0300
Message-ID: <871r7luup8.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hi,

Schmid, Carsten <Carsten_Schmid@mentor.com> writes:
>>> May I attach the patches as a file, generated with "git format-patch" meanwhile?
>>> I fear that I'm not allowed to use "git send-mail".
>>
>> For backports for the stable tree, yes, I can handle attachments just fine, you are not the only company with that problem :)
>>
> please find the patches attached.
> 0001-xhci-add-xhci_get_virt_sp-helper.patch.4 for 4.14 and 4.19
> 0001-xhci-add-xhci_get_virt_sp-helper.patch.5 for 5.4 and 5.10
>
> Applied and compiled, not tested.
> Added Cc: stable@vger.kernel.org in both patches.

Unfortunately, attachments will not do. You need to send the patches
themselves as the email. The easiest way is to configure (and rely) on
`git send-email', then it will do the right thing for you.

-- 
balbi
