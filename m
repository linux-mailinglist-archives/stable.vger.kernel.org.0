Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 114615B1A21
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 12:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbiIHKhu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 06:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbiIHKhp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 06:37:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E40DCB14E5;
        Thu,  8 Sep 2022 03:37:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94025B8207D;
        Thu,  8 Sep 2022 10:37:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30FBC43470;
        Thu,  8 Sep 2022 10:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662633456;
        bh=fSKYSszIWNxabqWyOrQjQBGLscb4SLkY/iSyZcXMOGI=;
        h=From:To:Cc:Subject:Date:From;
        b=lqVoR6Uw1YVOnz8K7qKtAwG2QYS9ea5ypKYWFqdJK0bMy0h5+YOiPbHqiXAvN9Dwt
         jCnptRpvjN/dsQGXYkh4aDnt1Dgj4Y8E0ocxBER+ffeJ1jBroQxXLXBrhYieQ+2ZFE
         WQAw3pUyxXfItylZBSTnCc1rLlOdXqTmaLbMTwbA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.67
Date:   Thu,  8 Sep 2022 12:37:52 +0200
Message-Id: <166263347214161@kroah.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.67 kernel.

All users of the 5.15 kernel series must upgrade.

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
      kbuild: fix up permissions on scripts/pahole-flags.sh
      Linux 5.15.67

