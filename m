Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2B64F324B
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343644AbiDEI5T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234136AbiDEIiS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:38:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25E41D0DD;
        Tue,  5 Apr 2022 01:32:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8CDE4B81B13;
        Tue,  5 Apr 2022 08:32:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04390C385A0;
        Tue,  5 Apr 2022 08:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147567;
        bh=z0MZUq/cr6LSD5n9+SgDZwG8ExGGT+HKRqHuTFk8Ndk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z/K4k+WR7ftFSqRKhU9WNBRTIuMRPwCw8OBnF6+tnWBS0YCj9Wzl0b4WoFCEyHxLl
         FMcZts4yaUM4OqiuByzqrU0Gn6g3y0AC3hjcS8VzMRyJYJq/3/sbzlnNxE0zwgmzhO
         GBlzKpHS9engaOPWQghYOJM0YYroepon7bXv+hVw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Akira Yokosawa <akiyks@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 5.16 0043/1017] docs: sphinx/requirements: Limit jinja2<3.1
Date:   Tue,  5 Apr 2022 09:15:56 +0200
Message-Id: <20220405070355.460162240@linuxfoundation.org>
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


