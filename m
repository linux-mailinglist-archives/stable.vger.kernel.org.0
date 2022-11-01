Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 553D7615179
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 19:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbiKASXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 14:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbiKASXM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 14:23:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A4491E3FC;
        Tue,  1 Nov 2022 11:23:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11FC8616F0;
        Tue,  1 Nov 2022 18:23:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92D18C433C1;
        Tue,  1 Nov 2022 18:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667326988;
        bh=SEWHabEE7rqmXwH+HMgv++ttdVlrV6jHThi39QcOPpU=;
        h=From:To:Cc:Subject:Date:From;
        b=t6nRRxoyn9UFVsp//9DFu2lxU83XacRu0cj+YHj1DlLxFLzSbnmBhgY2RcHNorQYR
         VR/+3dsPHnwpTlRakzdrd7rXVx+7qm+w9jqOQmYasZZITEyl4cnx/qQ61h1IfP6d1Q
         jCI8Fg8ckcjLNapRyL7/wwp9+ho5RnzhlJa3e85I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.222
Date:   Tue,  1 Nov 2022 19:24:00 +0100
Message-Id: <166732701420252@kroah.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.222 kernel.

This release is only needed if you use clang to build your kernel.
If not, no need to upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile             |    2 +-
 include/linux/once.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Greg Kroah-Hartman (2):
      once: fix section mismatch on clang builds
      Linux 5.4.222

