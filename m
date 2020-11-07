Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70E8B2AA637
	for <lists+stable@lfdr.de>; Sat,  7 Nov 2020 16:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726257AbgKGP1z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Nov 2020 10:27:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:44570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726060AbgKGP1z (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 7 Nov 2020 10:27:55 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CAF7206DB;
        Sat,  7 Nov 2020 15:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604762875;
        bh=heWSefAsDZPzshVFnemJkskUJeQCA4NFVaRtMdzoadg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ELrdIyf+d4FANoceDPQgJlZuDIEASgWf6RTu5W1TGRL10SFDBshCPOBCuxbeewQ4F
         dULzfUfmiHxMmLxAh5YkQYrfZxe2kv/mI/0FSUNlJTnN7zjkhYEdufdmq5KdPt7wNO
         d3WUmJeJUhdLSe3oGfXtM1/BhltQeF8XwbRcL/jk=
Date:   Sat, 7 Nov 2020 16:28:27 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     Sasha Levin <Alexander.Levin@microsoft.com>,
        stable <stable@vger.kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, intel-wired-lan@lists.osuosl.org
Subject: Re: [4.14] Security fixes (blktrace, i40e)
Message-ID: <20201107152827.GA90705@kroah.com>
References: <c21d1ef1ddb071eed868a96649b4edf0b61b4247.camel@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c21d1ef1ddb071eed868a96649b4edf0b61b4247.camel@codethink.co.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 07, 2020 at 12:17:42AM +0000, Ben Hutchings wrote:
> Here are backports of some fixes to the 4.14 stable branch.
> 
> I tested the blktrace fix with the script referenced in the commit
> message.
> 
> I wasn't able to test the i40e changes (no hardware and no reproducer
> available).

Thanks for all of these, now queued up.

greg k-h
