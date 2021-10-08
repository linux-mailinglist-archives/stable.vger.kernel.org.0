Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6FCA426657
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 11:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232902AbhJHJLa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 05:11:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:34660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229853AbhJHJL3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 05:11:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 817A860F6E;
        Fri,  8 Oct 2021 09:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633684175;
        bh=hYghpT9khS7rpUsG/oA0NrOqUtj4YWpxZwZ3ch2gCug=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QLamW4QLoXNfhkQUrxCn4B1ecwxSnEBGR8cFYtjfar5kMOO5OpVb3ers8FwyfGrBw
         sbXkz9YtU0TbxROgYrDOdVg/ClrqHHLdy9ceQfwXN0kFM6+8iFtPcGGDlCvABb9a/C
         1Dyn5H8u3+FuXFW+0a7XR7+Vkamjk2/MCM3WdhjA=
Date:   Fri, 8 Oct 2021 11:09:32 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Krzysztof =?utf-8?Q?Ol=C4=99dzki?= <ole@ans.pl>
Cc:     stable@vger.kernel.org, Kate Hsuan <hpa@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: Can we add both Samsung NCQ fixes
 (7a8526a5cd51cf5f070310c6c37dd7293334ac49 and
 8a6430ab9c9c87cb64c512e505e8690bbaee190b) to the -stable trees
Message-ID: <YWAKzC/NurI19yE+@kroah.com>
References: <d8f08d3f-ffd8-3389-9199-feccc493b483@ans.pl>
 <567a9e2a-6096-6a6a-42b4-df7d3a39beb2@ans.pl>
 <cff65e13-4669-a1c9-b216-13f1d357fe55@ans.pl>
 <72130d6c-00dc-9405-1b6f-bb4d508a60b4@ans.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <72130d6c-00dc-9405-1b6f-bb4d508a60b4@ans.pl>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 06, 2021 at 09:19:09AM -0700, Krzysztof Olędzki wrote:
> Third Time's the Charm, now with the proper stable@ address. ;)
> 
> On 2021-09-26 at 21:10, Krzysztof Olędzki wrote:
> > (fixed Greg's e-mail)
> > 
> > Hi,
> > 
> > On 2021-09-20 at 19:32, Krzysztof Olędzki wrote:
> >> Hi Greg, Sasha,
> >>
> >> On 2021-09-14 at 19:58, Krzysztof Olędzki wrote:
> >>> Hi,
> >>>
> >>> Would it be possible to add both:
> >>>  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=7a8526a5cd51cf5f070310c6c37dd7293334ac49
> >>>  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8a6430ab9c9c87cb64c512e505e8690bbaee190b
> >>> into the -stable trees?
> >>>
> >>> Right now only the second patch (8a6430ab9c9c87cb64c512e505e8690bbaee190b) is tagged with "Cc: stable@vger.kernel.org", but has not been include into 5.4.146-rc1 and is also not in stable-queue.git.
> >>>
> >>> If it helps, I have tested both of them on 5.4.145 and they apply cleanly.
> >>
> >>
> >> Looks like 8a6430ab9c9c87cb64c512e505e8690bbaee190b - "libata: add ATA_HORKAGE_NO_NCQ_TRIM for Samsung 860 and 870 SSDs" has been included into the most recent wave of -stable kernels.
> >>
> >> Can we include 7a8526a5cd51cf5f070310c6c37dd7293334ac49 - "libata: Add ATA_HORKAGE_NO_NCQ_ON_ATI for Samsung 860 and 870 SSD." in the next releases, pretty please?
> > 
> > With the new set of -stable kernel just released, is this a good moment to re-ask for 7a8526a5cd51cf5f070310c6c37dd7293334ac49?

Now queued up, thanks.

greg k-h
