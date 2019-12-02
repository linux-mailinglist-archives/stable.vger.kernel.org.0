Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47CC610ED2B
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 17:29:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbfLBQ3I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 11:29:08 -0500
Received: from verein.lst.de ([213.95.11.211]:39253 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727521AbfLBQ3H (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Dec 2019 11:29:07 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5AE5768BE1; Mon,  2 Dec 2019 17:29:05 +0100 (CET)
Date:   Mon, 2 Dec 2019 17:29:05 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Nadolski, Edmund" <edmund.nadolski@intel.com>
Cc:     Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
        stable@vger.kernel.org, Ingo Brunberg <ingo_brunberg@web.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        linux-nvme@lists.infradead.org
Subject: Re: [PATCH] nvme: Namepace identification descriptor list is
 optional
Message-ID: <20191202162905.GA7683@lst.de>
References: <20191202155611.21549-1-kbusch@kernel.org> <20191202161545.GA7434@lst.de> <20191202162256.GA21631@redsun51.ssa.fujisawa.hgst.com> <10e6520d-bc8c-94ff-00c4-32a727131b89@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10e6520d-bc8c-94ff-00c4-32a727131b89@intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 02, 2019 at 09:27:14AM -0700, Nadolski, Edmund wrote:
>> I don't have such a controller, but many apparently do. The regression
>> was reported here:
>>
>> http://lists.infradead.org/pipermail/linux-nvme/2019-December/028223.html
>>
>> And of course it's the SMI controller ...
>
> Does 5.4 show the exact error code?  Perhaps we should selectively allow 
> just for that case?

They'll find other ways to f***ck up.  Looks like at least the controller
in the bug report also doesn't have an subnqn and the nguid/eui64 are
bogus.  I wonder if we actually do users a favour by allowing that..
