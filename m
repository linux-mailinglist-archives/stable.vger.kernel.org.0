Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7CCB25748C
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 09:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727979AbgHaHu6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 03:50:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:38236 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728104AbgHaHux (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Aug 2020 03:50:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A3850AC8C;
        Mon, 31 Aug 2020 07:51:26 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 1A5891E12CF; Mon, 31 Aug 2020 09:50:51 +0200 (CEST)
Date:   Mon, 31 Aug 2020 09:50:51 +0200
From:   Jan Kara <jack@suse.cz>
To:     SeongJae Park <sjpark@amazon.com>
Cc:     Muchun Song <songmuchun@bytedance.com>,
        Filipe Manana <fdmanana@suse.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Alexander Tsoy <alexander@tsoy.me>,
        Takashi Iwai <tiwai@suse.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Taehee Yoo <ap420073@gmail.com>,
        Fabio Estevam <festevam@gmail.com>, Jan Kara <jack@suse.cz>,
        Dongli Zhang <dongli.zhang@oracle.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>,
        Adam Ford <aford173@gmail.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Xiaochen Shen <xiaochen.shen@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        sashal@kernel.org, amit@kernel.org, sj38.park@gmail.com,
        stable@vger.kernel.org
Subject: Re: [5.4.y] Found 27 commits that might missed
Message-ID: <20200831075051.GB23389@quack2.suse.cz>
References: <20200828152745.10819-1-sjpark@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200828152745.10819-1-sjpark@amazon.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 28-08-20 17:27:45, SeongJae Park wrote:
> c3dbe541ef77 ("blktrace: Avoid sparse warnings when assigning q->blk_trace")
> # commit date: 2020-06-17, author: Jan Kara <jack@suse.cz>
> # mentions 'blktrace: Protect q->blk_trace with RCU'

Backporting this is not needed. As the changelog states, it fixes only
sparse warnings, not real bugs...

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
