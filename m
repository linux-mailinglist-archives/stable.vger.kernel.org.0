Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD9F40B36A
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 17:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234464AbhINPs1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 11:48:27 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:55820 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234462AbhINPs1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 11:48:27 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id DFC8120123
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 15:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1631634428;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type;
        bh=hPJ1dx0ZJ4OjGzhbOOm1iQRQ7z5iOszjGLSKrJ/C6C0=;
        b=JsFgfFpoJuCjy0hRjIrx+/sj81wA0VrGHaMiKcUDCgqRHkAAHB0zLdLjGXnni+r33BOnDg
        r7GEJfioo/jrLPOXA79WLjpiqcRHvP76OcoW+31X7NNdSM2ctky/meZ1JGkcOUwcNER5V8
        c3gkyA18QYoCz9oTlgaLV80TYMdGy0Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1631634428;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type;
        bh=hPJ1dx0ZJ4OjGzhbOOm1iQRQ7z5iOszjGLSKrJ/C6C0=;
        b=v/110t7iwuD+JFErgq+htvPhobm38O6pcPnKQ8aNoJHqzNj2oC+O0OF4it7pwERitHfxe6
        QZP9jYCH4xCSULCA==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id D9AFDA3B90;
        Tue, 14 Sep 2021 15:47:08 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D95B0DA781; Tue, 14 Sep 2021 17:47:00 +0200 (CEST)
Date:   Tue, 14 Sep 2021 17:47:00 +0200
From:   David Sterba <dsterba@suse.cz>
To:     stable@vger.kernel.org
Subject: Btrfs backports for 5.14.x
Message-ID: <20210914154700.GC9286@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

please add the following patches to 5.14 queue. All apply cleanly, thanks.

03fe78cc2942c55  btrfs: use delalloc_bytes to determine flush amount for shrink_delalloc
e16460707e94c3d  btrfs: wait on async extents when flushing delalloc
93c60b17f2b5fca  btrfs: reduce the preemptive flushing threshold to 90%
114623979405abf  btrfs: do not do preemptive flushing if the majority is global rsv
