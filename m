Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8B8949FBDA
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 15:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349390AbiA1Oh4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 09:37:56 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:50614 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349350AbiA1Ohr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jan 2022 09:37:47 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 3FECC2113D
        for <stable@vger.kernel.org>; Fri, 28 Jan 2022 14:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1643380666;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type;
        bh=3KEojFczygcmB8M7sL5HjUyFIsOONxmpvbOcvhKgJJY=;
        b=ukLbGHTZ/Fq3VBreZdQ32aS49Bjc6YdZj6d6LsHbEN3EAKrZrbyUihvyuQMhoR3rmGusOY
        2N2rxY+obc79xmNAahmFpezVgnkZrbAvTIE8IaU0d8LfguSILrEtlYNcbEAm/m1jIQfaSA
        v8T8WVt3IdTSm3H/dRagyeQQr9RxEb4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1643380666;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type;
        bh=3KEojFczygcmB8M7sL5HjUyFIsOONxmpvbOcvhKgJJY=;
        b=0hhMB8WFWTrKPRjcxxah+SRMr68awdmwrUPKlVh8cczDXjXIsA2zgGbwMXyB5r9izuSop9
        2t8yi9frfzixTHAw==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 37616A3B83;
        Fri, 28 Jan 2022 14:37:46 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1F633DA7A9; Fri, 28 Jan 2022 15:37:04 +0100 (CET)
Date:   Fri, 28 Jan 2022 15:37:03 +0100
From:   David Sterba <dsterba@suse.cz>
To:     stable@vger.kernel.org
Subject: Btrfs fixes for 5.16.x (from 5.17-rc1)
Message-ID: <20220128143703.GF14046@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I'm not sure when patches get picked from Linus' branch, just in case
please add the following fixes to 5.16.4. They fix a few user visible
bugs in defrag, all apply cleanly. Thanks.

6b34cd8e175b btrfs: fix too long loop when defragging a 1 byte file
b767c2fc787e btrfs: allow defrag to be interruptible
484167da7773 btrfs: defrag: fix wrong number of defragged sectors
c080b4144b9d btrfs: defrag: properly update range->start for autodefrag
0cb5950f3f3b btrfs: fix deadlock when reserving space during defrag
3c9d31c71594 btrfs: add back missing dirty page rate limiting to defrag
