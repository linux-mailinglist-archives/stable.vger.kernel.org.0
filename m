Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBA6B533CE4
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 14:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbiEYMqr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 08:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbiEYMqq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 08:46:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C5A79158D;
        Wed, 25 May 2022 05:46:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0AB1EB81D70;
        Wed, 25 May 2022 12:46:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C7DEC385B8;
        Wed, 25 May 2022 12:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653482802;
        bh=R3WJvPKQrgJCw9rKAaUa8kuOBkz9LIdNWLFkMvMSMt4=;
        h=From:To:Cc:Subject:Date:From;
        b=mJK8V84jfzW30m7y+LChyNTG+8HQEjRWB1r5pLV1ox/RwzFxMAhGkpFwUvwUtJY9b
         SPTHf0EjnPKngwgNc0uYl1OgzrqaKeaIYeua6LYtbDEKwn3BT2JEt9VqhldDIL+9Py
         avGxwZBXyvOFaEXwM7TLN++UOyECTsScMJXUNe4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.43
Date:   Wed, 25 May 2022 14:46:38 +0200
Message-Id: <1653482798149115@kroah.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.43 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile             |    2 +-
 net/mptcp/protocol.h |    3 ++-
 net/mptcp/subflow.c  |   21 ++++++++++++++++++---
 3 files changed, 21 insertions(+), 5 deletions(-)

Greg Kroah-Hartman (1):
      Linux 5.15.43

Mat Martineau (1):
      mptcp: Do TCP fallback on early DSS checksum failure

