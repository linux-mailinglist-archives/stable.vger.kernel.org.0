Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79FE43F376F
	for <lists+stable@lfdr.de>; Sat, 21 Aug 2021 01:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240334AbhHTXuk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 19:50:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:58428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239686AbhHTXuk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Aug 2021 19:50:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BDD76108F;
        Fri, 20 Aug 2021 23:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629503401;
        bh=hzalvZhv8IkedZ/xS90UIir0cRqc1yKX8bsIh3QQvr4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pD9CEHMEXqOM6roP+RFPfR7hIC3fv5binTlDENC6rj71lZJxAhYdivWr2K7g1gHvj
         5cdxVS3DKOyvyN2u32dOKT/ZhChPm3rTX9XNFv0eeJWap8Wr/6wb7ebtjDubNNK+Ev
         gW4ZhgAr+sCrsD8TMBnT/cJ+wCB5U7q+LVkoEGylt64hBbxda6Pw+fCuqR53+fvvi6
         RkX8Ru1Rw1V46mkKt6Li2vefu+GIBVEj0uR/X4xFs2AwcVXdHiFQ9BKSYT8vQP9wbw
         aL3Mg9fBC1aKMJvg8F1MnNq3UzGRHkR6kihhauj7qVh8dShSnLj9Ym2YexJcofZYpY
         AwIxZ7m4lyUIw==
Date:   Fri, 20 Aug 2021 19:50:00 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ole =?iso-8859-1?Q?Bj=F8rn_Midtb=F8?= <omidtbo@cisco.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Tim Connors <tim.w.connors@gmail.com>
Subject: Re: Please apply commit cca342d98bef ("Bluetooth: hidp: use correct
 wait queue when removing ctrl_wait") to 5.10.y
Message-ID: <YSA/qB00Ex5kwdz0@sashalap>
References: <YR+9P8Na4PMXi72v@eldamar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YR+9P8Na4PMXi72v@eldamar.lan>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 20, 2021 at 04:33:35PM +0200, Salvatore Bonaccorso wrote:
>Hi
>
>Tim Connors, a user in Debian (https://bugs.debian.org/992121)
>reported that cca342d98bef ("Bluetooth: hidp: use correct wait queue
>when removing ctrl_wait") from 5.11-rc1 is missing for the 5.10.y
>stable series.
>
>Actually would apply further back, but it was only tested to fix the
>problem on 5.10.y
>
>Thanks for considering,

I'll queue it up for <=5.10, thanks!

-- 
Thanks,
Sasha
