Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB5744C179
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 13:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbhKJMpR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 07:45:17 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:41200 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbhKJMpQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Nov 2021 07:45:16 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 3E46C218A4
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 12:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1636548148;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type;
        bh=gleS0Ty+sznQiAgm7yV1tbfmXQQ3k+AhGh+ygnfx61w=;
        b=t7DCi4UOjrSXs+wxXwnCN3vWxdx9DGEOAbRTur6oHlprlOwgdABXbLtjDAu/P8SH8cdPFP
        jj2SCoyy7nFvtx0pKUCRrv0nl6YQ3tlyr28mkoQtVG8FRdMS8Fw1lC4THGFX7OPVHmFbLq
        I/glFNGdR9l/JzA9cLO0orPQgfaQU84=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1636548148;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type;
        bh=gleS0Ty+sznQiAgm7yV1tbfmXQQ3k+AhGh+ygnfx61w=;
        b=YDXjVxR5JdYNrvxbUErKHIvfC4Y5EY/fUFbmwUTnudQ6sdFIqyU8wcyzEMzvs23Vt7ca8d
        Sltj551/IuT/tCBQ==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 3533FA3B88;
        Wed, 10 Nov 2021 12:42:28 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 99F7DDA799; Wed, 10 Nov 2021 13:41:48 +0100 (CET)
Date:   Wed, 10 Nov 2021 13:41:48 +0100
From:   David Sterba <dsterba@suse.cz>
To:     stable@vger.kernel.org
Subject: Please add 2cf3f8133bda2a09 to 5.15.x
Message-ID: <20211110124147.GT28560@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

please add commit

2cf3f8133bda ("btrfs: fix lzo_decompress_bio() kmap leakage")

to the 5.15.x tree. It's been merged during the 5.16 pull, it's a fix
for a crash on 32bit architectures with enabled lzo compression.
Applies cleanly and has been tested.

Thanks.
