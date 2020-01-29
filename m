Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16A3414CF75
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 18:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727318AbgA2RTA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 12:19:00 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:41248 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726647AbgA2RTA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jan 2020 12:19:00 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04446;MF=yang.shi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0TojgHea_1580318334;
Received: from US-143344MP.local(mailfrom:yang.shi@linux.alibaba.com fp:SMTPD_---0TojgHea_1580318334)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 30 Jan 2020 01:18:56 +0800
Subject: Re: [v3 PATCH] mm: move_pages: report the number of non-attempted
 pages
To:     Michal Hocko <mhocko@kernel.org>
Cc:     richardw.yang@linux.intel.com, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <1580144268-79620-1-git-send-email-yang.shi@linux.alibaba.com>
 <20200129101228.GH24244@dhcp22.suse.cz>
From:   Yang Shi <yang.shi@linux.alibaba.com>
Message-ID: <ac797acb-fff9-3d23-18e7-94f97bd19dcb@linux.alibaba.com>
Date:   Wed, 29 Jan 2020 09:18:51 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:52.0)
 Gecko/20100101 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <20200129101228.GH24244@dhcp22.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/29/20 2:12 AM, Michal Hocko wrote:
> Btw. please do not forget to update the man page as well.
> Thanks!

Sure.


