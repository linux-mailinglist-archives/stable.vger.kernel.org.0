Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E37374F24DB
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbiDEHlr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:41:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231794AbiDEHll (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:41:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B52494CD49;
        Tue,  5 Apr 2022 00:39:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E72E6123C;
        Tue,  5 Apr 2022 07:39:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17D64C340EE;
        Tue,  5 Apr 2022 07:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144381;
        bh=z0MZUq/cr6LSD5n9+SgDZwG8ExGGT+HKRqHuTFk8Ndk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dkHoZNoKgcQUo9fzQ4jqf7I0KqdaE/IJqvS2zRRzEZ7n1x27pGSQZzuEwNdwlRoVJ
         0kU2fMyKdfU4m4amL+xKBYrcRgBtqYC1eCvIWN+6qWQR+PxKD4opD6A6kFUfGk+0t7
         aWRt8OeQ8vS2JmPhn/YCuzEhMWlrXA21wYP6hdlM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Akira Yokosawa <akiyks@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 5.17 0025/1126] docs: sphinx/requirements: Limit jinja2<3.1
Date:   Tue,  5 Apr 2022 09:12:52 +0200
Message-Id: <20220405070408.287710659@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Akira Yokosawa <akiyks@gmail.com>

commit be78837ca3c88eebd405103a7a2ce891c466b0db upstream.

jinja2 release 3.1.0 (March 24, 2022) broke Sphinx<4.0.
This looks like the result of deprecating Python 3.6.
It has been tested against Sphinx 4.3.0 and later.

Setting an upper limit of <3.1 to junja2 can unbreak Sphinx<4.0
including Sphinx 2.4.4.

Signed-off-by: Akira Yokosawa <akiyks@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: stable@vger.kernel.org # v5.15+
Link: https://lore.kernel.org/r/7dbff8a0-f4ff-34a0-71c7-1987baf471f9@gmail.com
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/sphinx/requirements.txt |    2 ++
 1 file changed, 2 insertions(+)

--- a/Documentation/sphinx/requirements.txt
+++ b/Documentation/sphinx/requirements.txt
@@ -1,2 +1,4 @@
+# jinja2>=3.1 is not compatible with Sphinx<4.0
+jinja2<3.1
 sphinx_rtd_theme
 Sphinx==2.4.4


