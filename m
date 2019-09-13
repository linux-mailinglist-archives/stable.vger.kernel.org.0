Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE190B1BF4
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 13:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbfIMLHE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 07:07:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:53220 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726754AbfIMLHE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 07:07:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A1A5CB618
        for <stable@vger.kernel.org>; Fri, 13 Sep 2019 11:07:03 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id CFBADDA835; Fri, 13 Sep 2019 13:07:25 +0200 (CEST)
Date:   Fri, 13 Sep 2019 13:07:25 +0200
From:   David Sterba <dsterba@suse.cz>
To:     stable@vger.kernel.org
Subject: Please add 18dfa7117a3f37986 to 5.2.x tree
Message-ID: <20190913110725.GN2850@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

please add the commit

  18dfa7117a3f379862dcd3f67cadd678013bb9dd
  Btrfs: fix unwritten extent buffers and hangs on future writeback attempts

to the 5.2.x tree. It fixes a regression introduced in 5.2 with a big
user impact.

Thanks.
