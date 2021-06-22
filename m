Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 986BB3B057A
	for <lists+stable@lfdr.de>; Tue, 22 Jun 2021 15:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbhFVNJW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 09:09:22 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:55306 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbhFVNJW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Jun 2021 09:09:22 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 74E671FD36;
        Tue, 22 Jun 2021 13:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1624367225;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+rpAryiJ4LXzrIX70pnVEjTDczKkPw3M4u1mrrnVebg=;
        b=ZhxCwmzDqreszwXZAmI7seW9wSFX7AWgc+5nKXRbn63WZ4hXMcI8Jkysa4bMvtUomekXah
        ytqp2OE+8jecyA67y1lsC2eOFrvxuO0nMOYMI1zXwwXSCqtmcIYMF2PTY8iuQoXhUKFE3v
        xoF4Qa5p6VWOj0GYKwMvy8Ab99xuxxs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1624367225;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+rpAryiJ4LXzrIX70pnVEjTDczKkPw3M4u1mrrnVebg=;
        b=NEIGCqCDfs0I27X36pxMArhwM98Qh4t7MQcOLt70zuuprndBMBFSLOpykTE76wD7d25J78
        IoSs5oT2VfgibBBA==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 6DAC3A3B8D;
        Tue, 22 Jun 2021 13:07:05 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B9B21DA77B; Tue, 22 Jun 2021 15:04:14 +0200 (CEST)
Date:   Tue, 22 Jun 2021 15:04:14 +0200
From:   David Sterba <dsterba@suse.cz>
To:     dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: handle shrink_delalloc pages calculation
 differently
Message-ID: <20210622130414.GJ28158@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        stable@vger.kernel.org
References: <f17b840611935b5f58bfcdbe050a942c33b90a60.1622576697.git.josef@toxicpanda.com>
 <20210622111604.GG28158@twin.jikos.cz>
 <20210622112550.GH28158@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210622112550.GH28158@twin.jikos.cz>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 22, 2021 at 01:25:50PM +0200, David Sterba wrote:
> On Tue, Jun 22, 2021 at 01:16:04PM +0200, David Sterba wrote:
> > On Tue, Jun 01, 2021 at 03:45:08PM -0400, Josef Bacik wrote:
> > As this is going to be resent, I'll remove it from misc-next for now.
> > Updated version can go in as a fix after rc1.
> 
> Ok so that does not work, the patchset "[PATCH 0/4][v2] btrfs: commit
> the transaction unconditionally for ensopc"
> https://lore.kernel.org/linux-btrfs/cover.1623421213.git.josef@toxicpanda.com/
> touches the defines and can't be trivially resolved.

Nikolay was kind to resolve the conflict so the final status is that
"btrfs: handle shrink_delalloc pages calculation differently" has been
removed from misc-next (due to known performance drop) and the refreshed
patchset is now in misc-next.
