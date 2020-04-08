Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAE8A1A1F46
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 12:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbgDHK61 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 06:58:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:36028 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728137AbgDHK60 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Apr 2020 06:58:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 926F4AC7B;
        Wed,  8 Apr 2020 10:58:24 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        stable@vger.kernel.org, Luis Henriques <lhenriques@suse.com>
Subject: [PATCH 0/2] stable CephFS backports
Date:   Wed,  8 Apr 2020 11:58:38 +0100
Message-Id: <20200408105844.21840-1-lhenriques@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi!

Please pick the backports for the following upstream commits:

  4fbc0c711b24 "ceph: remove the extra slashes in the server path"
  b27a939e8376 "ceph: canonicalize server path in place"

They fix an ancient bug that can be reproduced in kernels as old as 4.9 (I
couldn't reproduced it with 4.4).

Cheers,
--
Luis Henriques

Ilya Dryomov (1):
  ceph: canonicalize server path in place

Xiubo Li (1):
  ceph: remove the extra slashes in the server path
