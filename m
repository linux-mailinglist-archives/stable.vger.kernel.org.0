Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBA823B5AD3
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 11:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232425AbhF1JGg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 05:06:36 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:53410 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231683AbhF1JGg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Jun 2021 05:06:36 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D8942223C2;
        Mon, 28 Jun 2021 09:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624871049; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pSze+havdEUp5g4UGgcMsdfbY2u41+Dmsmn0rCQNfpE=;
        b=R66EXrUHz9iA4t4GBnFAMHyhL4/ZN59rXQDA5pdk8eO2iPB4l8MI1So63qFZ6l5IJ1Os44
        BRlLk4uDcfc3iiwpZ1Pc/4JCF+tTaUjYLREg7Djga5KIoQmnr8UXCipv/P1YlhKIxnk/MA
        yEeKGzm82s31k93pc9GQAycHimT6RvA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624871049;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pSze+havdEUp5g4UGgcMsdfbY2u41+Dmsmn0rCQNfpE=;
        b=3937/Nz8NQxjy1lXJ44quW8IEMuSUc8gV6WWJ/6EH55X4SpWrWwwC6ltYMOjYdzJxk54bq
        /vGMb4talDFrxhDw==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 71A94118DD;
        Mon, 28 Jun 2021 09:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624871049; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pSze+havdEUp5g4UGgcMsdfbY2u41+Dmsmn0rCQNfpE=;
        b=R66EXrUHz9iA4t4GBnFAMHyhL4/ZN59rXQDA5pdk8eO2iPB4l8MI1So63qFZ6l5IJ1Os44
        BRlLk4uDcfc3iiwpZ1Pc/4JCF+tTaUjYLREg7Djga5KIoQmnr8UXCipv/P1YlhKIxnk/MA
        yEeKGzm82s31k93pc9GQAycHimT6RvA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624871049;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pSze+havdEUp5g4UGgcMsdfbY2u41+Dmsmn0rCQNfpE=;
        b=3937/Nz8NQxjy1lXJ44quW8IEMuSUc8gV6WWJ/6EH55X4SpWrWwwC6ltYMOjYdzJxk54bq
        /vGMb4talDFrxhDw==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id wWDAGImQ2WAhTgAALh3uQQ
        (envelope-from <lhenriques@suse.de>); Mon, 28 Jun 2021 09:04:09 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id dc16ae65;
        Mon, 28 Jun 2021 09:04:08 +0000 (UTC)
Date:   Mon, 28 Jun 2021 10:04:08 +0100
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [RFC PATCH] ceph: reduce contention in ceph_check_delayed_caps()
Message-ID: <YNmQiP/Idf92tDDw@suse.de>
References: <20210625154559.8148-1-lhenriques@suse.de>
 <e427c4e5877e0b036c36eedbe40020047b02a85b.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e427c4e5877e0b036c36eedbe40020047b02a85b.camel@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 25, 2021 at 12:54:44PM -0400, Jeff Layton wrote:
<...>
> I'm not sure this approach is viable, unfortunately. Once you've dropped
> the cap_delay_lock, then nothing protects the i_cap_delay_list head
> anymore.
> 
> So you could detach these objects and put them on the private list, and
> then once you drop the spinlock another task could find one of them and
> (e.g.) call __cap_delay_requeue on it, potentially corrupting your list.
> 
> I think we'll need to come up with a different way to do this...

Ugh, yeah I see what you mean.

Another option I can think off is to time-bound this loop, so that it
would stop after finding the first ci->i_hold_caps_max timestamp that was
set *after* the start of the current run.  I'll see if I can come up with
an RFC shortly.

Cheers,
--
Luís
