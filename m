Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2CA461F73
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380122AbhK2SrS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:47:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57948 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1379898AbhK2SpQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:45:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638211318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=jl+FQTb1uPpROWpp/BVK0RPOqbVogQiw0gzl8Vgq7mo=;
        b=O8/JhNdnrFttCiYhYtLoc4tV41s8CxiriJJdxhRcGdBE/i23FX7eaq2LCJtzqNhCxprQJz
        25uM04wEkUfy8YWx6ZCHv272vyGztl6dHHX3sLXAtyHxO7G6UUpc97dSN65CVsST4vLQhX
        uD3maJl+EDk8fNDMveHY10MAhQHHc9g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-170-L7m-C_7GPxexNohehUrBeA-1; Mon, 29 Nov 2021 13:41:54 -0500
X-MC-Unique: L7m-C_7GPxexNohehUrBeA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8919510168C0;
        Mon, 29 Nov 2021 18:41:53 +0000 (UTC)
Received: from bcodding.csb (ovpn-64-2.rdu2.redhat.com [10.10.64.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6A3015D9C0;
        Mon, 29 Nov 2021 18:41:53 +0000 (UTC)
Received: by bcodding.csb (Postfix, from userid 24008)
        id DFD9C10C30E0; Mon, 29 Nov 2021 13:41:52 -0500 (EST)
From:   Benjamin Coddington <bcodding@redhat.com>
To:     stable@vger.kernel.org
Cc:     trond.myklebust@hammerspace.com, bcodding@redhat.com,
        gregkh@linuxfoundation.org
Subject: Patches for upstream 3f015d89a47c NFS COPY/CLONE - stable versions follow
Date:   Mon, 29 Nov 2021 13:41:47 -0500
Message-Id: <cover.1638210409.git.bcodding@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The five patches referencing this cover letter are backports of upstream
fix "3f015d89a47c NFSv42: Fix pagecache invalidation after COPY/CLONE",
which did not apply cleanly to longterm trees.

Note: while the upstream fix received extensive testing, these backports
have been build-tested only.

Benjamin Coddington (1):
  NFSv42: Fix pagecache invalidation after COPY/CLONE

 fs/nfs/nfs42proc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

-- 
2.31.1

