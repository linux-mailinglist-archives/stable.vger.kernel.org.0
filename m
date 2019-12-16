Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7CDD12089E
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 15:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbfLPO2V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 09:28:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:40814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728008AbfLPO2U (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 09:28:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A97A2067C;
        Mon, 16 Dec 2019 14:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576506500;
        bh=L8x9hNnvkTtZuEESDkQZ3kDHNAQUQZTigGjl7HhLEKQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hbsA1vyKOSqpljVD3NEBoy8nAy8ZCs2BVRQh4gXkJrluBSSgVAOBDVaEQAMeV5Kp3
         A2PNDUI3RpLHDOu7I+ba+xAS9rNKj5nwR3WflHNit/z9pjrjH6w6TFowdv1ZBzkfI7
         jg1LsYBNgHtEquuKq1IzPAWgySZ5hnrwnEPdOanY=
Date:   Mon, 16 Dec 2019 15:28:17 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc:     Stable <stable@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: Re: Please queue "ext4: fix leak of quota reservations" into 5.4.y
Message-ID: <20191216142817.GA1898872@kroah.com>
References: <9682429e-34a6-e8db-deec-b9628b1c6ba6@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9682429e-34a6-e8db-deec-b9628b1c6ba6@yandex-team.ru>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 16, 2019 at 05:08:28PM +0300, Konstantin Khlebnikov wrote:
> Upstream commit f4c2d372b89a1e504ebb7b7eb3e29b8306479366 ("ext4: fix leak of quota reservations")
> 
> Only 5.4 is affected.
> 
> As I see it wasn't autoselected.
> Probably because it isn't tagged as stable@ as should be.

Now queued up, thanks.

greg k-h
