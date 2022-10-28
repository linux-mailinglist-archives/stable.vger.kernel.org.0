Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8FFC611053
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 14:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbiJ1MCE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 08:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiJ1MCD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 08:02:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7E321D2F6B;
        Fri, 28 Oct 2022 05:02:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F094B82941;
        Fri, 28 Oct 2022 12:02:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF4FC433C1;
        Fri, 28 Oct 2022 12:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666958519;
        bh=dBASsPr/sry2qSHTTEXr6uGV8QzWRBCZ2YtAW+47MRo=;
        h=From:To:Cc:Subject:Date:From;
        b=mMZocS6dHwrSCBlm20qKDbrIuzMc9a6BM01M99Ti8jaJML9ZDZJFKE43b47M0UZnP
         SWd5bFVDJSeDo/P7jzbsZcxJqiqBBTu/GW/YZl5IQf/mJnEvtOfG8D/yHQzYFgkXyR
         tTszaRet/32FKWAOP68gHXMEnM0RUgOXzVIL5Sds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.151
Date:   Fri, 28 Oct 2022 14:01:56 +0200
Message-Id: <1666958516101237@kroah.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.151 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                |    5 ++++-
 scripts/link-vmlinux.sh |    2 +-
 scripts/pahole-flags.sh |   21 +++++++++++++++++++++
 3 files changed, 26 insertions(+), 2 deletions(-)

Andrii Nakryiko (1):
      kbuild: skip per-CPU BTF generation for pahole v1.18-v1.21

Greg Kroah-Hartman (1):
      Linux 5.10.151

Ilya Leoshkevich (1):
      bpf: Generate BTF_KIND_FLOAT when linking vmlinux

Javier Martinez Canillas (1):
      kbuild: Quote OBJCOPY var to avoid a pahole call break the build

Jiri Olsa (1):
      kbuild: Unify options for BTF generation for vmlinux and modules

Martin Rodriguez Reboredo (1):
      kbuild: Add skip_encoding_btf_enum64 option to pahole

