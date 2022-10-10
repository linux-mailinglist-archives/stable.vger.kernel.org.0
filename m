Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 840F05F9947
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbiJJHK1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231787AbiJJHJm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:09:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2A135AA1B;
        Mon, 10 Oct 2022 00:06:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF6B7B80E28;
        Mon, 10 Oct 2022 07:06:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21BD3C433D7;
        Mon, 10 Oct 2022 07:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665385576;
        bh=7a+WTDLovQeSm3K4+3q8ZCqpy2ODJ1EzuBZHDte6j3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EYpqd0whFwcd1py+589OmwLBxkGb43PY8cOmb7DIlOFjhO2eTimcXBeULaAhjBiLQ
         3jJME4O7Q1/0lMMYasAFSQlD+XzzrZ75rDV9618jelTljFrJoYg4fDUaqjvXiGnV1O
         Lg9Ayb+hd2rxkUCb8X6Hi8xx5ocxBF6R6ylqvrto=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 5.19 04/48] docs: update mediator information in CoC docs
Date:   Mon, 10 Oct 2022 09:05:02 +0200
Message-Id: <20221010070333.808349023@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221010070333.676316214@linuxfoundation.org>
References: <20221010070333.676316214@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuah Khan <skhan@linuxfoundation.org>

commit 8bfdfa0d6b929ede7b6189e0e546ceb6a124d05d upstream.

Update mediator information in the CoC interpretation document.

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/20220901212319.56644-1-skhan@linuxfoundation.org
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/process/code-of-conduct-interpretation.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/process/code-of-conduct-interpretation.rst
+++ b/Documentation/process/code-of-conduct-interpretation.rst
@@ -51,7 +51,7 @@ the Technical Advisory Board (TAB) or ot
 uncertain how to handle situations that come up.  It will not be
 considered a violation report unless you want it to be.  If you are
 uncertain about approaching the TAB or any other maintainers, please
-reach out to our conflict mediator, Mishi Choudhary <mishi@linux.com>.
+reach out to our conflict mediator, Joanna Lee <joanna.lee@gesmer.com>.
 
 In the end, "be kind to each other" is really what the end goal is for
 everybody.  We know everyone is human and we all fail at times, but the


