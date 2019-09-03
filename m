Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73469A73C5
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 21:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbfICTgF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 15:36:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:58512 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725882AbfICTgF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 15:36:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 473FCADDA;
        Tue,  3 Sep 2019 19:36:04 +0000 (UTC)
Date:   Tue, 3 Sep 2019 21:36:03 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Thomas Lindroth <thomas.lindroth@gmail.com>
Cc:     Andrey Ryabinin <aryabinin@virtuozzo.com>, linux-mm@kvack.org,
        stable@vger.kernel.org
Subject: Re: [BUG] Early OOM and kernel NULL pointer dereference in 4.19.69
Message-ID: <20190903193603.GF14028@dhcp22.suse.cz>
References: <31131c2d-a936-8bbf-e58d-a3baaa457340@gmail.com>
 <20190902071617.GC14028@dhcp22.suse.cz>
 <a07da432-1fc1-67de-ae35-93f157bf9a7d@gmail.com>
 <20190903074132.GM14028@dhcp22.suse.cz>
 <84c47d16-ff5a-9af0-efd4-5ef78d302170@virtuozzo.com>
 <20190903122221.GV14028@dhcp22.suse.cz>
 <c8c3effe-753c-ce1d-60f4-7d6ff2845074@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8c3effe-753c-ce1d-60f4-7d6ff2845074@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 03-09-19 20:20:20, Thomas Lindroth wrote:
[...]
> If kmem accounting is both broken, unfixable and cause kernel crashes when
> used why not remove it? Or perhaps disable it per default like
> cgroup.memory=nokmem or at least print a warning to dmesg if the user tries
> to user it in a way that cause crashes?

Well, cgroup v1 interfaces and implementation is mostly frozen and users
are advised to use v2 interface that doesn't suffer from this problem
because there is no separate kmem limit and both user and kernel charges
are tight to the same counter.

We can be more explicit about shortcomings in the documentation but in
general v1 is deprecated.

-- 
Michal Hocko
SUSE Labs
