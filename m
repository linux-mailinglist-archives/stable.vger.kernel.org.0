Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7883E5444B2
	for <lists+stable@lfdr.de>; Thu,  9 Jun 2022 09:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232315AbiFIHWt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jun 2022 03:22:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238500AbiFIHWs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jun 2022 03:22:48 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EFA226F375
        for <stable@vger.kernel.org>; Thu,  9 Jun 2022 00:22:46 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 2A27A1FD80;
        Thu,  9 Jun 2022 07:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654759365; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=QsIOHpvbIhIWIOwUiUmFpgIeGL3aVFpY5f3iHNjsB7Y=;
        b=PrG6DVPQUQO1gIYEUAMrkpsa0ROaF4pet5EKXFPiNp29gvdzdHXAmCp2eNM12b3ebGyx7f
        oFWNIImorTr0E62TSdIGyJ7aE7pkV1jF0hV2dcD8lqN0lPwbxE9JpEGc/7OFUNgQJh7w18
        EwujAd4CrijbHyuYeRY6Z6aFA7WtSGo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654759365;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=QsIOHpvbIhIWIOwUiUmFpgIeGL3aVFpY5f3iHNjsB7Y=;
        b=PXqovXV0/34KTYyQg1avgQSimQpgv2xbGc+SHI8i6DZgWPScbvYefOmtZjgnntvFWq6loE
        Emg6dzt6xr/Le9Cw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EBDA513456;
        Thu,  9 Jun 2022 07:22:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 9yTnOMSfoWLYMAAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Thu, 09 Jun 2022 07:22:44 +0000
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     airlied@redhat.com, kuohsiang_chou@aspeedtech.com,
        jfalempe@redhat.com
Cc:     stable@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 0/1] For stable: "drm/ast: Create threshold values for AST2600"
Date:   Thu,  9 Jun 2022 09:22:41 +0200
Message-Id: <20220609072242.11721-1-tzimmermann@suse.de>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Mainline commit bcc77411e8a6 ("drm/ast: Create threshold values for
AST2600") needs backporting into older Linux kernels. The earliest
affected version is v5.11.

KuoHsiang Chou (1):
  drm/ast: Create threshold values for AST2600

 drivers/gpu/drm/ast/ast_mode.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

-- 
2.36.1

