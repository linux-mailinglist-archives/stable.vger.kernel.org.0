Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADA384774C6
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 15:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238067AbhLPOjR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 09:39:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238100AbhLPOjQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Dec 2021 09:39:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22686C061751;
        Thu, 16 Dec 2021 06:39:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A46061E20;
        Thu, 16 Dec 2021 14:39:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A835C36AE4;
        Thu, 16 Dec 2021 14:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639665549;
        bh=kZPwdhtqvN8EAoo0DiHJZhRNK3glkhQdRZy2uSeQJ7E=;
        h=From:To:Cc:Subject:Date:From;
        b=qZOm7blc2k4F3K8AeRvUERRPlE58ir9Ntqox3XUpP/DnNk5iP1GWb97+SfmQP+2ym
         JGeXJNe3UtA9w9k+bROcVo+IxSK5IwrrAtTav7nyiDymIXKj6VRbd/u/bvUWVq0CB4
         BorMWucmlpqPDi5pKQMV8xyR4Yj+vEZk603gdNVM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.9
Date:   Thu, 16 Dec 2021 15:39:05 +0100
Message-Id: <1639665501240245@kroah.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.9 kernel.

Only change here is a permission setting of a netfilter selftest file.
No need to upgrade if this problem is not bothering you.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Greg Kroah-Hartman (2):
      netfilter: selftest: conntrack_vrf.sh: fix file permission
      Linux 5.15.9

