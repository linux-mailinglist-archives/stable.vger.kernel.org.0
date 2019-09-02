Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFED7A4FD6
	for <lists+stable@lfdr.de>; Mon,  2 Sep 2019 09:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729673AbfIBH1S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Sep 2019 03:27:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:39922 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729404AbfIBH1R (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Sep 2019 03:27:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BF6B1ADFE;
        Mon,  2 Sep 2019 07:27:16 +0000 (UTC)
Date:   Mon, 2 Sep 2019 09:27:16 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Thomas Lindroth <thomas.lindroth@gmail.com>
Cc:     linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [BUG] Early OOM and kernel NULL pointer dereference in 4.19.69
Message-ID: <20190902072716.GD14028@dhcp22.suse.cz>
References: <31131c2d-a936-8bbf-e58d-a3baaa457340@gmail.com>
 <20190902071617.GC14028@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190902071617.GC14028@dhcp22.suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon 02-09-19 09:16:17, Michal Hocko wrote:
> On Sun 01-09-19 22:43:05, Thomas Lindroth wrote:
> > After upgrading to the 4.19 series I've started getting problems with
> > early OOM.
> 
> What is the kenrel you have updated from? Would it be possible to try
> the current Linus' tree?

Btw. checking vanilla 4.19 without stable patches might be interesting
as well.
-- 
Michal Hocko
SUSE Labs
