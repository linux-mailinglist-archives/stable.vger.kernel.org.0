Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E005AFDF0
	for <lists+stable@lfdr.de>; Wed, 11 Sep 2019 15:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728126AbfIKNnz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Sep 2019 09:43:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51024 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728100AbfIKNnz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Sep 2019 09:43:55 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id ED53C2105
        for <stable@vger.kernel.org>; Wed, 11 Sep 2019 13:43:54 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 550D060167;
        Wed, 11 Sep 2019 13:43:49 +0000 (UTC)
Date:   Wed, 11 Sep 2019 09:43:48 -0400
From:   Mike Snitzer <snitzer@redhat.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     dm-devel@redhat.com, stable@vger.kernel.org
Subject: Re: [PATCH V2] dm-raid: fix updating of max_discard_sectors limit
Message-ID: <20190911134348.GB32121@redhat.com>
References: <20190911113133.837-1-ming.lei@redhat.com>
 <20190911133523.GA32121@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190911133523.GA32121@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.71]); Wed, 11 Sep 2019 13:43:54 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 11 2019 at  9:35am -0400,
Mike Snitzer <snitzer@redhat.com> wrote:
 
> FYI, I added a "Fixes:" tag to the commit header and switched to
> shifting by SECTOR_SHIFT instead of 9, staged commit for 5.4 is here:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.4&id=509818079bf1fefff4ed02d6a1b994e20efc0480

I just fixed a few typos in your patch header, so updated commit is:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.4&id=2b7aa6bde032c56e00245ed438922529251c9e13
