Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E948D6E0BB
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 07:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727366AbfGSFsc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 01:48:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40390 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726720AbfGSFsb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 01:48:31 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AB66BC04BD48;
        Fri, 19 Jul 2019 05:48:31 +0000 (UTC)
Received: from localhost (ovpn-204-136.brq.redhat.com [10.40.204.136])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0FF145C25C;
        Fri, 19 Jul 2019 05:48:30 +0000 (UTC)
Date:   Fri, 19 Jul 2019 07:48:29 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.3] mt76: mt76x0u: do not reset radio on resume
Message-ID: <20190719054828.GA6527@redhat.com>
References: <1563446290-2813-1-git-send-email-sgruszka@redhat.com>
 <20190719004524.4AC232184E@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190719004524.4AC232184E@mail.kernel.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Fri, 19 Jul 2019 05:48:31 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 19, 2019 at 12:45:23AM +0000, Sasha Levin wrote:
> v5.1.18: Failed to apply! Possible dependencies:
>     Unable to calculate
> 
> v4.19.59: Failed to apply! Possible dependencies:
<snip>

> How should we proceed with this patch?

I'll provide backported version of the patch for 4.19 and 5.1 
after it will be merged to Linus' tree.

Stanislaw
