Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83DCB324236
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 17:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233931AbhBXQfs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 11:35:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:34524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235260AbhBXQdj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 11:33:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B280A64EA4;
        Wed, 24 Feb 2021 16:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614184369;
        bh=P1zqM95tua8umI/SEFGYX/6BnqFv13eKW5KD+RTSkyE=;
        h=Subject:From:To:Cc:Date:From;
        b=W1ZOsPXk7zIecZaR/ZDWzGVQ8PMimU+4mjPABBK7NTLcM4BPwR8XoTKBM+SH6Imi7
         JJnKuGSaquTmVrMP9+n5vJv6r6dGGtabwV8EC6EtATAlIGvTpbkk1REtDlkYiC4Q1I
         Rp0mGXw9Gbj2mHboxEXJyPTPhBrx97FqWM4kPVHKvDvPNbNHO2j9IQUUBrUwNd23zd
         r0g+whWM/0T2G1EQwBZQHYyphF3cNxjMlDQmmyjZUfPCgGXktfMp7U62TNGIlnFmPJ
         CWEB/iBW0eSbiQr1BzxGrzusLXewRMVAp25Cd31VPgr2WlIfJqp9A7MzLD0qs0LmJd
         PPZ7xVcLGSFWA==
Message-ID: <d461df79aac53a77de3ebae08543c5ca9c6660cb.camel@kernel.org>
Subject: ceph: downgrade warning from mdsmap decode to debug
From:   Jeff Layton <jlayton@kernel.org>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc:     Luis Henriques <lhenriques@suse.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Frank Schilder <frans@dtu.dk>
Date:   Wed, 24 Feb 2021 11:32:47 -0500
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, we'd like to request that you pull this commit into stable kernels. 
It's a trivial patch that just downgrades a (harmless) kernel warning
message to debug level. The warning can be very chatty in some
situations, and it'd be nice to silence it.

-----------------------------8<-------------------------------

commit ccd1acdf1c49b835504b235461fd24e2ed826764
Author: Luis Henriques <lhenriques@suse.de>
Date:   Thu Nov 12 11:25:32 2020 +0000

    ceph: downgrade warning from mdsmap decode to debug
    
    While the MDS cluster is unstable and changing state the client may get
    mdsmap updates that will trigger warnings:
    
      [144692.478400] ceph: mdsmap_decode got incorrect state(up:standby-replay)
      [144697.489552] ceph: mdsmap_decode got incorrect state(up:standby-replay)
      [144697.489580] ceph: mdsmap_decode got incorrect state(up:standby-replay)
    
    This patch downgrades these warnings to debug, as they may flood the logs
    if the cluster is unstable for a while.
    
    Signed-off-by: Luis Henriques <lhenriques@suse.de>
    Reviewed-by: Jeff Layton <jlayton@kernel.org>
    Signed-off-by: Ilya Dryomov <idryomov@gmail.com>


Thanks!
-- 
Jeff Layton <jlayton@kernel.org>

