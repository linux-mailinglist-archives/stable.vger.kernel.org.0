Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC2E34F2FA3
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356094AbiDEKW4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233807AbiDEJae (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:30:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1A19E33BE;
        Tue,  5 Apr 2022 02:17:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8189C615E4;
        Tue,  5 Apr 2022 09:17:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C645C385A2;
        Tue,  5 Apr 2022 09:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150234;
        bh=Rd5nw3jDuLAv2KMmI7ewgk5evQITYPwffFCbrPD6p1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CEXkkkF3W0id0wwM+ItvQfrmtNEVccg02ucFGkddmBjyDKtycWpAFB4a6HE5WYzJo
         oE28YAAQ6XgUFh05xUHB3DatrY92pT3fBMLhJVSNh9IxL9lF5zpXq2WKSE049CJMCK
         7RMkXJGnNdI3Eb65z5aS44Yqj8KM8tkrQffqvZMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wan Jiabing <wanjiabing@vivo.com>,
        Xin Long <lucien.xin@gmail.com>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.16 0964/1017] docs: fix make htmldocs warning in SCTP.rst
Date:   Tue,  5 Apr 2022 09:31:17 +0200
Message-Id: <20220405070422.821445685@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Wan Jiabing <wanjiabing@vivo.com>

commit 70868c6b8fd80db585da57a264c50a69af8fd3c3 upstream.

Fix following 'make htmldocs' warnings:
./Documentation/security/SCTP.rst:123: WARNING: Title underline too short.
security_sctp_assoc_established()
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
./Documentation/security/SCTP.rst:123: WARNING: Title underline too short.
security_sctp_assoc_established()
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
./Documentation/security/SCTP.rst:273: WARNING: Title underline too short.
security_sctp_assoc_established()
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
./Documentation/security/SCTP.rst:273: WARNING: Title underline too short.
security_sctp_assoc_established()
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fixes: 5e50f5d4ff31 ("security: add sctp_assoc_established hook")
Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/security/SCTP.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/security/SCTP.rst
+++ b/Documentation/security/SCTP.rst
@@ -120,7 +120,7 @@ calls **sctp_peeloff**\(3).
 
 
 security_sctp_assoc_established()
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 Called when a COOKIE ACK is received, and the peer secid will be
 saved into ``@asoc->peer_secid`` for client::
 
@@ -270,7 +270,7 @@ sockets sid and peer sid to that contain
 
 
 security_sctp_assoc_established()
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 Called when a COOKIE ACK is received where it sets the connection's peer sid
 to that in ``@skb``::
 


