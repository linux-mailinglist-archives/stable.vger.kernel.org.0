Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 438D555D3A0
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233226AbiF0H7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 03:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233233AbiF0H6x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 03:58:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A7F1BF0;
        Mon, 27 Jun 2022 00:58:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 160CEB80FAF;
        Mon, 27 Jun 2022 07:58:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DC32C3411D;
        Mon, 27 Jun 2022 07:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656316728;
        bh=3QBOQ+63McWkZaoy6zDZtIM0PJkpeSnpFCaypOnEoLw=;
        h=From:To:Cc:Subject:Date:From;
        b=mzW42jmv0L939DFAbC+czjVbMGYQZIl0GHwsivZG3Z4FnRghjcHqZsRAMbitEEvbc
         7Ls1Ou3jTj8RMWFudyihoQM6VAA8QK/5HY3srvA8zAfR6jszVo6IEI+x7AyYfGgJI/
         +vLuTluPDSQhSqYmnpXcVIfv2b+wc2yzQAhir/no=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.126
Date:   Mon, 27 Jun 2022 09:58:45 +0200
Message-Id: <16563167256229@kroah.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.126 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile      |    2 +-
 fs/io_uring.c |   24 +++++++++++++-----------
 2 files changed, 14 insertions(+), 12 deletions(-)

Greg Kroah-Hartman (1):
      Linux 5.10.126

Jens Axboe (1):
      io_uring: use separate list entry for iopoll requests

