Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1DC33F5CD
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 17:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232008AbhCQQoY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 12:44:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:32896 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231998AbhCQQoU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Mar 2021 12:44:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 34E60ACA8;
        Wed, 17 Mar 2021 16:44:19 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id E5EB91E3C6D; Wed, 17 Mar 2021 17:44:18 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     <stable@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH stable 4.14.y 0/3] ext4: Avoid crash when journal inode extents are corrupted
Date:   Wed, 17 Mar 2021 17:44:11 +0100
Message-Id: <20210317164414.17364-1-jack@suse.cz>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

this is a backport of ext4 patches to avoid crashes when ext4 journal inode
extents are corrupted to 4.14.y kernel.

								Honza
