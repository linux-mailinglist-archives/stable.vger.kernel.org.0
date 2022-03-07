Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADE044CF902
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239549AbiCGKDW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:03:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240334AbiCGKA5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:00:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B173DBC8D;
        Mon,  7 Mar 2022 01:47:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C6DBB810A8;
        Mon,  7 Mar 2022 09:47:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE60AC340E9;
        Mon,  7 Mar 2022 09:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646450;
        bh=LBCgfJ6j5OyTUdvOgCcaMFIDfUpGnacIwThK4ySYF2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ej0pkxmWqYrsgU07UAkMYJzCq8iis0h0i9oazl60WtibcN+3GiVXrSX0pFJQBYxbw
         NZ5MyuIlGYZEych5ZF8KhFTi9RhSb/zeFFe5ruaAbHtT5k7vlD4mGWoKOP1jgIUbrb
         cYfUGaTOkFcX8ZGqUYLXEC0G4Lsyj1dKksYVHfrw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 246/262] MAINTAINERS: adjust file entry for of_net.c after movement
Date:   Mon,  7 Mar 2022 10:19:50 +0100
Message-Id: <20220307091710.482828222@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Bulwahn <lukas.bulwahn@gmail.com>

commit f616447034a120b18f6e612814641e7d8f5d7f0a upstream.

Commit e330fb14590c ("of: net: move of_net under net/") moves of_net.c
to ./net/core/, but misses to adjust the reference to this file in
MAINTAINERS.

Hence, ./scripts/get_maintainer.pl --self-test=patterns complains:

   warning: no file matches    F:    drivers/of/of_net.c

Adjust the file entry after this file movement.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Link: https://lore.kernel.org/r/20211016055815.14397-1-lukas.bulwahn@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7024,7 +7024,6 @@ F:	drivers/net/mdio/fwnode_mdio.c
 F:	drivers/net/mdio/of_mdio.c
 F:	drivers/net/pcs/
 F:	drivers/net/phy/
-F:	drivers/of/of_net.c
 F:	include/dt-bindings/net/qca-ar803x.h
 F:	include/linux/*mdio*.h
 F:	include/linux/mdio/*.h
@@ -7036,6 +7035,7 @@ F:	include/linux/platform_data/mdio-gpio
 F:	include/trace/events/mdio.h
 F:	include/uapi/linux/mdio.h
 F:	include/uapi/linux/mii.h
+F:	net/core/of_net.c
 
 EXFAT FILE SYSTEM
 M:	Namjae Jeon <linkinjeon@kernel.org>


