Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECC28102761
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 15:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbfKSOxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 09:53:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:36556 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726307AbfKSOxF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 09:53:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 47304B1AB;
        Tue, 19 Nov 2019 14:53:04 +0000 (UTC)
Date:   Tue, 19 Nov 2019 15:53:02 +0100
From:   Petr Vorel <pvorel@suse.cz>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     stable@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v3.16] alarmtimer: Use EOPNOTSUPP instead of ENOTSUPP
Message-ID: <20191119145302.GA11290@dell5510>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <20191108155411.13306-1-pvorel@suse.cz>
 <43b375712cdd400695af9e4e8e4a9381706601fc.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43b375712cdd400695af9e4e8e4a9381706601fc.camel@decadent.org.uk>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Ben,

> I've queued this up, thanks.
Thanks!
> In future please remember to include the upstream commit hash.
I'm sorry, I'll remember next time.


Kind regards,
Petr
