Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 093A34AFD30
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 20:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233430AbiBITRo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 14:17:44 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:51196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233404AbiBITRn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 14:17:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E1BC02B666;
        Wed,  9 Feb 2022 11:17:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1C0BB82386;
        Wed,  9 Feb 2022 19:15:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF80C340E7;
        Wed,  9 Feb 2022 19:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644434118;
        bh=JL1ZzQGS2DZRWorzqG+KWGB2TtceOBYLScub9lmpXW8=;
        h=From:To:Cc:Subject:Date:From;
        b=bS0FEbVQ3jfRbQvziuPJANTXAMWkOo4/ypcvEuDT8C+oX3siiqsbBvrwUqtGBVp76
         9TrBuV3mN6bmsJ78MQ94ys8dHHQrSnKOt0Gi+t8zBC9FkF2kFwqYmmr1Fg6Qs9PfzC
         17MFfTh+jTZBTCbv357tmIEOjHjWdnLF2pmXKZVA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.4 0/1] 5.4.179-rc1 review
Date:   Wed,  9 Feb 2022 20:14:09 +0100
Message-Id: <20220209191248.688351316@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.179-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.179-rc1
X-KernelTest-Deadline: 2022-02-11T19:12+00:00
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

This is the start of the stable review cycle for the 5.4.179 release.
There are 1 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 11 Feb 2022 19:12:41 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.179-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.179-rc1

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    moxart: fix potential use-after-free on remove path


-------------

Diffstat:

 Makefile                      | 4 ++--
 drivers/mmc/host/moxart-mmc.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)


