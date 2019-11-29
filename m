Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 437CE10D2E2
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 10:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbfK2JEZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 04:04:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:54000 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726780AbfK2JEZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 29 Nov 2019 04:04:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B913DB269;
        Fri, 29 Nov 2019 09:04:23 +0000 (UTC)
From:   Vlastimil Babka <vbabka@suse.cz>
To:     stable@vger.kernel.org
Cc:     Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Matthew Wilcox <willy@infradead.org>,
        Ajay Kaher <akaher@vmware.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH STABLE ONLY] add missing page refcount overflow checks
Date:   Fri, 29 Nov 2019 10:03:48 +0100
Message-Id: <20191129090351.3507-1-vbabka@suse.cz>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This collection of patches add the missing overflow checks in arch-specific
gup.c variants for x86 and s390. Those were missed in backport of 8fde12ca79af
("mm: prevent get_user_pages() from overflowing page refcount") as mainline
had a single gup.c implementation at that point. See individual patches for
details.

Vlastimil

-- 
2.24.0

