Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A73CB9DFED
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 09:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729687AbfH0H6r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 03:58:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:51770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731074AbfH0H6r (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:58:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 095AD20828;
        Tue, 27 Aug 2019 07:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892726;
        bh=w9n+0IkPLMXp12/EI3ePqqrQeWYE9NsYwoEcxGk5xxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DsjtRE86jODgMh3q86/Zknr7mx970LuEnjMn7a+ZNrlIcjX4aI5qAkmJPITTgV7X1
         mVZ4++X574iU2IgRIoiOKejA5xq1FvzM1zjyqhL6CHFEYCsyV+AGHdwVZvQM6GZlna
         NuvK5lLA/JMgvUOeYHnUUKSfCqpwL70f2dA6lKlo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Allison Henderson <allison.henderson@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 90/98] xfs: Move fs/xfs/xfs_attr.h to fs/xfs/libxfs/xfs_attr.h
Date:   Tue, 27 Aug 2019 09:51:09 +0200
Message-Id: <20190827072722.840655823@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072718.142728620@linuxfoundation.org>
References: <20190827072718.142728620@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit e2421f0b5ff3ce279573036f5cfcb0ce28b422a9 upstream.

This patch moves fs/xfs/xfs_attr.h to fs/xfs/libxfs/xfs_attr.h
since xfs_attr.c is in libxfs.  We will need these later in
xfsprogs.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/{ => libxfs}/xfs_attr.h | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename fs/xfs/{ => libxfs}/xfs_attr.h (100%)

diff --git a/fs/xfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
similarity index 100%
rename from fs/xfs/xfs_attr.h
rename to fs/xfs/libxfs/xfs_attr.h
-- 
2.20.1



