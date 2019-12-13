Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABB1611DB51
	for <lists+stable@lfdr.de>; Fri, 13 Dec 2019 01:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727524AbfLMAyv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 19:54:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:34108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727491AbfLMAyv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Dec 2019 19:54:51 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B835205C9;
        Fri, 13 Dec 2019 00:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576198490;
        bh=j8D+jY9fdqeL/Py33OYokgdHf7s0IVkY5v+nvBAEJos=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pufP1U08vwhmlXcMMrITJdIdTAfP7bWtp8132PxG22nlfgLomU0yp8xOL8VGGAD/7
         SuUmv/98B4MEfBWnSkYUCOBvJRzTocYhdIaAdzVpyxi0wlHbHj4XxhGRcwKDP9FPvK
         EoEZHwqWh6VnL0J7D8lDo+J6GIdmB/VDUr/66CKg=
Date:   Thu, 12 Dec 2019 19:54:49 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        stable@kernel.org, Andreas Dilger <adilger@dilger.ca>,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.4 27/37] ext4: work around deleting a file with
 i_nlink == 0 safely
Message-ID: <20191213005449.GG12996@sasha-vm>
References: <20191211153813.24126-1-sashal@kernel.org>
 <20191211153813.24126-27-sashal@kernel.org>
 <20191211161959.GB129186@mit.edu>
 <20191211200454.GF12996@sasha-vm>
 <20191212151706.GA204354@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191212151706.GA204354@mit.edu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 12, 2019 at 10:17:06AM -0500, Theodore Y. Ts'o wrote:
>On Wed, Dec 11, 2019 at 03:04:54PM -0500, Sasha Levin wrote:
>> > I'm confused; this was explicitly cc'ed to stable@kernel.org, so why
>> > is your AUTOSEL picking this up?  I would have thought this would get
>> > picked up via the normal stable kernel processes.
>>
>> My mistake, appologies.
>
>No worries; the intent was that it be backported to stable, and I
>don't really care with path it takes.
>
>I just wanted to make sure there wouldn't be confusion if you
>backported it to stable, and then Greg tried and then got a merge
>conflict.  (Or worse, if the patch was one of the ones where it can be
>successfully applied *twice* w/o a patch conflict; I'm not sure if git
>cherry-pick is smarter than patch in this regard, but I don't think it
>is?)

This one was just due to me running a bit faster then usual. I generally
don't filter out stable tagged commits and Greg just gets to them faster
than me (the delay on AUTOSEL is bigger than stable tagged commits).

-- 
Thanks,
Sasha
