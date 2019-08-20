Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1E0A96001
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 15:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729833AbfHTN1r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 09:27:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:60108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729810AbfHTN1r (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 09:27:47 -0400
Received: from localhost (unknown [12.236.144.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B500D22CF7;
        Tue, 20 Aug 2019 13:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566307666;
        bh=xo7viiAjxl9pUMWWu5Uib110Gy9MmAS8YARuBQWCQb8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kpBmHpiZtm5zV4e1/OqnRC66Skcxg+fRzH1BMrRiSjVtOEgnA6pOr9Czg7NzV6TlR
         rV+jfv9QXhCsuSjuXzH8GMkQs3XWS8j2vdOfgU01Ry2HgFRujkdmeRe1t45d6+2DvA
         bsgLHrQD2elV0/6C0qDdMem4ez28tUGqSrnuWBI8=
Date:   Tue, 20 Aug 2019 09:27:45 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Denis Andzakovic <denis.andzakovic@pulsesecurity.co.nz>,
        Salvatore Bonaccorso <carnil@debian.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH 3.16-4.14] tcp: Clear sk_send_head after purging the
 write queue
Message-ID: <20190820132745.GK30205@sasha-vm>
References: <20190813115317.6cgml2mckd3c6u7z@decadent.org.uk>
 <41a61a2f87691d2bc839f26cdfe6f5ff2f51e472.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <41a61a2f87691d2bc839f26cdfe6f5ff2f51e472.camel@decadent.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 20, 2019 at 03:11:37AM +0100, Ben Hutchings wrote:
>Sorry, this is the same issue that was already fixed by "tcp: reset
>sk_send_head in tcp_write_queue_purge".  You can drop my version from
>the queue for 4.4 and 4.9 and revert it for 4.14.

I've fixed it up, thanks Ben.

--
Thanks,
Sasha
