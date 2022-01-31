Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB7D14A3D83
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 06:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234927AbiAaFws (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 00:52:48 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:57852 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiAaFwr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 00:52:47 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 13C6E212C5;
        Mon, 31 Jan 2022 05:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1643608366; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r03ryjoJE+I6jzeUO7ZpiYA0DNC9txWpejJG0PG2+qM=;
        b=nWRTUQnMtTQ0XajvwGyACUJrKXAzwLaW6bsouECJ5eaW756sAFyWi18iG0WynWFmi7vADu
        9lvU6yssBQRb9beLwQKbuwbNAQig7yXWs5W1zpl++9pF/TVjV11Fmczd66E5rTMXzgpboZ
        3AJD5s2B4a9Gwnpgws8zcfHXtornNa0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1643608366;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r03ryjoJE+I6jzeUO7ZpiYA0DNC9txWpejJG0PG2+qM=;
        b=c3IAuy/cxQipjTDZ8VfHJwIx7X15VJGypjt3Ee8Jwp0yWobMYiJaGIU7iwTgsRvXo73jd0
        q/LPuYQInLm72lAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 848B113638;
        Mon, 31 Jan 2022 05:52:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id cShhHS1592FYJwAAMHmgww
        (envelope-from <osalvador@suse.de>); Mon, 31 Jan 2022 05:52:45 +0000
Date:   Mon, 31 Jan 2022 06:52:43 +0100
From:   Oscar Salvador <osalvador@suse.de>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v1] drivers/base/memory: add memory block to memory group
 after registration succeeded
Message-ID: <Yfd5Kz1HggmhIOC9@localhost.localdomain>
References: <20220128144540.153902-1-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220128144540.153902-1-david@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 28, 2022 at 03:45:40PM +0100, David Hildenbrand wrote:
> If register_memory() fails, we freed the memory block but already added
> the memory block to the group list, not good. Let's defer adding the
> block to the memory group to after registering the memory block device.
> 
> We do handle it properly during unregister_memory(), but that's not
> called when the registration fails.
> 
> Fixes: 028fc57a1c36 ("drivers/base/memory: introduce "memory groups" to logically group memory blocks")
> Cc: stable@vger.kernel.org # v5.15+
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Oscar Salvador <osalvador@suse.de>


-- 
Oscar Salvador
SUSE Labs
