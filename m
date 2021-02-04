Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E63A130FE7D
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 21:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240236AbhBDUfi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 15:35:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:60796 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240215AbhBDUe2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Feb 2021 15:34:28 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3F6D9AD2B
        for <stable@vger.kernel.org>; Thu,  4 Feb 2021 20:33:40 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 4ABEADA849; Thu,  4 Feb 2021 21:31:49 +0100 (CET)
Date:   Thu, 4 Feb 2021 21:31:49 +0100
From:   David Sterba <dsterba@suse.cz>
To:     stable@vger.kernel.org
Subject: Some btrfs fixes for 5.4.x
Message-ID: <20210204203149.GI1993@suse.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

please apply the following commits to 5.4.x tree. They're fixing a problem with
a long running transaction and there are users that have hit that. Other users
from the community have been using the patches on 5.4 base so they can be
considered tested.

All apply cleanly on top of current 5.4 tree. Thanks.

7ac8b88ee668a5b4743ebf3e9888fabac85c334a
ed58f2e66e849c34826083e5a6c1b506ee8a4d8e
cfc0eed0ec89db7c4a8d461174cabfaa4a0912c7
b25b0b871f206936d5bca02b80d38c05623e27da

Short ids with subjects:

7ac8b88ee668 ("btrfs: backref, only collect file extent items matching backref offset")
ed58f2e66e84 ("btrfs: backref, don't add refs from shared block when resolving normal backref")
cfc0eed0ec89 ("btrfs: backref, only search backref entries from leaves of the same root")
b25b0b871f20 ("btrfs: backref, use correct count to resolve normal data refs")
